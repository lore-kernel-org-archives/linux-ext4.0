From: Frank Mayhar <fmayhar@google.com>
Subject: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Tue, 11 Nov 2008 11:18:31 -0800
Message-ID: <1226431111.4444.41.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYKKTSp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2008 14:18:45 -0500
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id mABJIYEB020123
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 19:18:35 GMT
In-Reply-To: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the end of October I posted the first patch that was intended to
allow ext4 to run on existing ext2 file systems.  It certainly had its
flaws and I got some great feedback from Andreas.  I've integrated his
suggestions, fixed a few bugs and have generated a new patch for your
review and enjoyment.

With this patch I've managed to mount an ext2 root with a 2.6.26 kernel
(with ext4 patches to almost 2.6.28), muck about with it, then reboot to
a 2.6.18 kernel without ext4 and have it Just Work.

As before, this only modifies ext4 itself, it touches nothing else.  I'm
not including a signed-off-by since I don't intend this as an official
submission; there is almost certainly more work to do.  I just want to
get it out and let you guys take a look and beat on it if you care to.

I'm particularly interested in hearing what you think of the approach,
how well you think it will work and if I have overlooked anything.

Thanks!

 balloc.c    |    4 -
 defrag.c    |    2 
 ext4_jbd2.c |   60 +++++++++++++++-------
 ext4_jbd2.h |  105 ++++++++++++++++++++++++++++++++++-----
 ext4_sb.h   |    1 
 extents.c   |   12 ++--
 ialloc.c    |   25 ++++-----
 inode.c     |  131 +++++++++++++++++++++++++++++++------------------
 ioctl.c     |    2 
 mballoc.c   |   16 +++---
 migrate.c   |    5 +
 namei.c     |   50 +++++++++---------
 resize.c    |   31 ++++++-----
 super.c     |  159 ++++++++++++++++++++++++++++++++++++++++++------------------
 xattr.c     |   21 ++++---
 15 files changed, 419 insertions(+), 205 deletions(-)

--- fs/ext4/balloc.c#3
+++ fs/ext4/balloc.c
@@ -531,11 +531,11 @@
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
-	ret = ext4_journal_dirty_metadata(handle, gd_bh);
+	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err) err = ret;
 	*pdquot_freed_blocks += group_freed;
 
