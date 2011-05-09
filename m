From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 06/30] ext4: snapshot hooks - move data blocks
Date: Mon,  9 May 2011 19:41:24 +0300
Message-ID: <1304959308-11122-7-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59790 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1EIQnJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:09 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5954969wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:08 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Before every regular file data buffer write, the function
ext4_get_block() is called to map the buffer to disk. We add a
new function ext4_get_block_mow() which is called when we want to
snapshot the blocks. We use this hook to call the snapshot API
snapshot_get_move_access(), to optionally move the block
to the snapshot file.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h      |   15 +++-
 fs/ext4/ext4_jbd2.h |   17 ++++
 fs/ext4/inode.c     |  242 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/mballoc.c   |   23 +++++
 4 files changed, 280 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e9e46a..013eec2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -156,9 +156,10 @@ struct ext4_allocation_request {
 #define EXT4_MAP_UNWRITTEN	(1 << BH_Unwritten)
 #define EXT4_MAP_BOUNDARY	(1 << BH_Boundary)
 #define EXT4_MAP_UNINIT		(1 << BH_Uninit)
+#define EXT4_MAP_REMAP		(1 << BH_Remap)
 #define EXT4_MAP_FLAGS		(EXT4_MAP_NEW | EXT4_MAP_MAPPED |\
 				 EXT4_MAP_UNWRITTEN | EXT4_MAP_BOUNDARY |\
-				 EXT4_MAP_UNINIT)
+				 EXT4_MAP_UNINIT | EXT4_MAP_REMAP)
 
 struct ext4_map_blocks {
 	ext4_fsblk_t m_pblk;
@@ -525,6 +526,12 @@ struct ext4_new_group_data {
 	/* Convert extent to initialized after IO complete */
 #define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
+	/* Look up if mapped block is used by snapshot,
+	 * if so and EXT4_GET_BLOCKS_CREATE is set, move it to snapshot
+	 * and allocate a new block for new data.
+	 * if EXT4_GET_BLOCKS_CREATE is not set, return REMAP flags.
+	 */
+#define EXT4_GET_BLOCKS_MOVE_ON_WRITE		0x0100
 
 /*
  * Flags used by ext4_free_blocks
@@ -2128,10 +2135,16 @@ extern int ext4_bio_write_page(struct ext4_io_submit *io,
 enum ext4_state_bits {
 	BH_Uninit	/* blocks are allocated but uninitialized on disk */
 	  = BH_JBDPrivateStart,
+	BH_Remap,	/* Data block need to be remapped,
+			 * now used by snapshot to do mow
+			 */
+	BH_Partial_Write,	/* Buffer should be uptodate before write */
 };
 
 BUFFER_FNS(Uninit, uninit)
 TAS_BUFFER_FNS(Uninit, uninit)
+BUFFER_FNS(Remap, remap)
+BUFFER_FNS(Partial_Write, partial_write)
 
 /*
  * Add new method to test wether block and inode bitmaps are properly
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 707b810..1c119cc 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -360,5 +360,22 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 }
 
 #ifdef CONFIG_EXT4_FS_SNAPSHOT
+/*
+ * check if @inode data blocks should be moved-on-write
+ */
+static inline int ext4_snapshot_should_move_data(struct inode *inode)
+{
+	if (!EXT4_SNAPSHOTS(inode->i_sb))
+		return 0;
+	if (EXT4_JOURNAL(inode) == NULL)
+		return 0;
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return 0;
+	/* when a data block is journaled, it is already COWed as metadata */
+	if (ext4_should_journal_data(inode))
+		return 0;
+	return 1;
+}
+
 #endif
 #endif	/* _EXT4_JBD2_H */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b848072..3ed64bb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -78,7 +78,8 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
 static int __ext4_journalled_writepage(struct page *page, unsigned int len);
-static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
+static int ext4_bh_delay_or_unwritten_or_remap(handle_t *handle,
+		struct buffer_head *bh);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -987,6 +988,51 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 
 	partial = ext4_get_branch(inode, depth, offsets, chain, &err);
 
+	err = 0;
+	if (!partial && (flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE)) {
+		BUG_ON(!ext4_snapshot_should_move_data(inode));
+		first_block = le32_to_cpu(chain[depth - 1].key);
+		if (!(flags & EXT4_GET_BLOCKS_CREATE)) {
+			/*
+			 * First call from ext4_map_blocks():
+			 * test if first_block should be moved to snapshot?
+			 */
+			err = ext4_snapshot_get_move_access(handle, inode,
+							    first_block,
+							    &map->m_len, 0);
+			if (err < 0) {
+				/* cleanup the whole chain and exit */
+				partial = chain + depth - 1;
+				goto cleanup;
+			}
+			if (err > 0) {
+				/*
+				 * Return EXT4_MAP_REMAP via map->m_flags
+				 * to tell ext4_map_blocks() that the
+				 * found block should be moved to snapshot.
+				 */
+				map->m_flags |= EXT4_MAP_REMAP;
+			}
+			/*
+			 * Set max. blocks to map to max. blocks, which
+			 * ext4_snapshot_get_move_access() allows us to handle
+			 * (move or not move) in one ext4_map_blocks() call.
+			 */
+			err = 0;
+		} else if (map->m_flags & EXT4_MAP_REMAP &&
+				map->m_pblk == first_block) {
+			/*
+			 * Second call from ext4_map_blocks():
+			 * If mapped block hasn't change, we can rely the
+			 * cached result from the first call.
+			 */
+			err = 1;
+		}
+	}
+	if (err)
+		/* do not map found block - it should be moved to snapshot */
+		partial = chain + depth - 1;
+
 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
 		first_block = le32_to_cpu(chain[depth - 1].key);
@@ -1021,8 +1067,12 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	 * Next look up the indirect map to count the totoal number of
 	 * direct blocks to allocate for this branch.
 	 */
-	count = ext4_blks_to_allocate(partial, indirect_blks,
-				      map->m_len, blocks_to_boundary);
+	if (map->m_flags & EXT4_MAP_REMAP) {
+		BUG_ON(indirect_blks != 0);
+		count = map->m_len;
+	} else
+		count = ext4_blks_to_allocate(partial, indirect_blks,
+					      map->m_len, blocks_to_boundary);
 	/*
 	 * Block out ext4_truncate while we alter the tree
 	 */
@@ -1030,6 +1080,23 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				&count, goal,
 				offsets + (partial - chain), partial);
 
