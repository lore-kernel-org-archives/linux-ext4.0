From: akpm@linux-foundation.org
Subject: - jbd-fix-assertion-failure-in-fs-jbd-checkpointc.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:30:04 -0800
Message-ID: <200712080130.lB81U4rI013517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: Fix assertion failure in fs/jbd/checkpoint.c
has been removed from the -mm tree.  Its filename was
     jbd-fix-assertion-failure-in-fs-jbd-checkpointc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd: Fix assertion failure in fs/jbd/checkpoint.c
From: Jan Kara <jack@suse.cz>

Before we start committing a transaction, we call
__journal_clean_checkpoint_list() to cleanup transaction's written-back
buffers.

If this call happens to remove all of them (and there were already some
buffers), __journal_remove_checkpoint() will decide to free the transaction
because it isn't (yet) a committing transaction and soon we fail some
assertion - the transaction really isn't ready to be freed :).

We change the check in __journal_remove_checkpoint() to free only a
transaction in T_FINISHED state.  The locking there is subtle though (as
everywhere in JBD ;().  We use j_list_lock to protect the check and a
subsequent call to __journal_drop_transaction() and do the same in the end
of journal_commit_transaction() which is the only place where a transaction
can get to T_FINISHED state.

Probably I'm too paranoid here and such locking is not really necessary -
checkpoint lists are processed only from log_do_checkpoint() where a
transaction must be already committed to be processed or from
__journal_clean_checkpoint_list() where kjournald itself calls it and thus
transaction cannot change state either.  Better be safe if something
changes in future...

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/checkpoint.c |   12 ++++++------
 fs/jbd/commit.c     |    8 ++++----
 include/linux/jbd.h |    2 ++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/jbd/checkpoint.c~jbd-fix-assertion-failure-in-fs-jbd-checkpointc fs/jbd/checkpoint.c
--- a/fs/jbd/checkpoint.c~jbd-fix-assertion-failure-in-fs-jbd-checkpointc
+++ a/fs/jbd/checkpoint.c
@@ -602,15 +602,15 @@ int __journal_remove_checkpoint(struct j
 
 	/*
 	 * There is one special case to worry about: if we have just pulled the
-	 * buffer off a committing transaction's forget list, then even if the
-	 * checkpoint list is empty, the transaction obviously cannot be
-	 * dropped!
+	 * buffer off a running or committing transaction's checkpoing list,
+	 * then even if the checkpoint list is empty, the transaction obviously
+	 * cannot be dropped!
 	 *
-	 * The locking here around j_committing_transaction is a bit sleazy.
+	 * The locking here around t_state is a bit sleazy.
 	 * See the comment at the end of journal_commit_transaction().
 	 */
-	if (transaction == journal->j_committing_transaction) {
-		JBUFFER_TRACE(jh, "belongs to committing transaction");
+	if (transaction->t_state != T_FINISHED) {
+		JBUFFER_TRACE(jh, "belongs to running/committing transaction");
 		goto out;
 	}
 
diff -puN fs/jbd/commit.c~jbd-fix-assertion-failure-in-fs-jbd-checkpointc fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-assertion-failure-in-fs-jbd-checkpointc
+++ a/fs/jbd/commit.c
@@ -858,10 +858,10 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 	/*
-	 * This is a bit sleazy.  We borrow j_list_lock to protect
-	 * journal->j_committing_transaction in __journal_remove_checkpoint.
-	 * Really, __journal_remove_checkpoint should be using j_state_lock but
-	 * it's a bit hassle to hold that across __journal_remove_checkpoint
+	 * This is a bit sleazy.  We use j_list_lock to protect transition
+	 * of a transaction into T_FINISHED state and calling
+	 * __journal_drop_transaction(). Otherwise we could race with
+	 * other checkpointing code processing the transaction...
 	 */
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&journal->j_list_lock);
diff -puN include/linux/jbd.h~jbd-fix-assertion-failure-in-fs-jbd-checkpointc include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-fix-assertion-failure-in-fs-jbd-checkpointc
+++ a/include/linux/jbd.h
@@ -439,6 +439,8 @@ struct transaction_s
 	/*
 	 * Transaction's current state
 	 * [no locking - only kjournald alters this]
+	 * [j_list_lock] guards transition of a transaction into T_FINISHED
+	 * state and subsequent call of __journal_drop_transaction()
 	 * FIXME: needs barriers
 	 * KLUDGE: [use j_state_lock]
 	 */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