--- fs/ext4/defrag.c#1
+++ fs/ext4/defrag.c
@@ -409,7 +409,7 @@
 	}
 
 	if (depth) {
-		ret = ext4_journal_dirty_metadata(handle, org_path->p_bh);
+		ret = ext4_handle_dirty_metadata(handle, org_inode, org_path->p_bh);
 		if (ret)
 			return ret;
 	} else {
--- fs/ext4/ext4_jbd2.c#1
+++ fs/ext4/ext4_jbd2.c
@@ -7,53 +7,77 @@
 int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
 				struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_undo_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_get_undo_access(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
 
 int __ext4_journal_get_write_access(const char *where, handle_t *handle,
 				struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_write_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_get_write_access(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
 
 int __ext4_journal_forget(const char *where, handle_t *handle,
 				struct buffer_head *bh)
 {
-	int err = jbd2_journal_forget(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_forget(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
 
 int __ext4_journal_revoke(const char *where, handle_t *handle,
 				ext4_fsblk_t blocknr, struct buffer_head *bh)
 {
-	int err = jbd2_journal_revoke(handle, blocknr, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_revoke(handle, blocknr, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
 
 int __ext4_journal_get_create_access(const char *where,
 				handle_t *handle, struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_create_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_get_create_access(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
 
 int __ext4_journal_dirty_metadata(const char *where,
 				handle_t *handle, struct buffer_head *bh)
 {
-	int err = jbd2_journal_dirty_metadata(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = jbd2_journal_dirty_metadata(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
--- fs/ext4/ext4_jbd2.h#3
+++ fs/ext4/ext4_jbd2.h
@@ -122,12 +122,6 @@
  * been done yet.
  */
 
-static inline void ext4_journal_release_buffer(handle_t *handle,
-						struct buffer_head *bh)
-{
-	jbd2_journal_release_buffer(handle, bh);
-}
-
 void ext4_journal_abort_handle(const char *caller, const char *err_fn,
 		struct buffer_head *bh, handle_t *handle, int err);
 
@@ -149,6 +143,8 @@
 int __ext4_journal_dirty_metadata(const char *where,
 				handle_t *handle, struct buffer_head *bh);
 
+int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh);
+
 #define ext4_journal_get_undo_access(handle, bh) \
 	__ext4_journal_get_undo_access(__func__, (handle), (bh))
 #define ext4_journal_get_write_access(handle, bh) \
@@ -157,14 +153,68 @@
 	__ext4_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext4_journal_get_create_access(handle, bh) \
 	__ext4_journal_get_create_access(__func__, (handle), (bh))
-#define ext4_journal_dirty_metadata(handle, bh) \
-	__ext4_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext4_journal_forget(handle, bh) \
 	__ext4_journal_forget(__func__, (handle), (bh))
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);
 
+static inline int ext4_handle_valid(handle_t *handle)
+{
+	if (!handle)
+		return 0;
+	if (handle->h_transaction == NULL)
+		return 0;
+	return 1;
+}
+
+static inline int ext4_handle_dirty_metadata(handle_t *handle,
+				struct inode *inode, struct buffer_head *bh)
+{
+	int err = 0;
+
+	if (ext4_handle_valid(handle)) {
+		err = __ext4_journal_dirty_metadata(__func__, handle, bh);
+	} else {
+		err = __ext4_write_dirty_metadata(inode, bh);
+	}
+	return err;
+}
+
+static inline void ext4_handle_sync(handle_t *handle)
+{
+	if (ext4_handle_valid(handle))
+		handle->h_sync = 1;
+}
+
+static inline void ext4_handle_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
+{
+	if (ext4_handle_valid(handle))
+		jbd2_journal_release_buffer(handle, bh);
+}
+
+static inline int ext4_handle_is_aborted(handle_t *handle)
+{
+	if (ext4_handle_valid(handle))
+		return is_handle_aborted(handle);
+	return 0;
+}
+
+static inline int ext4_handle_has_enough_credits(handle_t *handle, int needed)
+{
+	if (ext4_handle_valid(handle) && handle->h_buffer_credits < needed)
+		return 0;
+	return 1;
+}
+
+static inline void ext4_journal_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
+{
+	if (ext4_handle_valid(handle))
+		jbd2_journal_release_buffer(handle, bh);
+}
+
 static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
 {
 	return ext4_journal_start_sb(inode->i_sb, nblocks);
@@ -180,27 +230,37 @@
 
 static inline int ext4_journal_extend(handle_t *handle, int nblocks)
 {
-	return jbd2_journal_extend(handle, nblocks);
+	if (ext4_handle_valid(handle))
+		return jbd2_journal_extend(handle, nblocks);
+	return 0;
 }
 
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
-	return jbd2_journal_restart(handle, nblocks);
+	if (ext4_handle_valid(handle))
+		return jbd2_journal_restart(handle, nblocks);
+	return 0;
 }
 
 static inline int ext4_journal_blocks_per_page(struct inode *inode)
 {
-	return jbd2_journal_blocks_per_page(inode);
+	if (EXT4_JOURNAL(inode) != NULL)
+		return jbd2_journal_blocks_per_page(inode);
+	return 0;
 }
 
 static inline int ext4_journal_force_commit(journal_t *journal)
 {
-	return jbd2_journal_force_commit(journal);
+	if (journal)
+		return jbd2_journal_force_commit(journal);
+	return 0;
 }
 
 static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
-	return jbd2_journal_file_inode(handle, &EXT4_I(inode)->jinode);
+	if (ext4_handle_valid(handle))
+		return jbd2_journal_file_inode(handle, &EXT4_I(inode)->jinode);
+	return 0;
 }
 
 /* super.c */
@@ -208,6 +268,8 @@
 
 static inline int ext4_should_journal_data(struct inode *inode)
 {
+	if (EXT4_JOURNAL(inode) == NULL)
+		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 1;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
@@ -221,7 +283,8 @@
 {
 	if (!S_ISREG(inode->i_mode))
 		return 0;
-	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
+	if (EXT4_JOURNAL(inode) != NULL &&
+	    EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
 		return 1;
@@ -230,6 +293,8 @@
 
 static inline int ext4_should_writeback_data(struct inode *inode)
 {
+	if (EXT4_JOURNAL(inode) == NULL)
+		return 0;
 	if (!S_ISREG(inode->i_mode))
 		return 0;
 	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
@@ -239,4 +304,16 @@
 	return 0;
 }
 
+static inline int ext4_journal_max_transaction_buffers(struct inode *inode)
+{
+	/*
+	 * max transaction buffers
+	 * calculation based on
+	 * journal->j_max_transaction_buffers = journal->j_maxlen / 4;
+	 */
+	if (EXT4_JOURNAL(inode) != NULL)
+		return (EXT4_JOURNAL(inode))->j_maxlen / 4;
+	return 0;
+}
+
 #endif	/* _EXT4_JBD2_H */
--- fs/ext4/ext4_sb.h#3
+++ fs/ext4/ext4_sb.h
@@ -28,6 +28,7 @@
  * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
+	int *s_nojournal_flag;		/* Null to indicate "not a handle" */
 	unsigned long s_desc_size;	/* Size of a group descriptor in bytes */
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
--- fs/ext4/extents.c#3
+++ fs/ext4/extents.c
@@ -97,6 +97,8 @@
 {
 	int err;
 
+	if (!ext4_handle_valid(handle))
+		return 0;
 	if (handle->h_buffer_credits > needed)
 		return 0;
 	err = ext4_journal_extend(handle, needed);
@@ -134,7 +136,7 @@
 	int err;
 	if (path->p_bh) {
 		/* path points to block */
-		err = ext4_journal_dirty_metadata(handle, path->p_bh);
+		err = ext4_handle_dirty_metadata(handle, inode, path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);
@@ -780,7 +782,7 @@
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	err = ext4_journal_dirty_metadata(handle, bh);
+	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto cleanup;
 	brelse(bh);
@@ -859,7 +861,7 @@
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
-		err = ext4_journal_dirty_metadata(handle, bh);
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto cleanup;
 		brelse(bh);
@@ -955,7 +957,7 @@
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	err = ext4_journal_dirty_metadata(handle, bh);
+	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto out;
 
@@ -2950,7 +2952,7 @@
 	 * transaction synchronous.
 	 */
 	if (IS_SYNC(inode))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 out_stop:
 	up_write(&EXT4_I(inode)->i_data_sem);
--- fs/ext4/ialloc.c#3
+++ fs/ext4/ialloc.c
@@ -253,12 +253,12 @@
 				spin_unlock(sb_bgl_lock(sbi, flex_group));
 			}
 		}
-		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
-		err = ext4_journal_dirty_metadata(handle, bh2);
+		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, NULL, bh2);
 		if (!fatal) fatal = err;
 	}
-	BUFFER_TRACE(bitmap_bh, "call ext4_journal_dirty_metadata");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (!fatal)
 		fatal = err;
 	sb->s_dirt = 1;
@@ -656,15 +656,16 @@
 						ino, bitmap_bh->b_data)) {
 				/* we won it */
 				BUFFER_TRACE(bitmap_bh,
-					"call ext4_journal_dirty_metadata");
-				err = ext4_journal_dirty_metadata(handle,
+					"call ext4_handle_dirty_metadata");
+				err = ext4_handle_dirty_metadata(handle,
+								inode,
 								bitmap_bh);
 				if (err)
 					goto fail;
 				goto got;
 			}
 			/* we lost it */
-			jbd2_journal_release_buffer(handle, bitmap_bh);
+			ext4_handle_release_buffer(handle, bitmap_bh);
 
 			if (++ino < EXT4_INODES_PER_GROUP(sb))
 				goto repeat_in_this_group;
@@ -724,7 +725,8 @@
 		/* Don't need to dirty bitmap block if we didn't change it */
 		if (free) {
 			BUFFER_TRACE(block_bh, "dirty block bitmap");
-			err = ext4_journal_dirty_metadata(handle, block_bh);
+			err = ext4_handle_dirty_metadata(handle,
+							NULL, block_bh);
 		}
 
 		brelse(block_bh);
@@ -769,8 +771,8 @@
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group));
-	BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
-	err = ext4_journal_dirty_metadata(handle, bh2);
+	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, bh2);
 	if (err) goto fail;
 
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
@@ -823,7 +825,7 @@
 
 	ext4_set_inode_flags(inode);
 	if (IS_DIRSYNC(inode))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 	insert_inode_hash(inode);
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
@@ -1022,4 +1024,3 @@
 	}
 	return count;
 }
-
--- fs/ext4/inode.c#3
+++ fs/ext4/inode.c
@@ -71,6 +71,8 @@
  * "bh" may be NULL: a metadata block may have been freed from memory
  * but there may still be a record of it in the journal, and that record
  * still needs to be revoked.
+ *
+ * If the handle isn't valid we're not journaling so there's nothing to do.
  */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 			struct buffer_head *bh, ext4_fsblk_t blocknr)
@@ -79,6 +81,9 @@
 
 	might_sleep();
 
+	if (!ext4_handle_valid(handle))
+		return 0;
+
 	BUFFER_TRACE(bh, "enter");
 
 	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
@@ -167,9 +172,11 @@
  * Returns 0 if we managed to create more room.  If we can't create more
  * room, and the transaction must be restarted we return 1.
  */
-static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
+static int ext4_try_to_extend_transaction(handle_t *handle, struct inode *inode)
 {
-	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+	if (!ext4_handle_valid(handle))
+		return 0;
+	if (ext4_handle_has_enough_credits(handle, EXT4_RESERVE_TRANS_BLOCKS+1))
 		return 0;
 	if (!ext4_journal_extend(handle, blocks_for_truncate(inode)))
 		return 0;
@@ -183,6 +190,7 @@
  */
 static int ext4_journal_test_restart(handle_t *handle, struct inode *inode)
 {
+	BUG_ON(EXT4_JOURNAL(inode) == NULL);
 	jbd_debug(2, "restarting handle %p\n", handle);
 	return ext4_journal_restart(handle, blocks_for_truncate(inode));
 }
@@ -195,7 +203,8 @@
 	handle_t *handle;
 	int err;
 
-	if (ext4_should_order_data(inode))
+	if (EXT4_JOURNAL(inode) != NULL &&
+	    ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
@@ -215,7 +224,7 @@
 	}
 
 	if (IS_SYNC(inode))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 	inode->i_size = 0;
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
@@ -232,7 +241,7 @@
 	 * enough credits left in the handle to remove the inode from
 	 * the orphan list and set the dtime field.
 	 */
-	if (handle->h_buffer_credits < 3) {
+	if (!ext4_handle_has_enough_credits(handle, 3)) {
 		err = ext4_journal_extend(handle, 3);
 		if (err > 0)
 			err = ext4_journal_restart(handle, 3);
@@ -708,8 +717,8 @@
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
-		BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-		err = ext4_journal_dirty_metadata(handle, bh);
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto failed;
 	}
@@ -791,8 +800,8 @@
 		 * generic_commit_write->__mark_inode_dirty->ext4_dirty_inode.
 		 */
 		jbd_debug(5, "splicing indirect only\n");
-		BUFFER_TRACE(where->bh, "call ext4_journal_dirty_metadata");
-		err = ext4_journal_dirty_metadata(handle, where->bh);
+		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, inode, where->bh);
 		if (err)
 			goto err_out;
 	} else {
@@ -1220,8 +1229,8 @@
 				set_buffer_uptodate(bh);
 			}
 			unlock_buffer(bh);
-			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-			err = ext4_journal_dirty_metadata(handle, bh);
+			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			err = ext4_handle_dirty_metadata(handle, inode, bh);
 			if (!fatal)
 				fatal = err;
 		} else {
@@ -1386,7 +1395,7 @@
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
 	set_buffer_uptodate(bh);
-	return ext4_journal_dirty_metadata(handle, bh);
+	return ext4_handle_dirty_metadata(handle, NULL, bh);
 }
 
 /*
@@ -2710,7 +2719,7 @@
 		filemap_write_and_wait(mapping);
 	}
 
-	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
+	if (EXT4_JOURNAL(inode) && EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
 		/*
 		 * This is a REALLY heavyweight approach, but the use of
 		 * bmap on dirty files is expected to be extremely rare:
@@ -2981,7 +2990,8 @@
 	if (offset == 0)
 		ClearPageChecked(page);
 
-	jbd2_journal_invalidatepage(journal, page, offset);
+	if (journal)
+		jbd2_journal_invalidatepage(journal, page, offset);
 }
 
 static int ext4_releasepage(struct page *page, gfp_t wait)
@@ -2989,7 +2999,7 @@
 	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
 
 	WARN_ON(PageChecked(page));
-	if (!page_has_buffers(page))
+	if (!journal || !page_has_buffers(page))
 		return 0;
 	return jbd2_journal_try_to_free_buffers(journal, page, wait);
 }
@@ -3259,7 +3269,7 @@
 
 	err = 0;
 	if (ext4_should_journal_data(inode)) {
-		err = ext4_journal_dirty_metadata(handle, bh);
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 	} else {
 		if (ext4_should_order_data(inode))
 			err = ext4_jbd2_file_inode(handle, inode);
@@ -3381,10 +3391,10 @@
 		unsigned long count, __le32 *first, __le32 *last)
 {
 	__le32 *p;
-	if (try_to_extend_transaction(handle, inode)) {
+	if (ext4_try_to_extend_transaction(handle, inode)) {
 		if (bh) {
-			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-			ext4_journal_dirty_metadata(handle, bh);
+			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_handle_dirty_metadata(handle, inode, bh);
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_test_restart(handle, inode);
@@ -3484,7 +3494,7 @@
 				  count, block_to_free_p, p);
 
 	if (this_bh) {
-		BUFFER_TRACE(this_bh, "call ext4_journal_dirty_metadata");
+		BUFFER_TRACE(this_bh, "call ext4_handle_dirty_metadata");
 
 		/*
 		 * The buffer head should have an attached journal head at this
@@ -3493,7 +3503,7 @@
 		 * the block was cleared. Check for this instead of OOPSing.
 		 */
 		if (bh2jh(this_bh))
-			ext4_journal_dirty_metadata(handle, this_bh);
+			ext4_handle_dirty_metadata(handle, inode, this_bh);
 		else
 			ext4_error(inode->i_sb, __func__,
 				   "circular indirect block detected, "
@@ -3523,7 +3533,7 @@
 	ext4_fsblk_t nr;
 	__le32 *p;
 
-	if (is_handle_aborted(handle))
+	if (ext4_handle_is_aborted(handle))
 		return;
 
 	if (depth--) {
@@ -3593,9 +3603,9 @@
 			 * will merely complain about releasing a free block,
 			 * rather than leaking blocks.
 			 */
-			if (is_handle_aborted(handle))
+			if (ext4_handle_is_aborted(handle))
 				return;
-			if (try_to_extend_transaction(handle, inode)) {
+			if (ext4_try_to_extend_transaction(handle, inode)) {
 				ext4_mark_inode_dirty(handle, inode);
 				ext4_journal_test_restart(handle, inode);
 			}
@@ -3612,9 +3622,10 @@
 								   parent_bh)){
 					*p = 0;
 					BUFFER_TRACE(parent_bh,
-					"call ext4_journal_dirty_metadata");
-					ext4_journal_dirty_metadata(handle,
-								    parent_bh);
+					"call ext4_handle_dirty_metadata");
+					ext4_handle_dirty_metadata(handle,
+								   inode,
+								   parent_bh);
 				}
 			}
 		}
@@ -3802,7 +3813,7 @@
 	 * synchronous
 	 */
 	if (IS_SYNC(inode))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 out_stop:
 	/*
 	 * If this was a simple ftruncate(), and the file will remain alive
@@ -4299,8 +4310,8 @@
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
-			handle->h_sync = 1;
-			err = ext4_journal_dirty_metadata(handle,
+			ext4_handle_sync(handle);
+			err = ext4_handle_dirty_metadata(handle, inode,
 					EXT4_SB(sb)->s_sbh);
 		}
 	}
@@ -4327,9 +4338,8 @@
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-
-	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-	rc = ext4_journal_dirty_metadata(handle, bh);
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	rc = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (!err)
 		err = rc;
 	ei->i_state &= ~EXT4_STATE_NEW;
@@ -4392,6 +4402,25 @@
 	return ext4_force_commit(inode->i_sb);
 }
 
+int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh)
+{
+	int err = 0;
+
+	mark_buffer_dirty(bh);
+	if (inode && inode_needs_sync(inode)) {
+		sync_dirty_buffer(bh);
+		if (buffer_req(bh) && !buffer_uptodate(bh)) {
+			ext4_error(inode->i_sb, __func__,
+				   "IO error syncing inode, "
+				   "inode=%lu, block=%llu",
+				   inode->i_ino,
+				   (unsigned long long)bh->b_blocknr);
+			err = -EIO;
+		}
+	}
+	return err;
+}
+
 /*
  * ext4_setattr()
  *
@@ -4695,16 +4724,15 @@
 ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 			 struct ext4_iloc *iloc)
 {
-	int err = 0;
-	if (handle) {
-		err = ext4_get_inode_loc(inode, iloc);
-		if (!err) {
-			BUFFER_TRACE(iloc->bh, "get_write_access");
-			err = ext4_journal_get_write_access(handle, iloc->bh);
-			if (err) {
-				brelse(iloc->bh);
-				iloc->bh = NULL;
-			}
+	int err;
+
+	err = ext4_get_inode_loc(inode, iloc);
+	if (!err) {
+		BUFFER_TRACE(iloc->bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, iloc->bh);
+		if (err) {
+			brelse(iloc->bh);
+			iloc->bh = NULL;
 		}
 	}
 	ext4_std_error(inode->i_sb, err);
@@ -4776,7 +4804,8 @@
 
 	might_sleep();
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
+	if (ext4_handle_valid(handle) &&
+	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
 		/*
 		 * We need extra buffer credits since we may write into EA block
@@ -4828,6 +4857,11 @@
 	handle_t *current_handle = ext4_journal_current_handle();
 	handle_t *handle;
 
+	if (!ext4_handle_valid(current_handle)) {
+		ext4_mark_inode_dirty(NULL, inode);
+		return;
+	}
+
 	handle = ext4_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
@@ -4865,8 +4899,9 @@
 			BUFFER_TRACE(iloc.bh, "get_write_access");
 			err = jbd2_journal_get_write_access(handle, iloc.bh);
 			if (!err)
-				err = ext4_journal_dirty_metadata(handle,
-								  iloc.bh);
+				err = ext4_handle_dirty_metadata(handle,
+								 inode,
+								 iloc.bh);
 			brelse(iloc.bh);
 		}
 	}
@@ -4892,6 +4927,8 @@
 	 */
 
 	journal = EXT4_JOURNAL(inode);
+	if (!journal)
+		return 0;
 	if (is_journal_aborted(journal))
 		return -EROFS;
 
@@ -4921,7 +4958,7 @@
 		return PTR_ERR(handle);
 
 	err = ext4_mark_inode_dirty(handle, inode);
-	handle->h_sync = 1;
+	ext4_handle_sync(handle);
 	ext4_journal_stop(handle);
 	ext4_std_error(inode->i_sb, err);
 
--- fs/ext4/ioctl.c#2
+++ fs/ext4/ioctl.c
@@ -99,7 +99,7 @@
 			goto flags_out;
 		}
 		if (IS_SYNC(inode))
-			handle->h_sync = 1;
+			ext4_handle_sync(handle);
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err)
 			goto flags_err;