+	if (map->m_flags & EXT4_MAP_REMAP) {
+		map->m_len = count;
+		/* move old block to snapshot */
+		err = ext4_snapshot_get_move_access(handle, inode,
+						    le32_to_cpu(*(partial->p)),
+						    &map->m_len, 1);
+		if (err <= 0) {
+			/* failed to move to snapshot - abort! */
+			err = err ? : -EIO;
+			ext4_journal_abort_handle(__func__, __LINE__,
+					"ext4_snapshot_get_move_access", NULL,
+					handle, err);
+			goto cleanup;
+		}
+		/* block moved to snapshot - continue to splice new block */
+		err = 0;
+	}
 	/*
 	 * The ext4_splice_branch call will free and forget any buffers
 	 * on the new chain if there is a failure, but that risks using
@@ -1045,7 +1112,8 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 
 	map->m_flags |= EXT4_MAP_NEW;
 
-	ext4_update_inode_fsync_trans(handle, inode, 1);
+	if (!IS_COWING(handle))
+		ext4_update_inode_fsync_trans(handle, inode, 1);
 got_it:
 	map->m_flags |= EXT4_MAP_MAPPED;
 	map->m_pblk = le32_to_cpu(chain[depth-1].key);
@@ -1291,7 +1359,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map, 0);
 	} else {
-		retval = ext4_ind_map_blocks(handle, inode, map, 0);
+		retval = ext4_ind_map_blocks(handle, inode, map,
+				flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -1312,7 +1381,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * ext4_ext_get_block() returns th create = 0
 	 * with buffer head unmapped.
 	 */
