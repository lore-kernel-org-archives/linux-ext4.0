From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/6] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Fri,  2 Jul 2010 15:58:14 -0400
Message-ID: <1278100699-24132-2-git-send-email-jmoyer@redhat.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch implements a blk_yield function to allow a process to voluntarily
give up its I/O scheduler time slice.  This is desirable for those processes
which know that they will be blocked on I/O from another process, such as
the file system journal thread.  The yield call works by causing the target
process to issue I/O in the context of the cfqq of the calling process.
Following patches will put calls to blk_yield into jbd and jbd2.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-core.c          |   24 +++++++
 block/blk-ioc.c           |    1 +
 block/blk-settings.c      |    6 ++
 block/cfq-iosched.c       |  147 +++++++++++++++++++++++++++++++++++++++++++-
 block/elevator.c          |   15 +++++
 include/linux/blkdev.h    |    4 +
 include/linux/elevator.h  |    3 +
 include/linux/iocontext.h |    3 +
 8 files changed, 199 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..e9530eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -324,6 +324,29 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
+static void generic_yield_iosched(struct request_queue *q,
+				  struct task_struct *tsk)
+{
+	elv_yield(q, tsk);
+}
+
+/**
+ * blk_yield()
+ * @q:		request_queue to which we're doing I/O
+ * @tsk:	task to which we're yielding the I/O scheduler
+ *
+ * This function should be called by code which knows that it is waiting
+ * on another thread to perform I/O in order for it to make progress.  By
+ * yielding the I/O scheduler, a potentially significant idling window can
+ * be bypassed, resulting in better latency and throughput.
+ */
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
@@ -609,6 +632,7 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
+	q->yield_fn		= generic_yield_iosched;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
 
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index d22c4c5..3a7b507 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -97,6 +97,7 @@ struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
+		ret->on_behalf_of = NULL;
 	}
 
 	return ret;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f5ed5a1..1353767 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -171,6 +171,12 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 }
 EXPORT_SYMBOL(blk_queue_make_request);
 
+void blk_queue_yield_set(struct request_queue *q, yield_fn *yield)
+{
+	q->yield_fn = yield;
+}
+EXPORT_SYMBOL_GPL(blk_queue_yield_set);
+
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dab836e..00b14d4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -87,9 +87,19 @@ struct cfq_rb_root {
 	unsigned total_weight;
 	u64 min_vdisktime;
 	struct rb_node *active;
+	/*
+	 * The following two fields are used only for the SYNC_NOIDLE
+	 * service tree.  Taken together, they are used to determine
+	 * whether or not there is currently a dependent reader doing
+	 * I/O on this service tree.  last_expiry records the last time
+	 * that a queue was expired in this service tree, and last_pid
+	 * tells which cfqq->pid it was that was expired.
+	 */
+	unsigned long last_expiry;
+	pid_t last_pid;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
-			.count = 0, .min_vdisktime = 0, }
+			.count = 0, .min_vdisktime = 0, .last_pid = (pid_t)-1, }
 
 /*
  * Per process-grouping structure
@@ -147,6 +157,7 @@ struct cfq_queue {
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
+	struct io_context *yield_to, *yield_from;
 };
 
 /*
@@ -318,6 +329,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
+	CFQ_CFQQ_FLAG_yield,		/* Allow another cfqq to run */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -347,6 +359,7 @@ CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
+CFQ_CFQQ_FNS(yield);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1594,6 +1607,9 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfq_mark_cfqq_slice_new(cfqq);
 
 		cfq_del_timer(cfqd, cfqq);
+
+		if (cfqq->yield_to)
+			cfqq->yield_to->on_behalf_of = cfqq->yield_from;
 	}
 
 	cfqd->active_queue = cfqq;
@@ -1614,6 +1630,18 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
 
