From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Sat, 15 Jan 2011 18:32:11 +0100
Message-ID: <20110115173211.GC27123@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
 <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
 <20110113074603.GC27381@tux1.beaverton.ibm.com>
 <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
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
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45570 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1AORcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Jan 2011 12:32:18 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Fri, Jan 14, 2011 at 09:00:22AM +0800, Shaohua Li wrote:
> it appears we can easily implement this in blk_do_flush, I had
> something at my hand too, passed test but no data yet.

> Task1: ...FS.....C
> Task2: ....F......S...C
> Task3: ......F.........S..C
> F means a flush is queued, S means a flush is dispatched, C means the flush
> is completed. In above, when Task2's flush is completed, we actually can
> make Task3 flush complete, as Task2's flush is dispatched after Task3's flush
> is queued. With the same reason, we can't merge Task2 and Task3's flush with
> Task1's.

I think this is the correct direction but we can take it further.  The
only thing block layer has to guarantee is (ignoring FUA support),

* If the flush request is empty, at least one flush is executed upon
  its completion.

* If the flush request is not empty, the payload is written only after
  a preceding flush and follwed by another flush if requested.

So, if we can combine N flushes with or without data,

 PREFLUSH -> N flush data payloads -> POSTFLUSH

The following is something I hacked past few hours.  I just made it
compile so it's definitely horridly broken.  Please don't try to even
test it, but it should still give an idea about the direction.  I'll
try to finish this early next week.

Thank you.

Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -54,9 +54,9 @@ static const int cfq_hist_divisor = 4;
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
 #define RQ_CIC(rq)		\
-	((struct cfq_io_context *) (rq)->elevator_private)
-#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private2)
-#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private3)
+	((struct cfq_io_context *) (rq)->elevator_private[0])
+#define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private[1])
+#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private[2])
 
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
@@ -3609,12 +3609,12 @@ static void cfq_put_request(struct reque
 
 		put_io_context(RQ_CIC(rq)->ioc);
 
-		rq->elevator_private = NULL;
-		rq->elevator_private2 = NULL;
+		rq->elevator_private[0] = NULL;
+		rq->elevator_private[1] = NULL;
 
 		/* Put down rq reference on cfqg */
 		cfq_put_cfqg(RQ_CFQG(rq));
-		rq->elevator_private3 = NULL;
+		rq->elevator_private[2] = NULL;
 
 		cfq_put_queue(cfqq);
 	}
@@ -3702,9 +3702,9 @@ new_queue:
 
 	cfqq->allocated[rw]++;
 	cfqq->ref++;
-	rq->elevator_private = cic;
-	rq->elevator_private2 = cfqq;
-	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elevator_private[0] = cic;
+	rq->elevator_private[1] = cfqq;
+	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
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
@@ -725,12 +730,15 @@ int elv_queue_empty(struct request_queue
 	struct elevator_queue *e = q->elevator;
 
 	if (!list_empty(&q->queue_head))
-		return 0;
+		return false;
+
+	if (!q->flush_seq && !list_empty(&q->pending_flushes))
+		return false;
 
 	if (e->ops->elevator_queue_empty_fn)
 		return e->ops->elevator_queue_empty_fn(q);
 
-	return 1;
+	return true;
 }
 EXPORT_SYMBOL(elv_queue_empty);
 
@@ -759,7 +767,7 @@ int elv_set_request(struct request_queue
 	if (e->ops->elevator_set_req_fn)
 		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
 
-	rq->elevator_private = NULL;
+	memset(rq->elevator_private, 0, sizeof(rq->elevator_private));
 	return 0;
 }
 
@@ -781,21 +789,25 @@ int elv_may_queue(struct request_queue *
 	return ELV_MQUEUE_MAY;
 }
 
