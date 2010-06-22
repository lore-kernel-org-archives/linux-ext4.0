From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Tue, 22 Jun 2010 17:35:00 -0400
Message-ID: <1277242502-9047-2-git-send-email-jmoyer@redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, vgoyal@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch implements a blk_yield to allow a process to voluntarily
give up its I/O scheduler time slice.  This is desirable for those processes
which know that they will be blocked on I/O from another process, such as
the file system journal thread.  Following patches will put calls to blk_yield
into jbd and jbd2.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-core.c         |   13 +++++
 block/blk-settings.c     |    6 ++
 block/cfq-iosched.c      |  123 +++++++++++++++++++++++++++++++++++++++++++++-
 block/elevator.c         |    8 +++
 include/linux/blkdev.h   |    4 ++
 include/linux/elevator.h |    3 +
 6 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..b9afbba 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -324,6 +324,18 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
+void generic_yield_iosched(struct request_queue *q, struct task_struct *tsk)
+{
+	elv_yield(q, tsk);
+}
+
+void blk_yield(struct request_queue *q, struct task_struct *tsk)
+{
+	if (q->yield_fn)
+		q->yield_fn(q, tsk);
+}
+EXPORT_SYMBOL(blk_yield);
+
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -609,6 +621,7 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
+	q->yield_fn		= generic_yield_iosched;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f5ed5a1..fe548c9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -171,6 +171,12 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 }
 EXPORT_SYMBOL(blk_queue_make_request);
 
+void blk_queue_yield(struct request_queue *q, yield_fn *yield)
+{
+	q->yield_fn = yield;
+}
+EXPORT_SYMBOL_GPL(blk_queue_yield);
+
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dab836e..a9922b9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -87,9 +87,12 @@ struct cfq_rb_root {
 	unsigned total_weight;
 	u64 min_vdisktime;
 	struct rb_node *active;
+	unsigned long last_expiry;
+	pid_t last_pid;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
-			.count = 0, .min_vdisktime = 0, }
+			.count = 0, .min_vdisktime = 0, .last_expiry = 0UL, \
+			.last_pid = (pid_t)-1, }
 
 /*
  * Per process-grouping structure
@@ -147,6 +150,7 @@ struct cfq_queue {
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
+	struct cfq_io_context *yield_to;
 };
 
 /*
@@ -318,6 +322,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
+	CFQ_CFQQ_FLAG_yield,		/* Allow another cfqq to run */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -347,6 +352,7 @@ CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
+CFQ_CFQQ_FNS(yield);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1614,6 +1620,15 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
 
+	if (!cfq_cfqq_yield(cfqq)) {
+		struct cfq_rb_root *st;
+		st = service_tree_for(cfqq->cfqg,
+				      cfqq_prio(cfqq), cfqq_type(cfqq));
+		st->last_expiry = jiffies;
+		st->last_pid = cfqq->pid;
+	}
+	cfq_clear_cfqq_yield(cfqq);
+
 	/*
 	 * If this cfqq is shared between multiple processes, check to
 	 * make sure that those processes are still issuing I/Os within
@@ -2118,7 +2133,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
-	cfq_log(cfqd, "workload slice:%d", slice);
+	cfq_log(cfqd, "workload:%d slice:%d", cfqd->serving_type, slice);
 	cfqd->workload_expires = jiffies + slice;
 	cfqd->noidle_tree_requires_idle = false;
 }
@@ -2153,6 +2168,36 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	choose_service_tree(cfqd, cfqg);
 }
 
+static int cfq_should_yield_now(struct cfq_queue *cfqq,
+				struct cfq_queue **yield_to)
+{
+	struct cfq_queue *new_cfqq;
+
+	new_cfqq = cic_to_cfqq(cfqq->yield_to, 1);
+
+	/*
+	 * If the queue we're yielding to is in a different cgroup,
+	 * just expire our own time slice.
+	 */
+	if (new_cfqq->cfqg != cfqq->cfqg) {
+		*yield_to = NULL;
+		return 1;
+	}
+
+	/*
+	 * If the new queue has pending I/O, then switch to it
+	 * immediately.  Otherwise, see if we can idle until it is
+	 * ready to preempt us.
+	 */
+	if (!RB_EMPTY_ROOT(&new_cfqq->sort_list)) {
+		*yield_to = new_cfqq;
+		return 1;
+	}
+
+	*yield_to = NULL;
+	return 0;
+}
+
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -2187,6 +2232,10 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		 * have been idling all along on this queue and it should be
 		 * ok to wait for this request to complete.
 		 */