+	if (cfq_cfqq_yield(cfqq)) {
+		if (cfqq->yield_to) {
+			cfqq->yield_to->on_behalf_of = NULL;
+			put_io_context(cfqq->yield_to);
+			cfqq->yield_to = cfqq->yield_from = NULL;
+		}
+		cfq_clear_cfqq_yield(cfqq);
+	} else {
+		cfqq->service_tree->last_expiry = jiffies;
+		cfqq->service_tree->last_pid = cfqq->pid;
+	}
+
 	/*
 	 * If this cfqq is shared between multiple processes, check to
 	 * make sure that those processes are still issuing I/Os within
@@ -2118,7 +2146,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
-	cfq_log(cfqd, "workload slice:%d", slice);
+	cfq_log(cfqd, "workload:%d slice:%d", cfqd->serving_type, slice);
 	cfqd->workload_expires = jiffies + slice;
 	cfqd->noidle_tree_requires_idle = false;
 }
@@ -2241,6 +2269,96 @@ keep_queue:
 	return cfqq;
 }
 
+static int expiry_data_valid(struct cfq_rb_root *service_tree)
+{
+	return (service_tree->last_pid != (pid_t)-1 &&
+		service_tree->last_expiry != 0UL);
+}
+
+static bool cfq_should_yield_now(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+
+	if (cfqq != cfqd->active_queue)
+		return false;
+
+	if (cfqd->serving_type != SYNC_NOIDLE_WORKLOAD)
+		return true;
+
+	/*
+	 * This is the sync-noidle workload.  If there is a dependent reader
+	 * executing now, then we should not allow yielding.
+	 */
+	if (expiry_data_valid(cfqq->service_tree) &&
+	    time_before(cfqq->service_tree->last_expiry +
+			cfq_slice_idle, jiffies) &&
+	    cfqq->service_tree->last_pid != cfqq->pid)
+		return false;
+
+	return true;
+}
+
+/*
+ * Explicitly give up this (sync) cfqq's time slice to the specified
+ * task.  This is currently used by the journal code when it is waiting
+ * on the jbd[2] thread to issue I/O on its behalf.
+ */
+static void cfq_yield(struct request_queue *q, struct task_struct *tsk)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_io_context *cic;
+	struct cfq_queue *cfqq;
+
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return;
+
+	spin_lock_irq(q->queue_lock);
+
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq) {
+		spin_unlock_irq(q->queue_lock);
+		return;
+	}
+
+	if (tsk) {
+		task_lock(tsk);
+		/*
+		 * If the task hasn't yet performed any I/O, then it
+		 * will have no io_context.  We can't create one for
+		 * another task, so just don't yield the queue in this
+		 * corner case.
+		 */
+		if (!tsk->io_context) {
+			task_unlock(tsk);
+			goto out_unlock;
+		}
+		atomic_long_inc(&tsk->io_context->refcount);
+		cfqq->yield_to = tsk->io_context;
+		cfqq->yield_from = current->io_context;
+		task_unlock(tsk);
+	} else {
+		if (cfq_should_yield_now(cfqd, cfqq)) {
+			__cfq_slice_expired(cfqd, cfqq, 0);
+			cfq_schedule_dispatch(cfqd);
+		} else
+			cfq_mark_cfqq_yield(cfqq);
+		goto out_unlock;
+	}
+
+	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
+	cfq_mark_cfqq_yield(cfqq);
+	if (cfqd->active_queue == cfqq)
+		tsk->io_context->on_behalf_of = current->io_context;
+
+	spin_unlock_irq(q->queue_lock);
+	return;
+
+out_unlock:
+	spin_unlock_irq(q->queue_lock);
+	if (tsk)
+		put_io_context(tsk->io_context);
+}
+
 static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 {
 	int dispatched = 0;
@@ -3010,6 +3128,13 @@ cfq_get_io_context(struct cfq_data *cfqd, gfp_t gfp_mask)
 	if (!ioc)
 		return NULL;
 
+	if (ioc->on_behalf_of) {
+		struct io_context *old_ioc = ioc;
+		ioc = ioc->on_behalf_of;
+		put_io_context(old_ioc);
+		atomic_long_inc(&ioc->refcount);
+	}
+
 	cic = cfq_cic_lookup(cfqd, ioc);
 	if (cic)
 		goto out;
@@ -3319,6 +3444,9 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;
 
+	if (cfq_cfqq_yield(cfqq))
+		return false;
+
 	if (cfq_slice_used(cfqq))
 		return true;
 
@@ -3401,7 +3529,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && cfqq_empty &&
-			 !cfq_close_cooperator(cfqd, cfqq)) {
+			 !cfq_close_cooperator(cfqd, cfqq) &&
+			 (!cfq_cfqq_yield(cfqq) ||
+			  (cfq_cfqq_yield(cfqq) && cfqq->yield_to))) {
+
 			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
 			/*
 			 * Idling is enabled for SYNC_WORKLOAD.
@@ -3548,7 +3679,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
 	const int rw = rq_data_dir(rq);
-	const bool is_sync = rq_is_sync(rq);
+	bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
 
@@ -3561,6 +3692,13 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	if (!cic)
 		goto queue_fail;
 
+	/*
+	 * If another process called blk_yield specifying us as the target,
+	 * then we issue I/O via their sync cfqq.
+	 */
+	if (current->io_context->on_behalf_of)
+		is_sync = 1;
+
 new_queue:
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
@@ -3973,6 +4111,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
 		.elevator_queue_empty_fn =	cfq_queue_empty,
 		.elevator_completed_req_fn =	cfq_completed_request,
+		.elevator_yield_fn =		cfq_yield,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
diff --git a/block/elevator.c b/block/elevator.c
index 923a913..aa3c326 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -866,6 +866,21 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	}
 }
 
+/**
+ * elv_yield() - explicitly give up the I/O scheduler
+ * @q:		request_queue for the device to which we're doing I/O
+ * @tsk:	task_struct of the process to which we're yielding
+ *
+ * This function abstracts out the I/O scheduler's yield function.
+ */
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
index 09a8402..ef2d10c 100644
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
+extern void blk_queue_yield_set(struct request_queue *, yield_fn *);
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
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 64d5291..1e3e578 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -54,6 +54,9 @@ struct io_context {
 	struct radix_tree_root radix_root;
 	struct hlist_head cic_list;
 	void *ioc_data;
+	/* set when another process has yielded its I/O scheduler slice to
+	 * this process */
+	struct io_context *on_behalf_of;
 };
 
 static inline struct io_context *ioc_task_link(struct io_context *ioc)
-- 
1.6.5.2
