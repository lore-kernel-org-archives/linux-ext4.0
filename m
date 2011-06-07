From: amir73il@users.sourceforge.net
Subject: [PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
Date: Tue,  7 Jun 2011 18:08:02 +0300
Message-ID: <1307459283-22130-36-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1FGPKc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:32 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:32 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Move blocks of deleted and shrunk snapshots to an older non-deleted
and disabled snapshot.  Merging helps removing snapshots from list
while older snapshots are not currently in use (disabled).


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot.h       |    3 +
 fs/ext4/snapshot_ctl.c   |  113 +++++++++++++++++
 fs/ext4/snapshot_inode.c |  307 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 423 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 53d4481..fafb38d 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -406,6 +406,9 @@ extern int ext4_snapshot_shrink_blocks(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
 		struct buffer_head *cow_bh,
 		int shrink, int *pmapped);
+extern int ext4_snapshot_merge_blocks(handle_t *handle,
+		struct inode *src, struct inode *dst,
+		sector_t iblock, unsigned long maxblocks);
 
 /* tests if @inode is a snapshot file */
 static inline int ext4_snapshot_file(struct inode *inode)
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 710e157..6c8dc35 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -1594,6 +1594,107 @@ out_err:
 }
 
 /*
+ * ext4_snapshot_merge - merge deleted snapshots
+ * @handle: JBD handle for this transaction
+ * @start:	latest non-deleted snapshot before deleted snapshots group
+ * @end:	first non-deleted snapshot after deleted snapshots group
+ * @need_merge: no. of deleted snapshots in the group
+ *
+ * Move all blocks from deleted snapshots group starting after @start and
+ * ending before @end to @start snapshot.  All moved blocks are 'in-use' by
+ * @start snapshot, because these deleted snapshots have already been shrunk
+ * (blocks 'in-use' are set in snapshot COW bitmap and not copied to snapshot).
+ * Called from ext4_snapshot_update() under snapshot_mutex.
+ * Returns 0 on success and <0 on error.
+ */
+static int ext4_snapshot_merge(struct inode *start, struct inode *end,
+				int need_merge)
+{
+	struct list_head *l, *n;
+	handle_t *handle = NULL;
+	struct ext4_sb_info *sbi = EXT4_SB(start->i_sb);
+	int err, ret;
+
+	snapshot_debug(3, "snapshot (%u-%u) merge: need_merge=%d\n",
+			start->i_generation, end->i_generation, need_merge);
+
+	/* iterate safe on (@start < snapshot < @end) */
+	list_for_each_prev_safe(l, n, &EXT4_I(start)->i_snaplist) {
+		struct inode *inode = &list_entry(l, struct ext4_inode_info,
+						  i_snaplist)->vfs_inode;
+
+		ext4_fsblk_t block = 1; /* skip super block */
+		/* blocks beyond the size of @start are not in-use by @start */
+		int count = SNAPSHOT_BLOCKS(start) - block;
+
+		if (n == &sbi->s_snapshot_list || inode == end ||
+		    !(ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK)))
+			break;
+
+		/* start large transaction that will be extended/restarted */
+		handle = ext4_journal_start(inode, EXT4_MAX_TRANS_DATA);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		while (count > 0) {
+			/* we modify one indirect block and the inode itself
+			 * for both the source and destination inodes */
+			err = extend_or_restart_transaction(handle, 4);
+			if (err)
+				goto out_err;
+
+			err = ext4_snapshot_merge_blocks(handle, inode, start,
+						 SNAPSHOT_IBLOCK(block), count);
+
+			snapshot_debug(3, "snapshot (%u) -> snapshot (%u) "
+				       "merge: block = 0x%llu, count = 0x%x, "
+				       "err = 0x%x\n", inode->i_generation,
+				       start->i_generation, block, count, err);
+
+			if (err <= 0)
+				goto out_err;
+
+			block += err;
+			count -= err;
+			/* indicate merge progress via i_size */
+			SNAPSHOT_SET_PROGRESS(inode, block);
+			cond_resched();
+		}
+
+		/* reset i_size that was used as progress indicator */
+		SNAPSHOT_SET_DISABLED(inode);
+
+		err = ext4_journal_stop(handle);
+		handle = NULL;
+		if (err)
+			goto out_err;
+
+		/* we finished moving all blocks of interest from 'inode'
+		 * into 'start' so it is now safe to remove 'inode' from the
+		 * snapshots list forever */
+		err = ext4_snapshot_remove(inode);
+		if (err)
+			goto out_err;
+
+		if (--need_merge <= 0)
+			break;
+	}
+
+	err = 0;
+out_err:
+	if (handle) {
+		ret = ext4_journal_stop(handle);
+		if (!err)
+			err = ret;
+	}
+	if (need_merge)
+		snapshot_debug(1, "snapshot (%u-%u) merge: need_merge=%d(>0!), "
+			       "err=%d\n", start->i_generation,
+			       end->i_generation, need_merge, err);
+	return err;
+}
+
+/*
  * ext4_snapshot_cleanup - shrink/merge/remove snapshot marked for deletion
  * @inode - inode in question
  * @used_by - latest non-deleted snapshot
@@ -1623,6 +1724,10 @@ static int ext4_snapshot_cleanup(struct inode *inode, struct inode *used_by,
 		if (!ext4_test_inode_flag(inode, EXT4_INODE_SNAPFILE_SHRUNK))
 			/* deleted snapshot needs shrinking */
 			(*need_shrink)++;
