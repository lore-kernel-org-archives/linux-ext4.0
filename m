From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 2/2 V2] Direct IO for holes and fallocate: unwritten
 extents spt for DIO
Date: Wed, 12 Aug 2009 08:57:27 -0700
Message-ID: <1250092648.18329.30.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:37970 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZHLP5i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2009 11:57:38 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7CFqedA026962
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:52:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7CFvUqX217868
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:57:31 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7CFvTEn024428
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 09:57:30 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Version2 of the patch, fixing issues found with fsstress tests. We
should not merge neighbor extents when do unwritten extents split for
DIO before submit the IO.

handling unwritten extents lookup/map/convert for direct IO request.

For already fallocated extent, at the time DIO get_block() is called,
ext4 will split the fallocated extent as necessary, mark the to-write
fallocated extent mapped but still remains unwritten. Need to insert the
splitted extents, to prevent ENOSPC later.

At the time all IO has completed, end_io call back function will mark
the unwritten extent as written.

Patch against ext4 patch queue.

Comments? 

Singed-Off-By: Mingming Cao <cmm@us.ibm.com> 
---
 fs/ext4/ext4_extents.h |    5 
 fs/ext4/extents.c      |  401 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 377 insertions(+), 29 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/ext4_extents.h
+++ linux-2.6.31-rc4/fs/ext4/ext4_extents.h
@@ -219,6 +219,11 @@ static inline int ext4_ext_get_actual_le
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
+static inline void ext4_ext_mark_initialized(struct ext4_extent *ext)
+{
+	ext->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ext));
+}
+
 extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
 extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
