From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd: don't give up looking for space so easily in __log_wait_for_space
Date: Wed,  5 Nov 2008 09:05:07 -0500
Message-ID: <1225893908-2086-1-git-send-email-tytso@mit.edu>
References: <20081105135349.GA22998@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48259 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbYKEOFK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 09:05:10 -0500
In-Reply-To: <20081105135349.GA22998@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/jbd/checkpoint.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

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
