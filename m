From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH 2/2] HACK: do I/O read requests while ext3 journal recovers
Date: Tue, 14 Jul 2009 17:06:03 +0300
Message-ID: <20090714140603.26116.59674.sendpatchset@ahunter-tower>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
Cc: Artem Bityutskiy <artem.bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>
To: Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52393 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZGNOD5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 10:03:57 -0400
In-Reply-To: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From c034a8b69ecc13ef924edd342ff945f890ebac61 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 14 Jul 2009 12:58:34 +0300
Subject: [PATCH] HACK: do I/O read requests while ext3 journal recovers

The ext3 journal can take a long time to recover at mount
time.  That was partially fixed by placing a barrier into
the I/O queue and then not waiting for the actual I/O to
complete.

However the barrier stops all other I/O, making the file
system unresponsive until the journal I/O completes
anyway.

This hack allows I/O read requests to jump the barrier
to the front on the I/O queue.

Note that the hack only takes affect while the ext3 journal
is recovering.

Note also, that in the normal situation, the I/O scheduler
is entitled to reorder I/O requests however it pleases,
so jumping read requests to the front is quite valid.

Where the normal rules are being broken, is that a barrier
is being jumped over.  That is safe for two reasons:
	- barriers are not otherwise used by ext3, vfat or swap
	- ext3 I/O all goes through buffers, so any attempt
	to read from sectors not yet written, will successfully
	read from the buffers instead.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 block/blk-core.c            |  121 ++++++++++++++++++++++++++++++++++++++++++-
 block/elevator.c            |   37 +++++++++++++
 fs/buffer.c                 |    9 +++-
 fs/ext3/super.c             |    8 +++
 fs/jbd/journal.c            |    8 +++
 include/linux/bio.h         |    3 +
 include/linux/blkdev.h      |   12 ++++
 include/linux/buffer_head.h |    2 +
 include/linux/elevator.h    |    1 +
 include/linux/fs.h          |    1 +
 10 files changed, 199 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c36aa98..66ac9b5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1003,6 +1003,23 @@ static inline void add_request(struct request_queue *q, struct request *req)
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
 
