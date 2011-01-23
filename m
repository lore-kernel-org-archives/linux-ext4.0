From: Tejun Heo <tj@kernel.org>
Subject: [PATCH UPDATED 3/3] block: reimplement FLUSH/FUA to support merge
Date: Sun, 23 Jan 2011 11:48:15 +0100
Message-ID: <20110123104815.GD23121@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34777 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1AWKsW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jan 2011 05:48:22 -0500
Content-Disposition: inline
In-Reply-To: <1295625598-15203-4-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current FLUSH/FUA support has evolved from the implementation
which had to perform queue draining.  As such, sequencing is done
queue-wide one flush request after another.  However, with the
draining requirement gone, there's no reason to keep the queue-wide
sequential approach.

This patch reimplements FLUSH/FUA support such that each FLUSH/FUA
request is sequenced individually.  The actual FLUSH execution is
double buffered and whenever a request wants to execute one for either
PRE or POSTFLUSH, it queues on the pending queue.  Once certain
conditions are met, a flush request is issued and on its completion
all pending requests proceed to the next sequence.

This allows arbitrary merging of different type of flushes.  How they
are merged can be primarily controlled and tuned by adjusting the
above said 'conditions' used to determine when to issue the next
flush.

This is inspired by Darrick's patches to merge multiple zero-data
flushes which helps workloads with highly concurrent fsync requests.

* As flush requests are never put on the IO scheduler, request fields
  used for flush share space with rq->rb_node.  rq->completion_data is
  moved out of the union.  This increases the request size by one
  pointer.

  As rq->elevator_private* are used only by the iosched too, it is
  possible to reduce the request size further.  However, to do that,
  we need to modify request allocation path such that iosched data is
  not allocated for flush requests.

* FLUSH/FUA processing happens on insertion now instead of dispatch.

- Comments updated as per Vivek and Mike.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
Simple comment update.  Nothing else changed.  Git tree is updated
too.

