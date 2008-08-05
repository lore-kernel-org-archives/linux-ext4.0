From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] jbd2: abort instead of waiting for nonexistent transactions
Date: Tue,  5 Aug 2008 02:05:21 +0100
Message-ID: <1217898321-3514-2-git-send-email-duaneg@dghda.com>
References: <1217898321-3514-1-git-send-email-duaneg@dghda.com>
Cc: akpm@linux-foundation.org, sct@redhat.com,
	linux-ext4@vger.kernel.org, Sami Liedes <sliedes@cc.hut.fi>,
	Duane Griffin <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:4450 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922AbYHEBF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2008 21:05:27 -0400
In-Reply-To: <1217898321-3514-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The __jbd2_log_wait_for_space function sits in a loop checkpointing
transactions until there is sufficient space free in the journal. However,
if there are no transactions to be processed (e.g. because the free space
calculation is wrong due to a corrupted filesystem) it will never progress.

Check for space being required when no transactions are outstanding and
abort the journal instead of endlessly looping.

This patch fixes the bug reported by Sami Liedes at:
http://bugzilla.kernel.org/show_bug.cgi?id=10976

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 91389c8..3c075c4 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -126,13 +126,24 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 
 		/*
 		 * Test again, another process may have checkpointed while we
-		 * were waiting for the checkpoint lock
+		 * were waiting for the checkpoint lock. If there are no
+		 * outstanding transactions there is nothing to checkpoint and
+		 * we can't make progress. Abort the journal in this case.
 		 */
 		spin_lock(&journal->j_state_lock);
 		nblocks = jbd_space_needed(journal);
 		if (__jbd2_log_space_left(journal) < nblocks) {
+			int chkpt = journal->j_checkpoint_transactions != NULL;
+
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
 		}
 		mutex_unlock(&journal->j_checkpoint_mutex);
