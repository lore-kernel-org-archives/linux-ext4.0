From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/4] ext4: fix a bug in resize when first_data_block != 0
Date: Mon, 30 Jan 2012 00:01:04 +0800
Message-ID: <1327852866-4448-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2CVNlc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 09:41:32 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so3130313iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:41:32 -0700 (PDT)
In-Reply-To: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_group_first_block_no should be used to computer block offset and
first block no in group rather than group * block_per_group. Otherwise,
if first_data_block != 0, the result is wrong.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 9a6fb74..58109fa 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -956,7 +956,6 @@ static void update_backups(struct super_block *sb,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	const ext4_group_t last = sbi->s_groups_count;
-	const int bpg = EXT4_BLOCKS_PER_GROUP(sb);
 	unsigned three = 1;
 	unsigned five = 5;
 	unsigned seven = 7;
@@ -982,7 +981,8 @@ static void update_backups(struct super_block *sb,
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
 
-		bh = sb_getblk(sb, group * bpg + blk_off);
+		bh = sb_getblk(sb, ext4_group_first_block_no(sb, group) +
+				   blk_off);
 		if (!bh) {
 			err = -EIO;
 			break;
@@ -1291,15 +1291,17 @@ exit_journal:
 
 	if (!err) {
 		int i;
-		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block));
+		ext4_fsblk_t first_block;
+		first_block = ext4_group_first_block_no(sb, 0);
+		update_backups(sb, sbi->s_sbh->b_blocknr - first_block,
+			       (char *)es, sizeof(struct ext4_super_block));
 		for (i = 0; i < flex_gd->count; i++, group++) {
 			struct buffer_head *gdb_bh;
 			int gdb_num;
 			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
 			gdb_bh = sbi->s_group_desc[gdb_num];
-			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
-				       gdb_bh->b_size);
+			update_backups(sb, gdb_bh->b_blocknr - first_block,
+				       gdb_bh->b_data, gdb_bh->b_size);
 		}
 	}
 exit:
-- 
1.7.5.1

