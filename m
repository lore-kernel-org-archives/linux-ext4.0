From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 12/12] ext4: simplify parameters of reserve_backup_gdb()
Date: Mon, 18 Jul 2011 10:52:35 +0800
Message-ID: <1310957555-15617-13-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1GRC5N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:57:13 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so2719031iwn.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:57:12 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

reserve_backup_gdb() only needs the no. of a group, there is no need to pass
a pointer to struct ext4_new_group_data to it.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 52d0426..3e790ad 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -556,7 +556,7 @@ exit_bh:
  * backup GDT blocks are stored in their reserved primary GDT block.
  */
 static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
-			      struct ext4_new_group_data *input)
+			      ext4_group_t group)
 {
 	struct super_block *sb = inode->i_sb;
 	int reserved_gdb =le16_to_cpu(EXT4_SB(sb)->s_es->s_reserved_gdt_blocks);
@@ -627,7 +627,7 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	 * Finally we can add each of the reserved backup GDT blocks from
 	 * the new group to its reserved primary GDT block.
 	 */
-	blk = input->group * EXT4_BLOCKS_PER_GROUP(sb);
+	blk = group * EXT4_BLOCKS_PER_GROUP(sb);
 	for (i = 0; i < reserved_gdb; i++) {
 		int err2;
 		data = (__le32 *)primary[i]->b_data;
@@ -841,9 +841,11 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 		if ((err = ext4_journal_get_write_access(handle, primary)))
 			goto exit_journal;
 
-		if (reserved_gdb && ext4_bg_num_gdb(sb, input->group) &&
-		    (err = reserve_backup_gdb(handle, inode, input)))
-			goto exit_journal;
+		if (reserved_gdb && ext4_bg_num_gdb(sb, input->group)) {
+			err = reserve_backup_gdb(handle, inode, input->group);
+			if (err)
+				goto exit_journal;
+		}
 	} else {
 		err = add_new_gdb(handle, inode, input->group);
 		if (err)
-- 
1.7.5.1

