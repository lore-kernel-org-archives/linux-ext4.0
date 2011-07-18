From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 09/12] ext4: simplify journal handling in ext4_setup_new_group_blocks
Date: Mon, 18 Jul 2011 10:52:32 +0800
Message-ID: <1310957555-15617-10-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65169 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1GRC5G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:57:06 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so2725572iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:57:06 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch simplifies journal handling in ext4_setup_new_group_blocks().


Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c91653c..ac5b63d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -171,8 +171,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
  * If that fails, restart the transaction & regain write access for the
  * buffer head which is used for block_bitmap modifications.
  */
-static int extend_or_restart_transaction(handle_t *handle, int thresh,
-					 struct buffer_head *bh)
+static int extend_or_restart_transaction(handle_t *handle, int thresh)
 {
 	int err;
 
@@ -183,9 +182,8 @@ static int extend_or_restart_transaction(handle_t *handle, int thresh,
 	if (err < 0)
 		return err;
 	if (err) {
-		if ((err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
-			return err;
-		if ((err = ext4_journal_get_write_access(handle, bh)))
+		err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA);
+		if (err)
 			return err;
 	}
 
@@ -222,29 +220,24 @@ static int setup_new_group_blocks(struct super_block *sb,
 
 	BUG_ON(input->group != sbi->s_groups_count);
 
-	if (IS_ERR(bh = bclean(handle, sb, input->block_bitmap))) {
-		err = PTR_ERR(bh);
-		goto exit_journal;
-	}
-
 	/* Copy all of the GDT blocks into the backup in this group */
 	for (i = 0, bit = 1, block = start + 1;
 	     i < gdblocks; i++, block++, bit++) {
 		struct buffer_head *gdb;
 
 		ext4_debug("update backup group %#04llx (+%d)\n", block, bit);
-
-		if ((err = extend_or_restart_transaction(handle, 1, bh)))
-			goto exit_bh;
+		err = extend_or_restart_transaction(handle, 1);
+		if (err)
+			goto exit_journal;
 
 		gdb = sb_getblk(sb, block);
 		if (!gdb) {
 			err = -EIO;
-			goto exit_bh;
+			goto exit_journal;
 		}
 		if ((err = ext4_journal_get_write_access(handle, gdb))) {
 			brelse(gdb);
-			goto exit_bh;
+			goto exit_journal;
 		}
 		lock_buffer(gdb);
 		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
@@ -253,7 +246,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 		err = ext4_handle_dirty_metadata(handle, NULL, gdb);
 		if (unlikely(err)) {
 			brelse(gdb);
-			goto exit_bh;
+			goto exit_journal;
 		}
 		brelse(gdb);
 	}
@@ -264,7 +257,17 @@ static int setup_new_group_blocks(struct super_block *sb,
 	err = sb_issue_zeroout(sb, gdblocks + start + 1, reserved_gdb,
 			       GFP_NOFS);
 	if (err)
-		goto exit_bh;
+		goto exit_journal;
+
+	err = extend_or_restart_transaction(handle, 2);
+	if (err)
+		goto exit_journal;
+
+	bh = bclean(handle, sb, input->block_bitmap);
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
+		goto exit_journal;
+	}
 
 	if (ext4_bg_has_super(sb, input->group)) {
 		ext4_debug("mark backup group tables %#04llx (+0)\n", start);
@@ -288,8 +291,6 @@ static int setup_new_group_blocks(struct super_block *sb,
 	ext4_set_bits(bh->b_data, input->inode_table - start,
 		      sbi->s_itb_per_group);
 
-	if ((err = extend_or_restart_transaction(handle, 2, bh)))
-		goto exit_bh;
 
 	ext4_mark_bitmap_end(input->blocks_count, sb->s_blocksize * 8,
 			     bh->b_data);
-- 
1.7.5.1

