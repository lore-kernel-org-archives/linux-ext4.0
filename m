From: <gregkh@suse.de>
Subject: patch jbd2-abort-instead-of-waiting-for-nonexistent-transaction.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:04 -0800
Message-ID: <20081203185932.73CAA4904F@coco.kroah.org>
References: <1226851540-8032-10-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: duaneg@dghda.com, akpm@linux-foundation.org, gregkh@suse.de,
	linux-ext4@vger.kernel.org, sliedes@cc.hut.fi, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449AbYLCS7d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:33 -0500
In-Reply-To: <1226851540-8032-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: jbd2: abort instead of waiting for nonexistent transaction

to the 2.6.27-stable tree.  Its filename is

    jbd2-abort-instead-of-waiting-for-nonexistent-transaction.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:04:03 2008
From: Duane Griffin <duaneg@dghda.com>
Date: Sun, 16 Nov 2008 11:05:29 -0500
Subject: jbd2: abort instead of waiting for nonexistent transaction
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Sami Liedes <sliedes@cc.hut.fi>, Duane Griffin <duaneg@dghda.com>
Message-ID: <1226851540-8032-10-git-send-email-tytso@mit.edu>


From: Duane Griffin <duaneg@dghda.com>

(cherry picked from commit 23f8b79eae8a74e42a006ffa7c456e295c7e1c0d)

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
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/checkpoint.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
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


Patches currently in stable-queue which might be from duaneg@dghda.com are

queue-2.6.27/jbd2-abort-instead-of-waiting-for-nonexistent-transaction.patch
queue-2.6.27/jbd2-don-t-give-up-looking-for-space-so-easily-in-__jbd2_log_wait_for_space.patch
