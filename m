From: amir73il@users.sourceforge.net
Subject: [PATCH v1 15/36] ext4: snapshot block operation - copy blocks to snapshot
Date: Tue,  7 Jun 2011 18:07:42 +0300
Message-ID: <1307459283-22130-16-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:37 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:36 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of copying blocks into a snapshot file.
This mechanism is used to copy-on-write metadata blocks to snapshot.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h     |    3 +
 fs/ext4/inode.c    |   40 +++++++-
 fs/ext4/mballoc.c  |   18 ++++
 fs/ext4/resize.c   |   10 ++-
 fs/ext4/snapshot.c |  269 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot.h |   12 ++-
 6 files changed, 346 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5564111..7d66f92 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -109,6 +109,8 @@ typedef unsigned int ext4_group_t;
 /* We are doing stream allocation */
 #define EXT4_MB_STREAM_ALLOC		0x0800
 
+/* allocate blocks for active snapshot */
+#define EXT4_MB_HINT_COWING		0x02000
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -1825,6 +1827,7 @@ extern void __ext4_free_blocks(const char *where, unsigned int line,
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
+extern int ext4_mb_test_bit_range(int bit, void *addr, int *pcount);
 
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 410bc8b..cdc1752 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -699,8 +699,17 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = target;
 	ar.logical = iblock;
-	if (S_ISREG(inode->i_mode))
-		/* enable in-core preallocation only for regular files */
+	if (IS_COWING(handle)) {
+		/*
+		 * This hint is used to tell the allocator not to fail
+		 * on quota limits and allow allocation from blocks which
+		 * are reserved for snapshots.
+		 * Failing allocation during COW operations would result
+		 * in I/O error, which is not desirable.
+		 */
+		ar.flags = EXT4_MB_HINT_COWING;
+	} else if (S_ISREG(inode->i_mode) && !ext4_snapshot_file(inode))
+		/* Enable preallocation only for non-snapshot regular files */
 		ar.flags = EXT4_MB_HINT_DATA;
 
 	current_block = ext4_mb_new_blocks(handle, &ar, err);
@@ -1362,6 +1371,21 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    struct ext4_map_blocks *map, int flags)
 {
 	int retval;
+	int cowing = 0;
+
+	if (handle && IS_COWING(handle)) {
+		/*
+		 * locking order for locks validator:
+		 * inode (VFS operation) -> active snapshot (COW operation)
+		 *
+		 * The i_data_sem lock is nested during COW operation, but
+		 * the active snapshot i_data_sem write lock is not taken
+		 * otherwise, because snapshot file has read-only aops and
+		 * because truncate/unlink of active snapshot is not permitted.
+		 */
+		BUG_ON(!ext4_snapshot_is_active(inode));
+		cowing = 1;
+	}
 
 	map->m_flags = 0;
 	ext_debug("ext4_map_blocks(): inode %lu, flag %d, max_blocks %u,"
@@ -1371,7 +1395,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.
 	 */
-	down_read((&EXT4_I(inode)->i_data_sem));
+	down_read_nested((&EXT4_I(inode)->i_data_sem), cowing);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		retval = ext4_ext_map_blocks(handle, inode, map,
 				flags & EXT4_GET_BLOCKS_MOVE_ON_WRITE);
@@ -1430,7 +1454,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 * the write lock of i_data_sem, and call get_blocks()
 	 * with create == 1 flag.
 	 */
-	down_write((&EXT4_I(inode)->i_data_sem));
+	down_write_nested((&EXT4_I(inode)->i_data_sem), cowing);
 
 	/*
 	 * if the caller is from delayed allocation writeout path
@@ -1621,6 +1645,14 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 		J_ASSERT(create != 0);
 		J_ASSERT(handle != NULL);
 
+		if (SNAPMAP_ISCOW(create)) {
+			/* COWing block or creating COW bitmap */
+			lock_buffer(bh);
+			clear_buffer_uptodate(bh);
+			/* flag locked buffer and return */
+			*errp = 1;
+			return bh;
+		}
 		/*
 		 * Now that we do not always journal data, we should
 		 * keep in mind whether this should always journal the
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4ff3079..6e4d960 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -420,6 +420,24 @@ static inline int mb_find_next_bit(void *addr, int max, int start)
 	return ret;
 }
 
+/*
+ * Find the largest range of set or clear bits.
+ * Return 1 for set bits and 0 for clear bits.
+ * Set *pcount to number of bits in range.
+ */
+int ext4_mb_test_bit_range(int bit, void *addr, int *pcount)
+{
+	int i, ret;
+
+	ret = mb_test_bit(bit, addr);
+	if (ret)
+		i = mb_find_next_zero_bit(addr, bit + *pcount, bit);
+	else
+		i = mb_find_next_bit(addr, bit + *pcount, bit);
+	*pcount = i - bit;
+	return ret ? 1 : 0;
+}
+
 static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
 {
 	char *bb;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ebff8a1..91f5473 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -673,7 +673,15 @@ static void update_backups(struct super_block *sb,
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
 
-		bh = sb_getblk(sb, group * bpg + blk_off);
+		if (ext4_snapshot_has_active(sb))
+			/*
+			 * test_and_cow() expects an uptodate buffer.
+			 * Read the buffer here to suppress the
+			 * "non uptodate buffer" warning.
+			 */
+			bh = sb_bread(sb, group * bpg + blk_off);
+		else
+			bh = sb_getblk(sb, group * bpg + blk_off);
 		if (!bh) {
 			err = -EIO;
 			break;
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index ef84551..fc91ca4 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -59,3 +59,272 @@ int ext4_snapshot_map_blocks(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+/*
+ * COW helper functions
+ */
+
+/*
+ * copy buffer @bh to (locked) snapshot buffer @sbh and mark it uptodate
+ */
+static inline void
+__ext4_snapshot_copy_buffer(struct buffer_head *sbh,
+		struct buffer_head *bh)
+{
+	memcpy(sbh->b_data, bh->b_data, SNAPSHOT_BLOCK_SIZE);
+	set_buffer_uptodate(sbh);
+}
+
+/*
+ * ext4_snapshot_complete_cow()
+ * Unlock a newly COWed snapshot buffer and complete the COW operation.
+ * Optionally, sync the buffer to disk or add it to the current transaction
+ * as dirty data.
+ */
+static inline int
+ext4_snapshot_complete_cow(handle_t *handle, struct inode *snapshot,
+		struct buffer_head *sbh, struct buffer_head *bh, int sync)
+{
+	int err = 0;
+
+	unlock_buffer(sbh);
+	err = ext4_jbd2_file_inode(handle, snapshot);
+	if (err)
+		goto out;
+	mark_buffer_dirty(sbh);
+	if (sync)
+		sync_dirty_buffer(sbh);
+out:
+	return err;
+}
+
+/*
+ * ext4_snapshot_copy_buffer_cow()
+ * helper function for ext4_snapshot_test_and_cow()
+ * copy COWed buffer to new allocated (locked) snapshot buffer
+ * add complete the COW operation
+ */
+static inline int
+ext4_snapshot_copy_buffer_cow(handle_t *handle, struct inode *snapshot,
+				   struct buffer_head *sbh,
+				   struct buffer_head *bh)
+{
+	__ext4_snapshot_copy_buffer(sbh, bh);
+	return ext4_snapshot_complete_cow(handle, snapshot, sbh, bh, 0);
+}
+
+/*
+ * ext4_snapshot_copy_buffer()
+ * helper function for ext4_snapshot_take()
+ * used for initializing pre-allocated snapshot blocks
+ * copy buffer to snapshot buffer and sync to disk
+ * 'mask' block bitmap with exclude bitmap before copying to snapshot.
+ */
+void ext4_snapshot_copy_buffer(struct buffer_head *sbh,
+		struct buffer_head *bh, const char *mask)
+{
+	lock_buffer(sbh);
+	__ext4_snapshot_copy_buffer(sbh, bh);
+	unlock_buffer(sbh);
+	mark_buffer_dirty(sbh);
+	sync_dirty_buffer(sbh);
+}
+
+/*
+ * COW functions
+ */
+
+#ifdef CONFIG_EXT4_DEBUG
+static void
+__ext4_snapshot_trace_cow(const char *where, handle_t *handle,
+		struct super_block *sb, struct inode *inode,
+		struct buffer_head *bh, ext4_fsblk_t block,
+		int count, int cmd)
+{
+	unsigned long inode_group = 0;
+	ext4_grpblk_t inode_offset = 0;
+
+	if (inode) {
+		inode_group = (inode->i_ino - 1) /
+			EXT4_INODES_PER_GROUP(sb);
+		inode_offset = (inode->i_ino - 1) %
+			EXT4_INODES_PER_GROUP(sb);
+	}
+	snapshot_debug_hl(4, "%s(i:%d/%ld, b:%lld/%lld) "
+			"count=%d, h_ref=%d, cmd=%d\n",
+			where, inode_offset, inode_group,
+			SNAPSHOT_BLOCK_TUPLE(block),
+			count, handle->h_ref, cmd);
+}
+
+#define ext4_snapshot_trace_cow(where, handle, sb, inode, bh, blk, cnt, cmd) \
+	if (snapshot_enable_debug >= 4)					\
+		__ext4_snapshot_trace_cow(where, handle, sb, inode,	\
+				bh, block, count, cmd)
+#else
+#define ext4_snapshot_trace_cow(where, handle, sb, inode, bh, blk, cnt, cmd)
+#endif
+/*
+ * Begin COW or move operation.
+ * No locks needed here, because @handle is a per-task struct.
+ */
+static inline void ext4_snapshot_cow_begin(handle_t *handle)
+{
+	snapshot_debug_hl(4, "{\n");
+	handle->h_cowing = 1;
+}
+
+/*
+ * End COW or move operation.
+ * No locks needed here, because @handle is a per-task struct.
+ */
+static inline void ext4_snapshot_cow_end(const char *where,
+		handle_t *handle, ext4_fsblk_t block, int err)
+{
+	handle->h_cowing = 0;
+	snapshot_debug_hl(4, "} = %d\n", err);
+	snapshot_debug_hl(4, ".\n");
+	if (err < 0)
+		snapshot_debug(1, "%s(b:%lld/%lld) failed!"
+				" h_ref=%d, err=%d\n", where,
+				SNAPSHOT_BLOCK_TUPLE(block),
+				handle->h_ref, err);
+}
+
+/*
+ * ext4_snapshot_test_and_cow - COW metadata block
+ * @where:	name of caller function
+ * @handle:	JBD handle
+ * @inode:	owner of blocks (NULL for global metadata blocks)
+ * @block:	address of metadata block
+ * @bh:		buffer head of metadata block
+ * @cow:	if false, return 1 if block needs to be COWed
+ *
+ * Return values:
+ * = 1 - @block needs to be COWed
+ * = 0 - @block was COWed or doesn't need to be COWed
+ * < 0 - error
+ */
+int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
+		struct inode *inode, ext4_fsblk_t block,
+		struct buffer_head *bh, int cow)
+{
+	struct super_block *sb = handle->h_transaction->t_journal->j_private;
+	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
+	struct buffer_head *sbh = NULL;
+	ext4_fsblk_t blk = 0;
+	int err = 0, clear = 0, count = 1;
+
+	if (!active_snapshot)
+		/* no active snapshot - no need to COW */
+		return 0;
+
+	ext4_snapshot_trace_cow(where, handle, sb, inode, bh, block, 1, cow);
+
+	if (IS_COWING(handle)) {
+		/* avoid recursion on active snapshot updates */
+		WARN_ON(inode && inode != active_snapshot);
+		snapshot_debug_hl(4, "active snapshot update - "
+				  "skip block cow!\n");
+		return 0;
+	} else if (inode == active_snapshot) {
+		/* active snapshot may only be modified during COW */
+		snapshot_debug_hl(4, "active snapshot access denied!\n");
+		return -EPERM;
+	}
+
+	/* BEGIN COWing */
+	ext4_snapshot_cow_begin(handle);
+
+	if (inode)
+		clear = ext4_snapshot_excluded(inode);
+	if (clear < 0) {
+		/*
+		 * excluded file block access - don't COW and
+		 * mark block in exclude bitmap
+		 */
+		snapshot_debug_hl(4, "file (%lu) excluded from snapshot - "
+				"mark block (%lld) in exclude bitmap\n",
+				inode->i_ino, block);
+		cow = 0;
+	}
+
+	if (clear < 0)
+		goto cowed;
+	if (!err) {
+		trace_cow_inc(handle, ok_bitmap);
+		goto cowed;
+	}
+
+	/* block is in use by snapshot - check if it is mapped */
+	err = ext4_snapshot_map_blocks(handle, active_snapshot, block, 1, &blk,
+					SNAPMAP_READ);
+	if (err < 0)
+		goto out;
+	if (err > 0) {
+		sbh = sb_find_get_block(sb, blk);
+		trace_cow_inc(handle, ok_mapped);
+		err = 0;
+		goto test_pending_cow;
+	}
+
+	/* block needs to be COWed */
+	err = 1;
+	if (!cow)
+		/* don't COW - we were just checking */
+		goto out;
+
+	err = -EIO;
+	/* make sure we hold an uptodate source buffer */
+	if (!bh || !buffer_mapped(bh))
+		goto out;
+	if (!buffer_uptodate(bh)) {
+		snapshot_debug(1, "warning: non uptodate buffer (%lld)"
+				" needs to be copied to active snapshot!\n",
+				block);
+		ll_rw_block(READ, 1, &bh);
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			goto out;
+	}
+
+	/* try to allocate snapshot block to make a backup copy */
+	sbh = ext4_getblk(handle, active_snapshot, SNAPSHOT_IBLOCK(block),
+			   SNAPMAP_COW, &err);
+	if (!sbh)
+		goto out;
+
+	blk = sbh->b_blocknr;
+	if (!err) {
+		/*
+		 * we didn't allocate this block -
+		 * another COWing task must have allocated it
+		 */
+		trace_cow_inc(handle, ok_mapped);
+		goto test_pending_cow;
+	}
+
+	/*
+	 * we allocated this block -
+	 * copy block data to snapshot and complete COW operation
+	 */
+	err = ext4_snapshot_copy_buffer_cow(handle, active_snapshot,
+			sbh, bh);
+	if (err)
+		goto out;
+	snapshot_debug(3, "block [%lld/%lld] of snapshot (%u) "
+			"mapped to block [%lld/%lld]\n",
+			SNAPSHOT_BLOCK_TUPLE(block),
+			active_snapshot->i_generation,
+			SNAPSHOT_BLOCK_TUPLE(sbh->b_blocknr));
+
+	trace_cow_inc(handle, copied);
+test_pending_cow:
+
+cowed:
+out:
+	brelse(sbh);
+	/* END COWing */
+	ext4_snapshot_cow_end(where, handle, block, err);
+	return err;
+}
+
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index ea87a5a..90cb33e 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -174,7 +174,17 @@ extern void ext4_snapshot_copy_buffer(struct buffer_head *sbh,
 extern int ext4_snapshot_read_block_bitmap(struct super_block *sb,
 		unsigned int block_group, struct buffer_head *bitmap_bh);
 
-#define ext4_snapshot_cow(handle, inode, block, bh, cow) 0
+extern int ext4_snapshot_test_and_cow(const char *where,
+		handle_t *handle, struct inode *inode,
+		ext4_fsblk_t block, struct buffer_head *bh, int cow);
+
+/*
+ * test if a metadata block should be COWed
+ * and if it should, copy the block to the active snapshot
+ */
+#define ext4_snapshot_cow(handle, inode, block, bh, cow)	\
+	ext4_snapshot_test_and_cow(__func__, handle, inode,	\
+			block, bh, cow)
 
 #define ext4_snapshot_move(handle, inode, block, pcount, move) (0)
 
-- 
1.7.4.1

