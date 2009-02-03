From: Jan Kara <jack@suse.cz>
Subject: Re: typo in jbd2_journal_begin_ordered_truncate()
Date: Tue, 3 Feb 2009 15:23:12 +0100
Message-ID: <20090203142312.GA24630@duck.suse.cz>
References: <alpine.DEB.2.00.0902012309120.26166@bikeee> <20090203003351.1efaa6db.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>, sct@redhat.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37894 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752484AbZBCOXQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 09:23:16 -0500
Content-Disposition: inline
In-Reply-To: <20090203003351.1efaa6db.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 03-02-09 00:33:51, Andrew Morton wrote:
> On Tue, 3 Feb 2009 11:23:03 +0300 (EAT) Dan Carpenter <error27@gmail.com> wrote:
> 
> > This is jbd2_journal_begin_ordered_truncate() from fs/jbd2/transaction.c.
> > 
> > I think the "&&" is supposed to be an "||" on line 2144.  Just knowing 
> > that inode->i_transaction is NULL should be enough, otherwise we would 
> > immediately dereference a null on line 2146.
> > 
> >    2144          if (!inode->i_transaction && !inode->i_next_transaction)
> >    2145                  goto out;
> >    2146          journal = inode->i_transaction->t_journal;
> > 
> 
> Could be.  Hard to tell from the code, changelog and (non) comments.  Perhaps
> it's dead code.
  It isn't dead, ext4 and ocfs2 use it. The condition is suspitious but ||
is definitely wrong there. i_next_transaction is often NULL - it is
non-NULL only if the inode is part of both the currently committing
transaction and the running transaction but we need to call
filemap_fdatawrite_range() whenever the inode is part of the committing
transaction. The correct check seems to be just !inode->i_transaction
because when i_transaction is NULL, then i_next_transaction must be NULL as
well.
  But as I'm looking at the function, it definitely deserves more detailed
comments about how transaction commit interacts with truncates. And the
dereference inode->i_transaction->t_journal can potentially race with
commit code clearing i_transaction pointer :(. The bad thing is that to
lock against that you need a journal pointer we are trying to get. So I'll
probably have to change the function to get the journal pointer from the
caller (which can obtain it from filesystems's superblock or so).

> Send a patch, become famous ;)
> 
> While you're there, rename local var `inode' to `jinode'.
  Yes.

  Thank you and Dan for pointing at the problems.

  Below is how I think the function should be rewritten. I'll post it also
with the corresponding OCFS2 and EXT4 changes if you won't see obvious
problems with it.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--

>From ee0edb7e1809515467846e8730daae85e0e53b89 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Feb 2009 14:56:53 +0100
Subject: [PATCH] jbd2: Fix possible NULL pointer dereference in jbd2_journal_begin_ordered_truncate()

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

