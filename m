From: Jan Kara <jack@suse.com>
Subject: [PATCH 3/3] block: Remove forced page bouncing under IO
Date: Wed, 15 Jul 2015 12:26:27 +0200
Message-ID: <1436955987-7305-4-git-send-email-jack@suse.com>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

JBD layer wrote back data buffers without setting PageWriteback bit.
Thus standard mechanism for guaranteeing stable pages under IO did not
work. Since JBD is gone now and there is no other user of the
functionality, just remove it.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bounce.c            | 31 ++++---------------------------
 include/linux/blk_types.h |  5 ++---
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index b17311227c12..31cad13a0c9d 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -176,26 +176,8 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
 	__bounce_end_io_read(bio, isa_page_pool, err);
 }
 
-#ifdef CONFIG_NEED_BOUNCE_POOL
-static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
-{
-	if (bio_data_dir(bio) != WRITE)
-		return 0;
-
-	if (!bdi_cap_stable_pages_required(&q->backing_dev_info))
-		return 0;
-
-	return test_bit(BIO_SNAP_STABLE, &bio->bi_flags);
-}
-#else
-static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
-{
-	return 0;
-}
-#endif /* CONFIG_NEED_BOUNCE_POOL */
-
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
-			       mempool_t *pool, int force)
+			       mempool_t *pool)
 {
 	struct bio *bio;
 	int rw = bio_data_dir(*bio_orig);
@@ -203,8 +185,6 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	struct bvec_iter iter;
 	unsigned i;
 
-	if (force)
-		goto bounce;
 	bio_for_each_segment(from, *bio_orig, iter)
 		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
 			goto bounce;
@@ -216,7 +196,7 @@ bounce:
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
 
-		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
+		if (page_to_pfn(page) <= queue_bounce_pfn(q))
 			continue;
 
 		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
@@ -254,7 +234,6 @@ bounce:
 
 void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 {
-	int must_bounce;
 	mempool_t *pool;
 
 	/*
@@ -263,15 +242,13 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	if (!bio_has_data(*bio_orig))
 		return;
 
-	must_bounce = must_snapshot_stable_pages(q, *bio_orig);
-
 	/*
 	 * for non-isa bounce case, just check if the bounce pfn is equal
 	 * to or bigger than the highest pfn in the system -- in that case,
 	 * don't waste time iterating over bio segments
 	 */
 	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (queue_bounce_pfn(q) >= blk_max_pfn && !must_bounce)
+		if (queue_bounce_pfn(q) >= blk_max_pfn)
 			return;
 		pool = page_pool;
 	} else {
@@ -282,7 +259,7 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	/*
 	 * slow path
 	 */
-	__blk_queue_bounce(q, bio_orig, pool, must_bounce);
+	__blk_queue_bounce(q, bio_orig, pool);
 }
 
 EXPORT_SYMBOL(blk_queue_bounce);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7303b3405520..89fd49184b48 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -118,9 +118,8 @@ struct bio {
 #define BIO_USER_MAPPED 4	/* contains user pages */
 #define BIO_NULL_MAPPED 5	/* contains invalid user pages */
 #define BIO_QUIET	6	/* Make BIO Quiet */
-#define BIO_SNAP_STABLE	7	/* bio data must be snapshotted during write */
-#define BIO_CHAIN	8	/* chained bio, ->bi_remaining in effect */
-#define BIO_REFFED	9	/* bio has elevated ->bi_cnt */
+#define BIO_CHAIN	7	/* chained bio, ->bi_remaining in effect */
+#define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
-- 
2.1.4
