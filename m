From: akpm@linux-foundation.org
Subject: - ext2-use-ext2_group_first_block_no.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:18 -0700
Message-ID: <200804282200.m3SM0IAB018682@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965567AbYD1WAV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: use ext2_group_first_block_no()
has been removed from the -mm tree.  Its filename was
     ext2-use-ext2_group_first_block_no.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: use ext2_group_first_block_no()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext2_group_first_block_no() and assign the return values to
ext2_fsblk_t variables.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    3 +--
 fs/ext2/super.c |   11 +++++------
 fs/ext2/xattr.c |    6 ++----
 3 files changed, 8 insertions(+), 12 deletions(-)

diff -puN fs/ext2/inode.c~ext2-use-ext2_group_first_block_no fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-use-ext2_group_first_block_no
+++ a/fs/ext2/inode.c
@@ -275,8 +275,7 @@ static unsigned long ext2_find_near(stru
 	 * It is going to be refered from inode itself? OK, just put it into
 	 * the same cylinder group then.
 	 */
-	bg_start = (ei->i_block_group * EXT2_BLOCKS_PER_GROUP(inode->i_sb)) +
-		le32_to_cpu(EXT2_SB(inode->i_sb)->s_es->s_first_data_block);
+	bg_start = ext2_group_first_block_no(inode->i_sb, ei->i_block_group);
 	colour = (current->pid % 16) *
 			(EXT2_BLOCKS_PER_GROUP(inode->i_sb) / 16);
 	return bg_start + colour;
diff -puN fs/ext2/super.c~ext2-use-ext2_group_first_block_no fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-use-ext2_group_first_block_no
+++ a/fs/ext2/super.c
@@ -621,13 +621,13 @@ static int ext2_check_descriptors(struct
 {
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	unsigned long first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
-	unsigned long last_block;
 
 	ext2_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		struct ext2_group_desc *gdp = ext2_get_group_desc(sb, i, NULL);
+		ext2_fsblk_t first_block = ext2_group_first_block_no(sb, i);
+		ext2_fsblk_t last_block;
 
 		if (i == sbi->s_groups_count - 1)
 			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
@@ -663,7 +663,6 @@ static int ext2_check_descriptors(struct
 				    i, (unsigned long) le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
-		first_block += EXT2_BLOCKS_PER_GROUP(sb);
 	}
 	return 1;
 }
@@ -720,10 +719,9 @@ static unsigned long descriptor_loc(stru
 				    int nr)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	unsigned long bg, first_data_block, first_meta_bg;
+	unsigned long bg, first_meta_bg;
 	int has_super = 0;
 	
-	first_data_block = le32_to_cpu(sbi->s_es->s_first_data_block);
 	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
 
 	if (!EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -732,7 +730,8 @@ static unsigned long descriptor_loc(stru
 	bg = sbi->s_desc_per_block * nr;
 	if (ext2_bg_has_super(sb, bg))
 		has_super = 1;
-	return (first_data_block + has_super + (bg * sbi->s_blocks_per_group));
+
+	return ext2_group_first_block_no(sb, bg) + has_super;
 }
 
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
diff -puN fs/ext2/xattr.c~ext2-use-ext2_group_first_block_no fs/ext2/xattr.c
--- a/fs/ext2/xattr.c~ext2-use-ext2_group_first_block_no
+++ a/fs/ext2/xattr.c
@@ -659,10 +659,8 @@ ext2_xattr_set2(struct inode *inode, str
 			ext2_xattr_cache_insert(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			int goal = le32_to_cpu(EXT2_SB(sb)->s_es->
-						           s_first_data_block) +
-				   EXT2_I(inode)->i_block_group *
-				   EXT2_BLOCKS_PER_GROUP(sb);
+			ext2_fsblk_t goal = ext2_group_first_block_no(sb,
+						EXT2_I(inode)->i_block_group);
 			int block = ext2_new_block(inode, goal, &error);
 			if (error)
 				goto cleanup;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

