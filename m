From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 8/9][e2fsprogs] Add 64-bit closefs interface.
Date: Fri, 09 May 2008 11:40:19 -0500
Message-ID: <20080509164018.15484.53983.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:47904 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970AbYEIQjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 12:39:51 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GajuE027653
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:36:45 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49GdpMr214528
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:51 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49Gdos4018321
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:50 -0600
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit closefs interface.

Add new ext2fs_super_and_bgd_loc2() that returns blk64_t pointers.
The function now returns the number of blocks used by super block and
group descriptors since with flex_bg, it can no longer be assumed that
bitmaps and inode tables still resided within the block group.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/closefs.c |   94 ++++++++++++++++++++++++++++++++++----------------
 lib/ext2fs/ext2fs.h  |    6 +++
 2 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 206faa6..cfb5ddc 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -47,30 +47,23 @@ int ext2fs_bg_has_super(ext2_filsys fs, int group_block)
 
 /*
  * This function returns the location of the superblock, block group
- * descriptors for a given block group.  It currently returns the
- * number of free blocks assuming that inode table and allocation
- * bitmaps will be in the group.  This is not necessarily the case
- * when the flex_bg feature is enabled, so callers should take care!
- * It was only really intended for use by mke2fs, and even there it's
- * not that useful.  In the future, when we redo this function for
- * 64-bit block numbers, we should probably return the number of
- * blocks used by the super block and group descriptors instead.
- *
- * See also the comment for ext2fs_reserve_super_and_bgd()
+ * descriptors for a given block group.  It returns the number of
+ * blocks used by super block and group descriptors.
  */
-int ext2fs_super_and_bgd_loc(ext2_filsys fs, 
+int ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 			     dgrp_t group,
-			     blk_t *ret_super_blk,
-			     blk_t *ret_old_desc_blk,
-			     blk_t *ret_new_desc_blk,
+			     blk64_t *ret_super_blk,
+			     blk64_t *ret_old_desc_blk,
+			     blk64_t *ret_new_desc_blk,
 			     int *ret_meta_bg)
 {
-	blk_t	group_block, super_blk = 0, old_desc_blk = 0, new_desc_blk = 0;
+	blk64_t	group_block, super_blk = 0, old_desc_blk = 0, new_desc_blk = 0;
 	unsigned int meta_bg, meta_bg_size;
-	blk_t	numblocks, old_desc_blocks;
+	blk_t	numblocks = 0;
+	blk64_t old_desc_blocks;
 	int	has_super;
 
-	group_block = ext2fs_group_first_block(fs, group);
+	group_block = ext2fs_group_first_block2(fs, group);
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
@@ -78,20 +71,11 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 		old_desc_blocks = 
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
-	if (group == fs->group_desc_count-1) {
-		numblocks = (fs->super->s_blocks_count -
-			     fs->super->s_first_data_block) %
-			fs->super->s_blocks_per_group;
-		if (!numblocks)
-			numblocks = fs->super->s_blocks_per_group;
-	} else
-		numblocks = fs->super->s_blocks_per_group;
-
 	has_super = ext2fs_bg_has_super(fs, group);
 
 	if (has_super) {
 		super_blk = group_block;
-		numblocks--;
+		numblocks++;
 	}
 	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	meta_bg = group / meta_bg_size;
@@ -100,7 +84,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 	    (meta_bg < fs->super->s_first_meta_bg)) {
 		if (has_super) {
 			old_desc_blk = group_block + 1;
-			numblocks -= old_desc_blocks;
+			numblocks += old_desc_blocks;
 		}
 	} else {
 		if (((group % meta_bg_size) == 0) ||
@@ -109,11 +93,9 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 			if (has_super)
 				has_super = 1;
 			new_desc_blk = group_block + has_super;
-			numblocks--;
+			numblocks++;
 		}
 	}
-		
-	numblocks -= 2 + fs->inode_blocks_per_group;
 
 	if (ret_super_blk)
 		*ret_super_blk = super_blk;
@@ -126,6 +108,56 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 	return (numblocks);
 }
 
+/*
+ * This function returns the location of the superblock, block group
+ * descriptors for a given block group.  It currently returns the
+ * number of free blocks assuming that inode table and allocation
+ * bitmaps will be in the group.  This is not necessarily the case
+ * when the flex_bg feature is enabled, so callers should take care!
+ * It was only really intended for use by mke2fs, and even there it's
+ * not that useful.
+ *
+ * The ext2fs_super_and_bgd_loc2() function is 64-bit block number
+ * capable and returns the number of blocks used by super block and
+ * group descriptors.
+ */
+int ext2fs_super_and_bgd_loc(ext2_filsys fs,
+			     dgrp_t group,
+			     blk_t *ret_super_blk,
+			     blk_t *ret_old_desc_blk,
+			     blk_t *ret_new_desc_blk,
+			     int *ret_meta_bg)
+{
+	int ret;
+	blk64_t ret_super_blk2;
+	blk64_t ret_old_desc_blk2;
+	blk64_t ret_new_desc_blk2;
+	blk_t numblocks;
+
+	ret = ext2fs_super_and_bgd_loc2(fs, group, &ret_super_blk2,
+					&ret_old_desc_blk2, &ret_new_desc_blk2,
+					ret_meta_bg);
+
+	if (group == fs->group_desc_count-1) {
+		numblocks = (fs->super->s_blocks_count -
+			     fs->super->s_first_data_block) %
+			fs->super->s_blocks_per_group;
+		if (!numblocks)
+			numblocks = fs->super->s_blocks_per_group;
+	} else
+		numblocks = fs->super->s_blocks_per_group;
+
+	if (ret_super_blk)
+		*ret_super_blk = (blk_t)ret_super_blk2;
+	if (ret_old_desc_blk)
+		*ret_old_desc_blk = (blk_t)ret_old_desc_blk2;
+	if (ret_new_desc_blk)
+		*ret_new_desc_blk = (blk_t)ret_new_desc_blk2;
+
+	numblocks -= 2 + fs->inode_blocks_per_group + ret;
+
+	return numblocks;
+}
 
 /*
  * This function forces out the primary superblock.  We need to only
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ed99901..f06581c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -707,6 +707,12 @@ extern errcode_t ext2fs_check_desc(ext2_filsys fs);
 extern errcode_t ext2fs_close(ext2_filsys fs);
 extern errcode_t ext2fs_flush(ext2_filsys fs);
 extern int ext2fs_bg_has_super(ext2_filsys fs, int group_block);
+extern int ext2fs_super_and_bgd_loc2(ext2_filsys fs,
+				    dgrp_t group,
+				    blk64_t *ret_super_blk,
+				    blk64_t *ret_old_desc_blk,
+				    blk64_t *ret_new_desc_blk,
+				    int *ret_meta_bg);
 extern int ext2fs_super_and_bgd_loc(ext2_filsys fs, 
 				    dgrp_t group,
 				    blk_t *ret_super_blk,

