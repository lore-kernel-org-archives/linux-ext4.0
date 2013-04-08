From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/29] jbd2: Cleanup needed free block estimates when starting a transaction
Date: Mon,  8 Apr 2013 23:32:14 +0200
Message-ID: <1365456754-29373-10-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936289Ab3DHVdD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:03 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__jbd2_log_space_left() and jbd_space_needed() were kind of odd.
jbd_space_needed() accounted also credits needed for currently committing
transaction while it didn't account for credits needed for control blocks.
__jbd2_log_space_left() then accounted for control blocks as a fraction of free
space. Since results of these two functions are always only compared against
each other, this works correct but is somewhat strange. Move the estimates so
that jbd_space_needed() returns number of blocks needed for a transaction
including control blocks and __jbd2_log_space_left() returns free space in the
journal (with the committing transaction already subtracted). Rename functions
to jbd2_log_space_left() and jbd2_space_needed() while we are changing them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c  |    8 ++++----
 fs/jbd2/journal.c     |   29 -----------------------------
 fs/jbd2/transaction.c |    9 +++++----
 include/linux/jbd2.h  |   32 ++++++++++++++++++++++++++------
 4 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 65ec076..a572383 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -120,8 +120,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 	int nblocks, space_left;
 	/* assert_spin_locked(&journal->j_state_lock); */
 
-	nblocks = jbd_space_needed(journal);
-	while (__jbd2_log_space_left(journal) < nblocks) {
+	nblocks = jbd2_space_needed(journal);
+	while (jbd2_log_space_left(journal) < nblocks) {
 		if (journal->j_flags & JBD2_ABORT)
 			return;
 		write_unlock(&journal->j_state_lock);
@@ -140,8 +140,8 @@ void __jbd2_log_wait_for_space(journal_t *journal)
 		 */
 		write_lock(&journal->j_state_lock);
 		spin_lock(&journal->j_list_lock);
-		nblocks = jbd_space_needed(journal);
-		space_left = __jbd2_log_space_left(journal);
+		nblocks = jbd2_space_needed(journal);
+		space_left = jbd2_log_space_left(journal);
 		if (space_left < nblocks) {
 			int chkpt = journal->j_checkpoint_transactions != NULL;
 			tid_t tid = 0;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e9a9cdb..e6f14e0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -480,35 +480,6 @@ repeat:
  */
 
 /*
- * __jbd2_log_space_left: Return the number of free blocks left in the journal.
- *
- * Called with the journal already locked.
- *
- * Called under j_state_lock
- */
-
-int __jbd2_log_space_left(journal_t *journal)
-{
-	int left = journal->j_free;
-
-	/* assert_spin_locked(&journal->j_state_lock); */
-
-	/*
-	 * Be pessimistic here about the number of those free blocks which
-	 * might be required for log descriptor control blocks.
-	 */
-
-#define MIN_LOG_RESERVED_BLOCKS 32 /* Allow for rounding errors */
-
-	left -= MIN_LOG_RESERVED_BLOCKS;
-
-	if (left <= 0)
-		return 0;
-	left -= (left >> 3);
-	return left;
-}
-
-/*
  * Called with j_state_lock locked for writing.
  * Returns true if a transaction commit was started.
  */
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 74cfbd3..aee40c9 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -283,12 +283,12 @@ repeat:
 	 * reduce the free space arbitrarily.  Be careful to account for
 	 * those buffers when checkpointing.
 	 */
-	if (__jbd2_log_space_left(journal) < jbd_space_needed(journal)) {
+	if (jbd2_log_space_left(journal) < jbd2_space_needed(journal)) {
 		jbd_debug(2, "Handle %p waiting for checkpoint...\n", handle);
 		atomic_sub(nblocks, &transaction->t_outstanding_credits);
 		read_unlock(&journal->j_state_lock);
 		write_lock(&journal->j_state_lock);
-		if (__jbd2_log_space_left(journal) < jbd_space_needed(journal))
+		if (jbd2_log_space_left(journal) < jbd2_space_needed(journal))
 			__jbd2_log_wait_for_space(journal);
 		write_unlock(&journal->j_state_lock);
 		goto repeat;
@@ -306,7 +306,7 @@ repeat:
 	jbd_debug(4, "Handle %p given %d credits (total %d, free %d)\n",
 		  handle, nblocks,
 		  atomic_read(&transaction->t_outstanding_credits),
-		  __jbd2_log_space_left(journal));
+		  jbd2_log_space_left(journal));
 	read_unlock(&journal->j_state_lock);
 
 	lock_map_acquire(&handle->h_lockdep_map);
@@ -442,7 +442,8 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 		goto unlock;
 	}
 
-	if (wanted > __jbd2_log_space_left(journal)) {
+	if (wanted + (wanted >> JBD2_CONTROL_BLOCKS_SHIFT) >
+	    jbd2_log_space_left(journal)) {
 		jbd_debug(3, "denied handle %p %d blocks: "
 			  "insufficient log space\n", handle, nblocks);
 		goto unlock;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index be5115f..9197d1b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1219,7 +1219,6 @@ extern void	jbd2_clear_buffer_revoked_flags(journal_t *journal);
  * transitions on demand.
  */
 
-int __jbd2_log_space_left(journal_t *); /* Called with journal locked */
 int jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
@@ -1289,16 +1288,37 @@ extern int jbd2_journal_blocks_per_page(struct inode *inode);
 extern size_t journal_tag_bytes(journal_t *journal);
 
 /*
+ * We reserve t_outstanding_credits >> JBD2_CONTROL_BLOCKS_SHIFT for
+ * transaction control blocks.
+ */
+#define JBD2_CONTROL_BLOCKS_SHIFT 5
+
+/*
  * Return the minimum number of blocks which must be free in the journal
  * before a new transaction may be started.  Must be called under j_state_lock.
  */
-static inline int jbd_space_needed(journal_t *journal)
+static inline int jbd2_space_needed(journal_t *journal)
 {
 	int nblocks = journal->j_max_transaction_buffers;
-	if (journal->j_committing_transaction)
-		nblocks += atomic_read(&journal->j_committing_transaction->
-				       t_outstanding_credits);
-	return nblocks;
+	return nblocks + (nblocks >> JBD2_CONTROL_BLOCKS_SHIFT);
+}
+
+/*
+ * Return number of free blocks in the log. Must be called under j_state_lock.
+ */
+static inline unsigned long jbd2_log_space_left(journal_t *journal)
+{
+	/* Allow for rounding errors */
+	unsigned long free = journal->j_free - 32;
+
+	if (journal->j_committing_transaction) {
+		unsigned long committing = atomic_read(&journal->
+			j_committing_transaction->t_outstanding_credits);
+
+		/* Transaction + control blocks */
+		free -= committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
+	}
+	return free;
 }
 
 /*
-- 
1.7.1

