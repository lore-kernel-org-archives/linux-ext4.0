From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext3: Use WRITE_SYNC for commits which are caused by fsync()
Date: Fri, 27 Mar 2009 16:24:30 -0400
Message-ID: <1238185471-31152-3-git-send-email-tytso@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
 <1238185471-31152-2-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45713 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761539AbZC0UYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:35 -0400
In-Reply-To: <1238185471-31152-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a commit is triggered by fsync(), set a flag indicating the journal
blocks associated with the transaction should be flushed out using
WRITE_SYNC.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd/commit.c      |   23 +++++++++++++++--------
 fs/jbd/transaction.c |    2 ++
 include/linux/jbd.h  |    5 +++++
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 3fbffb1..f8077b9 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/bio.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -171,14 +172,15 @@ static int journal_write_commit_record(journal_t *journal,
 	return (ret == -EIO);
 }
 
-static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
+static void journal_do_submit_data(struct buffer_head **wbuf, int bufs,
+				   int write_op)
 {
 	int i;
 
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
 		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
+		submit_bh(write_op, wbuf[i]);
 	}
 }
 
@@ -186,7 +188,8 @@ static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
  *  Submit all the data buffers to disk
  */
 static int journal_submit_data_buffers(journal_t *journal,
-				transaction_t *commit_transaction)
+				       transaction_t *commit_transaction,
+				       int write_op)
 {
 	struct journal_head *jh;
 	struct buffer_head *bh;
@@ -225,7 +228,7 @@ write_out_data:
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
-				journal_do_submit_data(wbuf, bufs);
+				journal_do_submit_data(wbuf, bufs, write_op);
 				bufs = 0;
 				lock_buffer(bh);
 				spin_lock(&journal->j_list_lock);
@@ -256,7 +259,7 @@ write_out_data:
 			jbd_unlock_bh_state(bh);
 			if (bufs == journal->j_wbufsize) {
 				spin_unlock(&journal->j_list_lock);
-				journal_do_submit_data(wbuf, bufs);
+				journal_do_submit_data(wbuf, bufs, write_op);
 				bufs = 0;
 				goto write_out_data;
 			}
@@ -286,7 +289,7 @@ write_out_data:
 		}
 	}
 	spin_unlock(&journal->j_list_lock);
-	journal_do_submit_data(wbuf, bufs);
+	journal_do_submit_data(wbuf, bufs, write_op);
 
 	return err;
 }
@@ -315,6 +318,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
+	int write_op = WRITE;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -347,6 +351,8 @@ void journal_commit_transaction(journal_t *journal)
 	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_LOCKED;
 
+	if (commit_transaction->t_synchronous_commit)
+		write_op = WRITE_SYNC;
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
@@ -431,7 +437,8 @@ void journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction,
+					  write_op);
 
 	/*
 	 * Wait for all previously submitted IO to complete.
@@ -660,7 +667,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE, bh);
+				submit_bh(write_op, bh);
 			}
 			cond_resched();
 
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index e6a1174..ed886e6 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1440,6 +1440,8 @@ int journal_stop(handle_t *handle)
 		}
 	}
 
+	if (handle->h_sync)
+		transaction->t_synchronous_commit = 1;
 	current->journal_info = NULL;
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 64246dc..2c69431 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -552,6 +552,11 @@ struct transaction_s
 	 */
 	int t_handle_count;
 
+	/*
+	 * This transaction is being forced and some process is
+	 * waiting for it to finish.
+	 */
+	int t_synchronous_commit:1;
 };
 
 /**
-- 
1.5.6.3

