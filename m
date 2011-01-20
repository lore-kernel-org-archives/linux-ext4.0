From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Thu, 20 Jan 2011 19:50:57 +0100
Message-ID: <20110120185057.GA4701@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
 <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
 <20110113074603.GC27381@tux1.beaverton.ibm.com>
 <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
 <20110115173211.GC27123@htj.dyndns.org>
 <AANLkTi=MiY+GMXRwfOMhEzGQC3=F89FOKAJ4y1hvyDG0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
	Theodore Ts'o <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1ATSwV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jan 2011 13:52:21 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=MiY+GMXRwfOMhEzGQC3=F89FOKAJ4y1hvyDG0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Tue, Jan 18, 2011 at 09:12:55AM +0800, Shaohua Li wrote:
> This makes sense. would it possible N flush data payloads delay the
> first request?

I ended up with a different design.  Still buggy.  It triggers a weird
oops under stress test but other than that things generally seem to
work as expected.  Please read the comment at the top of blk-flush.c
for more info.  I'll post properly after more testing and debugging.

Thanks.

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -149,39 +149,29 @@ EXPORT_SYMBOL(blk_rq_init);
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
-	struct request_queue *q = rq->q;
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
 
-	if (&q->flush_rq != rq) {
-		if (error)
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-			error = -EIO;
-
-		if (unlikely(nbytes > bio->bi_size)) {
-			printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-			       __func__, nbytes, bio->bi_size);
-			nbytes = bio->bi_size;
-		}
+	if (unlikely(nbytes > bio->bi_size)) {
+		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
+		       __func__, nbytes, bio->bi_size);
+		nbytes = bio->bi_size;
+	}
 
-		if (unlikely(rq->cmd_flags & REQ_QUIET))
-			set_bit(BIO_QUIET, &bio->bi_flags);
+	if (unlikely(rq->cmd_flags & REQ_QUIET))
+		set_bit(BIO_QUIET, &bio->bi_flags);
 
-		bio->bi_size -= nbytes;
-		bio->bi_sector += (nbytes >> 9);
+	bio->bi_size -= nbytes;
+	bio->bi_sector += (nbytes >> 9);
 
-		if (bio_integrity(bio))
-			bio_integrity_advance(bio, nbytes);
+	if (bio_integrity(bio))
+		bio_integrity_advance(bio, nbytes);
 