@@ -229,7 +234,7 @@ extern int ext4_ext_calc_credits_for_sin
 						   struct ext4_ext_path *path);
 extern int ext4_can_extents_be_merged(struct inode *inode,
 				      struct ext4_extent *ex1,
-				      struct ext4_extent *ex2);
+				      struct ext4_extent *ex2, int flag);
 extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -1425,10 +1425,12 @@ static int ext4_ext_correct_indexes(hand
 
 int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
-				struct ext4_extent *ex2)
+				struct ext4_extent *ex2, int flag)
 {
 	unsigned short ext1_ee_len, ext2_ee_len, max_len;
 
+	if (flag == EXT4_GET_BLOCKS_DIO_CREATE_EXT)
+		return 0;
 	/*
 	 * Make sure that either both extents are uninitialized, or
 	 * both are _not_.
@@ -1486,7 +1488,7 @@ int ext4_ext_try_to_merge(struct inode *
 	eh = path[depth].p_hdr;
 
 	while (ex < EXT_LAST_EXTENT(eh)) {
-		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
+		if (!ext4_can_extents_be_merged(inode, ex, ex + 1, 0))
 			break;
 		/* merge with next extent! */
 		if (ext4_ext_is_uninitialized(ex))
@@ -1567,9 +1569,9 @@ out:
  * inserts requested extent as new one into the tree,
  * creating new leaf in the no-space case.
  */
-int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
+static int __ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext)
+				struct ext4_extent *newext, int flag)
 {
 	struct ext4_extent_header *eh;
 	struct ext4_extent *ex, *fex;
@@ -1585,7 +1587,7 @@ int ext4_ext_insert_extent(handle_t *han
 	BUG_ON(path[depth].p_hdr == NULL);
 
 	/* try to insert block into found extent and return */
-	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
+	if (ex && ext4_can_extents_be_merged(inode, ex, newext, flag)) {
 		ext_debug("append [%d]%d block to %d:[%d]%d (from %llu)\n",
 				ext4_ext_is_uninitialized(newext),
 				ext4_ext_get_actual_len(newext),
@@ -1705,7 +1707,8 @@ has_space:
 
 merge:
 	/* try to merge extents to the right */
-	ext4_ext_try_to_merge(inode, path, nearex);
+	if (!flag)
+		ext4_ext_try_to_merge(inode, path, nearex);
 
 	/* try to merge extents to the left */
 
@@ -1725,6 +1728,21 @@ cleanup:
 	return err;
 }
 
+int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
+				struct ext4_ext_path *path,
+				struct ext4_extent *newext)
+{
+	return __ext4_ext_insert_extent(handle, inode, path, newext, 0);
+}
+
+static int ext4_ext_insert_extent_dio(handle_t *handle, struct inode *inode,
+					struct ext4_ext_path *path,
+					struct ext4_extent *newext)
+{
+	return __ext4_ext_insert_extent(handle, inode, path, newext,
+					EXT4_GET_BLOCKS_DIO_CREATE_EXT);
+}
+
 int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			ext4_lblk_t num, ext_prepare_callback func,
 			void *cbdata)
@@ -2473,7 +2491,6 @@ static int ext4_ext_zeroout(struct inode
 }
 
 #define EXT4_EXT_ZERO_LEN 7
-
 /*
  * This function is called by ext4_ext_get_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -2768,6 +2785,318 @@ fix_extent_len:
 }
 
 /*
+ * This function is called by ext4_ext_get_blocks() from
+ * ext4_get_blocks_dio_write() when DIO to write
+ * to an uninitialized extent.
+ *
+ * Writing to an uninitized extent may result in splitting the uninitialized
+ * extent into multiple /intialized unintialized extents (up to three)
+ * There are three possibilities:
+ *   a> There is no split required: Entire extent should be uninitialized
+ *   b> Splits in two extents: Write is happening at either end of the extent
+ *   c> Splits in three extents: Somone is writing in middle of the extent
+ *
+ * One of more index blocks maybe needed if the extent tree grow after
+ * the unintialized extent split. To prevent ENOSPC occur at the IO
+ * complete, we need to split the uninitialized extent before DIO submit
+ * the IO. The uninitilized extent called at this time will be split
+ * into three uninitialized extent(at most). After IO complete, the part
+ * being filled will be convert to initialized by the end_io callback function
+ * via ext4_convert_unwritten_extents().
+ */
+static int ext4_split_unwritten_extents(handle_t *handle,
+					struct inode *inode,
+					struct ext4_ext_path *path,
+					ext4_lblk_t iblock,
+					unsigned int max_blocks)
+{
+	struct ext4_extent *ex, newex, orig_ex;
+	struct ext4_extent *ex1 = NULL;
+	struct ext4_extent *ex2 = NULL;
+	struct ext4_extent *ex3 = NULL;
+	struct ext4_extent_header *eh;
+	ext4_lblk_t ee_block;
+	unsigned int allocated, ee_len, depth;
+	ext4_fsblk_t newblock;
+	int err = 0;
+	int ret = 0;
+
+	ext_debug("ext4_split_unwritten_extents: inode %lu,"
+		  "iblock %llu, max_blocks %u\n", inode->i_ino,
+		  (unsigned long long)iblock, max_blocks);
+	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+	ee_block = le32_to_cpu(ex->ee_block);
+	ee_len = ext4_ext_get_actual_len(ex);
+	allocated = ee_len - (iblock - ee_block);
+	newblock = iblock - ee_block + ext_pblock(ex);
+	ex2 = ex;
+	orig_ex.ee_block = ex->ee_block;
+	orig_ex.ee_len   = cpu_to_le16(ee_len);
+	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
+
+	/*
+ 	 * if the entire unintialized extent length less than
+ 	 * the size of extent to write, there is no need to split
+ 	 * uninitialized extent
+ 	 */
+ 	if (allocated <= max_blocks)
+		return ret;
+
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
+		goto out;
+	/* ex1: ee_block to iblock - 1 : uninitialized */
+	if (iblock > ee_block) {
+		ex1 = ex;
+		ex1->ee_len = cpu_to_le16(iblock - ee_block);
+		ext4_ext_mark_uninitialized(ex1);
+		ex2 = &newex;
+	}
+	/*
+	 * for sanity, update the length of the ex2 extent before
+	 * we insert ex3, if ex1 is NULL. This is to avoid temporary
+	 * overlap of blocks.
+	 */
+	if (!ex1 && allocated > max_blocks)
+		ex2->ee_len = cpu_to_le16(max_blocks);
+	/* ex3: to ee_block + ee_len : uninitialised */
+	if (allocated > max_blocks) {
+		unsigned int newdepth;
+		ex3 = &newex;
+		ex3->ee_block = cpu_to_le32(iblock + max_blocks);
+		ext4_ext_store_pblock(ex3, newblock + max_blocks);
+		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
+		ext4_ext_mark_uninitialized(ex3);
+		err = ext4_ext_insert_extent_dio(handle, inode, path, ex3);
+		if (err == -ENOSPC) {
+			err =  ext4_ext_zeroout(inode, &orig_ex);
+			if (err)
+				goto fix_extent_len;
+			/* update the extent length and mark as initialized */
+			ex->ee_block = orig_ex.ee_block;
+			ex->ee_len   = orig_ex.ee_len;
+			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+			ext4_ext_dirty(handle, inode, path + depth);
+			/* zeroed the full extent */
+			/* blocks available from iblock */
+			return allocated;
+
+		} else if (err)
+			goto fix_extent_len;
+		/*
+		 * The depth, and hence eh & ex might change
+		 * as part of the insert above.
+		 */
+		newdepth = ext_depth(inode);
+		/*
+		 * update the extent length after successful insert of the
+		 * split extent
+		 */
+		orig_ex.ee_len = cpu_to_le16(ee_len -
+						ext4_ext_get_actual_len(ex3));
+		depth = newdepth;
+		ext4_ext_drop_refs(path);
+		path = ext4_ext_find_extent(inode, iblock, path);
+		if (IS_ERR(path)) {
+			err = PTR_ERR(path);
+			goto out;
+		}
+		eh = path[depth].p_hdr;
+		ex = path[depth].p_ext;
+		if (ex2 != &newex)
+			ex2 = ex;
+
+		err = ext4_ext_get_access(handle, inode, path + depth);
+		if (err)
+			goto out;
+
+		allocated = max_blocks;
+	}
+	/*
+	 * If there was a change of depth as part of the
+	 * insertion of ex3 above, we need to update the length
+	 * of the ex1 extent again here
+	 */
+	if (ex1 && ex1 != ex) {
+		ex1 = ex;
+		ex1->ee_len = cpu_to_le16(iblock - ee_block);
+		ext4_ext_mark_uninitialized(ex1);
+		ex2 = &newex;
+	}
+	/*
+	 * ex2: iblock to iblock + maxblocks-1 : to be direct IO written,
+	 * uninitialised still.
+	 */
+	ex2->ee_block = cpu_to_le32(iblock);
+	ext4_ext_store_pblock(ex2, newblock);
+	ex2->ee_len = cpu_to_le16(allocated);
+	ext4_ext_mark_uninitialized(ex2);
+	if (ex2 != ex)
+		goto insert;
+	/* Mark modified extent as dirty */
+	err = ext4_ext_dirty(handle, inode, path + depth);
+	ext_debug("out here\n");
+	goto out;
+insert:
+	err = ext4_ext_insert_extent_dio(handle, inode, path, &newex);
+	if (err == -ENOSPC) {
+		err =  ext4_ext_zeroout(inode, &orig_ex);
+		if (err)
+			goto fix_extent_len;
+		/* update the extent length and mark as initialized */
+		ex->ee_block = orig_ex.ee_block;
+		ex->ee_len   = orig_ex.ee_len;
+		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+		ext4_ext_dirty(handle, inode, path + depth);
+		/* zero out the first half */
+		return allocated;
+	} else if (err)
+		goto fix_extent_len;
+out:
+	ext4_ext_show_leaf(inode, path);
+	return err ? err : allocated;
+
+fix_extent_len:
+	ex->ee_block = orig_ex.ee_block;
+	ex->ee_len   = orig_ex.ee_len;
+	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+	ext4_ext_mark_uninitialized(ex);
+	ext4_ext_dirty(handle, inode, path + depth);
+	return err;
+}
+static int ext4_convert_unwritten_extents_dio(handle_t *handle,
+					      struct inode *inode,
+					      struct ext4_ext_path *path)
+{
+	struct ext4_extent *ex;
+	struct ext4_extent_header *eh;
+	int depth;
+	int err = 0;
+	int ret = 0;
+
+	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+
+	/* first mark the extent as initialized */
+	ext4_ext_mark_initialized(ex);
+
+	if (err < 0)
+		return err;
+	/*
+	 * We have to see if it can be merged with the extent
+	 * on the left.
+	 */
+	if (ex > EXT_FIRST_EXTENT(eh)) {
+		/*
+		 * To merge left, pass "ex - 1" to try_to_merge(),
+		 * since it merges towards right _only_.
+		 */
+		ret = ext4_ext_try_to_merge(inode, path, ex - 1);
+		if (ret) {
+			err = ext4_ext_correct_indexes(handle, inode, path);
+			if (err)
+				goto out;
+			depth = ext_depth(inode);
+			ex--;
+		}
+	}
+	/*
+	 * Try to Merge towards right.
+	 */
+	ret = ext4_ext_try_to_merge(inode, path, ex);
+	if (ret) {
+		err = ext4_ext_correct_indexes(handle, inode, path);
+		if (err)
+			goto out;
+		depth = ext_depth(inode);
+	}
+	/* Mark modified extent as dirty */
+	err = ext4_ext_dirty(handle, inode, path + depth);
+out:
+	ext4_ext_show_leaf(inode, path);
+	return err;
+}
+
+static int
+ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
+			ext4_lblk_t iblock, unsigned int max_blocks,
+			struct ext4_ext_path *path, int flags,
+			unsigned int allocated, struct buffer_head *bh_result,
+			ext4_fsblk_t newblock)
+{
+	int ret = 0;
+	int err = 0;
+
+	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical"
+		  "block %llu, max_blocks %u, flags %d, allocated %u",
+		  inode->i_ino, (unsigned long long)iblock, max_blocks,
+		  flags, allocated);
+	ext4_ext_show_leaf(inode, path);
+
+	/* DIO get_block() before submit the IO, split the extent */
+	if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
+		ret = ext4_split_unwritten_extents(handle,
+						inode, path, iblock,
+						max_blocks);
+		goto out;
+	}
+	/* DIO end_io complete, convert the filled extent to written */
+	if (flags == EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
+		ret = ext4_convert_unwritten_extents_dio(handle, inode,
+							path);
+		goto out2;
+	}
+	/* buffered IO case */
+	/*
+	 * repeat fallocate creation request
+	 * we already have an unwritten extent
+	 */
+	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
+		goto map_out;
+
+	/* buffered READ or buffered write_begin() lookup */
+	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
+		/*
+		 * We have blocks reserved already.  We
+		 * return allocated blocks so that delalloc
+		 * won't do block reservation for us.  But
+		 * the buffer head will be unmapped so that
+		 * a read from the block returns 0s.
+		 */
+		set_buffer_unwritten(bh_result);
+		goto out1;
+	}
+
+	/* buffered write, writepage time, convert*/
+	ret = ext4_ext_convert_to_initialized(handle, inode,
+						path, iblock,
+						max_blocks);
+out:
+	if (ret <= 0) {
+		err = ret;
+		goto out2;
+	} else
+		allocated = ret;
+	set_buffer_new(bh_result);
+map_out:
+	set_buffer_mapped(bh_result);
+out1:
+	if (allocated > max_blocks)
+		allocated = max_blocks;
+	ext4_ext_show_leaf(inode, path);
+	bh_result->b_bdev = inode->i_sb->s_bdev;
+	bh_result->b_blocknr = newblock;
+out2:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	return err ? err : allocated;
+}
+/*
  * Block allocation/map/preallocation routine for extents based files
  *
  *
@@ -2872,33 +3201,10 @@ int ext4_ext_get_blocks(handle_t *handle
 							EXT4_EXT_CACHE_EXTENT);
 				goto out;
 			}
-			if (flags & EXT4_GET_BLOCKS_UNINIT_EXT)
-				goto out;
-			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
-				if (allocated > max_blocks)
-					allocated = max_blocks;
-				/*
-				 * We have blocks reserved already.  We
-				 * return allocated blocks so that delalloc
-				 * won't do block reservation for us.  But
-				 * the buffer head will be unmapped so that
-				 * a read from the block returns 0s.
-				 */
-				set_buffer_unwritten(bh_result);
-				bh_result->b_bdev = inode->i_sb->s_bdev;
-				bh_result->b_blocknr = newblock;
-				goto out2;
-			}
-
-			ret = ext4_ext_convert_to_initialized(handle, inode,
-								path, iblock,
-								max_blocks);
-			if (ret <= 0) {
-				err = ret;
-				goto out2;
-			} else
-				allocated = ret;
-			goto outnew;
+			ret = ext4_ext_handle_uninitialized_extents(handle,
+					inode, iblock, max_blocks, path,
+					flags, allocated, bh_result, newblock);
+			return ret;
 		}
 	}
 
