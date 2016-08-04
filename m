From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Thu,  4 Aug 2016 12:17:36 -0500
Message-ID: <1470331056-796-1-git-send-email-mchristi@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
To: ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, minchan@kernel.org, ngupta@vflare.org,
	vishal.l.verma@intel.com, axboe@kernel.dk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934006AbcHDRRk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 13:17:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a regression from
4e1b2d52a80d79296a5d899d73249748dea71a53
block, fs, drivers: remove REQ_OP compat defs and related code

The rw_page users were not converted to use bio/req ops. As a result
bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
be sent down as reads.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/brd.c           | 17 +++++++----------
 drivers/block/zram/zram_drv.c | 28 +++++++++++++++-------------
 drivers/nvdimm/btt.c          | 18 +++++++++---------
 drivers/nvdimm/pmem.c         | 12 ++++++------
 fs/block_dev.c                |  8 +++++---
 fs/mpage.c                    |  2 +-
 include/linux/blkdev.h        |  3 ++-
 include/linux/pagemap.h       |  2 +-
 mm/filemap.c                  |  6 +++---
 9 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3022dad..9fbbeba 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -300,20 +300,20 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
  * Process a single bvec of a bio.
  */
 static int brd_do_bvec(struct brd_device *brd, struct page *page,
-			unsigned int len, unsigned int off, int rw,
+			unsigned int len, unsigned int off, int op,
 			sector_t sector)
 {
 	void *mem;
 	int err = 0;
 
-	if (rw != READ) {
+	if (op_is_write(op)) {
 		err = copy_to_brd_setup(brd, sector, len);
 		if (err)
 			goto out;
 	}
 
 	mem = kmap_atomic(page);
-	if (rw == READ) {
+	if (!op_is_write(op)) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
 	} else {
@@ -330,7 +330,6 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct block_device *bdev = bio->bi_bdev;
 	struct brd_device *brd = bdev->bd_disk->private_data;
-	int rw;
 	struct bio_vec bvec;
 	sector_t sector;
 	struct bvec_iter iter;
@@ -347,14 +346,12 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
-	rw = bio_data_dir(bio);
-
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
 
 		err = brd_do_bvec(brd, bvec.bv_page, len,
-					bvec.bv_offset, rw, sector);
+					bvec.bv_offset, bio_op(bio), sector);
 		if (err)
 			goto io_error;
 		sector += len >> SECTOR_SHIFT;
@@ -369,11 +366,11 @@ io_error:
 }
 
 static int brd_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, int rw)
+		       struct page *page, int op, int op_flags)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
-	int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, rw, sector);
-	page_endio(page, rw & WRITE, err);
+	int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, op, sector);
+	page_endio(page, op, err);
 	return err;
 }
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7454cf1..f0e126c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -843,15 +843,15 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, int rw)
+			int offset, int op)
 {
 	unsigned long start_time = jiffies;
 	int ret;
 
-	generic_start_io_acct(rw, bvec->bv_len >> SECTOR_SHIFT,
+	generic_start_io_acct(op, bvec->bv_len >> SECTOR_SHIFT,
 			&zram->disk->part0);
 
-	if (rw == READ) {
+	if (!op_is_write(op)) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset);
 	} else {
@@ -859,10 +859,10 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
-	generic_end_io_acct(rw, &zram->disk->part0, start_time);
+	generic_end_io_acct(op, &zram->disk->part0, start_time);
 
 	if (unlikely(ret)) {
-		if (rw == READ)
+		if (!op_is_write(op))
 			atomic64_inc(&zram->stats.failed_reads);
 		else
 			atomic64_inc(&zram->stats.failed_writes);
@@ -873,7 +873,7 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
-	int offset, rw;
+	int offset;
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -888,7 +888,6 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 		return;
 	}
 
-	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		int max_transfer_size = PAGE_SIZE - offset;
 
@@ -903,15 +902,18 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset,
+					 bio_op(bio)) < 0)
 				goto out;
 
 			bv.bv_len = bvec.bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index + 1, 0, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0,
+					 bio_op(bio)) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset, rw) < 0)
+			if (zram_bvec_rw(zram, &bvec, index, offset,
+					 bio_op(bio)) < 0)
 				goto out;
 
 		update_position(&index, &offset, &bvec);
@@ -968,7 +970,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 }
 
 static int zram_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, int rw)
+		       struct page *page, int op, int op_flags)
 {
 	int offset, err = -EIO;
 	u32 index;
@@ -992,7 +994,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
-	err = zram_bvec_rw(zram, &bv, index, offset, rw);
+	err = zram_bvec_rw(zram, &bv, index, offset, op);
 put_zram:
 	zram_meta_put(zram);
 out:
@@ -1005,7 +1007,7 @@ out:
 	 * (e.g., SetPageError, set_page_dirty and extra works).
 	 */
 	if (err == 0)
-		page_endio(page, rw, 0);
+		page_endio(page, op, 0);
 	return err;
 }
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 9dce03f..6a6208d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1133,11 +1133,11 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 
 static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
 			struct page *page, unsigned int len, unsigned int off,
