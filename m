From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] jbd2: Fix sending of data flush on journal commit
Date: Mon, 23 May 2011 23:38:44 +0200
Message-ID: <1306186726-23430-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Edward Goggin <egoggin@vmware.com>,
	Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab1EWViw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 17:38:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It can theoretically happen, that in data=ordered mode inode is filed to
transaction's t_inode_list, then flusher thread writes all the data and
inode is reclaimed before transaction starts to commit. In such case we
could errorneously ommit sending a flush to filesystem device when it
is different from the journal device (because data can still be in disk
cache only).

Fix the problem by setting a flag in a transaction when some inode is added
to it and then send disk flush in the commit code when the flag is set.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c      |    3 +--
 fs/jbd2/transaction.c |    7 +++++++
 include/linux/jbd2.h  |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6e28000..8bd8790 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -219,7 +219,6 @@ static int journal_submit_data_buffers(journal_t *journal,
 			ret = err;
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
-		commit_transaction->t_flushed_data_blocks = 1;
 		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
 		smp_mb__after_clear_bit();
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
@@ -683,7 +682,7 @@ start_journal_io:
 	 * then we must flush the file system device before we issue
 	 * the commit record
 	 */
-	if (commit_transaction->t_flushed_data_blocks &&
+	if (commit_transaction->t_need_data_flush &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..7f70390 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2147,6 +2147,13 @@ int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
 	    jinode->i_next_transaction == transaction)
 		goto done;
 
+	/*
+	 * We only ever set this variable to 1 so the test is safe. Since
+	 * t_need_data_flush is likely to be set, we do the test to save some
+	 * cacheline bouncing
+	 */
+	if (!transaction->t_need_data_flush)
+		transaction->t_need_data_flush = 1;
 	/* On some different transaction's list - should be
 	 * the committing one */
 	if (jinode->i_transaction) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..4d57955 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -658,7 +658,9 @@ struct transaction_s
 	 * waiting for it to finish.
 	 */
 	unsigned int t_synchronous_commit:1;
-	unsigned int t_flushed_data_blocks:1;
+
+	/* Disk flush needs to be sent to fs partition [no locking] */
+	int			t_need_data_flush;
 
 	/*
 	 * For use by the filesystem to store fs-specific data
-- 
1.7.1

