From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 2/2] fix possible journal overflow issues
Date: Wed, 27 Feb 2008 13:51:53 -0500
Message-ID: <200802271351.54026.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758204AbYB0TDN@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

There are several cases where the running transaction can get buffers added to 
its BJ_Metadata list which it never dirtied, which makes its t_nr_buffers 
counter end up larger than its t_outstanding_credits counter.  This will cause 
issues when starting new transactions as while we are logging buffers we 
decrement t_outstanding_buffers, so when t_outstanding_buffers goes negative, 
we will report that we need less space in the journal than we actually need, so 
transactions will be started even though there may not be enough room for them.  
In the worst case scenario (which admittedly is almost impossible to reproduce) 
this will result in the journal running out of space.  The fix is to only 
refile buffers from the committing transaction to the running transactions 
BJ_Modified list when b_modified is set on that journal, which is the only way 
to be sure if the running transaction has modified that buffer.  This patch 
also fixes an accounting error in journal_forget, it is possible that we can 
call journal_forget on a buffer without having modified it, only gotten write 
access to it, so instead of freeing a credit, we only do so if the buffer was 
modified.  The assert will help catch if this problem occurs.  Without these 
two patches I could hit this assert within minutes of running postmark, with 
them this issue no longer arises.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -1234,6 +1234,7 @@ int journal_forget (handle_t *handle, st
 	struct journal_head *jh;
 	int drop_reserve = 0;
 	int err = 0;
+	int was_modified = 0;
 
 	BUFFER_TRACE(bh, "entry");
 
@@ -1252,6 +1253,9 @@ int journal_forget (handle_t *handle, st
 		goto not_jbd;
 	}
 
+	/* keep track of wether or not this transaction modified us */
+	was_modified = jh->b_modified;
+
 	/*
 	 * The buffer's going from the transaction, we must drop
 	 * all references -bzzz
@@ -1269,7 +1273,12 @@ int journal_forget (handle_t *handle, st
 
 		JBUFFER_TRACE(jh, "belongs to current transaction: unfile");
 
-		drop_reserve = 1;
+		/*
+		 * we only want to drop a reference if this transaction
+		 * modified the buffer
+		 */
+		if (was_modified)
+			drop_reserve = 1;
 
 		/*
 		 * We are no longer going to journal this buffer.
@@ -1309,7 +1318,13 @@ int journal_forget (handle_t *handle, st
 		if (jh->b_next_transaction) {
 			J_ASSERT(jh->b_next_transaction == transaction);
 			jh->b_next_transaction = NULL;
-			drop_reserve = 1;
+
+			/*
+			 * only drop a reference if this transaction modified
+			 * the buffer
+			 */
+			if (was_modified)
+				drop_reserve = 1;
 		}
 	}
 
@@ -2081,7 +2096,7 @@ void __journal_refile_buffer(struct jour
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
 	__journal_file_buffer(jh, jh->b_transaction,
-				was_dirty ? BJ_Metadata : BJ_Reserved);
+				jh->b_modified ? BJ_Metadata : BJ_Reserved);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
Index: linux-2.6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd2/transaction.c
+++ linux-2.6/fs/jbd2/transaction.c
@@ -1243,6 +1243,7 @@ int jbd2_journal_forget (handle_t *handl
 	struct journal_head *jh;
 	int drop_reserve = 0;
 	int err = 0;
+	int was_modified = 0;
 
 	BUFFER_TRACE(bh, "entry");
 
@@ -1261,6 +1262,9 @@ int jbd2_journal_forget (handle_t *handl
 		goto not_jbd;
 	}
 
+	/* keep track of wether or not this transaction modified us */
+	was_modified = jh->b_modified;
+
 	/*
 	 * The buffer's going from the transaction, we must drop
 	 * all references -bzzz
@@ -1278,7 +1282,12 @@ int jbd2_journal_forget (handle_t *handl
 
 		JBUFFER_TRACE(jh, "belongs to current transaction: unfile");
 
-		drop_reserve = 1;
+		/*
+		 * we only want to drop a reference if this transaction
+		 * modified the buffer
+		 */
+		if (was_modified)
+			drop_reserve = 1;
 
 		/*
 		 * We are no longer going to journal this buffer.
@@ -1318,7 +1327,13 @@ int jbd2_journal_forget (handle_t *handl
 		if (jh->b_next_transaction) {
 			J_ASSERT(jh->b_next_transaction == transaction);
 			jh->b_next_transaction = NULL;
-			drop_reserve = 1;
+
+			/*
+			 * only drop a reference if this transaction modified
+			 * the buffer
+			 */
+			if (was_modified)
+				drop_reserve = 1;
 		}
 	}
 
@@ -2090,7 +2105,7 @@ void __jbd2_journal_refile_buffer(struct
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
 	__jbd2_journal_file_buffer(jh, jh->b_transaction,
-				was_dirty ? BJ_Metadata : BJ_Reserved);
+				jh->b_modified ? BJ_Metadata : BJ_Reserved);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -472,6 +472,9 @@ void journal_commit_transaction(journal_
 	 */
 	commit_transaction->t_state = T_COMMIT;
 
+	J_ASSERT(commit_transaction->t_nr_buffers <=
+		 commit_transaction->t_outstanding_credits);
+
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c
+++ linux-2.6/fs/jbd2/commit.c
@@ -568,6 +568,9 @@ void jbd2_journal_commit_transaction(jou
 	stats.u.run.rs_blocks = commit_transaction->t_outstanding_credits;
 	stats.u.run.rs_blocks_logged = 0;
 
+	J_ASSERT(commit_transaction->t_nr_buffers <=
+		 commit_transaction->t_outstanding_credits);
+
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