+static void elv_abort_request(struct request_queue *q, struct request *rq)
+{
+	rq->cmd_flags |= REQ_QUIET;
+	trace_block_rq_abort(q, rq);
+	/*
+	 * Mark this request as started so we don't trigger any debug logic
+	 * in the end I/O path.
+	 */
+	blk_start_request(rq);
+	__blk_end_request_all(rq, -EIO);
+}
+
 void elv_abort_queue(struct request_queue *q)
 {
-	struct request *rq;
+	while (!list_empty(&q->queue_head))
+		elv_abort_request(q, list_entry_rq(q->queue_head.next));
 
-	while (!list_empty(&q->queue_head)) {
-		rq = list_entry_rq(q->queue_head.next);
-		rq->cmd_flags |= REQ_QUIET;
-		trace_block_rq_abort(q, rq);
-		/*
-		 * Mark this request as started so we don't trigger
-		 * any debug logic in the end I/O path.
-		 */
-		blk_start_request(rq);
-		__blk_end_request_all(rq, -EIO);
-	}
+	while (!list_empty(&q->pending_flushes))
+		elv_abort_request(q, list_entry_rq(q->queue_head.next));
 }
 EXPORT_SYMBOL(elv_abort_queue);
 
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -110,9 +110,10 @@ struct request {
 	 * Three pointers are available for the IO schedulers, if they need
 	 * more they have to dynamically allocate it.
 	 */
-	void *elevator_private;
-	void *elevator_private2;
-	void *elevator_private3;
+	union {
+		void *elevator_private[3];
+		struct list_head flush_list;
+	};
 
 	struct gendisk *rq_disk;
 	struct hd_struct *part;
@@ -364,10 +365,11 @@ struct request_queue
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_seq;
+	int			flush_data_cnt;
 	int			flush_err;
 	struct request		flush_rq;
-	struct request		*orig_flush_rq;
 	struct list_head	pending_flushes;
+	struct list_head	running_flushes;
 
 	struct mutex		sysfs_lock;
 
Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -151,27 +151,27 @@ static void req_bio_endio(struct request
 {
 	struct request_queue *q = rq->q;
 
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
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
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
 
+	if (!(rq->cmd_flags & REQ_FLUSH_SEQ)) {
 		if (bio->bi_size == 0)
 			bio_endio(bio, error);
 	} else {
@@ -1219,7 +1219,7 @@ static int __make_request(struct request
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
@@ -16,9 +16,12 @@ enum {
 	QUEUE_FSEQ_DATA		= (1 << 2), /* data write in progress */
 	QUEUE_FSEQ_POSTFLUSH	= (1 << 3), /* post-flushing in progress */
 	QUEUE_FSEQ_DONE		= (1 << 4),
+
+	QUEUE_FSEQ_ACTIONS	= QUEUE_FSEQ_PREFLUSH | QUEUE_FSEQ_DATA |
+				  QUEUE_FSEQ_POSTFLUSH,
 };
 
-static struct request *queue_next_fseq(struct request_queue *q);
+static void queue_next_fseq(struct request_queue *q);
 
 unsigned blk_flush_cur_seq(struct request_queue *q)
 {
@@ -27,10 +30,10 @@ unsigned blk_flush_cur_seq(struct reques
 	return 1 << ffz(q->flush_seq);
 }
 
-static struct request *blk_flush_complete_seq(struct request_queue *q,
-					      unsigned seq, int error)
+static void blk_flush_complete_seq(struct request_queue *q, unsigned seq,
+				   int error)
 {
-	struct request *next_rq = NULL;
+	struct request *rq, *n;
 
 	if (error && !q->flush_err)
 		q->flush_err = error;
@@ -40,35 +43,28 @@ static struct request *blk_flush_complet
 
 	if (blk_flush_cur_seq(q) != QUEUE_FSEQ_DONE) {
 		/* not complete yet, queue the next flush sequence */
-		next_rq = queue_next_fseq(q);
+		queue_next_fseq(q);
 	} else {
-		/* complete this flush request */
-		__blk_end_request_all(q->orig_flush_rq, q->flush_err);
-		q->orig_flush_rq = NULL;
+		/* complete all running flush requests */
+		list_for_each_entry_safe(rq, n, &q->running_flushes, flush_list)
+			__blk_end_request_all(rq, q->flush_err);
+		INIT_LIST_HEAD(&q->running_flushes);
 		q->flush_seq = 0;
-
-		/* dispatch the next flush if there's one */
-		if (!list_empty(&q->pending_flushes)) {
-			next_rq = list_entry_rq(q->pending_flushes.next);
-			list_move(&next_rq->queuelist, &q->queue_head);
-		}
 	}
-	return next_rq;
 }
 
 static void blk_flush_complete_seq_end_io(struct request_queue *q,
 					  unsigned seq, int error)
 {
 	bool was_empty = elv_queue_empty(q);
-	struct request *next_rq;
 
-	next_rq = blk_flush_complete_seq(q, seq, error);
+	blk_flush_complete_seq(q, seq, error);
 
 	/*
 	 * Moving a request silently to empty queue_head may stall the
 	 * queue.  Kick the queue in those cases.
 	 */
-	if (was_empty && next_rq)
+	if (was_empty && !elv_queue_empty(q))
 		__blk_run_queue(q);
 }
 
@@ -81,7 +77,12 @@ static void pre_flush_end_io(struct requ
 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
+
+	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
+	rq->end_io = NULL;
+
+	if (!--rq->q->flush_data_cnt)
+		blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
 }
 
 static void post_flush_end_io(struct request *rq, int error)
@@ -93,13 +94,13 @@ static void post_flush_end_io(struct req
 static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = WRITE_FLUSH;
+	rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
 	rq->rq_disk = disk;
 }
 
-static struct request *queue_next_fseq(struct request_queue *q)
+static void queue_next_fseq(struct request_queue *q)
 {
-	struct request *orig_rq = q->orig_flush_rq;
+	struct request *orig_rq = list_entry_rq(q->running_flushes.next);
 	struct request *rq = &q->flush_rq;
 
 	blk_rq_init(q, rq);
@@ -110,17 +111,18 @@ static struct request *queue_next_fseq(s
 		rq->end_io = pre_flush_end_io;
 		break;
 	case QUEUE_FSEQ_DATA:
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
+		list_for_each_entry_reverse(rq, &q->running_flushes,
+					    flush_list) {
+			WARN_ON_ONCE(rq->end_io || rq->end_io_data);
+
+			if (!blk_rq_sectors(rq))
+				continue;
+
+			rq->cmd_flags |= REQ_FLUSH_SEQ;
+			rq->end_io = flush_data_end_io;
+			list_add(&rq->queuelist, &q->queue_head);
+			q->flush_data_cnt++;
+		}
 		break;
 	case QUEUE_FSEQ_POSTFLUSH:
 		init_flush_request(rq, orig_rq->rq_disk);
@@ -131,64 +133,80 @@ static struct request *queue_next_fseq(s
 	}
 
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
-	return rq;
 }
 
-struct request *blk_do_flush(struct request_queue *q, struct request *rq)
+static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
-	unsigned int fflags = q->flush_flags; /* may change, cache it */
-	bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
-	bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
-	bool do_postflush = has_flush && !has_fua && (rq->cmd_flags & REQ_FUA);
-	unsigned skip = 0;
+	unsigned int policy = 0;
+
+	if (fflags & REQ_FLUSH) {
+		if (rq->cmd_flags & REQ_FLUSH)
+			policy |= QUEUE_FSEQ_PREFLUSH;
+		if (blk_rq_sectors(rq))
+			policy |= QUEUE_FSEQ_DATA;
+		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
+			policy |= QUEUE_FSEQ_POSTFLUSH;
+	}
+	return policy;
+}
+
+void blk_insert_flush(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	unsigned int fflags = q->flush_flags;
 
 	/*
-	 * Special case.  If there's data but flush is not necessary,
-	 * the request can be issued directly.
+	 * If there's data but flush is not necessary, the request can be
+	 * issued directly.
 	 *
 	 * Flush w/o data should be able to be issued directly too but
 	 * currently some drivers assume that rq->bio contains
 	 * non-zero data if it isn't NULL and empty FLUSH requests
 	 * getting here usually have bio's without data.
 	 */
-	if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
+	if (blk_flush_policy(fflags, rq) &
+	    (QUEUE_FSEQ_PREFLUSH | QUEUE_FSEQ_POSTFLUSH)) {
+		INIT_LIST_HEAD(&rq->flush_list);
+		list_add_tail(&rq->flush_list, &q->pending_flushes);
+	} else {
 		rq->cmd_flags &= ~REQ_FLUSH;
-		if (!has_fua)
+		if (!(fflags & REQ_FUA))
 			rq->cmd_flags &= ~REQ_FUA;
-		return rq;
+		list_add(&rq->queuelist, &q->queue_head);
 	}
+}
 
-	/*
-	 * Sequenced flushes can't be processed in parallel.  If
-	 * another one is already in progress, queue for later
-	 * processing.
-	 */
-	if (q->flush_seq) {
-		list_move_tail(&rq->queuelist, &q->pending_flushes);
-		return NULL;
-	}
+bool blk_do_flush(struct request_queue *q)
+{
+	unsigned int fflags = q->flush_flags; /* may change, cache it */
+	unsigned int skip = QUEUE_FSEQ_ACTIONS;
+	struct request *rq;
 
-	/*
-	 * Start a new flush sequence
-	 */
+	/* sequenced flushes can't be processed in parallel */
+	if (q->flush_seq)
+		return false;
+
+	/* start a new flush sequence */
+	q->flush_data_cnt = 0;
 	q->flush_err = 0;
 	q->flush_seq |= QUEUE_FSEQ_STARTED;
 
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
+	/*
+	 * Collect what needs to be done, adjust REQ_FLUSH/FUA and stash
+	 * away the original flush requests.
+	 */
+	list_splice_init(&q->pending_flushes, &q->running_flushes);
+	list_for_each_entry(rq, &q->running_flushes, flush_list) {
+		skip &= ~blk_flush_policy(fflags, rq);
+
+		rq->cmd_flags &= ~REQ_FLUSH;
+		if (!(fflags & REQ_FUA))
+			rq->cmd_flags &= ~REQ_FUA;
+	}
+
+	/* skip unneded sequences and queue the first one */
+	blk_flush_complete_seq(q, skip, 0);
+	return !q->flush_seq;
 }
 
 static void bio_end_flush(struct bio *bio, int err)
Index: work/block/blk.h
===================================================================
--- work.orig/block/blk.h
+++ work/block/blk.h
@@ -51,21 +51,20 @@ static inline void blk_clear_rq_complete
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-struct request *blk_do_flush(struct request_queue *q, struct request *rq);
+void blk_insert_flush(struct request *rq);
+bool blk_do_flush(struct request_queue *q);
 
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
 
 	while (1) {
-		while (!list_empty(&q->queue_head)) {
+		if (!list_empty(&q->pending_flushes) && blk_do_flush(q))
+			continue;
+
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
