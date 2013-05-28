From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/6] jbd: optimize journal_force_commit
Date: Tue, 28 May 2013 13:18:58 +0400
Message-ID: <1369732741-26070-4-git-send-email-dmonakhov@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27617 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933714Ab3E1JTN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 05:19:13 -0400
In-Reply-To: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current implementation of journal_force_commit() is suboptimal because
result in empty and useless commits. But callers just want to force and wait
any unfinished commits. We already has journal_force_commit_nested()
which does exactly what we want, except we are guaranteed that we do not hold
journal transaction open.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd/journal.c     |   50 +++++++++++++++++++++++++++++++++++++++-----------
 fs/jbd/transaction.c |   23 -----------------------
 2 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 81cc7ea..dd7e851 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -482,19 +482,18 @@ int log_start_commit(journal_t *journal, tid_t tid)
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
  */
-int journal_force_commit_nested(journal_t *journal)
+static int __journal_force_commit(journal_t *journal, int nested, int *progress)
 {
 	transaction_t *transaction = NULL;
 	tid_t tid;
+	int ret = 0;
+
+	J_ASSERT(!current->journal_info || nested);
+	if (progress)
+		*progress = 0;
 
 	spin_lock(&journal->j_state_lock);
 	if (journal->j_running_transaction && !current->journal_info) {
@@ -510,8 +509,37 @@ int journal_force_commit_nested(journal_t *journal)
 
 	tid = transaction->t_tid;
 	spin_unlock(&journal->j_state_lock);
-	log_wait_commit(journal, tid);
-	return 1;
+	ret = log_wait_commit(journal, tid);
+	if (!ret && progress)
+		*progress = 1;
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
+int journal_force_commit_nested(journal_t *journal)
+{
+	int progress;
+
+	__journal_force_commit(journal, 1, &progress);
+	return progress;
+}
+
+/**
+ * int journal_force_commit() - force any uncommitted transactions
+ * @journal: journal to force
+ *
+ */
+int journal_force_commit(journal_t *journal)
+{
+	return __journal_force_commit(journal, 0, NULL);
 }
 
 /*
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 071d690..d3b9a13 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1483,29 +1483,6 @@ int journal_stop(handle_t *handle)
 	return err;
 }
 
-/**
- * int journal_force_commit() - force any uncommitted transactions
- * @journal: journal to force
- *
- * For synchronous operations: force any uncommitted transactions
- * to disk.  May seem kludgy, but it reuses all the handle batching
- * code in a very simple manner.
- */
-int journal_force_commit(journal_t *journal)
-{
-	handle_t *handle;
-	int ret;
-
-	handle = journal_start(journal, 1);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-	} else {
-		handle->h_sync = 1;
-		ret = journal_stop(handle);
-	}
-	return ret;
-}
