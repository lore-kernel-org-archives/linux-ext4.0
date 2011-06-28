From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/3] block: Fix fsync slowness with CFQ cgroups
Date: Tue, 28 Jun 2011 17:20:27 -0400
Message-ID: <20110628212027.GD12949@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
 <4E09B457.9050800@parallels.com>
 <20110628134500.GD17552@redhat.com>
 <4E09E871.8040600@parallels.com>
 <20110628144744.GF17552@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jaxboe@fusionio.com" <jaxboe@fusionio.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1F1VUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 17:20:32 -0400
Content-Disposition: inline
In-Reply-To: <20110628144744.GF17552@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 10:47:44AM -0400, Vivek Goyal wrote:
[..]
> > >>         rcu_read_lock();
> > >>         if (task_blkio_cgroup(current) == task_blkio_cgroup(tsk))
> > >>-               return;
> > >>-       rcu_read_unlock();
> > >>+               goto out_unlock_rcu;
> > >>
> > >>         cic = cfq_cic_lookup(cfqd, current->io_context);
> > >>         if (!cic)
> > >>-               return;
> > >>+               goto out_unlock_rcu;
> > >
> > >You have done this change because you want to keep cfq_cic_lookup() also
> > >in rcu read side critical section? I am assuming that it works even
> > >without this. Though keeping it under rcu is probably more correct as
> > >cic objects are freed in rcu manner.
> > 
> > No, your just forgot to relese rcu in case task_blkio_cgroup(current) == task_blkio_cgroup(tsk)
> 
> Oh, that's right. Thanks for catching this. I will fix it.

Here is the fixed version of the patch. I am now calling rcu_read_unlock()
before returning if cgroups are same.

block: A new interface for specifying IO dependencing among tasks

This patch introduces two new block layer interfaces which allows file
systems to specify IO dependencies among processes. For example, fsync
process is dependent on IO completion from journallig thread in ext3
and ext4.

blk_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
blk_reset_depends_on_task(struct request_queue *q)

First one allows one to say that current process is dependent on
IO completions from "tsk". This call will let CFQ know abou the
dependency and CFQ will allow "tsk"'s IO to be dispatched in the
allocated time slice of calling process.

Once the dependency is over, one needs to tear down the mapping
by calling reset function.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c         |   42 ++++++++
 block/cfq-iosched.c      |  238 +++++++++++++++++++++++++++++++++++++++++++----
 block/elevator.c         |   16 +++
 include/linux/blkdev.h   |    8 +
 include/linux/elevator.h |    6 +
 5 files changed, 293 insertions(+), 17 deletions(-)

Index: linux-2.6-block/block/cfq-iosched.c
===================================================================
--- linux-2.6-block.orig/block/cfq-iosched.c	2011-06-28 16:32:45.672242961 -0400
+++ linux-2.6-block/block/cfq-iosched.c	2011-06-28 16:35:35.571928038 -0400
@@ -75,6 +75,8 @@ static DEFINE_IDA(cic_index_ida);
 #define sample_valid(samples)	((samples) > 80)
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
+static void cfq_put_request(struct request *rq);
+
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
  * if we cache the leftmost node we don't have to walk down the tree
@@ -148,6 +150,12 @@ struct cfq_queue {
 	struct cfq_group *cfqg;
 	/* Number of sectors dispatched from queue in single dispatch round */
 	unsigned long nr_sectors;
+
+	/*
+	 * This cfqq's further IO is dependent on other IO queued in other
+	 * cfqq pointed by dep_on_cfqq.
+	 */
+	struct cfq_queue *depends_on;
 };
 
 /*
@@ -447,7 +455,7 @@ static inline int cfqg_busy_async_queues
 		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
 }
 
-static void cfq_dispatch_insert(struct request_queue *, struct request *);
+static void cfq_dispatch_insert(struct request_queue *, struct request *, bool);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
@@ -2043,16 +2051,23 @@ static void cfq_arm_slice_timer(struct c
 
 /*
  * Move request from internal lists to the request queue dispatch list.
+ * @rq_dequeued: rq to be dispatched has already been removed from associated
+ * 	         cfqq. This is useful when rq from dependent queue is being
+ * 	         dispatched in current queue context.
  */
-static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
+static void cfq_dispatch_insert(struct request_queue *q, struct request *rq,
+			bool rq_dequeued)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatch_insert");
 
-	cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
-	cfq_remove_request(rq);
+	if (!rq_dequeued) {
+		cfqq->next_rq = cfq_find_next_rq(cfqd, cfqq, rq);
+		cfq_remove_request(rq);
+	}
+
 	cfqq->dispatched++;
 	(RQ_CFQG(rq))->dispatched++;
 	elv_dispatch_sort(q, rq);
