From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/4] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Tue, 18 May 2010 14:20:18 -0400
Message-ID: <1274206820-17071-3-git-send-email-jmoyer@redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, jens.axboe@oracle.com,
	vgoyal@redhat.com, Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
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
 block/blk-settings.c     |    6 +++
 block/cfq-iosched.c      |  112 +++++++++++++++++++++++++++++++++++++++++++++-
 block/elevator.c         |    8 +++
 include/linux/blkdev.h   |    4 ++
 include/linux/elevator.h |    3 +
 6 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..b8be6c8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -323,6 +323,18 @@ void blk_unplug(struct request_queue *q)
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
@@ -580,6 +592,7 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
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
index 46a7fe5..9aab701 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -148,6 +148,7 @@ struct cfq_queue {
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
+	struct cfq_io_context *yield_to;
 	/* Sectors dispatched in current dispatch round */
 	unsigned long nr_sectors;
 };
@@ -320,6 +321,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
+	CFQ_CFQQ_FLAG_yield,		/* Allow another cfqq to run */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -349,6 +351,7 @@ CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
+CFQ_CFQQ_FNS(yield);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_DEBUG_CFQ_IOSCHED
@@ -1566,6 +1569,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
+	cfq_clear_cfqq_yield(cfqq);
 
 	/*
 	 * If this cfqq is shared between multiple processes, check to
@@ -2068,7 +2072,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
-	cfq_log(cfqd, "workload slice:%d", slice);
+	cfq_log(cfqd, "workload:%d slice:%d", cfqd->serving_type, slice);
 	cfqd->workload_expires = jiffies + slice;
 	cfqd->noidle_tree_requires_idle = false;
 }
@@ -2138,7 +2142,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		 * ok to wait for this request to complete.
 		 */
 		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
-		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
+		    && cfqq->dispatched && !cfq_cfqq_yield(cfqq) &&
+		    cfq_should_idle(cfqd, cfqq)) {
 			cfqq = NULL;
 			goto keep_queue;
 		} else
@@ -2165,6 +2170,9 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto expire;
 	}
 
+	if (cfq_cfqq_yield(cfqq))
+		goto expire;
+
 	/*
 	 * No requests pending. If the active queue still has requests in
 	 * flight or is idling for a new request, allow either of these
@@ -2191,6 +2199,98 @@ keep_queue:
 	return cfqq;
 }
 
+static void cfq_yield(struct request_queue *q, struct task_struct *tsk)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_io_context *cic, *new_cic;
+	struct cfq_queue *cfqq, *sync_cfqq, *async_cfqq, *new_cfqq;
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
+	/*
+	 * This is primarily called to ensure that the long synchronous
+	 * time slice does not prevent other I/O happenning (like journal
+	 * commits) while we idle waiting for it.  Thus, check to see if the
+	 * current cfqq is the sync cfqq for this process.
+	 */
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq)
+		goto out_unlock;
+
+	if (cfqd->active_queue != cfqq)
+		goto out_unlock;
+
+	sync_cfqq = cic_to_cfqq(new_cic, 1);
+	async_cfqq = cic_to_cfqq(new_cic, 0);
+	if (!sync_cfqq && !async_cfqq)
+		goto out_unlock;
+	if (!RB_EMPTY_ROOT(&sync_cfqq->sort_list))
+		new_cfqq = sync_cfqq;
+	else
+		new_cfqq = async_cfqq;
+
+	/*
+	 * If we are currently servicing the SYNC_NOIDLE_WORKLOAD, and we
+	 * are idling on the last queue in that workload, *and* the average
+	 * think time is larger thank the remaining slice time, go ahead
+	 * and yield the queue.  Otherwise, don't yield so that fsync-heavy
+	 * workloads don't starve out the sync-noidle workload.
+	 */
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
+	    (!sample_valid(cfqq->service_tree->ttime_samples) ||
+	     cfqq->slice_end - jiffies > cfqq->service_tree->ttime_mean)) {
+		/*
+		 * If there's only a single sync-noidle queue on average,
+		 * there's no point in idling in order to not starve the
+		 * non-existent other queues.
+		 */
+		if (cfq_group_busy_queues_wl(SYNC_NOIDLE_WORKLOAD, cfqd,
+					     cfqq->cfqg) > 1)
+			goto out_unlock;
+	}
+
+	cfq_log_cfqq(cfqd, cfqq, "yielding queue");
+
+	/*
+	 * If there are other requests pending, just mark the queue as
+	 * yielding and give up our slice after the last request is
+	 * dispatched.  Or, if there are no requests currently pending
+	 * on the selected queue, keep our time slice until such a time
+	 * as the new queue has something to do.  It will then preempt
+	 * this queue (see cfq_should_preempt).
+	 */
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list) ||
+	    RB_EMPTY_ROOT(&new_cfqq->sort_list)) {
+		cfqq->yield_to = new_cic;
+		cfq_mark_cfqq_yield(cfqq);
+		goto out_unlock;
+	}
+
+	/*
+	 * At this point, we know that the target queue has requests pending.
+	 * Yield the io scheduler.
+	 */
+	__cfq_slice_expired(cfqd, cfqq, 1);
+	__cfq_set_active_queue(cfqd, new_cfqq);
+	__blk_run_queue(cfqd->queue);
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
@@ -3094,6 +3194,13 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
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
 
@@ -3910,6 +4017,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
 		.elevator_queue_empty_fn =	cfq_queue_empty,
 		.elevator_completed_req_fn =	cfq_completed_request,
+		.elevator_yield_fn =		cfq_yield,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
diff --git a/block/elevator.c b/block/elevator.c
index 76e3702..3af7796 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -855,6 +855,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
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
index 6690e8b..1099d29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -259,6 +259,7 @@ struct request_pm_state
 
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef void (yield_fn) (struct request_queue *q, struct task_struct *tsk);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
 
@@ -341,6 +342,7 @@ struct request_queue
 
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
+	yield_fn		*yield_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
@@ -833,6 +835,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 extern void blk_unplug(struct request_queue *q);
+extern void blk_yield(struct request_queue *q, struct task_struct *tsk);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
@@ -920,6 +923,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
+extern void blk_queue_yield(struct request_queue *, yield_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1cb3372..a5aaee9 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -20,6 +20,7 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
+typedef void (elevator_yield_fn) (struct request_queue *, struct task_struct *tsk);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
@@ -44,6 +45,7 @@ struct elevator_ops
 
 	elevator_queue_empty_fn *elevator_queue_empty_fn;
 	elevator_completed_req_fn *elevator_completed_req_fn;
+	elevator_yield_fn *elevator_yield_fn;
 
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
@@ -105,6 +107,7 @@ extern void elv_merge_requests(struct request_queue *, struct request *,
 extern void elv_merged_request(struct request_queue *, struct request *, int);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
+extern void elv_yield(struct request_queue *, struct task_struct *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
-- 
1.6.5.2
