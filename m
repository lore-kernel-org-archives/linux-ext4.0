From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 20/30] ext4: snapshot journaled - increase transaction credits
Date: Mon,  9 May 2011 19:41:38 +0300
Message-ID: <1304959308-11122-21-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1EIQoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:08 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:07 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Snapshot operations are journaled as part of the running transaction.
The amount of requested credits is multiplied with a factor, to ensure
that enough buffer credits are reserved in the running transaction.
The new field h_base_credits stored to original credits request and
the new filed u_user_credits counts the number of credits used by
non-COW operations.  They are especially useful when exteding a large
transaction, which did not use the extra COW credits it requested.
In this case, only the missing extra credits are requested.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.c |   21 +++++++
 fs/ext4/ext4_jbd2.h |  159 ++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/resize.c    |    2 +-
 fs/ext4/super.c     |   38 ++++++++++++-
 4 files changed, 202 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index c44c362..015f727 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -131,6 +131,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 handle_t *handle, struct inode *inode,
 				 struct buffer_head *bh)
 {
+	struct super_block *sb;
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
@@ -138,6 +139,26 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
+		if (err)
+			return err;
+		sb = handle->h_transaction->t_journal->j_private;
+		if (EXT4_SNAPSHOTS(sb) && !IS_COWING(handle)) {
+			struct journal_head *jh = bh2jh(bh);
+			jbd_lock_bh_state(bh);
+			/*
+			 * buffer_credits was decremented when buffer was
+			 * modified for the first time in the current
+			 * transaction, which may have been during a COW
+			 * operation.  We decrement user_credits and mark
+			 * b_modified = 2, on the first time that the buffer
+			 * is modified not during a COW operation (!h_cowing).
+			 */
+			if (jh->b_modified == 1) {
+				jh->b_modified = 2;
+				handle->h_user_credits--;
+			}
+			jbd_unlock_bh_state(bh);
+		}
 	} else {
 		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 79b6594..e80402b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -83,6 +83,62 @@
  * one block, plus two quota updates.  Quota allocations are not
  * needed. */
 
+/* on block write we have to journal the block itself */
+#define EXT4_WRITE_CREDITS 1
+/* on snapshot block alloc we have to journal block group bitmap, exclude
+   bitmap and gdb */
+#define EXT4_ALLOC_CREDITS 3
+/* number of credits for COW bitmap operation (allocated blocks are not
+   journalled): alloc(dind+ind+cow) = 9 */
+#define EXT4_COW_BITMAP_CREDITS	(3*EXT4_ALLOC_CREDITS)
+/* number of credits for other block COW operations:
+   alloc(dind+ind+cow)+write(dind+ind) = 11 */
+#define EXT4_COW_BLOCK_CREDITS	(3*EXT4_ALLOC_CREDITS+2*EXT4_WRITE_CREDITS)
+/* number of credits for the first COW operation in the block group, which
+ * is not the first group in a flex group (alloc 2 dind blocks):
+   9+11 = 20 */
+#define EXT4_COW_CREDITS	(EXT4_COW_BLOCK_CREDITS +	\
+				 EXT4_COW_BITMAP_CREDITS)
+/* number of credits for snapshot operations counted once per transaction:
+   write(sb+inode+tind) = 3 */
+#define EXT4_SNAPSHOT_CREDITS	(3*EXT4_WRITE_CREDITS)
+/*
+ * in total, for N COW operations, we may have to journal 20N+3 blocks,
+ * and we also want to reserve 20+3 credits for the last COW operation,
+ * so we add 20(N-1)+3+(20+3) to the requested N buffer credits
+ * and request 21N+6 buffer credits.
+ * that's a lot of extra credits and much more then needed for the common
+ * case, but what can we do?
+ *
+ * we are going to need a bigger journal to accommodate the
+ * extra snapshot credits.
+ * mke2fs -j uses the following default formula for fs-size above 1G:
+ * journal-size = MIN(128M, fs-size/32)
+ * mke2fs -j -J big uses the following formula:
+ * journal-size = MIN(3G, fs-size/32)
+ */
+#define EXT4_SNAPSHOT_TRANS_BLOCKS(n) \
+	((n)*(1+EXT4_COW_CREDITS)+EXT4_SNAPSHOT_CREDITS)
+#define EXT4_SNAPSHOT_START_TRANS_BLOCKS(n) \
+	((n)*(1+EXT4_COW_CREDITS)+2*EXT4_SNAPSHOT_CREDITS)
+
+/*
+ * check for sufficient buffer and COW credits
+ */
+#define EXT4_SNAPSHOT_HAS_TRANS_BLOCKS(handle, n)			\
+	((handle)->h_buffer_credits >= EXT4_SNAPSHOT_TRANS_BLOCKS(n) && \
+	 (handle)->h_user_credits >= (n))
+
+#define EXT4_RESERVE_COW_CREDITS	(EXT4_COW_CREDITS +		\
+					 EXT4_SNAPSHOT_CREDITS)
+
+/*
+ * Ext4 is not designed for filesystems under 4G with journal size < 128M
+ * Recommended journal size is 3G (created with 'mke2fs -j -J big')
+ */
+#define EXT4_MIN_JOURNAL_BLOCKS	32768U
+#define EXT4_BIG_JOURNAL_BLOCKS	(24*EXT4_MIN_JOURNAL_BLOCKS)
+
 #define EXT4_RESERVE_TRANS_BLOCKS	12U
 
 #define EXT4_INDEX_EXTRA_TRANS_BLOCKS	8