-		if (bio->bi_size == 0)
-			bio_endio(bio, error);
-	} else {
-		/*
-		 * Okay, this is the sequenced flush request in
-		 * progress, just record the error;
-		 */
-		if (error && !q->flush_err)
-			q->flush_err = error;
-	}
+	/* don't actually finish bio if it's part of flush sequence */
+	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+		bio_endio(bio, error);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -540,7 +530,9 @@ struct request_queue *blk_alloc_queue_no
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
-	INIT_LIST_HEAD(&q->pending_flushes);
+	INIT_LIST_HEAD(&q->flush_queue[0]);
+	INIT_LIST_HEAD(&q->flush_queue[1]);
+	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_WORK(&q->unplug_work, blk_unplug_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -1219,7 +1211,7 @@ static int __make_request(struct request
 	spin_lock_irq(q->queue_lock);
 
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
-		where = ELEVATOR_INSERT_FRONT;
+		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
 	}
 
@@ -1804,7 +1796,7 @@ static void blk_account_io_done(struct r
 	 * normal IO on queueing nor completion.  Accounting the
 	 * containing request is enough.
 	 */
-	if (blk_do_io_stat(req) && req != &req->q->flush_rq) {
+	if (blk_do_io_stat(req) && !(req->cmd_flags & REQ_FLUSH_SEQ)) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
Index: work/block/blk-flush.c
===================================================================
--- work.orig/block/blk-flush.c
+++ work/block/blk-flush.c
@@ -1,6 +1,66 @@
 /*
  * Functions to sequence FLUSH and FUA writes.
+ *
+ * Copyright (C) 2011		Max Planck Institute for Gravitational Physics
+ * Copyright (C) 2011		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * REQ_{FLUSH|FUA} requests are decomposed to sequences composed of three
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
+ * data or executed as normal requests.
+ *
+ * If the device has writeback cache and supports FUA, REQ_FLUSH is
+ * translated to PREFLUSH but REQ_FUA is passed down directly with the data
+ * request.
+ *
+ * If the device has writeback cache and doesn't support FUA, REQ_FLUSH is
+ * translated to PREFLUSH and REQ_FUA to POSTFLUSH.
+ *
+ * The actual execution of flush is double buffered.  Whenever a request
+ * needs to execute PRE or POSTFLUSH, it queues at
+ * q->flush_queue[q->flush_pending_idx].  Once certain criteria are met,
+ * flush is issued and pending_idx is toggled.  When the flush completes,
+ * all the requests which were pending are proceeded to the next step.
+ * This allows near optimal merging of flush requests.
+ *
+ * Currently, the following conditions are used to determine when to issue
+ * flush.
+ *
+ * C1. At any given time, only one flush shall be in progress.  This makes
+ *     double buffering sufficient.
+ *
+ * C2. Flush is not deferred if any request is executing the data part of
+ *     its sequence.  This avoids issuing separate POSTFLUSHes for requests
+ *     which shared PREFLUSH.
+ *
+ * C3. The second condition is ignored if there is a request which has
+ *     waited longer than FLUSH_PENDING_TIMEOUT.  This is to avoid
+ *     starvation in the unlikely case where there are continuous stream of
+ *     FUA (without FLUSH) requests.
+ *
+ * Note that a sequenced FLUSH/FUA request with data is completed twice.
+ * Once while executing the data part and again after the whole sequence is
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
@@ -11,184 +71,289 @@
 
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
+ * %true if a request was added to the dispatch queue, %false otherwise.
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
+	bool was_empty = elv_queue_empty(rq->q);
 
-static void post_flush_end_io(struct request *rq, int error)
-{
-	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	/* after populating an empty queue, kick it to avoid stall */
+	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error) && was_empty)
+		__blk_run_queue(rq->q);
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
 
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-	return rq;
+	/*
+	 * @rq should go through flush machinery.  Mark it part of flush
+	 * sequence and submit for further processing.
+	 */
+	memset(&rq->flush, 0, sizeof(rq->flush));
+	INIT_LIST_HEAD(&rq->flush.list);
+	rq->cmd_flags |= REQ_FLUSH_SEQ;
+	rq->end_io = flush_data_end_io;
+
+	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
-struct request *blk_do_flush(struct request_queue *q, struct request *rq)
+/**
+ * blk_abort_flush - @q is being aborted, abort flush requests
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
-			    rq == &q->flush_rq)
-				return rq;
-			rq = blk_do_flush(q, rq);
-			if (rq)
-				return rq;
+			return rq;
 		}
 
 		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
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
@@ -103,9 +103,15 @@ struct request {
 	 */
 	union {
 		struct rb_node rb_node;	/* sort/lookup */
-		void *completion_data;
+		struct {
+			unsigned int			serial;
+			unsigned int			seq;
+			struct list_head		list;
+		} flush;
 	};
 
+	void *completion_data;
+
 	/*
 	 * Three pointers are available for the IO schedulers, if they need
 	 * more they have to dynamically allocate it.
@@ -363,11 +369,12 @@ struct request_queue
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
 
Index: work/include/linux/blk_types.h
===================================================================
--- work.orig/include/linux/blk_types.h
+++ work/include/linux/blk_types.h
@@ -148,6 +148,7 @@ enum rq_flag_bits {
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_FLUSH,		/* request for cache flush */
+	__REQ_FLUSH_SEQ,	/* request for flush sequence */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
@@ -188,6 +189,7 @@ enum rq_flag_bits {
 #define REQ_ALLOCED		(1 << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1 << __REQ_COPY_USER)
 #define REQ_FLUSH		(1 << __REQ_FLUSH)
+#define REQ_FLUSH_SEQ		(1 << __REQ_FLUSH_SEQ)
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
 #define REQ_SECURE		(1 << __REQ_SECURE)
