From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH]ext4: Use new buffer_head flag to check uninit group
	bitmaps initialization
Date: Mon, 19 Jan 2009 17:08:09 +0530
Message-ID: <20090119113809.GH9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:64506 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZATGDF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jan 2009 01:03:05 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id n0JBuvFU040268
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:57:47 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JBcM7O205312
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:38:22 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0JBcL1q001318
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:38:22 +1100
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH]ext4: Use new buffer_head flag to check uninit group bitmaps initialization

For uninit block group, the ondisk bitmap is not initialized. That implies
we cannot depend on the uptodate flag on the bitmap buffer_head to
find bitmap validity. Use a new buffer_head flag which would be set after
we properly initialize the bitmap. This also prevent the initializing
the uninit group bitmap initialization every time we do a
ext4_read_block_bitmap.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>   

---
 fs/ext4/balloc.c  |   25 ++++++++++++++++++++++++-
 fs/ext4/ext4.h    |   18 ++++++++++++++++++
 fs/ext4/ialloc.c  |   24 +++++++++++++++++++++++-
 fs/ext4/mballoc.c |   24 +++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 4235817..0cedf3b 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -319,18 +319,41 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+
+	if (bitmap_uptodate(bh))
 		return bh;
 
+  	lock_buffer(bh);
+ 	if (bitmap_uptodate(bh)) {
+ 		unlock_buffer(bh);
+ 		return bh;
+ 	}
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
+		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
 	}
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	if (buffer_uptodate(bh)) {
+ 		/*
+ 		 * if not uninit if bh is uptodate,
+ 		 * bitmap is also uptodate
+ 		 */
+ 		set_bitmap_uptodate(bh);
+ 		unlock_buffer(bh);
+ 		return bh;
+ 	}
+ 	/*
+ 	 * submit the buffer_head for read. We can
+ 	 * safely mark the bitmap as uptodate now.
+ 	 * We do it here so the bitmap uptodate bit
+ 	 * get set with buffer lock held.
+ 	 */
+ 	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e605295..1bbab6a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/magic.h>
+#include <linux/jbd2.h>
 #include "ext4_i.h"
 
 /*
@@ -1250,6 +1251,23 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned long max_blocks,
 			struct buffer_head *bh, int create,
 			int extend_disksize, int flag);
+/*
+ * Add new method to test wether block and inode bitmaps are properly
+ * initialized. With uninit_bg reading the block from disk is not enough
+ * to mark the bitmap uptodate. We need to also zero-out the bitmap
+ */
+#define BH_BITMAP_UPTODATE BH_JBDPrivateStart
+ 
+static inline int bitmap_uptodate(struct buffer_head *bh)
+{
+	return (buffer_uptodate(bh) &&
+ 			test_bit(BH_BITMAP_UPTODATE, &(bh)->b_state));
+}
+static inline void set_bitmap_uptodate(struct buffer_head *bh)
+{
+	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
+}
+ 
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c61168d..9b9705c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -115,18 +115,40 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (bitmap_uptodate(bh))
 		return bh;
 
+  	lock_buffer(bh);
+ 	if (bitmap_uptodate(bh)) {
+ 		unlock_buffer(bh);
+ 		return bh;
+ 	}
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
+		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
 	}
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+ 	if (buffer_uptodate(bh)) {
+ 		/*
+ 		 * if not uninit if bh is uptodate,
+ 		 * bitmap is also uptodate
+ 		 */
+ 		set_bitmap_uptodate(bh);
+ 		unlock_buffer(bh);
+ 		return bh;
+ 	}
+ 	/*
+ 	 * submit the buffer_head for read. We can
+ 	 * safely mark the bitmap as uptodate now.
+ 	 * We do it here so the bitmap uptodate bit
+ 	 * get set with buffer lock held.
+ 	 */
+ 	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ea13c5e..417e254 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -796,20 +796,42 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] == NULL)
 			goto out;
 
-		if (bh_uptodate_or_lock(bh[i]))
+		if (bitmap_uptodate(bh[i]))
 			continue;
 
+  		lock_buffer(bh[i]);
+ 		if (bitmap_uptodate(bh[i])) {
+ 			unlock_buffer(bh[i]);
+ 			continue;
+		}
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
 						first_group + i, desc);
+			set_bitmap_uptodate(bh[i]);
 			set_buffer_uptodate(bh[i]);
 			unlock_buffer(bh[i]);
 			spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 			continue;
 		}
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
+ 		if (buffer_uptodate(bh[i])) {
+ 			/*
+ 			 * if not uninit if bh is uptodate,
+ 			 * bitmap is also uptodate
+ 			 */
+ 			set_bitmap_uptodate(bh[i]);
+ 			unlock_buffer(bh[i]);
+ 			continue;
+ 		}
 		get_bh(bh[i]);
+ 		/*
+ 		 * submit the buffer_head for read. We can
+ 		 * safely mark the bitmap as uptodate now.
+ 		 * We do it here so the bitmap uptodate bit
+ 		 * get set with buffer lock held.
+ 		 */
+ 		set_bitmap_uptodate(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
 		mb_debug("read bitmap for group %lu\n", first_group + i);
-- 
tg: (56a5653..) ext4-Use-new-buffer_head-flag-to-check-uninit-group.patch (depends on: aneesh-7-dont-use-blocks-freed-but-not-yet-committed-in-buddy-cache-init)