Thanks.

 block/blk-core.c         |   10 -
 block/blk-flush.c        |  432 ++++++++++++++++++++++++++++++++---------------
 block/blk.h              |   12 -
 block/elevator.c         |    7 
 include/linux/blkdev.h   |   18 +
 include/linux/elevator.h |    1 
 6 files changed, 328 insertions(+), 152 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -149,8 +149,6 @@ EXPORT_SYMBOL(blk_rq_init);
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
-	struct request_queue *q = rq->q;
-
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
@@ -174,8 +172,6 @@ static void req_bio_endio(struct request
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
 		bio_endio(bio, error);
-	else if (error && !q->flush_err)
-		q->flush_err = error;
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -534,7 +530,9 @@ struct request_queue *blk_alloc_queue_no
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
-	INIT_LIST_HEAD(&q->pending_flushes);
+	INIT_LIST_HEAD(&q->flush_queue[0]);
+	INIT_LIST_HEAD(&q->flush_queue[1]);
+	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1213,7 +1211,7 @@ static int __make_request(struct request
 	spin_lock_irq(q->queue_lock);
 
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
-		where = ELEVATOR_INSERT_FRONT;
+		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
 	}
 
Index: work/block/blk-flush.c
===================================================================
--- work.orig/block/blk-flush.c
+++ work/block/blk-flush.c
@@ -1,6 +1,69 @@
 /*
  * Functions to sequence FLUSH and FUA writes.
+ *
+ * Copyright (C) 2011		Max Planck Institute for Gravitational Physics
+ * Copyright (C) 2011		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * REQ_{FLUSH|FUA} requests are decomposed to sequences consisted of three
+ * optional steps - PREFLUSH, DATA and POSTFLUSH - according to the request
+ * properties and hardware capability.
+ *
+ * If a request doesn't have data, only REQ_FLUSH makes sense, which
+ * indicates a simple flush request.  If there is data, REQ_FLUSH indicates
+ * that the device cache should be flushed before the data is executed, and
+ * REQ_FUA means that the data must be on non-volatile media on request
+ * completion.
+ *
+ * If the device doesn't have writeback cache, FLUSH and FUA don't make any
+ * difference.  The requests are either completed immediately if there's no
+ * data or executed as normal requests otherwise.
+ *
+ * If the device has writeback cache and supports FUA, REQ_FLUSH is
+ * translated to PREFLUSH but REQ_FUA is passed down directly with DATA.
+ *
+ * If the device has writeback cache and doesn't support FUA, REQ_FLUSH is
+ * translated to PREFLUSH and REQ_FUA to POSTFLUSH.
+ *
+ * The actual execution of flush is double buffered.  Whenever a request
+ * needs to execute PRE or POSTFLUSH, it queues at
+ * q->flush_queue[q->flush_pending_idx].  Once certain criteria are met, a
+ * flush is issued and the pending_idx is toggled.  When the flush
+ * completes, all the requests which were pending are proceeded to the next
+ * step.  This allows arbitrary merging of different types of FLUSH/FUA
+ * requests.
+ *
+ * Currently, the following conditions are used to determine when to issue
+ * flush.
+ *
+ * C1. At any given time, only one flush shall be in progress.  This makes
+ *     double buffering sufficient.
+ *
+ * C2. Flush is deferred if any request is executing DATA of its sequence.
+ *     This avoids issuing separate POSTFLUSHes for requests which shared
+ *     PREFLUSH.
+ *
+ * C3. The second condition is ignored if there is a request which has
+ *     waited longer than FLUSH_PENDING_TIMEOUT.  This is to avoid
+ *     starvation in the unlikely case where there are continuous stream of
+ *     FUA (without FLUSH) requests.
+ *
+ * For devices which support FUA, it isn't clear whether C2 (and thus C3)
+ * is beneficial.
+ *
+ * Note that a sequenced FLUSH/FUA request with DATA is completed twice.
+ * Once while executing DATA and again after the whole sequence is
+ * complete.  The first completion updates the contained bio but doesn't
+ * finish it so that the bio submitter is notified only after the whole
+ * sequence is complete.  This is implemented by testing REQ_FLUSH_SEQ in
+ * req_bio_endio().
+ *
+ * The above peculiarity requires that each FLUSH/FUA request has only one
+ * bio attached to it, which is guaranteed as they aren't allowed to be
+ * merged in the usual way.
  */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bio.h>
@@ -11,185 +74,290 @@
 
 /* FLUSH/FUA sequences */
 enum {
-	QUEUE_FSEQ_STARTED	= (1 << 0), /* flushing in progress */
-	QUEUE_FSEQ_PREFLUSH	= (1 << 1), /* pre-flushing in progress */
-	QUEUE_FSEQ_DATA		= (1 << 2), /* data write in progress */
-	QUEUE_FSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
-	QUEUE_FSEQ_DONE		= (1 << 4),
+	REQ_FSEQ_PREFLUSH	= (1 << 0), /* pre-flushing in progress */
+	REQ_FSEQ_DATA		= (1 << 1), /* data write in progress */
+	REQ_FSEQ_POSTFLUSH	= (1 << 2), /* post-flushing in progress */
+	REQ_FSEQ_DONE		= (1 << 3),
+
+	REQ_FSEQ_ACTIONS	= REQ_FSEQ_PREFLUSH | REQ_FSEQ_DATA |
+				  REQ_FSEQ_POSTFLUSH,
+
+	/*
+	 * If flush has been pending longer than the following timeout,
+	 * it's issued even if flush_data requests are still in flight.
+	 */
+	FLUSH_PENDING_TIMEOUT	= 5 * HZ,
 };
 
-static struct request *queue_next_fseq(struct request_queue *q);
+static bool blk_kick_flush(struct request_queue *q);
 
-unsigned blk_flush_cur_seq(struct request_queue *q)
+static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
-	if (!q->flush_seq)
-		return 0;
-	return 1 << ffz(q->flush_seq);
+	unsigned int policy = 0;
+
+	if (fflags & REQ_FLUSH) {
+		if (rq->cmd_flags & REQ_FLUSH)
+			policy |= REQ_FSEQ_PREFLUSH;
+		if (blk_rq_sectors(rq))
+			policy |= REQ_FSEQ_DATA;
+		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
+			policy |= REQ_FSEQ_POSTFLUSH;
+	}
+	return policy;
 }
 
