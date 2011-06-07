From: amir73il@users.sourceforge.net
Subject: [PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
Date: Tue,  7 Jun 2011 18:08:01 +0300
Message-ID: <1307459283-22130-35-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab1FGPKa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:30 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:29 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Free blocks of deleted snapshots, which are not in use by an older
non-deleted snapshot.  Shrinking helps reclaiming disk space
while older snapshots are currently in use (enabled).
We modify the indirect inode truncate helper functions so that they
can be used by the snapshot cleanup functions to free blocks
selectively according to a COW bitmap buffer.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h           |   10 ++
 fs/ext4/inode.c          |   51 ++++++++---
 fs/ext4/snapshot.h       |    5 +
 fs/ext4/snapshot_ctl.c   |  232 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_inode.c |  220 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 504 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6f0f310..92d75c2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1894,6 +1894,16 @@ extern void ext4_free_branches(handle_t *handle, struct inode *inode,
 				struct buffer_head *parent_bh,
 				__le32 *first, __le32 *last,
 				int depth);
+extern void ext4_free_data_cow(handle_t *handle, struct inode *inode,
+			   struct buffer_head *this_bh,
+			   __le32 *first, __le32 *last,
+			   const char *bitmap, int bit,
+			   int *pfreed_blocks);
+
+#define ext4_free_data(handle, inode, bh, first, last)		\
+	ext4_free_data_cow(handle, inode, bh, first, last,	\
+			    NULL, 0, NULL)
+
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5199035..ad9463f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4523,11 +4523,15 @@ no_top:
  * Return 0 on success, 1 on invalid block range
  * and < 0 on fatal error.
  */
-static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
-			     struct buffer_head *bh,
-			     ext4_fsblk_t block_to_free,
-			     unsigned long count, __le32 *first,
-			     __le32 *last)
+/*
+ * ext4_clear_blocks_cow - Zero a number of block pointers (consult COW bitmap)
+ * @bitmap:	COW bitmap to consult when shrinking deleted snapshot
+ * @bit:	bit number representing the @first block
+ */
+static int ext4_clear_blocks_cow(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_fsblk_t block_to_free,
+		unsigned long count, __le32 *first, __le32 *last,
+		const char *bitmap, int bit)
 {
 	__le32 *p;
 	int	flags = EXT4_FREE_BLOCKS_FORGET | EXT4_FREE_BLOCKS_VALIDATED;
@@ -4567,8 +4571,12 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	for (p = first; p < last; p++)
+	for (p = first; p < last; p++) {
+		if (*p && bitmap && ext4_test_bit(bit + (p - first), bitmap))
+			/* don't free block used by older snapshot */
+			continue;
 		*p = 0;
+	}
 
 	ext4_free_blocks(handle, inode, NULL, block_to_free, count, flags);
 	return 0;
@@ -4596,9 +4604,17 @@ out_err:
  * @this_bh will be %NULL if @first and @last point into the inode's direct
  * block pointers.
  */
-static void ext4_free_data(handle_t *handle, struct inode *inode,
+/*
+ * ext4_free_data_cow - free a list of data blocks (consult COW bitmap)
+ * @bitmap:	   COW bitmap to consult when shrinking deleted snapshot
+ * @bit:	   bit number representing the @first block
+ * @pfreed_blocks: return number of freed blocks
+ */
+void ext4_free_data_cow(handle_t *handle, struct inode *inode,
 			   struct buffer_head *this_bh,
-			   __le32 *first, __le32 *last)
+			   __le32 *first, __le32 *last,
+			   const char *bitmap, int bit,
+			   int *pfreed_blocks)
 {
 	ext4_fsblk_t block_to_free = 0;    /* Starting block # of a run */
 	unsigned long count = 0;	    /* Number of blocks in the run */
@@ -4622,6 +4638,11 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 
 	for (p = first; p < last; p++) {
 		nr = le32_to_cpu(*p);
+		if (nr && bitmap && ext4_test_bit(bit + (p - first), bitmap))
+			/* don't free block used by older snapshot */
+			nr = 0;
+		if (nr && pfreed_blocks)
+			++(*pfreed_blocks);
 		if (nr) {
 			/* accumulate blocks to free if they're contiguous */
 			if (count == 0) {
@@ -4631,9 +4652,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 			} else if (nr == block_to_free + count) {
 				count++;
 			} else {
-				err = ext4_clear_blocks(handle, inode, this_bh,
-						        block_to_free, count,
-						        block_to_free_p, p);
+				err = ext4_clear_blocks_cow(handle, inode,
+					       this_bh, block_to_free, count,
+					       block_to_free_p, p, bitmap,
+					       bit + (block_to_free_p - first));
 				if (err)
 					break;
 				block_to_free = nr;
@@ -4643,9 +4665,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	if (!err && count > 0)
-		err = ext4_clear_blocks(handle, inode, this_bh, block_to_free,
-					count, block_to_free_p, p);
+	if (count > 0)
+		err = ext4_clear_blocks_cow(handle, inode, this_bh,
+				block_to_free, count, block_to_free_p, p,
+				bitmap, bit + (block_to_free_p - first));
 	if (err < 0)
 		/* fatal error */
 		return;
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 11fa43d..53d4481 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -401,6 +401,11 @@ static inline void exit_ext4_snapshot(void)
 {
 }
 
+/* snapshot_inode.c */
+extern int ext4_snapshot_shrink_blocks(handle_t *handle, struct inode *inode,
+		sector_t iblock, unsigned long maxblocks,
+		struct buffer_head *cow_bh,
+		int shrink, int *pmapped);
 
 /* tests if @inode is a snapshot file */
 static inline int ext4_snapshot_file(struct inode *inode)
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 13048f5..710e157 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -1379,6 +1379,221 @@ out_err:
 }
 
 /*
+ * ext4_snapshot_shrink_range - free unused blocks from deleted snapshots
+ * @handle: JBD handle for this transaction
+ * @start:	latest non-deleted snapshot before deleted snapshots group
+ * @end:	first non-deleted snapshot after deleted snapshots group
+ * @iblock:	inode offset to first data block to shrink
+ * @maxblocks:	inode range of data blocks to shrink
+ * @cow_bh:	buffer head to map the COW bitmap block of snapshot @start
+ *		if NULL, don't look for COW bitmap block
+ *
+ * Shrinks @maxblocks blocks starting at inode offset @iblock in a group of
+ * subsequent deleted snapshots starting after @start and ending before @end.
+ * Shrinking is done by finding a range of mapped blocks in @start snapshot
+ * or in one of the deleted snapshots, where no other blocks are mapped in the
+ * same range in @start snapshot or in snapshots between them.
+ * The blocks in the found range may be 'in-use' by @start snapshot, so only
+ * blocks which are not set in the COW bitmap are freed.
+ * All mapped blocks of other deleted snapshots in the same range are freed.
+ *
+ * Called from ext4_snapshot_shrink() under snapshot_mutex.
+ * Returns the shrunk blocks range and <0 on error.
+ */
+static int ext4_snapshot_shrink_range(handle_t *handle,
+		struct inode *start, struct inode *end,
+		sector_t iblock, unsigned long maxblocks,
+		struct buffer_head *cow_bh)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(start->i_sb);
+	struct list_head *l;
+	struct inode *inode = start;
+	/* start with @maxblocks range and narrow it down */
+	int err, count = maxblocks;
+	/* @start snapshot blocks should not be freed only counted */
+	int mapped, shrink = 0;
+
+	/* iterate on (@start <= snapshot < @end) */
+	list_for_each_prev(l, &EXT4_I(start)->i_snaplist) {
+		err = ext4_snapshot_shrink_blocks(handle, inode,
+				iblock, count, cow_bh, shrink, &mapped);
+		if (err < 0)
+			return err;
+
+		/* 0 < new range <= old range */
+		BUG_ON(!err || err > count);
+		count = err;
+		cond_resched();
+
+		/*
+		 * shrink mode state transitions:
+		 * 1. on @start, shrink is set to 0 ('don't free' mode).
+		 * 2. after @start, shrink is incremented until mapped blocks
+		 *    are found in the shrunk range ('free unused' mode).
+		 * 3. after mapped block were found, or if cow_bh is NULL,
+		 *    shrink is set to -1 and decremented until the end of
+		 *    the deleted snapshots group ('free all' mode).
+		 */
+		if (shrink < 0)
+			/* stay in 'free all' mode */
+			shrink--;
+		else if (!cow_bh)
+			/* no COW bitmap - enter 'free all' mode */
+			shrink = -1;
+		else if (mapped)
+			/* found mapped blocks - enter 'free all' mode */
+			shrink = -1;
+		else
+			/* enter/stay in 'free unused' mode */
+			shrink++;
+
+		if (l == &sbi->s_snapshot_list)
+			/* didn't reach @end */
+			return -EINVAL;
+		inode = &list_entry(l, struct ext4_inode_info,
+						  i_snaplist)->vfs_inode;
+		if (inode == end)
+			break;
+		/* indicate shrink progress via i_size */
+		SNAPSHOT_SET_PROGRESS(inode, SNAPSHOT_BLOCK(iblock));
+	}
+	return count;
+}
+
+/*
+ * ext4_snapshot_shrink - free unused blocks from deleted snapshot files
+ * @handle: JBD handle for this transaction
+ * @start:	latest non-deleted snapshot before deleted snapshots group
+ * @end:	first non-deleted snapshot after deleted snapshots group
+ * @need_shrink: no. of deleted snapshots in the group
+ *
+ * Frees all blocks in subsequent deleted snapshots starting after @start and
+ * ending before @end, except for blocks which are 'in-use' by @start snapshot.
+ * (blocks 'in-use' are set in snapshot COW bitmap and not copied to snapshot).
+ * Called from ext4_snapshot_update() under snapshot_mutex.
+ * Returns 0 on success and <0 on error.
+ */
+static int ext4_snapshot_shrink(struct inode *start, struct inode *end,
+				 int need_shrink)
+{
+	struct list_head *l;
+	handle_t *handle;
+	struct buffer_head cow_bitmap, *cow_bh = NULL;
+	ext4_fsblk_t block = 1; /* skip super block */
+	struct ext4_sb_info *sbi = EXT4_SB(start->i_sb);
+	/* blocks beyond the size of @start are not in-use by @start */
+	ext4_fsblk_t snapshot_blocks = SNAPSHOT_BLOCKS(start);
+	unsigned long count = ext4_blocks_count(sbi->s_es) - block;
+	long block_group = -1;
+	ext4_fsblk_t bg_boundary = 0;
+	int err, ret;
+
+	snapshot_debug(3, "snapshot (%u-%u) shrink: "
+			"count = 0x%lx, need_shrink = %d\n",
+			start->i_generation, end->i_generation,
+			count, need_shrink);
+
+	/* start large truncate transaction that will be extended/restarted */
+	handle = ext4_journal_start(start, EXT4_MAX_TRANS_DATA);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	while (count > 0) {
+		while (block >= bg_boundary) {
+			/* reset COW bitmap cache */
+			cow_bitmap.b_state = 0;
+			cow_bitmap.b_blocknr = 0;
+			cow_bh = &cow_bitmap;
+			bg_boundary += SNAPSHOT_BLOCKS_PER_GROUP;
+			block_group++;
+			if (block >= snapshot_blocks)
+				/*
+				 * Past last snapshot block group - pass NULL
+				 * cow_bh to ext4_snapshot_shrink_range().
+				 * This will cause snapshots after resize to
+				 * shrink to the size of @start snapshot.
+				 */
+				cow_bh = NULL;
+			cond_resched();
+		}
+
+		err = extend_or_restart_transaction(handle,
+						    EXT4_MAX_TRANS_DATA);
+		if (err)
+			goto out_err;
+
+		err = ext4_snapshot_shrink_range(handle, start, end,
+					      SNAPSHOT_IBLOCK(block), count,
+					      cow_bh);
+
+		snapshot_debug(3, "snapshot (%u-%u) shrink: "
+				"block = 0x%llu, count = 0x%lx, err = 0x%x\n",
+				start->i_generation, end->i_generation,
+				block, count, err);
+
+		if (buffer_mapped(&cow_bitmap) && buffer_new(&cow_bitmap)) {
+			snapshot_debug(2, "snapshot (%u-%u) shrink: "
+				"block group = %ld/%u, "
+				"COW bitmap = [%llu/%llu]\n",
+				start->i_generation, end->i_generation,
+				block_group, sbi->s_groups_count,
+				SNAPSHOT_BLOCK_TUPLE(cow_bitmap.b_blocknr));
+			clear_buffer_new(&cow_bitmap);
+		}
+
+		if (err <= 0)
+			goto out_err;
+
+		block += err;
+		count -= err;
+	}
+
+	/* marks need_shrink snapshots shrunk */
+	err = extend_or_restart_transaction(handle, need_shrink);
+	if (err)
+		goto out_err;
+
+	/* iterate on (@start < snapshot < @end) */
+	list_for_each_prev(l, &EXT4_I(start)->i_snaplist) {
+		struct inode *inode;
+		struct ext4_iloc iloc;
+
+		if (l == &sbi->s_snapshot_list)
+			break;
+
+		inode = &list_entry(l, struct ext4_inode_info,
+				    i_snaplist)->vfs_inode;
+		if (inode == end)
+			break;
+		/* reset i_size that was used as progress indicator */
+		SNAPSHOT_SET_DISABLED(inode);
+		if (ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED) &&
+		    !(ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK) &&
+		    ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_ACTIVE))) {
+			/* mark snapshot shrunk */
+			err = ext4_reserve_inode_write(handle, inode, &iloc);
+			ext4_set_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK);
+			if (!err)
+				ext4_mark_iloc_dirty(handle, inode, &iloc);
+			if (--need_shrink <= 0)
+				break;
+		}
+	}
+
+	err = 0;
+out_err:
+	ret = ext4_journal_stop(handle);
+	if (!err)
+		err = ret;
+	if (need_shrink)
+		snapshot_debug(1, "snapshot (%u-%u) shrink: "
+			       "need_shrink=%d(>0!), err=%d\n",
+			       start->i_generation, end->i_generation,
+			       need_shrink, err);
+	return err;
+}
+
+/*
  * ext4_snapshot_cleanup - shrink/merge/remove snapshot marked for deletion
  * @inode - inode in question
  * @used_by - latest non-deleted snapshot
@@ -1403,6 +1618,23 @@ static int ext4_snapshot_cleanup(struct inode *inode, struct inode *used_by,
 		/* remove permanently unused deleted snapshot */
 		return ext4_snapshot_remove(inode);
 
