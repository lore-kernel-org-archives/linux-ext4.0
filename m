From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/3] ext2: use ext2_group_first_block_no()
Date: Sun, 17 Feb 2008 14:57:51 +0900
Message-ID: <20080217055750.GB3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:35390 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYBQGEK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:04:10 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2073557wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:04:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext2_group_first_block_no() and assign the return values to
ext2_fsblk_t variables.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext2/inode.c |    3 +--
 fs/ext2/super.c |   11 +++++------
 fs/ext2/xattr.c |    6 ++----
 3 files changed, 8 insertions(+), 12 deletions(-)

Index: 2.6-rc/fs/ext2/super.c
===================================================================
--- 2.6-rc.orig/fs/ext2/super.c
+++ 2.6-rc/fs/ext2/super.c
@@ -622,13 +622,13 @@ static int ext2_check_descriptors(struct
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
@@ -664,7 +664,6 @@ static int ext2_check_descriptors(struct
 				    i, (unsigned long) le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
-		first_block += EXT2_BLOCKS_PER_GROUP(sb);
 	}
 	return 1;
 }
@@ -721,10 +720,9 @@ static unsigned long descriptor_loc(stru
 				    int nr)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
-	unsigned long bg, first_data_block, first_meta_bg;
+	unsigned long bg, first_meta_bg;
 	int has_super = 0;
 	
-	first_data_block = le32_to_cpu(sbi->s_es->s_first_data_block);
 	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
 
 	if (!EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -733,7 +731,8 @@ static unsigned long descriptor_loc(stru
 	bg = sbi->s_desc_per_block * nr;
 	if (ext2_bg_has_super(sb, bg))
 		has_super = 1;
-	return (first_data_block + has_super + (bg * sbi->s_blocks_per_group));
+
+	return ext2_group_first_block_no(sb, bg) + has_super;
 }
 
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
Index: 2.6-rc/fs/ext2/inode.c
===================================================================
--- 2.6-rc.orig/fs/ext2/inode.c
+++ 2.6-rc/fs/ext2/inode.c
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
Index: 2.6-rc/fs/ext2/xattr.c
===================================================================
--- 2.6-rc.orig/fs/ext2/xattr.c
+++ 2.6-rc/fs/ext2/xattr.c
@@ -660,10 +660,8 @@ ext2_xattr_set2(struct inode *inode, str
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
