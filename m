From: Frank Mayhar <fmayhar@google.com>
Subject: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 30 Oct 2008 13:08:01 -0700
Message-ID: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>, Peter Kukol <pkukol@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYJ3UIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 16:08:12 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id m9UK86FY022289
	for <linux-ext4@vger.kernel.org>; Thu, 30 Oct 2008 20:08:06 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a need to run ext4 on existing ext2 file systems.  To get there
we need to be able to run ext4 without a journal.  I've managed to come
up with an early patch that gets us at least partway there.

This patch just allows ext4 to mount and run with an ext2 root; I
haven't tried it with anything else yet.  It also scribbles in the
superblock, so it takes an fsck to get it back to ext2 compatibility.
I'm posting it to get you guys involved and to hear any comments you
guys have about how I did it.

I say that I did it, but actually it was a sequential collaboration
between Peter Kukul <pkukol@google.com> and I.  He did the first pass
and I went behind him, changed things around a bit and made it actually
sort of work.

This only modifies ext4 itself, it touches nothing else.  I'm not
including a signed-off-by since I don't intend this as an official
submission.  There is more work to do.  I just want to get it out and
let you guys take a look and beat on it if you care to.

---
 acl.c       |    4 
 balloc.c    |   12 +-
 ext4_jbd2.c |   60 +++++++++----
 extents.c   |   34 +++----
 fsync.c     |    2 
 ialloc.c    |   29 +++---
 inode.c     |  258 +++++++++++++++++++++++++++++++++---------------------------
 ioctl.c     |   10 +-
 mballoc.c   |   20 ++--
 migrate.c   |   13 +--
 namei.c     |   83 +++++++++----------
 resize.c    |   50 +++++------
 super.c     |  247 +++++++++++++++++++++++++++++++++++++++------------------
 xattr.c     |   23 +++--
 14 files changed, 501 insertions(+), 344 deletions(-)