@@ -2332,6 +2347,10 @@ static struct cfq_queue *cfq_select_queu
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto keep_queue;
 
+	/* There are reuquests in the cfqq we depend on. Allow dispatch */
+	if (cfqq->depends_on && !RB_EMPTY_ROOT(&cfqq->depends_on->sort_list))
+		goto keep_queue;
+
 	/*
 	 * If another queue has a request waiting within our mean seek
 	 * distance, let it run.  The expire code will check for close
@@ -2402,7 +2421,7 @@ static int __cfq_forced_dispatch_cfqq(st
 	int dispatched = 0;
 
 	while (cfqq->next_rq) {
-		cfq_dispatch_insert(cfqq->cfqd->queue, cfqq->next_rq);
+		cfq_dispatch_insert(cfqq->cfqd->queue, cfqq->next_rq, false);
 		dispatched++;
 	}
 
@@ -2534,6 +2553,77 @@ static bool cfq_may_dispatch(struct cfq_
 }
 
 /*
+ * This queue was not active and we might expire it becaue its request got
+ * dispatched in some other queue's context and it is an empty queue now
+ */
+static void
+cfq_expire_inactive_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	/*
+	 * If this cfqq is shared between multiple processes, check to
+	 * make sure that those processes are still issuing I/Os within
+	 * the mean seek distance.  If not, it may be time to break the
+	 * queues apart again.
+	 */
+	if (cfq_cfqq_coop(cfqq) && CFQQ_SEEKY(cfqq))
+		cfq_mark_cfqq_split_coop(cfqq);
+
+	cfq_del_cfqq_rr(cfqd, cfqq);
+}
+
+static void cfq_set_dispatch_dependent_request(struct cfq_data *cfqd,
+				struct cfq_queue *cfqq)
+{
+	struct cfq_queue *dep_cfqq;
+	int rw;
+	struct request *rq;
+
+	dep_cfqq = cfqq->depends_on;
+
+	cfq_log_cfqq(cfqd, cfqq, "dispatch from dependent"
+			" queue pid=%d\n", dep_cfqq->pid);
+	/*
+	 * Select a request from the queue we are dependent on. Dequeue
+	 * the request from other queue and make rq belong to this
+	 * queue and dispatch in this queue's context
+	 */
+	rq = cfq_check_fifo(dep_cfqq);
+	if (!rq)
+		rq = dep_cfqq->next_rq;
+	cfq_remove_request(rq);
+	if (RB_EMPTY_ROOT(&dep_cfqq->sort_list))
+		cfq_expire_inactive_queue(cfqd, dep_cfqq);
+	/*
+	 * Change the identity of request to belong to current cfqq
+	 * cfqg and cic. Drop references to old cfqq, cfqg and cic.
+	 */
+	cfqq->ref++;
+	rw = rq_data_dir(rq);
+	cfqq->allocated[rw]++;
+
+	/*
+	 * If we are here that means we are idling on the queue and we
+	 * must have dispatched atleast one request and that must have
+	 * set the cfqd->active_cic. Use that
+	 */
+	BUG_ON(!cfqd->active_cic);
+	atomic_long_inc(&cfqd->active_cic->ioc->refcount);
+
+	cfq_put_request(rq);
+
+	rq->elevator_private[0] = cfqd->active_cic;
+	rq->elevator_private[1] = cfqq;
+	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
+
+	if (cfq_cfqq_wait_request(cfqq))
+		cfq_del_timer(cfqd, cfqq);
+
+	cfq_clear_cfqq_wait_request(cfqq);
+
+	cfq_dispatch_insert(cfqd->queue, rq, true);
+}
+
+/*
  * Dispatch a request from cfqq, moving them to the request queue
  * dispatch list.
  */
@@ -2541,22 +2631,26 @@ static bool cfq_dispatch_request(struct 
 {
 	struct request *rq;
 
-	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
+	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list) && !cfqq->depends_on);
 
 	if (!cfq_may_dispatch(cfqd, cfqq))
 		return false;
 
-	/*
-	 * follow expired path, else get first next available
-	 */
-	rq = cfq_check_fifo(cfqq);
-	if (!rq)
-		rq = cfqq->next_rq;
+	if (RB_EMPTY_ROOT(&cfqq->sort_list))
+		cfq_set_dispatch_dependent_request(cfqd, cfqq);
+	else {
+		/*
+		 * follow expired path, else get first next available
+		 */
+		rq = cfq_check_fifo(cfqq);
+		if (!rq)
+			rq = cfqq->next_rq;
 
-	/*
-	 * insert request into driver dispatch list
-	 */
-	cfq_dispatch_insert(cfqd->queue, rq);
+		/*
+		 * insert request into driver dispatch list
+		 */
+		cfq_dispatch_insert(cfqd->queue, rq, false);
+	}
 
 	if (!cfqd->active_cic) {
 		struct cfq_io_context *cic = RQ_CIC(rq);
@@ -2640,6 +2734,11 @@ static void cfq_put_queue(struct cfq_que
 	}
 
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
+
+	/* This cfqq is going away. If there is a dependent queue, drop ref */
+	if (cfqq->depends_on)
+		cfq_put_queue(cfqq->depends_on);
+
 	kmem_cache_free(cfq_pool, cfqq);
 	cfq_put_cfqg(cfqg);
 }