-			int rw, sector_t sector)
+			int op, sector_t sector)
 {
 	int ret;
 
-	if (rw == READ) {
+	if (!op_is_write(op)) {
 		ret = btt_read_pg(btt, bip, page, off, sector, len);
 		flush_dcache_page(page);
 	} else {
@@ -1155,7 +1155,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 	struct bvec_iter iter;
 	unsigned long start;
 	struct bio_vec bvec;
-	int err = 0, rw;
+	int err = 0;
 	bool do_acct;
 
 	/*
@@ -1170,7 +1170,6 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	do_acct = nd_iostat_start(bio, &start);
-	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -1181,11 +1180,12 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		BUG_ON(len % btt->sector_size);
 
 		err = btt_do_bvec(btt, bip, bvec.bv_page, len, bvec.bv_offset,
-				rw, iter.bi_sector);
+				  bio_op(bio), iter.bi_sector);
 		if (err) {
 			dev_info(&btt->nd_btt->dev,
 					"io error in %s sector %lld, len %d,\n",
-					(rw == READ) ? "READ" : "WRITE",
+					(op_is_write(bio_op(bio))) ? "WRITE" :
+					"READ",
 					(unsigned long long) iter.bi_sector, len);
 			bio->bi_error = err;
 			break;
@@ -1200,12 +1200,12 @@ out:
 }
 
 static int btt_rw_page(struct block_device *bdev, sector_t sector,
-		struct page *page, int rw)
+		struct page *page, int op, int op_flags)
 {
 	struct btt *btt = bdev->bd_disk->private_data;
 
-	btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, rw, sector);
-	page_endio(page, rw & WRITE, 0);
+	btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, op, sector);
+	page_endio(page, op, 0);
 	return 0;
 }
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b511099..6a7b97d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -67,7 +67,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 }
 
 static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
-			unsigned int len, unsigned int off, int rw,
+			unsigned int len, unsigned int off, int op,
 			sector_t sector)
 {
 	int rc = 0;
@@ -79,7 +79,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		bad_pmem = true;
 
-	if (rw == READ) {
+	if (!op_is_write(op)) {
 		if (unlikely(bad_pmem))
 			rc = -EIO;
 		else {
@@ -134,7 +134,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
 		rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
-				bvec.bv_offset, bio_data_dir(bio),
+				bvec.bv_offset, bio_op(bio),
 				iter.bi_sector);
 		if (rc) {
 			bio->bi_error = rc;
@@ -152,12 +152,12 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 }
 
 static int pmem_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, int rw)
+		       struct page *page, int op, int op_flags)
 {
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	int rc;
 
-	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, rw, sector);
+	rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, op, sector);
 
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
@@ -166,7 +166,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	 * caused by double completion.
 	 */
 	if (rc == 0)
-		page_endio(page, rw & WRITE, 0);
+		page_endio(page, op, 0);
 
 	return rc;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2033a3f..7ef1737 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -416,7 +416,8 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 	result = blk_queue_enter(bdev->bd_queue, false);
 	if (result)
 		return result;
-	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
+	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page,
+			      REQ_OP_READ, 0);
 	blk_queue_exit(bdev->bd_queue);
 	return result;
 }
@@ -445,7 +446,7 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 			struct page *page, struct writeback_control *wbc)
 {
 	int result;
-	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
+	int op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
 
 	if (!ops->rw_page || bdev_get_integrity(bdev))
@@ -455,7 +456,8 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 		return result;
 
 	set_page_writeback(page);
-	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
+	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page,
+			      REQ_OP_WRITE, op_flags);
 	if (result)
 		end_page_writeback(page);
 	else
diff --git a/fs/mpage.c b/fs/mpage.c
index 2ca1f39..7a09c55 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -50,7 +50,7 @@ static void mpage_end_io(struct bio *bio)
 
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
-		page_endio(page, bio_data_dir(bio), bio->bi_error);
+		page_endio(page, bio_op(bio), bio->bi_error);
 	}
 
 	bio_put(bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index adf3307..3652408 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1673,7 +1673,8 @@ struct blk_dax_ctl {
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
-	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
+	int (*rw_page)(struct block_device *, sector_t, struct page *,
+		       int op, int op_flags);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 81363b8..4578637 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -510,7 +510,7 @@ static inline void wait_on_page_writeback(struct page *page)
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
-void page_endio(struct page *page, int rw, int err);
+void page_endio(struct page *page, int op, int err);
 
 /*
  * Add an arbitrary waiter to a page's wait queue
diff --git a/mm/filemap.c b/mm/filemap.c
index 3083ded..daef091 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -887,9 +887,9 @@ EXPORT_SYMBOL(end_page_writeback);
  * After completing I/O on a page, call this routine to update the page
  * flags appropriately
  */
-void page_endio(struct page *page, int rw, int err)
+void page_endio(struct page *page, int op, int err)
 {
-	if (rw == READ) {
+	if (!op_is_write(op)) {
 		if (!err) {
 			SetPageUptodate(page);
 		} else {
@@ -897,7 +897,7 @@ void page_endio(struct page *page, int rw, int err)
 			SetPageError(page);
 		}
 		unlock_page(page);
-	} else { /* rw == WRITE */
+	} else {
 		if (err) {
 			SetPageError(page);
 			if (page->mapping)
-- 
2.7.2

