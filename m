From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: clean up error handling in swap_inode_boot_loader()
Date: Wed, 12 Feb 2014 11:56:51 -0500
Message-ID: <1392224211-23834-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57120 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaBLQ4y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 11:56:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tighten up the code to make the code easier to read and maintain.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ioctl.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a2a837f..0f2252e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -104,21 +104,15 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	struct ext4_inode_info *ei_bl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode)) {
-		err = -EINVAL;
-		goto swap_boot_out;
-	}
+	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode))
+		return -EINVAL;
 
-	if (!inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto swap_boot_out;
-	}
+	if (!inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
 	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
-	if (IS_ERR(inode_bl)) {
-		err = PTR_ERR(inode_bl);
-		goto swap_boot_out;
-	}
+	if (IS_ERR(inode_bl))
+		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
 
 	filemap_flush(inode->i_mapping);
@@ -193,20 +187,14 @@ static long swap_inode_boot_loader(struct super_block *sb,
 			ext4_mark_inode_dirty(handle, inode);
 		}
 	}
-
 	ext4_journal_stop(handle);
-
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
 journal_err_out:
 	ext4_inode_resume_unlocked_dio(inode);
 	ext4_inode_resume_unlocked_dio(inode_bl);
-
 	unlock_two_nondirectories(inode, inode_bl);
-
 	iput(inode_bl);
