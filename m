From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Fix waiting on transaction during fsync
Date: Mon, 26 Apr 2010 22:10:59 +0200
Message-ID: <1272312659-16468-3-git-send-email-jack@suse.cz>
References: <1272312659-16468-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab0DZULI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 16:11:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 2CFC786EE4
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 22:11:08 +0200 (CEST)
In-Reply-To: <1272312659-16468-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

log_start_commit() returns 1 only when it started a transaction
commit. Thus in case transaction commit is already running, we
fail to wait for the commit to finish. Fix the issue by always
waiting for the commit regardless of the log_start_commit return
value.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/fsync.c  |   20 +++++++++-----------
 fs/jbd/journal.c |    2 +-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 8209f26..26289e8 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -48,7 +48,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	struct inode *inode = dentry->d_inode;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
-	int ret = 0;
+	int ret, needs_barrier = 0;
 	tid_t commit_tid;
 
 	if (inode->i_sb->s_flags & MS_RDONLY)
@@ -70,28 +70,26 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
 	 */
-	if (ext3_should_journal_data(inode)) {
-		ret = ext3_force_commit(inode->i_sb);
-		goto out;
-	}
+	if (ext3_should_journal_data(inode))
+		return ext3_force_commit(inode->i_sb);
 
 	if (datasync)
 		commit_tid = atomic_read(&ei->i_datasync_tid);
 	else
 		commit_tid = atomic_read(&ei->i_sync_tid);
 
-	if (log_start_commit(journal, commit_tid)) {
-		log_wait_commit(journal, commit_tid);
-		goto out;
-	}
+	if (test_opt(inode->i_sb, BARRIER) &&
+	    !journal_trans_will_send_data_barrier(journal, commit_tid))
+		needs_barrier = 1;
+	log_start_commit(journal, commit_tid);
+	ret = log_wait_commit(journal, commit_tid);
 
 	/*
 	 * In case we didn't commit a transaction, we have to flush
 	 * disk caches manually so that data really is on persistent
 	 * storage
 	 */
-	if (test_opt(inode->i_sb, BARRIER))
+	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-out:
 	return ret;
 }
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 99c7194..93d1e47 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -594,7 +594,7 @@ out:
 	spin_unlock(&journal->j_state_lock);
 	return ret;
 }
-EXPORT_SYMBOL(journal_commit_will_send_barrier);
+EXPORT_SYMBOL(journal_trans_will_send_data_barrier);
 
 /*
  * Log buffer allocation routines:
-- 
1.6.4.2

