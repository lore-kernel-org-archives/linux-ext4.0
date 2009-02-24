From: Theodore Tso <tytso@mit.edu>
Subject: Re: [STABLE, 2.6.27.y] jbd2: Avoid possible NULL dereference in
	jbd2_journal_begin_ordered_truncate()
Date: Tue, 24 Feb 2009 16:13:18 -0500
Message-ID: <20090224211318.GC7064@mit.edu>
References: <1235495694-8116-1-git-send-email-tytso@mit.edu> <1235495694-8116-2-git-send-email-tytso@mit.edu> <1235495694-8116-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, mfasheh@suse.de,
	Dan Carpenter <error27@gmail.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54284 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZBXVN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 16:13:29 -0500
Content-Disposition: inline
In-Reply-To: <1235495694-8116-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, it turns out the ocfs2 chunk is not needed for 2.6.27, and in
fact causes problem.  Please replace the patch I sent with this one,
which removes the diff chunk which patches fs/ocfs2/journal.h; it's
not needed for the 2.6.27.y backport, apparently.

						- Ted
----------------
jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_truncate()

From: Jan Kara <jack@suse.cz>

If we race with commit code setting i_transaction to NULL, we could
possibly dereference it.  Proper locking requires the journal pointer
(to access journal->j_list_lock), which we don't have.  So we have to
change the prototype of the function so that filesystem passes us the
journal pointer.  Also add a more detailed comment about why the
function jbd2_journal_begin_ordered_truncate() does what it does and
how it should be used.

Thanks to Dan Carpenter <error27@gmail.com> for pointing to the
suspitious code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Joel Becker <joel.becker@oracle.com>
CC: linux-ext4@vger.kernel.org
CC: mfasheh@suse.de
CC: Dan Carpenter <error27@gmail.com>
(cherry picked from commit 7f5aa215088b817add9c71914b83650bdd49f8a9)
---
 fs/ext4/inode.c       |    6 ++++--
 fs/jbd2/transaction.c |   42 +++++++++++++++++++++++++++++++-----------
 include/linux/jbd2.h  |    3 ++-
 4 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e7f085..7b063d4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -46,8 +46,10 @@
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
-	return jbd2_journal_begin_ordered_truncate(&EXT4_I(inode)->jinode,
-						   new_size);
+	return jbd2_journal_begin_ordered_truncate(
+					EXT4_SB(inode->i_sb)->s_journal,
+					&EXT4_I(inode)->jinode,
+					new_size);
 }
 
 static void ext4_invalidatepage(struct page *page, unsigned long offset);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index e5d5405..92d77c9 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2049,26 +2049,46 @@ done:
 }
 
 /*
- * This function must be called when inode is journaled in ordered mode
- * before truncation happens. It starts writeout of truncated part in
- * case it is in the committing transaction so that we stand to ordered
- * mode consistency guarantees.
+ * File truncate and transaction commit interact with each other in a
+ * non-trivial way.  If a transaction writing data block A is
+ * committing, we cannot discard the data by truncate until we have
+ * written them.  Otherwise if we crashed after the transaction with
+ * write has committed but before the transaction with truncate has
+ * committed, we could see stale data in block A.  This function is a
+ * helper to solve this problem.  It starts writeout of the truncated
+ * part in case it is in the committing transaction.
+ *
+ * Filesystem code must call this function when inode is journaled in
+ * ordered mode before truncation happens and after the inode has been
+ * placed on orphan list with the new inode size. The second condition
+ * avoids the race that someone writes new data and we start
+ * committing the transaction after this function has been called but
+ * before a transaction for truncate is started (and furthermore it
+ * allows us to optimize the case where the addition to orphan list
+ * happens in the same transaction as write --- we don't have to write
+ * any data in such case).
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
index 0e1bd70..df4137e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1075,7 +1075,8 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
+				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
-- 
1.5.6.3

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
