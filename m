From: dingdinghua <dingdinghua85@gmail.com>
Subject: [PATCH] set h_transaction to NULL when restart handle
Date: Tue, 14 Jul 2009 14:06:08 +0800
Message-ID: <1247551568-6307-1-git-send-email-dingdinghua85@gmail.com>
Cc: linux-ext4@vger.kernel.org, dingdinghua <dingdinghua85@gmail.com>
To: adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:44598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZGNGGR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 02:06:17 -0400
Received: by rv-out-0506.google.com with SMTP id f6so781645rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 23:06:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We may restart journal handle when do truncate or resize work, but current 
journal restart doesn't set handle->h_transaction to NULL when remove the 
handle from old transaction. This may results bugs if restart handle failed,
since this handle doesn't belongs to the old transaction any more, and the 
transaction may have been committed, checkpointed and dropped while this 
handle still refer to it.  

So an active handle has a state that doesn't belongs to any transaction now,
but current journal codes suppose that handle  must belongs to an transaction,
I add h_journal to handle_s, which points to journal.

ext4/jbd2 also has this problem. I will make & send it out if this patch working.

Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
---
 fs/ext3/ext3_jbd.c       |    8 +++++
 fs/ext3/super.c          |    6 +++-
 fs/jbd/revoke.c          |   12 ++++++--
 fs/jbd/transaction.c     |   68 +++++++++++++++++++++++++++++++++-------------
 include/linux/ext3_jbd.h |    9 +++---
 include/linux/jbd.h      |    1 +
 6 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/fs/ext3/ext3_jbd.c b/fs/ext3/ext3_jbd.c
index d401f14..17d43a5 100644
--- a/fs/ext3/ext3_jbd.c
+++ b/fs/ext3/ext3_jbd.c
@@ -57,3 +57,11 @@ int __ext3_journal_dirty_metadata(const char *where,
 		ext3_journal_abort_handle(where, __func__, bh, handle,err);
 	return err;
 }