@@ -3670,6 +3769,111 @@ static int cfq_may_queue(struct request_
 }
 
 /*
+ * Calling task depends on "tsk" for further IO. It is caller's responsibility
+ * to make sure tsk pointer is valid during the execution of call
+ */
+static void
+cfq_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
+{
+	struct cfq_io_context *cic, *tsk_cic;
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_queue *cfqq, *tsk_cfqq, *__cfqq;
+
+	if (unlikely(!tsk))
+		return;
+
+	if (!tsk->io_context || !current->io_context)
+		return;
+
+	/*
+	 * If two processes belong to same cgroup, no need to do this as
+	 * both journalling thread and fsync process will go on same
+	 * service tree and be able to preempt each other
+	 */
+	rcu_read_lock();
+	if (task_blkio_cgroup(current) == task_blkio_cgroup(tsk)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return;
+
+	task_lock(tsk);
+	spin_lock_irq(q->queue_lock);
+
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq)
+		goto out_unlock;
+
+	/* If cfqq already has a dependent queue, ignore this new queue */
+	if (cfqq->depends_on) {
+		cfq_log_cfqq(cfqd, cfqq, "depends on queue already set"
+			" old_pid=%d", cfqq->depends_on->pid);
+		goto out_unlock;
+	}
+
+	if (!tsk->io_context)
+		goto out_unlock;
+
+	tsk_cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	if (!tsk_cic)
+		goto out_unlock;
+
+	tsk_cfqq = cic_to_cfqq(tsk_cic, 1);
+
+	if (!tsk_cfqq)
+		goto out_unlock;
+
+	/* Don't allow circular dependency among a group of queues */
+	__cfqq = tsk_cfqq;
+
+	while((__cfqq = __cfqq->depends_on)) {
+		if (__cfqq  == cfqq)
+			goto out_unlock;
+	}
+
+	/* Take reference on tasks' cfqq */
+	tsk_cfqq->ref++;
+	cfqq->depends_on = tsk_cfqq;
+
+	cfq_log_cfqq(cfqd, cfqq, "set depends on queue pid= %d", tsk->pid);
+
+out_unlock:
+	spin_unlock_irq(q->queue_lock);
+	task_unlock(tsk);
+}
+
+static void cfq_reset_depends_on_task(struct request_queue *q)
+{
+	struct cfq_io_context *cic;
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_queue *cfqq;
+
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return;
+
+	spin_lock_irq(q->queue_lock);
+
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq || !cfqq->depends_on) {
+		spin_unlock_irq(q->queue_lock);
+		return;
+	}
+
+	cfq_log_cfqq(cfqd, cfqq, "reset depends on queue");
+
+	/* Drop refenrece on tasks's cfqq */
+	cfq_put_queue(cfqq->depends_on);
+	cfqq->depends_on = NULL;
+	spin_unlock_irq(q->queue_lock);
+
+}
+
+/*
  * queue lock held here
  */
 static void cfq_put_request(struct request *rq)
@@ -4206,6 +4410,8 @@ static struct elevator_type iosched_cfq 
 		.elevator_set_req_fn =		cfq_set_request,
 		.elevator_put_req_fn =		cfq_put_request,
 		.elevator_may_queue_fn =	cfq_may_queue,
+		.elevator_set_depends_on_task_fn = cfq_set_depends_on_task,
+		.elevator_reset_depends_on_task_fn = cfq_reset_depends_on_task,
 		.elevator_init_fn =		cfq_init_queue,
 		.elevator_exit_fn =		cfq_exit_queue,
 		.trim =				cfq_free_io_context,
Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c	2011-06-28 10:02:23.544839889 -0400
+++ linux-2.6-block/block/blk-core.c	2011-06-28 16:33:13.703491049 -0400
@@ -398,6 +398,19 @@ static int blk_init_free_list(struct req
 	return 0;
 }
 
