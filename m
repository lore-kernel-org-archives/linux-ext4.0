From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V1] ext4: Use new buffer_head flag to check uninit group bitmaps initialization
Date: Wed, 26 Nov 2008 20:24:10 +0530
Message-ID: <1227711250-13934-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Alex.Zhuravlev@Sun.COM
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51259 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYKZOze (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 09:55:34 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAQEsgJL014861
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 01:54:42 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAQEsHr1137394
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 01:54:17 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAQEsGLi002266
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 01:54:17 +1100
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
 fs/ext4/balloc.c     |   16 ++++++++++++++--
 fs/ext4/ext4.h       |   18 ++++++++++++++++++
 fs/ext4/ialloc.c     |   15 +++++++++++++--
 fs/ext4/mballoc.c    |   15 +++++++++++++--
 include/linux/jbd2.h |    1 +
 5 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3cae4c6..b96e49a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -320,20 +320,32 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
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
index 64e535d..4a803b7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/blkdev.h>
 #include <linux/magic.h>
+#include <linux/jbd2.h>
 #include "ext4_i.h"
 
 /*
@@ -1350,6 +1351,23 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 
+/*
+ * Add new method to test wether block and inode bitmaps are properly
+ * initialized. With uninit_bg reading the block from disk is not enough
+ * to mark the bitmap uptodate. We need to also zero-out the bitmap
+ */
+#define BH_BITMAP_UPTODATE BH_JBD_State_bits_End
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
index d1ccae5..742c545 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -115,20 +115,31 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
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
index 249d9c7..d7a165c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -794,15 +794,19 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
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
@@ -810,6 +814,13 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		}
 		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
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
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 4932b34..6694561 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -329,6 +329,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBD_State_bits_End,
 };
 
 BUFFER_FNS(JBD, jbd)
-- 
1.6.0.4.735.gea4f