@@ -2985,7 +3291,6 @@ int ext4_ext_get_blocks(handle_t *handle
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
-outnew:
 	set_buffer_new(bh_result);
 
 	/* Cache only when it is _not_ an uninitialized extent */
@@ -3184,6 +3489,77 @@ retry:
 }
 
 /*
+ * This function convert a range of blocks to written extents
+ * The caller of this function will pass the start offset and the size.
+ * all unwritten extents within this range will be converted to
+ * written extents.
+ *
+ * This function is called from the direct IO end io call back
+ * function, to convert the fallocated extents after IO is completed.
+ */
+int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
+				    loff_t len)
+{
+	handle_t *handle;
+	ext4_lblk_t block;
+	loff_t new_size;
+	unsigned int max_blocks;
+	int ret = 0;
+	int ret2 = 0;
+	struct buffer_head map_bh;
+	unsigned int credits, blkbits = inode->i_blkbits;
+
+	block = offset >> blkbits;
+	/*
+	 * We can't just convert len to max_blocks because
+	 * If blocksize = 4096 offset = 3072 and len = 2048
+	 */
+	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
+							- block;
+	/*
+	 * credits to insert 1 extent into extent tree
+	 */
+	credits = ext4_chunk_trans_blocks(inode, max_blocks);
+	while (ret >= 0 && ret < max_blocks) {
+		block = block + ret;
+		max_blocks = max_blocks - ret;
+		handle = ext4_journal_start(inode, credits);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			break;
+		}
+		map_bh.b_state = 0;
+		ret = ext4_get_blocks(handle, inode, block,
+				      max_blocks, &map_bh,
+				      EXT4_GET_BLOCKS_DIO_CONVERT_EXT);
+		if (ret <= 0) {
+			WARN_ON(ret <= 0);
+			printk(KERN_ERR "%s: ext4_ext_get_blocks "
+				    "returned error inode#%lu, block=%u, "
+				    "max_blocks=%u", __func__,
+				    inode->i_ino, block, max_blocks);
+			ext4_mark_inode_dirty(handle, inode);
+			ret2 = ext4_journal_stop(handle);
+			break;
+		}
+
+		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
+						blkbits) >> blkbits))
+			new_size = offset + len;
+		else
+			new_size = (block + ret) << blkbits;
+
+		if (new_size > EXT4_I(inode)->i_disksize)
+			ext4_update_i_disksize(inode, new_size);
+
+		ext4_mark_inode_dirty(handle, inode);
+		ret2 = ext4_journal_stop(handle);
+		if (ret2)
+			break;
+	}
+	return ret > 0 ? ret2 : ret;
+}
+/*
  * Callback function called for each extent to gather FIEMAP information.
  */
 static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