+
+int __ext3_journal_restart(const char *where, handle_t *handle, int nblocks)
+{
+	int err = journal_restart(handle, nblocks);
+	if (err)
+		ext3_journal_abort_handle(where, __func__, NULL, handle, err);
+	return err;
+}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 524b349..1f4c694 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -105,11 +105,13 @@ handle_t *ext3_journal_start_sb(struct super_block *sb, int nblocks)
  */
 int __ext3_journal_stop(const char *where, handle_t *handle)
 {
-	struct super_block *sb;
+	struct super_block *sb = handle->h_journal->j_private;
 	int err;
 	int rc;
 
-	sb = handle->h_transaction->t_journal->j_private;
+	if (unlikely(handle->h_transaction == NULL))
+		BUG_ON(!is_handle_aborted(handle));
+
 	err = handle->h_err;
 	rc = journal_stop(handle);
 
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index da6cd9b..712f6c4 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -336,7 +336,7 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
 		   struct buffer_head *bh_in)
 {
 	struct buffer_head *bh = NULL;
-	journal_t *journal;
+	journal_t *journal = handle->h_journal;
 	struct block_device *bdev;
 	int err;
 
@@ -344,7 +344,11 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
 	if (bh_in)
 		BUFFER_TRACE(bh_in, "enter");
 
-	journal = handle->h_transaction->t_journal;
+	if (unlikely(handle->h_transaction == NULL)) {
+		J_ASSERT(is_handle_aborted(handle));
+		return -EROFS;
+	}
+
 	if (!journal_set_features(journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)){
 		J_ASSERT (!"Cannot set revoke feature!");
 		return -EINVAL;
@@ -426,13 +430,15 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
 int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
 	struct jbd_revoke_record_s *record;
-	journal_t *journal = handle->h_transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	int need_cancel;
 	int did_revoke = 0;	/* akpm: debug */
 	struct buffer_head *bh = jh2bh(jh);
 
 	jbd_debug(4, "journal_head %p, cancelling revoke\n", jh);
 
+	J_ASSERT(handle->h_transaction != NULL);
+
 	/* Is the existing Revoke bit valid?  If so, we trust it, and
 	 * only perform the full cancel if the revoke bit is set.  If
 	 * not, we can't trust the revoke bit, and we need to do the
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 73242ba..8e61801 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -220,6 +220,7 @@ repeat_locked:
 	 * use and add the handle to the running transaction. */
 
 	handle->h_transaction = transaction;
+	handle->h_journal = transaction->t_journal;
 	transaction->t_outstanding_credits += nblocks;
 	transaction->t_updates++;
 	transaction->t_handle_count++;
@@ -274,7 +275,7 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		return ERR_PTR(-EROFS);
 
 	if (handle) {
-		J_ASSERT(handle->h_transaction->t_journal == journal);
+		J_ASSERT(handle->h_journal == journal);
 		handle->h_ref++;
 		return handle;
 	}
@@ -322,11 +323,15 @@ out:
 int journal_extend(handle_t *handle, int nblocks)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	int result;
 	int wanted;
 
 	result = -EIO;
+
+	if (unlikely(transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	if (is_handle_aborted(handle))
 		goto out;
 
@@ -388,13 +393,16 @@ out:
 int journal_restart(handle_t *handle, int nblocks)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	int ret;
 
+	if (unlikely(transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	/* If we've had an abort of any type, don't even think about
 	 * actually doing the restart! */
 	if (is_handle_aborted(handle))
-		return 0;
+		return -EROFS;
 
 	/*
 	 * First unlink the handle from its current transaction, and start the
@@ -407,6 +415,7 @@ int journal_restart(handle_t *handle, int nblocks)
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
 	transaction->t_updates--;
+	handle->h_transaction = NULL;
 
 	if (!transaction->t_updates)
 		wake_up(&journal->j_wait_updates);
@@ -534,18 +543,18 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 			int force_copy)
 {
 	struct buffer_head *bh;
-	transaction_t *transaction;
-	journal_t *journal;
+	transaction_t *transaction = handle->h_transaction;
+	journal_t *journal = handle->h_journal;
 	int error;
 	char *frozen_buffer = NULL;
 	int need_copy = 0;
 
+	if (unlikely(transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	if (is_handle_aborted(handle))
 		return -EROFS;
 
-	transaction = handle->h_transaction;
-	journal = transaction->t_journal;
-
 	jbd_debug(5, "buffer_head %p, force_copy %d\n", jh, force_copy);
 
 	JBUFFER_TRACE(jh, "entry");
@@ -797,12 +806,15 @@ int journal_get_write_access(handle_t *handle, struct buffer_head *bh)
 int journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	struct journal_head *jh = journal_add_journal_head(bh);
 	int err;
 
 	jbd_debug(5, "journal_head %p\n", jh);
 	err = -EROFS;
+	if (unlikely(transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	if (is_handle_aborted(handle))
 		goto out;
 	err = 0;
@@ -951,11 +963,14 @@ out:
  */
 int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 {
-	journal_t *journal = handle->h_transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
 	int ret = 0;
 
+	if (unlikely(handle->h_transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	if (is_handle_aborted(handle))
 		return ret;
 
@@ -1143,11 +1158,15 @@ no_journal:
 int journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	struct journal_head *jh = bh2jh(bh);
 
 	jbd_debug(5, "journal_head %p\n", jh);
 	JBUFFER_TRACE(jh, "entry");
+
+	if (unlikely(transaction == NULL))
+		J_ASSERT(is_handle_aborted(handle));
+
 	if (is_handle_aborted(handle))
 		goto out;
 
@@ -1241,7 +1260,7 @@ journal_release_buffer(handle_t *handle, struct buffer_head *bh)
 int journal_forget (handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal = handle->h_journal;
 	struct journal_head *jh;
 	int drop_reserve = 0;
 	int err = 0;
@@ -1249,6 +1268,11 @@ int journal_forget (handle_t *handle, struct buffer_head *bh)
 
 	BUFFER_TRACE(bh, "entry");
 
+	if (unlikely(transaction == NULL)) {
+		J_ASSERT(is_handle_aborted(handle));
+		return err;
+	}
+
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
 
@@ -1370,18 +1394,14 @@ drop:
 int journal_stop(handle_t *handle)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
-	int err;
+	journal_t *journal = handle->h_journal;
+	int err = 0;
 	pid_t pid;
 
 	J_ASSERT(journal_current_handle() == handle);
 
 	if (is_handle_aborted(handle))
 		err = -EIO;
-	else {
-		J_ASSERT(transaction->t_updates > 0);
-		err = 0;
-	}
 
 	if (--handle->h_ref > 0) {
 		jbd_debug(4, "h_ref %d -> %d\n", handle->h_ref + 1,
@@ -1389,6 +1409,16 @@ int journal_stop(handle_t *handle)
 		return err;
 	}
 
+	if (unlikely(transaction == NULL)) {
+		/*isolated handle, can only exist when restart handle failed*/
+		J_ASSERT(is_handle_aborted(handle));
+		current->journal_info = NULL;
+		jbd_free_handle(handle);
+		return err;
+	}
+
+	J_ASSERT(transaction->t_updates > 0);
+
 	jbd_debug(4, "Handle %p going down\n", handle);
 
 	/*
diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
index cf82d51..2a3e9fd 100644
--- a/include/linux/ext3_jbd.h
+++ b/include/linux/ext3_jbd.h
@@ -136,6 +136,8 @@ int __ext3_journal_get_create_access(const char *where,
 int __ext3_journal_dirty_metadata(const char *where,
 				handle_t *handle, struct buffer_head *bh);
 
+int __ext3_journal_restart(const char *where, handle_t *handle, int nblocks);
+
 #define ext3_journal_get_undo_access(handle, bh) \
 	__ext3_journal_get_undo_access(__func__, (handle), (bh))
 #define ext3_journal_get_write_access(handle, bh) \
@@ -148,6 +150,8 @@ int __ext3_journal_dirty_metadata(const char *where,
 	__ext3_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext3_journal_forget(handle, bh) \
 	__ext3_journal_forget(__func__, (handle), (bh))
+#define ext3_journal_restart(handle, nblocks) \
+	__ext3_journal_restart(__func__, (handle), (nblocks))
 
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
 
@@ -172,11 +176,6 @@ static inline int ext3_journal_extend(handle_t *handle, int nblocks)
 	return journal_extend(handle, nblocks);
 }
 
-static inline int ext3_journal_restart(handle_t *handle, int nblocks)
-{
-	return journal_restart(handle, nblocks);
-}