-static struct request *blk_flush_complete_seq(struct request_queue *q,
-					      unsigned seq, int error)
+static unsigned int blk_flush_cur_seq(struct request *rq)
 {
-	struct request *next_rq = NULL;
+	return 1 << ffz(rq->flush.seq);
+}
 
-	if (error && !q->flush_err)
-		q->flush_err = error;
+static void blk_flush_restore_request(struct request *rq)
+{
+	/*
+	 * After flush data completion, @rq->bio is %NULL but we need to
+	 * complete the bio again.  @rq->biotail is guaranteed to equal the
+	 * original @rq->bio.  Restore it.
+	 */
+	rq->bio = rq->biotail;
 
-	BUG_ON(q->flush_seq & seq);
-	q->flush_seq |= seq;
+	/* make @rq a normal request */
+	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
+	rq->end_io = NULL;
+}
 
-	if (blk_flush_cur_seq(q) != QUEUE_FSEQ_DONE) {
-		/* not complete yet, queue the next flush sequence */
-		next_rq = queue_next_fseq(q);
-	} else {
-		/* complete this flush request */
-		__blk_end_request_all(q->orig_flush_rq, q->flush_err);
-		q->orig_flush_rq = NULL;
-		q->flush_seq = 0;
+/**
+ * blk_flush_complete_seq - complete flush sequence
+ * @rq: FLUSH/FUA request being sequenced
+ * @seq: sequences to complete (mask of %REQ_FSEQ_*, can be zero)
+ * @error: whether an error occurred
+ *
+ * @rq just completed @seq part of its flush sequence, record the
+ * completion and trigger the next step.
+ *
+ * CONTEXT:
+ * spin_lock_irq(q->queue_lock)
+ *
+ * RETURNS:
+ * %true if requests were added to the dispatch queue, %false otherwise.
+ */
+static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
+				   int error)
+{
+	struct request_queue *q = rq->q;
+	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	bool queued = false;
+
+	BUG_ON(rq->flush.seq & seq);
+	rq->flush.seq |= seq;
+
+	if (likely(!error))
+		seq = blk_flush_cur_seq(rq);
+	else
+		seq = REQ_FSEQ_DONE;
+
+	switch (seq) {
+	case REQ_FSEQ_PREFLUSH:
+	case REQ_FSEQ_POSTFLUSH:
+		/* queue for flush */
+		if (list_empty(pending))
+			q->flush_pending_since = jiffies;
+		list_move_tail(&rq->flush.list, pending);
+		break;
 
-		/* dispatch the next flush if there's one */
-		if (!list_empty(&q->pending_flushes)) {
-			next_rq = list_entry_rq(q->pending_flushes.next);
-			list_move(&next_rq->queuelist, &q->queue_head);
-		}
+	case REQ_FSEQ_DATA:
+		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
+		list_add(&rq->queuelist, &q->queue_head);
+		queued = true;
+		break;
+
+	case REQ_FSEQ_DONE:
+		/*
+		 * @rq was previously adjusted by blk_flush_issue() for
+		 * flush sequencing and may already have gone through the
+		 * flush data request completion path.  Restore @rq for
+		 * normal completion and end it.
+		 */
+		BUG_ON(!list_empty(&rq->queuelist));
+		list_del_init(&rq->flush.list);
+		blk_flush_restore_request(rq);
+		__blk_end_request_all(rq, error);
+		break;
+
+	default:
+		BUG();
 	}
-	return next_rq;
+
+	return blk_kick_flush(q) | queued;
 }
 
