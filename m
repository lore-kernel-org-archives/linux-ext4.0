From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v5 01/15] ext4: add a function which extends a group without checking parameters
Date: Fri, 23 Dec 2011 16:14:51 +0800
Message-ID: <1324628105-32559-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47423 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1LWLw5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Dec 2011 06:52:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so15005525iae.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Dec 2011 03:52:57 -0800 (PST)
In-Reply-To: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch added a function named ext4_group_extend_no_check() whose code
is copied from ext4_group_extend().  ext4_group_extend_no_check() assumes
the parameter is valid and has been checked by caller.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 996780a..ac5565c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -969,6 +969,59 @@ exit_put:
 } /* ext4_group_add */
 
 /*
+ * extend a group without checking assuming that checking has been done.
+ */
+static int ext4_group_extend_no_check(struct super_block *sb,
+			ext4_fsblk_t o_blocks_count, ext4_grpblk_t add)
+{
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	handle_t *handle;
+	int err = 0, err2;
+
+	/* We will update the superblock, one block bitmap, and
+	 * one group descriptor via ext4_group_add_blocks().
+	 */
+	handle = ext4_journal_start_sb(sb, 3);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		ext4_warning(sb, "error %d on journal start", err);
+		goto out;
+	}
+
+	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
+	if (err) {
+		ext4_warning(sb, "error %d on journal write access", err);
+		ext4_journal_stop(handle);
+		goto out;
+	}
+
+	ext4_blocks_count_set(es, o_blocks_count + add);
+	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
+		   o_blocks_count + add);
+	/* We add the blocks to the bitmap and set the group need init bit */
+	err = ext4_group_add_blocks(handle, sb, o_blocks_count, add);
+	if (err)
+		goto exit_journal;
+	ext4_handle_dirty_super(handle, sb);
+	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
+		   o_blocks_count + add);
+exit_journal:
+	err2 = ext4_journal_stop(handle);
+	if (err2 && !err)
+		err = err2;
+
+	if (!err) {
+		if (test_opt(sb, DEBUG))
+			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
+			       "blocks\n", ext4_blocks_count(es));
+		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
+			       sizeof(struct ext4_super_block));
+	}
+out:
+	return err;
+}
+
+/*
  * Extend the filesystem to the new number of blocks specified.  This entry
  * point is only used to extend the current filesystem to the end of the last
  * existing group.  It can be accessed via ioctl, or by "remount,resize=<size>"
-- 
1.7.5.1

