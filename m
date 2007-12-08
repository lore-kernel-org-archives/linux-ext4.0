From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext[234]: use ext[234]_get_group_desc()
Date: Sun, 9 Dec 2007 00:34:53 +0900
Message-ID: <20071208153453.GC4878@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:61838 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLHPfn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2007 10:35:43 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1061474rvb
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2007 07:35:42 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext[234]_get_group_desc() to get group descriptor from group number.

Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: adilger@clusterfs.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>


---
 fs/ext2/super.c |   12 ++++--------
 fs/ext3/super.c |   13 ++++---------
 fs/ext4/super.c |   14 ++++----------
 3 files changed, 12 insertions(+), 27 deletions(-)

Index: 2.6-git/fs/ext2/super.c
===================================================================
--- 2.6-git.orig/fs/ext2/super.c
+++ 2.6-git/fs/ext2/super.c
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
Index: 2.6-git/fs/ext3/super.c
===================================================================
--- 2.6-git.orig/fs/ext3/super.c
+++ 2.6-git/fs/ext3/super.c
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
Index: 2.6-git/fs/ext4/super.c
===================================================================
--- 2.6-git.orig/fs/ext4/super.c
+++ 2.6-git/fs/ext4/super.c
@@ -1353,7 +1353,7 @@ int ext4_group_desc_csum_verify(struct e
 }
 
 /* Called at mount-time, super-block is locked */
-static int ext4_check_descriptors (struct super_block * sb)
+static int ext4_check_descriptors(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
@@ -1361,8 +1361,6 @@ static int ext4_check_descriptors (struc
 	ext4_fsblk_t block_bitmap;
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
-	struct ext4_group_desc * gdp = NULL;
-	int desc_block = 0;
 	int flexbg_flag = 0;
 	int i;
 
@@ -1371,17 +1369,15 @@ static int ext4_check_descriptors (struc
 
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
@@ -1420,8 +1416,6 @@ static int ext4_check_descriptors (struc
 		}
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
-		gdp = (struct ext4_group_desc *)
-			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
 
 	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