-static void blk_flush_complete_seq_end_io(struct request_queue *q,
-					  unsigned seq, int error)
+static void flush_end_io(struct request *flush_rq, int error)
 {
+	struct request_queue *q = flush_rq->q;
+	struct list_head *running = &q->flush_queue[q->flush_running_idx];
 	bool was_empty = elv_queue_empty(q);
-	struct request *next_rq;
+	bool queued = false;
+	struct request *rq, *n;
 
-	next_rq = blk_flush_complete_seq(q, seq, error);
+	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
-	/*
-	 * Moving a request silently to empty queue_head may stall the
-	 * queue.  Kick the queue in those cases.
-	 */
-	if (was_empty && next_rq)
+	/* account completion of the flush request */
+	q->flush_running_idx ^= 1;
+	elv_completed_request(q, flush_rq);
+
+	/* and push the waiting requests to the next stage */
+	list_for_each_entry_safe(rq, n, running, flush.list) {
+		unsigned int seq = blk_flush_cur_seq(rq);
+
+		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
+		queued |= blk_flush_complete_seq(rq, seq, error);
+	}
+
+	/* after populating an empty queue, kick it to avoid stall */
+	if (queued && was_empty)
 		__blk_run_queue(q);
 }
 
-static void pre_flush_end_io(struct request *rq, int error)
+/**
+ * blk_kick_flush - consider issuing flush request
+ * @q: request_queue being kicked
+ *
+ * Flush related states of @q have changed, consider issuing flush request.
+ * Please read the comment at the top of this file for more info.
+ *
+ * CONTEXT:
+ * spin_lock_irq(q->queue_lock)
+ *
+ * RETURNS:
+ * %true if flush was issued, %false otherwise.
+ */
+static bool blk_kick_flush(struct request_queue *q)
 {
-	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct request *first_rq =
+		list_first_entry(pending, struct request, flush.list);
+
+	/* C1 described at the top of this file */
+	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
+		return false;
+
+	/* C2 and C3 */
+	if (!list_empty(&q->flush_data_in_flight) &&
+	    time_before(jiffies,
+			q->flush_pending_since + FLUSH_PENDING_TIMEOUT))
+		return false;
+
+	/*
+	 * Issue flush and toggle pending_idx.  This makes pending_idx
+	 * different from running_idx, which means flush is in flight.
+	 */
+	blk_rq_init(q, &q->flush_rq);
+	q->flush_rq.cmd_type = REQ_TYPE_FS;
+	q->flush_rq.cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	q->flush_rq.rq_disk = first_rq->rq_disk;
+	q->flush_rq.end_io = flush_end_io;
+
+	q->flush_pending_idx ^= 1;
+	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_FRONT);
+	return true;
 }
 
 static void flush_data_end_io(struct request *rq, int error)
 {
-	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
-}
+	struct request_queue *q = rq->q;
+	bool was_empty = elv_queue_empty(q);
 
-static void post_flush_end_io(struct request *rq, int error)
-{
-	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	/* after populating an empty queue, kick it to avoid stall */
+	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error) && was_empty)
+		__blk_run_queue(q);
 }
 
-static void init_flush_request(struct request *rq, struct gendisk *disk)
+/**
+ * blk_insert_flush - insert a new FLUSH/FUA request
+ * @rq: request to insert
+ *
+ * To be called from elv_insert() for %ELEVATOR_INSERT_FLUSH insertions.
+ * @rq is being submitted.  Analyze what needs to be done and put it on the
+ * right queue.
+ *
+ * CONTEXT:
+ * spin_lock_irq(q->queue_lock)
+ */
+void blk_insert_flush(struct request *rq)
 {
-	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = WRITE_FLUSH;
-	rq->rq_disk = disk;
-}
+	struct request_queue *q = rq->q;
+	unsigned int fflags = q->flush_flags;	/* may change, cache */
+	unsigned int policy = blk_flush_policy(fflags, rq);
 
