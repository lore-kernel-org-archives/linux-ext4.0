From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Sun, 29 Mar 2009 19:28:13 +0200
Message-ID: <200903291928.14451.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:52378 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZC2RaN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Mar 2009 13:30:13 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
command execution) so its users should check for the return value.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/ext4/fsync.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: b/fs/ext4/fsync.c
===================================================================
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -48,7 +48,7 @@ int ext4_sync_file(struct file *file, st
 {
 	struct inode *inode = dentry->d_inode;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret = 0;
+	int ret = 0, tmp_ret;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -92,8 +92,11 @@ int ext4_sync_file(struct file *file, st
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
-		if (journal && (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		if (journal && (journal->j_flags & JBD2_BARRIER)) {
+			tmp_ret = blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+			if (ret == 0 && tmp_ret < 0 && tmp_ret != -EOPNOTSUPP)
+				ret = tmp_ret;
+		}
 	}
 out:
 	return ret;
