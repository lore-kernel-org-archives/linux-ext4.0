From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] block: add REQ_FLUSH_SEQ
Date: Fri, 21 Jan 2011 16:59:56 +0100
Message-ID: <1295625598-15203-2-git-send-email-tj@kernel.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1AUQAT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 11:00:19 -0500
In-Reply-To: <1295625598-15203-1-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

rq == &q->flush_rq was used to determine whether a rq is part of a
flush sequence, which worked because all requests in a flush sequence
were sequenced using the single dedicated request.  This is about to
change, so introduce REQ_FLUSH_SEQ flag to distinguish flush sequence
requests.

This patch doesn't cause any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c          |    4 ++--
 block/blk-flush.c         |    1 +
 block/blk.h               |    2 +-
 include/linux/blk_types.h |    2 ++
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2f4002f..22e0b4f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -151,7 +151,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 {
 	struct request_queue *q = rq->q;
 
-	if (&q->flush_rq != rq) {
+	if (!(rq->cmd_flags & REQ_FLUSH_SEQ)) {
 		if (error)
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
@@ -1804,7 +1804,7 @@ static void blk_account_io_done(struct request *req)
 	 * normal IO on queueing nor completion.  Accounting the
 	 * containing request is enough.
 	 */
-	if (blk_do_io_stat(req) && req != &req->q->flush_rq) {
+	if (blk_do_io_stat(req) && !(req->cmd_flags & REQ_FLUSH_SEQ)) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 54b123d..8592869 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,6 +130,7 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		BUG();
 	}
 
+	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 	return rq;
 }
diff --git a/block/blk.h b/block/blk.h
index 2db8f32..9d2ee8f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -61,7 +61,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 		while (!list_empty(&q->queue_head)) {
 			rq = list_entry_rq(q->queue_head.next);
 			if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
-			    rq == &q->flush_rq)
+			    (rq->cmd_flags & REQ_FLUSH_SEQ))
 				return rq;
 			rq = blk_do_flush(q, rq);
 			if (rq)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46ad519..dddedfc 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
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
-- 
1.7.1

