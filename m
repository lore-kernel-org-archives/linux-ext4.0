From: amir73il@users.sourceforge.net
Subject: [PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
Date: Tue,  7 Jun 2011 18:07:30 +0300
Message-ID: <1307459283-22130-4-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1FGPJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:03 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:02 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Before every metadata buffer write, the journal API is called,
namely, one of the ext4_journal_get_XXX_access() functions.
We use these journal hooks to call the snapshot API, namely
ext4_snapshot_get_XXX_access(), to COW the metadata buffer before
it is modified for the first time.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.c   |    9 ++++++-
 fs/ext4/ext4_jbd2.h   |   15 ++++++++++---
 fs/ext4/extents.c     |    3 +-
 fs/ext4/inode.c       |   22 ++++++++++++++------
 fs/ext4/move_extent.c |    3 +-
 fs/ext4/snapshot.h    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 88 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 560020d..833969b 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -23,13 +23,16 @@ int __ext4_journal_get_undo_access(const char *where, unsigned int line,
 	return err;
 }
 
-int __ext4_journal_get_write_access(const char *where, unsigned int line,
-				    handle_t *handle, struct buffer_head *bh)
+int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
+					 handle_t *handle, struct inode *inode,
+					 struct buffer_head *bh, int exclude)
 {
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_write_access(handle, bh);
+		if (!err && !exclude)
+			err = ext4_snapshot_get_write_access(handle, inode, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
@@ -111,6 +114,8 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_create_access(handle, bh);
+		if (!err)
+			err = ext4_snapshot_get_create_access(handle, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 3da2092..ca6e135 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -132,9 +132,9 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 int __ext4_journal_get_undo_access(const char *where, unsigned int line,
 				   handle_t *handle, struct buffer_head *bh);
 
-int __ext4_journal_get_write_access(const char *where, unsigned int line,
-				    handle_t *handle, struct buffer_head *bh);
-
+int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
+					 handle_t *handle, struct inode *inode,
+					 struct buffer_head *bh, int exclude);
 int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 		  int is_metadata, struct inode *inode,
 		  struct buffer_head *bh, ext4_fsblk_t blocknr);
@@ -151,8 +151,15 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 
 #define ext4_journal_get_undo_access(handle, bh) \
 	__ext4_journal_get_undo_access(__func__, __LINE__, (handle), (bh))
+#define ext4_journal_get_write_access_exclude(handle, bh) \
+	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
+						 (handle), NULL, (bh), 1)
 #define ext4_journal_get_write_access(handle, bh) \