Index: linux-2.6.31-rc4/fs/ext4/move_extent.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/move_extent.c
+++ linux-2.6.31-rc4/fs/ext4/move_extent.c
@@ -504,7 +504,7 @@ mext_leaf_block(handle_t *handle, struct
 		 * if these are contiguous and same extent type.
 		 */
 		if (ext4_can_extents_be_merged(orig_inode, prev_ext,
-					       &new_ext) {
+					       &new_ext, 0)) {
 			o_start = prev_ext;
 			start_ext.ee_len = cpu_to_le16(
 				ext4_ext_get_actual_len(prev_ext) +
@@ -1216,7 +1216,7 @@ ext4_move_extents(struct file *o_filp, s
 		 * if extents are contiguous.
 		 */
 		if (ext4_can_extents_be_merged(orig_inode,
-					       ext_prev, ext_cur) &&
+					       ext_prev, ext_cur, 0) &&
 		    block_end >= le32_to_cpu(ext_cur->ee_block) &&
 		    !last_extent)
 			continue;
Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -1156,6 +1156,9 @@ int ext4_get_blocks(handle_t *handle, st
 	clear_buffer_mapped(bh);
 	clear_buffer_unwritten(bh);
 
+	ext_debug("ext4_get_blocks(): inode %lu, flag %d, max_blocks %u,"
+		  "logical block %lu\n", inode->i_ino, flags, max_blocks,
+		  (unsigned long)block);
 	/*
 	 * Try to see if we can get the block without requesting a new
 	 * file system block.


