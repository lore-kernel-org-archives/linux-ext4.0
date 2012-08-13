From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: check return value of blkdev_issue_flush()
Date: Sun, 12 Aug 2012 23:38:41 -0400
Message-ID: <1344829121-23739-2-git-send-email-tytso@mit.edu>
References: <1344829121-23739-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44329 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2HMDip (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2012 23:38:45 -0400
In-Reply-To: <1344829121-23739-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkdev_issue_flush() can fail; make sure the error gets properly
propagated.

This is a port of the equivalent ext3 patch from commit 44f4f729e7a1.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2a1dcea..323eb15 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -203,7 +203,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret;
+	int ret, err;
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
@@ -255,8 +255,11 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		needs_barrier = true;
 	jbd2_log_start_commit(journal, commit_tid);
 	ret = jbd2_log_wait_commit(journal, commit_tid);
-	if (needs_barrier)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+	if (needs_barrier) {
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (!ret)
+			ret = err;
+	}
  out:
 	mutex_unlock(&inode->i_mutex);
 	trace_ext4_sync_file_exit(inode, ret);
-- 
1.7.12.rc0.22.gcdd159b

