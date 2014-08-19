From: Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 1/3] fs/buffer.c: allocate buffer cache with user specific
 flag
Date: Tue, 19 Aug 2014 15:52:38 +0900
Message-ID: <53F2F436.4070307@lge.com>
References: <53F2F3E6.1030901@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Cc: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
	=?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53F2F3E6.1030901@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


A buffer cache is allocated from movable area
because it is referred for a while and released soon.
But some filesystems are taking buffer cache for a long time
and it can disturb page migration.

A new API should be introduced to allocate buffer cache
with user specific flag.
For instance if user set flag to zero, buffer cache is allocated from
non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/buffer.c                 |   52 +++++++++++++++++++++++++++++--------------
 include/linux/buffer_head.h |   12 +++++++++-
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8f05111..14f2f21 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
  */
 static int
 grow_dev_page(struct block_device *bdev, sector_t block,
-               pgoff_t index, int size, int sizebits)
+             pgoff_t index, int size, int sizebits, gfp_t gfp)
 {
        struct inode *inode = bdev->bd_inode;
        struct page *page;
@@ -1002,10 +1002,10 @@ grow_dev_page(struct block_device *bdev, sector_t block,
        int ret = 0;            /* Will call free_more_memory() */
        gfp_t gfp_mask;

-       gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
-       gfp_mask |= __GFP_MOVABLE;
+       gfp_mask = (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) | gfp;
+
        /*
-        * XXX: __getblk_slow() can not really deal with failure and
+        * XXX: __getblk_gfp() can not really deal with failure and
         * will endlessly loop on improvised global reclaim.  Prefer
         * looping in the allocator rather than here, at least that
         * code knows what it's doing.
@@ -1058,7 +1058,7 @@ failed:
  * that page was dirty, the buffers are set dirty also.
  */
 static int
-grow_buffers(struct block_device *bdev, sector_t block, int size)
+grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
 {
        pgoff_t index;
        int sizebits;
@@ -1085,11 +1085,12 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
        }

        /* Create a page with the proper size buffers.. */
-       return grow_dev_page(bdev, block, index, size, sizebits);
+       return grow_dev_page(bdev, block, index, size, sizebits, gfp);
 }

-static struct buffer_head *
-__getblk_slow(struct block_device *bdev, sector_t block, int size)
+struct buffer_head *
+__getblk_gfp(struct block_device *bdev, sector_t block,
+            unsigned size, gfp_t gfp)
 {
        /* Size must be multiple of hard sectorsize */
        if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
@@ -1111,13 +1112,14 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
                if (bh)
                        return bh;

-               ret = grow_buffers(bdev, block, size);
+               ret = grow_buffers(bdev, block, size, gfp);
                if (ret < 0)
                        return NULL;
                if (ret == 0)
                        free_more_memory();
        }
 }
+EXPORT_SYMBOL(__getblk_gfp);

 /*
  * The relationship between dirty buffers and dirty pages:
@@ -1381,12 +1383,7 @@ EXPORT_SYMBOL(__find_get_block);
 struct buffer_head *
 __getblk(struct block_device *bdev, sector_t block, unsigned size)
 {
-       struct buffer_head *bh = __find_get_block(bdev, block, size);
-
-       might_sleep();
-       if (bh == NULL)
-               bh = __getblk_slow(bdev, block, size);
-       return bh;
+       return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
 }
 EXPORT_SYMBOL(__getblk);

@@ -1410,18 +1407,39 @@ EXPORT_SYMBOL(__breadahead);
  *  @size: size (in bytes) to read
  *
  *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache is allocated from movable area so that it can be migrated.
  *  It returns NULL if the block was unreadable.
  */
 struct buffer_head *
 __bread(struct block_device *bdev, sector_t block, unsigned size)
 {
-       struct buffer_head *bh = __getblk(bdev, block, size);
+       return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
+}
+EXPORT_SYMBOL(__bread);
+
+/**
+ *  __bread_gfp() - reads a specified block and returns the bh
+ *  @bdev: the block_device to read from
+ *  @block: number of block
+ *  @size: size (in bytes) to read
+ *  @gfp: page allocation flag
+ *
+ *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache can be allocated from non-movable area
+ *  not to prevent page migration if you set gfp to zero.
+ *  It returns NULL if the block was unreadable.
+ */
+struct buffer_head *
+__bread_gfp(struct block_device *bdev, sector_t block,
+                  unsigned size, gfp_t gfp)
+{
+       struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);

        if (likely(bh) && !buffer_uptodate(bh))
                bh = __bread_slow(bh);
        return bh;
 }
-EXPORT_SYMBOL(__bread);
+EXPORT_SYMBOL(__bread_gfp);

 /*
  * invalidate_bh_lrus() is called rarely - but not only at unmount.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 324329c..a1d73fd 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -177,10 +177,14 @@ struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
                        unsigned size);
 struct buffer_head *__getblk(struct block_device *bdev, sector_t block,
                        unsigned size);
+struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
+                                unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
 struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
+struct buffer_head *__bread_gfp(struct block_device *,
+                               sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
@@ -295,7 +299,13 @@ static inline void bforget(struct buffer_head *bh)
 static inline struct buffer_head *
 sb_bread(struct super_block *sb, sector_t block)
 {
-       return __bread(sb->s_bdev, block, sb->s_blocksize);
+       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MOVABLE);
+}
+
+static inline struct buffer_head *
+sb_bread_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
+{
+       return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
 }

 static inline void
--
1.7.9.5
