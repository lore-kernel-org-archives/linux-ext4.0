From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH V7 02/12] ext4: add a function which adds a new group descriptors to a fs
Date: Wed,  4 Jan 2012 00:07:24 -0500
Message-ID: <1325653654-10478-3-git-send-email-tytso@mit.edu>
References: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50285 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2ADFHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:07:35 -0500
In-Reply-To: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch adds a function named ext4_add_new_descs() which adds one
or more new group descriptors to a fs and whose code is copied from
ext4_group_add().

The function will be used by new resize implementation.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 1c3c2b5..3bb4e7b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -735,6 +735,52 @@ exit_err:
 	}
 }
 
+/*
+ * ext4_add_new_descs() adds @count group descriptor of groups
+ * starting at @group
+ *
+ * @handle: journal handle
+ * @sb: super block
+ * @group: the group no. of the first group desc to be added
+ * @resize_inode: the resize inode
+ * @count: number of group descriptors to be added
+ */
+static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
+			      ext4_group_t group, struct inode *resize_inode,
+			      ext4_group_t count)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	struct buffer_head *gdb_bh;
+	int i, gdb_off, gdb_num, err = 0;
+
+	for (i = 0; i < count; i++, group++) {
+		int reserved_gdb = ext4_bg_has_super(sb, group) ?
+			le16_to_cpu(es->s_reserved_gdt_blocks) : 0;
+
+		gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
+		gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+
+		/*
+		 * We will only either add reserved group blocks to a backup group
+		 * or remove reserved blocks for the first group in a new group block.
+		 * Doing both would be mean more complex code, and sane people don't
+		 * use non-sparse filesystems anymore.  This is already checked above.
+		 */
+		if (gdb_off) {
+			gdb_bh = sbi->s_group_desc[gdb_num];
+			err = ext4_journal_get_write_access(handle, gdb_bh);
+
+			if (!err && reserved_gdb && ext4_bg_num_gdb(sb, group))
+				err = reserve_backup_gdb(handle, resize_inode, group);
+		} else
+			err = add_new_gdb(handle, resize_inode, group);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 /* Add group descriptor data to an existing or new group descriptor block.
  * Ensure we handle all possible error conditions _before_ we start modifying
  * the filesystem, because we cannot abort the transaction and not have it
-- 
1.7.8.11.gefc1f.dirty