diff -up -r linux-2.6.26.y/fs/ext4/acl.c foo/fs/ext4/acl.c
--- linux-2.6.26.y/fs/ext4/acl.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/acl.c	2008-10-30 12:56:08.000000000 -0700
@@ -396,7 +396,7 @@ ext4_acl_chmod(struct inode *inode)
 	retry:
 		handle = ext4_journal_start(inode,
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-		if (IS_ERR(handle)) {
+		if (handle && IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			ext4_std_error(inode->i_sb, error);
 			goto out;
@@ -506,7 +506,7 @@ ext4_xattr_set_acl(struct inode *inode, 
 
 retry:
 	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 	error = ext4_set_acl(handle, inode, type, acl);
 	ext4_journal_stop(handle);
diff -up -r linux-2.6.26.y/fs/ext4/balloc.c foo/fs/ext4/balloc.c
--- linux-2.6.26.y/fs/ext4/balloc.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/balloc.c	2008-10-30 12:56:08.000000000 -0700
@@ -816,11 +816,11 @@ do_more:
 
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
 
@@ -1585,9 +1585,9 @@ ext4_try_to_allocate_with_rsv(struct sup
 	}
 out:
 	if (ret >= 0) {
-		BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for "
+		BUFFER_TRACE(bitmap_bh, "handle_dirty_metadata for "
 					"bitmap block");
-		fatal = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		fatal = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (fatal) {
 			*errp = fatal;
 			return -1;
@@ -1920,8 +1920,8 @@ allocated:
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
 
-	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
-	err = ext4_journal_dirty_metadata(handle, gdp_bh);
+	BUFFER_TRACE(gdp_bh, "handle_dirty_metadata for group descriptor");
+	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 	if (!fatal)
 		fatal = err;
 
diff -up -r linux-2.6.26.y/fs/ext4/ext4_jbd2.c foo/fs/ext4/ext4_jbd2.c
--- linux-2.6.26.y/fs/ext4/ext4_jbd2.c	2008-10-08 16:36:07.000000000 -0700
+++ foo/fs/ext4/ext4_jbd2.c	2008-10-30 12:56:08.000000000 -0700
@@ -7,53 +7,77 @@
 int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
 				struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_undo_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	int err = 0;
+
+	if (handle) {
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
+	if (handle) {
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
+	if (handle) {
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
+	if (handle) {
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
+	if (handle) {
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
+	if (handle) {
+		err = jbd2_journal_dirty_metadata(handle, bh);
+		if (err)
+			ext4_journal_abort_handle(where, __func__, bh, handle, err);
+	}
 	return err;
 }
diff -up -r linux-2.6.26.y/fs/ext4/extents.c foo/fs/ext4/extents.c
--- linux-2.6.26.y/fs/ext4/extents.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/extents.c	2008-10-30 12:56:08.000000000 -0700
@@ -96,7 +96,7 @@ static int ext4_ext_journal_restart(hand
 {
 	int err;
 
-	if (handle->h_buffer_credits > needed)
+	if (handle && handle->h_buffer_credits > needed)
 		return 0;
 	err = ext4_journal_extend(handle, needed);
 	if (err <= 0)
@@ -133,7 +133,7 @@ static int ext4_ext_dirty(handle_t *hand
 	int err;
 	if (path->p_bh) {
 		/* path points to block */
-		err = ext4_journal_dirty_metadata(handle, path->p_bh);
+		err = ext4_handle_dirty_metadata(handle, inode, path->p_bh);
 	} else {
 		/* path points to leaf/index in inode body */
 		err = ext4_mark_inode_dirty(handle, inode);
@@ -778,7 +778,7 @@ static int ext4_ext_split(handle_t *hand
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	err = ext4_journal_dirty_metadata(handle, bh);
+	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto cleanup;
 	brelse(bh);
@@ -857,7 +857,7 @@ static int ext4_ext_split(handle_t *hand
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
-		err = ext4_journal_dirty_metadata(handle, bh);
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto cleanup;
 		brelse(bh);
@@ -953,7 +953,7 @@ static int ext4_ext_grow_indepth(handle_
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
 
-	err = ext4_journal_dirty_metadata(handle, bh);
+	err = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (err)
 		goto out;
 
@@ -1885,7 +1885,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 
 	while (ex >= EXT_FIRST_EXTENT(eh) &&
 			ex_ee_block + ex_ee_len > start) {
-		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
+		ext_debug("remove ext %lu:%u\n", (unsigned long)ex_ee_block, ex_ee_len);
 		path[depth].p_ext = ex;
 
 		a = ex_ee_block > start ? ex_ee_block : start;
@@ -2012,7 +2012,7 @@ static int ext4_ext_remove_space(struct 
 
 	/* probably first extent we're gonna free will be last in block */
 	handle = ext4_journal_start(inode, depth + 1);
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
 	ext4_ext_invalidate_cache(inode);
@@ -2023,7 +2023,7 @@ static int ext4_ext_remove_space(struct 
 	 */
 	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
-		ext4_journal_stop(handle);
+		ext4_journal_stop(sb, handle);
 		return -ENOMEM;
 	}
 	path[0].p_hdr = ext_inode_hdr(inode);
@@ -2126,7 +2126,7 @@ out:
 	ext4_ext_tree_changed(inode);
 	ext4_ext_drop_refs(path);
 	kfree(path);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(sb, handle);
 
 	return err;
 }
@@ -2582,7 +2582,7 @@ int ext4_ext_get_blocks(handle_t *handle
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%lu requested for inode %u\n",
-			iblock, max_blocks, inode->i_ino);
+			iblock, max_blocks, (unsigned)inode->i_ino);
 
 	/* check in cache */
 	goal = ext4_ext_in_cache(inode, iblock, &newex);
@@ -2645,7 +2645,7 @@ int ext4_ext_get_blocks(handle_t *handle
 			/* number of remaining blocks in the extent */
 			allocated = ee_len - (iblock - ee_block);
 			ext_debug("%u fit into %lu:%d -> %llu\n", iblock,
-					ee_block, ee_len, newblock);
+					(unsigned long)ee_block, ee_len, newblock);
 
 			/* Do not put uninitialized extent in the cache */
 			if (!ext4_ext_is_uninitialized(ex)) {
@@ -2811,7 +2811,7 @@ void ext4_ext_truncate(struct inode *ino
 	 */
 	handle = ext4_journal_start(inode,
 				    ext4_writepages_trans_blocks(inode, 1) + 3);
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return;
 
 	if (inode->i_size & (sb->s_blocksize - 1))
@@ -2842,7 +2842,7 @@ void ext4_ext_truncate(struct inode *ino
 	/* In a multi-transaction truncate, we only make the final
 	 * transaction synchronous.
 	 */
-	if (IS_SYNC(inode))
+	if (handle && IS_SYNC(inode))
 		handle->h_sync = 1;
 
 out_stop:
@@ -2859,7 +2859,7 @@ out_stop:
 
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(sb, handle);
 }
 
 /*
@@ -2962,7 +2962,7 @@ retry:
 		block = block + ret;
 		max_blocks = max_blocks - ret;
 		handle = ext4_journal_start(inode, credits);
-		if (IS_ERR(handle)) {
+		if (handle && IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			break;
 		}
@@ -2978,7 +2978,7 @@ retry:
 				    inode->i_ino, block, max_blocks);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
-			ret2 = ext4_journal_stop(handle);
+			ret2 = ext4_journal_stop(inode->i_sb, handle);
 			break;
 		}
 		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
@@ -2990,7 +2990,7 @@ retry:
 		ext4_falloc_update_inode(inode, mode, new_size,
 						buffer_new(&map_bh));
 		ext4_mark_inode_dirty(handle, inode);
-		ret2 = ext4_journal_stop(handle);
+		ret2 = ext4_journal_stop(inode->i_sb, handle);
 		if (ret2)
 			break;
 	}
diff -up -r linux-2.6.26.y/fs/ext4/fsync.c foo/fs/ext4/fsync.c
--- linux-2.6.26.y/fs/ext4/fsync.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/fsync.c	2008-10-30 12:56:08.000000000 -0700
@@ -49,7 +49,7 @@ int ext4_sync_file(struct file * file, s
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
-	J_ASSERT(ext4_journal_current_handle() == NULL);
+	J_ASSERT(ext4_journal_current_handle(inode->i_sb) == NULL);
 
 	/*
 	 * data=writeback:
diff -up -r linux-2.6.26.y/fs/ext4/ialloc.c foo/fs/ext4/ialloc.c
--- linux-2.6.26.y/fs/ext4/ialloc.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/ialloc.c	2008-10-30 12:56:08.000000000 -0700
@@ -250,12 +250,12 @@ void ext4_free_inode (handle_t *handle, 
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
@@ -645,7 +645,8 @@ repeat_in_this_group:
 		if (ino < EXT4_INODES_PER_GROUP(sb)) {
 
 			BUFFER_TRACE(bitmap_bh, "get_write_access");
-			err = ext4_journal_get_write_access(handle, bitmap_bh);
+			err = ext4_journal_get_write_access(handle,
+								    bitmap_bh);
 			if (err)
 				goto fail;
 
@@ -653,15 +654,17 @@ repeat_in_this_group:
 						ino, bitmap_bh->b_data)) {
 				/* we won it */
 				BUFFER_TRACE(bitmap_bh,
-					"call ext4_journal_dirty_metadata");
-				err = ext4_journal_dirty_metadata(handle,
+					    "call ext4_handle_dirty_metadata");
+				err = ext4_handle_dirty_metadata(handle,
+								inode,
 								bitmap_bh);
 				if (err)
 					goto fail;
 				goto got;
 			}
 			/* we lost it */
-			jbd2_journal_release_buffer(handle, bitmap_bh);
+			if (handle)
+				jbd2_journal_release_buffer(handle, bitmap_bh);
 
 			if (++ino < EXT4_INODES_PER_GROUP(sb))
 				goto repeat_in_this_group;
@@ -721,7 +724,8 @@ got:
 		/* Don't need to dirty bitmap block if we didn't change it */
 		if (free) {
 			BUFFER_TRACE(block_bh, "dirty block bitmap");
-			err = ext4_journal_dirty_metadata(handle, block_bh);
+			err = ext4_handle_dirty_metadata(handle,
+							NULL, block_bh);
 		}
 
 		brelse(block_bh);
@@ -766,8 +770,8 @@ got:
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group));
-	BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
-	err = ext4_journal_dirty_metadata(handle, bh2);
+	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, bh2);
 	if (err) goto fail;
 
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
@@ -820,7 +824,7 @@ got:
 	ei->i_block_group = group;
 
 	ext4_set_inode_flags(inode);
-	if (IS_DIRSYNC(inode))
+	if (handle && IS_DIRSYNC(inode))
 		handle->h_sync = 1;
 	insert_inode_hash(inode);
 	spin_lock(&sbi->s_next_gen_lock);
@@ -1019,4 +1023,3 @@ unsigned long ext4_count_dirs (struct su
 	}
 	return count;
 }
-
diff -up -r linux-2.6.26.y/fs/ext4/inode.c foo/fs/ext4/inode.c
--- linux-2.6.26.y/fs/ext4/inode.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/inode.c	2008-10-30 12:56:08.000000000 -0700
@@ -71,6 +71,8 @@ static int ext4_inode_is_fast_symlink(st
  * "bh" may be NULL: a metadata block may have been freed from memory
  * but there may still be a record of it in the journal, and that record
  * still needs to be revoked.
+ *
+ * If there's no handle we're not journaling so there's nothing to do.
  */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 			struct buffer_head *bh, ext4_fsblk_t blocknr)
@@ -79,6 +81,9 @@ int ext4_forget(handle_t *handle, int is
 
 	might_sleep();
 
+	if (!handle)
+		return 0;
+
 	BUFFER_TRACE(bh, "enter");
 
 	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
@@ -154,7 +159,7 @@ static handle_t *start_transaction(struc
 	handle_t *result;
 
 	result = ext4_journal_start(inode, blocks_for_truncate(inode));
-	if (!IS_ERR(result))
+	if (!result || !IS_ERR(result))
 		return result;
 
 	ext4_std_error(inode->i_sb, PTR_ERR(result));
@@ -169,7 +174,7 @@ static handle_t *start_transaction(struc
  */
 static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
 {
-	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+	if (!handle || handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
 		return 0;
 	if (!ext4_journal_extend(handle, blocks_for_truncate(inode)))
 		return 0;
@@ -183,6 +188,7 @@ static int try_to_extend_transaction(han
  */
 static int ext4_journal_test_restart(handle_t *handle, struct inode *inode)
 {
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
 	jbd_debug(2, "restarting handle %p\n", handle);
 	return ext4_journal_restart(handle, blocks_for_truncate(inode));
 }
@@ -195,7 +201,8 @@ void ext4_delete_inode (struct inode * i
 	handle_t *handle;
 	int err;
 
-	if (ext4_should_order_data(inode))
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
@@ -203,7 +210,7 @@ void ext4_delete_inode (struct inode * i
 		goto no_delete;
 
 	handle = ext4_journal_start(inode, blocks_for_truncate(inode)+3);
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
 		/*
 		 * If we're going to skip the normal cleanup, we still need to
@@ -214,7 +221,7 @@ void ext4_delete_inode (struct inode * i
 		goto no_delete;
 	}
 
-	if (IS_SYNC(inode))
+	if (handle && IS_SYNC(inode))
 		handle->h_sync = 1;
 	inode->i_size = 0;
 	err = ext4_mark_inode_dirty(handle, inode);
@@ -232,7 +239,7 @@ void ext4_delete_inode (struct inode * i
 	 * enough credits left in the handle to remove the inode from
 	 * the orphan list and set the dtime field.
 	 */
-	if (handle->h_buffer_credits < 3) {
+	if (handle && handle->h_buffer_credits < 3) {
 		err = ext4_journal_extend(handle, 3);
 		if (err > 0)
 			err = ext4_journal_restart(handle, 3);
@@ -240,7 +247,7 @@ void ext4_delete_inode (struct inode * i
 			ext4_warning(inode->i_sb, __func__,
 				     "couldn't extend journal (err %d)", err);
 		stop_handle:
-			ext4_journal_stop(handle);
+			ext4_journal_stop(inode->i_sb, handle);
 			goto no_delete;
 		}
 	}
@@ -268,7 +275,7 @@ void ext4_delete_inode (struct inode * i
 		clear_inode(inode);
 	else
 		ext4_free_inode(handle, inode);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 	return;
 no_delete:
 	clear_inode(inode);	/* We must guarantee clearing of inode... */
@@ -717,8 +724,8 @@ static int ext4_alloc_branch(handle_t *h
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 
-		BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-		err = ext4_journal_dirty_metadata(handle, bh);
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto failed;
 	}
@@ -813,8 +820,8 @@ static int ext4_splice_branch(handle_t *
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
@@ -881,7 +888,8 @@ int ext4_get_blocks_handle(handle_t *han
 
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
-	J_ASSERT(handle != NULL || create == 0);
+	/*J_ASSERT(handle != NULL || create == 0);*/
+
 	depth = ext4_block_to_path(inode, iblock, offsets,
 					&blocks_to_boundary);
 
@@ -1160,7 +1168,7 @@ int ext4_get_blocks_wrap(handle_t *handl
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = ext4_journal_current_handle();
+	handle_t *handle = ext4_journal_current_handle(inode->i_sb);
 	int ret = 0, started = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 	int dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
@@ -1184,7 +1192,7 @@ static int ext4_get_block(struct inode *
 		ret = 0;
 	}
 	if (started)
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 out:
 	return ret;
 }
@@ -1198,8 +1206,6 @@ struct buffer_head *ext4_getblk(handle_t
 	struct buffer_head dummy;
 	int fatal = 0, err;
 
-	J_ASSERT(handle != NULL || create == 0);
-
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
@@ -1224,7 +1230,6 @@ struct buffer_head *ext4_getblk(handle_t
 		}
 		if (buffer_new(&dummy)) {
 			J_ASSERT(create != 0);
-			J_ASSERT(handle != NULL);
 
 			/*
 			 * Now that we do not always journal data, we should
@@ -1241,8 +1246,8 @@ struct buffer_head *ext4_getblk(handle_t
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
@@ -1368,7 +1373,7 @@ retry:
 
 	page = __grab_cache_page(mapping, index);
 	if (!page) {
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1384,7 +1389,7 @@ retry:
 
 	if (ret) {
  		unlock_page(page);
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
  		page_cache_release(page);
 	}
 
@@ -1400,7 +1405,7 @@ static int write_end_fn(handle_t *handle
 	if (!buffer_mapped(bh) || buffer_freed(bh))
 		return 0;
 	set_buffer_uptodate(bh);
-	return ext4_journal_dirty_metadata(handle, bh);
+	return ext4_handle_dirty_metadata(handle, NULL, bh);
 }
 
 /*
@@ -1415,8 +1420,8 @@ static int ext4_ordered_write_end(struct
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = mapping->host;
+	handle_t *handle = ext4_journal_current_handle(inode->i_sb);
 	int ret = 0, ret2;
 
 	ret = ext4_jbd2_file_inode(handle, inode);
@@ -1438,7 +1443,7 @@ static int ext4_ordered_write_end(struct
 		if (ret2 < 0)
 			ret = ret2;
 	}
-	ret2 = ext4_journal_stop(handle);
+	ret2 = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = ret2;
 
@@ -1450,8 +1455,8 @@ static int ext4_writeback_write_end(stru
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = mapping->host;
+	handle_t *handle = ext4_journal_current_handle(inode->i_sb);
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
@@ -1465,7 +1470,7 @@ static int ext4_writeback_write_end(stru
 	if (ret2 < 0)
 		ret = ret2;
 
-	ret2 = ext4_journal_stop(handle);
+	ret2 = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = ret2;
 
@@ -1477,8 +1482,8 @@ static int ext4_journalled_write_end(str
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = mapping->host;
+	handle_t *handle = ext4_journal_current_handle(inode->i_sb);
 	int ret = 0, ret2;
 	int partial = 0;
 	unsigned from, to;
@@ -1507,7 +1512,7 @@ static int ext4_journalled_write_end(str
 	}
 
 	unlock_page(page);
-	ret2 = ext4_journal_stop(handle);
+	ret2 = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = ret2;
 	page_cache_release(page);
@@ -2071,16 +2076,9 @@ static int ext4_da_get_block_write(struc
 	loff_t disksize = EXT4_I(inode)->i_disksize;
 	handle_t *handle = NULL;
 
-	handle = ext4_journal_current_handle();
-	if (!handle) {
-		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, 0, 0, 0);
-		BUG_ON(!ret);
-	} else {
-		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+	handle = ext4_journal_current_handle(inode->i_sb);
+	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
 				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
-	}
-
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
@@ -2265,33 +2263,37 @@ restart_loop:
 		needed_blocks = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 
 		/* start a new transaction*/
-		handle = ext4_journal_start(inode, needed_blocks);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			printk(KERN_EMERG "ext4_da_writepages: jbd2_start: "
-			       "%ld pages, ino %lu; err %d\n",
-			       wbc->nr_to_write, inode->i_ino, ret);
-			dump_stack();
-			goto out_writepages;
-		}
-		if (ext4_should_order_data(inode)) {
-			/*
-			 * With ordered mode we need to add
-			 * the inode to the journal handle
-			 * when we do block allocation.
-			 */
-			ret = ext4_jbd2_file_inode(handle, inode);
-			if (ret) {
-				ext4_journal_stop(handle);
+		if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb,
+					    EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+			handle = ext4_journal_start(inode, needed_blocks);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				printk(KERN_EMERG "ext4_da_writepages: jbd2_start: "
+				       "%ld pages, ino %lu; err %d\n",
+				       wbc->nr_to_write, inode->i_ino, ret);
+				dump_stack();
 				goto out_writepages;
 			}
-
+			if (ext4_should_order_data(inode)) {
+				/*
+				 * With ordered mode we need to add
+				 * the inode to the journal handle
+				 * when we do block allocation.
+				 */
+				ret = ext4_jbd2_file_inode(handle, inode);
+				if (ret) {
+					ext4_journal_stop(inode->i_sb, handle);
+					goto out_writepages;
+				}
+	
+			}
 		}
 
 		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc,
 						ext4_da_get_block_write);
-		ext4_journal_stop(handle);
+		if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+			ext4_journal_stop(inode->i_sb, handle);
 		if (ret == MPAGE_DA_EXTENT_TAIL) {
 			/*
 			 * got one extent now try with
@@ -2356,7 +2358,7 @@ retry:
 
 	page = __grab_cache_page(mapping, index);
 	if (!page) {
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2366,7 +2368,7 @@ retry:
 							ext4_da_get_block_prep);
 	if (ret < 0) {
 		unlock_page(page);
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 		page_cache_release(page);
 	}
 
@@ -2406,7 +2408,7 @@ static int ext4_da_write_end(struct file
 {
 	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
-	handle_t *handle = ext4_journal_current_handle();
+	handle_t *handle = ext4_journal_current_handle(inode->i_sb);
 	loff_t new_i_size;
 	unsigned long start, end;
 
@@ -2442,9 +2444,11 @@ static int ext4_da_write_end(struct file
 	copied = ret2;
 	if (ret2 < 0)
 		ret = ret2;
-	ret2 = ext4_journal_stop(handle);
-	if (!ret)
-		ret = ret2;
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		ret2 = ext4_journal_stop(inode->i_sb, handle);
+		if (!ret)
+			ret = ret2;
+	}
 
 	return ret ? ret : copied;
 }
@@ -2635,7 +2639,7 @@ static int ext4_normal_writepage(struct 
 					ext4_bh_unmapped_or_delay));
 	}
 
-	if (!ext4_journal_current_handle())
+	if (!ext4_journal_current_handle(inode->i_sb))
 		return __ext4_normal_writepage(page, wbc);
 
 	redirty_page_for_writepage(wbc, page);
@@ -2679,7 +2683,7 @@ static int __ext4_journalled_writepage(s
 				PAGE_CACHE_SIZE, NULL, write_end_fn);
 	if (ret == 0)
 		ret = err;
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 
@@ -2721,7 +2725,7 @@ static int ext4_journalled_writepage(str
 					ext4_bh_unmapped_or_delay));
 	}
 
-	if (ext4_journal_current_handle())
+	if (ext4_journal_current_handle(inode->i_sb))
 		goto no_write;
 
 	if (PageChecked(page)) {
@@ -2815,12 +2819,12 @@ static ssize_t ext4_direct_IO(int rw, st
 			}
 			ret = ext4_orphan_add(handle, inode);
 			if (ret) {
-				ext4_journal_stop(handle);
+				ext4_journal_stop(inode->i_sb, handle);
 				goto out;
 			}
 			orphan = 1;
 			ei->i_disksize = inode->i_size;
-			ext4_journal_stop(handle);
+			ext4_journal_stop(inode->i_sb, handle);
 		}
 	}
 
@@ -2857,7 +2861,7 @@ static ssize_t ext4_direct_IO(int rw, st
 				ext4_mark_inode_dirty(handle, inode);
 			}
 		}
-		err = ext4_journal_stop(handle);
+		err = ext4_journal_stop(inode->i_sb, handle);
 		if (ret == 0)
 			ret = err;
 	}
@@ -3047,7 +3051,7 @@ int ext4_block_truncate_page(handle_t *h
 
 	err = 0;
 	if (ext4_should_journal_data(inode)) {
-		err = ext4_journal_dirty_metadata(handle, bh);
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
 	} else {
 		if (ext4_should_order_data(inode))
 			err = ext4_jbd2_file_inode(handle, inode);
@@ -3171,8 +3175,8 @@ static void ext4_clear_blocks(handle_t *
 	__le32 *p;
 	if (try_to_extend_transaction(handle, inode)) {
 		if (bh) {
-			BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-			ext4_journal_dirty_metadata(handle, bh);
+			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+			ext4_handle_dirty_metadata(handle, inode, bh);
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_test_restart(handle, inode);
@@ -3272,7 +3276,7 @@ static void ext4_free_data(handle_t *han
 				  count, block_to_free_p, p);
 
 	if (this_bh) {
-		BUFFER_TRACE(this_bh, "call ext4_journal_dirty_metadata");
+		BUFFER_TRACE(this_bh, "call ext4_handle_dirty_metadata");
 
 		/*
 		 * The buffer head should have an attached journal head at this
@@ -3281,7 +3285,7 @@ static void ext4_free_data(handle_t *han
 		 * the block was cleared. Check for this instead of OOPSing.
 		 */
 		if (bh2jh(this_bh))
-			ext4_journal_dirty_metadata(handle, this_bh);
+			ext4_handle_dirty_metadata(handle, inode, this_bh);
 		else
 			ext4_error(inode->i_sb, __func__,
 				   "circular indirect block detected, "
@@ -3311,7 +3315,7 @@ static void ext4_free_branches(handle_t 
 	ext4_fsblk_t nr;
 	__le32 *p;
 
-	if (is_handle_aborted(handle))
+	if (handle && is_handle_aborted(handle))
 		return;
 
 	if (depth--) {
@@ -3381,11 +3385,13 @@ static void ext4_free_branches(handle_t 
 			 * will merely complain about releasing a free block,
 			 * rather than leaking blocks.
 			 */
-			if (is_handle_aborted(handle))
-				return;
-			if (try_to_extend_transaction(handle, inode)) {
-				ext4_mark_inode_dirty(handle, inode);
-				ext4_journal_test_restart(handle, inode);
+			if (handle) {
+				if (is_handle_aborted(handle))
+					return;
+				if (try_to_extend_transaction(handle, inode)) {
+					ext4_mark_inode_dirty(handle, inode);
+					ext4_journal_test_restart(handle, inode);
+				}
 			}
 
 			ext4_free_blocks(handle, inode, nr, 1, 1);
@@ -3400,9 +3406,10 @@ static void ext4_free_branches(handle_t 
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
@@ -3588,7 +3595,7 @@ do_indirects:
 	 * In a multi-transaction truncate, we only make the final transaction
 	 * synchronous
 	 */
-	if (IS_SYNC(inode))
+	if (handle && IS_SYNC(inode))
 		handle->h_sync = 1;
 out_stop:
 	/*
@@ -3601,7 +3608,7 @@ out_stop:
 	if (inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 }
 
 static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
@@ -4103,8 +4110,9 @@ static int ext4_do_update_inode(handle_t
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
-			handle->h_sync = 1;
-			err = ext4_journal_dirty_metadata(handle,
+			if (handle)
+				handle->h_sync = 1;
+			err = ext4_handle_dirty_metadata(handle, inode,
 					EXT4_SB(sb)->s_sbh);
 		}
 	}
@@ -4131,11 +4139,11 @@ static int ext4_do_update_inode(handle_t
 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
 	}
 
-
-	BUFFER_TRACE(bh, "call ext4_journal_dirty_metadata");
-	rc = ext4_journal_dirty_metadata(handle, bh);
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	rc = ext4_handle_dirty_metadata(handle, inode, bh);
 	if (!err)
 		err = rc;
+
 	ei->i_state &= ~EXT4_STATE_NEW;
 
 out_brelse:
@@ -4184,7 +4192,7 @@ int ext4_write_inode(struct inode *inode
 	if (current->flags & PF_MEMALLOC)
 		return 0;
 
-	if (ext4_journal_current_handle()) {
+	if (ext4_journal_current_handle(inode->i_sb)) {
 		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
 		dump_stack();
 		return -EIO;
@@ -4196,6 +4204,23 @@ int ext4_write_inode(struct inode *inode
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
+			printk ("IO error syncing ext4 inode [%s:%08lx]\n",
+				inode->i_sb->s_id,
+				(unsigned long) inode->i_ino);
+			err = -EIO;
+		}
+	}
+	return err;
+}
+
 /*
  * ext4_setattr()
  *
@@ -4244,7 +4269,7 @@ int ext4_setattr(struct dentry *dentry, 
 		}
 		error = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
 		if (error) {
-			ext4_journal_stop(handle);
+			ext4_journal_stop(inode->i_sb, handle);
 			return error;
 		}
 		/* Update corresponding info in inode so that everything is in
@@ -4254,7 +4279,7 @@ int ext4_setattr(struct dentry *dentry, 
 		if (attr->ia_valid & ATTR_GID)
 			inode->i_gid = attr->ia_gid;
 		error = ext4_mark_inode_dirty(handle, inode);
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
@@ -4283,9 +4308,10 @@ int ext4_setattr(struct dentry *dentry, 
 		rc = ext4_mark_inode_dirty(handle, inode);
 		if (!error)
 			error = rc;
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 
-		if (ext4_should_order_data(inode)) {
+		if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+		    ext4_should_order_data(inode)) {
 			error = ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
 			if (error) {
@@ -4296,7 +4322,7 @@ int ext4_setattr(struct dentry *dentry, 
 					goto err_out;
 				}
 				ext4_orphan_del(handle, inode);
-				ext4_journal_stop(handle);
+				ext4_journal_stop(inode->i_sb, handle);
 				goto err_out;
 			}
 		}
@@ -4446,16 +4472,15 @@ int
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
@@ -4527,7 +4552,8 @@ int ext4_mark_inode_dirty(handle_t *hand
 
 	might_sleep();
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
+	if (handle &&
+	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !(EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND)) {
 		/*
 		 * We need extra buffer credits since we may write into EA block
@@ -4576,9 +4602,14 @@ int ext4_mark_inode_dirty(handle_t *hand
  */
 void ext4_dirty_inode(struct inode *inode)
 {
-	handle_t *current_handle = ext4_journal_current_handle();
+	handle_t *current_handle = ext4_journal_current_handle(inode->i_sb);
 	handle_t *handle;
 
+	if (!current_handle) {
+		ext4_mark_inode_dirty(NULL, inode);
+		return;
+	}
+
 	handle = ext4_journal_start(inode, 2);
 	if (IS_ERR(handle))
 		goto out;
@@ -4592,7 +4623,7 @@ void ext4_dirty_inode(struct inode *inod
 				current_handle);
 		ext4_mark_inode_dirty(handle, inode);
 	}
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 out:
 	return;
 }
@@ -4616,8 +4647,9 @@ static int ext4_pin_inode(handle_t *hand
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
@@ -4673,7 +4705,7 @@ int ext4_change_inode_journal_flag(struc
 
 	err = ext4_mark_inode_dirty(handle, inode);
 	handle->h_sync = 1;
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 	ext4_std_error(inode->i_sb, err);
 
 	return err;
diff -up -r linux-2.6.26.y/fs/ext4/ioctl.c foo/fs/ext4/ioctl.c
--- linux-2.6.26.y/fs/ext4/ioctl.c	2008-10-08 16:36:07.000000000 -0700
+++ foo/fs/ext4/ioctl.c	2008-10-30 12:56:08.000000000 -0700
@@ -84,11 +84,11 @@ long ext4_ioctl(struct file *filp, unsig
 		}
 
 		handle = ext4_journal_start(inode, 1);
-		if (IS_ERR(handle)) {
+		if (handle && IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto flags_out;
 		}
-		if (IS_SYNC(inode))
+		if (handle && IS_SYNC(inode))
 			handle->h_sync = 1;
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err)
@@ -103,7 +103,7 @@ long ext4_ioctl(struct file *filp, unsig
 
 		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 flags_err:
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 		if (err)
 			goto flags_out;
 
@@ -136,7 +136,7 @@ flags_out:
 		}
 
 		handle = ext4_journal_start(inode, 1);
-		if (IS_ERR(handle)) {
+		if (handle && IS_ERR(handle)) {
 			err = PTR_ERR(handle);
 			goto setversion_out;
 		}
@@ -146,7 +146,7 @@ flags_out:
 			inode->i_generation = generation;
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
diff -up -r linux-2.6.26.y/fs/ext4/mballoc.c foo/fs/ext4/mballoc.c
--- linux-2.6.26.y/fs/ext4/mballoc.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/mballoc.c	2008-10-30 12:56:08.000000000 -0700
@@ -2940,7 +2940,7 @@ ext4_mb_mark_diskspace_used(struct ext4_
 		mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group),
 				bitmap_bh->b_data, ac->ac_b_ex.fe_start,
 				ac->ac_b_ex.fe_len);
-		err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!err)
 			err = -EAGAIN;
 		goto out_err;
@@ -2986,10 +2986,10 @@ ext4_mb_mark_diskspace_used(struct ext4_
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
@@ -4442,6 +4442,8 @@ static void ext4_mb_poll_new_transaction
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
+	if (!handle)
+		return;
 	if (sbi->s_last_transaction == handle->h_transaction->t_tid)
 		return;
 
@@ -4478,13 +4480,15 @@ ext4_mb_free_metadata(handle_t *handle, 
 	struct ext4_free_metadata *md;
 	int i;
 
+	BUG_ON(!handle);
 	BUG_ON(e4b->bd_bitmap_page == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
 	ext4_lock_group(sb, group);
 	for (i = 0; i < count; i++) {
+		int htid = handle->h_transaction->t_tid;
 		md = db->bb_md_cur;
-		if (md && db->bb_tid != handle->h_transaction->t_tid) {
+		if (md && db->bb_tid != htid) {
 			db->bb_md_cur = NULL;
 			md = NULL;
 		}
@@ -4509,7 +4513,7 @@ ext4_mb_free_metadata(handle_t *handle, 
 				page_cache_get(e4b->bd_buddy_page);
 				page_cache_get(e4b->bd_bitmap_page);
 				db->bb_md_cur = md;
-				db->bb_tid = handle->h_transaction->t_tid;
+				db->bb_tid = htid;
 				mb_debug("new md 0x%p for group %lu\n",
 						md, md->group);
 			} else {
@@ -4643,7 +4647,7 @@ do_more:
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
-	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 
 	if (ac) {
 		ac->ac_b_ex.fe_group = block_group;
@@ -4652,7 +4656,7 @@ do_more:
 		ext4_mb_store_history(ac);
 	}
 
-	if (metadata) {
+	if (handle && metadata) {
 		/* blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed */
 		ext4_mb_free_metadata(handle, &e4b, block_group, bit, count);
@@ -4682,7 +4686,7 @@ do_more:
 
 	/* And the group descriptor block */
 	BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
-	ret = ext4_journal_dirty_metadata(handle, gd_bh);
+	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
 
diff -up -r linux-2.6.26.y/fs/ext4/migrate.c foo/fs/ext4/migrate.c
--- linux-2.6.26.y/fs/ext4/migrate.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/migrate.c	2008-10-30 12:56:08.000000000 -0700
@@ -60,7 +60,8 @@ static int finish_range(handle_t *handle
 	/*
 	 * Make sure the credit we accumalated is not really high
 	 */
-	if (needed && handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {
+	if (needed && handle &&
+	    handle->h_buffer_credits >= EXT4_RESERVE_TRANS_BLOCKS) {
 		retval = ext4_journal_restart(handle, needed);
 		if (retval)
 			goto err_out;
@@ -230,7 +231,7 @@ static int extend_credit_for_blkdel(hand
 {
 	int retval = 0, needed;
 
-	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+	if (handle && handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
 		return 0;
 	/*
 	 * We are freeing a blocks. During this we touch
@@ -480,7 +481,7 @@ int ext4_ext_migrate(struct inode *inode
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					2 * EXT4_QUOTA_INIT_BLOCKS(inode->i_sb)
 					+ 1);
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		goto err_out;
 	}
@@ -489,7 +490,7 @@ int ext4_ext_migrate(struct inode *inode
 				S_IFREG);
 	if (IS_ERR(tmp_inode)) {
 		retval = -ENOMEM;
-		ext4_journal_stop(handle);
+		ext4_journal_stop(inode->i_sb, handle);
 		tmp_inode = NULL;
 		goto err_out;
 	}
@@ -506,7 +507,7 @@ int ext4_ext_migrate(struct inode *inode
 
 	ext4_ext_tree_init(handle, tmp_inode);
 	ext4_orphan_add(handle, tmp_inode);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 
 	/*
 	 * start with one credit accounted for
@@ -623,7 +624,7 @@ err_out:
 	 */
 	tmp_inode->i_nlink = 0;
 
-	ext4_journal_stop(handle);
+	ext4_journal_stop(inode->i_sb, handle);
 	mutex_unlock(&(inode->i_mutex));
 
 	if (tmp_inode)
diff -up -r linux-2.6.26.y/fs/ext4/namei.c foo/fs/ext4/namei.c
--- linux-2.6.26.y/fs/ext4/namei.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/namei.c	2008-10-30 12:56:08.000000000 -0700
@@ -1238,10 +1238,10 @@ static struct ext4_dir_entry_2 *do_split
 		de = de2;
 	}
 	dx_insert_block (frame, hash2 + continued, newblock);
-	err = ext4_journal_dirty_metadata (handle, bh2);
+	err = ext4_handle_dirty_metadata (handle, dir, bh2);
 	if (err)
 		goto journal_error;
-	err = ext4_journal_dirty_metadata (handle, frame->bh);
+	err = ext4_handle_dirty_metadata (handle, dir, frame->bh);
 	if (err)
 		goto journal_error;
 	brelse (bh2);
@@ -1345,8 +1345,8 @@ static int add_dirent_to_buf(handle_t *h
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
@@ -1583,7 +1583,7 @@ static int ext4_dx_add_entry(handle_t *h
 			dxtrace(dx_show_index ("node", frames[1].entries));
 			dxtrace(dx_show_index ("node",
 			       ((struct dx_node *) bh2->b_data)->entries));
-			err = ext4_journal_dirty_metadata(handle, bh2);
+			err = ext4_handle_dirty_metadata(handle, inode, bh2);
 			if (err)
 				goto journal_error;
 			brelse (bh2);
@@ -1608,7 +1608,7 @@ static int ext4_dx_add_entry(handle_t *h
 			if (err)
 				goto journal_error;
 		}
-		ext4_journal_dirty_metadata(handle, frames[0].bh);
+		ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
 	}
 	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
 	if (!de)
@@ -1654,8 +1654,8 @@ static int ext4_delete_entry (handle_t *
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
@@ -1727,10 +1727,10 @@ retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode = ext4_new_inode (handle, dir, mode);
@@ -1741,7 +1741,7 @@ retry:
 		ext4_set_aops(inode);
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -1761,10 +1761,10 @@ retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode = ext4_new_inode (handle, dir, mode);
@@ -1776,7 +1776,7 @@ retry:
 #endif
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -1797,10 +1797,10 @@ retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
 					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode = ext4_new_inode (handle, dir, S_IFDIR | mode);
@@ -1830,8 +1830,8 @@ retry:
 	strcpy (de->name, "..");
 	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
 	inode->i_nlink = 2;
-	BUFFER_TRACE(dir_block, "call ext4_journal_dirty_metadata");
-	ext4_journal_dirty_metadata(handle, dir_block);
+	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ext4_handle_dirty_metadata(handle, dir, dir_block);
 	brelse (dir_block);
 	ext4_mark_inode_dirty(handle, inode);
 	err = ext4_add_entry (handle, dentry, inode);
@@ -1847,7 +1847,7 @@ out_clear_inode:
 	ext4_mark_inode_dirty(handle, dir);
 	d_instantiate(dentry, inode);
 out_stop:
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -1969,7 +1969,7 @@ int ext4_orphan_add(handle_t *handle, st
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_metadata(handle, inode, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2025,7 +2025,8 @@ int ext4_orphan_del(handle_t *handle, st
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (!handle)
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    !handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
@@ -2039,7 +2040,7 @@ int ext4_orphan_del(handle_t *handle, st
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_journal_dirty_metadata(handle, sbi->s_sbh);
+		err = ext4_handle_dirty_metadata(handle, inode, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =
@@ -2081,7 +2082,7 @@ static int ext4_rmdir (struct inode * di
 	 * separate transaction */
 	DQUOT_INIT(dentry->d_inode);
 	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
@@ -2089,7 +2090,7 @@ static int ext4_rmdir (struct inode * di
 	if (!bh)
 		goto end_rmdir;
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode = dentry->d_inode;
@@ -2123,7 +2124,7 @@ static int ext4_rmdir (struct inode * di
 	ext4_mark_inode_dirty(handle, dir);
 
 end_rmdir:
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	brelse (bh);
 	return retval;
 }
@@ -2140,10 +2141,10 @@ static int ext4_unlink(struct inode * di
 	 * in separate transaction */
 	DQUOT_INIT(dentry->d_inode);
 	handle = ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	retval = -ENOENT;
@@ -2177,7 +2178,7 @@ static int ext4_unlink(struct inode * di
 	retval = 0;
 
 end_unlink:
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	brelse (bh);
 	return retval;
 }
@@ -2197,10 +2198,10 @@ retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
 					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode = ext4_new_inode (handle, dir, S_IFLNK|S_IRWXUGO);
@@ -2234,7 +2235,7 @@ retry:
 	EXT4_I(inode)->i_disksize = inode->i_size;
 	err = ext4_add_nondir(handle, dentry, inode);
 out_stop:
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -2260,10 +2261,10 @@ static int ext4_link (struct dentry * ol
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(dir))
+	if (handle && IS_DIRSYNC(dir))
 		handle->h_sync = 1;
 
 	inode->i_ctime = ext4_current_time(inode);
@@ -2271,7 +2272,7 @@ retry:
 	atomic_inc(&inode->i_count);
 
 	err = ext4_add_nondir(handle, dentry, inode);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(dir->i_sb, handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
 	return err;
@@ -2302,10 +2303,10 @@ static int ext4_rename (struct inode * o
 	handle = ext4_journal_start(old_dir, 2 *
 					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
+	if (handle && (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir)))
 		handle->h_sync = 1;
 
 	old_bh = ext4_find_entry (old_dentry, &old_de);
@@ -2360,8 +2361,8 @@ static int ext4_rename (struct inode * o
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
@@ -2411,8 +2412,8 @@ static int ext4_rename (struct inode * o
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
@@ -2436,7 +2437,7 @@ end_rename:
 	brelse (dir_bh);
 	brelse (old_bh);
 	brelse (new_bh);
-	ext4_journal_stop(handle);
+	ext4_journal_stop(old_dir->i_sb, handle);
 	return retval;
 }
 
diff -up -r linux-2.6.26.y/fs/ext4/resize.c foo/fs/ext4/resize.c
--- linux-2.6.26.y/fs/ext4/resize.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/resize.c	2008-10-30 12:56:08.000000000 -0700
@@ -149,7 +149,7 @@ static int extend_or_restart_transaction
 {
 	int err;
 
-	if (handle->h_buffer_credits >= thresh)
+	if (!handle || handle->h_buffer_credits >= thresh)
 		return 0;
 
 	err = ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA);
@@ -190,7 +190,7 @@ static int setup_new_group_blocks(struct
 	/* This transaction may be extended/restarted along the way */
 	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
 
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 
 	lock_super(sb);
@@ -232,7 +232,7 @@ static int setup_new_group_blocks(struct
 		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
 		unlock_buffer(gdb);
-		ext4_journal_dirty_metadata(handle, gdb);
+		ext4_handle_dirty_metadata(handle, NULL, gdb);
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
@@ -251,7 +251,7 @@ static int setup_new_group_blocks(struct
 			err = PTR_ERR(bh);
 			goto exit_bh;
 		}
-		ext4_journal_dirty_metadata(handle, gdb);
+		ext4_handle_dirty_metadata(handle, NULL, gdb);
 		ext4_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
@@ -276,7 +276,7 @@ static int setup_new_group_blocks(struct
 			err = PTR_ERR(it);
 			goto exit_bh;
 		}
-		ext4_journal_dirty_metadata(handle, it);
+		ext4_handle_dirty_metadata(handle, NULL, it);
 		brelse(it);
 		ext4_set_bit(bit, bh->b_data);
 	}
@@ -286,7 +286,7 @@ static int setup_new_group_blocks(struct
 
 	mark_bitmap_end(input->blocks_count, EXT4_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
-	ext4_journal_dirty_metadata(handle, bh);
+	ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 
 	/* Mark unused entries in inode bitmap used */
@@ -299,13 +299,13 @@ static int setup_new_group_blocks(struct
 
 	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
 			bh->b_data);
-	ext4_journal_dirty_metadata(handle, bh);
+	ext4_handle_dirty_metadata(handle, NULL, bh);
 exit_bh:
 	brelse(bh);
 
 exit_journal:
 	unlock_super(sb);
-	if ((err2 = ext4_journal_stop(handle)) && !err)
+	if ((err2 = ext4_journal_stop(sb, handle)) && !err)
 		err = err2;
 
 	return err;
@@ -486,12 +486,12 @@ static int add_new_gdb(handle_t *handle,
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
@@ -502,7 +502,7 @@ static int add_new_gdb(handle_t *handle,
 	kfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
-	ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 
 	return 0;
 
@@ -618,7 +618,7 @@ static int reserve_backup_gdb(handle_t *
 		       primary[i]->b_blocknr, gdbackups,
 		       blk + primary[i]->b_blocknr); */
 		data[gdbackups] = cpu_to_le32(blk + primary[i]->b_blocknr);
-		err2 = ext4_journal_dirty_metadata(handle, primary[i]);
+		err2 = ext4_handle_dirty_metadata(handle, NULL, primary[i]);
 		if (!err)
 			err = err2;
 	}
@@ -666,7 +666,7 @@ static void update_backups(struct super_
 	int err = 0, err2;
 
 	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		group = 1;
 		err = PTR_ERR(handle);
 		goto exit_err;
@@ -676,7 +676,7 @@ static void update_backups(struct super_
 		struct buffer_head *bh;
 
 		/* Out of journal space, and can't get more - abort - so sad */
-		if (handle->h_buffer_credits == 0 &&
+		if (handle && handle->h_buffer_credits == 0 &&
 		    ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA) &&
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
@@ -696,10 +696,10 @@ static void update_backups(struct super_
 			memset(bh->b_data + size, 0, rest);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		ext4_journal_dirty_metadata(handle, bh);
+		ext4_handle_dirty_metadata(handle, NULL, bh);
 		brelse(bh);
 	}
-	if ((err2 = ext4_journal_stop(handle)) && !err)
+	if ((err2 = ext4_journal_stop(sb, handle)) && !err)
 		err = err2;
 
 	/*
@@ -802,7 +802,7 @@ int ext4_group_add(struct super_block *s
 	handle = ext4_journal_start_sb(sb,
 				       ext4_bg_has_super(sb, input->group) ?
 				       3 + reserved_gdb : 4);
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		goto exit_put;
 	}
@@ -915,7 +915,7 @@ int ext4_group_add(struct super_block *s
 	/* Update the global fs size fields */
 	sbi->s_groups_count++;
 
-	ext4_journal_dirty_metadata(handle, primary);
+	ext4_handle_dirty_metadata(handle, NULL, primary);
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
@@ -928,12 +928,12 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
-	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	sb->s_dirt = 1;
 
 exit_journal:
 	unlock_super(sb);
-	if ((err2 = ext4_journal_stop(handle)) && !err)
+	if ((err2 = ext4_journal_stop(sb, handle)) && !err)
 		err = err2;
 	if (!err) {
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
@@ -1037,7 +1037,7 @@ int ext4_group_extend(struct super_block
 	 * one group descriptor via ext4_free_blocks().
 	 */
 	handle = ext4_journal_start_sb(sb, 3);
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		ext4_warning(sb, __func__, "error %d on journal start", err);
 		goto exit_put;
@@ -1048,7 +1048,7 @@ int ext4_group_extend(struct super_block
 		ext4_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
-		ext4_journal_stop(handle);
+		ext4_journal_stop(sb, handle);
 		err = -EBUSY;
 		goto exit_put;
 	}
@@ -1058,11 +1058,11 @@ int ext4_group_extend(struct super_block
 		ext4_warning(sb, __func__,
 			     "error %d on journal write access", err);
 		unlock_super(sb);
-		ext4_journal_stop(handle);
+		ext4_journal_stop(sb, handle);
 		goto exit_put;
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
-	ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	sb->s_dirt = 1;
 	unlock_super(sb);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
@@ -1070,7 +1070,7 @@ int ext4_group_extend(struct super_block
 	ext4_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
 	ext4_debug("freed blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
-	if ((err = ext4_journal_stop(handle)))
+	if ((err = ext4_journal_stop(sb, handle)))
 		goto exit_put;
 
 	/*
diff -up -r linux-2.6.26.y/fs/ext4/super.c foo/fs/ext4/super.c
--- linux-2.6.26.y/fs/ext4/super.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/super.c	2008-10-30 12:57:16.000000000 -0700
@@ -132,13 +132,17 @@ handle_t *ext4_journal_start_sb(struct s
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
 
-	return jbd2_journal_start(journal, nblocks);
+	BUG_ON(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+	return NULL;
 }
 
 /*
@@ -147,13 +151,17 @@ handle_t *ext4_journal_start_sb(struct s
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
  */
-int __ext4_journal_stop(const char *where, handle_t *handle)
+int __ext4_journal_stop(const char *where, struct super_block *sb, handle_t *handle)
 {
-	struct super_block *sb;
 	int err;
 	int rc;
 
-	sb = handle->h_transaction->t_journal->j_private;
+	if (!handle ||
+	    !(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)))
+		return 0;
+
+	BUG_ON(sb != handle->h_transaction->t_journal->j_private);
+
 	err = handle->h_err;
 	rc = jbd2_journal_stop(handle);
 
@@ -170,6 +178,8 @@ void ext4_journal_abort_handle(const cha
 	char nbuf[16];
 	const char *errstr = ext4_decode_error(NULL, err, nbuf);
 
+	BUG_ON(handle == NULL);
+
 	if (bh)
 		BUFFER_TRACE(bh, "abort");
 
@@ -214,8 +224,10 @@ static void ext4_handle_error(struct sup
 		journal_t *journal = EXT4_SB(sb)->s_journal;
 
 		EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
-		if (journal)
+		if (journal) {
+			BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
 			jbd2_journal_abort(journal, -EIO);
+		}
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		printk(KERN_CRIT "Remounting filesystem read-only\n");
@@ -329,7 +341,8 @@ void ext4_abort(struct super_block *sb, 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
-	jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 }
 
 void ext4_warning(struct super_block *sb, const char *function,
@@ -381,10 +394,11 @@ int ext4_update_compat_feature(handle_t 
 			return err;
 		EXT4_SET_COMPAT_FEATURE(sb, compat);
 		sb->s_dirt = 1;
-		handle->h_sync = 1;
+		if (handle)
+			handle->h_sync = 1;
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
-					"call ext4_journal_dirty_met adata");
-		err = ext4_journal_dirty_metadata(handle,
+					"call ext4_handle_dirty_met adata");
+		err = ext4_handle_dirty_metadata(handle, NULL,
 				EXT4_SB(sb)->s_sbh);
 	}
 	return err;
@@ -401,10 +415,11 @@ int ext4_update_rocompat_feature(handle_
 			return err;
 		EXT4_SET_RO_COMPAT_FEATURE(sb, rocompat);
 		sb->s_dirt = 1;
-		handle->h_sync = 1;
+		if (handle)
+			handle->h_sync = 1;
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
-					"call ext4_journal_dirty_met adata");
-		err = ext4_journal_dirty_metadata(handle,
+					"call ext4_handle_dirty_met adata");
+		err = ext4_handle_dirty_metadata(handle, NULL,
 				EXT4_SB(sb)->s_sbh);
 	}
 	return err;
@@ -421,10 +436,11 @@ int ext4_update_incompat_feature(handle_
 			return err;
 		EXT4_SET_INCOMPAT_FEATURE(sb, incompat);
 		sb->s_dirt = 1;
-		handle->h_sync = 1;
+		if (handle)
+			handle->h_sync = 1;
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh,
-					"call ext4_journal_dirty_met adata");
-		err = ext4_journal_dirty_metadata(handle,
+					"call ext4_handle_dirty_met adata");
+		err = ext4_handle_dirty_metadata(handle, NULL,
 				EXT4_SB(sb)->s_sbh);
 	}
 	return err;
@@ -503,8 +519,13 @@ static void ext4_put_super(struct super_
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		BUG_ON(sbi->s_journal == NULL);
+		jbd2_journal_destroy(sbi->s_journal);
+		sbi->s_journal = NULL;
+	} else {
+		BUG_ON(sbi->s_journal != NULL);
+	}
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -571,7 +592,8 @@ static struct inode *ext4_alloc_inode(st
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
@@ -641,8 +663,10 @@ static void ext4_clear_inode(struct inod
 	EXT4_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
-	jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
+	if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
 				       &EXT4_I(inode)->jinode);
+	}
 }
 
 static inline void ext4_show_quota_options(struct seq_file *seq,
@@ -1473,13 +1497,15 @@ static int ext4_setup_super(struct super
 			sbi->s_mount_opt);
 
 	printk(KERN_INFO "EXT4 FS on %s, ", sb->s_id);
-	if (EXT4_SB(sb)->s_journal->j_inode == NULL) {
-		char b[BDEVNAME_SIZE];
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		if (EXT4_SB(sb)->s_journal->j_inode == NULL) {
+			char b[BDEVNAME_SIZE];
 
-		printk("external journal on %s\n",
-			bdevname(EXT4_SB(sb)->s_journal->j_dev, b));
-	} else {
-		printk("internal journal\n");
+			printk("external journal on %s\n",
+				bdevname(EXT4_SB(sb)->s_journal->j_dev, b));
+		} else {
+			printk("internal journal\n");
+		}
 	}
 	return res;
 }
@@ -2044,9 +2070,12 @@ static int ext4_fill_super(struct super_
 	 * that the TEST_FILESYS flag in s->flags be set.
 	 */
 	if (!(le32_to_cpu(es->s_flags) & EXT2_FLAGS_TEST_FILESYS)) {
-		printk(KERN_WARNING "EXT4-fs: %s: not marked "
-		       "OK to use with test code.\n", sb->s_id);
-		goto failed_mount;
+		/* As a temp hack, don't give up when there is no journal */
+		if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+			printk(KERN_WARNING "EXT4-fs: %s: not marked "
+			       "OK to use with test code.\n", sb->s_id);
+			goto failed_mount;
+		}
 	}
 
 	/*
@@ -2333,7 +2362,12 @@ static int ext4_fill_super(struct super_
 			printk(KERN_ERR
 			       "ext4: No journal on filesystem on %s\n",
 			       sb->s_id);
-		goto failed_mount3;
+
+		// ISSUE: do we need to do anything else here?
+		clear_opt(sbi->s_mount_opt, DATA_FLAGS);
+		  set_opt(sbi->s_mount_opt, WRITEBACK_DATA);
+		sbi->s_journal = NULL;
+		goto no_journal;
 	}
 
 	if (ext4_blocks_count(es) > 0xffffffffULL &&
@@ -2385,6 +2419,8 @@ static int ext4_fill_super(struct super_
 		break;
 	}
 
+no_journal:
+
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
 			printk(KERN_WARNING "EXT4-fs: Ignoring nobh option - "
@@ -2457,10 +2493,12 @@ static int ext4_fill_super(struct super_
 	if (needs_recovery)
 		printk(KERN_INFO "EXT4-fs: recovery complete.\n");
 	ext4_mark_recovery_complete(sb, es);
-	printk(KERN_INFO "EXT4-fs: mounted filesystem with %s data mode.\n",
-	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ? "journal":
-	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
-	       "writeback");
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		printk(KERN_INFO "EXT4-fs: mounted filesystem with %s data mode.\n",
+		       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ? "journal":
+		       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
+		       "writeback");
+	}
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
@@ -2470,7 +2508,8 @@ static int ext4_fill_super(struct super_
 		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
 
 	ext4_ext_init(sb);
-	ext4_mb_init(sb, needs_recovery);
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		ext4_mb_init(sb, needs_recovery);
 
 	lock_kernel();
 	return 0;
@@ -2482,8 +2521,12 @@ cantfind_ext4:
 	goto failed_mount;
 
 failed_mount4:
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		jbd2_journal_destroy(sbi->s_journal);
+		sbi->s_journal = NULL;
+	} else {
+		BUG_ON(sbi->s_journal != NULL);
+	}
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -2515,6 +2558,8 @@ static void ext4_init_journal_params(str
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	if (sbi->s_commit_interval)
 		journal->j_commit_interval = sbi->s_commit_interval;
 	/* We could also set up an ext4-specific default for the commit
@@ -2535,6 +2580,8 @@ static journal_t *ext4_get_journal(struc
 	struct inode *journal_inode;
 	journal_t *journal;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	/* First, test for the existence of a valid inode on disk.  Bad
 	 * things happen if we iget() an unused inode, as the subsequent
 	 * iput() will try to delete it. */
@@ -2583,6 +2630,8 @@ static journal_t *ext4_get_dev_journal(s
 	struct ext4_super_block *es;
 	struct block_device *bdev;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	bdev = ext4_blkdev_get(j_dev);
 	if (bdev == NULL)
 		return NULL;
@@ -2670,6 +2719,8 @@ static int ext4_load_journal(struct supe
 	int err = 0;
 	int really_read_only;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
 		printk(KERN_INFO "EXT4-fs: external journal device major/minor "
@@ -2756,6 +2807,8 @@ static int ext4_create_journal(struct su
 	journal_t *journal;
 	int err;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
 				"create journal.\n");
@@ -2778,15 +2831,17 @@ static int ext4_create_journal(struct su
 
 	EXT4_SB(sb)->s_journal = journal;
 
-	ext4_update_dynamic_rev(sb);
-	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-	EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL);
+	if (journal_inum != 0) {
+		ext4_update_dynamic_rev(sb);
+		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL);
 
-	es->s_journal_inum = cpu_to_le32(journal_inum);
-	sb->s_dirt = 1;
+		es->s_journal_inum = cpu_to_le32(journal_inum);
+		sb->s_dirt = 1;
 
-	/* Make sure we flush the recovery flag to disk. */
-	ext4_commit_super(sb, es, 1);
+		/* Make sure we flush the recovery flag to disk. */
+		ext4_commit_super(sb, es, 1);
+	}
 
 	return 0;
 }
@@ -2818,6 +2873,11 @@ static void ext4_mark_recovery_complete(
 {
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
+		BUG_ON(journal != NULL);
+		return;
+	}
+
 	jbd2_journal_lock_updates(journal);
 	jbd2_journal_flush(journal);
 	lock_super(sb);
@@ -2843,6 +2903,8 @@ static void ext4_clear_journal_err(struc
 	int j_errno;
 	const char *errstr;
 
+	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+
 	journal = EXT4_SB(sb)->s_journal;
 
 	/*
@@ -2875,14 +2937,17 @@ static void ext4_clear_journal_err(struc
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
 
@@ -2897,19 +2962,27 @@ int ext4_force_commit(struct super_block
 
 static void ext4_write_super(struct super_block *sb)
 {
-	if (mutex_trylock(&sb->s_lock) != 0)
-		BUG();
-	sb->s_dirt = 0;
+	if(EXT4_SB(sb)->s_journal) {
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
@@ -2925,9 +2998,13 @@ static void ext4_write_super_lockfs(stru
 	if (!(sb->s_flags & MS_RDONLY)) {
 		journal_t *journal = EXT4_SB(sb)->s_journal;
 
-		/* Now we set up the journal barrier. */
-		jbd2_journal_lock_updates(journal);
-		jbd2_journal_flush(journal);
+		if (journal) {
+			/* Now we set up the journal barrier. */
+			jbd2_journal_lock_updates(journal);
+			jbd2_journal_flush(journal);
+		} else {
+			BUG_ON(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
+		}
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -2947,7 +3024,10 @@ static void ext4_unlockfs(struct super_b
 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 		unlock_super(sb);
-		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (EXT4_SB(sb)->s_journal)
+			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		else
+			BUG_ON(EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
 	}
 }
 
@@ -2992,7 +3072,8 @@ static int ext4_remount(struct super_blo
 
 	es = sbi->s_es;
 
-	ext4_init_journal_params(sb, sbi->s_journal);
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		ext4_init_journal_params(sb, sbi->s_journal);
 
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY) ||
 		n_blocks_count > ext4_blocks_count(es)) {
@@ -3077,7 +3158,8 @@ static int ext4_remount(struct super_blo
 			 * been changed by e2fsck since we originally mounted
 			 * the partition.)
 			 */
-			ext4_clear_journal_err(sb, es);
+			if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+				ext4_clear_journal_err(sb, es);
 			sbi->s_mount_state = le16_to_cpu(es->s_state);
 			if ((err = ext4_group_extend(sb, es, n_blocks_count)))
 				goto restore_opts;
@@ -3085,6 +3167,9 @@ static int ext4_remount(struct super_blo
 				sb->s_flags &= ~MS_RDONLY;
 		}
 	}
+	if (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+		ext4_commit_super(sb, es, 1);
+
 #ifdef CONFIG_QUOTA
 	/* Release old quota file names */
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -3201,10 +3286,10 @@ static int ext4_dquot_initialize(struct 
 
 	/* We may create quota structure so we need to reserve enough blocks */
 	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_INIT_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_initialize(inode, type);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3217,7 +3302,7 @@ static int ext4_dquot_drop(struct inode 
 
 	/* We may delete quota structure so we need to reserve enough blocks */
 	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		/*
 		 * We call dquot_drop() anyway to at least release references
 		 * to quota structures so that umount does not hang.
@@ -3226,7 +3311,7 @@ static int ext4_dquot_drop(struct inode 
 		return PTR_ERR(handle);
 	}
 	ret = dquot_drop(inode);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3241,10 +3326,10 @@ static int ext4_write_dquot(struct dquot
 	inode = dquot_to_inode(dquot);
 	handle = ext4_journal_start(inode,
 					EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit(dquot);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3254,13 +3339,14 @@ static int ext4_acquire_dquot(struct dqu
 {
 	int ret, err;
 	handle_t *handle;
+	struct inode *inode = dquot_to_inode(dquot);
 
-	handle = ext4_journal_start(dquot_to_inode(dquot),
+	handle = ext4_journal_start(inode,
 					EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_acquire(dquot);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3270,16 +3356,17 @@ static int ext4_release_dquot(struct dqu
 {
 	int ret, err;
 	handle_t *handle;
+	struct inode *inode = dquot_to_inode(dquot);
 
-	handle = ext4_journal_start(dquot_to_inode(dquot),
+	handle = ext4_journal_start(inode,
 					EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
 		return PTR_ERR(handle);
 	}
 	ret = dquot_release(dquot);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(inode->i_sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3304,10 +3391,10 @@ static int ext4_write_info(struct super_
 
 	/* Data block + inode block */
 	handle = ext4_journal_start(sb->s_root->d_inode, 2);
-	if (IS_ERR(handle))
+	if (handle && IS_ERR(handle))
 		return PTR_ERR(handle);
 	ret = dquot_commit_info(sb, type);
-	err = ext4_journal_stop(handle);
+	err = ext4_journal_stop(sb, handle);
 	if (!ret)
 		ret = err;
 	return ret;
@@ -3360,7 +3447,8 @@ static int ext4_quota_on(struct super_bl
 	 * When we journal data on quota file, we have to flush journal to see
 	 * all updates to the file when we bypass pagecache...
 	 */
-	if (ext4_should_journal_data(nd.path.dentry->d_inode)) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    ext4_should_journal_data(nd.path.dentry->d_inode)) {
 		/*
 		 * We don't need to lock updates but journal_flush() could
 		 * otherwise be livelocked...
@@ -3429,7 +3517,8 @@ static ssize_t ext4_quota_write(struct s
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
 
-	if (!handle) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    !handle) {
 		printk(KERN_WARNING "EXT4-fs: Quota write (off=%Lu, len=%Lu)"
 			" cancelled because transaction is not started.\n",
 			(unsigned long long)off, (unsigned long long)len);
@@ -3454,7 +3543,7 @@ static ssize_t ext4_quota_write(struct s
 		flush_dcache_page(bh->b_page);
 		unlock_buffer(bh);
 		if (journal_quota)
-			err = ext4_journal_dirty_metadata(handle, bh);
+			err = ext4_handle_dirty_metadata(handle, NULL, bh);
 		else {
 			/* Always do at least ordered writes for quotas */
 			err = ext4_jbd2_file_inode(handle, inode);
diff -up -r linux-2.6.26.y/fs/ext4/xattr.c foo/fs/ext4/xattr.c
--- linux-2.6.26.y/fs/ext4/xattr.c	2008-10-30 12:07:20.000000000 -0700
+++ foo/fs/ext4/xattr.c	2008-10-30 12:56:08.000000000 -0700
@@ -457,7 +457,7 @@ static void ext4_xattr_update_super_bloc
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
 		sb->s_dirt = 1;
-		ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
+		ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	}
 }
 
@@ -487,8 +487,8 @@ ext4_xattr_release_block(handle_t *handl
 		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
-		error = ext4_journal_dirty_metadata(handle, bh);
-		if (IS_SYNC(inode))
+		error = ext4_handle_dirty_metadata(handle, inode, bh);
+		if (handle && IS_SYNC(inode))
 			handle->h_sync = 1;
 		DQUOT_FREE_BLOCK(inode, 1);
 		ea_bdebug(bh, "refcount now=%d; releasing",
@@ -724,8 +724,9 @@ ext4_xattr_block_set(handle_t *handle, s
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
@@ -794,8 +795,9 @@ inserted:
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
@@ -833,7 +835,8 @@ getblk_failed:
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(new_bh);
-			error = ext4_journal_dirty_metadata(handle, new_bh);
+			error = ext4_handle_dirty_metadata(handle,
+							   inode, new_bh);
 			if (error)
 				goto cleanup;
 		}
@@ -1035,7 +1038,7 @@ ext4_xattr_set_handle(handle_t *handle, 
 		 * error != 0.
 		 */
 		is.iloc.bh = NULL;
-		if (IS_SYNC(inode))
+		if (handle && IS_SYNC(inode))
 			handle->h_sync = 1;
 	}
 
@@ -1063,7 +1066,7 @@ ext4_xattr_set(struct inode *inode, int 
 
 retry:
 	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle)) {
+	if (handle && IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
 		int error2;

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