-	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
+	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED &&
+		!(map->m_flags & EXT4_MAP_REMAP))
 		return retval;
 
 	/*
@@ -1375,6 +1445,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		ext4_clear_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED);
 
 	up_write((&EXT4_I(inode)->i_data_sem));
+	/* Clear EXT4_MAP_REMAP, it is not needed any more. */
+	map->m_flags &= ~EXT4_MAP_REMAP;
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
 		int ret = check_block_validity(inode, map);
 		if (ret != 0)
@@ -1383,6 +1455,41 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	return retval;
 }
 
+/*
+ * Block may need to be moved to snapshot and we need to writeback part of the
+ * existing block data to the new block, so make sure the buffer and page are
+ * uptodate before moving the existing block to snapshot.
+ */
+static int ext4_partial_write_begin(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh)
+{
+	struct ext4_map_blocks map;
+	int ret;
+
+	BUG_ON(!buffer_partial_write(bh));
+	BUG_ON(!bh->b_page || !PageLocked(bh->b_page));
+	map.m_lblk = iblock;
+	map.m_len = 1;
+
+	ret = ext4_map_blocks(NULL, inode, &map, 0);
+	if (ret <= 0)
+		return ret;
+
+	if (!buffer_uptodate(bh) && !buffer_unwritten(bh)) {
+		/* map existing block for read */
+		map_bh(bh, inode->i_sb, map.m_pblk);
+		ll_rw_block(READ, 1, &bh);
+		wait_on_buffer(bh);
+		/* clear existing block mapping */
+		clear_buffer_mapped(bh);
+		if (!buffer_uptodate(bh))
+			return -EIO;
+	}
+	/* prevent zero out of page with BH_New flag in block_write_begin() */
+	SetPageUptodate(bh->b_page);
+	return 0;
+}
+
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
 
@@ -1405,11 +1512,18 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 		handle = ext4_journal_start(inode, dio_credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-			return ret;
+			goto out;
 		}
 		started = 1;
 	}
 
+	if ((flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE) &&
+	     buffer_partial_write(bh)) {
+		/* Read existing block data before moving it to snapshot */
+		ret = ext4_partial_write_begin(inode, iblock, bh);
+		if (ret < 0)
+			goto out;
+	}
 	ret = ext4_map_blocks(handle, inode, &map, flags);
 	if (ret > 0) {
 		map_bh(bh, inode->i_sb, map.m_pblk);
@@ -1417,11 +1531,30 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
 		ret = 0;
 	}
+out:
 	if (started)
 		ext4_journal_stop(handle);
+	/*
+	 * BH_Partial_Write flags are only used to pass
+	 * hints to this function and should be cleared on exit.
+	 */
+	clear_buffer_partial_write(bh);
 	return ret;
 }
 
+/*
+ * ext4_get_block_mow is used when a block may be needed to be snapshotted.
+ */
+int ext4_get_block_mow(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh, int create)
+{
+	int flags = create ? EXT4_GET_BLOCKS_CREATE : 0;
+
+	if (ext4_snapshot_should_move_data(inode))
+		flags |= EXT4_GET_BLOCKS_MOVE_ON_WRITE;
+	return _ext4_get_block(inode, iblock, bh, flags);
+}
+
 int ext4_get_block(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh, int create)
 {
@@ -1600,6 +1733,45 @@ static void ext4_truncate_failed_write(struct inode *inode)
 	ext4_truncate(inode);
 }
 
