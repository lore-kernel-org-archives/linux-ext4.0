From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH V7 07/12] ext4: pass verify_reserved_gdb() the number of group decriptors
Date: Wed,  4 Jan 2012 00:07:29 -0500
Message-ID: <1325653654-10478-8-git-send-email-tytso@mit.edu>
References: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50281 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab2ADFHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:07:35 -0500
In-Reply-To: <1325653654-10478-1-git-send-email-tytso@mit.edu>
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
index eb0aebc..12eace0 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -656,10 +656,10 @@ static unsigned ext4_list_backups(struct super_block *sb, unsigned *three,
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
@@ -734,7 +734,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	if (!gdb_bh)
 		return -EIO;
 
-	gdbackups = verify_reserved_gdb(sb, gdb_bh);
+	gdbackups = verify_reserved_gdb(sb, group, gdb_bh);
 	if (gdbackups < 0) {
 		err = gdbackups;
 		goto exit_bh;
@@ -897,7 +897,8 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
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
1.7.8.11.gefc1f.dirty

