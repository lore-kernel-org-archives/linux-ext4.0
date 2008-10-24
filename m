From: akpm@linux-foundation.org
Subject: - jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:38 -0700
Message-ID: <200810241940.m9OJecrG000949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: duaneg@dghda.com, linux-ext4@vger.kernel.org, sliedes@cc.hut.fi,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: abort instead of waiting for nonexistent transactions
has been removed from the -mm tree.  Its filename was
     jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: abort instead of waiting for nonexistent transactions
From: "Duane Griffin" <duaneg@dghda.com>

The __log_wait_for_space function sits in a loop checkpointing
transactions until there is sufficient space free in the journal. 
However, if there are no transactions to be processed (e.g.  because the
free space calculation is wrong due to a corrupted filesystem) it will
never progress.

Check for space being required when no transactions are outstanding and
abort the journal instead of endlessly looping.

This patch fixes the bug reported by Sami Liedes at:
http://bugzilla.kernel.org/show_bug.cgi?id=10976

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Tested-by: Sami Liedes <sliedes@cc.hut.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/checkpoint.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN fs/jbd/checkpoint.c~jbd-abort-instead-of-waiting-for-nonexistent-transactions fs/jbd/checkpoint.c
--- a/fs/jbd/checkpoint.c~jbd-abort-instead-of-waiting-for-nonexistent-transactions
+++ a/fs/jbd/checkpoint.c
@@ -127,14 +127,29 @@ void __log_wait_for_space(journal_t *jou
 
 		/*
 		 * Test again, another process may have checkpointed while we
-		 * were waiting for the checkpoint lock
+		 * were waiting for the checkpoint lock. If there are no
+		 * outstanding transactions there is nothing to checkpoint and
+		 * we can't make progress. Abort the journal in this case.
 		 */
 		spin_lock(&journal->j_state_lock);
+		spin_lock(&journal->j_list_lock);
 		nblocks = jbd_space_needed(journal);
 		if (__log_space_left(journal) < nblocks) {
+			int chkpt = journal->j_checkpoint_transactions != NULL;
+
+			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
-			log_do_checkpoint(journal);
+			if (chkpt) {
+				log_do_checkpoint(journal);
+			} else {
+				printk(KERN_ERR "%s: no transactions\n",
+				       __func__);
+				journal_abort(journal, 0);
+			}
+
 			spin_lock(&journal->j_state_lock);
+		} else {
+			spin_unlock(&journal->j_list_lock);
 		}
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
_

Patches currently in -mm which might be from duaneg@dghda.com are


