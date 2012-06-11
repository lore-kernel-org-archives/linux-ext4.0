From: Saugata Das <saugata.das@stericsson.com>
Subject: [PATCH 1/3] block: Context support
Date: Mon, 11 Jun 2012 16:16:00 +0530
Message-ID: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <patches@linaro.org>, <venkat@linaro.org>,
	Saugata Das <saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Saugata Das <saugata.das@linaro.org>

On eMMC and UFS devices there is a new feature of setting context with each
read or write. The idea is to classify the data from different files and
apply the realibility on the complete file instead of individual writes,
which helps in performance. A new address space operation has been a added
to get the context from file system and set up the bi_context field in bio.
Then we need to ensure that bio from different contexts are not merged. The
context is then passed to the underlying driver as part of the read or write
request. Since the number of MMC contexts is limited, multiple file system
contexts are mapped to single MMC context.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
---
 block/blk-core.c            |    1 +
 block/blk-merge.c           |    3 +++
 fs/mpage.c                  |   12 ++++++++++++
 include/linux/blk_types.h   |    1 +
 include/linux/blkdev.h      |    1 +
 include/linux/buffer_head.h |    2 ++
 include/linux/fs.h          |    1 +
 7 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..274e05d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1309,6 +1309,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->errors = 0;
 	req->__sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
+	req->context = bio->bi_context;
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 160035f..ed70d56 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -497,6 +497,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return false;
 
+	if (bio->bi_context != rq->bio->bi_context)
+		return false;
+
 	return true;
 }
 
diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..4889842 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -293,6 +293,12 @@ alloc_new:
 			goto confused;
 	}
 
+	if (page && page->mapping && page->mapping->a_ops &&
+		page->mapping->a_ops->get_context)
+		bio->bi_context = page->mapping->a_ops->get_context(page);
+	else
+		bio->bi_context = 0;
+
 	length = first_hole << blkbits;
 	if (bio_add_page(bio, page, length, 0) < length) {
 		bio = mpage_bio_submit(READ, bio);
@@ -581,6 +587,12 @@ alloc_new:
 			goto confused;
 	}
 
+	if (page && page->mapping && page->mapping->a_ops &&
+		page->mapping->a_ops->get_context)
+		bio->bi_context = page->mapping->a_ops->get_context(page);
+	else
+		bio->bi_context = 0;
+
 	/*
 	 * Must try to add the page before marking the buffer clean or
 	 * the confused fail path above (OOM) will be very confused when
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..f3ac448 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -42,6 +42,7 @@ struct bio {
 
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 	unsigned short		bi_idx;		/* current index into bvl_vec */
+	unsigned long		bi_context;	/* context of this bio */
 
 	/* Number of segments in this BIO after
 	 * physical address coalescing is performed.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..0dd9a08 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -167,6 +167,7 @@ struct request {
 	struct list_head timeout_list;
 	unsigned int timeout;
 	int retries;
+	unsigned long context;	/* context of this request */
 
 	/*
 	 * completion callback.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 13bba17..0776564 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -72,6 +72,8 @@ struct buffer_head {
 	struct list_head b_assoc_buffers; /* associated with another mapping */
 	struct address_space *b_assoc_map;	/* mapping this buffer is
 						   associated with */
+	unsigned long	b_context; /* context for this buffer within the
+							storage device */
 	atomic_t b_count;		/* users using this buffer_head */
 };
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..4b379d8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -626,6 +626,7 @@ struct address_space_operations {
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
+	int (*get_context)(struct page *);
 };
 
 extern const struct address_space_operations empty_aops;
-- 
1.7.4.3

