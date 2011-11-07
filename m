From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 10/15] ext4: pass verify_reserved_gdb() the number of group decriptors
Date: Tue,  8 Nov 2011 07:13:23 +0800
Message-ID: <1320707608-14246-11-git-send-email-xiaoqiangnk@gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1KHB2i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 20:28:38 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6468027iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 17:28:37 -0800 (PST)
In-Reply-To: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The 64bit resizer adds a flex group each time, so verify_reserved_gdb
can not use s_groups_count directly, it should use the number of group
decriptors before the added group.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index fef0768..34791cb 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -624,10 +624,10 @@ static unsigned ext4_list_backups(struct super_block *sb, unsigned *three,
  * groups in current filesystem that have BACKUPS, or -ve error code.
  */
 static int verify_reserved_gdb(struct super_block *sb,
+			       ext4_group_t end,
 			       struct buffer_head *primary)
 {
 	const ext4_fsblk_t blk = primary->b_blocknr;
-	const ext4_group_t end = EXT4_SB(sb)->s_groups_count;
 	unsigned three = 1;
 	unsigned five = 5;
 	unsigned seven = 7;
@@ -702,7 +702,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	if (!gdb_bh)
 		return -EIO;
 
-	gdbackups = verify_reserved_gdb(sb, gdb_bh);
+	gdbackups = verify_reserved_gdb(sb, group, gdb_bh);
 	if (gdbackups < 0) {
 		err = gdbackups;
 		goto exit_bh;
@@ -865,7 +865,8 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 			err = -EIO;
 			goto exit_bh;
 		}
-		if ((gdbackups = verify_reserved_gdb(sb, primary[res])) < 0) {
+		gdbackups = verify_reserved_gdb(sb, group, primary[res]);
+		if (gdbackups < 0) {
 			brelse(primary[res]);
 			err = gdbackups;
 			goto exit_bh;
-- 
1.7.5.1

