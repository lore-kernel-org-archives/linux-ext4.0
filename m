From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/4] ext4: Use new buffer_head flag to check uninit group bitmaps initialization
Date: Mon,  1 Dec 2008 19:13:43 +0530
Message-ID: <1228139026-22736-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54392 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLANnz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 08:43:55 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1DhptU011775
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:51 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1Dh6qt3940546
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:06 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1DhoOk015847
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 00:43:51 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For uninit block group, the ondisk bitmap is not initialized. That implies
we cannot depend on the uptodate flag on the bitmap buffer_head to
find bitmap validity. Use a new buffer_head flag which would be set after
we properly initialize the bitmap. This also prevent the initializing
the uninit group bitmap initialization every time we do a
ext4_read_block_bitmap.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |   25 +++++++++++++++++++++++--
 fs/ext4/ext4.h    |   18 ++++++++++++++++++
 fs/ext4/ialloc.c  |   24 ++++++++++++++++++++++--
 fs/ext4/mballoc.c |   24 ++++++++++++++++++++++--
 4 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3cae4c6..c00023f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -320,20 +320,41 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (buffer_uptodate(bh) &&
-	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
+
+	if (bitmap_uptodate(bh))
 		return bh;
 
 	lock_buffer(bh);
+	if (bitmap_uptodate(bh)) {
+		unlock_buffer(bh);
+		return bh;
+	}
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
+		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		unlock_buffer(bh);
 		return bh;
 	}
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	if (buffer_uptodate(bh)) {
+		/*
+		 * if not uninit if bh is uptodate,
+		 * bitmap is also uptodate
+		 */
+		set_bitmap_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
+	}
+	/*
+	 * submit the buffer_head for read. We can
+	 * safely mark the bitmap as uptodate now.
+	 * We do it here so the bitmap uptodate bit
+	 * get set with buffer lock held.
+	 */
+	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fc4148d..9039b8a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/magic.h>
+#include <linux/jbd2.h>
 #include "ext4_i.h"
 
 /*
@@ -1360,6 +1361,23 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 
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
+			test_bit(BH_BITMAP_UPTODATE, &(bh)->b_state));
+}
+static inline void set_bitmap_uptodate(struct buffer_head *bh)
+{
+	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
+}
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d1ccae5..1627868 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -115,20 +115,40 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (buffer_uptodate(bh) &&
-	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
+	if (bitmap_uptodate(bh))
 		return bh;
 
 	lock_buffer(bh);
+	if (bitmap_uptodate(bh)) {
+		unlock_buffer(bh);
+		return bh;
+	}
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
+		set_bitmap_uptodate(bh);
 		set_buffer_uptodate(bh);
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		unlock_buffer(bh);
 		return bh;
 	}
 	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
+	if (buffer_uptodate(bh)) {
+		/*
+		 * if not uninit if bh is uptodate,
+		 * bitmap is also uptodate
+		 */
+		set_bitmap_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
+	}
+	/*
+	 * submit the buffer_head for read. We can
+	 * safely mark the bitmap as uptodate now.
+	 * We do it here so the bitmap uptodate bit
+	 * get set with buffer lock held.
+	 */
+	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 259eef7..5d4105d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -794,22 +794,42 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (bh[i] == NULL)
 			goto out;
 
-		if (buffer_uptodate(bh[i]) &&
-		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
+		if (bitmap_uptodate(bh[i]))
 			continue;
 
 		lock_buffer(bh[i]);
+		if (bitmap_uptodate(bh[i])) {
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
 						first_group + i, desc);
+			set_bitmap_uptodate(bh[i]);
 			set_buffer_uptodate(bh[i]);
 			spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 			unlock_buffer(bh[i]);
 			continue;
 		}
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
+		if (buffer_uptodate(bh[i])) {
+			/*
+			 * if not uninit if bh is uptodate,
+			 * bitmap is also uptodate
+			 */
+			set_bitmap_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
+		/*
+		 * submit the buffer_head for read. We can
+		 * safely mark the bitmap as uptodate now.
+		 * We do it here so the bitmap uptodate bit
+		 * get set with buffer lock held.
+		 */
+		set_bitmap_uptodate(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
 		mb_debug("read bitmap for group %u\n", first_group + i);
-- 
1.6.0.4.735.gea4f

