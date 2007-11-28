From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix assertion failure in fs/jbd/checkpoint.c
Date: Wed, 28 Nov 2007 15:34:11 +0100
Message-ID: <20071128143410.GD11350@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760694AbXK1OeY@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  the patch below should fix an assertion failure in JBD checkpointing
code. The patch survived some fsstress and similar runs on my test machine
so it shouldn't be obviously wrong ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Before we start committing a transaction, we call
__journal_clean_checkpoint_list() to cleanup transaction's written-back
buffers. If this call happens to remove all of them (and there were already
some buffers), __journal_remove_checkpoint() will decide to free the
transaction because it isn't (yet) a committing transaction and soon we fail
some assertion - the transaction really isn't ready to be freed :).
We change the check in __journal_remove_checkpoint() to free only a transaction
in T_FINISHED state. The locking there is subtle though (as everywhere in
JBD ;(). We use j_list_lock to protect the check and a subsequent call to
__journal_drop_transaction() and do the same in the end of
journal_commit_transaction() which is the only place where a transaction can
get to T_FINISHED state. Probably I'm too paranoid here and such locking is
not really necessary - checkpoint lists are processed only from
log_do_checkpoint() where a transaction must be already committed to be
processed or from __journal_clean_checkpoint_list() where kjournald itself
calls it and thus transaction cannot change state either. Better be safe if
something changes in future...

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 47552d4..0f69c41 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -602,15 +602,15 @@ int __journal_remove_checkpoint(struct journal_head *jh)
 
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
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 8f1f2aa..610264b 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
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
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 16e7ed8..d9ecd13 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -439,6 +439,8 @@ struct transaction_s
 	/*
 	 * Transaction's current state
 	 * [no locking - only kjournald alters this]
+	 * [j_list_lock] guards transition of a transaction into T_FINISHED
+	 * state and subsequent call of __journal_drop_transaction()
 	 * FIXME: needs barriers
 	 * KLUDGE: [use j_state_lock]
 	 */
