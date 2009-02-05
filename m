From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] jbd2: Fix possible NULL pointer dereference in jbd2_journal_begin_ordered_truncate()
Date: Thu,  5 Feb 2009 15:53:00 +0100
Message-ID: <1233845582-954-2-git-send-email-jack@suse.cz>
References: <y>
 <1233845582-954-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com,
	Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com,
	Dan Carpenter <error27@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35082 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753270AbZBEOxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 09:53:04 -0500
In-Reply-To: <1233845582-954-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we race with commit code setting i_transaction to NULL, we could possibly
dereference it. Proper locking requires journal pointer (journal->j_list_lock)
we don't have. So we have to change the prototype of the function so that
filesystem passes us the journal pointer. Also add more detailed comment
about why function does what it does how it should be used.

Thanks to Dan Carpenter <error27@gmail.com> for pointing to the suspitious
code.

CC: linux-ext4@vger.kernel.org
CC: ocfs2-devel@oss.oracle.com
CC: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |   41 ++++++++++++++++++++++++++++++-----------
 include/linux/jbd2.h  |    3 ++-
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 46b4e34..9f1f5f2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2129,26 +2129,45 @@ done:
 }
 
 /*
- * This function must be called when inode is journaled in ordered mode
- * before truncation happens. It starts writeout of truncated part in
- * case it is in the committing transaction so that we stand to ordered
- * mode consistency guarantees.
+ * File truncate and transaction commit interact with each other in a
+ * non-trivial way. If a transaction writing data block A is committing,
+ * we cannot discard the data by truncate until we have written them.
+ * Otherwise if we crashed after the transaction with write has committed
+ * but before the transaction with truncate has committed, we could see
+ * stale data in block A. This function is a helper to solve this problem.
+ * It starts writeout of the truncated part in case it is in the committing
+ * transaction.
+ *
+ * Filesystem must call this function when inode is journaled in ordered mode
+ * before truncation happens and after the inode has been placed on orphan list
+ * with the new inode size. The second condition avoids the race that someone
+ * writes new data and we start committing the transaction after this function
+ * has been called but before a transaction for truncate is started (and
+ * furthermore it allows us to optimize the case where addition to orphan list
+ * happens in the same transaction as write - we don't have to write any data
+ * in such case).
  */
-int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
+int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+					struct jbd2_inode *jinode,
 					loff_t new_size)
 {
-	journal_t *journal;
-	transaction_t *commit_trans;
+	transaction_t *inode_trans, *commit_trans;
 	int ret = 0;
 
-	if (!inode->i_transaction && !inode->i_next_transaction)
+	/* This is a quick check to avoid locking if not necessary */
+	if (!jinode->i_transaction)
 		goto out;
-	journal = inode->i_transaction->t_journal;
+	/* Locks are here just to force reading of recent values, it is
+	 * enough that the transaction was not committing before we started
+	 * a transaction adding the inode to orphan list */
 	spin_lock(&journal->j_state_lock);
 	commit_trans = journal->j_committing_transaction;
 	spin_unlock(&journal->j_state_lock);
-	if (inode->i_transaction == commit_trans) {
-		ret = filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
+	spin_lock(&journal->j_list_lock);
+	inode_trans = jinode->i_transaction;
+	spin_unlock(&journal->j_list_lock);
+	if (inode_trans == commit_trans) {
+		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
 			new_size, LLONG_MAX);
 		if (ret)
 			jbd2_journal_abort(journal, ret);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b28b37e..4d248b3 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1150,7 +1150,8 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
+				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
-- 
1.6.0.2

