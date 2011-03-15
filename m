From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 5/5] Ext4 Punch Hole Support: Enable Punch Hole
Date: Tue, 15 Mar 2011 14:18:48 -0700
Message-ID: <4D7FD7B8.8060806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:32852 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1COVSt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 17:18:49 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2FL5qdV021346
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:05:52 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2FLImE3113760
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:48 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2FLImYE001510
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:48 -0600
Received: from [127.0.0.1] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.120])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2FLIlQX001498
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:18:48 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the  new "ext4_punch_hole" "ext4_ext_punch_hole" routines.

fallocate has been modified to call ext4_punch_hole when the punch hole
flag is passed.  At the moment, we only support punching holes in
extents, so this routine is pretty much a wrapper for the ext4_ext_punch_hole
routine.

The ext4_ext_punch_hole routine completes all outstanding writes
with the associated pages, and then releases them.  The unblock
aligned data is zeroed, and all blocks in between are identified
as mapped or already punched out. Mapped blocks are then punched
out using the "ext4_ext_release_blocks" routine

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 c722e31... fe92010... M	fs/ext4/ext4.h
:100644 100644 a46d3d7... 2d0544c... M	fs/ext4/extents.c
:100644 100644 78c5bc4... b72b20f... M	fs/ext4/inode.c
 fs/ext4/ext4.h    |    3 +
 fs/ext4/extents.c |  179 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/inode.c   |   26 ++++++++
 3 files changed, 204 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c722e31..fe92010 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1729,6 +1729,7 @@ extern int ext4_change_inode_journal_flag(struct inode *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_can_truncate(struct inode *inode);
 extern void ext4_truncate(struct inode *);
+extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
 extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
@@ -2066,6 +2067,8 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
 extern void ext4_ext_truncate(struct inode *);
+extern int ext4_ext_punch_hole(struct file *file, loff_t offset,
+				loff_t length);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a46d3d7..2d0544c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3992,10 +3992,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 -	/* We only support the FALLOC_FL_KEEP_SIZE mode */
-	if (mode & ~FALLOC_FL_KEEP_SIZE)
-		return -EOPNOTSUPP;
-
 	/*
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
@@ -4003,6 +3999,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EOPNOTSUPP;
 +	/* Return error if mode is not supported */
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+		return -EOPNOTSUPP;
+
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		return ext4_punch_hole(file, offset, len);
+
 	map.m_lblk = offset >> blkbits;
 	/*
 	 * We can't just convert len to max_blocks because
@@ -4531,3 +4534,171 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	return error;
 }
 +/*
+ * ext4_ext_punch_hole
+ *
+ * Punches a hole of "length" bytes in a file starting
+ * at byte "offset"
+ *
+ * @inode:  The inode of the file to punch a hole in
+ * @offset: The starting byte offset of the hole
+ * @length: The length of the hole
+ *
+ * Returns the number of blocks removed or negative on err
+ */
+int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	ext4_lblk_t first_block, last_block, num_blocks, iblock;
+	ext4_lblk_t fe_logical_block, fe_length_blocks;
+	struct address_space *mapping = inode->i_mapping;
+	struct ext4_map_blocks map;
+	handle_t *handle;
+	loff_t first_block_offset, last_block_offset, block_len;
+	loff_t first_page, last_page, first_page_offset, last_page_offset;
+	int err, credits, blocks_removed, ret = 0;
+
+	struct fiemap_extent_info fieinfo;
+	struct fiemap_extent fie_extent;
+
+	first_block = (offset + sb->s_blocksize - 1)
+			>> EXT4_BLOCK_SIZE_BITS(sb);
+	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
+
+	first_block_offset = first_block
+			<< EXT4_BLOCK_SIZE_BITS(sb);
+	last_block_offset = last_block << EXT4_BLOCK_SIZE_BITS(sb);
+
+	first_page = (offset + PAGE_CACHE_SIZE - 1)
+			>> PAGE_CACHE_SHIFT;
+	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
+
+	first_page_offset = first_page
+			<< PAGE_CACHE_SHIFT;
+	last_page_offset = last_page << PAGE_CACHE_SHIFT;
+
+	/*
+	 * Write out all dirty pages to avoid race conditions
+	 * Then release them.
+	 */
+	if (last_page_offset > first_page_offset) {
+		err = filemap_write_and_wait_range(mapping,
+			first_page_offset, last_page_offset-1);
+		if (err)
+			return err;
+
+		truncate_inode_pages_range(mapping, first_page_offset,
+			last_page_offset-1);
+
+	}
+
+	credits = ext4_writepage_trans_blocks(inode);
+	handle = ext4_journal_start(inode, credits);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	/*
+	 * Now we need to zero out the un block aligned data.
+	 * If the file is smaller than a block, just
+	 * zero out the middle and return
+	 */
+	if (first_block > last_block)
+		ext4_block_zero_page_range(handle, mapping, offset, length);
+	else {
+		/* zero out the head of the hole before the first block */
+		block_len  = first_block_offset - offset;
+		if (block_len > 0)
+			ext4_block_zero_page_range(handle, mapping,
+				offset, block_len);
+
+		/* zero out the tail of the hole after the last block */
+		block_len = offset + length - last_block_offset;
+		if (block_len > 0) {
+			ext4_block_zero_page_range(handle, mapping,
+				last_block_offset, block_len);
+		}
+	}
+
+	/* If there are no blocks to remove, return now */
+	if (first_block >= last_block) {
+		ext4_journal_stop(handle);
+		return 0;
+	}
+
+	/*
+	 * Loop over all the blocks and identify blocks
+	 * that need to be punched out
+	 */
+	iblock = first_block;
+	while (iblock < last_block) {
+
+		memset(&map, 0, sizeof(map));
+		map.m_lblk = iblock;
+		map.m_len = last_block - iblock;
+		ret = ext4_map_blocks(handle, inode, &map, 0);
+
+		/* If the blocks are mapped, release them */
+		if (ret > 0) {
+			num_blocks = ret;
+			ext4_ext_convert_blocks_uninit(handle, inode,
+				iblock, num_blocks);
+			ext4_ext_release_blocks(inode, iblock,
+				iblock + num_blocks);
+			blocks_removed += num_blocks;
+			goto next;
+		}
+
+		/*
+		 * If map blocks could not look up the blocks
+		 * use fiemap to see if they are already
+		 * punched out
+		 */
+		memset(&fieinfo, 0, sizeof(fieinfo));
+		memset(&fie_extent, 0, sizeof(fie_extent));
+		fieinfo.fi_extents_start = &fie_extent;
+		fieinfo.fi_extents_max = 1;
+
+		err = ext4_ext_walk_space(inode, iblock, last_block-iblock,
+				ext4_ext_fiemap_cb_kern, &fieinfo);
+
+		if (err < 0) {
+			/*
+			 * If the block cannot be
+			 * identified then skip it
+			 */
+			ext_debug("hole lookup err: %d", err);
+			num_blocks = 1;
+			goto next;
+		}
+		if (fieinfo.fi_extents_mapped < 1) {
+			/*
+			 * None of the remaining blocks
+			 * are mapped, so quit now
+			 */
+			break;
+		}
+
+		fe_logical_block =  fie_extent.fe_logical
+			>> EXT4_BLOCK_SIZE_BITS(sb);
+		fe_length_blocks = fie_extent.fe_length
+			>> EXT4_BLOCK_SIZE_BITS(sb);
+
+		/* Advance past holes to the next mapped block */
+		if (fe_logical_block > iblock)
+			num_blocks = fe_logical_block - iblock;
+		else {
+			ext_debug("hole lookup err: "
+				"iblock: %lu, fe_logical_block: %lu",
+				iblock, fe_logical_block);
+			num_blocks = 1;
+		}
+
+next:
+		iblock += num_blocks;
+	}
+	ext4_mark_inode_dirty(handle, inode);
+
+	ext4_journal_stop(handle);
+	return 0;
+}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 78c5bc4..b72b20f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4406,6 +4406,32 @@ int ext4_can_truncate(struct inode *inode)
 }
  /*
+ * ext4_punch_hole: punches a hole in a file by releaseing the blocks
+ * associated with the given offset and length
+ *
+ * @inode:  File inode
+ * @offset: The offset where the hole will begin
+ * @len:    The length of the hole
+ *
+ * Returns: 0 on sucess or negative on failure
+ */
+
+int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	if (!S_ISREG(inode->i_mode))
+		return -ENOTSUPP;
+
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		/* TODO: Add support for non extent hole punching */
+		return -ENOTSUPP;
+	}
+
+	ext4_ext_punch_hole(file, offset, length);
+	return 0;
+}
+
+/*
  * ext4_truncate()
  *
  * We block out ext4_get_block() block instantiations across the entire
-- 
1.7.1


