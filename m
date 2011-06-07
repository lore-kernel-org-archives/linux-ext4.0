From: amir73il@users.sourceforge.net
Subject: [PATCH v1 19/36] ext4: snapshot control - init new snapshot
Date: Tue,  7 Jun 2011 18:07:46 +0300
Message-ID: <1307459283-22130-20-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:50 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:50 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On snapshot create, a few special blocks (i.e., the super block and
group descriptors) are pre-allocated and on snapshot take, they are
copied under journal_lock_updates().  This is done to avoid the
recursion that would be caused by COWing these blocks after the
snapshot becomes active.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot_ctl.c |  308 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 308 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index f2dbef4..9d915a9 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -299,6 +299,48 @@ int __extend_or_restart_transaction(const char *where,
 #define extend_or_restart_transaction_inode(handle, inode, nblocks)	\
 	__extend_or_restart_transaction(__func__, (handle), (inode), (nblocks))
 
+/*
+ * helper function for snapshot_create().
+ * places pre-allocated [d,t]ind blocks in position
+ * after they have been allocated as direct blocks.
+ */
+static inline int ext4_snapshot_shift_blocks(struct ext4_inode_info *ei,
+		int from, int to, int count)
+{
+	int i, err = -EIO;
+
+	/* move from direct blocks range */
+	BUG_ON(from < 0 || from + count > EXT4_NDIR_BLOCKS);
+	/* to indirect blocks range */
+	BUG_ON(to < EXT4_NDIR_BLOCKS || to + count > EXT4_SNAPSHOT_N_BLOCKS);
+
+	/*
+	 * truncate_mutex is held whenever allocating or freeing inode
+	 * blocks.
+	 */
+	down_write(&ei->i_data_sem);
+
+	/*
+	 * verify that 'from' blocks are allocated
+	 * and that 'to' blocks are not allocated.
+	 */
+	for (i = 0; i < count; i++)
+		if (!ei->i_data[from+i] ||
+				ei->i_data[(to+i)%EXT4_N_BLOCKS])
+			goto out;
+
+	/*
+	 * shift 'count' blocks from position 'from' to 'to'
+	 */
+	for (i = 0; i < count; i++) {
+		ei->i_data[(to+i)%EXT4_N_BLOCKS] = ei->i_data[from+i];
+		ei->i_data[from+i] = 0;
+	}
+	err = 0;
+out:
+	up_write(&ei->i_data_sem);
+	return err;
+}
 
 static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
 					 unsigned long ino,
@@ -344,6 +386,13 @@ static int ext4_snapshot_create(struct inode *inode)
 	struct inode *active_snapshot = ext4_snapshot_has_active(sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int i, err, ret;
+	int count, nind;
+	const long double_blocks = (1 << (2 * SNAPSHOT_ADDR_PER_BLOCK_BITS));
+	struct buffer_head *bh = NULL;
+	struct ext4_group_desc *desc;
+	unsigned long ino;
+	struct ext4_iloc iloc;
+	ext4_fsblk_t bmap_blk = 0, imap_blk = 0, inode_blk = 0;
 	ext4_fsblk_t snapshot_blocks = ext4_blocks_count(sbi->s_es);
 	if (active_snapshot) {
 		snapshot_debug(1, "failed to add snapshot because active "
@@ -418,6 +467,140 @@ static int ext4_snapshot_create(struct inode *inode)
 	if (err)
 		goto out_handle;
 
+	/* small filesystems can be mapped with just 1 double indirect block */
+	nind = 1;
+	if (snapshot_blocks > double_blocks)
+		/* add up to 4 triple indirect blocks to map 2^32 blocks */
+		nind += ((snapshot_blocks - double_blocks) >>
+			(3 * SNAPSHOT_ADDR_PER_BLOCK_BITS)) + 1;
+	if (nind > 2 + EXT4_SNAPSHOT_EXTRA_TIND_BLOCKS) {
+		snapshot_debug(1, "need too many [d,t]ind blocks (%d) "
+				"for snapshot (%u)\n",
+				nind, inode->i_generation);
+		err = -EFBIG;
+		goto out_handle;
+	}
+
+	err = extend_or_restart_transaction_inode(handle, inode,
+			nind * EXT4_DATA_TRANS_BLOCKS(sb));
+	if (err)
+		goto out_handle;
+
+	/* pre-allocate and zero out [d,t]ind blocks */
+	for (i = 0; i < nind; i++) {
+		brelse(bh);
+		bh = ext4_getblk(handle, inode, i, SNAPMAP_WRITE, &err);
+		if (!bh)
+			break;
+		/* zero out indirect block and journal as dirty metadata */
+		err = ext4_journal_get_write_access(handle, bh);
+		if (err)
+			break;
+		lock_buffer(bh);
+		memset(bh->b_data, 0, bh->b_size);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		err = ext4_handle_dirty_metadata(handle, NULL, bh);
+		if (err)
+			break;
+	}
+	brelse(bh);
+	if (!bh || err) {
+		snapshot_debug(1, "failed to initiate [d,t]ind block (%d) "
+				"for snapshot (%u)\n",
+				i, inode->i_generation);
+		goto out_handle;
+	}
+	/* place pre-allocated [d,t]ind blocks in position */
+	err = ext4_snapshot_shift_blocks(ei, 0, EXT4_DIND_BLOCK, nind);
+	if (err) {
+		snapshot_debug(1, "failed to move pre-allocated [d,t]ind blocks"
+				" for snapshot (%u)\n",
+				inode->i_generation);
+		goto out_handle;
+	}
+
+	/* allocate super block and group descriptors for snapshot */
+	count = sbi->s_gdb_count + 1;
+	err = count;
+	for (i = 0; err > 0 && i < count; i += err) {
+		err = extend_or_restart_transaction_inode(handle, inode,
+				EXT4_DATA_TRANS_BLOCKS(sb));
+		if (err)
+			goto out_handle;
+		err = ext4_snapshot_map_blocks(handle, inode, i, count - i,
+						NULL, SNAPMAP_WRITE);
+	}
+	if (err <= 0) {
+		snapshot_debug(1, "failed to allocate super block and %d "
+			       "group descriptor blocks for snapshot (%u)\n",
+			       count - 1, inode->i_generation);
+		if (err)
+			err = -EIO;
+		goto out_handle;
+	}
+
+	ino = inode->i_ino;
+	/*
+	 * pre-allocate the following blocks in the new snapshot:
+	 * - block and inode bitmap blocks of ino's block group
+	 * - inode table block that contains ino
+	 */
+	err = extend_or_restart_transaction_inode(handle, inode,
+			3 * EXT4_DATA_TRANS_BLOCKS(sb));
+	if (err)
+		goto out_handle;
+
+	inode_blk = ext4_get_inode_block(sb, ino, &iloc);
+
+	bmap_blk = 0;
+	imap_blk = 0;
+	desc = ext4_get_group_desc(sb, iloc.block_group, NULL);
+	if (!desc)
+		goto next_snapshot;
+
+	bmap_blk = ext4_block_bitmap(sb, desc);
+	imap_blk = ext4_inode_bitmap(sb, desc);
+	if (!bmap_blk || !imap_blk)
+		goto next_snapshot;
+
+	count = 1;
+	if (imap_blk == bmap_blk + 1)
+		count++;
+	if ((count > 1) && (inode_blk == imap_blk + 1))
+		count++;
+	/* try to allocate all blocks at once */
+	err = ext4_snapshot_map_blocks(handle, inode,
+			bmap_blk, count,
+			NULL, SNAPMAP_WRITE);
+	count = err;
+	/* allocate remaining blocks one by one */
+	if (err > 0 && count < 2)
+		err = ext4_snapshot_map_blocks(handle, inode,
+				imap_blk, 1,
+				NULL,
+				SNAPMAP_WRITE);
+	if (err > 0 && count < 3)
+		err = ext4_snapshot_map_blocks(handle, inode,
+				inode_blk, 1,
+				NULL,
+				SNAPMAP_WRITE);
+next_snapshot:
+	if (!bmap_blk || !imap_blk || !inode_blk || err < 0) {
+#ifdef CONFIG_EXT4_DEBUG
+		ext4_fsblk_t blk0 = iloc.block_group *
+			EXT4_BLOCKS_PER_GROUP(sb);
+		snapshot_debug(1, "failed to allocate block/inode bitmap "
+				"or inode table block of inode (%lu) "
+				"(%llu,%llu,%llu/%u) for snapshot (%u)\n",
+				ino, bmap_blk - blk0,
+				imap_blk - blk0, inode_blk - blk0,
+				iloc.block_group, inode->i_generation);
+#endif
+		if (!err)
+			err = -EIO;
+		goto out_handle;
+	}
 	snapshot_debug(1, "snapshot (%u) created\n", inode->i_generation);
 	err = 0;
 out_handle:
@@ -427,6 +610,68 @@ out_handle:
 	return err;
 }
 
+/*
+ * ext4_snapshot_copy_block() - copy block to new snapshot
+ * @snapshot:	new snapshot to copy block to
+ * @bh:		source buffer to be copied
+ * @mask:	if not NULL, mask buffer data before copying to snapshot
+ *		(used to mask block bitmap with exclude bitmap)
+ * @name:	name of copied block to print
+ * @idx:	index of copied block to print
+ *
+ * Called from ext4_snapshot_take() under journal_lock_updates()
+ * Returns snapshot buffer on success, NULL on error
+ */
+static struct buffer_head *ext4_snapshot_copy_block(struct inode *snapshot,
+		struct buffer_head *bh, const char *mask,
+		const char *name, unsigned long idx)
+{
+	struct buffer_head *sbh = NULL;
+	int err;
+
+	if (!bh)
+		return NULL;
+
+	sbh = ext4_getblk(NULL, snapshot,
+			SNAPSHOT_IBLOCK(bh->b_blocknr),
+			SNAPMAP_READ, &err);
+
+	if (!sbh || sbh->b_blocknr == bh->b_blocknr) {
+		snapshot_debug(1, "failed to copy %s (%lu) "
+				"block [%llu/%llu] to snapshot (%u)\n",
+				name, idx,
+				SNAPSHOT_BLOCK_TUPLE(bh->b_blocknr),
+				snapshot->i_generation);
+		brelse(sbh);
+		return NULL;
+	}
+
+	ext4_snapshot_copy_buffer(sbh, bh, mask);
+
+	snapshot_debug(4, "copied %s (%lu) block [%llu/%llu] "
+			"to snapshot (%u)\n",
+			name, idx,
+			SNAPSHOT_BLOCK_TUPLE(bh->b_blocknr),
+			snapshot->i_generation);
+	return sbh;
+}
+
+/*
+ * List of blocks which are copied to snapshot for every special inode.
+ * Keep block bitmap first and inode table block last in the list.
+ */
+enum copy_inode_block {
+	COPY_BLOCK_BITMAP,
+	COPY_INODE_BITMAP,
+	COPY_INODE_TABLE,
+	COPY_INODE_BLOCKS_NUM
+};
+
+static char *copy_inode_block_name[COPY_INODE_BLOCKS_NUM] = {
+	"block bitmap",
+	"inode bitmap",
+	"inode table"
+};
 
 /*
  * ext4_snapshot_take() makes a new snapshot file
@@ -443,6 +688,12 @@ int ext4_snapshot_take(struct inode *inode)
 	struct ext4_super_block *es = NULL;
 	struct buffer_head *es_bh = NULL;
 	struct buffer_head *sbh = NULL;
+	struct buffer_head *bhs[COPY_INODE_BLOCKS_NUM] = { NULL };
+	const char *mask = NULL;
+	struct inode *curr_inode;
+	struct ext4_iloc iloc;
+	struct ext4_group_desc *desc;
+	int i;
 	int err = -EIO;
 
 	if (!sbi->s_sbh)
@@ -489,6 +740,61 @@ int ext4_snapshot_take(struct inode *inode)
 	}
 #endif
 
+	/*
+	 * copy group descriptors to snapshot
+	 */
+	for (i = 0; i < sbi->s_gdb_count; i++) {
+		brelse(sbh);
+		sbh = ext4_snapshot_copy_block(inode,
+				sbi->s_group_desc[i], NULL,
+				"GDT", i);
+		if (!sbh)
+			goto out_unlockfs;
+	}
+
+	curr_inode = inode;
+	/*
+	 * copy the following blocks to the new snapshot:
+	 * - block and inode bitmap blocks of curr_inode block group
+	 * - inode table block that contains curr_inode
+	 */
+	iloc.block_group = 0;
+	err = ext4_get_inode_loc(curr_inode, &iloc);
+	brelse(bhs[COPY_INODE_TABLE]);
+	bhs[COPY_INODE_TABLE] = iloc.bh;
+	desc = ext4_get_group_desc(sb, iloc.block_group, NULL);
+	if (err || !desc) {
+		snapshot_debug(1, "failed to read inode and bitmap blocks "
+			       "of inode (%lu)\n", curr_inode->i_ino);
+		err = err ? : -EIO;
+		goto out_unlockfs;
+	}
+	brelse(bhs[COPY_BLOCK_BITMAP]);
+	bhs[COPY_BLOCK_BITMAP] = sb_bread(sb,
+			ext4_block_bitmap(sb, desc));
+	brelse(bhs[COPY_INODE_BITMAP]);
+	bhs[COPY_INODE_BITMAP] = sb_bread(sb,
+			ext4_inode_bitmap(sb, desc));
+	err = -EIO;
+	for (i = 0; i < COPY_INODE_BLOCKS_NUM; i++) {
+		brelse(sbh);
+		sbh = ext4_snapshot_copy_block(inode, bhs[i], mask,
+				copy_inode_block_name[i], curr_inode->i_ino);
+		if (!sbh)
+			goto out_unlockfs;
+		mask = NULL;
+	}
+
+	/*
+	 * copy super block to snapshot and fix it
+	 */
+	lock_buffer(es_bh);
+	memcpy(es_bh->b_data, sbi->s_sbh->b_data, sb->s_blocksize);
+	set_buffer_uptodate(es_bh);
+	unlock_buffer(es_bh);
+	mark_buffer_dirty(es_bh);
+	sync_dirty_buffer(es_bh);
+
 
 	/* reset i_size and invalidate page cache */
 	SNAPSHOT_SET_DISABLED(inode);
@@ -523,6 +829,8 @@ out_unlockfs:
 out_err:
 	brelse(es_bh);
 	brelse(sbh);
+	for (i = 0; i < COPY_INODE_BLOCKS_NUM; i++)
+		brelse(bhs[i]);
 	return err;
 }
 
-- 
1.7.4.1

