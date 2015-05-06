From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: fix NULL pointer dereference when journal restart fails
Date: Wed,  6 May 2015 10:05:13 +0200
Message-ID: <1430899514-19128-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbEFIFY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2015 04:05:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently when journal restart fails, we'll have the h_transaction of
the handle set to NULL to indicate that the handle has been effectively
aborted. However it's not _really_ aborted and we need to treat this
differently because an abort indicates critical error which might not be
the case here.

So we handle this situation quietly in the jbd2_journal_stop() and just
free the handle and exit because everything else has been done before we
attempted (and failed) to restart the journal.

Unfortunately there are a number of problems with that approach
introduced with commit

41a5b913197c "jbd2: invalidate handle if jbd2_journal_restart()
fails"

First of all in ext4 jbd2_journal_stop() will be called through
__ext4_journal_stop() where we would try to get a hold of the superblock
by dereferencing h_transaction which in this case would lead to NULL
pointer dereference and crash.

In addition we're going to free the handle regardless of the refcount
which is bad as well, because other's up the call chain will still
reference the handle so we might potentially reference already freed
memory.

I think that setting the h_transaction to NULL is just a hack and we can
do this properly by introducing h_stopped flag to the handle structure.

Now we use h_stopped flag to indicate that the handle has already
been stopped so there is nothing else to do in jbd2_journal_stop() other
than decrease the refcount, or free the handle structure (in case refcount
drops to zero) and exit which exactly fits our case. So if we fail to start
the handle in jbd2__journal_restart() instead of setting h_transaction to
NULL we set the h_stopped flag and let the jbd2_journal_stop() deal with
this.

This will also fix the NULL dereference because we no longer free the
h_transaction.

Moreover remove all the WARN_ON's when we're dealing with already
stopped handle. Again the situation is quite similar with the aborted
handle and it is possible to get an already stopped handle, in this case
we do not want to emit an backtrace.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/jbd2/transaction.c | 45 ++++++++++++++++++++++++++-------------------
 include/linux/jbd2.h  | 20 +++++++++++++++++++-
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5f09370..34bd0c5 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -361,6 +361,7 @@ repeat:
 	handle->h_transaction = transaction;
 	handle->h_requested_credits = blocks;
 	handle->h_start_jiffies = jiffies;
+	handle->h_stopped = 0;
 	atomic_inc(&transaction->t_updates);
 	atomic_inc(&transaction->t_handle_count);
 	jbd_debug(4, "Handle %p given %d credits (total %d, free %lu)\n",
@@ -551,8 +552,7 @@ int jbd2_journal_extend(handle_t *handle, int nblocks)
 	int result;
 	int wanted;
 
-	WARN_ON(!transaction);
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		return -EROFS;
 	journal = transaction->t_journal;
 
@@ -627,11 +627,10 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 	tid_t		tid;
 	int		need_to_start, ret;
 
-	WARN_ON(!transaction);
 	/* If we've had an abort of any type, don't even think about
 	 * actually doing the restart! */
-	if (is_handle_aborted(handle))
-		return 0;
+	if (is_handle_aborted_or_stopped(handle))
+		return -EROFS;
 	journal = transaction->t_journal;
 
 	/*
@@ -653,7 +652,7 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
 		wake_up(&journal->j_wait_updates);
 	tid = transaction->t_tid;
 	spin_unlock(&transaction->t_handle_lock);
-	handle->h_transaction = NULL;
+	jbd2_journal_stop_handle(handle);
 	current->journal_info = NULL;
 
 	jbd_debug(2, "restarting handle %p\n", handle);
@@ -785,8 +784,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	int need_copy = 0;
 	unsigned long start_lock, time_lock;
 
-	WARN_ON(!transaction);
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		return -EROFS;
 	journal = transaction->t_journal;
 
@@ -849,7 +847,7 @@ repeat:
 	unlock_buffer(bh);
 
 	error = -EROFS;
-	if (is_handle_aborted(handle)) {
+	if (is_handle_aborted_or_stopped(handle)) {
 		jbd_unlock_bh_state(bh);
 		goto out;
 	}
@@ -1051,9 +1049,8 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	int err;
 
 	jbd_debug(5, "journal_head %p\n", jh);
-	WARN_ON(!transaction);
 	err = -EROFS;
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		goto out;
 	journal = transaction->t_journal;
 	err = 0;
@@ -1266,8 +1263,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	struct journal_head *jh;
 	int ret = 0;
 
-	WARN_ON(!transaction);
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		return -EROFS;
 	journal = transaction->t_journal;
 	jh = jbd2_journal_grab_journal_head(bh);
@@ -1397,8 +1393,7 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 	int err = 0;
 	int was_modified = 0;
 
-	WARN_ON(!transaction);
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		return -EROFS;
 	journal = transaction->t_journal;
 
@@ -1530,8 +1525,19 @@ int jbd2_journal_stop(handle_t *handle)
 	tid_t tid;
 	pid_t pid;
 
-	if (!transaction)
-		goto free_and_exit;
+	if (is_handle_stopped(handle)) {
+		/*
+		 * Handle is stopped so there is nothing to do other than
+		 * decrease a refcount, or free the handle if refcount
+		 * drops to zero
+		 */
+		if (--handle->h_ref > 0) {
+			jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
+							 handle->h_ref);
+			return err;
+		} else
+			goto free_and_exit;
+	}
 	journal = transaction->t_journal;
 
 	J_ASSERT(journal_current_handle() == handle);
@@ -1665,7 +1671,9 @@ int jbd2_journal_stop(handle_t *handle)
 
 	if (handle->h_rsv_handle)
 		jbd2_journal_free_reserved(handle->h_rsv_handle);
+
 free_and_exit:
+	jbd2_journal_stop_handle(handle);
 	jbd2_free_handle(handle);
 	return err;
 }
@@ -2373,8 +2381,7 @@ int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal;
 
-	WARN_ON(!transaction);
-	if (is_handle_aborted(handle))
+	if (is_handle_aborted_or_stopped(handle))
 		return -EROFS;
 	journal = transaction->t_journal;
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 20e7f78..349975e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -441,6 +441,7 @@ struct jbd2_journal_handle
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_reserved:	1;	/* handle with reserved credits */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+	unsigned int	h_stopped:	1;	/* handle is already stopped */
 	unsigned int	h_type:		8;	/* for handle statistics */
 	unsigned int	h_line_no:	16;	/* for handle statistics */
 
@@ -1266,18 +1267,35 @@ static inline int is_journal_aborted(journal_t *journal)
 	return journal->j_flags & JBD2_ABORT;
 }
 
+static inline int is_handle_stopped(handle_t *handle)
+{
+	return handle->h_stopped;
+}
+
 static inline int is_handle_aborted(handle_t *handle)
 {
-	if (handle->h_aborted || !handle->h_transaction)
+	if (handle->h_aborted)
 		return 1;
 	return is_journal_aborted(handle->h_transaction->t_journal);
 }
 
+static inline int is_handle_aborted_or_stopped(handle_t *handle)
+{
+	if (is_handle_aborted(handle) || is_handle_stopped(handle))
+		return 1;
+	return 0;
+}
+
 static inline void jbd2_journal_abort_handle(handle_t *handle)
 {
 	handle->h_aborted = 1;
 }
 
+static inline void jbd2_journal_stop_handle(handle_t *handle)
+{
+	handle->h_stopped = 1;
+}
+
 #endif /* __KERNEL__   */
 
 /* Comparison functions for transaction IDs: perform comparisons using
-- 
1.8.3.1

