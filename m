From: amir73il@users.sourceforge.net
Subject: [PATCH v1 16/36] ext4: snapshot block operation - move blocks to snapshot
Date: Tue,  7 Jun 2011 18:07:43 +0300
Message-ID: <1307459283-22130-17-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:39 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:39 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Implementation of moving blocks into a snapshot file.
The move block command maps an allocated blocks to the snapshot file,
allocating only the indirect blocks when needed.
This mechanism is used to move-on-write data blocks to snapshot.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c    |   62 +++++++++++++++++++-------
 fs/ext4/snapshot.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot.h |   12 +++++-
 3 files changed, 176 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cdc1752..1558a7b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -676,6 +676,11 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			new_blocks[index++] = current_block++;
 			count--;
 		}
+		if (blks == 0 && target == 0) {
+			/* mapping data blocks */
+			*err = 0;
+			return 0;
+		}
 		if (count > 0) {
 			/*
 			 * save the new block number
@@ -777,10 +782,10 @@ failed_out:
  *	ext4_alloc_block() (normally -ENOSPC). Otherwise we set the chain
  *	as described above and return 0.
  */
-static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
-			     ext4_lblk_t iblock, int indirect_blks,
-			     int *blks, ext4_fsblk_t goal,
-			     ext4_lblk_t *offsets, Indirect *branch)
+static int ext4_alloc_branch_cow(handle_t *handle, struct inode *inode,
+			ext4_fsblk_t iblock, int indirect_blks,
+				  int *blks, ext4_fsblk_t goal,
+				  int *offsets, Indirect *branch, int flags)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -790,6 +795,22 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t new_blocks[4];
 	ext4_fsblk_t current_block;
 
+	if (SNAPMAP_ISMOVE(flags)) {
+		/* mapping snapshot block to block device block */
+		current_block = SNAPSHOT_BLOCK(iblock);
+		num = 0;
+		if (indirect_blks > 0) {
+			/* allocating only indirect blocks */
+			ext4_alloc_blocks(handle, inode, iblock, goal,
+					  indirect_blks, 0, new_blocks, &err);
+			if (err)
+				return err;
+		}
+		/* charge snapshot file owner for moved blocks */
+		dquot_alloc_block_nofail(inode, *blks);
+		num = *blks;
+		new_blocks[indirect_blks] = current_block;
+	} else
 	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
 				*blks, new_blocks, &err);
 	if (err)
@@ -861,8 +882,11 @@ failed:
 	}
 	for (i = n+1; i < indirect_blks; i++)
 		ext4_free_blocks(handle, inode, NULL, new_blocks[i], 1, 0);
-
-	ext4_free_blocks(handle, inode, NULL, new_blocks[i], num, 0);
+	if (SNAPMAP_ISMOVE(flags) && num > 0)
+		/* don't charge snapshot file owner if move failed */
+		dquot_free_block(inode, num);
+	else if (num > 0)
+		ext4_free_blocks(handle, inode, NULL, new_blocks[i], num, 0);
 
 	return err;
 }
@@ -882,9 +906,8 @@ failed:
  * inode (->i_blocks, etc.). In case of success we end up with the full
  * chain to new block and return 0.
  */
-static int ext4_splice_branch(handle_t *handle, struct inode *inode,
-			      ext4_lblk_t block, Indirect *where, int num,
-			      int blks)
+static int ext4_splice_branch_cow(handle_t *handle, struct inode *inode,
+		long block, Indirect *where, int num, int blks, int flags)
 {
 	int i;
 	int err = 0;
@@ -951,8 +974,12 @@ err_out:
 		ext4_free_blocks(handle, inode, where[i].bh, 0, 1,
 				 EXT4_FREE_BLOCKS_FORGET);
 	}
-	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(where[num].key),
-			 blks, 0);
+	if (SNAPMAP_ISMOVE(flags))
+		/* don't charge snapshot file owner if move failed */
+		dquot_free_block(inode, blks);
+	else
+		ext4_free_blocks(handle, inode, NULL,
+				 le32_to_cpu(where[num].key), blks, 0);
 
 	return err;
 }
@@ -1099,9 +1126,11 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	/*
 	 * Block out ext4_truncate while we alter the tree
 	 */
-	err = ext4_alloc_branch(handle, inode, map->m_lblk, indirect_blks,
-				&count, goal,
-				offsets + (partial - chain), partial);
+	err = ext4_alloc_branch_cow(handle, inode, map->m_lblk, indirect_blks,
+				     &count, goal, offsets + (partial - chain),
+				     partial, flags);
+	if (err)
+		goto cleanup;
 
 	if (map->m_flags & EXT4_MAP_REMAP) {
 		map->m_len = count;
@@ -1127,9 +1156,8 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	 * credits cannot be returned.  Can we handle this somehow?  We
 	 * may need to return -EAGAIN upwards in the worst case.  --sct
 	 */
-	if (!err)
-		err = ext4_splice_branch(handle, inode, map->m_lblk,
-					 partial, indirect_blks, count);
+	err = ext4_splice_branch_cow(handle, inode, map->m_lblk, partial,
+				     indirect_blks, count, flags);
 	if (err)
 		goto cleanup;
 
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index fc91ca4..adeb0b6 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -328,3 +328,123 @@ out:
 	return err;
 }
 