+		if (!ext4_test_inode_snapstate(inode, EXT4_SNAPSTATE_INUSE))
+			/* temporarily unused deleted
+			 * snapshot needs merging */
+			(*need_merge)++;
 		return 0;
 	}
 
@@ -1635,6 +1740,14 @@ static int ext4_snapshot_cleanup(struct inode *inode, struct inode *used_by,
 			return err;
 		*need_shrink = 0;
 	}
+	if (*need_merge) {
+		/* pass 2: merge all shrunk snapshots
+		 * between 'used_by' and 'inode' */
+		err = ext4_snapshot_merge(used_by, inode, *need_merge);
+		if (err)
+			return err;
+		*need_merge = 0;
+	}
 	return 0;
 }
 
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index 391aa92..73defa8 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -259,6 +259,313 @@ return err;
 }
 
 /*
+ * ext4_snapshot_count_blocks - count blocks and verify that
+ * snapshot blocks are excluded.
+ *	@inode:	snapshot we are merging
+ *	@block:	first block to test
+ *	@count:	no. of blocks to test
+ *	@pblocks: pointer to counter of blocks
+ *
+ * Return <0 on error or if blocks are not excluded.
+ */
+static int ext4_snapshot_count_blocks(struct inode *inode, ext4_fsblk_t block,
+				      unsigned long count, int *pblocks)
+{
+	int err;
+
+	/* test that blocks are excluded and update blocks counter */
+	err = ext4_snapshot_test_excluded(inode, block, count);
+	if (err)
+		return err;
+	*pblocks += count;
+	return 0;
+}
+
+/**
+ * ext4_snapshot_count_data - count blocks on an array of data blocks
+ * and verify that snapshot blocks are excluded.
+ *	@inode:	snapshot we are merging
+ *	@first:	array of block numbers
+ *	@last:	points immediately past the end of array
+ *	@pblocks: pointer to counter of branch blocks
+ *
+ * We accumulate contiguous runs of blocks to test they are excluded.
+ *
+ * Return <0 on error or if blocks are not excluded.
+ */
+static int ext4_snapshot_count_data(struct inode *inode,
+				    __le32 *first, __le32 *last,
+				    int *pblocks)
+{
+	ext4_fsblk_t block = 0;		/* Starting block # of a run */
+	unsigned long count = 0;	/* Number of blocks in the run */
+	__le32 *block_p = NULL;		/* Pointer into inode/ind
+					   corresponding to block */
+	ext4_fsblk_t nr;		/* Current block # */
+	__le32 *p;			/* Pointer into inode/ind
+					   for current block */
+	int err = 0;
+
+	for (p = first; p < last; p++) {
+		nr = le32_to_cpu(*p);
+		if (nr) {
+			/* accumulate blocks to test if they're contiguous */
+			if (count == 0) {
+				block = nr;
+				block_p = p;
+				count = 1;
+			} else if (nr == block + count) {
+				count++;
+			} else {
+				err = ext4_snapshot_count_blocks(inode,
+						block, count, pblocks);
+				if (err)
+					return err;
+				block = nr;
+				block_p = p;
+				count = 1;
+			}
+		}
+	}
+
+	if (count > 0)
+		err = ext4_snapshot_count_blocks(inode, block, count, pblocks);
+	return err;
+}
+
+/**
+ * ext4_snapshot_count_branches - count blocks on an array of branches
+ * and verify that snapshot blocks are excluded.
+ *	@inode:	snapshot we are merging
+ *	@first:	array of block numbers
+ *	@last:	pointer immediately past the end of array
+ *	@depth:	depth of the branches to free
+ *	@pblocks: pointer to counter of branch blocks
+ *
+ * Return <0 on error or if blocks are not excluded.
+ */
+static int ext4_snapshot_count_branches(struct inode *inode,
+			       __le32 *first, __le32 *last, int depth,
+			       int *pblocks)
+{
+	ext4_fsblk_t nr;
+	__le32 *p;
+	int err = 0;
+
+	if (depth--) {
+		struct buffer_head *bh;
+		int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+		p = last;
+		while (--p >= first) {
+			nr = le32_to_cpu(*p);
+			if (!nr)
+				continue;		/* A hole */
+
+			if (!ext4_data_block_valid(EXT4_SB(inode->i_sb),
+						   nr, 1)) {
+				EXT4_ERROR_INODE(inode,
+						 "invalid indirect mapped "
+						 "block %lu (level %d)",
+						 (unsigned long) nr, depth);
+				break;
+			}
+
+			/* Go read the buffer for the next level down */
+			bh = sb_bread(inode->i_sb, nr);
+
+			/*
+			 * A read failure? Report error and clear slot
+			 * (should be rare).
+			 */
+			if (!bh) {
+				EXT4_ERROR_INODE_BLOCK(inode, nr,
+						       "Read failure");
+				continue;
+			}
+
+			/* This counts the entire branch.  Bottom up. */
+			BUFFER_TRACE(bh, "count child branches");
+			err = ext4_snapshot_count_branches(inode,
+					(__le32 *)bh->b_data,
+					(__le32 *)bh->b_data + addr_per_block,
+					depth, pblocks);
+			if (err)
+				break;
+			/* Count the parent block */
+			err = ext4_snapshot_count_blocks(inode, nr, 1, pblocks);
+			if (err)
+				break;
+		}
+	} else {
+		/* We have reached the bottom of the tree. */
+		BUFFER_TRACE(parent_bh, "count data blocks");
+		err = ext4_snapshot_count_data(inode, first, last, pblocks);
+	}
+	return err;
+}
+
+/*
+ * ext4_move_branches - move an array of branches
+ * @handle: JBD handle for this transaction
+ * @src:	inode we're moving blocks from
+ * @ps:		array of src block numbers
+ * @pd:		array of dst block numbers
+ * @depth:	depth of the branches to move
+ * @count:	max branches to move
+ * @pmoved:	pointer to counter of moved blocks
+ *
+ * We move whole branches from src to dst, skipping the holes in src
+ * and stopping at the first branch that needs to be merged at higher level.
+ * Called from ext4_snapshot_merge_blocks() under snapshot_mutex.
+ * Returns the number of merged branches.
+ * Return <0 on error or if blocks are not excluded.
+ */
+static int ext4_move_branches(handle_t *handle, struct inode *src,
+		__le32 *ps, __le32 *pd, int depth,
+		int count, int *pmoved)
+{
+	int i, err;
+
+	for (i = 0; i < count; i++, ps++, pd++) {
+		__le32 s = *ps, d = *pd;
+		if (s && d && depth)
+			/* can't move or skip entire branch, need to merge
+			   these 2 branches */
+			break;
+		if (!s || d)
+			/* skip holes is src and mapped data blocks in dst */
+			continue;
+
+		/* count moved blocks (and verify they are excluded) */
+		err = ext4_snapshot_count_branches(src, ps, ps+1, depth,
+						   pmoved);
+		if (err)
+			return err;
+
+		/* move the entire branch from src to dst inode */
+		*pd = s;
+		*ps = 0;
+	}
+	return i;
+}
+
+/*
+ * ext4_snapshot_merge_blocks - merge blocks from @src to @dst inode
+ * @handle: JBD handle for this transaction
+ * @src:	inode we're merging blocks from
+ * @dst:	inode we're merging blocks to
+ * @iblock:	inode offset to first data block to merge
+ * @maxblocks:	inode range of data blocks to merge
+ *
+ * Merges @maxblocks data blocks starting at @iblock and all the indirect
+ * blocks that map them.
+ * Called from ext4_snapshot_merge() under snapshot_mutex.
+ * Returns the merged blocks range and <0 on error.
+ */
+int ext4_snapshot_merge_blocks(handle_t *handle,
+		struct inode *src, struct inode *dst,
+		sector_t iblock, unsigned long maxblocks)
+{
+	Indirect S[4], D[4], *pS, *pD;
+	int offsets[4];
+	int ks, kd, depth, count;
+	int ptrs = EXT4_ADDR_PER_BLOCK(src->i_sb);
+	int ptrs_bits = EXT4_ADDR_PER_BLOCK_BITS(src->i_sb);
+	int data_ptrs_bits, data_ptrs_mask, max_ptrs;
+	int moved = 0, err;
+
+	depth = ext4_block_to_path(src, iblock, offsets, NULL);
+	if (depth < 3)
+		/* snapshot blocks are mapped with double and tripple
+		   indirect blocks */
+		return -1;
+
+	memset(D, 0, sizeof(D));
+	memset(S, 0, sizeof(S));
+	pD = ext4_get_branch(dst, depth, offsets, D, &err);
+	kd = (pD ? pD - D : depth - 1);
+	if (err)
+		goto out;
+	pS = ext4_get_branch(src, depth, offsets, S, &err);
+	ks = (pS ? pS - S : depth - 1);
+	if (err)
+		goto out;
+
+	if (ks < 1 || kd < 1) {
+		/* snapshot double and tripple tree roots are pre-allocated */
+		err = -EIO;
+		goto out;
+	}
+
+	if (ks < kd) {
+		/* nothing to move from src to dst */
+		count = ext4_blks_to_skip(src, iblock, maxblocks,
+					S, depth, offsets, ks);
+		snapshot_debug(3, "skipping src snapshot (%u) holes: "
+			       "block=0x%llx, count=0x%x\n", src->i_generation,
+			       SNAPSHOT_BLOCK(iblock), count);
+		err = count;
+		goto out;
+	}
+
+	/* move branches from level kd in src to dst */
+	pS = S+kd;
+	pD = D+kd;
+
+	/* compute max branches that can be moved */
+	data_ptrs_bits = ptrs_bits * (depth - kd - 1);
+	data_ptrs_mask = (1 << data_ptrs_bits) - 1;
+	max_ptrs = (maxblocks >> data_ptrs_bits) + 1;
+	if (max_ptrs > ptrs-offsets[kd])
+		max_ptrs = ptrs-offsets[kd];
+
+	/* get write access for the splice point */
+	err = ext4_journal_get_write_access_inode(handle, src, pS->bh);
+	if (err)
+		goto out;
+	err = ext4_journal_get_write_access_inode(handle, dst, pD->bh);
+	if (err)
+		goto out;
+
+	/* move as many whole branches as possible */
+	err = ext4_move_branches(handle, src, pS->p, pD->p, depth-1-kd,
+			max_ptrs, &moved);
+	if (err < 0)
+		goto out;
+	count = err;
+	if (moved) {
+		snapshot_debug(3, "moved snapshot (%u) -> snapshot (%d) "
+			       "branches: block=0x%llx, count=0x%x, k=%d/%d, "
+			       "moved_blocks=%d\n", src->i_generation,
+			       dst->i_generation, SNAPSHOT_BLOCK(iblock),
+			       count, kd, depth, moved);
+		/* update src and dst inodes blocks usage */
+		dquot_free_block(src, moved);
+		dquot_alloc_block_nofail(dst, moved);
+		err = ext4_handle_dirty_metadata(handle, NULL, pD->bh);
+		if (err)
+			goto out;
+		err = ext4_handle_dirty_metadata(handle, NULL, pS->bh);
+		if (err)
+			goto out;
+	}
+
+	/* we merged at least 1 partial branch and optionally count-1 full
+	   branches */
+	err = (count << data_ptrs_bits) -
+		(SNAPSHOT_BLOCK(iblock) & data_ptrs_mask);
+out:
+	/* count_branch_blocks may use the entire depth of S */
+	for (ks = 1; ks < depth; ks++) {
+		if (S[ks].bh)
+			brelse(S[ks].bh);
+		if (ks <= kd)
+			brelse(D[ks].bh);
+	}
+	return err < maxblocks ? err : maxblocks;
+}
+
+/*
  * ext4_snapshot_get_block_access() - called from ext4_snapshot_read_through()
  * on snapshot file access.
  * return value <0 indicates access not granted
-- 
1.7.4.1

