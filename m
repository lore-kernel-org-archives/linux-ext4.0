From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 01/15] ext4: add a function which extends a group without checking parameters
Date: Tue, 30 Aug 2011 16:10:11 +0800
Message-ID: <1314691825-12295-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33594 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1H3Ixp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 04:53:45 -0400
Received: by gya6 with SMTP id 6so5445483gya.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 01:53:44 -0700 (PDT)
In-Reply-To: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch added a function named __ext4_group_extend() whose code
is copied from ext4_group_extend().  __ext4_group_extend() assumes
the parameter is valid and has been checked by caller.

__ext4_group_extend() will be used by new resize implementation. It
can also be used by ext4_group_extend(), but this patch series does
not do this.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 707d3f1..5126aac 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -969,6 +969,59 @@ exit_put:
 } /* ext4_group_add */
 
 /*
+ * extend a group without checking assuming that checking has been done.
+ */
+static int __ext4_group_extend(struct super_block *sb,
+			       ext4_fsblk_t o_blocks_count, ext4_grpblk_t add)
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