@@ -176,7 +232,19 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define trace_cow_add(handle, name, num)
 #define trace_cow_inc(handle, name)
 
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
+#define ext4_journal_trace(n, caller, handle, nblocks)
+
+handle_t *__ext4_journal_start(const char *where,
+		struct super_block *sb, int nblocks);
+
+#define ext4_journal_start_sb(sb, nblocks) \
+	__ext4_journal_start(__func__, \
+			(sb), (nblocks))
+
+#define ext4_journal_start(inode, nblocks) \
+	__ext4_journal_start(__func__, \
+			(inode)->i_sb, (nblocks))
+
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
 
 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
@@ -212,16 +280,20 @@ static inline int ext4_handle_is_aborted(handle_t *handle)
 
 static inline int ext4_handle_has_enough_credits(handle_t *handle, int needed)
 {
-	if (ext4_handle_valid(handle) && handle->h_buffer_credits < needed)
+	struct super_block *sb;
+
+	if (!ext4_handle_valid(handle))
+		return 1;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (EXT4_SNAPSHOTS(sb))
+		return EXT4_SNAPSHOT_HAS_TRANS_BLOCKS(handle, needed);
+	/* sb has no snapshot feature */
+	if (handle->h_buffer_credits < needed)
 		return 0;
 	return 1;
 }
 
-static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
-{
-	return ext4_journal_start_sb(inode->i_sb, nblocks);
-}
-
 #define ext4_journal_stop(handle) \
 	__ext4_journal_stop(__func__, __LINE__, (handle))
 
@@ -230,20 +302,77 @@ static inline handle_t *ext4_journal_current_handle(void)
 	return journal_current_handle();
 }
 
-static inline int ext4_journal_extend(handle_t *handle, int nblocks)
+/*
+ * Ext4 wrapper for journal_extend()
+ * When transaction runs out of buffer credits it is possible to try and
+ * extend the buffer credits without restarting the transaction.
+ * Ext4 wrapper for journal_start() has increased the user requested buffer
+ * credits to include the extra credits for COW operations.
+ * This wrapper checks the remaining user credits and how many COW credits
+ * are missing and then tries to extend the transaction.
+ */
+static inline int __ext4_journal_extend(const char *where,
+					handle_t *handle, int nblocks)
 {
-	if (ext4_handle_valid(handle))
-		return jbd2_journal_extend(handle, nblocks);
-	return 0;
+	int credits = 0;
+	int err = 0;
+	struct super_block *sb;
+
+	if (!ext4_handle_valid((handle_t *)handle))
+		return 0;
+
+	credits = nblocks;
+	sb = handle->h_transaction->t_journal->j_private;
+	if (EXT4_SNAPSHOTS(sb)) {
+		/* extend transaction to valid buffer/user credits ratio */
+		credits = EXT4_SNAPSHOT_TRANS_BLOCKS(handle->h_user_credits +
+			nblocks) - handle->h_buffer_credits;
+	}
+	if (credits > 0)
+		err = jbd2_journal_extend((handle_t *)handle, credits);
+	if (EXT4_SNAPSHOTS(sb) && !err) {
+		/* update base/user credits for future extends */
+		handle->h_base_credits += nblocks;
+		handle->h_user_credits += nblocks;
+		ext4_journal_trace(SNAP_WARN, where, handle, nblocks);
+	}
+	return err;
 }
 