-	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
+	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
+						 (handle), NULL, (bh), 0)
+#define ext4_journal_get_write_access_inode(handle, inode, bh) \
+	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
+						(handle), (inode), (bh), 0)
 #define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
 	__ext4_forget(__func__, __LINE__, (handle), (is_metadata), (inode), \
 		      (bh), (block_nr))
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7598224..6f0a711 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -79,7 +79,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
 {
 	if (path->p_bh) {
 		/* path points to block */
-		return ext4_journal_get_write_access(handle, path->p_bh);
+		return ext4_journal_get_write_access_inode(handle,
+					inode, path->p_bh);
 	}
 	/* path points to leaf/index in inode body */
 	/* we use in-core data, no need to protect them */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9dbd806..80e3393 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -874,7 +874,8 @@ static int ext4_splice_branch(handle_t *handle, struct inode *inode,
 	 */
 	if (where->bh) {
 		BUFFER_TRACE(where->bh, "get_write_access");
-		err = ext4_journal_get_write_access(handle, where->bh);
+		err = ext4_journal_get_write_access_inode(handle, inode,
+							   where->bh);
 		if (err)
 			goto err_out;
 	}
@@ -4149,7 +4150,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 			goto out_err;
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
-			err = ext4_journal_get_write_access(handle, bh);
+			err = ext4_journal_get_write_access_inode(handle,
+								  inode, bh);
 			if (unlikely(err))
 				goto out_err;
 		}
@@ -4200,7 +4202,8 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 
 	if (this_bh) {				/* For indirect block */
 		BUFFER_TRACE(this_bh, "get_write_access");
-		err = ext4_journal_get_write_access(handle, this_bh);
+		err = ext4_journal_get_write_access_inode(handle, inode,
+							   this_bh);
 		/* Important: if we can't update the indirect pointers
 		 * to the blocks, we can't free them. */
 		if (err)
@@ -4363,8 +4366,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 				 * pointed to by an indirect block: journal it
 				 */
 				BUFFER_TRACE(parent_bh, "get_write_access");
-				if (!ext4_journal_get_write_access(handle,
-								   parent_bh)){
+				if (!ext4_journal_get_write_access_inode(
+					    handle, inode, parent_bh)){
 					*p = 0;
 					BUFFER_TRACE(parent_bh,
 					"call ext4_handle_dirty_metadata");
@@ -4741,9 +4744,14 @@ has_buffer:
 
 int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 {
-	/* We have all inode data except xattrs in memory here. */
-	return __ext4_get_inode_loc(inode, iloc,
+	int in_mem = (!EXT4_SNAPSHOTS(inode->i_sb) &&
 		!ext4_test_inode_state(inode, EXT4_STATE_XATTR));
+
+	/*
+	 * We have all inode's data except xattrs in memory here,
+	 * but we must always read-in the entire inode block for COW.
+	 */
+	return __ext4_get_inode_loc(inode, iloc, in_mem);
 }
 
 void ext4_set_inode_flags(struct inode *inode)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b9f3e78..ad5409a 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -421,7 +421,8 @@ mext_insert_extents(handle_t *handle, struct inode *orig_inode,
 
 	if (depth) {
 		/* Register to journal */
-		ret = ext4_journal_get_write_access(handle, orig_path->p_bh);
+		ret = ext4_journal_get_write_access_inode(handle,
+					orig_inode, orig_path->p_bh);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index d0c985b..54241b9 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -145,6 +145,57 @@ static inline int EXT4_SNAPSHOTS(struct super_block *sb)
  * Block access functions
  */
 
+/*
+ * get_write_access() is called before writing to a metadata block
+ * if @inode is not NULL, then this is an inode's indirect block
+ * otherwise, this is a file system global metadata block
+ *
+ * Return values:
+ * = 0 - block was COWed or doesn't need to be COWed
+ * < 0 - error
+ */
+static inline int ext4_snapshot_get_write_access(handle_t *handle,
+		struct inode *inode, struct buffer_head *bh)
+{
+	struct super_block *sb;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (!EXT4_SNAPSHOTS(sb))
+		return 0;
+
+	return ext4_snapshot_cow(handle, inode, bh->b_blocknr, bh, 1);
+}
+
+/*
+ * get_create_access() is called after allocating a new metadata block
+ *
+ * Return values:
+ * = 0 - block was COWed or doesn't need to be COWed
+ * < 0 - error
+ */
+static inline int ext4_snapshot_get_create_access(handle_t *handle,
+		struct buffer_head *bh)
+{
+	struct super_block *sb;
+	int err;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (!EXT4_SNAPSHOTS(sb))
+		return 0;
+
+	/* Should block be COWed? */
+	err = ext4_snapshot_cow(handle, NULL, bh->b_blocknr, bh, 0);
+	/*
+	 * A new block shouldn't need to be COWed if get_delete_access() was
+	 * called for all deleted blocks.  However, it may need to be COWed
+	 * if fsck was run and if it had freed some blocks without moving them
+	 * to snapshot.  In the latter case, -EIO will be returned.
+	 */
+	if (err > 0)
+		err = -EIO;
+	return err;
+}
+
 
 
 /* snapshot_ctl.c */
-- 
1.7.4.1

