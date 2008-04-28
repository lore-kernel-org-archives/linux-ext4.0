From: akpm@linux-foundation.org
Subject: - ext3-use-ext3_group_first_block_no.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:35 -0700
Message-ID: <200804282200.m3SM0ZqC018719@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965193AbYD1WAh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: use ext3_group_first_block_no()
has been removed from the -mm tree.  Its filename was
     ext3-use-ext3_group_first_block_no.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use ext3_group_first_block_no()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext3_group_first_block_no()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    5 ++---
 fs/ext3/xattr.c |    6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/ext3/super.c~ext3-use-ext3_group_first_block_no fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-use-ext3_group_first_block_no
+++ a/fs/ext3/super.c
@@ -1254,14 +1254,14 @@ static int ext3_setup_super(struct super
 static int ext3_check_descriptors(struct super_block *sb)
 {
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
-	ext3_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
-	ext3_fsblk_t last_block;
 	int i;
 
 	ext3_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		struct ext3_group_desc *gdp = ext3_get_group_desc(sb, i, NULL);
+		ext3_fsblk_t first_block = ext3_group_first_block_no(sb, i);
+		ext3_fsblk_t last_block;
 
 		if (i == sbi->s_groups_count - 1)
 			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
@@ -1300,7 +1300,6 @@ static int ext3_check_descriptors(struct
 					le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
-		first_block += EXT3_BLOCKS_PER_GROUP(sb);
 	}
 
 	sbi->s_es->s_free_blocks_count=cpu_to_le32(ext3_count_free_blocks(sb));
diff -puN fs/ext3/xattr.c~ext3-use-ext3_group_first_block_no fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-use-ext3_group_first_block_no
+++ a/fs/ext3/xattr.c
@@ -799,10 +799,8 @@ inserted:
 			get_bh(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			ext3_fsblk_t goal = le32_to_cpu(
-					EXT3_SB(sb)->s_es->s_first_data_block) +
-				(ext3_fsblk_t)EXT3_I(inode)->i_block_group *
-				EXT3_BLOCKS_PER_GROUP(sb);
+			ext3_fsblk_t goal = ext3_group_first_block_no(sb,
+						EXT3_I(inode)->i_block_group);
 			ext3_fsblk_t block = ext3_new_block(handle, inode,
 							goal, &error);
 			if (error)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