-static inline int ext4_journal_restart(handle_t *handle, int nblocks)
+/*
+ * Ext4 wrapper for journal_restart()
+ * When transaction runs out of buffer credits and cannot be extended,
+ * the alternative is to restart it (start a new transaction).
+ * This wrapper increases the user requested buffer credits to include the
+ * extra credits for COW operations.
+ */
+static inline int __ext4_journal_restart(const char *where,
+					 handle_t *handle, int nblocks)
 {
-	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
-	return 0;
+	int err = 0;
+	int credits = 0;
+	struct super_block *sb;
+
+	if (!ext4_handle_valid((handle_t *)handle))
+		return 0;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	credits = EXT4_SNAPSHOTS(sb) ?
+		  EXT4_SNAPSHOT_START_TRANS_BLOCKS(nblocks) : nblocks;
+	err = jbd2_journal_restart((handle_t *)handle, credits);
+	if (EXT4_SNAPSHOTS(sb) && !err) {
+		handle->h_base_credits = nblocks;
+		handle->h_user_credits = nblocks;
+		ext4_journal_trace(SNAP_WARN, where, handle, nblocks);
+	}
+	return err;
 }
 
+#define ext4_journal_extend(handle, nblocks) \
+	__ext4_journal_extend(__func__, (handle), (nblocks))
+
+#define ext4_journal_restart(handle, nblocks) \
+	__ext4_journal_restart(__func__, (handle), (nblocks))
 static inline int ext4_journal_blocks_per_page(struct inode *inode)
 {
 	if (EXT4_JOURNAL(inode) != NULL)
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 06c11fd..dff9b5d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -668,7 +668,7 @@ static void update_backups(struct super_block *sb,
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		if (ext4_handle_valid(handle) &&
-		    handle->h_buffer_credits == 0 &&
+		    !ext4_handle_has_enough_credits(handle, 1) &&
 		    ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA) &&
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a768b63..0bde939 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -248,8 +248,10 @@ static void ext4_put_nojournal(handle_t *handle)
  * ext4 prevents a new handle from being started by s_frozen, which
  * is in an upper layer.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+handle_t *__ext4_journal_start(const char *where,
+		struct super_block *sb, int nblocks)
 {
+	int credits;
 	journal_t *journal;
 	handle_t  *handle;
 
@@ -280,7 +282,18 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks);
+
+	credits = EXT4_SNAPSHOTS(sb) ?
+		EXT4_SNAPSHOT_START_TRANS_BLOCKS(nblocks) : nblocks;
+	handle = jbd2_journal_start(journal, credits);
+	if (EXT4_SNAPSHOTS(sb) && !IS_ERR(handle)) {
+		if (handle->h_ref == 1) {
+			handle->h_base_credits = nblocks;
+			handle->h_user_credits = nblocks;
+		}
+		ext4_journal_trace(SNAP_WARN, where, handle, nblocks);
+	}
+	return handle;
 }
 
 /*
@@ -3823,6 +3836,27 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 		return NULL;
 	}
 
+	if (EXT4_SNAPSHOTS(sb) &&
+			(journal_inode->i_size >> EXT4_BLOCK_SIZE_BITS(sb)) <
+			EXT4_MIN_JOURNAL_BLOCKS) {
+		ext4_msg(sb, KERN_ERR,
+			"journal is too small (%lld < %u) for snapshots",
+			journal_inode->i_size >> EXT4_BLOCK_SIZE_BITS(sb),
+			EXT4_MIN_JOURNAL_BLOCKS);
+		iput(journal_inode);
+		return NULL;
+	}
+
+	if (EXT4_SNAPSHOTS(sb) &&
+			(journal_inode->i_size >> EXT4_BLOCK_SIZE_BITS(sb)) <
+			EXT4_BIG_JOURNAL_BLOCKS) {
+		snapshot_debug(1, "warning: journal is not big enough "
+			"(%lld < %u) - this might affect concurrent "
+			"filesystem writers performance!\n",
+			journal_inode->i_size >> EXT4_BLOCK_SIZE_BITS(sb),
+			EXT4_BIG_JOURNAL_BLOCKS);
+	}
+
 	journal = jbd2_journal_init_inode(journal_inode);
 	if (!journal) {
 		ext4_msg(sb, KERN_ERR, "Could not load journal inode");
-- 
1.7.0.4