+	if (deleted) {
+		/* deleted (non-active) snapshot file */
+		if (!ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK))
+			/* deleted snapshot needs shrinking */
+			(*need_shrink)++;
+		return 0;
+	}
+
+	/* non-deleted (or active) snapshot file */
+	if (*need_shrink) {
+		/* pass 1: shrink all deleted snapshots
+		 * between 'used_by' and 'inode' */
+		err = ext4_snapshot_shrink(used_by, inode, *need_shrink);
+		if (err)
+			return err;
+		*need_shrink = 0;
+	}
 	return 0;
 }
 
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index 3d6cb7b..391aa92 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -38,6 +38,226 @@
 
 #include <trace/events/ext4.h>
 #include "snapshot.h"
+
+/**
+ * ext4_blks_to_skip - count the number blocks that can be skipped
+ * @inode: inode in question
+ * @i_block: start block number
+ * @maxblocks: max number of data blocks to be skipped
+ * @chain: chain of indirect blocks
+ * @depth: length of chain from inode to data block
+ * @offsets: array of offsets in chain blocks
+ * @k: number of allocated blocks in the chain
+ *
+ * Counts the number of non-allocated data blocks (holes) at offset @i_block.
+ * Called from ext4_snapshot_merge_blocks() and ext4_snapshot_shrink_blocks()
+ * under snapshot_mutex.
+ * Returns the total number of data blocks to be skipped.
+ */
+
+static int ext4_blks_to_skip(struct inode *inode, long i_block,
+		unsigned long maxblocks, Indirect chain[4], int depth,
+		int *offsets, int k)
+{
+	int ptrs = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+	int ptrs_bits = EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb);
+	const long direct_blocks = EXT4_NDIR_BLOCKS,
+		indirect_blocks = ptrs,
+		double_blocks = (1 << (ptrs_bits * 2));
+	/* number of data blocks mapped with a single splice to the chain */
+	int data_ptrs_bits = ptrs_bits * (depth - k - 1);
+	int max_ptrs = maxblocks >> data_ptrs_bits;
+	int final = 0;
+	unsigned long count = 0;
+
+	switch (depth) {
+	case 4: /* tripple indirect */
+		i_block -= double_blocks;
+		/* fall through */
+	case 3: /* double indirect */
+		i_block -= indirect_blocks;
+		/* fall through */
+	case 2: /* indirect */
+		i_block -= direct_blocks;
+		final = (k == 0 ? 1 : ptrs);
+		break;
+	case 1: /* direct */
+		final = direct_blocks;
+		break;
+	}
+	/* offset of block from start of splice point */
+	i_block &= ((1 << data_ptrs_bits) - 1);
+
+	count++;
+	while (count <= max_ptrs &&
+		offsets[k] + count < final &&
+		le32_to_cpu(*(chain[k].p + count)) == 0) {
+		count++;
+	}
+	/* number of data blocks mapped by 'count' splice points */
+	count <<= data_ptrs_bits;
+	count -= i_block;
+	return count < maxblocks ? count : maxblocks;
+}
+
+/*
+ * ext4_snapshot_shrink_blocks - free unused blocks from deleted snapshot
+ * @handle: JBD handle for this transaction
+ * @inode:	inode we're shrinking
+ * @iblock:	inode offset to first data block to shrink
+ * @maxblocks:	inode range of data blocks to shrink
+ * @cow_bh:	buffer head to map the COW bitmap block
+ *		if NULL, don't look for COW bitmap block
+ * @shrink:	shrink mode: 0 (don't free), >0 (free unused), <0 (free all)
+ * @pmapped:	return no. of mapped blocks or 0 for skipped holes
+ *
+ * Frees @maxblocks blocks starting at offset @iblock in @inode, which are not
+ * 'in-use' by non-deleted snapshots (blocks 'in-use' are set in COW bitmap).
+ * If @shrink is false, just count mapped blocks and look for COW bitmap block.
+ * The first time that a COW bitmap block is found in @inode, whether @inode is
+ * deleted or not, it is stored in @cow_bh and is used in subsequent calls to
+ * this function with other deleted snapshots within the block group boundaries.
+ * Called from ext4_snapshot_shrink_blocks() under snapshot_mutex.
+ *
+ * Return values:
+ * >= 0 - no. of shrunk blocks (*@pmapped ? mapped blocks : skipped holes)
+ *  < 0 - error
+ */
+int ext4_snapshot_shrink_blocks(handle_t *handle, struct inode *inode,
+		sector_t iblock, unsigned long maxblocks,
+		struct buffer_head *cow_bh,
+		int shrink, int *pmapped)
+{
+	int offsets[4];
+	Indirect chain[4], *partial;
+	int err, blocks_to_boundary, depth, count;
+	struct buffer_head *sbh = NULL;
+	struct ext4_group_desc *desc = NULL;
+	ext4_snapblk_t block_bitmap, block = SNAPSHOT_BLOCK(iblock);
+	unsigned long block_group = SNAPSHOT_BLOCK_GROUP(block);
+	int mapped_blocks = 0, freed_blocks = 0;
+	const char *cow_bitmap;
+
+	BUG_ON(shrink &&
+	       (!(ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_DELETED)) ||
+		ext4_snapshot_is_active(inode)));
+
+	depth = ext4_block_to_path(inode, iblock, offsets,
+			&blocks_to_boundary);
+	if (depth == 0)
+		return -EIO;
+
+	desc = ext4_get_group_desc(inode->i_sb, block_group, NULL);
+	if (!desc)
+		return -EIO;
+	block_bitmap = ext4_block_bitmap(inode->i_sb, desc);
+	partial = ext4_get_branch(inode, depth, offsets, chain, &err);
+	if (err)
+		return err;
+
+	if (partial) {
+		/* block not mapped (hole) - count the number of holes to
+		 * skip */
+		count = ext4_blks_to_skip(inode, iblock, maxblocks, chain,
+					   depth, offsets, (partial - chain));
+		snapshot_debug(3, "skipping snapshot (%u) blocks: block=0x%llx"
+			       ", count=0x%x\n", inode->i_generation,
+			       block, count);
+		goto shrink_indirect_blocks;
+	}
+
+	/* data block mapped - check if data blocks should be freed */
+	partial = chain + depth - 1;
+	/* scan all blocks upto maxblocks/boundary */
+	count = 0;
+	while (count < maxblocks && count <= blocks_to_boundary) {
+		ext4_fsblk_t blk = le32_to_cpu(*(partial->p + count));
+		if (blk && block + count == block_bitmap &&
+			cow_bh && !buffer_mapped(cow_bh)) {
+			/*
+			 * 'blk' is the COW bitmap physical block -
+			 * store it in cow_bh for subsequent calls
+			 * FIXME: for non-first flex_bg group,
+			 * we will not find COW bitmap like this.
+			 */
+			map_bh(cow_bh, inode->i_sb, blk);
+			set_buffer_new(cow_bh);
+			snapshot_debug(3, "COW bitmap #%lu: snapshot "
+				"(%u), bitmap_blk=(+%lld)\n",
+				block_group, inode->i_generation,
+				SNAPSHOT_BLOCK_GROUP_OFFSET(block_bitmap));
+		}
+		if (blk)
+			/* count mapped blocks in range */
+			mapped_blocks++;
+		else if (shrink >= 0)
+			/*
+			 * Unless we are freeing all block in range,
+			 * we cannot have holes inside mapped range
+			 */
+			break;
+		/* count size of range */
+		count++;
+	}
+
+	if (!shrink)
+		goto done_shrinking;
+
+	cow_bitmap = NULL;
+	if (shrink > 0 && cow_bh && buffer_mapped(cow_bh)) {
+		/* we found COW bitmap - consult it when shrinking */
+		sbh = sb_bread(inode->i_sb, cow_bh->b_blocknr);
+		if (!sbh) {
+			err = -EIO;
+			goto cleanup;
+		}
+		cow_bitmap = sbh->b_data;
+	}
+	if (shrink < 0 || cow_bitmap) {
+		int bit = SNAPSHOT_BLOCK_GROUP_OFFSET(block);
+
+		BUG_ON(bit + count > SNAPSHOT_BLOCKS_PER_GROUP);
+		/* free blocks with or without consulting COW bitmap */
+		ext4_free_data_cow(handle, inode, partial->bh,
+				partial->p, partial->p + count,
+				cow_bitmap, bit, &freed_blocks);
+	}
+
+shrink_indirect_blocks:
+	/* check if the indirect block should be freed */
+	if (shrink && partial == chain + depth - 1) {
+		Indirect *ind = partial - 1;
+		__le32 *p = NULL;
+		if (freed_blocks == mapped_blocks &&
+		    count > blocks_to_boundary) {
+			for (p = (__le32 *)(partial->bh->b_data);
+			     !*p && p < partial->p; p++)
+				;
+		}
+		if (p == partial->p)
+			/* indirect block maps zero data blocks - free it */
+			ext4_free_branches(handle, inode, ind->bh, ind->p,
+					ind->p+1, 1);
+	}
+
+done_shrinking:
+	snapshot_debug(3, "shrinking snapshot (%u) blocks: shrink=%d, "
+			"block=0x%llx, count=0x%x, mapped=0x%x, freed=0x%x\n",
+			inode->i_generation, shrink, block, count,
+			mapped_blocks, freed_blocks);
+
+	if (pmapped)
+		*pmapped = mapped_blocks;
+	err = count;
+cleanup:
+	while (partial > chain) {
+		brelse(partial->bh);
+		partial--;
+	}
+	brelse(sbh);
+return err;
+}
+
 /*
  * ext4_snapshot_get_block_access() - called from ext4_snapshot_read_through()
  * on snapshot file access.
-- 
1.7.4.1

