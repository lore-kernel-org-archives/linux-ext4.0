From: akpm@linux-foundation.org
Subject: + jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch added to -mm tree
Date: Mon, 04 Aug 2008 18:44:25 -0700
Message-ID: <200808050144.m751iP1t010723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org, sliedes@cc.hut.fi
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: abort instead of waiting for nonexistent transactions
has been added to the -mm tree.  Its filename is
     jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: abort instead of waiting for nonexistent transactions
From: "Duane Griffin" <duaneg@dghda.com>

The __jbd2_log_wait_for_space function sits in a loop checkpointing
transactions until there is sufficient space free in the journal. 
However, if there are no transactions to be processed (e.g.  because the
free space calculation is wrong due to a corrupted filesystem) it will
never progress.

Check for space being required when no transactions are outstanding and
abort the journal instead of endlessly looping.

This patch fixes the bug reported by Sami Liedes at:
http://bugzilla.kernel.org/show_bug.cgi?id=10976

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: Sami Liedes <sliedes@cc.hut.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/checkpoint.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN fs/jbd2/checkpoint.c~jbd2-abort-instead-of-waiting-for-nonexistent-transactions fs/jbd2/checkpoint.c
--- a/fs/jbd2/checkpoint.c~jbd2-abort-instead-of-waiting-for-nonexistent-transactions
+++ a/fs/jbd2/checkpoint.c
@@ -126,14 +126,29 @@ void __jbd2_log_wait_for_space(journal_t
 
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
 		if (__jbd2_log_space_left(journal) < nblocks) {
+			int chkpt = journal->j_checkpoint_transactions != NULL;
+
+			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
-			jbd2_log_do_checkpoint(journal);
+			if (chkpt) {
+				jbd2_log_do_checkpoint(journal);
+			} else {
+				printk(KERN_ERR "%s: no transactions\n",
+				       __func__);
+				jbd2_journal_abort(journal, 0);
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

jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch
jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch

