From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCH 1/2] fs/buffer.c: allocate buffer cache from non-movable area
Date: Tue, 22 Jul 2014 14:20:59 +0900
Message-ID: <53CDF4BB.5060109@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lgeamrelo04.lge.com ([156.147.1.127]:57363 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaGVFVC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 01:21:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A buffer cache is allocated from movable area
because it is referred for a while and released soon.
But some filesystems are taking buffer cache for a long time
and it can disturb page migration.

A new API should be introduced to allocate buffer cache from
non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/buffer.c                 |   39 ++++++++++++++++++++++++++++++++-------
 include/linux/buffer_head.h |    8 ++++++++
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8f05111..8c7ed02 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
  */
 static int
 grow_dev_page(struct block_device *bdev, sector_t block,
-               pgoff_t index, int size, int sizebits)
+             pgoff_t index, int size, int sizebits, gfp_t movable_mask)
 {
        struct inode *inode = bdev->bd_inode;
        struct page *page;
@@ -1003,7 +1003,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
        gfp_t gfp_mask;

        gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
-       gfp_mask |= __GFP_MOVABLE;
+       if (movable_mask & __GFP_MOVABLE)
+               gfp_mask |= __GFP_MOVABLE;
        /*
         * XXX: __getblk_slow() can not really deal with failure and
         * will endlessly loop on improvised global reclaim.  Prefer
@@ -1058,7 +1059,8 @@ failed:
  * that page was dirty, the buffers are set dirty also.
  */
 static int
-grow_buffers(struct block_device *bdev, sector_t block, int size)
+grow_buffers(struct block_device *bdev, sector_t block,
+            int size, gfp_t movable_mask)
 {
        pgoff_t index;
        int sizebits;
@@ -1085,11 +1087,12 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
        }

        /* Create a page with the proper size buffers.. */
-       return grow_dev_page(bdev, block, index, size, sizebits);
+       return grow_dev_page(bdev, block, index, size, sizebits, movable_mask);
 }

 static struct buffer_head *
-__getblk_slow(struct block_device *bdev, sector_t block, int size)
+__getblk_slow(struct block_device *bdev, sector_t block,
+             int size, gfp_t movable_mask)
 {
        /* Size must be multiple of hard sectorsize */
        if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
@@ -1111,7 +1114,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
                if (bh)
                        return bh;

-               ret = grow_buffers(bdev, block, size);
+               ret = grow_buffers(bdev, block, size, movable_mask);
                if (ret < 0)
                        return NULL;
                if (ret == 0)
@@ -1385,7 +1388,7 @@ __getblk(struct block_device *bdev, sector_t block, unsigned size)

        might_sleep();
        if (bh == NULL)
-               bh = __getblk_slow(bdev, block, size);
+               bh = __getblk_slow(bdev, block, size, __GFP_MOVABLE);
        return bh;
 }
 EXPORT_SYMBOL(__getblk);
@@ -1410,6 +1413,7 @@ EXPORT_SYMBOL(__breadahead);
  *  @size: size (in bytes) to read
  *
  *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache is allocated from movable area.
  *  It returns NULL if the block was unreadable.
  */
 struct buffer_head *
@@ -1423,6 +1427,27 @@ __bread(struct block_device *bdev, sector_t block, unsigned size)
 }
 EXPORT_SYMBOL(__bread);

+/**
+ *  __bread_nonmovable() - reads a specified block and returns the bh
+ *  @bdev: the block_device to read from
+ *  @block: number of block
+ *  @size: size (in bytes) to read
+ *
+ *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache is allocated from non-movable area.
+ *  It returns NULL if the block was unreadable.
+ */
+struct buffer_head *
+__bread_nonmovable(struct block_device *bdev, sector_t block, unsigned size)
+{
+       struct buffer_head *bh = __getblk_slow(bdev, block, size, 0);
+
+       if (likely(bh) && !buffer_uptodate(bh))
+               bh = __bread_slow(bh);
+       return bh;
+}
+EXPORT_SYMBOL(__bread_nonmovable);
+
 /*
  * invalidate_bh_lrus() is called rarely - but not only at unmount.
  * This doesn't race because it runs in each cpu either in irq
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 324329c..cf8def2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -181,6 +181,8 @@ void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
 struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
+struct buffer_head *__bread_nonmovable(struct block_device *,
+                                      sector_t block, unsigned size);
 void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
@@ -298,6 +300,12 @@ sb_bread(struct super_block *sb, sector_t block)
        return __bread(sb->s_bdev, block, sb->s_blocksize);
 }

+static inline struct buffer_head *
+sb_bread_nonmovable(struct super_block *sb, sector_t block)
+{
+       return __bread_nonmovable(sb->s_bdev, block, sb->s_blocksize);
+}
+
 static inline void
 sb_breadahead(struct super_block *sb, sector_t block)
 {
--
1.7.9.5
