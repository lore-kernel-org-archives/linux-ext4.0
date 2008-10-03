From: akpm@linux-foundation.org
Subject: - jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch removed from -mm tree
Date: Fri, 03 Oct 2008 14:29:12 -0700
Message-ID: <200810032129.m93LTCXj016672@imap1.linux-foundation.org>
To: duaneg@dghda.com, linux-ext4@vger.kernel.org, sct@redhat.com,
	sliedes@cc.hut.fi, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYJCV3a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2008 17:29:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd2: abort instead of waiting for nonexistent transactions
has been removed from the -mm tree.  Its filename was
     jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: "Stephen C. Tweedie" <sct@redhat.com>
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

git-ext4.patch
jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch

