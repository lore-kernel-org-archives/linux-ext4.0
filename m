From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][BUG] jbd: fix the root cause of "no transactions"
	error in __log_wait_for_space()
Date: Wed, 5 Nov 2008 08:53:49 -0500
Message-ID: <20081105135349.GA22998@mit.edu>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com> <20081020160249.ff41f762.akpm@linux-foundation.org> <20081023174101.85b59177.toshi.okajima@jp.fujitsu.com> <20081027142657.2120aa3f.akpm@linux-foundation.org> <49067D03.6080609@jp.fujitsu.com> <20081105131140.7689f048.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081105131140.7689f048.toshi.okajima@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Toshiyuki-san,

I authored a patch a few days ago which I am about to push to Linus,
since it two people who have reported this problem has confirmed that
it solves the problem for them.  That patch can be found here:

   http://lkml.org/lkml/2008/11/1/61

As you can see, it has a rather different theory about the root cause
of the problem; but it makes sense to me, and it has empircally solved
the problem.

So I read your proposed description of the root cause of the problem
with interest.  If I understand you correctly, your concern is that
various functions in jbd2 are cleaning up the memory associated with
tracking the transactions, thus leaving potentially leaving
journal->j_checkpoint_transactions to be NULL, even though the on-disk
tail of the journal hasn't been updated yet in the jbd superblock.
Your solution to this is to avoid cleaning up the in-memory
representation of the transaction until log_do_checkpoint() has a
chance to clean it up.

Your reasoning and your general diagnosis is sound and I agree with
your observation.  However, I disagree with your belief that the
fundamental problem is that journal->j_free is being left "out of
date", and that this is the issue that must be addressed.  This is
because your proposed solution of deferring dropping the in-memory
transaction structure has a number of disadvantages.  For one, it adds
a lot more code complexity; for another, it means that we are tieing
up memory until we have a chance to call log_do_checkpoint.

Therefore, I believe my original strategy of fixing
__log_wait_for_space() is the correct one, since it was a change in in
that function which introduced the regression in the first place.
However, your insight that the problem is that cleanup_journal_tail()
can sometimes free up space even if journal->j_checkpoint_transactions
is NULL is very important, and it will be more efficient to try to
call cleanup_journal_tail() before trying to wait on the current
transaction to finish.

So here is my revised patch, which includes your key insight, but
which does not make a large number of changes in other parts of the
jbd code, and which allows transactions to be dropped as soon as we no
longer need to track any buffers associated with them, even though
cleanup_journal_tail() hasn't been called yet.

						- Ted

jbd: don't give up looking for space so easily in __log_wait_for_space wait

From: Theodore Ts'o <tytso@mit.edu>

Commit be07c4ed introducd a regression because it assumed that if
there were no transactions ready to be checkpointed, that no progress
could be made on making space available in the journal, and so the
journal should be aborted.  This assumption is false; it could be the
case that simply calling cleanup_journal_tail() will recover the
necessary space, or, for small journals, the currently committing
transaction could be responsible for chewing up the required space in
the log, so we need to wait for the currently committing transaction
to finish before trying to force a checkpoint operation.

This patch fixes the bug reported by Meelis Roos at:
http://bugzilla.kernel.org/show_bug.cgi?id=11937

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Duane Griffin <duaneg@dghda.com>
---
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 1bd8d4a..5e856de 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -128,25 +128,42 @@ void __log_wait_for_space(journal_t *journal)
 		/*
 		 * Test again, another process may have checkpointed while we
 		 * were waiting for the checkpoint lock. If there are no
-		 * outstanding transactions there is nothing to checkpoint and
-		 * we can't make progress. Abort the journal in this case.
+		 * transactions ready to be checkpointed, try to recover
+		 * journal space by calling cleanup_journal_tail(), and if
+		 * that doesn't work, by waiting for the currently committing
+		 * transaction to complete.  If there is absolutely no way
+		 * to make progress, this is either a BUG or corrupted
+		 * filesystem, so abort the journal and leave a stack
+		 * trace for forensic evidence.
 		 */
 		spin_lock(&journal->j_state_lock);
 		spin_lock(&journal->j_list_lock);
 		nblocks = jbd_space_needed(journal);
 		if (__log_space_left(journal) < nblocks) {
 			int chkpt = journal->j_checkpoint_transactions != NULL;
+			int tid = 0;
 
+			if (journal->j_committing_transaction)
+				tid = journal->j_committing_transaction->t_tid;
 			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
 			if (chkpt) {
 				log_do_checkpoint(journal);
+			} else if (cleanup_journal_tail(journal) == 0) {
+				/* We were able to recover space; yay! */
+				;
+			} else if (tid) {
+				log_wait_commit(journal, tid);
 			} else {
-				printk(KERN_ERR "%s: no transactions\n",
-				       __func__);
+				printk(KERN_ERR "%s: needed %d blocks and "
+				       "only had %d space available\n",
+				       __func__, nblocks,
+				       __log_space_left(journal));
+				printk(KERN_ERR "%s: no way to get more "
+				       "journal space\n", __func__);
+				WARN_ON(1);
 				journal_abort(journal, 0);
 			}
-
 			spin_lock(&journal->j_state_lock);
 		} else {
 			spin_unlock(&journal->j_list_lock);