-static struct request *queue_next_fseq(struct request_queue *q)
-{
-	struct request *orig_rq = q->orig_flush_rq;
-	struct request *rq = &q->flush_rq;
+	BUG_ON(rq->end_io);
+	BUG_ON(!rq->bio || rq->bio != rq->biotail);
 
-	blk_rq_init(q, rq);
+	/*
+	 * @policy now records what operations need to be done.  Adjust
+	 * REQ_FLUSH and FUA for the driver.
+	 */
+	rq->cmd_flags &= ~REQ_FLUSH;
+	if (!(fflags & REQ_FUA))
+		rq->cmd_flags &= ~REQ_FUA;
 
-	switch (blk_flush_cur_seq(q)) {
-	case QUEUE_FSEQ_PREFLUSH:
-		init_flush_request(rq, orig_rq->rq_disk);
-		rq->end_io = pre_flush_end_io;
-		break;
-	case QUEUE_FSEQ_DATA:
-		init_request_from_bio(rq, orig_rq->bio);
-		/*
-		 * orig_rq->rq_disk may be different from
-		 * bio->bi_bdev->bd_disk if orig_rq got here through
-		 * remapping drivers.  Make sure rq->rq_disk points
-		 * to the same one as orig_rq.
-		 */
-		rq->rq_disk = orig_rq->rq_disk;
-		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
-		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
-		rq->end_io = flush_data_end_io;
-		break;
-	case QUEUE_FSEQ_POSTFLUSH:
-		init_flush_request(rq, orig_rq->rq_disk);
-		rq->end_io = post_flush_end_io;
-		break;
-	default:
-		BUG();
+	/*
+	 * If there's data but flush is not necessary, the request can be
+	 * processed directly without going through flush machinery.  Queue
+	 * for normal execution.
+	 */
+	if ((policy & REQ_FSEQ_DATA) &&
+	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
+		list_add(&rq->queuelist, &q->queue_head);
+		return;
 	}
 
+	/*
+	 * @rq should go through flush machinery.  Mark it part of flush
+	 * sequence and submit for further processing.
+	 */
+	memset(&rq->flush, 0, sizeof(rq->flush));
+	INIT_LIST_HEAD(&rq->flush.list);
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-	return rq;
+	rq->end_io = flush_data_end_io;
+
+	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
-struct request *blk_do_flush(struct request_queue *q, struct request *rq)
+/**
+ * blk_abort_flushes - @q is being aborted, abort flush requests
+ * @q: request_queue being aborted
+ *
+ * To be called from elv_abort_queue().  @q is being aborted.  Prepare all
+ * FLUSH/FUA requests for abortion.
+ *
+ * CONTEXT:
+ * spin_lock_irq(q->queue_lock)
+ */
+void blk_abort_flushes(struct request_queue *q)
 {
-	unsigned int fflags = q->flush_flags; /* may change, cache it */
-	bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
-	bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
-	bool do_postflush = has_flush && !has_fua && (rq->cmd_flags & REQ_FUA);
-	unsigned skip = 0;
+	struct request *rq, *n;
+	int i;
 
 	/*
-	 * Special case.  If there's data but flush is not necessary,
-	 * the request can be issued directly.
-	 *
-	 * Flush w/o data should be able to be issued directly too but
-	 * currently some drivers assume that rq->bio contains
-	 * non-zero data if it isn't NULL and empty FLUSH requests
-	 * getting here usually have bio's without data.
+	 * Requests in flight for data are already owned by the dispatch
+	 * queue or the device driver.  Just restore for normal completion.
 	 */
-	if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
-		rq->cmd_flags &= ~REQ_FLUSH;
-		if (!has_fua)
-			rq->cmd_flags &= ~REQ_FUA;
-		return rq;
+	list_for_each_entry_safe(rq, n, &q->flush_data_in_flight, flush.list) {
+		list_del_init(&rq->flush.list);
+		blk_flush_restore_request(rq);
 	}
 
 	/*
-	 * Sequenced flushes can't be processed in parallel.  If
-	 * another one is already in progress, queue for later
-	 * processing.
+	 * We need to give away requests on flush queues.  Restore for
+	 * normal completion and put them on the dispatch queue.
 	 */
-	if (q->flush_seq) {
-		list_move_tail(&rq->queuelist, &q->pending_flushes);
-		return NULL;
+	for (i = 0; i < ARRAY_SIZE(q->flush_queue); i++) {
+		list_for_each_entry_safe(rq, n, &q->flush_queue[i],
+					 flush.list) {
+			list_del_init(&rq->flush.list);
+			blk_flush_restore_request(rq);
+			list_add_tail(&rq->queuelist, &q->queue_head);
+		}
 	}
-
-	/*
-	 * Start a new flush sequence
-	 */
-	q->flush_err = 0;
-	q->flush_seq |= QUEUE_FSEQ_STARTED;
-
-	/* adjust FLUSH/FUA of the original request and stash it away */
-	rq->cmd_flags &= ~REQ_FLUSH;
-	if (!has_fua)
-		rq->cmd_flags &= ~REQ_FUA;
-	blk_dequeue_request(rq);
-	q->orig_flush_rq = rq;
-
-	/* skip unneded sequences and return the first one */
-	if (!do_preflush)
-		skip |= QUEUE_FSEQ_PREFLUSH;
-	if (!blk_rq_sectors(rq))
-		skip |= QUEUE_FSEQ_DATA;
-	if (!do_postflush)
-		skip |= QUEUE_FSEQ_POSTFLUSH;
-	return blk_flush_complete_seq(q, skip, 0);
 }
 
 static void bio_end_flush(struct bio *bio, int err)
Index: work/block/elevator.c
===================================================================
--- work.orig/block/elevator.c
+++ work/block/elevator.c
@@ -673,6 +673,11 @@ void elv_insert(struct request_queue *q,
 		q->elevator->ops->elevator_add_req_fn(q, rq);
 		break;
 
+	case ELEVATOR_INSERT_FLUSH:
+		rq->cmd_flags |= REQ_SOFTBARRIER;
+		blk_insert_flush(rq);
+		break;
+
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
 		       __func__, where);
@@ -785,6 +790,8 @@ void elv_abort_queue(struct request_queu
 {
 	struct request *rq;
 
+	blk_abort_flushes(q);
+
 	while (!list_empty(&q->queue_head)) {
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
Index: work/include/linux/elevator.h
===================================================================
--- work.orig/include/linux/elevator.h
+++ work/include/linux/elevator.h
@@ -167,6 +167,7 @@ extern struct request *elv_rb_find(struc
 #define ELEVATOR_INSERT_BACK	2
 #define ELEVATOR_INSERT_SORT	3
 #define ELEVATOR_INSERT_REQUEUE	4
+#define ELEVATOR_INSERT_FLUSH	5
 
 /*
  * return values from elevator_may_queue_fn
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -99,13 +99,18 @@ struct request {
 	/*
 	 * The rb_node is only used inside the io scheduler, requests
 	 * are pruned when moved to the dispatch queue. So let the
-	 * completion_data share space with the rb_node.
+	 * flush fields share space with the rb_node.
 	 */
 	union {
 		struct rb_node rb_node;	/* sort/lookup */
-		void *completion_data;
+		struct {
+			unsigned int			seq;
+			struct list_head		list;
+		} flush;
 	};
 
+	void *completion_data;
+
 	/*
 	 * Three pointers are available for the IO schedulers, if they need
 	 * more they have to dynamically allocate it.
@@ -363,11 +368,12 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
-	unsigned int		flush_seq;
-	int			flush_err;
+	unsigned int		flush_pending_idx:1;
+	unsigned int		flush_running_idx:1;
+	unsigned long		flush_pending_since;
+	struct list_head	flush_queue[2];
+	struct list_head	flush_data_in_flight;
 	struct request		flush_rq;
-	struct request		*orig_flush_rq;
-	struct list_head	pending_flushes;
 
 	struct mutex		sysfs_lock;
 
Index: work/block/blk.h
===================================================================
--- work.orig/block/blk.h
+++ work/block/blk.h
@@ -51,21 +51,17 @@ static inline void blk_clear_rq_complete
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-struct request *blk_do_flush(struct request_queue *q, struct request *rq);
+void blk_insert_flush(struct request *rq);
+void blk_abort_flushes(struct request_queue *q);
 
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
 
 	while (1) {
-		while (!list_empty(&q->queue_head)) {
+		if (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
-			if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
-			    (rq->cmd_flags & REQ_FLUSH_SEQ))
-				return rq;
-			rq = blk_do_flush(q, rq);
-			if (rq)
-				return rq;
+			return rq;
 		}
 
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