--- fs/ext4/mballoc.c#3
+++ fs/ext4/mballoc.c
@@ -2876,7 +2876,7 @@
 		mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group),
 				bitmap_bh->b_data, ac->ac_b_ex.fe_start,
 				ac->ac_b_ex.fe_len);
-		err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
 		goto out_err;
@@ -2923,10 +2923,10 @@
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
 
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (err)
 		goto out_err;
-	err = ext4_journal_dirty_metadata(handle, gdp_bh);
+	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
 	sb->s_dirt = 1;
@@ -4416,6 +4416,8 @@
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
+	if (!ext4_handle_valid(handle))
+		return;
 	if (sbi->s_last_transaction == handle->h_transaction->t_tid)
 		return;
 
@@ -4468,7 +4470,7 @@
 	struct rb_node **n = &db->bb_free_root.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node;
 
-
+	BUG_ON(!ext4_handle_valid(handle));
 	BUG_ON(e4b->bd_bitmap_page == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
@@ -4648,7 +4650,7 @@
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	if (ac) {
 		ac->ac_b_ex.fe_group = block_group;
@@ -4657,7 +4659,7 @@
 		ext4_mb_store_history(ac);
 	}
 
-	if (metadata) {
+	if (ext4_handle_valid(handle) && metadata) {
 		/* blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed */
 		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
@@ -4687,7 +4689,7 @@
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
-	ret = ext4_journal_dirty_metadata(handle, gd_bh);
+	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
 
--- fs/ext4/migrate.c#3
+++ fs/ext4/migrate.c
@@ -59,7 +59,8 @@
 	/*
 	 * Make sure the credit we accumalated is not really high
 	 */
-	if (needed && handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {
+	if (needed && ext4_handle_has_enough_credits(handle,
+						EXT4_RESERVE_TRANS_BLOCKS)) {
 		retval = ext4_journal_restart(handle, needed);
 		if (retval)
 			goto err_out;
@@ -229,7 +230,7 @@
 {
 	int retval = 0, needed;
 
-	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+	if (ext4_handle_has_enough_credits(handle, EXT4_RESERVE_TRANS_BLOCKS+1))
 		return 0;
 	/*
 	 * We are freeing a blocks. During this we touch
--- fs/ext4/namei.c#3
+++ fs/ext4/namei.c
@@ -1238,10 +1238,10 @@
 		de = de2;
 	}
 	dx_insert_block(frame, hash2 + continued, newblock);
-	err = ext4_journal_dirty_metadata(handle, bh2);
+	err = ext4_handle_dirty_metadata(handle, dir, bh2);
 	if (err)
 		goto journal_error;
-	err = ext4_journal_dirty_metadata(handle, frame->bh);
+	err = ext4_handle_dirty_metadata(handle, dir, frame->bh);
 	if (err)
 		goto journal_error;
 	brelse(bh2);
@@ -1345,8 +1345,8 @@
 	ext4_update_dx_flag(dir);
 	dir->i_version++;
 	ext4_mark_inode_dirty(handle, dir);
-	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-	err = ext4_journal_dirty_metadata(handle, bh);
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, dir, bh);
 	if (err)
 		ext4_std_error(dir->i_sb, err);
 	brelse(bh);
@@ -1584,7 +1584,7 @@
 			dxtrace(dx_show_index("node", frames[1].entries));
 			dxtrace(dx_show_index("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_journal_dirty_metadata(handle, bh2);
+			err = ext4_handle_dirty_metadata(handle, inode, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1610,7 +1610,7 @@
 			if (err)
 				goto journal_error;
 		}
-		ext4_journal_dirty_metadata(handle, frames[0].bh);
+		ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
 	}
 	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
 	if (!de)
@@ -1656,8 +1656,8 @@
 			else
 				de->inode = 0;
 			dir->i_version++;
-			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-			ext4_journal_dirty_metadata(handle, bh);
+			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_handle_dirty_metadata(handle, dir, bh);
 			return 0;
 		}
 		i += ext4_rec_len_from_disk(de->rec_len);
@@ -1733,7 +1733,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode (handle, dir, mode);
 	err = PTR_ERR(inode);
@@ -1767,7 +1767,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode(handle, dir, mode);
 	err = PTR_ERR(inode);
@@ -1803,7 +1803,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode(handle, dir, S_IFDIR | mode);
 	err = PTR_ERR(inode);
@@ -1832,8 +1832,8 @@
 	strcpy(de->name, "..");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
-	BUFFER_TRACE(dir_block, "call ext4_journal_dirty_metadata");
-	ext4_journal_dirty_metadata(handle, dir_block);
+	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ext4_handle_dirty_metadata(handle, dir, dir_block);
 	brelse(dir_block);
 	ext4_mark_inode_dirty(handle, inode);
 	err = ext4_add_entry(handle, dentry, inode);
@@ -1971,7 +1971,7 @@
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_metadata(handle, inode, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2027,7 +2027,7 @@
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (!handle)
+	if (sbi->s_journal && !handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
@@ -2041,7 +2041,7 @@
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_journal_dirty_metadata(handle, sbi->s_sbh);
+		err = ext4_handle_dirty_metadata(handle, inode, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =
@@ -2092,7 +2092,7 @@
 		goto end_rmdir;
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode = dentry->d_inode;
 
@@ -2146,7 +2146,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	retval = -ENOENT;
 	bh = ext4_find_entry(dir, &dentry->d_name, &de);
@@ -2203,7 +2203,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode(handle, dir, S_IFLNK|S_IRWXUGO);
 	err = PTR_ERR(inode);
@@ -2266,7 +2266,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_inc_count(handle, inode);
@@ -2308,7 +2308,7 @@
 		return PTR_ERR(handle);
 
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
-		handle->h_sync = 1;
+		ext4_handle_sync(handle);
 
 	old_bh = ext4_find_entry(old_dir, &old_dentry->d_name, &old_de);
 	/*
@@ -2362,8 +2362,8 @@
 		new_dir->i_ctime = new_dir->i_mtime =
 					ext4_current_time(new_dir);
 		ext4_mark_inode_dirty(handle, new_dir);
-		BUFFER_TRACE(new_bh, "call ext4_journal_dirty_metadata");
-		ext4_journal_dirty_metadata(handle, new_bh);
+		BUFFER_TRACE(new_bh, "call ext4_handle_dirty_metadata");
+		ext4_handle_dirty_metadata(handle, new_dir, new_bh);
 		brelse(new_bh);
 		new_bh = NULL;
 	}
@@ -2413,8 +2413,8 @@
 		BUFFER_TRACE(dir_bh, "get_write_access");
 		ext4_journal_get_write_access(handle, dir_bh);
 		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
-		BUFFER_TRACE(dir_bh, "call ext4_journal_dirty_metadata");
-		ext4_journal_dirty_metadata(handle, dir_bh);
+		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
+		ext4_handle_dirty_metadata(handle, new_dir, dir_bh);
 		ext4_dec_count(handle, old_dir);
 		if (new_inode) {
 			/* checked empty_dir above, can't have another parent,
--- fs/ext4/resize.c#3
+++ fs/ext4/resize.c
@@ -149,7 +149,7 @@
 {
 	int err;
 
-	if (handle->h_buffer_credits >= thresh)
+	if (ext4_handle_has_enough_credits(handle, thresh))
 		return 0;
 
 	err = ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA);
@@ -232,7 +232,7 @@
 		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
 		unlock_buffer(gdb);
-		ext4_journal_dirty_metadata(handle, gdb);
+		ext4_handle_dirty_metadata(handle, NULL, gdb);
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
@@ -251,7 +251,7 @@
 			err = PTR_ERR(bh);
 			goto exit_bh;
 		}
-		ext4_journal_dirty_metadata(handle, gdb);
+		ext4_handle_dirty_metadata(handle, NULL, gdb);
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
@@ -276,7 +276,7 @@
 			err = PTR_ERR(it);
 			goto exit_bh;
 		}
-		ext4_journal_dirty_metadata(handle, it);
+		ext4_handle_dirty_metadata(handle, NULL, it);
 		brelse(it);
 		ext4_set_bit(bit, bh->b_data);
 	}
@@ -286,7 +286,7 @@
 
 	mark_bitmap_end(input->blocks_count, EXT4_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
-	ext4_journal_dirty_metadata(handle, bh);
+	ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 
 	/* Mark unused entries in inode bitmap used */
@@ -299,7 +299,7 @@
 
 	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
-	ext4_journal_dirty_metadata(handle, bh);
+	ext4_handle_dirty_metadata(handle, NULL, bh);
 exit_bh:
 	brelse(bh);
 
@@ -486,12 +486,12 @@
 	 * reserved inode, and will become GDT blocks (primary and backup).
 	 */
 	data[gdb_num % EXT4_ADDR_PER_BLOCK(sb)] = 0;
-	ext4_journal_dirty_metadata(handle, dind);
+	ext4_handle_dirty_metadata(handle, NULL, dind);
 	brelse(dind);
 	inode->i_blocks -= (gdbackups + 1) * sb->s_blocksize >> 9;
 	ext4_mark_iloc_dirty(handle, inode, &iloc);
 	memset((*primary)->b_data, 0, sb->s_blocksize);
-	ext4_journal_dirty_metadata(handle, *primary);
+	ext4_handle_dirty_metadata(handle, NULL, *primary);
 
 	o_group_desc = EXT4_SB(sb)->s_group_desc;
 	memcpy(n_group_desc, o_group_desc,
@@ -502,7 +502,7 @@
 	kfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
-	ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 
 	return 0;
 
@@ -618,7 +618,7 @@
 		       primary[i]->b_blocknr, gdbackups,
 		       blk + primary[i]->b_blocknr); */
 		data[gdbackups] = cpu_to_le32(blk + primary[i]->b_blocknr);
-		err2 = ext4_journal_dirty_metadata(handle, primary[i]);
+		err2 = ext4_handle_dirty_metadata(handle, NULL, primary[i]);
 		if (!err)
 			err = err2;
 	}
@@ -676,7 +676,8 @@
 		struct buffer_head *bh;
 
 		/* Out of journal space, and can't get more - abort - so sad */
-		if (handle->h_buffer_credits == 0 &&
+		if (ext4_handle_valid(handle) &&
+		    handle->h_buffer_credits == 0 &&
 		    ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA) &&
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
@@ -696,7 +697,7 @@
 			memset(bh->b_data + size, 0, rest);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		ext4_journal_dirty_metadata(handle, bh);
+		ext4_handle_dirty_metadata(handle, NULL, bh);
 		brelse(bh);
 	}
 	if ((err2 = ext4_journal_stop(handle)) && !err)
@@ -915,7 +916,7 @@
 	/* Update the global fs size fields */
 	sbi->s_groups_count++;
 
-	ext4_journal_dirty_metadata(handle, primary);
+	ext4_handle_dirty_metadata(handle, NULL, primary);
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
@@ -937,7 +938,7 @@
 			EXT4_INODES_PER_GROUP(sb);
 	}
 
-	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	sb->s_dirt = 1;
 
 exit_journal:
@@ -1071,7 +1072,7 @@
 		goto exit_put;
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
-	ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	sb->s_dirt = 1;
 	unlock_super(sb);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
--- fs/ext4/super.c#5
+++ fs/ext4/super.c
@@ -136,13 +136,16 @@
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
 	journal = EXT4_SB(sb)->s_journal;
-	if (is_journal_aborted(journal)) {
-		ext4_abort(sb, __func__,
-			   "Detected aborted journal");
-		return ERR_PTR(-EROFS);
+	if (journal) {
+		if (is_journal_aborted(journal)) {
+			ext4_abort(sb, __func__,
+				   "Detected aborted journal");
+			return ERR_PTR(-EROFS);
+		}
+		return jbd2_journal_start(journal, nblocks);
 	}
-
-	return jbd2_journal_start(journal, nblocks);
+	current->journal_info = (handle_t *)EXT4_SB(sb);
+	return current->journal_info;
 }
 
 /*
@@ -157,6 +160,10 @@
 	int err;
 	int rc;
 
+	if (!ext4_handle_valid(handle)) {
+		current->journal_info = NULL;
+		return 0;
+	}
 	sb = handle->h_transaction->t_journal->j_private;
 	err = handle->h_err;
 	rc = jbd2_journal_stop(handle);
@@ -174,6 +181,8 @@
 	char nbuf[16];
 	const char *errstr = ext4_decode_error(NULL, err, nbuf);
 
+	BUG_ON(!ext4_handle_valid(handle));
+
 	if (bh)
 		BUFFER_TRACE(bh, "abort");
 
@@ -448,11 +457,12 @@
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	err = jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
-	if (err < 0)
-		ext4_abort(sb, __func__, "Couldn't clean up the journal");
-
+	if (sbi->s_journal) {
+		err = jbd2_journal_destroy(sbi->s_journal);
+		sbi->s_journal = NULL;
+		if (err < 0)
+			ext4_abort(sb, __func__, "Couldn't clean up the journal");
+	}
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -522,7 +532,8 @@
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
+	if (EXT4_SB(sb)->s_journal)
+		jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
@@ -588,7 +599,8 @@
 	}
 #endif
 	ext4_discard_preallocations(inode);
-	jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
+	if (EXT4_SB(inode->i_sb)->s_journal)
+		jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
 				       &EXT4_I(inode)->jinode);
 }
 
@@ -1425,7 +1437,8 @@
 	le16_add_cpu(&es->s_mnt_count, 1);
 	es->s_mtime = cpu_to_le32(get_seconds());
 	ext4_update_dynamic_rev(sb);
-	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+	if (sbi->s_journal)
+		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 
 	ext4_commit_super(sb, es, 1);
 	if (test_opt(sb, DEBUG))
@@ -1437,9 +1450,13 @@
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
-	printk(KERN_INFO "EXT4 FS on %s, %s journal on %s\n",
-	       sb->s_id, EXT4_SB(sb)->s_journal->j_inode ? "internal" :
-	       "external", EXT4_SB(sb)->s_journal->j_devname);
+	if (EXT4_SB(sb)->s_journal) {
+		printk(KERN_INFO "EXT4 FS on %s, %s journal on %s\n",
+		       sb->s_id, EXT4_SB(sb)->s_journal->j_inode ? "internal" :
+		       "external", EXT4_SB(sb)->s_journal->j_devname);
+	} else {
+		printk(KERN_INFO "EXT4 FS on %s, no journal\n", sb->s_id);
+	}
 	return res;
 }
 
@@ -1891,6 +1908,7 @@
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
+	sbi->s_nojournal_flag = NULL;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
 	sbi->s_resgid = EXT4_DEF_RESGID;
@@ -2289,7 +2307,12 @@
 			printk(KERN_ERR
 			       "ext4: No journal on filesystem on %s\n",
 			       sb->s_id);
-		goto failed_mount3;
+		clear_opt(sbi->s_mount_opt, DATA_FLAGS);
+		set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
+		sbi->s_journal = NULL;
+		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
+		needs_recovery = 0;
+		goto no_journal;
 	}
 
 	if (ext4_blocks_count(es) > 0xffffffffULL &&
@@ -2341,6 +2364,8 @@
 		break;
 	}
 
+no_journal:
+
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
 			printk(KERN_WARNING "EXT4-fs: Ignoring nobh option - "
@@ -2428,10 +2453,12 @@
 	if (needs_recovery)
 		printk(KERN_INFO "EXT4-fs: recovery complete.\n");
 	ext4_mark_recovery_complete(sb, es);
-	printk(KERN_INFO "EXT4-fs: mounted filesystem with %s data mode.\n",
-	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ? "journal":
-	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
-	       "writeback");
+	if (EXT4_SB(sb)->s_journal) {
+		printk(KERN_INFO "EXT4-fs: mounted filesystem with %s data mode.\n",
+		       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ? "journal":
+		       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
+		       "writeback");
+	}
 
 	printk(KERN_INFO "EXT4-fs: %s mounted. Flags: 0x%lx Opts: %s\n",
 		sb->s_id, sb->s_flags, (char *)data);
@@ -2446,8 +2473,10 @@
 	goto failed_mount;
 
 failed_mount4:
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	if (sbi->s_journal) {
+		jbd2_journal_destroy(sbi->s_journal);
+		sbi->s_journal = NULL;
+	}
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -2484,6 +2513,8 @@
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
+	BUG_ON(sbi->s_journal == NULL);
+
 	if (sbi->s_commit_interval)
 		journal->j_commit_interval = sbi->s_commit_interval;
 	/* We could also set up an ext4-specific default for the commit
@@ -2512,6 +2543,8 @@
 	struct inode *journal_inode;
 	journal_t *journal;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	/* First, test for the existence of a valid inode on disk.  Bad
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
@@ -2560,6 +2593,8 @@
 	struct ext4_super_block *es;
 	struct block_device *bdev;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	bdev = ext4_blkdev_get(j_dev);
 	if (bdev == NULL)
 		return NULL;
@@ -2647,6 +2682,8 @@
 	int err = 0;
 	int really_read_only;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		printk(KERN_INFO "EXT4-fs: external journal device major/minor "
@@ -2760,6 +2797,9 @@
 
 	EXT4_SB(sb)->s_journal = journal;
 
+	if (journal_inum == 0)
+		return 0;
+
 	ext4_update_dynamic_rev(sb);
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL);
@@ -2821,6 +2861,10 @@
 {
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		BUG_ON(journal != NULL);
+		return;
+	}
 	jbd2_journal_lock_updates(journal);
 	if (jbd2_journal_flush(journal) < 0)
 		goto out;
@@ -2850,6 +2894,8 @@
 	int j_errno;
 	const char *errstr;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	journal = EXT4_SB(sb)->s_journal;
 
 	/*
@@ -2882,14 +2928,17 @@
 int ext4_force_commit(struct super_block *sb)
 {
 	journal_t *journal;
-	int ret;
+	int ret = 0;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	sb->s_dirt = 0;
-	ret = ext4_journal_force_commit(journal);
+	if (journal) {
+		sb->s_dirt = 0;
+		ret = ext4_journal_force_commit(journal);
+	}
+
 	return ret;
 }
 
@@ -2904,20 +2953,28 @@
 
 static void ext4_write_super(struct super_block *sb)
 {
-	if (mutex_trylock(&sb->s_lock) != 0)
-		BUG();
-	sb->s_dirt = 0;
+	if (EXT4_SB(sb)->s_journal) {
+		if (mutex_trylock(&sb->s_lock) != 0)
+			BUG();
+		sb->s_dirt = 0;
+	}
+	else
+		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 }
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
+	journal_t *journal;
 
 	trace_mark(ext4_sync_fs, "dev %s wait %d", sb->s_id, wait);
 	sb->s_dirt = 0;
-	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
-		if (wait)
-			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
+	journal = EXT4_SB(sb)->s_journal;
+	if (journal) {
+		if (jbd2_journal_start_commit(journal, &target)) {
+			if (wait)
+				jbd2_log_wait_commit(journal, target);
+		}
 	}
 	return 0;
 }
@@ -2933,15 +2990,17 @@
 	if (!(sb->s_flags & MS_RDONLY)) {
 		journal_t *journal = EXT4_SB(sb)->s_journal;
 
-		/* Now we set up the journal barrier. */
-		jbd2_journal_lock_updates(journal);
+		if (journal) {
+			/* Now we set up the journal barrier. */
+			jbd2_journal_lock_updates(journal);
 
-		/*
-		 * We don't want to clear needs_recovery flag when we failed
-		 * to flush the journal.
-		 */
-		if (jbd2_journal_flush(journal) < 0)
-			return;
+			/*
+			 * We don't want to clear needs_recovery flag when we failed
+			 * to flush the journal.
+			 */
+			if (jbd2_journal_flush(journal) < 0)
+				return;
+		}
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -2955,7 +3014,7 @@
  */
 static void ext4_unlockfs(struct super_block *sb)
 {
-	if (!(sb->s_flags & MS_RDONLY)) {
+	if (EXT4_SB(sb)->s_journal && !(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
 		/* Reser the needs_recovery flag before the fs is unlocked. */
 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -3006,7 +3065,8 @@
 
 	es = sbi->s_es;
 
-	ext4_init_journal_params(sb, sbi->s_journal);
+	if (sbi->s_journal)
+		ext4_init_journal_params(sb, sbi->s_journal);
 
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY) ||
 		n_blocks_count > ext4_blocks_count(es)) {
@@ -3091,7 +3151,8 @@
 			 * been changed by e2fsck since we originally mounted
 			 * the partition.)
 			 */
-			ext4_clear_journal_err(sb, es);
+			if (sbi->s_journal)
+				ext4_clear_journal_err(sb, es);
 			sbi->s_mount_state = le16_to_cpu(es->s_state);
 			if ((err = ext4_group_extend(sb, es, n_blocks_count)))
 				goto restore_opts;
@@ -3099,6 +3160,9 @@
 				sb->s_flags &= ~MS_RDONLY;
 		}
 	}
+	if (sbi->s_journal == NULL)
+		ext4_commit_super(sb, es, 1);
+
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -3378,7 +3442,8 @@
 	 * When we journal data on quota file, we have to flush journal to see
 	 * all updates to the file when we bypass pagecache...
 	 */
-	if (ext4_should_journal_data(nd.path.dentry->d_inode)) {
+	if (EXT4_SB(sb)->s_journal &&
+	    ext4_should_journal_data(nd.path.dentry->d_inode)) {
 		/*
 		 * We don't need to lock updates but journal_flush() could
 		 * otherwise be livelocked...
@@ -3451,7 +3516,7 @@
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
-	if (!handle) {
+	if (EXT4_SB(sb)->s_journal && !handle) {
 		printk(KERN_WARNING "EXT4-fs: Quota write (off=%llu, len=%llu)"
 			" cancelled because transaction is not started.\n",
 			(unsigned long long)off, (unsigned long long)len);
@@ -3476,7 +3541,7 @@
 		flush_dcache_page(bh->b_page);
 		unlock_buffer(bh);
 		if (journal_quota)
-			err = ext4_journal_dirty_metadata(handle, bh);
+			err = ext4_handle_dirty_metadata(handle, NULL, bh);
 		else {
 			/* Always do at least ordered writes for quotas */
 			err = ext4_jbd2_file_inode(handle, inode);
--- fs/ext4/xattr.c#3
+++ fs/ext4/xattr.c
@@ -457,7 +457,7 @@
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
 		sb->s_dirt = 1;
-		ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+		ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	}
 }
 
@@ -487,9 +487,9 @@
 		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
-		error = ext4_journal_dirty_metadata(handle, bh);
+		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
-			handle->h_sync = 1;
+			ext4_handle_sync(handle);
 		DQUOT_FREE_BLOCK(inode, 1);
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
@@ -724,8 +724,9 @@
 			if (error == -EIO)
 				goto bad_block;
 			if (!error)
-				error = ext4_journal_dirty_metadata(handle,
-								    bs->bh);
+				error = ext4_handle_dirty_metadata(handle,
+								   inode,
+								   bs->bh);
 			if (error)
 				goto cleanup;
 			goto inserted;
@@ -794,8 +795,9 @@
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
-				error = ext4_journal_dirty_metadata(handle,
-								    new_bh);
+				error = ext4_handle_dirty_metadata(handle,
+								   inode,
+								   new_bh);
 				if (error)
 					goto cleanup_dquot;
 			}
@@ -833,7 +835,8 @@
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(new_bh);
-			error = ext4_journal_dirty_metadata(handle, new_bh);
+			error = ext4_handle_dirty_metadata(handle,
+							   inode, new_bh);
 			if (error)
 				goto cleanup;
 		}
@@ -1040,7 +1043,7 @@
 		 */
 		is.iloc.bh = NULL;
 		if (IS_SYNC(inode))
-			handle->h_sync = 1;
+			ext4_handle_sync(handle);
 	}
 
 cleanup:

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