+		if (cfq_cfqq_yield(cfqq) &&
+		    cfq_should_yield_now(cfqq, &new_cfqq))
+			goto expire;
+
 		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
 		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 			cfqq = NULL;
@@ -2215,6 +2264,9 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto expire;
 	}
 
+	if (cfq_cfqq_yield(cfqq) && cfq_should_yield_now(cfqq, &new_cfqq))
+		goto expire;
+
 	/*
 	 * No requests pending. If the active queue still has requests in
 	 * flight or is idling for a new request, allow either of these
@@ -2241,6 +2293,65 @@ keep_queue:
 	return cfqq;
 }
 
+static inline int expiry_data_valid(struct cfq_rb_root *service_tree)
+{
+	return (service_tree->last_pid != (pid_t)-1 &&
+		service_tree->last_expiry != 0UL);
+}
+
+static void cfq_yield(struct request_queue *q, struct task_struct *tsk)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_io_context *cic, *new_cic;
+	struct cfq_queue *cfqq;
+
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return;
+
+	task_lock(tsk);
+	new_cic = cfq_cic_lookup(cfqd, tsk->io_context);
+	atomic_long_inc(&tsk->io_context->refcount);
+	task_unlock(tsk);
+	if (!new_cic)
+		goto out_dec;
+
+	spin_lock_irq(q->queue_lock);
+
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq)
+		goto out_unlock;
+
+	/*
+	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
+	 * are idling on the last queue in that workload, *and* there are no
+	 * potential dependent readers running currently, then go ahead and
+	 * yield the queue.
+	 */
+	if (cfqd->active_queue == cfqq &&
+	    cfqd->serving_type == SYNC_NOIDLE_WORKLOAD) {
+		/*
+		 * If there's been no I/O from another process in the idle
+		 * slice time, then there is by definition no dependent
+		 * read going on for this service tree.
+		 */
+		if (expiry_data_valid(cfqq->service_tree) &&
+		    time_before(cfqq->service_tree->last_expiry +
+				cfq_slice_idle, jiffies) &&
+		    cfqq->service_tree->last_pid != cfqq->pid)
+			goto out_unlock;
+	}
+
+	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
+	cfqq->yield_to = new_cic;
+	cfq_mark_cfqq_yield(cfqq);
+
+out_unlock:
+	spin_unlock_irq(q->queue_lock);
+out_dec:
+	put_io_context(tsk->io_context);
+}
+
 static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 {
 	int dispatched = 0;
@@ -3123,6 +3234,13 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (!cfqq)
 		return false;
 
+	/*
+	 * If the active queue yielded its timeslice to this queue, let
+	 * it preempt.
+	 */
+	if (cfq_cfqq_yield(cfqq) && RQ_CIC(rq) == cfqq->yield_to)
+		return true;
+
 	if (cfq_class_idle(new_cfqq))
 		return false;
 
@@ -3973,6 +4091,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
 		.elevator_queue_empty_fn =	cfq_queue_empty,
 		.elevator_completed_req_fn =	cfq_completed_request,
+		.elevator_yield_fn =		cfq_yield,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
diff --git a/block/elevator.c b/block/elevator.c
index 923a913..5e33297 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -866,6 +866,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	}
 }
 
+void elv_yield(struct request_queue *q, struct task_struct *tsk)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e && e->ops->elevator_yield_fn)
+		e->ops->elevator_yield_fn(q, tsk);
+}
+
 #define to_elv(atr) container_of((atr), struct elv_fs_entry, attr)
 
 static ssize_t
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..8d073c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -263,6 +263,7 @@ struct request_pm_state
 
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef void (yield_fn) (struct request_queue *q, struct task_struct *tsk);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
 
@@ -345,6 +346,7 @@ struct request_queue
 
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
+	yield_fn		*yield_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
@@ -837,6 +839,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 extern void blk_unplug(struct request_queue *q);
+extern void blk_yield(struct request_queue *q, struct task_struct *tsk);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
@@ -929,6 +932,7 @@ extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 						      request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
+extern void blk_queue_yield(struct request_queue *, yield_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 2c958f4..a68b5b1 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -23,6 +23,7 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
+typedef void (elevator_yield_fn) (struct request_queue *, struct task_struct *tsk);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
@@ -48,6 +49,7 @@ struct elevator_ops
 
 	elevator_queue_empty_fn *elevator_queue_empty_fn;
 	elevator_completed_req_fn *elevator_completed_req_fn;
+	elevator_yield_fn *elevator_yield_fn;
 
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
@@ -111,6 +113,7 @@ extern void elv_bio_merged(struct request_queue *q, struct request *,
 				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
+extern void elv_yield(struct request_queue *, struct task_struct *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
-- 
1.6.5.2