+/*
+ * Prepare for snapshot.
+ * Clear mapped flag of buffers,
+ * Set partial write flag of buffers in non-delayed-mow case.
+ */
+static void ext4_snapshot_write_begin(struct inode *inode,
+				struct page *page, unsigned len, int delay)
+{
+	struct buffer_head *bh = NULL;
+	/*
+	 * XXX: We can also check ext4_snapshot_has_active() here and we don't
+	 * need to unmap the buffers is there is no active snapshot, but the
+	 * result must be valid throughout the writepage() operation and to
+	 * guarantee this we have to know that the transaction is not restarted.
+	 * Can we count on that?
+	 */
+	if (!ext4_snapshot_should_move_data(inode))
+		return;
+
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, inode->i_sb->s_blocksize, 0);
+	/* snapshots only work when blocksize == pagesize */
+	bh = page_buffers(page);
+	/*
+	 * make sure that get_block() is called even if the buffer is
+	 * mapped, but not if it is already a part of any transaction.
+	 * in data=ordered,the only mode supported by ext4, all dirty
+	 * data buffers are flushed on snapshot take via freeze_fs()
+	 * API.
+	 */
+	if (!buffer_jbd(bh) && !buffer_delay(bh)) {
+		clear_buffer_mapped(bh);
+		/* explicitly request move-on-write */
+		if (!delay && len < PAGE_CACHE_SIZE)
+			/* read block before moving it to snapshot */
+			set_buffer_partial_write(bh);
+	}
+}
+
 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
@@ -1642,11 +1814,13 @@ retry:
 		goto out;
 	}
 	*pagep = page;
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		ext4_snapshot_write_begin(inode, page, len, 0);
 
 	if (ext4_should_dioread_nolock(inode))
 		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
 	else
-		ret = __block_write_begin(page, pos, len, ext4_get_block);
+		ret = __block_write_begin(page, pos, len, ext4_get_block_mow);
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
@@ -2114,6 +2288,10 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 						clear_buffer_delay(bh);
 						bh->b_blocknr = pblock;
 					}
+					if (buffer_remap(bh)) {
+						clear_buffer_remap(bh);
+						bh->b_blocknr = pblock;
+					}
 					if (buffer_unwritten(bh) ||
 					    buffer_mapped(bh))
 						BUG_ON(bh->b_blocknr != pblock);
@@ -2123,7 +2301,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 				}
 
 				/* skip page if block allocation undone */
-				if (buffer_delay(bh) || buffer_unwritten(bh))
+				if (buffer_delay(bh) || buffer_unwritten(bh) ||
+				    buffer_remap(bh))
 					skip_page = 1;
 				bh = bh->b_this_page;
 				block_start += bh->b_size;
@@ -2243,7 +2422,8 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	if ((mpd->b_size == 0) ||
 	    ((mpd->b_state  & (1 << BH_Mapped)) &&
 	     !(mpd->b_state & (1 << BH_Delay)) &&
-	     !(mpd->b_state & (1 << BH_Unwritten))))
+	     !(mpd->b_state & (1 << BH_Unwritten)) &&
+		 !(mpd->b_state & (1 << BH_Remap))))
 		goto submit_io;
 
 	handle = ext4_journal_current_handle();
@@ -2274,6 +2454,9 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
 	if (mpd->b_state & (1 << BH_Delay))
 		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
+	if (mpd->b_state & (1 << BH_Remap))
+		get_blocks_flags |= EXT4_GET_BLOCKS_MOVE_ON_WRITE |
+				EXT4_GET_BLOCKS_DELALLOC_RESERVE;
 
 	blks = ext4_map_blocks(handle, mpd->inode, &map, get_blocks_flags);
 	if (blks < 0) {
@@ -2357,7 +2540,7 @@ submit_io:
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
-		(1 << BH_Delay) | (1 << BH_Unwritten))
+		(1 << BH_Delay) | (1 << BH_Unwritten) | (1 << BH_Remap))
 
 /*
  * mpage_add_bh_to_extent - try to add one more block to extent of blocks
@@ -2434,9 +2617,11 @@ flush_it:
 	return;
 }
 
-static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
+static int ext4_bh_delay_or_unwritten_or_remap(handle_t *handle,
+		struct buffer_head *bh)
 {
-	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
+	return ((buffer_delay(bh) || buffer_unwritten(bh)) &&
+		buffer_dirty(bh)) || buffer_remap(bh);
 }
 
 /*
@@ -2456,6 +2641,8 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 {
 	struct ext4_map_blocks map;
 	int ret = 0;
+	handle_t *handle = ext4_journal_current_handle();
+	int flags = 0;
 	sector_t invalid_block = ~((sector_t) 0xffff);
 
 	if (invalid_block < ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es))
@@ -2467,12 +2654,15 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 	map.m_lblk = iblock;
 	map.m_len = 1;
 
+	if (ext4_snapshot_should_move_data(inode))
+		flags |= EXT4_GET_BLOCKS_MOVE_ON_WRITE;
+
 	/*
 	 * first, we need to know whether the block is allocated already
 	 * preallocated blocks are unmapped but should treated
 	 * the same as allocated blocks.
 	 */
