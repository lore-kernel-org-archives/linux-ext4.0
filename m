From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] jbd2: optimize jbd2_journal_force_commit V3
Date: Mon, 10 Jun 2013 20:40:59 +0400
Message-ID: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:30013 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3FJQlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 12:41:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current implementation of jbd2_journal_force_commit() is suboptimal because
result in empty and useless commits. But callers just want to force and wait
any unfinished commits. We already has jbd2_journal_force_commit_nested()
which does exactly what we want, except we are guaranteed that we do not hold
journal transaction open.

Changes since V3 to V2
 - API changes according to Jan's comments
 - make __jbd2_journal_force_commit() static

Changes since V2 to V1
 - Fix incorrect return value  according to Jan's comments.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/journal.c     |   63 ++++++++++++++++++++++++++++++++++++++-----------
 fs/jbd2/transaction.c |   23 ------------------
 include/linux/jbd2.h  |    2 +-
 3 files changed, 50 insertions(+), 38 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 70990d6..8771fe5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -529,20 +529,18 @@ int jbd2_log_start_commit(journal_t *journal, tid_t tid)
 }
 
 /*
- * Force and wait upon a commit if the calling process is not within
- * transaction.  This is used for forcing out undo-protected data which contains
- * bitmaps, when the fs is running out of space.
- *
- * We can only force the running transaction if we don't have an active handle;
- * otherwise, we will deadlock.
- *
- * Returns true if a transaction was started.
+ * Force and wait any uncommitted transactions.  We can only force the running
+ * transaction if we don't have an active handle, otherwise, we will deadlock.
+ * Returns: <0 in case of error,
+ *           0 if nothing to commit,
+ *           1 if transaction was successfully committed.
  */
-int jbd2_journal_force_commit_nested(journal_t *journal)
+static int __jbd2_journal_force_commit(journal_t *journal)
 {
 	transaction_t *transaction = NULL;
 	tid_t tid;
-	int need_to_start = 0;
+	int need_to_start = 0, ret = 0;
+
 
 	read_lock(&journal->j_state_lock);
 	if (journal->j_running_transaction && !current->journal_info) {
@@ -553,16 +551,53 @@ int jbd2_journal_force_commit_nested(journal_t *journal)
 		transaction = journal->j_committing_transaction;
 
 	if (!transaction) {
+		/* Nothing to commit */
 		read_unlock(&journal->j_state_lock);
-		return 0;	/* Nothing to retry */
+		return 0;
 	}
-
 	tid = transaction->t_tid;
 	read_unlock(&journal->j_state_lock);
 	if (need_to_start)
 		jbd2_log_start_commit(journal, tid);
-	jbd2_log_wait_commit(journal, tid);
-	return 1;
+	ret = jbd2_log_wait_commit(journal, tid);
+	if (!ret)
+		ret = 1;
+
+	return ret;
+}
+
+/**
+ * Force and wait upon a commit if the calling process is not within
+ * transaction.  This is used for forcing out undo-protected data which contains
+ * bitmaps, when the fs is running out of space.
+ *
+ * @journal: journal to force
+ * Returns true if progress was made.
+ */
+int jbd2_journal_force_commit_nested(journal_t *journal)
+{
+	int ret;
+
+	ret = __jbd2_journal_force_commit(journal);
+	return ret > 0;
+}
+
+/**
+ * int journal_force_commit() - force any uncommitted transactions
+ * @journal: journal to force
+ *
+ * Caller want unconditional commit. We can only force the running transaction
+ * if we don't have an active handle, otherwise, we will deadlock.
+ */
+int jbd2_journal_force_commit(journal_t *journal)
+{
+	int ret;
+
+	J_ASSERT(!current->journal_info);
+	ret = __jbd2_journal_force_commit(journal);
+	if (ret > 0)
+		ret = 0;
+	return ret;
 }
 
 /*
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index f33342a..dd422e6 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1661,29 +1661,6 @@ int jbd2_journal_stop(handle_t *handle)
 	return err;
 }
 
-/**
- * int jbd2_journal_force_commit() - force any uncommitted transactions
- * @journal: journal to force
- *
- * For synchronous operations: force any uncommitted transactions
- * to disk.  May seem kludgy, but it reuses all the handle batching
- * code in a very simple manner.
- */
-int jbd2_journal_force_commit(journal_t *journal)
-{
-	handle_t *handle;
-	int ret;
-
-	handle = jbd2_journal_start(journal, 1);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-	} else {
-		handle->h_sync = 1;
-		ret = jbd2_journal_stop(handle);
-	}
-	return ret;
-}
-
 /*
  *
  * List management code snippets: various functions for manipulating the
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index fb91c8d..c3645b9 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1160,6 +1160,7 @@ extern void	   jbd2_journal_ack_err    (journal_t *);
 extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
+extern int	   jbd2_journal_force_commit_nested(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
@@ -1235,7 +1236,6 @@ extern void	jbd2_clear_buffer_revoked_flags(journal_t *journal);
 int jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
-int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
 int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
-- 
1.7.1

