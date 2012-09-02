From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] ext4: when resizing, do not copy gdt blocks for groups that do not have them
Date: Sun,  2 Sep 2012 00:51:21 -0400
Message-ID: <1346561485-6413-2-git-send-email-tytso@mit.edu>
References: <1346561485-6413-1-git-send-email-tytso@mit.edu>
Cc: xiaoqiangnk@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
	stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48371 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2IBHgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Sep 2012 03:36:33 -0400
In-Reply-To: <1346561485-6413-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

The resize code was copying blocks at the beginning of each block
group in order to copy the superblock and block group descriptor table
(gdt) blocks.  This was, unfortunately, being done even for block
groups that did not have super blocks or gdt blocks.  This is a
complete waste of perfectly good I/O bandwidth, to skip writing those
blocks for sparse bg's.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/resize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 41f6ef6..724e250 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -451,6 +451,9 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
 
+		if (!ext4_bg_has_super(sb, group))
+			goto handle_itb;
+
 		/* Copy all of the GDT blocks into the backup in this group */
 		for (j = 0, block = start + 1; j < gdblocks; j++, block++) {
 			struct buffer_head *gdb;
@@ -493,6 +496,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 				goto out;
 		}
 
+handle_itb:
 		/* Initialize group tables of the grop @group */
 		if (!(bg_flags[i] & EXT4_BG_INODE_ZEROED))
 			goto handle_bb;
-- 
1.7.12.rc0.22.gcdd159b

