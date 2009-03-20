From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Date: Fri, 20 Mar 2009 15:17:50 -0700
Message-ID: <20090320221750.GA32416@kroah.com>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Greg KH <gregkh@suse.de>, mfasheh@suse.com,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, Dan Carpenter <error27@gmail.com>,
	mfasheh@suse.de, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752196AbZCTWR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 18:17:57 -0400
Content-Disposition: inline
In-Reply-To: <49C00FE9.9040407@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 17, 2009 at 02:02:33PM -0700, Randy Dunlap wrote:
> Greg KH wrote:
> > On Tue, Mar 17, 2009 at 01:26:47PM -0700, Randy Dunlap wrote:
> >> Enable all possible OCFS2 kconfig options:
> >>
> >>
> >>
> >> In file included from fs/ocfs2/alloc.c:42:
> >> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> >> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> >> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> >> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> >>   CC [M]  fs/ocfs2/buffer_head_io.o
> >> In file included from fs/ocfs2/aops.c:42:
> >> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> >> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> >> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> >> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> >> make[2]: *** [fs/ocfs2/aops.o] Error 1
> >> make[2]: *** Waiting for unfinished jobs....
> >> In file included from fs/ocfs2/buffer_head_io.c:37:
> >> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> >> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> >> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> >> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> >> make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
> >> make[2]: *** [fs/ocfs2/alloc.o] Error 1
> > 
> > Did this show up in 2.6.28.7?
> 
> no.
> 
> > Odds are it's one of the jbd2 patches from Ted.  Ted, any ideas?

I tracked this down to commit 54dc90 in the 2.6.28.8 tree.

I've included it below.  Jan and Ted, any ideas on how to fix this
error?

Should I just revert this from the 2.6.28 tree?  Or does no one really
care about ocfs2 in the stable tree?

thanks,

greg k-h

From: Jan Kara <jack@suse.cz>
Date: Tue, 24 Feb 2009 12:14:43 -0500
Subject: jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_truncate()
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dan Carpenter <error27@gmail.com>, mfasheh@suse.de, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Message-ID: <1235495688-8044-3-git-send-email-tytso@mit.edu>


From: Jan Kara <jack@suse.cz>

(cherry picked from commit 7f5aa215088b817add9c71914b83650bdd49f8a9)

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
CC: ocfs2-devel@oss.oracle.com
CC: mfasheh@suse.de
CC: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c       |    6 ++++--
 fs/jbd2/transaction.c |   42 +++++++++++++++++++++++++++++++-----------
 fs/ocfs2/journal.h    |    6 ++++--
 include/linux/jbd2.h  |    3 ++-
 4 files changed, 41 insertions(+), 16 deletions(-)

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
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2050,26 +2050,46 @@ done:
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
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -445,8 +445,10 @@ static inline int ocfs2_jbd2_file_inode(
 static inline int ocfs2_begin_ordered_truncate(struct inode *inode,
 					       loff_t new_size)
 {
-	return jbd2_journal_begin_ordered_truncate(&OCFS2_I(inode)->ip_jinode,
-						   new_size);
+	return jbd2_journal_begin_ordered_truncate(
+				OCFS2_SB(inode->i_sb)->journal->j_journal,
+				&OCFS2_I(inode)->ip_jinode,
+				new_size);
 }
 
 #endif /* OCFS2_JOURNAL_H */
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1087,7 +1087,8 @@ extern int	   jbd2_journal_clear_err  (j
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
+				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