+/*
+ * ext4_snapshot_test_and_move - move blocks to active snapshot
+ * @where:	name of caller function
+ * @handle:	JBD handle
+ * @inode:	owner of blocks (NULL for global metadata blocks)
+ * @block:	address of first block to move
+ * @maxblocks:	max. blocks to move
+ * @move:	if false, only test if @block needs to be moved
+ *
+ * Return values:
+ * > 0 - blocks a) were moved to snapshot for @move = 1;
+ *		b) needs to be moved for @move = 0
+ * = 0 - blocks dont need to be moved
+ * < 0 - error
+ */
+int ext4_snapshot_test_and_move(const char *where, handle_t *handle,
+	struct inode *inode, ext4_fsblk_t block, int *maxblocks, int move)
+{
+	struct super_block *sb = handle->h_transaction->t_journal->j_private;
+	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
+	ext4_fsblk_t blk = 0;
+	int err = 0, count = *maxblocks;
+	int moved_blks = 0;
+	int excluded = 0;
+
+	if (!active_snapshot)
+		/* no active snapshot - no need to move */
+		return 0;
+
+	ext4_snapshot_trace_cow(where, handle, sb, inode, NULL, block, count,
+				move);
+
+	BUG_ON(IS_COWING(handle) || inode == active_snapshot);
+
+	/* BEGIN moving */
+	ext4_snapshot_cow_begin(handle);
+
+	if (inode)
+		excluded = ext4_snapshot_excluded(inode);
+	if (excluded) {
+		/* don't move excluded file block to snapshot */
+		snapshot_debug_hl(4, "file (%lu) excluded from snapshot\n",
+				inode->i_ino);
+		move = 0;
+	}
+
+	if (excluded)
+		goto out;
+	if (!err) {
+		/* block not in COW bitmap - no need to move */
+		trace_cow_add(handle, ok_bitmap, count);
+		goto out;
+	}
+
+#ifdef CONFIG_EXT4_DEBUG
+	if (inode == NULL &&
+		!(EXT4_I(active_snapshot)->i_flags & EXT4_UNRM_FL)) {
+		/*
+		 * This is ext4_group_extend() "freeing" the blocks that
+		 * were added to the block group.  These block should not be
+		 * moved to snapshot, unless the snapshot is marked with the
+		 * UNRM flag for large snapshot creation test.
+		 */
+		trace_cow_add(handle, ok_bitmap, count);
+		err = 0;
+		goto out;
+	}
+#endif
+
+	/* count blocks are in use by snapshot - check if @block is mapped */
+	err = ext4_snapshot_map_blocks(handle, active_snapshot, block, count,
+					&blk, SNAPMAP_READ);
+	if (err < 0)
+		goto out;
+	if (err > 0) {
+		/* blocks already mapped in snapshot - no need to move */
+		count = err;
+		trace_cow_add(handle, ok_mapped, count);
+		err = 0;
+		goto out;
+	}
+
+	/* @count blocks need to be moved */
+	err = count;
+	if (!move)
+		/* don't move - we were just checking */
+		goto out;
+
+	/* try to move @count blocks from inode to snapshot.
+	 * @count blocks may cross block boundry.
+	 * TODO: if moving fails after some blocks has been moved,
+	 * maybe we need a blockbitmap fsck.
+	 */
+	blk = block;
+	while (count) {
+		err = ext4_snapshot_map_blocks(handle, active_snapshot, blk,
+					count, NULL, SNAPMAP_MOVE);
+		if (err <= 0)
+			goto out;
+		moved_blks += err;
+		blk += err;
+		count -= err;
+	}
+	count = moved_blks;
+	err = moved_blks;
+	/*
+	 * User should no longer be charged for these blocks.
+	 * Snapshot file owner was charged for these blocks
+	 * when they were mapped to snapshot file.
+	 */
+	if (inode)
+		dquot_free_block(inode, count);
+	trace_cow_add(handle, moved, count);
+out:
+	/* END moving */
+	ext4_snapshot_cow_end(where, handle, block, err);
+	*maxblocks = count;
+	return err;
+}
+
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 90cb33e..fc5dbec 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -186,7 +186,17 @@ extern int ext4_snapshot_test_and_cow(const char *where,
 	ext4_snapshot_test_and_cow(__func__, handle, inode,	\
 			block, bh, cow)
 
-#define ext4_snapshot_move(handle, inode, block, pcount, move) (0)
+extern int ext4_snapshot_test_and_move(const char *where,
+		handle_t *handle, struct inode *inode,
+		ext4_fsblk_t block, int *pcount, int move);
+
+/*
+ * test if blocks should be moved to snapshot
+ * and if they should, try to move them to the active snapshot
+ */
+#define ext4_snapshot_move(handle, inode, block, pcount, move)	\
+	ext4_snapshot_test_and_move(__func__, handle, inode,	\
+			block, pcount, move)
 
 /*
  * Block access functions
-- 
1.7.4.1

