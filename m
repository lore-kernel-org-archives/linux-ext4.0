From: akpm@linux-foundation.org
Subject: [patch 276/307] jbd: fix possible journal overflow issues
Date: Mon, 28 Apr 2008 02:16:12 -0700
Message-ID: <200804280916.m3S9GCk5019157@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com, jack@ucw.cz,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762211AbYD1JVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

There are several cases where the running transaction can get buffers added to
its BJ_Metadata list which it never dirtied, which makes its t_nr_buffers
counter end up larger than its t_outstanding_credits counter.

This will cause issues when starting new transactions as while we are logging
buffers we decrement t_outstanding_buffers, so when t_outstanding_buffers goes
negative, we will report that we need less space in the journal than we
actually need, so transactions will be started even though there may not be
enough room for them.  In the worst case scenario (which admittedly is almost
impossible to reproduce) this will result in the journal running out of space.

The fix is to only
refile buffers from the committing transaction to the running transactions
BJ_Modified list when b_modified is set on that journal, which is the only way
to be sure if the running transaction has modified that buffer.

This patch also fixes an accounting error in journal_forget, it is possible
that we can call journal_forget on a buffer without having modified it, only
gotten write access to it, so instead of freeing a credit, we only do so if
the buffer was modified.  The assert will help catch if this problem occurs. 
Without these two patches I could hit this assert within minutes of running
postmark, with them this issue no longer arises.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Acked-by: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c      |    3 +++
 fs/jbd/transaction.c |   21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff -puN fs/jbd/commit.c~jbd-fix-possible-journal-overflow-issues fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-fix-possible-journal-overflow-issues
+++ a/fs/jbd/commit.c
@@ -472,6 +472,9 @@ void journal_commit_transaction(journal_
 	 */
 	commit_transaction->t_state = T_COMMIT;
 
+	J_ASSERT(commit_transaction->t_nr_buffers <=
+		 commit_transaction->t_outstanding_credits);
+
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
diff -puN fs/jbd/transaction.c~jbd-fix-possible-journal-overflow-issues fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-fix-possible-journal-overflow-issues
+++ a/fs/jbd/transaction.c
@@ -1235,6 +1235,7 @@ int journal_forget (handle_t *handle, st
 	struct journal_head *jh;
 	int drop_reserve = 0;
 	int err = 0;
+	int was_modified = 0;
 
 	BUFFER_TRACE(bh, "entry");
 
@@ -1253,6 +1254,9 @@ int journal_forget (handle_t *handle, st
 		goto not_jbd;
 	}
 
+	/* keep track of wether or not this transaction modified us */
+	was_modified = jh->b_modified;
+
 	/*
 	 * The buffer's going from the transaction, we must drop
 	 * all references -bzzz
@@ -1270,7 +1274,12 @@ int journal_forget (handle_t *handle, st
 
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
@@ -1310,7 +1319,13 @@ int journal_forget (handle_t *handle, st
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
 
@@ -2082,7 +2097,7 @@ void __journal_refile_buffer(struct jour
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
 	__journal_file_buffer(jh, jh->b_transaction,
-				was_dirty ? BJ_Metadata : BJ_Reserved);
+				jh->b_modified ? BJ_Metadata : BJ_Reserved);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
_
