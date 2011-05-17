From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] jbd2: Provide function to check whether transaction will issue data barrier
Date: Tue, 17 May 2011 12:28:14 +0200
Message-ID: <1305628095-27843-2-git-send-email-jack@suse.cz>
References: <1305628095-27843-1-git-send-email-jack@suse.cz>
Cc: Edward Goggin <egoggin@vmware.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1EQK2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 06:28:48 -0400
In-Reply-To: <1305628095-27843-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a function which returns whether a transaction with given tid
will send a barrier to the filesystem device. The function will be used
by ext4 to detect whether fsync needs to send a separate barrier or not.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c     |    6 +++++-
 fs/jbd2/journal.c    |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h |    3 ++-
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6e28000..e7812ed 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -800,6 +800,10 @@ wait_for_iobuf:
 		jbd2_journal_abort(journal, err);
 
 	jbd_debug(3, "JBD: commit phase 5\n");
+	write_lock(&journal->j_state_lock);
+	J_ASSERT(commit_transaction->t_state == T_COMMIT);
+	commit_transaction->t_state = T_COMMIT_RECORD;
+	write_unlock(&journal->j_state_lock);
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
 				       JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
@@ -955,7 +959,7 @@ restart_loop:
 
 	jbd_debug(3, "JBD: commit phase 7\n");
 
-	J_ASSERT(commit_transaction->t_state == T_COMMIT);
+	J_ASSERT(commit_transaction->t_state == T_COMMIT_RECORD);
 
 	commit_transaction->t_start = jiffies;
 	stats.run.rs_logging = jbd2_time_diff(stats.run.rs_logging,
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e0ec3db..dbafbc5 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -577,6 +577,43 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 }
 
 /*
+ * Return 1 if a given transaction has not yet sent barrier request
+ * connected with a transaction commit. If 0 is returned, transaction
+ * may or may not have sent the barrier. Used to avoid sending barrier
+ * twice in common cases.
+ */
+int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
+{
+	int ret = 0;
+	transaction_t *commit_trans;
+
+	/*
+	 * For external journal sending data barrier is more complex so just
+	 * admit we don't know...
+	 */
+	if (!(journal->j_flags & JBD2_BARRIER) ||
+	    journal->j_fs_dev != journal->j_dev)
+		return 0;
+	read_lock(&journal->j_state_lock);
+	/* Transaction already committed? */
+	if (tid_geq(journal->j_commit_sequence, tid))
+		goto out;
+	/*
+	 * Transaction is being committed and we already proceeded to
+	 * submitting barrier?
+	 */
+	commit_trans = journal->j_committing_transaction;
+	if (commit_trans && commit_trans->t_tid == tid &&
+	    commit_trans->t_state >= T_COMMIT_RECORD)
+		goto out;
+	ret = 1;
+out:
+	read_unlock(&journal->j_state_lock);
+	return ret;
+}
+EXPORT_SYMBOL(jbd2_trans_will_send_data_barrier);
+
+/*
  * Wait for a specified commit to complete.
  * The caller may not hold the journal lock.
  */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..fea6d6f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -529,9 +529,9 @@ struct transaction_s
 	enum {
 		T_RUNNING,
 		T_LOCKED,
-		T_RUNDOWN,
 		T_FLUSH,
 		T_COMMIT,
+		T_COMMIT_RECORD,
 		T_FINISHED
 	}			t_state;
 
@@ -1228,6 +1228,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
+int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
 
 void __jbd2_log_wait_for_space(journal_t *journal);
 extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
-- 
1.7.1

