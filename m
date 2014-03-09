From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/6] jbd2: add transaction to checkpoint list earlier
Date: Sun,  9 Mar 2014 01:05:38 -0500
Message-ID: <1394345141-3471-3-git-send-email-tytso@mit.edu>
References: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38899 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaCIGFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Mar 2014 01:05:52 -0500
In-Reply-To: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't otherwise need j_list_lock during the rest of commit phase
#7, so add the transaction to the checkpoint list at the very end of
commit phase #6.  This allows us to drop j_list_lock earlier, which is
a good thing since it is a super hot lock.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index af36252..5f26139 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -1065,6 +1065,25 @@ restart_loop:
 		goto restart_loop;
 	}
 
+	/* Add the transaction to the checkpoint list
+	 * __journal_remove_checkpoint() can not destroy transaction
+	 * under us because it is not marked as T_FINISHED yet */
+	if (journal->j_checkpoint_transactions == NULL) {
+		journal->j_checkpoint_transactions = commit_transaction;
+		commit_transaction->t_cpnext = commit_transaction;
+		commit_transaction->t_cpprev = commit_transaction;
+	} else {
+		commit_transaction->t_cpnext =
+			journal->j_checkpoint_transactions;
+		commit_transaction->t_cpprev =
+			commit_transaction->t_cpnext->t_cpprev;
+		commit_transaction->t_cpnext->t_cpprev =
+			commit_transaction;
+		commit_transaction->t_cpprev->t_cpnext =
+				commit_transaction;
+	}
+	spin_unlock(&journal->j_list_lock);
+
 	/* Done with this transaction! */
 
 	jbd_debug(3, "JBD2: commit phase 7\n");
@@ -1103,24 +1122,6 @@ restart_loop:
 
 	write_unlock(&journal->j_state_lock);
 
-	if (journal->j_checkpoint_transactions == NULL) {
-		journal->j_checkpoint_transactions = commit_transaction;
-		commit_transaction->t_cpnext = commit_transaction;
-		commit_transaction->t_cpprev = commit_transaction;
-	} else {
-		commit_transaction->t_cpnext =
-			journal->j_checkpoint_transactions;
-		commit_transaction->t_cpprev =
-			commit_transaction->t_cpnext->t_cpprev;
-		commit_transaction->t_cpnext->t_cpprev =
-			commit_transaction;
-		commit_transaction->t_cpprev->t_cpnext =
-				commit_transaction;
-	}
-	spin_unlock(&journal->j_list_lock);
-	/* Drop all spin_locks because commit_callback may be block.
-	 * __journal_remove_checkpoint() can not destroy transaction
-	 * under us because it is not marked as T_FINISHED yet */
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
@@ -1131,7 +1132,7 @@ restart_loop:
 	write_lock(&journal->j_state_lock);
 	spin_lock(&journal->j_list_lock);
 	commit_transaction->t_state = T_FINISHED;
-	/* Recheck checkpoint lists after j_list_lock was dropped */
+	/* Check if the transaction can be dropped now that we are finished */
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
-- 
1.9.0

