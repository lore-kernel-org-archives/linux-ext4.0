From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/3] ext4: add block-based file punching hole support
Date: Thu, 23 Aug 2012 12:25:39 +0800
Message-ID: <1345695941-15053-2-git-send-email-wenqing.lz@taobao.com>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2HWEPy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2012 00:15:54 -0400
In-Reply-To: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds block-based file to support punching hole feature.  In general,
ext4_ind_punch_hole is almost the same as ext4_ext_pucnh_hole.  First, we
invalidate all pages between this hole, and then we try to deallocate all blocks
of this hole.

The process of deallocating blocks looks a little complicated.  We first get the
offset of hole boundary, and then we will try to deallocate these blocks between
start and end.  There are two cases that needs to be handled.  One is that the
start and end blocks are at the same offset, and another is that they are at the
differnet offsets.  In case 1, we try to handle next level recursively.  In case
2, we need to traverse the direct blocks from start block to end block to try to
deallocate blocks.  In this case there has three situations.  The first one is
that current direct block is neither start block nor end block.  So we can call
ext4_free_branches to free this branch directly.  If current block is the start
block or the end block.  We need to try to handle next level recursively until
we reach the leaf block.  Moreover when we have deallocated a level blocks, we
will check whether upper level block should be freed or not in order to ensure
that all blocks in this hole can be freed correctly.

CC: Dave Chinner <david@fromorbit.com>
CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
I run xfstests to do some tests, and I got an error from xfstests # 255.  The
failure reason is that block-based file in ext4 cannot support fallocate(2) to
allocate an unwritten blocks.  I am not sure whether we should change # 255 in
xfstests or not.  So Cc' to Dave Chinner to get some feedbacks.

Regards,
Zheng

 fs/ext4/ext4.h     |    1 +
 fs/ext4/indirect.c |  462 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c    |    6 +-
 3 files changed, 465 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c3411d4..a4b796c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2018,6 +2018,7 @@ extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
 extern void ext4_ind_truncate(struct inode *inode);
+extern int ext4_ind_punch_hole(struct file *file, loff_t offset, loff_t length);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..76c24da 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1500,3 +1500,465 @@ out_stop:
 	trace_ext4_truncate_exit(inode);
 }
 
