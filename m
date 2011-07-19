From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 11/11] ext4: simplify parameters of reserve_backup_gdb()
Date: Tue, 19 Jul 2011 12:02:17 +0800
Message-ID: <1311048137-16400-12-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSEGw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:52 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so3703318iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:52 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

reserve_backup_gdb() only needs the no. of a group, there is no need to pass
a pointer to struct ext4_new_group_data to it.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

 v1->v2:
    nothing changed.

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7964ed9..19c217e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -546,7 +546,7 @@ exit_bh:
  * backup GDT blocks are stored in their reserved primary GDT block.
  */
 static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
-			      struct ext4_new_group_data *input)
+			      ext4_group_t group)
 {
 	struct super_block *sb = inode->i_sb;
 	int reserved_gdb =le16_to_cpu(EXT4_SB(sb)->s_es->s_reserved_gdt_blocks);
@@ -617,7 +617,7 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	 * Finally we can add each of the reserved backup GDT blocks from
 	 * the new group to its reserved primary GDT block.
 	 */
-	blk = input->group * EXT4_BLOCKS_PER_GROUP(sb);
+	blk = group * EXT4_BLOCKS_PER_GROUP(sb);
 	for (i = 0; i < reserved_gdb; i++) {
 		int err2;
 		data = (__le32 *)primary[i]->b_data;
@@ -831,9 +831,11 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
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
 		/*
 		 * Note that we can access new group descriptor block safely
-- 
1.7.5.1

