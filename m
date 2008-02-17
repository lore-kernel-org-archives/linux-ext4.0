From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/4] ext3: use ext3_group_first_block_no()
Date: Sun, 17 Feb 2008 15:02:06 +0900
Message-ID: <20080217060205.GD3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:45040 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYBQGIY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:08:24 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2074812wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:08:24 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext3_group_first_block_no()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
---
 fs/ext3/super.c |    5 ++---
 fs/ext3/xattr.c |    6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

Index: 2.6-rc/fs/ext3/super.c
===================================================================
--- 2.6-rc.orig/fs/ext3/super.c
+++ 2.6-rc/fs/ext3/super.c
@@ -1253,14 +1253,14 @@ static int ext3_setup_super(struct super
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
@@ -1299,7 +1299,6 @@ static int ext3_check_descriptors(struct
 					le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
-		first_block += EXT3_BLOCKS_PER_GROUP(sb);
 	}
 
 	sbi->s_es->s_free_blocks_count=cpu_to_le32(ext3_count_free_blocks(sb));
Index: 2.6-rc/fs/ext3/xattr.c
===================================================================
--- 2.6-rc.orig/fs/ext3/xattr.c
+++ 2.6-rc/fs/ext3/xattr.c
@@ -797,10 +797,8 @@ inserted:
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
