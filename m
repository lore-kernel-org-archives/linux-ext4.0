From: dingdinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH] Jbd2: delay discarding buffers in journal_unmap_buffer
Date: Sat,  6 Feb 2010 12:54:23 +0800
Message-ID: <1265432063-5806-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: jack@suse.cz, dingdinghua <dingdinghua@nrchpc.ac.cn>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [159.226.39.252] ([159.226.39.252]:35503 "EHLO bwstor.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754368Ab0BFEyG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2010 23:54:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Delay discarding buffers in journal_unmap_buffer until
we know that "add to orphan" operation has definitely been
committed, otherwise the log space of committing transation
may be freed and reused before truncate get committed, updates
may get lost if crash happens.

Signed-off-by: dingdinghua <dingdinghua@nrchpc.ac.cn>
---
 fs/jbd2/commit.c      |   10 +++++-----
 fs/jbd2/transaction.c |   33 +++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 1bc74b6..aabff6a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -930,12 +930,12 @@ restart_loop:
 		/* A buffer which has been freed while still being
 		 * journaled by a previous transaction may end up still
 		 * being dirty here, but we want to avoid writing back
-		 * that buffer in the future now that the last use has
-		 * been committed.  That's not only a performance gain,
-		 * it also stops aliasing problems if the buffer is left
-		 * behind for writeback and gets reallocated for another
+		 * that buffer in the future after the "add to orphan"
+		 * operation been committed,  That's not only a performance
+                 * gain, it also stops aliasing problems if the buffer is
+		 * left behind for writeback and gets reallocated for another
 		 * use in a different page. */
-		if (buffer_freed(bh)) {
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
 			clear_buffer_freed(bh);
 			clear_buffer_jbddirty(bh);
 		}
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a051270..6e2971d 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1783,16 +1783,20 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	} else if (transaction == journal->j_committing_transaction) {
 		JBUFFER_TRACE(jh, "on committing transaction");
 		/*
-		 * If it is committing, we simply cannot touch it.  We
-		 * can remove it's next_transaction pointer from the
-		 * running transaction if that is set, but nothing
-		 * else. */
+		 * We don't know the transaction which "add to orphan" handle
+		 * belongs to, there are three cases:
+		 * (1) it's a transaction which has been committed
+		 * (2) it's the committing transaction
+		 * (3) it's the running transaction
+		 * We can't clear the BH_jbddirty bit and discard the buffer
+		 * before "add to orphan" has been committed, just
+		 * be conservative, if running transaction exists and buffer
+		 * has been dirtied(may be by previous transaction), wait until
+		 * running transaction complete commit and do the discard work.
+		 */
 		set_buffer_freed(bh);
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction ==
-					journal->j_running_transaction);
-			jh->b_next_transaction = NULL;
-		}
+		if (journal->j_running_transaction && buffer_jbddirty(bh))
+			jh->b_next_transaction = journal->j_running_transaction;
 		jbd2_journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
@@ -1969,7 +1973,7 @@ void jbd2_journal_file_buffer(struct journal_head *jh,
  */
 void __jbd2_journal_refile_buffer(struct journal_head *jh)
 {
-	int was_dirty;
+	int was_dirty, jlist;
 	struct buffer_head *bh = jh2bh(jh);
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
@@ -1991,8 +1995,13 @@ void __jbd2_journal_refile_buffer(struct journal_head *jh)
 	__jbd2_journal_temp_unlink_buffer(jh);
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
-	__jbd2_journal_file_buffer(jh, jh->b_transaction,
-				jh->b_modified ? BJ_Metadata : BJ_Reserved);
+	if (buffer_freed(bh))
+		jlist = BJ_Forget;
+	else if (jh->b_modified)
+		jlist = BJ_Metadata;
+	else
+		jlist = BJ_Reserved;
+	__jbd2_journal_file_buffer(jh, jh->b_transaction, jlist);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
-- 
1.5.5.6

