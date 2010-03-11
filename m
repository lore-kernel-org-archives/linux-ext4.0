From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix io-barrier logic for external journal case
Date: Thu, 11 Mar 2010 18:40:30 +0300
Message-ID: <87wrxij28h.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64955 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab0CKPke (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 10:40:34 -0500
Received: by bwz1 with SMTP id 1so152375bwz.21
        for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 07:40:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have to submit barrier before we start journal commit process.
otherwise transaction may be committed before data flushed to disk.
There is no difference from performance of view, but definitely
fsync becomes more correct.

If jbd2_log_start_commit return 0 then it means that transaction
was already committed. So we don't have to issue barrier for
ordered mode, because it was already done during commit.

By unknown reason we ignored ret val from jbd2_log_wait_commit()
so even in case of EIO fsync will succeed.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..621a8ed 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -88,21 +88,19 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		return ext4_force_commit(inode->i_sb);
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (jbd2_log_start_commit(journal, commit_tid)) {
-		/*
-		 * When the journal is on a different device than the
-		 * fs data disk, we need to issue the barrier in
-		 * writeback mode.  (In ordered mode, the jbd2 layer
-		 * will take care of issuing the barrier.  In
-		 * data=journal, all of the data blocks are written to
-		 * the journal device.)
-		 */
-		if (ext4_should_writeback_data(inode) &&
-		    (journal->j_fs_dev != journal->j_dev) &&
-		    (journal->j_flags & JBD2_BARRIER))
-			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-		jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
+	/*
+	 * When the journal is on a different device than the
+	 * fs data disk, we need to issue the barrier in
+	 * writeback mode.  (In ordered mode, the jbd2 layer
+	 * will take care of issuing the barrier.  In
+	 * data=journal, all of the data blocks are written to
+	 * the journal device.)
+	 */
+	if (ext4_should_writeback_data(inode) &&
+		(journal->j_fs_dev != journal->j_dev) &&
+		(journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+	if (jbd2_log_start_commit(journal, commit_tid))
+		ret = jbd2_log_wait_commit(journal, commit_tid);
 	return ret;
 }
-- 
1.6.6