+/*
+ * Leapfrog requests are inserted with a special 'where' code:
+ * ELEVATOR_INSERT_FRONT_BACK which means the back of the READ requests that
+ * are at the front of the dispatch queue.
+ */
+static inline void request_leapfrog(struct request_queue *q,
+				    struct request *req)
+{
+	drive_stat_acct(req, 1);
+
+	/*
+	 * elevator indicated where it wants this request to be
+	 * inserted at elevator_merge time
+	 */
+	__elv_add_request(q, req, ELEVATOR_INSERT_FRONT_BACK, 0);
+}
+
 static void part_round_stats_single(int cpu, struct hd_struct *part,
 				    unsigned long now)
 {
@@ -1117,6 +1134,13 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	if (bio_rw_meta(bio))
 		req->cmd_flags |= REQ_RW_META;
 
+	/*
+	 * The bio says to start leapfrog mode, so set the request
+	 * to say the same.
+	 */
+	if (bio_leapfrog(bio))
+		req->cmd_flags |= REQ_LEAPFROG;
+
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
@@ -1124,13 +1148,68 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
+/*
+ * This is the same as elv_rq_merge_ok but for leapfrog mode, we are
+ * merging into the dispatch queue and do not want to involve the
+ * I/O scheduler in any way.
+ */
+static int elv_rq_leapfrog_merge_ok(struct request *rq, struct bio *bio)
+{
+	if (!rq_mergeable(rq))
+		return 0;
+
+	/*
+	 * Don't merge file system requests and discard requests
+	 */
+	if (bio_discard(bio) != bio_discard(rq->bio))
+		return 0;
+
+	/*
+	 * different data direction or already started, don't merge
+	 */
+	if (bio_data_dir(bio) != rq_data_dir(rq))
+		return 0;
+
+	/*
+	 * must be same device and not a special request
+	 */
+	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
+		return 0;
+
+	/*
+	 * only merge integrity protected bio into ditto rq
+	 */
+	if (bio_integrity(bio) != blk_integrity_rq(rq))
+		return 0;
+
+	return 1;
+}
+
+/* This is the same as elv_try_merge but calls elv_rq_leapfrog_merge_ok */
+static inline int elv_try_leapfrog_merge(struct request *__rq, struct bio *bio)
+{
+	int ret = ELEVATOR_NO_MERGE;
+
+	/*
+	 * we can merge and sequence is ok, check if it's possible
+	 */
+	if (elv_rq_leapfrog_merge_ok(__rq, bio)) {
+		if (__rq->sector + __rq->nr_sectors == bio->bi_sector)
+			ret = ELEVATOR_BACK_MERGE;
+		else if (__rq->sector - bio_sectors(bio) == bio->bi_sector)
+			ret = ELEVATOR_FRONT_MERGE;
+	}
+
+	return ret;
+}
+
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
 	int el_ret, nr_sectors, barrier, discard, err;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
-	int rw_flags;
+	int rw_flags, leapfrog = 0;
 
 	nr_sectors = bio_sectors(bio);
 
@@ -1159,6 +1238,40 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	if (unlikely(barrier) || elv_queue_empty(q))
 		goto get_rq;
 
+	/*
+	 * If the request queue is in leapfrog mode, leapfrog READs to the
+	 * front of the queue.
+	 */
+	if (unlikely(q->leapfrog) && !discard && (bio->bi_rw & (1 << BIO_RW)) == READ) {
+		/* Look in the dispatch queue for a request to merge with */
+		list_for_each_entry(req, &q->queue_head, queuelist) {
+			if (req->cmd_flags & REQ_STARTED)
+				continue;
+			if (rq_data_dir(req) == READ) {
+				/* Try to merge bio into request */
+				el_ret = elv_try_leapfrog_merge(req, bio);
+				/* Front merges are uncommon, so just do back merges */
+				if (el_ret == ELEVATOR_BACK_MERGE && ll_back_merge_fn(q, req, bio)) {
+					/* Merge is OK so plonk bio into this request and we are done */
+					blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
+					req->biotail->bi_next = bio;
+					req->biotail = bio;
+					req->nr_sectors = req->hard_nr_sectors += nr_sectors;
+					req->ioprio = ioprio_best(req->ioprio, prio);
+					if (!blk_rq_cpu_valid(req))
+						req->cpu = bio->bi_comp_cpu;
+					drive_stat_acct(req, 0);
+					goto out;
+				}
+				continue;
+			}
+			break;
+		}
+		/* Was not able to merge so create a new request */
+		leapfrog = 1;
+		goto get_rq;
+	}
+
 	el_ret = elv_merge(q, &req, bio);
 	switch (el_ret) {
 	case ELEVATOR_BACK_MERGE:
@@ -1244,7 +1357,11 @@ get_rq:
 		req->cpu = blk_cpu_to_group(smp_processor_id());
 	if (elv_queue_empty(q))
 		blk_plug_device(q);
-	add_request(q, req);
+	/* Leapfrogging requests are added specially */
+	if (unlikely(leapfrog))
+		request_leapfrog(q, req);
+	else
+		add_request(q, req);
 out:
 	if (sync)
 		__generic_unplug_device(q);
diff --git a/block/elevator.c b/block/elevator.c
index a6951f7..80dbd18 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -663,6 +663,31 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		list_add_tail(&rq->queuelist, pos);
 		break;
 
+	case ELEVATOR_INSERT_FRONT_BACK:
+		/*
+		 * New 'where' code for leapfrog mode. Put the request at the
+		 * front of the queue but after any requests that have already
+		 * started, and after other READ requests.
+		 */
+		{
+			struct request *r;
+			struct list_head *p = &q->queue_head;
+
+			list_for_each_entry(r, &q->queue_head, queuelist) {
+				if (r->cmd_flags & REQ_STARTED) {
+					p = &r->queuelist;
+					continue;
+				}
+				if (rq_data_dir(r) == READ) {
+					p = &r->queuelist;
+					continue;
+				}
+				break;
+			}
+			list_add(&rq->queuelist, p);
+			break;
+		}
+
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
 		       __func__, where);
@@ -691,6 +716,10 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		if (blk_barrier_rq(rq))
 			q->ordcolor ^= 1;
 
+		/* A request marked as 'leapfrog' cause leapfrog mode to start */
+		if (blk_leapfrog_rq(rq))
+			q->leapfrog += 1;
+
 		/*
 		 * barriers implicitly indicate back insertion
 		 */
@@ -773,6 +802,14 @@ struct request *elv_next_request(struct request_queue *q)
 			 */
 			rq->cmd_flags |= REQ_STARTED;
 			blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
+
+			/*
+			 * If this request started leapfrog mode, then
+			 * leapfrog mode stops now that this request is
+			 * starting.
+			 */
+			if (blk_leapfrog_rq(rq))
+				q->leapfrog -= 1;
 		}
 
 		if (!q->boundary_rq || q->boundary_rq == rq) {
diff --git a/fs/buffer.c b/fs/buffer.c
index 10179cf..b4f3b92 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2930,8 +2930,15 @@ int submit_bh(int rw, struct buffer_head * bh)
 	 * Mask in barrier bit for a write (could be either a WRITE or a
 	 * WRITE_SYNC
 	 */
-	if (buffer_ordered(bh) && (rw & WRITE))
+	if (buffer_ordered(bh) && (rw & WRITE)) {
 		rw |= WRITE_BARRIER;
+		/*
+		 * If the buffer says to start leapfrog mode, then flag it
+		 * on the bio too.
+		 */
+		if (buffer_leapfrog(bh))
+			rw |= LEAPFROG;
+	}
 
 	/*
 	 * Only clear out a write error when rewriting
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 59efefb..b75a825 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2317,8 +2317,16 @@ static void ext3_commit_super (struct super_block * sb,
 		 * write will not reach the disk before any previous ones,
 		 * and we will not have to wait for it either.
 		 */
+		/*
+		 * Start leapfrog mode.  Leapfrog mode continues until the
+		 * associated I/O request is started by the underlying
+		 * block driver.  Note that the request is also a barrier
+		 * so it is never merged with another request.
+		 */
 		set_buffer_ordered(sbh);
+		set_buffer_leapfrog(sbh);
 		ll_rw_block(SWRITE, 1, &sbh);
+		clear_buffer_leapfrog(sbh);
 		clear_buffer_ordered(sbh);
 	} else if (sync)
 		sync_dirty_buffer(sbh);
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3fd14ef..5e3628c 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -963,8 +963,16 @@ void journal_update_superblock(journal_t *journal, int wait)
 	if (wait)
 		sync_dirty_buffer(bh);
 	else {
+		/*
+		 * Start leapfrog mode.  Leapfrog mode continues until the
+		 * associated I/O request is started by the underlying
+		 * block driver.  Note that the request is also a barrier
+		 * so it is never merged with another request.
+		 */
 		set_buffer_ordered(bh);
+		set_buffer_leapfrog(bh);
 		ll_rw_block(SWRITE, 1, &bh);
+		clear_buffer_leapfrog(bh);
 		clear_buffer_ordered(bh);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6a64209..43bd58d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -150,6 +150,7 @@ struct bio {
  * bit 7 -- fail fast transport errors
  * bit 8 -- fail fast driver errors
  *	Don't want driver retries for any fast fail whatever the reason.
+ * bit 9 -- start leapfrog mode
  */
 #define BIO_RW		0	/* Must match RW in req flags (blkdev.h) */
 #define BIO_RW_AHEAD	1	/* Must match FAILFAST in req flags */
@@ -160,6 +161,7 @@ struct bio {
 #define BIO_RW_FAILFAST_DEV		6
 #define BIO_RW_FAILFAST_TRANSPORT	7
 #define BIO_RW_FAILFAST_DRIVER		8
+#define BIO_RW_LEAPFROG			9
 
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
@@ -194,6 +196,7 @@ struct bio {
 #define bio_rw_meta(bio)	((bio)->bi_rw & (1 << BIO_RW_META))
 #define bio_discard(bio)	((bio)->bi_rw & (1 << BIO_RW_DISCARD))
 #define bio_empty_barrier(bio)	(bio_barrier(bio) && !bio_has_data(bio) && !bio_discard(bio))
+#define bio_leapfrog(bio)	((bio)->bi_rw & (1 << BIO_RW_LEAPFROG))
 
 static inline unsigned int bio_cur_sectors(struct bio *bio)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 031a315..3ed0639 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -109,6 +109,7 @@ enum rq_flag_bits {
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
+	__REQ_LEAPFROG,		/* start leapfrog mode */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -135,6 +136,7 @@ enum rq_flag_bits {
 #define REQ_RW_META	(1 << __REQ_RW_META)
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
+#define REQ_LEAPFROG	(1 << __REQ_LEAPFROG)
 
 #define BLK_MAX_CDB	16
 
@@ -399,6 +401,15 @@ struct request_queue
 	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 
+	/*
+	 * Flag indicating leapfrog mode. When a request also
+	 * has a leapfrog flag, then the request queue starts
+	 * leapfrog mode.  When that request is finally started,
+	 * leapfrog mode ends. Here 'leapfrog' is a counter, so
+	 * if 2 requests start leapfrog mode, then the value is 2.
+	 */
+	unsigned int		leapfrog;
+
 	struct blk_queue_tag	*queue_tags;
 	struct list_head	tag_busy_list;
 
@@ -584,6 +595,7 @@ enum {
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_discard_rq(rq)	((rq)->cmd_flags & REQ_DISCARD)
+#define blk_leapfrog_rq(rq)	((rq)->cmd_flags & REQ_LEAPFROG)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 #define blk_empty_barrier(rq)	(blk_barrier_rq(rq) && blk_fs_request(rq) && !(rq)->hard_nr_sectors)
 /* rq->queuelist of dequeued request must be list_empty() */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 3ce64b9..2b73a1f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -35,6 +35,7 @@ enum bh_state_bits {
 	BH_Ordered,	/* ordered write */
 	BH_Eopnotsupp,	/* operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
+	BH_Leapfrog,	/* Start leapfrog mode */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -127,6 +128,7 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
 BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
+BUFFER_FNS(Leapfrog, leapfrog)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 92f6f63..e5112c4 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -160,6 +160,7 @@ extern struct request *elv_rb_find(struct rb_root *, sector_t);
 #define ELEVATOR_INSERT_BACK	2
 #define ELEVATOR_INSERT_SORT	3
 #define ELEVATOR_INSERT_REQUEUE	4
+#define ELEVATOR_INSERT_FRONT_BACK 5
 
 /*
  * return values from elevator_may_queue_fn
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aaa6291..1635a41 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -95,6 +95,7 @@ extern int dir_notify_enable;
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
+#define LEAPFROG (1 << BIO_RW_LEAPFROG)
 
 #define SEL_IN		1
 #define SEL_OUT		2
-- 
1.5.6.3