+static void clear_upper_direct(handle_t *handle, struct inode *inode, __le32 *p)
+{
+	ext4_free_data(handle, inode, NULL, p, p+1);
+	*p = 0;
+	ext4_mark_inode_dirty(handle, inode);
+}
+
+static void try_to_free_upper_direct(handle_t *handle, struct inode *inode,
+		struct buffer_head *next_bh, __le32 *p)
+{
+	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+
+	if (all_zeroes((__le32 *)next_bh->b_data,
+		       (__le32 *)next_bh->b_data + addr_per_block))
+		clear_upper_direct(handle, inode, p);
+}
+
+static void clear_upper_indirect(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_lblk_t nr, __le32 *p)
+{
+	if (try_to_extend_transaction(handle, inode)) {
+		ext4_mark_inode_dirty(handle, inode);
+		ext4_truncate_restart_trans(handle, inode,
+			    ext4_blocks_for_truncate(inode));
+	}
+
+	ext4_free_blocks(handle, inode, NULL, nr, 1,
+			 EXT4_FREE_BLOCKS_METADATA|
+			 EXT4_FREE_BLOCKS_FORGET);
+	if (!ext4_journal_get_write_access(handle,
+					   bh)){
+		*p = 0;
+		BUFFER_TRACE(parent_bh, "call ext4_handle_dirty_metadata");
+		ext4_handle_dirty_metadata(handle, inode, bh);
+	}
+}
+
+static void try_to_free_upper_indirect(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, struct buffer_head *next_bh,
+		ext4_lblk_t nr, __le32 *p)
+{
+	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+
+	if (ext4_handle_is_aborted(handle))
+		return;
+
+	if (all_zeroes((__le32 *)next_bh->b_data,
+		       (__le32 *)next_bh->b_data + addr_per_block))
+		clear_upper_indirect(handle, inode, bh, nr, p);
+}
+
+/*
+ * Try to free at the beginning of boundary in this hole.  This function will
+ * be called recursively until we reach the leaf indirect block.
+ */
+static void try_to_free_branches_start(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_lblk_t offsets[4],
+		int n, int level)
+{
+	struct buffer_head *next_bh;
+	__le32 *p;
+	ext4_lblk_t nr;
+	int i, depth;
+	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
+
+	if (level == n)
+		return;
+
+	for (i = offsets[level] + 1; i < addr_per_block; i++) {
+		p = (__le32 *)bh->b_data + i;
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			continue;
+
+		depth = n - level - 1;
+		ext4_free_branches(handle, inode, bh, p, p+1,
+				   depth);
+	}
+
+	p = (__le32 *)bh->b_data + offsets[level];
+	nr = le32_to_cpu(*p);
+	if (nr == 0)
+		return;
+
+	next_bh = sb_bread(inode->i_sb, nr);
+	if (!next_bh) {
+		EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+		return;
+	}
+
+	try_to_free_branches_start(handle, inode, next_bh, offsets, n,
+				   level+1);
+
+	try_to_free_upper_indirect(handle, inode, bh, next_bh, nr, p);
+
+	brelse(next_bh);
+}
+
+/*
+ * Try to free at the end of boundary in this hole.  This function will
+ * be called recursively until we reach the leaf indirect block.
+ */
+static void try_to_free_branches_end(handle_t *handle, struct inode *inode,
+		struct buffer_head *bh, ext4_lblk_t offsets[4],
+		int n, int level)
+{
+	struct buffer_head *next_bh;
+	__le32 *p;
+	ext4_lblk_t nr;
+	int i, depth;
+
+	if (level == n)
+		return;
+
+	for (i = 0; i < offsets[level]; i++) {
+		p = (__le32 *)bh->b_data + i;
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			continue;
+
+		depth = n - level - 1;
+		ext4_free_branches(handle, inode, bh, p, p+1, depth);
+	}
+
+	p = (__le32 *)bh->b_data + offsets[level];
+	nr = le32_to_cpu(*p);
+	if (nr == 0)
+		return;
+
+	next_bh = sb_bread(inode->i_sb, nr);
+	if (!next_bh) {
+		EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+		return;
+	}
+
+	try_to_free_branches_end(handle, inode, next_bh, offsets, n, level+1);
+
+	/*
+	 * we don't need to free the leaf block itself because
+	 * this block should survive.
+	 */
+	if (level + 1 == n)
+		goto out;
+
+	try_to_free_upper_indirect(handle, inode, bh, next_bh, nr, p);
+
+out:
+	brelse(next_bh);
+}
+
+/*
+ * This function is almost the same as ext4_free_hole_blocks.
+ * The difference between them is that this fucntion can be called
+ * recursively, and it is used to handle indirect blocks.
+ */
+static void try_to_free_branches(handle_t *handle, struct inode *inode,
+	struct buffer_head *bh, ext4_lblk_t offsets1[4], int n1,
+	ext4_lblk_t offsets2[4], int n2, int level)
+{
+	struct buffer_head *next_bh;
+	__le32 *p;
+	ext4_lblk_t nr;
+	int i, depth;
+
+	if (ext4_handle_is_aborted(handle))
+		return;
+
+	if (offsets1[level] == offsets2[level]) {
+		p = (__le32 *)bh->b_data + offsets1[level];
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			return;
+
+		depth = n1 - level - 1;
+
+		next_bh = sb_bread(inode->i_sb, nr);
+		if (!next_bh) {
+			EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+			return;
+		}
+
+		try_to_free_branches(handle, inode, next_bh, offsets1, n1,
+				     offsets2, n2, level+1);
+
+		try_to_free_upper_indirect(handle, inode, bh, next_bh, nr, p);
+
+		brelse(next_bh);
+
+		return;
+	}
+
+	for (i = offsets1[level]; i <= offsets2[level]; i++) {
+		p = (__le32 *)bh->b_data + i;
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			continue;
+
+		depth = n1 - level - 1;
+
+		next_bh = sb_bread(inode->i_sb, nr);
+		if (!next_bh) {
+			EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+			continue;
+		}
+
+		if (i == offsets1[level]) {
+			if (level + 1 == n1) {
+				/*
+				 * when we reach the leaf indirect block, we
+				 * should clear it in here because in
+				 * try_to_free_branches_start function we
+				 * cannot get parent buffer_head.
+				 */
+				clear_upper_indirect(handle, inode, bh, nr, p);
+				goto cont;
+			}
+			try_to_free_branches_start(handle, inode, next_bh,
+						   offsets1, n1, level+1);
+			try_to_free_upper_indirect(handle, inode, bh, next_bh,
+						   nr, p);
+		} else if (i == offsets2[level]) {
+			try_to_free_branches_end(handle, inode, next_bh,
+						 offsets2, n2, level+1);
+			try_to_free_upper_indirect(handle, inode, bh, next_bh,
+						   nr, p);
+		} else {
+			ext4_free_branches(handle, inode, bh, p, p+1, depth);
+		}
+
+cont:
+		brelse(next_bh);
+	}
+}
+
+/*
+ * Try to free blocks that are in the hole.
+ */
+static int ext4_free_hole_blocks(handle_t *handle, struct inode *inode,
+				 ext4_lblk_t offsets1[4], int n1,
+				 ext4_lblk_t offsets2[4], int n2)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct buffer_head *bh;
+	__le32 *i_data = ei->i_data;
+	__le32 *p;
+	ext4_lblk_t nr;
+	int i, depth;
+
+	if (ext4_handle_is_aborted(handle))
+		return 0;
+
+	/*
+	 * If start and end blocks are at the same offset, we only try to call
+	 * try_to_free_branches() recursively to free blocks.
+	 */
+	if (offsets1[0] == offsets2[0]) {
+		p = i_data + offsets1[0];
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			return 0;
+
+		bh = sb_bread(inode->i_sb, nr);
+		if (!bh) {
+			EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+			return -EIO;
+		}
+
+		try_to_free_branches(handle, inode, bh, offsets1, n1,
+				     offsets2, n2, 1);
+
+		try_to_free_upper_direct(handle, inode, bh, p);
+
+		brelse(bh);
+		return 0;
+	}
+
+	/*
+	 * The boundary of hole are at the different offset, we will traverse
+	 * direct block to free blocks from start to end.
+	 */
+	for (i = offsets1[0]; i <= offsets2[0]; i++) {
+		p = (__le32 *)i_data + i;
+		nr = le32_to_cpu(*p);
+		if (nr == 0)
+			continue;
+
+		depth = 0;
+		if (i >= EXT4_NDIR_BLOCKS)
+			depth = i - EXT4_NDIR_BLOCKS + 1;
+
+		bh = sb_bread(inode->i_sb, nr);
+		if (!bh) {
+			EXT4_ERROR_INODE_BLOCK(inode, nr, "Read failure");
+			continue;
+		}
+
+		if (i == offsets1[0]) {
+			/* start block */
+			if (i < EXT4_NDIR_BLOCKS) {
+				/*
+				 * if start block is a direct block, we just
+				 * need to free it in here.
+				 */
+				clear_upper_direct(handle, inode, p);
+				goto cont;
+			}
+			try_to_free_branches_start(handle, inode, bh,
+						   offsets1, n1, 1);
+			try_to_free_upper_direct(handle, inode, bh, p);
+		} else if (i == offsets2[0]) {
+			/* end block */
+			try_to_free_branches_end(handle, inode, bh,
+						 offsets2, n2, 1);
+			try_to_free_upper_direct(handle, inode, bh, p);
+		} else {
+			/* middle block */
+			ext4_free_branches(handle, inode, NULL, p, p+1, depth);
+			*p = 0;
+			ext4_mark_inode_dirty(handle, inode);
+		}
+
+cont:
+		brelse(bh);
+	}
+
+	return 0;
+}
+
+int ext4_ind_punch_hole(struct file *file, loff_t offset, loff_t length)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	ext4_lblk_t first_block, stop_block;
+	ext4_lblk_t offsets1[4], offsets2[4];
+	struct address_space *mapping = inode->i_mapping;
+	handle_t *handle;
+	loff_t first_page, last_page, page_len;
+	loff_t first_page_offset, last_page_offset;
+	int n1 = 0, n2 = 0, err = 0;
+
+	mutex_lock(&inode->i_mutex);
+
+	/* No need to punch hole beyond i_size */
+	if (offset >= inode->i_size)
+		goto error;
+
+	/*
+	 * If the hole extents beyond i_size, set the hole
+	 * to end after the page that contains i_size
+	 */
+	if (offset + length > inode->i_size) {
+		length = inode->i_size +
+		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
+		   offset;
+	}
+
+	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
+
+	first_page_offset = first_page << PAGE_CACHE_SHIFT;
+	last_page_offset = last_page << PAGE_CACHE_SHIFT;
+
+	/* Now release the pages */
+	if (last_page_offset > first_page_offset) {
+		truncate_pagecache_range(inode, first_page_offset,
+					 last_page_offset - 1);
+	}
+
+	handle = start_transaction(inode);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	/*
+	 * Now we need to zero out the non-page-aligned data in the
+	 * pages at the start and tail of the hole, and unmap the buffer
+	 * heads for the block aligned regions of the page that were
+	 * completely zeroed.
+	 */
+	if (first_page > last_page) {
+		/*
+		 * If the file space being truncated is contained within a page
+		 * just zero out and unmap the middle of that page
+		 */
+		err = ext4_discard_partial_page_buffers(handle,
+			mapping, offset, length, 0);
+	} else {
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the start of the hole
+		 */
+		page_len = first_page_offset - offset;
+		if (page_len > 0) {
+			err = ext4_discard_partial_page_buffers(handle, mapping,
+							offset, page_len, 0);
+			if (err)
+				goto out;
+		}
+
+		/*
+		 * zero out and unmap the partial page that contains
+		 * the end of the hole
+		 */
+		page_len = offset + length - last_page_offset;
+		if (page_len > 0) {
+			err = ext4_discard_partial_page_buffers(handle, mapping,
+							offset, page_len, 0);
+			if (err)
+				goto out;
+		}
+	}
+
+	/*
+	 * If i_size is contained in the last page, we need to
+	 * unmap and zero the partial page after i_size
+	 */
+	if (inode->i_size >> PAGE_CACHE_SHIFT == last_page &&
+	    inode->i_size % PAGE_CACHE_SIZE != 0) {
+
+		page_len = PAGE_CACHE_SIZE -
+			(inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		if (page_len > 0) {
+			err = ext4_discard_partial_page_buffers(handle, mapping,
+							offset, page_len, 0);
+			if (err)
+				goto out;
+		}
+	}
+
+	first_block = (offset + sb->s_blocksize - 1) >>
+		EXT4_BLOCK_SIZE_BITS(sb);
+	stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
+
+	if (first_block >= stop_block)
+		goto out;
+
+	n1 = ext4_block_to_path(inode, first_block, offsets1, NULL);
+	if (n1 == 0)
+		goto out;
+	n2 = ext4_block_to_path(inode, stop_block, offsets2, NULL);
+	if (n2 == 0)
+		goto out;
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_discard_preallocations(inode);
+
+	err = ext4_free_hole_blocks(handle, inode, offsets1, n1, offsets2, n2);
+
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+
+	up_write(&EXT4_I(inode)->i_data_sem);
+
+out:
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+error:
+	mutex_unlock(&inode->i_mutex);
+	return err;
+}
+
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dff171c..dde62e0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3495,10 +3495,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		/* TODO: Add support for non extent hole punching */
-		return -EOPNOTSUPP;
-	}
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return ext4_ind_punch_hole(file, offset, length);
 
 	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
 		/* TODO: Add support for bigalloc file systems */
-- 
1.7.4.1