-	ret = ext4_map_blocks(NULL, inode, &map, 0);
+	ret = ext4_map_blocks(handle, inode, &map, flags);
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
@@ -2492,6 +2682,11 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		return 0;
 	}
 
+	if (map.m_flags & EXT4_MAP_REMAP) {
+		ret = ext4_da_reserve_space(inode, iblock);
+		if (ret < 0)
+			return ret;
+	}
 	map_bh(bh, inode->i_sb, map.m_pblk);
 	bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
 
@@ -2659,7 +2854,7 @@ static int ext4_writepage(struct page *page,
 	}
 	page_bufs = page_buffers(page);
 	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-			      ext4_bh_delay_or_unwritten)) {
+			      ext4_bh_delay_or_unwritten_or_remap)) {
 		/*
 		 * We don't want to do block allocation, so redirty
 		 * the page and return.  We may reach here when we do
@@ -2840,7 +3035,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 					 * Otherwise we won't make progress
 					 * with the page in ext4_writepage
 					 */
-					if (ext4_bh_delay_or_unwritten(NULL, bh)) {
+					if (ext4_bh_delay_or_unwritten_or_remap(
+								NULL, bh)) {
 						mpage_add_bh_to_extent(mpd, logical,
 								       bh->b_size,
 								       bh->b_state);
@@ -3175,6 +3371,8 @@ retry:
 		goto out;
 	}
 	*pagep = page;
+	if (EXT4_SNAPSHOTS(inode->i_sb))
+		ext4_snapshot_write_begin(inode, page, len, 1);
 
 	ret = __block_write_begin(page, pos, len, ext4_da_get_block_prep);
 	if (ret < 0) {
@@ -4002,6 +4200,18 @@ int ext4_block_truncate_page(handle_t *handle,
 			goto unlock;
 	}
 
+	/* check if block needs to be moved to snapshot before zeroing */
+	if (ext4_snapshot_should_move_data(inode)) {
+		err = ext4_get_block_mow(inode, iblock, bh, 1);
+		if (err)
+			goto unlock;
+		if (buffer_new(bh)) {
+			unmap_underlying_metadata(bh->b_bdev,
+					bh->b_blocknr);
+			clear_buffer_new(bh);
+		}
+	}
+
 	if (ext4_should_journal_data(inode)) {
 		BUFFER_TRACE(bh, "get write access");
 		err = ext4_journal_get_write_access(handle, bh);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3b1c6d1..5eced75 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3174,6 +3174,29 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	struct ext4_prealloc_space *pa, *cpa = NULL;
 	ext4_fsblk_t goal_block;
 
+	/*
+	 * All inode preallocations allocated before the time when the
+	 * active snapshot is taken need to be discarded, otherwise blocks
+	 * maybe used by both a regular file and the snapshot file that we
+	 * are taking in the below case.
+	 *
+	 * Case: An user take a snapshot when an inode has a preallocation
+	 * 12/512, of which 12/64 has been used by the inode. Here 12 is the
+	 * logical block number. After the snapshot is taken, an user issues
+	 * a write request on the 12th block, then an allocation on 12 is
+	 * needed and allocator will use blocks from the preallocations.As
+	 * a result, the event above happens.
+	 *
+	 *
+	 * For now, all preallocations are discarded.
+	 *
+	 * Please refer to code and comments about preallocation in
+	 * mballoc.c for more information.
+	 */
+	if (ext4_snapshot_active(EXT4_SB(ac->ac_inode->i_sb)) &&
+	    !ext4_snapshot_mow_in_tid(ac->ac_inode)) {
+		ext4_discard_preallocations(ac->ac_inode);
+	}
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return 0;
-- 
1.7.0.4

