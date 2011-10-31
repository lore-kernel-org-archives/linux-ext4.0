From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/5] ext4: add hooks in buffer layer
Date: Mon, 31 Oct 2011 17:43:01 +0800
Message-ID: <1320054184-14329-3-git-send-email-wenqing.lz@taobao.com>
References: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJl5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 05:41:57 -0400
In-Reply-To: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Add hooks in buffer layer, we just ignore the IO which hit in cache.
Some interfaces are changed to pass ios argument.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/buffer.c                 |   61 ++++++++++++++++++++++++++++++++++++------
 include/linux/buffer_head.h |   17 ++++++++++++
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 936d603..1e12533 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1208,7 +1208,8 @@ void __bforget(struct buffer_head *bh)
 }
 EXPORT_SYMBOL(__bforget);
 
-static struct buffer_head *__bread_slow(struct buffer_head *bh)
+static struct buffer_head *__bread_slow_stat(struct buffer_head *bh,
+					     struct ios *ios)
 {
 	lock_buffer(bh);
 	if (buffer_uptodate(bh)) {
@@ -1219,13 +1220,21 @@ static struct buffer_head *__bread_slow(struct buffer_head *bh)
 		bh->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh);
 		wait_on_buffer(bh);
-		if (buffer_uptodate(bh))
+		if (buffer_uptodate(bh)) {
+			if (ios)
+				ios->io_stat(ios->data);
 			return bh;
+		}
 	}
 	brelse(bh);
 	return NULL;
 }
 
+static struct buffer_head *__bread_slow(struct buffer_head *bh)
+{
+	return __bread_slow_stat(bh, NULL);
+}
+
 /*
  * Per-cpu buffer LRU implementation.  To reduce the cost of __find_get_block().
  * The bhs[] array is sorted - newest buffer is at bhs[0].  Buffers have their
@@ -1387,13 +1396,20 @@ EXPORT_SYMBOL(__getblk);
  */
 void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
+	__breadahead_stat(bdev, block, size, NULL);
+}
+EXPORT_SYMBOL(__breadahead);
+
+void __breadahead_stat(struct block_device *bdev, sector_t block,
+		       unsigned size, struct ios *ios)
+{
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(READA, 1, &bh);
+		ll_rw_block_stat(READA, 1, &bh, ios);
 		brelse(bh);
 	}
 }
-EXPORT_SYMBOL(__breadahead);
+EXPORT_SYMBOL(__breadahead_stat);
 
 /**
  *  __bread() - reads a specified block and returns the bh
@@ -1407,13 +1423,21 @@ EXPORT_SYMBOL(__breadahead);
 struct buffer_head *
 __bread(struct block_device *bdev, sector_t block, unsigned size)
 {
+	return __bread_stat(bdev, block, size, NULL);
+}
+EXPORT_SYMBOL(__bread);
+
+struct buffer_head *
+__bread_stat(struct block_device *bdev, sector_t block, unsigned size,
+	     struct ios *ios)
+{
 	struct buffer_head *bh = __getblk(bdev, block, size);
 
 	if (likely(bh) && !buffer_uptodate(bh))
-		bh = __bread_slow(bh);
+		bh = __bread_slow_stat(bh, ios);
 	return bh;
 }
-EXPORT_SYMBOL(__bread);
+EXPORT_SYMBOL(__bread_stat);
 
 /*
  * invalidate_bh_lrus() is called rarely - but not only at unmount.
@@ -2978,7 +3002,8 @@ EXPORT_SYMBOL(submit_bh);
  * All of the buffers must be for the same device, and must also be a
  * multiple of the current approved size for the device.
  */
-void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+void ll_rw_block_stat(int rw, int nr, struct buffer_head *bhs[],
+		      struct ios *ios)
 {
 	int i;
 
@@ -2992,6 +3017,8 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
 				submit_bh(WRITE, bh);
+				if (ios)
+					ios->io_stat(ios->data);
 				continue;
 			}
 		} else {
@@ -2999,12 +3026,19 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 				bh->b_end_io = end_buffer_read_sync;
 				get_bh(bh);
 				submit_bh(rw, bh);
+				if (ios)
+					ios->io_stat(ios->data);
 				continue;
 			}
 		}
 		unlock_buffer(bh);
 	}
 }
+EXPORT_SYMBOL(ll_rw_block_stat);
+void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+{
+	ll_rw_block_stat(rw, nr, bhs, NULL);
+}
 EXPORT_SYMBOL(ll_rw_block);
 
 void write_dirty_buffer(struct buffer_head *bh, int rw)
@@ -3288,6 +3322,12 @@ EXPORT_SYMBOL(bh_uptodate_or_lock);
  */
 int bh_submit_read(struct buffer_head *bh)
 {
+	return bh_submit_read_stat(bh, NULL);
+}
+EXPORT_SYMBOL(bh_submit_read);
+
+int bh_submit_read_stat(struct buffer_head *bh, struct ios *ios)
+{
 	BUG_ON(!buffer_locked(bh));
 
 	if (buffer_uptodate(bh)) {
@@ -3299,11 +3339,14 @@ int bh_submit_read(struct buffer_head *bh)
 	bh->b_end_io = end_buffer_read_sync;
 	submit_bh(READ, bh);
 	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
+	if (buffer_uptodate(bh)) {
+		if (ios)
+			ios->io_stat(ios->data);
 		return 0;
+	}
 	return -EIO;
 }
-EXPORT_SYMBOL(bh_submit_read);
+EXPORT_SYMBOL(bh_submit_read_stat);
 
 void __init buffer_init(void)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..07306a9 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -171,13 +171,18 @@ struct buffer_head *__getblk(struct block_device *bdev, sector_t block,
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
+void __breadahead_stat(struct block_device *, sector_t block,
+		       unsigned int size, struct ios *ios);
 struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
+struct buffer_head *__bread_stat(struct block_device *, sector_t block,
+				 unsigned size, struct ios *ios);
 void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
 void ll_rw_block(int, int, struct buffer_head * bh[]);
+void ll_rw_block_stat(int, int, struct buffer_head *bh[], struct ios *ios);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int rw);
 void write_dirty_buffer(struct buffer_head *bh, int rw);
@@ -186,6 +191,7 @@ void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
 int bh_submit_read(struct buffer_head *bh);
+int bh_submit_read_stat(struct buffer_head *bh, struct ios *ios);
 
 extern int buffer_heads_over_limit;
 
@@ -288,12 +294,23 @@ sb_bread(struct super_block *sb, sector_t block)
 {
 	return __bread(sb->s_bdev, block, sb->s_blocksize);
 }
+static inline struct buffer_head *
+sb_bread_stat(struct super_block *sb, sector_t block, struct ios *ios)
+{
+	return __bread_stat(sb->s_bdev, block, sb->s_blocksize, ios);
+}
+
 
 static inline void
 sb_breadahead(struct super_block *sb, sector_t block)
 {
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
+static inline void
+sb_breadahead_stat(struct super_block *sb, sector_t block, struct ios *ios)
+{
+	__breadahead_stat(sb->s_bdev, block, sb->s_blocksize, ios);
+}
 
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
-- 
1.7.4.1

