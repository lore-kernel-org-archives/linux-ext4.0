From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v5 10/15] ext4: pass verify_reserved_gdb() the number of group decriptors
Date: Fri, 23 Dec 2011 16:15:00 +0800
Message-ID: <1324628105-32559-11-git-send-email-xiaoqiangnk@gmail.com>
References: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47472 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab1LWLxR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Dec 2011 06:53:17 -0500
Received: by mail-tul01m020-f174.google.com with SMTP id wo16so4941593obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Dec 2011 03:53:17 -0800 (PST)
In-Reply-To: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

The 64bit resizer adds a flex group each time, so verify_reserved_gdb
can not use s_groups_count directly, it should use the number of group
decriptors before the added group.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index fdce84c..f368190 100644
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

