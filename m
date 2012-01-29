From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/4] ext4: accelerate updating of backup gdb
Date: Mon, 30 Jan 2012 00:01:05 +0800
Message-ID: <1327852866-4448-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CVNle (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 09:41:34 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so3130313iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:41:34 -0700 (PDT)
In-Reply-To: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Updating of backup group descriptor blocks shoud done in the unit of
gdb, rather than group.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 58109fa..3999a19 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1290,15 +1290,18 @@ exit_journal:
 		err = err2;
 
 	if (!err) {
-		int i;
+		int gdb_num, gdb_num_end;
 		ext4_fsblk_t first_block;
+
 		first_block = ext4_group_first_block_no(sb, 0);
 		update_backups(sb, sbi->s_sbh->b_blocknr - first_block,
 			       (char *)es, sizeof(struct ext4_super_block));
-		for (i = 0; i < flex_gd->count; i++, group++) {
+
+		gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+		gdb_num_end = (group + flex_gd->count - 1) /
+			      EXT4_DESC_PER_BLOCK(sb);
+		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
-			int gdb_num;
-			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
 			gdb_bh = sbi->s_group_desc[gdb_num];
 			update_backups(sb, gdb_bh->b_blocknr - first_block,
 				       gdb_bh->b_data, gdb_bh->b_size);
-- 
1.7.5.1

