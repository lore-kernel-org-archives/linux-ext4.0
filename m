From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH v2 2/3] jbd2: Add extra parameter in start_this_handle() to control allocation flags.
Date: Fri, 27 May 2011 23:20:57 -0700
Message-ID: <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
Cc: Manish Katiyar <mkatiyar@gmail.com>
To: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42559 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1E1GVP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2011 02:21:15 -0400
Received: by pwi15 with SMTP id 15so1067541pwi.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 May 2011 23:21:14 -0700 (PDT)
In-Reply-To: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

changes from v1 -> v2 :
*) Update start_this_handle to take extra parameter to specify whether
to retry the allocation or not.
*) Added jbd allocation flags for callers to control the transaction allocation
behavior. Callers can pass JBD2_TOPLEVEL if allocation needs to be done using GFP_KERNEL.

Pass extra flags in journal routines to specify if its ok to
fail in the journal transaction allocation. Passing JBD2_FAIL_OK means caller is
ok with journal start failures and can handle ENOMEM.

Update ocfs2 and ext4 routines to pass JBD2_NO_FAIL for the updated journal
interface by default, to retain the existing behavior.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/ext4_jbd2.h   |    2 +-
 fs/ext4/super.c       |    2 +-
 fs/jbd2/transaction.c |   44 ++++++++++++++++----------------------------
 fs/ocfs2/journal.c    |    8 ++++----
 include/linux/jbd2.h  |   13 +++++++++----
 5 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index bb85757..14e6599 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -220,7 +220,7 @@ static inline int ext4_journal_extend(handle_t *handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, JBD2_NO_FAIL);
 	return 0;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d9937df..aa842f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -295,7 +295,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks);
+	return jbd2_journal_start(journal, nblocks, JBD2_NO_FAIL);
 }
 
 /*
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3eec82d..7f53589 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -106,6 +106,11 @@ static inline void update_t_max_wait(transaction_t *transaction,
 #endif
 }
 
+static inline int __jbd_flags_to_mask(int jbd_alloc_flags)
+{
+	return (jbd_alloc_flags & JBD2_TOPLEVEL) ? GFP_KERNEL : GFP_NOFS;
+}
+
 /*
  * start_this_handle: Given a handle, deal with any locking or stalling
  * needed to make sure that there is enough journal space for the handle
@@ -114,13 +119,14 @@ static inline void update_t_max_wait(transaction_t *transaction,
  */
 
 static int start_this_handle(journal_t *journal, handle_t *handle,
-			     int gfp_mask)
+			     int jbd_alloc_flags)
 {
 	transaction_t	*transaction, *new_transaction = NULL;
 	tid_t		tid;
 	int		needed, need_to_start;
 	int		nblocks = handle->h_buffer_credits;
 	unsigned long ts = jiffies;
+	int gfp_mask = __jbd_flags_to_mask(jbd_alloc_flags);
 
 	if (nblocks > journal->j_max_transaction_buffers) {
 		printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
@@ -133,14 +139,7 @@ alloc_transaction:
 	if (!journal->j_running_transaction) {
 		new_transaction = kzalloc(sizeof(*new_transaction), gfp_mask);
 		if (!new_transaction) {
-			/*
-			 * If __GFP_FS is not present, then we may be
-			 * being called from inside the fs writeback
-			 * layer, so we MUST NOT fail.  Since
-			 * __GFP_NOFAIL is going away, we will arrange
-			 * to retry the allocation ourselves.
-			 */
-			if ((gfp_mask & __GFP_FS) == 0) {
+			if (jbd_alloc_flags & JBD2_NO_FAIL) {
 				congestion_wait(BLK_RW_ASYNC, HZ/50);
 				goto alloc_transaction;
 			}
@@ -308,6 +307,7 @@ static handle_t *new_handle(int nblocks)
  * handle_t *jbd2_journal_start() - Obtain a new handle.
  * @journal: Journal to start transaction on.
  * @nblocks: number of block buffer we might modify
+ * @jbd_alloc_flags:  jbd allocation flags for transaction.
  *
  * We make sure that the transaction can guarantee at least nblocks of
  * modified buffers in the log.  We block until the log can guarantee
@@ -319,7 +319,8 @@ static handle_t *new_handle(int nblocks)
  * Return a pointer to a newly allocated handle, or an ERR_PTR() value
  * on failure.
  */
-handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
+handle_t *jbd2_journal_start(journal_t *journal,
+			     int nblocks, int jbd_alloc_flags)
 {
 	handle_t *handle = journal_current_handle();
 	int err;
@@ -339,7 +340,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 
 	current->journal_info = handle;
 
-	err = start_this_handle(journal, handle, gfp_mask);
+	err = start_this_handle(journal, handle, jbd_alloc_flags);
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
@@ -347,13 +348,6 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 	}
 	return handle;
 }
-EXPORT_SYMBOL(jbd2__journal_start);
-
-
-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
-{
-	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_start);
 
 
@@ -442,7 +436,8 @@ out:
  * transaction capabable of guaranteeing the requested number of
  * credits.
  */
-int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
+int jbd2_journal_restart(handle_t *handle,
+			 int nblocks, int jbd_alloc_flags)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
@@ -478,16 +473,9 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
 
 	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
-	ret = start_this_handle(journal, handle, gfp_mask);
+	ret = start_this_handle(journal, handle, jbd_alloc_flags);
 	return ret;
 }
-EXPORT_SYMBOL(jbd2__journal_restart);
-
-
-int jbd2_journal_restart(handle_t *handle, int nblocks)
-{
-	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_restart);
 
 /**
@@ -1437,7 +1425,7 @@ int jbd2_journal_force_commit(journal_t *journal)
 	handle_t *handle;
 	int ret;
 
-	handle = jbd2_journal_start(journal, 1);
+	handle = jbd2_journal_start(journal, 1, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 	} else {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index b141a44..a784a64 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -353,11 +353,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 
 	/* Nested transaction? Just return the handle... */
 	if (journal_current_handle())
-		return jbd2_journal_start(journal, max_buffs);
+		return jbd2_journal_start(journal, max_buffs, JBD2_NO_FAIL);
 
 	down_read(&osb->journal->j_trans_barrier);
 
-	handle = jbd2_journal_start(journal, max_buffs);
+	handle = jbd2_journal_start(journal, max_buffs, JBD2_NO_FAIL);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);
 
@@ -437,8 +437,8 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	if (status > 0) {
 		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
-		status = jbd2_journal_restart(handle,
-					      old_nblocks + nblocks);
+		status = jbd2_journal_restart(handle, old_nblocks + nblocks,
+					      JBD2_NO_FAIL);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 4ecb7b1..c11181b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1106,10 +1106,10 @@ static inline handle_t *journal_current_handle(void)
  * Register buffer modifications against the current transaction.
  */
 
-extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
-extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
-extern int	 jbd2_journal_restart(handle_t *, int nblocks);
-extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
+extern handle_t *jbd2_journal_start(journal_t *,
+				    int nblocks, int jbd_alloc_flags);
+extern int	 jbd2_journal_restart(handle_t *,
+				      int nblocks, int jbd_alloc_flags);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
@@ -1322,6 +1322,11 @@ static inline int jbd_space_needed(journal_t *journal)
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
+/* JBD2 transaction allocation flags */
+#define JBD2_NO_FAIL	0x00000001
+#define JBD2_FAIL_OK	0x00000002
+#define JBD2_TOPLEVEL	0x00000004
+
 #ifdef __KERNEL__
 
 #define buffer_trace_init(bh)	do {} while (0)
-- 
1.7.4.1

