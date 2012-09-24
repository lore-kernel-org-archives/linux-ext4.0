From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Only call update_backups if necessary in online resize.
Date: Mon, 24 Sep 2012 23:00:17 +0800
Message-ID: <1348498817-3598-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:40529 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754683Ab2IXPDH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 11:03:07 -0400
Received: from [111.193.1.206] (port=47052 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TGABY-0000QL-Bc
	for linux-ext4@vger.kernel.org; Mon, 24 Sep 2012 09:03:04 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Now in online resize, we will add a bunch of groups at one time in
ext4_flex_group_add, so in most cases a lot of group descriptors
will be in the same group block. But in the end of this function,
update_backups will be called for every group descriptor and the
same block will be copied and journalled again and again.
It is really a waste.

So add a old_gdb to store the group block we have already done
the backup and skip the backup until we meet with a new group block.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/resize.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 019d528..ae2f5fc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1348,6 +1348,7 @@ exit_journal:
 
 	if (!err) {
 		int i;
+		sector_t old_gdb = 0;
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
 			       sizeof(struct ext4_super_block));
 		for (i = 0; i < flex_gd->count; i++, group++) {
@@ -1355,8 +1356,16 @@ exit_journal:
 			int gdb_num;
 			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
 			gdb_bh = sbi->s_group_desc[gdb_num];
-			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
-				       gdb_bh->b_size);
+			/*
+			 * only backup the group descriptor block
+			 * which hasn't been updated before.
+			 */
+			if (old_gdb != gdb_bh->b_blocknr) {
+				update_backups(sb, gdb_bh->b_blocknr,
+					       gdb_bh->b_data,
+					       gdb_bh->b_size);
+				old_gdb = gdb_bh->b_blocknr;
+			}
 		}
 	}
 exit:
-- 
1.7.1

