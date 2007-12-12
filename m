From: akpm@linux-foundation.org
Subject: + ext-use-ext_get_group_desc.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:28:26 -0800
Message-ID: <200712120528.lBC5SQMb027468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext[234]: use ext[234]_get_group_desc()
has been added to the -mm tree.  Its filename is
     ext-use-ext_get_group_desc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext[234]: use ext[234]_get_group_desc()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext[234]_get_group_desc() to get group descriptor from group number.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |   12 ++++--------
 fs/ext3/super.c |   13 ++++---------
 fs/ext4/super.c |   14 ++++----------
 3 files changed, 12 insertions(+), 27 deletions(-)

diff -puN fs/ext2/super.c~ext-use-ext_get_group_desc fs/ext2/super.c
--- a/fs/ext2/super.c~ext-use-ext_get_group_desc
+++ a/fs/ext2/super.c
@@ -617,27 +617,24 @@ static int ext2_setup_super (struct supe
 	return res;
 }
 
-static int ext2_check_descriptors (struct super_block * sb)
+static int ext2_check_descriptors(struct super_block *sb)
 {
 	int i;
-	int desc_block = 0;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	unsigned long first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
 	unsigned long last_block;
-	struct ext2_group_desc * gdp = NULL;
 
 	ext2_debug ("Checking group descriptors");
 
-	for (i = 0; i < sbi->s_groups_count; i++)
-	{
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		struct ext2_group_desc *gdp = ext2_get_group_desc(sb, i, NULL);
+
 		if (i == sbi->s_groups_count - 1)
 			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
 		else
 			last_block = first_block +
 				(EXT2_BLOCKS_PER_GROUP(sb) - 1);
 
-		if ((i % EXT2_DESC_PER_BLOCK(sb)) == 0)
-			gdp = (struct ext2_group_desc *) sbi->s_group_desc[desc_block++]->b_data;
 		if (le32_to_cpu(gdp->bg_block_bitmap) < first_block ||
 		    le32_to_cpu(gdp->bg_block_bitmap) > last_block)
 		{
@@ -667,7 +664,6 @@ static int ext2_check_descriptors (struc
 			return 0;
 		}
 		first_block += EXT2_BLOCKS_PER_GROUP(sb);
-		gdp++;
 	}
 	return 1;
 }
diff -puN fs/ext3/super.c~ext-use-ext_get_group_desc fs/ext3/super.c
--- a/fs/ext3/super.c~ext-use-ext_get_group_desc
+++ a/fs/ext3/super.c
@@ -1252,28 +1252,24 @@ static int ext3_setup_super(struct super
 }
 
 /* Called at mount-time, super-block is locked */
-static int ext3_check_descriptors (struct super_block * sb)
+static int ext3_check_descriptors(struct super_block *sb)
 {
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	ext3_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
 	ext3_fsblk_t last_block;
-	struct ext3_group_desc * gdp = NULL;
-	int desc_block = 0;
 	int i;
 
 	ext3_debug ("Checking group descriptors");
 
-	for (i = 0; i < sbi->s_groups_count; i++)
-	{
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		struct ext3_group_desc *gdp = ext3_get_group_desc(sb, i, NULL);
+
 		if (i == sbi->s_groups_count - 1)
 			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
 		else
 			last_block = first_block +
 				(EXT3_BLOCKS_PER_GROUP(sb) - 1);
 
-		if ((i % EXT3_DESC_PER_BLOCK(sb)) == 0)
-			gdp = (struct ext3_group_desc *)
-					sbi->s_group_desc[desc_block++]->b_data;
 		if (le32_to_cpu(gdp->bg_block_bitmap) < first_block ||
 		    le32_to_cpu(gdp->bg_block_bitmap) > last_block)
 		{
@@ -1306,7 +1302,6 @@ static int ext3_check_descriptors (struc
 			return 0;
 		}
 		first_block += EXT3_BLOCKS_PER_GROUP(sb);
-		gdp++;
 	}
 
 	sbi->s_es->s_free_blocks_count=cpu_to_le32(ext3_count_free_blocks(sb));
diff -puN fs/ext4/super.c~ext-use-ext_get_group_desc fs/ext4/super.c
--- a/fs/ext4/super.c~ext-use-ext_get_group_desc
+++ a/fs/ext4/super.c
@@ -1447,7 +1447,7 @@ int ext4_group_desc_csum_verify(struct e
 }
 
 /* Called at mount-time, super-block is locked */
-static int ext4_check_descriptors (struct super_block * sb)
+static int ext4_check_descriptors(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
@@ -1455,8 +1455,6 @@ static int ext4_check_descriptors (struc
 	ext4_fsblk_t block_bitmap;
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
-	struct ext4_group_desc * gdp = NULL;
-	int desc_block = 0;
 	int flexbg_flag = 0;
 	ext4_grpnum_t i;
 
@@ -1465,17 +1463,15 @@ static int ext4_check_descriptors (struc
 
 	ext4_debug ("Checking group descriptors");
 
-	for (i = 0; i < sbi->s_groups_count; i++)
-	{
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, i, NULL);
+
 		if (i == sbi->s_groups_count - 1 || flexbg_flag)
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
 				(EXT4_BLOCKS_PER_GROUP(sb) - 1);
 
-		if ((i % EXT4_DESC_PER_BLOCK(sb)) == 0)
-			gdp = (struct ext4_group_desc *)
-					sbi->s_group_desc[desc_block++]->b_data;
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block)
 		{
@@ -1513,8 +1509,6 @@ static int ext4_check_descriptors (struc
 		}
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
-		gdp = (struct ext4_group_desc *)
-			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
 
 	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-net.patch
git-battery.patch
fs-use-hlist_unhashed.patch
fs-use-list_for_each_entry_reverse-and-kill-sb_entry.patch
ext-fix-comment-for-nonexistent-variable.patch
ext-use-ext_get_group_desc.patch
ext-remove-unused-argument-for-ext_find_goal.patch