+static void
+generic_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
+{
+	if (q->elevator)
+		elv_set_depends_on_task(q, tsk);
+}
+
+static void generic_reset_depends_on_task(struct request_queue *q)
+{
+	if (q->elevator)
+		elv_reset_depends_on_task(q);
+}
+
 struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 {
 	return blk_alloc_queue_node(gfp_mask, -1);
@@ -534,6 +547,8 @@ blk_init_allocated_queue_node(struct req
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
+	q->set_depends_on_task_fn	= generic_set_depends_on_task;
+	q->reset_depends_on_task_fn	= generic_reset_depends_on_task;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)
@@ -2766,6 +2781,33 @@ void blk_finish_plug(struct blk_plug *pl
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
+/*
+ * Give a hint to CFQ that current task is dependent on IO coming from
+ * "tsk". In such cases, CFQ will allow dispatch from "tsk" queue in
+ * the time slice of "current" process and this can cut down on
+ * unnecessarily queue idling.
+ *
+ * This function will return with interrupts disabled in case of CFQ.
+ * (task_lock()/task_unlock() pair).
+ */
+void blk_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
+{
+	if (q->set_depends_on_task_fn)
+		q->set_depends_on_task_fn(q, tsk);
+}
+EXPORT_SYMBOL(blk_set_depends_on_task);
+
+/*
+ * Tear down the any dependent task mapping previously set up by the current
+ * task.
+ */
+void blk_reset_depends_on_task(struct request_queue *q)
+{
+	if (q->reset_depends_on_task_fn)
+		q->reset_depends_on_task_fn(q);
+}
+EXPORT_SYMBOL(blk_reset_depends_on_task);
+
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
Index: linux-2.6-block/block/elevator.c
===================================================================
--- linux-2.6-block.orig/block/elevator.c	2011-06-28 16:32:45.673243005 -0400
+++ linux-2.6-block/block/elevator.c	2011-06-28 16:33:13.705491137 -0400
@@ -783,6 +783,22 @@ int elv_may_queue(struct request_queue *
 	return ELV_MQUEUE_MAY;
 }
 
+void elv_set_depends_on_task(struct request_queue *q, struct task_struct *tsk)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_set_depends_on_task_fn)
+		e->ops->elevator_set_depends_on_task_fn(q, tsk);
+}
+
+void elv_reset_depends_on_task(struct request_queue *q)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_reset_depends_on_task_fn)
+		e->ops->elevator_reset_depends_on_task_fn(q);
+}
+
 void elv_abort_queue(struct request_queue *q)
 {
 	struct request *rq;
Index: linux-2.6-block/include/linux/blkdev.h
===================================================================
--- linux-2.6-block.orig/include/linux/blkdev.h	2011-06-28 16:32:46.020258283 -0400
+++ linux-2.6-block/include/linux/blkdev.h	2011-06-28 16:33:13.706491181 -0400
@@ -209,6 +209,8 @@ typedef int (merge_bvec_fn) (struct requ
 typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
+typedef void (set_depends_on_task_fn) (struct request_queue *q, struct task_struct *tsk);
+typedef void (reset_depends_on_task_fn) (struct request_queue *q);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -283,7 +285,8 @@ struct request_queue
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
-
+	set_depends_on_task_fn	*set_depends_on_task_fn;
+	reset_depends_on_task_fn	*reset_depends_on_task_fn;
 	/*
 	 * Dispatch queue sorting
 	 */
@@ -895,6 +898,9 @@ static inline bool blk_needs_flush_plug(
 	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
 }
 
+extern void blk_set_depends_on_task(struct request_queue *q, struct task_struct *tsk);
+extern void blk_reset_depends_on_task(struct request_queue *q);
+
 /*
  * tag stuff
  */
Index: linux-2.6-block/include/linux/elevator.h
===================================================================
--- linux-2.6-block.orig/include/linux/elevator.h	2011-06-28 16:32:46.022258371 -0400
+++ linux-2.6-block/include/linux/elevator.h	2011-06-28 16:33:13.707491225 -0400
@@ -23,6 +23,8 @@ typedef void (elevator_add_req_fn) (stru
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef void (elevator_set_depends_on_task_fn) (struct request_queue *, struct task_struct *);
+typedef void (elevator_reset_depends_on_task_fn) (struct request_queue *);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
@@ -54,6 +56,8 @@ struct elevator_ops
 	elevator_put_req_fn *elevator_put_req_fn;
 
 	elevator_may_queue_fn *elevator_may_queue_fn;
+	elevator_set_depends_on_task_fn *elevator_set_depends_on_task_fn;
+	elevator_reset_depends_on_task_fn *elevator_reset_depends_on_task_fn;
 
 	elevator_init_fn *elevator_init_fn;
 	elevator_exit_fn *elevator_exit_fn;
@@ -114,6 +118,8 @@ extern struct request *elv_latter_reques
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
+extern void elv_set_depends_on_task(struct request_queue *q, struct task_struct *tsk);
+extern void elv_reset_depends_on_task(struct request_queue *q);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
