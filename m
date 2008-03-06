From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Thu, 06 Mar 2008 09:01:16 +0900
Message-ID: <200803060001.AA00324@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a-fujita@rs.jp.nec.com
To: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60413 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbYCFACO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 19:02:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Change the name of functions (ext4_ext_xxx -> ext4_defrag_xxx)
and some cleanups.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
--
 fs/ext4/defrag.c                | 1060 +++++++++++++++------------------------
 fs/ext4/extents.c               |    5 +-
 fs/ext4/ioctl.c                 |    5 +-
 fs/ext4/mballoc.c               |    3 +-
 include/linux/ext4_fs.h         |   13 +-
 include/linux/ext4_fs_extents.h |   13 -
 6 files changed, 424 insertions(+), 675 deletions(-)

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index d22bec9..c86a9e2 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -1,207 +1,45 @@
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/time.h>
-#include <linux/jbd2.h>
-#include <linux/highuid.h>
-#include <linux/pagemap.h>
+/*
+ * Copyright (c) 2008, NEC Software Tohoku, Ltd.
+ * Written by Takashi Sato <t-sato@yk.jp.nec.com>
+ *            Akira Fujita <a-fujita@rs.jp.nec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Online defragmentation for EXT4 */
+
 #include <linux/quotaops.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/falloc.h>
-#include <asm/uaccess.h>
 #include <linux/ext4_jbd2.h>
 #include <linux/ext4_fs_extents.h>
 #include "group.h"
 
-#define DIO_CREDITS (EXT4_RESERVE_TRANS_BLOCKS + 32)
 #define EXT_SET_EXTENT_DATA(src, dest)  do {			\
 		dest.block = le32_to_cpu(src->ee_block);	\
 		dest.start = ext_pblock(src);			\
 		dest.len = le16_to_cpu(src->ee_len);		\
 					} while (0)
 
-/*
- * this structure is used to gather extents from the tree via ioctl
- */
-struct ext4_extent_buf {
-	ext4_fsblk_t start;
-	int buflen;
-	void *buffer;
-	void *cur;
-	int err;
-};
-
-/*
- * this structure is used to collect stats info about the tree
- */
-struct ext4_extent_tree_stats {
-	int depth;
-	int extents_num;
-	int leaf_num;
-};
-
-int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
-			ext4_lblk_t num, ext_prepare_callback func,
-			void *cbdata)
-{
-	struct ext4_ext_path *path = NULL;
-	struct ext4_ext_cache cbex;
-	struct ext4_extent *ex;
-	ext4_lblk_t next, start = 0, end = 0;
-	ext4_lblk_t last = block + num;
-	int depth, exists, err = 0;
-
-	BUG_ON(func == NULL);
-	BUG_ON(inode == NULL);
-
-	while (block < last && block != EXT_MAX_BLOCK) {
-		num = last - block;
-		/* find extent for this block */
-		path = ext4_ext_find_extent(inode, block, path);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			path = NULL;
-			break;
-		}
-
-		depth = ext_depth(inode);
-		BUG_ON(path[depth].p_hdr == NULL);
-		ex = path[depth].p_ext;
-		next = ext4_ext_next_allocated_block(path);
-
-		exists = 0;
-		if (!ex) {
-			/* there is no extent yet, so try to allocate
-			 * all requested space */
-			start = block;
-			end = block + num;
-		} else if (le32_to_cpu(ex->ee_block) > block) {
-			/* need to allocate space before found extent */
-			start = block;
-			end = le32_to_cpu(ex->ee_block);
-			if (block + num < end)
-				end = block + num;
-		} else if (block >= le32_to_cpu(ex->ee_block)
-					+ ext4_ext_get_actual_len(ex)) {
-			/* need to allocate space after found extent */
-			start = block;
-			end = block + num;
-			if (end >= next)
-				end = next;
-		} else if (block >= le32_to_cpu(ex->ee_block)) {
-			/*
-			 * some part of requested space is covered
-			 * by found extent
-			 */
-			start = block;
-			end = le32_to_cpu(ex->ee_block)
-				+ ext4_ext_get_actual_len(ex);
-			if (block + num < end)
-				end = block + num;
-			exists = 1;
-		} else {
-			BUG();
-		}
-		BUG_ON(end <= start);
-
-		if (!exists) {
-			cbex.ec_block = start;
-			cbex.ec_len = end - start;
-			cbex.ec_start = 0;
-			cbex.ec_type = EXT4_EXT_CACHE_GAP;
-		} else {
-			cbex.ec_block = le32_to_cpu(ex->ee_block);
-			cbex.ec_len = ext4_ext_get_actual_len(ex);
-			cbex.ec_start = ext_pblock(ex);
-			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
-		}
-
-		BUG_ON(cbex.ec_len == 0);
-		err = func(inode, path, &cbex, cbdata);
-		ext4_ext_drop_refs(path);
-
-		if (err < 0)
-			break;
-		if (err == EXT_REPEAT)
-			continue;
-		else if (err == EXT_BREAK) {
-			err = 0;
-			break;
-		}
-
-		if (ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
-		}
-
-		block = cbex.ec_block + cbex.ec_len;
-	}
-
-	if (path) {
-		ext4_ext_drop_refs(path);
-		kfree(path);
-	}
-
-	return err;
-}
-
-static int
-ext4_ext_store_extent_cb(struct inode *inode,
-			struct ext4_ext_path *path,
-			struct ext4_ext_cache *newex,
-			struct ext4_extent_buf *buf)
-{
-
-	if (newex->ec_type != EXT4_EXT_CACHE_EXTENT)
-		return EXT_CONTINUE;
-
-	if (buf->err < 0)
-		return EXT_BREAK;
-	if (buf->cur - buf->buffer + sizeof(*newex) > buf->buflen)
-		return EXT_BREAK;
-
-	if (!copy_to_user(buf->cur, newex, sizeof(*newex))) {
-		buf->err++;
-		buf->cur += sizeof(*newex);
-	} else {
-		buf->err = -EFAULT;
-		return EXT_BREAK;
-	}
-	return EXT_CONTINUE;
-}
-
-static int
-ext4_ext_collect_stats_cb(struct inode *inode,
-			struct ext4_ext_path *path,
-			struct ext4_ext_cache *ex,
-			struct ext4_extent_tree_stats *buf)
-{
-	int depth;
-
-	if (ex->ec_type != EXT4_EXT_CACHE_EXTENT)
-		return EXT_CONTINUE;
-
-	depth = ext_depth(inode);
-	buf->extents_num++;
-	if (path[depth].p_ext == EXT_FIRST_EXTENT(path[depth].p_hdr))
-		buf->leaf_num++;
-	return EXT_CONTINUE;
-}
-
 /**
- * ext4_ext_next_extent - search for next extent and set it to "extent"
+ * ext4_defrag_next_extent - Search for the next extent and set it to "extent"
+ *
  * @inode:	inode of the the original file
- * @path:	this will obtain data for next extent
- * @extent:	pointer to next extent we have just gotten
+ * @path:	this will obtain data for the next extent
+ * @extent:	pointer to the next extent we have just gotten
  *
- * This function returns 0 or 1(last_entry) if succeeded, otherwise
- * returns -EIO
+ * This function returns 0 or 1(last entry) if succeeded, otherwise
+ * returns -EIO.
  */
 static int
-ext4_ext_next_extent(struct inode *inode,
-		     struct ext4_ext_path *path,
-		     struct ext4_extent **extent)
+ext4_defrag_next_extent(struct inode *inode,
+			struct ext4_ext_path *path,
+			struct ext4_extent **extent)
 {
 	int ppos;
 	int leaf_ppos = path->p_depth;
@@ -231,7 +69,7 @@ ext4_ext_next_extent(struct inode *inode,
 			path[ppos+1].p_hdr =
 				ext_block_hdr(path[ppos+1].p_bh);
 
-			/* halfway index block */
+			/* Halfway index block */
 			while (++cur_ppos < leaf_ppos) {
 				path[cur_ppos].p_idx =
 					EXT_FIRST_INDEX(path[cur_ppos].p_hdr);
@@ -253,39 +91,39 @@ ext4_ext_next_extent(struct inode *inode,
 			return 0;
 		}
 	}
-	/* last_extent */
+	/* We found the last extent */
 	return 1;
 }
 
 /**
- * ext4_ext_extents_info() - get extents information
- *
- * @ext_info:                   pointer to ext4_extents_info
- *  @ext_info->ino              describe an inode which is used to get extent
- *                              information
- *  @ext_info->max_entries:     defined by DEFRAG_MAX_ENT
- *  @ext_info->entries:	        amount of extents (output)
- *  @ext_info->ext[]:           array of extent (output)
- *  @ext_info->offset:          starting block offset of targeted extent
- *                              (file relative)
+ * ext4_defrag_extents_info - Get extents information
  *
- * @sb:                         for iget()
+ * @sb:				for ext4_iget()
+ * @ext_info:			pointer to ext4_extents_info
+ *  @ext_info->ino		describe an inode which is used to get
+ *				extent information
+ *  @ext_info->max_entries:	defined by DEFRAG_MAX_ENT
+ *  @ext_info->entries:		amount of extents (output)
+ *  @ext_info->ext[]:		array of extent (output)
+ *  @ext_info->offset:		starting block offset of targeted extent
+ *				(file relative)
  *
- * This function returns 0 if next extent(s) exists,
- * or returns 1 if next extent doesn't exist, otherwise returns error value.
+ * This function returns 0 if the next extent(s) exists,
+ * or returns 1 if the next extent doesn't exist,
+ * otherwise returns error value.
  */
-static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
-				struct super_block *sb)
+static int ext4_defrag_extents_info(struct super_block *sb,
+				struct ext4_extents_info *ext_info)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent *ext = NULL;
 	struct inode *inode = NULL;
 	ext4_lblk_t offset = ext_info->f_offset;
 	int max_entries = ext_info->max_entries;
-	int is_last_extent = 0;
 	int depth = 0;
 	int entries = 0;
 	int err = 0;
+	int ret = 0;
 
 	inode = ext4_iget(sb, ext_info->ino);
 	if (IS_ERR(inode))
@@ -293,7 +131,7 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 
-	/* if a file doesn't exist*/
+	/* Return -ENOENT if a file does not exist */
 	if ((!inode->i_nlink) || (inode->i_ino < 11) ||
 			!S_ISREG(inode->i_mode)) {
 		ext_info->entries = 0;
@@ -309,7 +147,7 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
 	}
 	depth = ext_depth(inode);
 
-	/* if file size is 0, skip this one. */
+	/* Skip the 0 size file */
 	if (path[depth].p_ext == NULL) {
 		ext_info->entries = 0;
 		goto out;
@@ -324,9 +162,9 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
 	 * more the number of extents than 'max_entries'.
 	 */
 	while (entries < max_entries) {
-		is_last_extent = ext4_ext_next_extent(inode, path, &ext);
-		/* found next extent (not the last one)*/
-		if (is_last_extent == 0) {
+		ret = ext4_defrag_next_extent(inode, path, &ext);
+		if (ret == 0) {
+			/* Found the next extent (it means not the last one) */
 			EXT_SET_EXTENT_DATA(ext, ext_info->ext[entries]);
 			entries++;
 
@@ -341,27 +179,27 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
 				ext_info->f_offset =
 						le32_to_cpu(ext->ee_block) +
 						le32_to_cpu(ext->ee_len);
-				/* check the extent is the last one or not*/
-				is_last_extent =
-					ext4_ext_next_extent(inode, path, &ext);
-				if (is_last_extent == 1) {
-					err = is_last_extent;
-				} else if (is_last_extent < 0) {
-					/*ERR*/
-					err = is_last_extent;
+				/* Check the extent is the last one or not */
+				ret =
+				    ext4_defrag_next_extent(inode, path, &ext);
+				if (ret == 1) {
+					err = ret;
+				} else if (ret < 0) {
+					/* Failed to get the next extent */
+					err = ret;
 					goto out;
 				}
 				break;
 			}
 
-		/* the extent is the last one */
-		} else if (is_last_extent == 1) {
+		} else if (ret == 1) {
+			/* The extent is the last one */
 			ext_info->f_offset = 0;
-			err = is_last_extent;
+			err = ret;
 			break;
 		} else {
-			/* ERR */
-			err = is_last_extent;
+			/* Failed to get the next extent */
+			err = ret;
 			goto out;
 		}
 	}
@@ -379,20 +217,21 @@ out:
 }
 
 /**
- * ext4_ext_defrag_reserve - reserve blocks for defrag
+ * ext4_defrag_reserve_blocks - Reserve blocks for defrag
+ *
  * @inode	target inode
  * @goal	block reservation goal
  * @len		blocks count to reserve
  *
  * This function returns 0 if succeeded, otherwise
- * returns error value
+ * returns error value.
  */
 
 static int
-ext4_ext_defrag_reserve(struct inode *inode, ext4_fsblk_t goal, int len)
+ext4_defrag_reserve_blocks(struct inode *inode, ext4_fsblk_t goal, int len)
 {
 	struct super_block *sb = NULL;
-	handle_t *handle = NULL;
+	handle_t *handle;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_block_alloc_info *block_i;
 	struct ext4_reserve_window_node *my_rsv = NULL;
@@ -413,16 +252,14 @@ ext4_ext_defrag_reserve(struct inode *inode, ext4_fsblk_t goal, int len)
 	if (S_ISREG(inode->i_mode) && (!EXT4_I(inode)->i_block_alloc_info)) {
 		ext4_init_block_alloc_info(inode);
 	} else if (!S_ISREG(inode->i_mode)) {
-		printk(KERN_ERR "ext4_ext_defrag_reserve:"
-				 " incorrect file type\n");
-		err = -1;
+		printk(KERN_ERR "ext4 defrag: Invalid file type\n");
+		err = -EINVAL;
 		goto out;
 	}
 
 	sb = inode->i_sb;
 	if (!sb) {
-		printk(KERN_ERR "ext4_ext_defrag_reserve: "
-				 "nonexistent device\n");
+		printk(KERN_ERR "ext4 defrag: Non-existent device\n");
 		err = -ENXIO;
 		goto out;
 	}
@@ -430,13 +267,13 @@ ext4_ext_defrag_reserve(struct inode *inode, ext4_fsblk_t goal, int len)
 				&grp_target_blk);
 
 	block_i = EXT4_I(inode)->i_block_alloc_info;
+	/* Block reservation should be enabled */
+	BUG_ON(!block_i);
+
+	windowsz = block_i->rsv_window_node.rsv_goal_size;
+	/* Goal size should be set */
+	BUG_ON(!windowsz);
 
-	if (!block_i || ((windowsz =
-			block_i->rsv_window_node.rsv_goal_size) == 0)) {
-		printk(KERN_ERR "ex4_ext_defrag_reserve: unable to reserve\n");
-		err = -1;
-		goto out;
-	}
 
 	my_rsv = &block_i->rsv_window_node;
 
@@ -454,7 +291,9 @@ ext4_ext_defrag_reserve(struct inode *inode, ext4_fsblk_t goal, int len)
 	err = alloc_new_reservation(my_rsv, grp_target_blk, sb,
 						group_no, bitmap_bh);
 	if (err < 0) {
-		printk(KERN_ERR "defrag: reservation faild\n");
+		printk(KERN_ERR "ext4 defrag: Block reservation failed."
+				"offset [%d], bg[%lu]\n",
+				grp_target_blk, group_no);
 		ext4_discard_reservation(inode);
 		goto out;
 	} else {
@@ -476,16 +315,17 @@ out:
 }
 
 /**
- * ext4_ext_block_within_rsv - Is target extent reserved ?
- * @ inode       inode of target file
- * @ ex_start    start physical block number of the extent
- *               which already moved
- * @ ex_len      block length of the extent which already moved
+ * ext4_defrag_block_within_rsv - Is target extent reserved ?
+ *
+ * @ inode	inode of target file
+ * @ ex_start	start physical block number of the extent
+ *		which already moved
+ * @ ex_len	block length of the extent which already moved
  *
  * This function returns 0 if succeeded, otherwise
- * returns error value
+ * returns error value.
  */
-static int ext4_ext_block_within_rsv(struct inode *inode,
+static int ext4_defrag_block_within_rsv(struct inode *inode,
 				ext4_fsblk_t ex_start, int ex_len)
 {
 	struct super_block *sb = inode->i_sb;
@@ -495,15 +335,15 @@ static int ext4_ext_block_within_rsv(struct inode *inode,
 	struct ext4_reserve_window_node *rsv;
 
 	block_i = EXT4_I(inode)->i_block_alloc_info;
-	if (block_i && block_i->rsv_window_node.rsv_goal_size > 0) {
-		rsv = &block_i->rsv_window_node;
-		if (rsv_is_empty(&rsv->rsv_window)) {
-			printk(KERN_ERR "defrag: Can't defrag due to"
-					" the empty reservation\n");
-			return -ENOSPC;
-		}
-	} else {
-		printk(KERN_ERR "defrag: No i_block_alloc_info\n");
+	/* Block reservation should be enabled */
+	BUG_ON(!block_i);
+
+	/* Goal size should be set */
+	BUG_ON(!block_i->rsv_window_node.rsv_goal_size);
+
+	rsv = &block_i->rsv_window_node;
+	if (rsv_is_empty(&rsv->rsv_window)) {
+		printk(KERN_ERR "ext4 defrag: Reservation window is empty\n");
 		return -ENOSPC;
 	}
 
@@ -512,7 +352,7 @@ static int ext4_ext_block_within_rsv(struct inode *inode,
 	if (!goal_in_my_reservation(&rsv->rsv_window, grp_blk, group_no, sb)
 	    || !goal_in_my_reservation(&rsv->rsv_window, grp_blk + ex_len - 1,
 		group_no, sb)){
-		printk(KERN_ERR "defrag: %d or %d in bg %lu is "
+		printk(KERN_ERR "ext4 defrag: %d or %d in bg %lu is "
 				"not in rsv_window\n", grp_blk,
 				grp_blk + ex_len - 1, group_no);
 		return -ENOSPC;
@@ -521,13 +361,14 @@ static int ext4_ext_block_within_rsv(struct inode *inode,
 }
 
 /*
- * ext4_ext_fblocks_reserve() -
- *	reserve free blocks by ext4_ext_defrag_reserve()
+ * ext4_defrag_reserve_fblocks - Reserve free blocks
+ *				with ext4_defrag_reserve_blocks
+ *
  * @inode:		To get a block group number
  * @ext_info:		freeblocks distribution which stored extent-like style
- *  @ext_info->ext[]    an array of struct ext4_extents_data
+ *  @ext_info->ext[]	an array of struct ext4_extents_data
  */
-static int ext4_ext_fblocks_reserve(struct inode *inode,
+static int ext4_defrag_reserve_fblocks(struct inode *inode,
 			struct ext4_extents_info *ext_info)
 {
 	ext4_fsblk_t ex_start = 0;
@@ -539,22 +380,24 @@ static int ext4_ext_fblocks_reserve(struct inode *inode,
 		ex_start = ext_info->ext[i].start;
 		len = ext_info->ext[i].len;
 
-		ret = ext4_ext_defrag_reserve(inode, ex_start, len);
+		ret = ext4_defrag_reserve_blocks(inode, ex_start, len);
 		if (ret < 0) {
-			printk(KERN_ERR "defrag: failed "
-				"ext4_ext_defrag_reserve\n");
-			goto ERR;
+			printk(KERN_ERR "ext4 defrag: "
+				"Block reservation failed. offset [%llu], "
+				"length [%d]\n", ex_start, len);
+			goto err;
 		}
-		ret = ext4_ext_block_within_rsv(inode, ex_start, len);
+		ret = ext4_defrag_block_within_rsv(inode, ex_start, len);
 		if (ret < 0) {
-			printk(KERN_ERR "defrag: failed "
-				"ext4_ext_block_within_rsv\n");
-			goto ERR;
+			printk(KERN_ERR "ext4 defrag: "
+				"Reservation window is not set. "
+				"offset [%llu], length [%d]\n", ex_start, len);
+			goto err;
 		}
 	}
 	return ret;
 
-ERR:
+err:
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_reservation(inode);
 	up_write(&EXT4_I(inode)->i_data_sem);
@@ -562,33 +405,34 @@ ERR:
 }
 
 /**
- * ext4_ext_defrag_victim - Create free space for defrag
- * @filp      target file
- * @ex_info   target extents array to move
+ * ext4_defrag_move_victim - Create free space for defrag
+ *
+ * @filp	target file
+ * @ext_info	target extents array to move
  *
  * This function returns 0 if succeeded, otherwise
- * returns error value
+ * returns error value.
  */
-static int ext4_ext_defrag_victim(struct file *target_filp,
-			struct ext4_extents_info *ex_info)
+static int ext4_defrag_move_victim(struct file *target_filp,
+			struct ext4_extents_info *ext_info)
 {
 	struct inode *target_inode = target_filp->f_dentry->d_inode;
 	struct super_block *sb = target_inode->i_sb;
 	struct file victim_file;
 	struct dentry victim_dent;
 	struct inode *victim_inode;
-	ext4_fsblk_t goal = ex_info->goal;
+	ext4_fsblk_t goal = ext_info->goal;
 	int ret = 0;
 	int i = 0;
 	struct ext4_extent_data ext;
 	ext4_group_t group;
 	ext4_grpblk_t grp_off;
 
-	/* Setup dummy entent data */
+	/* Setup dummy extent data */
 	ext.len = 0;
 
 	/* Get the inode of the victim file */
-	victim_inode = ext4_iget(sb, ex_info->ino);
+	victim_inode = ext4_iget(sb, ext_info->ino);
 	if (IS_ERR(victim_inode))
 		return PTR_ERR(victim_inode);
 
@@ -600,30 +444,33 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
 	/* Set the goal appropriate offset */
 	if (goal == -1) {
 		ext4_get_group_no_and_offset(victim_inode->i_sb,
-				ex_info->ext[0].start, &group, &grp_off);
+				ext_info->ext[0].start, &group, &grp_off);
 		goal = ext4_group_first_block_no(sb, group + 1);
 	}
 
-	for (i = 0; i < ex_info->entries; i++) {
+	for (i = 0; i < ext_info->entries; i++) {
 		/* Move original blocks to another block group */
-		ret = ext4_ext_defrag(&victim_file, ex_info->ext[i].block,
-			ex_info->ext[i].len, goal, DEFRAG_FORCE_VICTIM, &ext);
+		ret = ext4_defrag(&victim_file, ext_info->ext[i].block,
+			ext_info->ext[i].len, goal, DEFRAG_FORCE_VICTIM, &ext);
 		if (ret < 0) {
-			printk(KERN_ERR "defrag: failed ext4_ext_defrag\n");
-			goto ERR;
+			printk(KERN_ERR "ext4 defrag: "
+				"Moving victim file failed. ino [%lu]\n",
+				ext_info->ino);
+			goto err;
 		}
 
 		/* Sync journal blocks before reservation */
 		ret = ext4_force_commit(sb);
 		if (ret) {
-			printk(KERN_ERR "defrag: failed ext4_force_commit (%d)\n", ret);
-			goto ERR;
+			printk(KERN_ERR "ext4 defrag: "
+				"ext4_force_commit failed(%d)\n", ret);
+			goto err;
 		}
 	}
 
 	iput(victim_inode);
 	return 0;
-ERR:
+err:
 	down_write(&EXT4_I(target_inode)->i_data_sem);
 	ext4_discard_reservation(target_inode);
 	up_write(&EXT4_I(target_inode)->i_data_sem);
@@ -632,19 +479,19 @@ ERR:
 }
 
 /**
- * ext4_ext_fblocks_distribution - Search free block distribution
- * @filp      target file
- * @ex_info   ext4_extents_info
+ * ext4_defrag_fblocks_distribution - Search free blocks distribution
+ *
+ * @inode	target file
+ * @ext_info	ext4_extents_info
  *
  * This function returns 0 if succeeded, otherwise
- * returns error value
+ * returns error value.
  */
-static int ext4_ext_fblocks_distribution(struct inode *inode,
+static int ext4_defrag_fblocks_distribution(struct inode *inode,
 			struct ext4_extents_info *ext_info)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
-	struct ext4_super_block *es;
 	handle_t *handle;
 	ext4_group_t group_no;
 	ext4_grpblk_t start, end;
@@ -654,18 +501,21 @@ static int ext4_ext_fblocks_distribution(struct inode *inode,
 	int i = 0;
 	int err = 0;
 	int block_set = 0;
+	int extra_block = 0;
 
 	if (!sb) {
-		printk(KERN_ERR "ext4_ext_fblock_distribution: "
-				"nonexitent device\n");
+		printk(KERN_ERR "ext4 defrag: Non-existent device\n");
 		return -ENOSPC;
 	}
-	es = EXT4_SB(sb)->s_es;
 
 	group_no = (inode->i_ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	start = ext_info->g_offset;
 	end = EXT4_BLOCKS_PER_GROUP(sb) - 1;
 
+	/* We consider about the boot block if bs = 1k */
+	if (sb->s_blocksize == 1024)
+		extra_block = 1;
+
 	handle = ext4_journal_start(inode, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -686,10 +536,14 @@ static int ext4_ext_fblocks_distribution(struct inode *inode,
 	for (i = start; i <= end ; i++) {
 		if (bitmap_search_next_usable_block(i, bitmap_bh, i + 1) >= 0) {
 			len++;
-			/* if the free block is the first one in a region */
+			/*
+			 * Reset start_block if the free block is
+			 * the head of region.
+			 */
 			if (!block_set) {
 				start_block =
-				 i + group_no * EXT4_BLOCKS_PER_GROUP(sb);
+				 i + group_no * EXT4_BLOCKS_PER_GROUP(sb) +
+				 extra_block;
 				block_set = 1;
 			}
 		} else if (len) {
@@ -721,7 +575,7 @@ out:
 	return err;
 }
 
-int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+int ext4_defrag_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			unsigned long arg)
 {
 	int err = 0;
@@ -729,37 +583,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		cmd == EXT4_IOC_FIBMAP))
 			return -EINVAL;
 
-	if (cmd == EXT4_IOC_GET_EXTENTS) {
-		struct ext4_extent_buf buf;
-
-		if (copy_from_user(&buf, (void *) arg, sizeof(buf)))
-			return -EFAULT;
-
-		buf.cur = buf.buffer;
-		buf.err = 0;
-		down_write(&EXT4_I(inode)->i_data_sem);
-		err = ext4_ext_walk_space(inode, buf.start, EXT_MAX_BLOCK,
-				(void *)ext4_ext_store_extent_cb, &buf);
-		up_write(&EXT4_I(inode)->i_data_sem);
-		if (err == 0)
-			err = buf.err;
-	} else if (cmd == EXT4_IOC_GET_TREE_STATS) {
-		struct ext4_extent_tree_stats buf;
-
-		down_write(&EXT4_I(inode)->i_data_sem);
-		buf.depth = ext_depth(inode);
-		buf.extents_num = 0;
-		buf.leaf_num = 0;
-		err = ext4_ext_walk_space(inode, 0, EXT_MAX_BLOCK,
-				(void *)ext4_ext_collect_stats_cb, &buf);
-		up_write(&EXT4_I(inode)->i_data_sem);
-		if (!err)
-			err = copy_to_user((void *) arg, &buf, sizeof(buf));
-	} else if (cmd == EXT4_IOC_GET_TREE_DEPTH) {
-		down_write(&EXT4_I(inode)->i_data_sem);
-		err = ext_depth(inode);
-		up_write(&EXT4_I(inode)->i_data_sem);
-	} else if (cmd == EXT4_IOC_FIBMAP) {
+	if (cmd == EXT4_IOC_FIBMAP) {
 		ext4_fsblk_t __user *p = (ext4_fsblk_t __user *)arg;
 		ext4_fsblk_t block = 0;
 		struct address_space *mapping = filp->f_mapping;
@@ -799,7 +623,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 
 		BUG_ON(ext_info.ino != inode->i_ino);
 
-		err = ext4_ext_fblocks_distribution(inode, &ext_info);
+		err = ext4_defrag_fblocks_distribution(inode, &ext_info);
 
 		if (!err)
 			err = copy_to_user((struct ext4_extents_info *)arg,
@@ -812,7 +636,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 				sizeof(ext_info)))
 			return -EFAULT;
 
-		err = ext4_ext_extents_info(&ext_info, inode->i_sb);
+		err = ext4_defrag_extents_info(inode->i_sb, &ext_info);
 		if (err >= 0) {
 			if (copy_to_user((struct ext4_extents_info __user *)arg,
 				&ext_info, sizeof(ext_info)))
@@ -826,7 +650,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 				sizeof(ext_info)))
 			return -EFAULT;
 
-		err = ext4_ext_fblocks_reserve(inode, &ext_info);
+		err = ext4_defrag_reserve_fblocks(inode, &ext_info);
 	} else if (cmd == EXT4_IOC_MOVE_VICTIM) {
 		struct ext4_extents_info ext_info;
 
@@ -835,7 +659,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			sizeof(ext_info)))
 			return -EFAULT;
 
-		err = ext4_ext_defrag_victim(filp, &ext_info);
+		err = ext4_defrag_move_victim(filp, &ext_info);
 
 	} else if (cmd == EXT4_IOC_BLOCK_RELEASE) {
 		down_write(&EXT4_I(inode)->i_data_sem);
@@ -848,7 +672,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			(struct ext4_ext_defrag_data __user *)arg,
 			sizeof(defrag)))
 			return -EFAULT;
-		err = ext4_ext_defrag(filp, defrag.start_offset,
+		err = ext4_defrag(filp, defrag.start_offset,
 				defrag.defrag_size, defrag.goal, defrag.flag,
 				&defrag.ext);
 	}
@@ -857,7 +681,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 }
 
 /**
- * ext4_ext_merge_across - merge extents across leaf block
+ * ext4_defrag_merge_across_blocks - Merge extents across leaf block
  *
  * @handle	journal handle
  * @inode	target file's inode
@@ -871,7 +695,7 @@ int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
  * This function returns 0 if succeed, otherwise returns error value.
  */
 static int
-ext4_ext_merge_across_blocks(handle_t *handle, struct inode *inode,
+ext4_defrag_merge_across_blocks(handle_t *handle, struct inode *inode,
 		struct ext4_extent *o_start,
 		struct ext4_extent *o_end, struct ext4_extent *start_ext,
 		struct ext4_extent *new_ext, struct ext4_extent *end_ext,
@@ -943,7 +767,10 @@ ext4_ext_merge_across_blocks(handle_t *handle, struct inode *inode,
 		o_end->ee_len = end_ext->ee_len;
 		ext4_ext_store_pblock(o_end, ext_pblock(end_ext));
 
-		/* If new_ext was first block */
+		/*
+		 * Set 0 to the extent block if new_ext was
+		 * the first block.
+		 */
 		if (!new_ext->ee_block)
 			eblock = 0;
 		else
@@ -951,7 +778,7 @@ ext4_ext_merge_across_blocks(handle_t *handle, struct inode *inode,
 
 		new_flag = 1;
 	} else {
-		printk(KERN_ERR "Unexpected case \n");
+		printk(KERN_ERR "ext4 defrag: Unexpected merge case\n");
 		return -EIO;
 	}
 
@@ -960,12 +787,12 @@ ext4_ext_merge_across_blocks(handle_t *handle, struct inode *inode,
 		if (IS_ERR(org_path)) {
 			err = PTR_ERR(org_path);
 			org_path = NULL;
-			goto ERR;
+			goto out;
 		}
 		err = ext4_ext_insert_extent_defrag(handle, inode,
 					org_path, new_ext, defrag_flag);
 		if (err)
-			goto ERR;
+			goto out;
 	}
 
 	if (end_flag) {
@@ -974,14 +801,14 @@ ext4_ext_merge_across_blocks(handle_t *handle, struct inode *inode,
 		if (IS_ERR(org_path)) {
 			err = PTR_ERR(org_path);
 			org_path = NULL;
-			goto ERR;
+			goto out;
 		}
 		err = ext4_ext_insert_extent_defrag(handle, inode,
 					org_path, end_ext, defrag_flag);
 		if (err)
-			goto ERR;
+			goto out;
 	}
-ERR:
+out:
 	if (org_path) {
 		ext4_ext_drop_refs(org_path);
 		kfree(org_path);
@@ -992,23 +819,23 @@ ERR:
 }
 
 /**
- * ext4_ext_merge_inside_block - merge new extent to the extent block
+ * ext4_defrag_merge_inside_block - Merge new extent to the extent block
  *
- * @handle	journal handle
- * @inode	target file's inode
- * @o_start	first original extent to be defraged
- * @o_end	last original extent to be merged
- * @start_ext	first new extent to be merged
- * @new_ext	middle of new extent to be merged
- * @end_ext	last new extent to be merged
- * @eh		extent header of target leaf block
- * @replaced	the number of blocks which will be replaced with new_ext
- * @range_to_move used to dicide how to merge
+ * @handle		journal handle
+ * @inode		target file's inode
+ * @o_start		first original extent to be defraged
+ * @o_end		last original extent to be merged
+ * @start_ext		first new extent to be merged
+ * @new_ext		middle of new extent to be merged
+ * @end_ext		last new extent to be merged
+ * @eh			extent header of target leaf block
+ * @replaced		the number of blocks which will be replaced with new_ext
+ * @range_to_move	used to decide how to merge
  *
  * This function always returns 0.
-*/
+ */
 static int
-ext4_ext_merge_inside_block(handle_t *handle, struct inode *inode,
+ext4_defrag_merge_inside_block(handle_t *handle, struct inode *inode,
 		struct ext4_extent *o_start, struct ext4_extent *o_end,
 		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
 		struct ext4_extent *end_ext, struct ext4_extent_header *eh,
@@ -1047,23 +874,23 @@ ext4_ext_merge_inside_block(handle_t *handle, struct inode *inode,
 }
 
 /**
- * ext4_ext_merge_extents - merge new extent
+ * ext4_defrag_merge_extents - Merge new extent
  *
- * @handle      journal handle
- * @inode       target file's inode
- * @org_path    path indicates first extent to be defraged
- * @o_start     first original extent to be defraged
- * @o_end       last original extent to be defraged
- * @start_ext   first new extent to be merged
- * @new_ext     middle of new extent to be merged
- * @end_ext     last new extent to be merged
- * @replaced    the number of blocks which will be replaced with new_ext
- * @flag        defrag mode (e.g. -f)
+ * @handle	journal handle
+ * @inode	target file's inode
+ * @org_path	path indicates first extent to be defraged
+ * @o_start	first original extent to be defraged
+ * @o_end	last original extent to be defraged
+ * @start_ext	first new extent to be merged
+ * @new_ext	middle of new extent to be merged
+ * @end_ext	last new extent to be merged
+ * @replaced	the number of blocks which will be replaced with new_ext
+ * @flag	defrag mode (e.g. -f)
  *
  * This function returns 0 if succeed, otherwise returns error value.
  */
 static int
-ext4_ext_merge_extents(handle_t *handle, struct inode *inode,
+ext4_defrag_merge_extents(handle_t *handle, struct inode *inode,
 		struct ext4_ext_path *org_path,
 		struct ext4_extent *o_start, struct ext4_extent *o_end,
 		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
@@ -1073,8 +900,9 @@ ext4_ext_merge_extents(handle_t *handle, struct inode *inode,
 	unsigned need_slots, slots_range;
 	int	range_to_move, depth, ret;
 
-	/* The extents need to be inserted
-	 * start_extent + new_extent + end_extent
+	/*
+	 * The extents need to be inserted
+	 * start_extent + new_extent + end_extent.
 	 */
 	need_slots = (le16_to_cpu(start_ext->ee_len) ? 1 : 0) +
 			(le16_to_cpu(end_ext->ee_len) ? 1 : 0) +
@@ -1096,18 +924,18 @@ ext4_ext_merge_extents(handle_t *handle, struct inode *inode,
 			return ret;
 	}
 
-	/* expansion */
+	/* Expansion */
 	if ((range_to_move > 0) &&
 		(range_to_move > le16_to_cpu(eh->eh_max)
 			- le16_to_cpu(eh->eh_entries))) {
 
-		ret = ext4_ext_merge_across_blocks(handle, inode, o_start,
+		ret = ext4_defrag_merge_across_blocks(handle, inode, o_start,
 						o_end, start_ext, new_ext,
 						end_ext, flag);
 		if (ret < 0)
 			return ret;
 	} else {
-		ret = ext4_ext_merge_inside_block(handle, inode, o_start,
+		ret = ext4_defrag_merge_inside_block(handle, inode, o_start,
 					o_end, start_ext, new_ext, end_ext,
 					eh, replaced, range_to_move);
 		if (ret < 0)
@@ -1129,18 +957,19 @@ ext4_ext_merge_extents(handle_t *handle, struct inode *inode,
 }
 
 /**
- * ext4_ext_defrag_leaf_block -  Defragmentation for one leaf extent block.
- * @handle      journal handle
- * @org_inode   target inode
- * @org_path    path indicates first extent to be defraged
- * @dext        destination extent
- * @from        start offset on the target file
- * @flag        defrag mode (e.g. -f)
+ * ext4_defrag_leaf_block - Defragmentation for one leaf extent block
+ *
+ * @handle	journal handle
+ * @org_inode	target inode
+ * @org_path	path indicates first extent to be defraged
+ * @dext	destination extent
+ * @from	start offset on the target file
+ * @flag	defrag mode (e.g. -f)
  *
  * This function returns 0 if succeed, otherwise returns error value.
  */
 static int
-ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
+ext4_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 		struct ext4_ext_path *org_path, struct ext4_extent *dext,
 		ext4_lblk_t *from, int flag)
 {
@@ -1166,7 +995,8 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 	new_phys_end = ext_pblock(&new_ext)
 		+ le16_to_cpu(new_ext.ee_len) - 1;
 
-	/* First original extent
+	/*
+	 * First original extent
 	 * dest	 |---------------|
 	 * org  |---------------|
 	 */
@@ -1194,12 +1024,14 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 			new_ext.ee_len = 0;
 		}
 	}
-		for (;;) {
+
+	for (;;) {
 		/* The extent for destination must be found. */
 		BUG_ON(!oext || lblock != le32_to_cpu(oext->ee_block));
 		lblock += le16_to_cpu(oext->ee_len);
 
-		/* Middle of original extent
+		/*
+		 * Middle of original extent
 		 * dest |-------------------|
 		 * org   |-----------------|
 		 */
@@ -1209,7 +1041,8 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 			+ le16_to_cpu(oext->ee_len) - 1)
 			replaced += le16_to_cpu(oext->ee_len);
 
-		/* Last original extent
+		/*
+		 * Last original extent
 		 * dest |----------------|
 		 * org	  |---------------|
 		 */
@@ -1230,13 +1063,14 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 				- le16_to_cpu(end_ext.ee_len);
 		}
 
-		/* Detected the block end, reached the number of replaced
-		 * blocks to dext->ee_len.  Then, merge the extent.
+		/*
+		 * Detected the block end, reached the number of replaced
+		 * blocks to dext->ee_len. Then merge the extent.
 		 */
 		if (oext == EXT_LAST_EXTENT(org_path[depth].p_hdr) ||
 			new_end <= le32_to_cpu(oext->ee_block)
 				+ le16_to_cpu(oext->ee_len) - 1) {
-			ret = ext4_ext_merge_extents(handle, org_inode,
+			ret = ext4_defrag_merge_extents(handle, org_inode,
 					org_path, o_start, o_end, &start_ext,
 					&new_ext, &end_ext, replaced, flag);
 			if (ret < 0)
@@ -1249,19 +1083,19 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 				return 0;
 			}
 
-			/* re-calculate new_ext */
+			/* Re-calculate new_ext */
 			new_ext.ee_len = cpu_to_le32(le16_to_cpu(new_ext.ee_len)
 				- replaced);
 			new_ext.ee_block =
 				cpu_to_le32(le32_to_cpu(new_ext.ee_block)
 				+ replaced);
 			ext4_ext_store_pblock(&new_ext, ext_pblock(&new_ext)
-					 + replaced);
+					+ replaced);
 			replaced = 0;
 			start_ext.ee_len = end_ext.ee_len = 0;
 			o_start = NULL;
 
-			/* All expected blocks are replaced */
+			/* All expected blocks are replaced. */
 			if (le16_to_cpu(new_ext.ee_len) <= 0) {
 				if (DQUOT_ALLOC_BLOCK(org_inode, len))
 					return -EDQUOT;
@@ -1269,7 +1103,7 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 			}
 		}
 
-		/* Get next extent for original. */
+		/* Get the next extent for original. */
 		if (org_path)
 			ext4_ext_drop_refs(org_path);
 		org_path = ext4_ext_find_extent(org_inode, lblock, org_path);
@@ -1290,22 +1124,24 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
 }
 
 /**
- * ext4_ext_replace_branches - replace original extents with new extents.
- * @org_inode    Original inode
- * @dest_inode   temporary inode
- * @from_page    Page offset
- * @count_page   Page count to be replaced
- * @flag         defrag mode (e.g. -f)
+ * ext4_defrag_replace_branches - Replace original extents with new extents
+ *
+ * @handle		journal handle
+ * @org_inode		original inode
+ * @dest_inode		temporary inode
+ * @from_page		page offset of org_inode
+ * @dest_from_page	page offset of dest_inode
+ * @count_page		page count to be replaced
+ * @flag		defrag mode (e.g. -f)
  *
  * This function returns 0 if succeed, otherwise returns error value.
  * Replace extents for blocks from "from" to "from + count - 1".
  */
 static int
-ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
-			pgoff_t from_page,  pgoff_t dest_from_page,
-			pgoff_t count_page, int flag)
+ext4_defrag_replace_branches(handle_t *handle, struct inode *org_inode,
+			struct inode *dest_inode, pgoff_t from_page,
+			pgoff_t dest_from_page, pgoff_t count_page, int flag)
 {
-	handle_t *handle = NULL;
 	struct ext4_ext_path *org_path = NULL;
 	struct ext4_ext_path *dest_path = NULL;
 	struct ext4_extent *oext, *dext, *swap_ext;
@@ -1314,7 +1150,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	int err = 0;
 	int depth;
 	int replaced_count = 0;
-	unsigned jnum;
 
 	from = (ext4_lblk_t)from_page <<
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
@@ -1322,12 +1157,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
 	dest_off = (ext4_lblk_t)dest_from_page <<
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
-	jnum = ext4_ext_writepage_trans_blocks(org_inode, count) + 3;
-	handle = ext4_journal_start(org_inode, jnum);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		goto out;
-	}
 
 	/* Get the original extent for the block "from" */
 	org_path = ext4_ext_find_extent(org_inode, from, NULL);
@@ -1361,7 +1190,7 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	ext4_ext_store_pblock(&tmp_ext2, ext_pblock(oext) + org_diff);
 	tmp_ext2.ee_block = tmp_ext.ee_block;
 
-	/* adjust extent length when blocksize != pagesize */
+	/* Adjust extent length when blocksize != pagesize */
 	if (tmp_ext.ee_len <= (oext->ee_len - org_diff)) {
 		tmp_ext2.ee_len = tmp_ext.ee_len;
 	} else {
@@ -1370,22 +1199,23 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	}
 	swap_ext = &tmp_ext2;
 
-	/* loop for the destination extents */
+	/* Loop for the destination extents */
 	while (1) {
 		/* The extent for destination must be found. */
 		BUG_ON(!dext || dest_off != le32_to_cpu(dext->ee_block));
 
-		/* loop for the original extent blocks */
-		err = ext4_ext_defrag_leaf_block(handle, org_inode,
+		/* Loop for the original extent blocks */
+		err = ext4_defrag_leaf_block(handle, org_inode,
 						org_path, dext, &from, flag);
 		if (err < 0)
 			goto out;
 
-		/* We need the function which fixes extent information for
+		/*
+		 * We need the function which fixes extent information for
 		 * inserting.
-		 * e.g. ext4_ext_merge_extents().
+		 * e.g. ext4_defrag_merge_extents()
 		 */
-		err = ext4_ext_defrag_leaf_block(handle, dest_inode,
+		err = ext4_defrag_leaf_block(handle, dest_inode,
 					dest_path, swap_ext, &dest_off, -1);
 		if (err < 0)
 			goto out;
@@ -1444,7 +1274,7 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 		ext4_ext_store_pblock(&tmp_ext2, ext_pblock(oext) + org_diff);
 		tmp_ext2.ee_block = tmp_ext.ee_block;
 
-		/* adjust extent length when blocksize != pagesize */
+		/* Adjust extent length when blocksize != pagesize */
 		if (tmp_ext.ee_len <= (oext->ee_len - org_diff)) {
 			tmp_ext2.ee_len = tmp_ext.ee_len;
 		} else {
@@ -1455,8 +1285,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	}
 
 out:
-	if (handle)
-		ext4_journal_stop(handle);
 	if (org_path) {
 		ext4_ext_drop_refs(org_path);
 		kfree(org_path);
@@ -1470,18 +1298,19 @@ out:
 }
 
 /**
- * ext4_ext_alloc_blocks - allocate contiguous blocks to temporary inode
- * @dest_inode   temporary inode for multiple block allocation
- * @org_inode    original inode
- * @iblock       file related offset
- * @total_blocks contiguous blocks count
- * @goal	 block offset for allocation
- * @phase        phase of create free space mode
+ * ext4_defrag_alloc_blocks - Allocate contiguous blocks to temporary inode
+ *
+ * @dest_inode		temporary inode for multiple block allocation
+ * @org_inode		original inode
+ * @iblock		file related offset
+ * @total_blocks	contiguous blocks count
+ * @goal		block offset for allocation
+ * @phase		phase of the force defrag mode
  *
  * If succeed, fuction returns count of extent we got,
  * otherwise returns err.
  */
-static int ext4_ext_alloc_blocks(struct inode *dest_inode,
+static int ext4_defrag_alloc_blocks(struct inode *dest_inode,
 		struct inode *org_inode, ext4_lblk_t iblock,
 		ext4_fsblk_t total_blocks, ext4_fsblk_t goal, int phase)
 {
@@ -1525,7 +1354,7 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 		ar.excepted_group = -1;
 	}
 
-	/* Find first extent. */
+	/* Find first extent */
 	dest_path = ext4_ext_find_extent(dest_inode, iblock, dest_path);
 	if (IS_ERR(dest_path)) {
 		err = PTR_ERR(dest_path);
@@ -1536,11 +1365,11 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 	ar.inode = dest_inode;
 	ar.flags = EXT4_MB_HINT_DATA | EXT4_MB_HINT_RESERVED
 		| EXT4_MB_HINT_NOPREALLOC;
-	if (goal) {
+
+	if (goal)
 		ar.goal = goal;
-	} else {
+	else
 		ar.goal = ext4_ext_find_goal(dest_inode, dest_path, iblock);
-	}
 
 	ar.logical = iblock;
 	ar.lleft = 0;
@@ -1572,23 +1401,22 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 				(phase == DEFRAG_FORCE_TRY)) {
 			ext4_free_blocks(handle, org_inode, newblock,
 						ar.len, metadata);
-			/* go to force mode */
+			/* -ENOSPC triggers DEFRAG_FORCE_VICTIM phase. */
 			err = -ENOSPC;
 			goto out;
 		} else {
 			/*
-			 * If ext4_mb_new_blocks() allcates
-			 * the block which used to be the metadata block,
-			 * its dirty buffer_head causes the overwriting
-			 * with old metadata.
+			 * Dirty buffer_head causes the overwriting
+			 * if ext4_mb_new_blocks() allocates the block
+			 * which used to be the metadata block.
 			 * We should call unmap_underlying_metadata()
 			 * to clear the dirty flag.
 			 */
 			for (len_cnt = 0; len_cnt < ar.len; len_cnt++) {
 				bh = sb_find_get_block(org_sb,
-						       newblock + len_cnt);
+							newblock + len_cnt);
 				unmap_underlying_metadata(org_sb->s_bdev,
-							  newblock + len_cnt);
+							newblock + len_cnt);
 			}
 
 			alloc_total += ar.len;
@@ -1596,12 +1424,18 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 				goal, &goal_grp_no, &goal_blk_off);
 			ext4_get_group_no_and_offset(dest_inode->i_sb,
 				newblock, &dest_grp_no, &dest_blk_off);
-			/* We can't allocate at the same block group */
+
+			/* Only the force defrag mode */
 			switch (phase) {
 			case DEFRAG_FORCE_VICTIM:
+				/*
+				 * We can't allocate new blocks in the same
+				 * block group.
+				 */
 				if (dest_grp_no == org_grp_no) {
-					printk(KERN_ERR "defrag: Can't allocate"
-					" in same block group\n");
+					printk(KERN_ERR "ext4 defrag: "
+						"Failed to allocate victim file"
+						" to other block group\n");
 					ext4_free_blocks(handle, org_inode,
 						newblock, ar.len, metadata);
 					err = -ENOSPC;
@@ -1609,12 +1443,15 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 				}
 				break;
 			case DEFRAG_FORCE_GATHER:
-				/* Maybe reserved blocks are already used by
-				   other process */
+				/*
+				 * Maybe reserved blocks are already used by
+				 * other process.
+				 */
 				if (dest_grp_no != goal_grp_no
 					|| alloc_total != total_blocks) {
-					printk(KERN_ERR "defrag: Already used"
-						" the specified blocks\n");
+					printk(KERN_ERR "ext4 defrag: "
+						"Reserved blocks are already "
+						"used by other process\n");
 					ext4_free_blocks(handle, org_inode,
 						newblock, ar.len, metadata);
 					err = -EIO;
@@ -1645,11 +1482,14 @@ static int ext4_ext_alloc_blocks(struct inode *dest_inode,
 	}
 
 out:
-	/* Faild case: We have to remove halfway blocks */
-	if (err)
+	if (err) {
+		/* Faild case: We have to remove halfway blocks */
 		err2 = ext4_ext_remove_space(dest_inode, 0);
-
-	/* Successful case */
+		if (err2)
+			printk(KERN_ERR "ext4 defrag: "
+				"Failed to remove temporary inode blocks\n");
+	}
+out2:
 	if (dest_path) {
 		ext4_ext_drop_refs(dest_path);
 		kfree(dest_path);
@@ -1658,107 +1498,27 @@ out:
 		ext4_ext_drop_refs(org_path);
 		kfree(org_path);
 	}
-out2:
-	ext4_journal_stop(handle);
-
-	if (err2) {
-		return err2;
-	} else if (err) {
-		return err;
-	}
-	/* return extents count */
-	return count;
-}
-
-/**
- * ext4_ext_defrag_partial - defrag original file partially
- * @filp:		pointer to file
- * @org_offset:		page index on original file
- * @dest_offset:	page index on temporary file
- * @flag:		defrag mode (e.g. -f)
- *
- * This function returns 0 if succeeded, otherwise returns error value
- */
-static int
-ext4_ext_defrag_partial(struct inode *tmp_inode, struct file *filp,
-			pgoff_t org_offset, pgoff_t dest_offset, int flag)
-{
-	struct inode *inode = filp->f_dentry->d_inode;
-	struct address_space *mapping = inode->i_mapping;
-	struct page *page;
-	pgoff_t offset_in_page = PAGE_SIZE;
-	int ret = 0;
-
-	up_write(&EXT4_I(inode)->i_data_sem);
-	page = read_cache_page(inode->i_mapping, org_offset,
-		(filler_t *)inode->i_mapping->a_ops->readpage, NULL);
-	down_write(&EXT4_I(inode)->i_data_sem);
-
-	if (IS_ERR(page)) {
-		ret = PTR_ERR(page);
-		return ret;
-	}
-
-	lock_page(page);
 
-	/*
-	 * try_to_release_page() doesn't call relasepage in writeback mode.
-	 * We should care about the order of writing to the same file
-	 * by multiple defrag processes.
-	 * It needs to call wait_on_page_writeback() to wait for the
-	 * writeback of the page.
-	 */
-	if (PageWriteback(page))
-		wait_on_page_writeback(page);
-
-	/* release old bh and drop refs */
-	try_to_release_page(page, 0);
-	ret = ext4_ext_replace_branches(inode, tmp_inode, org_offset,
-			dest_offset, 1, flag);
-	if (ret < 0)
-		goto ERR;
-
-	/* Clear the inode cache not to refer to the old data. */
-	ext4_ext_invalidate_cache(inode);
-
-	if (org_offset == ((inode->i_size - 1) >> PAGE_CACHE_SHIFT)) {
-		offset_in_page = (inode->i_size & (PAGE_CACHE_SIZE - 1));
-		/*
-		 * If org_offset is the last page and i_size is
-		 * multiples of PAGE_CACHE_SIZE, set PAGE_CACHE_SIZE to
-		 * offset_in_page not to be 0.
-		 */
-		if (offset_in_page == 0)
-			offset_in_page = PAGE_CACHE_SIZE;
-	}
-
-	up_write(&EXT4_I(inode)->i_data_sem);
-	ret = mapping->a_ops->prepare_write(filp, page,
-					0, offset_in_page);
-	down_write(&EXT4_I(inode)->i_data_sem);
-	if (ret)
-		goto ERR;
+	ext4_journal_stop(handle);
 
-	ret = mapping->a_ops->commit_write(filp, page,
-					0, offset_in_page);
-ERR:
-	unlock_page(page);
-	page_cache_release(page);
+	/* Return extents count or err value */
+	return (!err ? count : err);
 
-	return (ret < 0 ? ret : 0);
 }
 
 /**
- * ext4_ext_defrag_partial2 - defrag_partial with write_{begin, end}
+ * ext4_defrag_partial - Defrag a file per page
+ *
+ * @tmp_inode:		the inode which has blocks to swap with original
  * @filp:		pointer to file
  * @org_offset:		page index on original file
  * @dest_offset:	page index on temporary file
  * @flag:		defrag mode (e.g. -f)
  *
- * This function returns 0 if succeeded, otherwise returns error value
+ * This function returns 0 if succeeded, otherwise returns error value.
  */
 static int
-ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
+ext4_defrag_partial(struct inode *tmp_inode, struct file *filp,
 			pgoff_t org_offset, pgoff_t dest_offset, int flag)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
@@ -1766,7 +1526,9 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	struct buffer_head *bh;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
+	handle_t *handle;
 	pgoff_t offset_in_page = PAGE_SIZE;
+	int jblocks;
 	int ret = 0;
 	int blocksize = inode->i_sb->s_blocksize;
 	int blocks_per_page = 0;
@@ -1776,15 +1538,26 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	unsigned int w_flags = 0;
 	void *fsdata;
 
+	/*
+	 * It needs twice the amount of ordinary journal buffers because
+	 * inode and tmp_inode may change each different metadata blocks.
+	 */
+	jblocks = ext4_writepage_trans_blocks(inode) * 2;
+	handle = ext4_journal_start(inode, jblocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
 	if (segment_eq(get_fs(), KERNEL_DS))
 		w_flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
 	if (org_offset == ((inode->i_size - 1) >> PAGE_CACHE_SHIFT)) {
 		offset_in_page = (inode->i_size & (PAGE_CACHE_SIZE - 1));
 		/*
-		 * If org_offset is the last page and i_size is
-		 * multiples of PAGE_CACHE_SIZE, set PAGE_CACHE_SIZE to
-		 * offset_in_page not to be 0.
+		 * Set PAGE_CACHE_SIZE to offset_in_page not be 0
+		 * if org_offset is the last page and i_size is
+		 * multiples of PAGE_CACHE_SIZE.
 		 */
 		if (offset_in_page == 0)
 			offset_in_page = PAGE_CACHE_SIZE;
@@ -1796,7 +1569,7 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	down_write(&EXT4_I(inode)->i_data_sem);
 
 	if (unlikely(ret < 0))
-		goto ERR;
+		goto out;
 
 	if (!PageUptodate(page)) {
 		mapping->a_ops->readpage(filp, page);
@@ -1813,15 +1586,15 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	if (PageWriteback(page))
 		wait_on_page_writeback(page);
 
-	/* release old bh and drop refs */
+	/* Release old bh and drop refs */
 	try_to_release_page(page, 0);
-	ret = ext4_ext_replace_branches(inode, tmp_inode, org_offset,
-			dest_offset, 1, flag);
+	ret = ext4_defrag_replace_branches(handle, inode, tmp_inode,
+					org_offset, dest_offset, 1, flag);
 
 	if (ret < 0)
-		goto ERR;
+		goto out;
 
-	/* Clear the inode cache not to refer to the old data. */
+	/* Clear the inode cache not to refer to the old data */
 	ext4_ext_invalidate_cache(inode);
 
 	if (!page_has_buffers(page))
@@ -1837,7 +1610,7 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 		down_write(&EXT4_I(inode)->i_data_sem);
 
 		if (ret < 0)
-			goto ERR;
+			goto out;
 
 		if (bh->b_this_page != NULL)
 			bh = bh->b_this_page;
@@ -1847,13 +1620,16 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 				offset_in_page, page, fsdata);
 
 	if (unlikely(ret < 0))
-		goto ERR;
-ERR:
+		goto out;
+out:
+	ext4_journal_stop(handle);
+
 	return (ret < 0 ? ret : 0);
 }
 
 /**
- * ext4_ext_new_extent_tree -  allocate contiguous blocks
+ * ext4_defrag_new_extent_tree -  Allocate contiguous blocks
+ *
  * @inode:		inode of the original file
  * @tmp_inode:		inode of the temporary file
  * @path:		the structure holding some info about
@@ -1862,15 +1638,15 @@ ERR:
  * @tar_blocks:		the number of blocks to allocate
  * @iblock:		file related offset
  * @goal:		block offset for allocaton
- * @flag:               phase of create free space mode
+ * @flag:               phase of the force defrag mode
  *
  * This function returns the value as below:
- * 	0(succeeded)
+ *	0(succeeded)
  *	1(not improved)
  *	negative value(error)
  */
 static int
-ext4_ext_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
+ext4_defrag_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
 			struct ext4_ext_path *path, ext4_lblk_t tar_start,
 			ext4_lblk_t tar_blocks, ext4_lblk_t iblock,
 			ext4_fsblk_t goal, int flag)
@@ -1885,12 +1661,12 @@ ext4_ext_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
 	eh = ext_inode_hdr(tmp_inode);
 	eh->eh_depth = 0;
 
-	/* allocate contiguous blocks */
-	sum_tmp = ext4_ext_alloc_blocks(tmp_inode, inode, iblock,
+	/* Allocate contiguous blocks */
+	sum_tmp = ext4_defrag_alloc_blocks(tmp_inode, inode, iblock,
 					tar_blocks, goal, flag);
 	if (sum_tmp < 0) {
 		ret = sum_tmp;
-		goto ERR;
+		goto out;
 	}
 
 	depth = ext_depth(inode);
@@ -1904,45 +1680,46 @@ ext4_ext_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
 			       last_extent) {
 
 			if ((sum_org == sum_tmp) && !goal) {
-				/* not improved */
-				if (!(ret =
-					ext4_ext_remove_space(tmp_inode, 0)))
+				/* Not improved */
+				ret = ext4_ext_remove_space(tmp_inode, 0);
+				if (!ret)
 					ret = 1;
 			} else if (sum_org < sum_tmp &&
 					flag != DEFRAG_FORCE_VICTIM) {
-				/* fragment increased */
-				if (!(ret =
-					ext4_ext_remove_space(tmp_inode, 0)))
+				/* Fragment increased */
+				ret = ext4_ext_remove_space(tmp_inode, 0);
+				if (!ret)
 					ret = -ENOSPC;
-				printk("defrag failed due to no space\n");
-			}
+				printk(KERN_ERR "ext4 defrag: "
+					"Insufficient free blocks\n");
+				}
 			break;
 		}
-		if ((last_extent =
-			ext4_ext_next_extent(tmp_inode,
-				path, &ext)) < 0) {
+		last_extent = ext4_defrag_next_extent(tmp_inode, path, &ext);
+		if (last_extent < 0) {
 			ret = last_extent;
 			break;
 		}
 	}
-ERR:
+out:
 	return ret;
 }
 
 /**
- * ext4_ext_defrag - defrag whole file
- * @filp:            pointer to file
- * @from:            starting offset to defrag in blocks
- * @defrag_size:     size of defrag in blocks
- * @goal:            block offset for allocation
- * @flag:            phase of create free space mode
- * @ext:             extent to be moved (only -f)
+ * ext4_defrag - Defrag the specified range of a file
+ *
+ * @filp:		pointer to file
+ * @from:		starting offset to defrag in blocks
+ * @defrag_size:	size of defrag in blocks
+ * @goal:		block offset for allocation
+ * @flag:		phase of the force defrag mode
+ * @ext:		extent to be moved (only -f)
  *
  * This function returns the number of blocks if succeeded, otherwise
- * returns error value
+ * returns error value.
  */
 int
-ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
+ext4_defrag(struct file *filp, ext4_lblk_t block_start,
 		ext4_lblk_t defrag_size, ext4_fsblk_t goal,
 		int flag, struct ext4_extent_data *ext)
 {
@@ -1958,20 +1735,26 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 	pgoff_t page_offset = 0, dest_offset = 0, seq_end_page = 0;
 	int ret = 0, depth = 0, last_extent = 0, seq_extents = 0;
 
-	/* Check goal offset if goal offset was given from userspace. */
+	/* ext4 defrag needs mballoc mount option. */
+	if (!test_opt(inode->i_sb, MBALLOC)) {
+		printk(KERN_ERR "ext4 defrag: multiblock allocation "
+				"is disabled\n");
+		return -EINVAL;
+	}
+
+	/* Check goal offset if goal offset was given from userspace */
 	if (((0 < goal) && (ext4_blocks_count(es) < goal)) && (goal != -1)) {
-		printk(KERN_ERR "defrag: incorrect goal number %llu, "
-			"you can set goal until %llu\n", goal,
-			ext4_blocks_count(es));
-		ret = -EINVAL;
-		goto ERR1;
+		printk(KERN_ERR "ext4 defrag: Invalid goal offset %llu, "
+				"you can set goal offset up to %llu\n", goal,
+						ext4_blocks_count(es));
+		return -EINVAL;
 	}
 
-	/* Setup for fixed blocks mode */
 	if (ext->len) {
+		/* Setup for the force defrag mode */
 		if (ext->len < defrag_size) {
-			printk("Cannot defrag due to the insufficient"
-			" specified free blocks\n");
+			printk(KERN_ERR "ext4 defrag: "
+					"Invalid length of extent\n");
 			return -EINVAL;
 		}
 		flag = DEFRAG_FORCE_GATHER;
@@ -1988,51 +1771,51 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		path = NULL;
-		goto ERR2;
+		goto out;
 	}
 
-	/* get path structure to check hole */
+	/* Get path structure to check the hole */
 	holecheck_path = ext4_ext_find_extent(inode, block_start, NULL);
 	if (IS_ERR(holecheck_path)) {
 		ret = PTR_ERR(holecheck_path);
 		holecheck_path = NULL;
-		goto ERR2;
+		goto out;
 	}
 
 	depth = ext_depth(inode);
 	ext_cur = holecheck_path[depth].p_ext;
 	if (ext_cur == NULL)
-		goto ERR2;
+		goto out;
 
 	/*
-	 * if block_start was within the hole, get proper extent whose ee_block
-	 * is beyond block_start
+	 * Get proper extent whose ee_block is beyond block_start
+	 * if block_start was within the hole.
 	 */
 	if (le32_to_cpu(ext_cur->ee_block) +
 		le32_to_cpu(ext_cur->ee_len) - 1 < block_start) {
-		if ((last_extent =
-				ext4_ext_next_extent(inode, holecheck_path,
-				&ext_cur)) < 0) {
+		last_extent = ext4_defrag_next_extent(inode, holecheck_path,
+				&ext_cur);
+		if (last_extent < 0) {
 			ret = last_extent;
-			goto ERR2;
+			goto out;
 		}
-		if ((last_extent =
-				ext4_ext_next_extent(inode, path,
-				&ext_dummy)) < 0) {
+		last_extent = ext4_defrag_next_extent(inode, path, &ext_dummy);
+		if (last_extent < 0) {
 			ret = last_extent;
-			goto ERR2;
+			goto out;
 		}
 	}
 	seq_extents = 1;
 	seq_start = ext_cur->ee_block;
 
-	/* no blocks existed within designated range */
+	/* No blocks within the specified range. */
 	if (le32_to_cpu(ext_cur->ee_block) > block_end) {
-		printk("nothing done due to the lack of contiguous blocks\n");
-		goto ERR2;
+		printk(KERN_INFO "ext4 defrag: The specified range of file"
+				" may be the hole\n");
+		goto out;
 	}
 
-	/* adjust start blocks */
+	/* Adjust start blocks */
 	add_blocks = min(ext_cur->ee_block +
 			 ext_cur->ee_len, block_end + 1) -
 		     max(ext_cur->ee_block, block_start);
@@ -2046,7 +1829,7 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 			2 * EXT4_QUOTA_INIT_BLOCKS(inode->i_sb) + 1);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-			goto ERR1;
+			goto out;
 		}
 		tmp_inode = ext4_new_inode(handle,
 			inode->i_sb->s_root->d_inode, S_IFREG);
@@ -2054,7 +1837,7 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 			ret = -ENOMEM;
 			ext4_journal_stop(handle);
 			tmp_inode = NULL;
-			goto ERR1;
+			goto out;
 		}
 
 		i_size_write(tmp_inode, i_size_read(inode));
@@ -2063,14 +1846,14 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 		ext4_orphan_add(handle, tmp_inode);
 		ext4_journal_stop(handle);
 
-		/* adjust tail blocks */
+		/* Adjust tail blocks */
 		if (seq_start + seq_blocks - 1 > block_end)
 			seq_blocks = block_end - seq_start + 1;
 
 		ext_prev = ext_cur;
-		if ((last_extent =
-				ext4_ext_next_extent(inode, holecheck_path,
-				&ext_cur)) < 0) {
+		last_extent = ext4_defrag_next_extent(inode, holecheck_path,
+				&ext_cur);
+		if (last_extent < 0) {
 			ret = last_extent;
 			break;
 		}
@@ -2078,8 +1861,9 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 			seq_extents++;
 		add_blocks = le16_to_cpu(ext_cur->ee_len);
 
-		/* found hole or reached the tail of either a designated range
-		 * or the file
+		/*
+		 * Extend the length of contiguous block (seq_blocks)
+		 * if extents are contiguous.
 		 */
 		if ((le32_to_cpu(ext_prev->ee_block) +
 				le16_to_cpu(ext_prev->ee_len) ==
@@ -2093,13 +1877,13 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 			continue;
 		}
 
-		/* found an isolated block */
+		/* Found an isolated block */
 		if ((seq_extents == 1) && !goal) {
 			seq_start = ext_cur->ee_block;
 			goto CLEANUP;
 		}
 
-		ret = ext4_ext_new_extent_tree(inode, tmp_inode, path,
+		ret = ext4_defrag_new_extent_tree(inode, tmp_inode, path,
 			seq_start, seq_blocks, block_start, goal, flag);
 
 		if (ret < 0) {
@@ -2118,40 +1902,26 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 		dest_offset = 0;
 		seq_start = le32_to_cpu(ext_cur->ee_block);
 
-		/* Discard all preallocations.
+		/*
+		 * Discard all preallocations.
 		 * This is provisional solution.
 		 * When true ext4_mb_return_to_preallocation() is
 		 * implemented, this will be removed.
 		 */
 		ext4_mb_discard_inode_preallocations(inode);
 
-		if (inode->i_mapping->a_ops->write_begin) {
-			while (page_offset <= seq_end_page) {
-				/* replace original branches for new branches */
-				ret = ext4_ext_defrag_partial2(tmp_inode,
-							filp, page_offset,
-							dest_offset, flag);
-				if (ret < 0)
-					goto ERR2;
-
-				page_offset++;
-				dest_offset++;
-			}
-		} else {
-			while (page_offset <= seq_end_page) {
-				/* replace original branches for new branches */
-				ret = ext4_ext_defrag_partial(tmp_inode,
-							filp, page_offset,
-							dest_offset, flag);
-				if (ret < 0)
-					goto ERR2;
-
-				page_offset++;
-				dest_offset++;
-			}
+		while (page_offset <= seq_end_page) {
+			/* Swap original branches with new branches */
+			ret = ext4_defrag_partial(tmp_inode, filp,
+					page_offset, dest_offset, flag);
+			if (ret < 0)
+				goto out;
+
+			page_offset++;
+			dest_offset++;
 		}
 
-		/* decrease buffer counter */
+		/* Decrease buffer counter */
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
 		holecheck_path =
@@ -2164,7 +1934,7 @@ ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
 		depth = holecheck_path->p_depth;
 
 CLEANUP:
-		/* decrease buffer counter */
+		/* Decrease buffer counter */
 		if (path)
 			ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode, seq_start, path);
@@ -2186,7 +1956,7 @@ CLEANUP:
 		}
 	}
 
-ERR2:
+out:
 	if (path) {
 		ext4_ext_drop_refs(path);
 		kfree(path);
@@ -2195,7 +1965,7 @@ ERR2:
 		ext4_ext_drop_refs(holecheck_path);
 		kfree(holecheck_path);
 	}
-ERR1:
+
 	up_write(&EXT4_I(inode)->i_data_sem);
 	mutex_unlock(&inode->i_mutex);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ff18c70..767e550 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1531,11 +1531,10 @@ repeat:
 			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 	}
 
-	if (defrag) {
+	if (defrag)
 		defrag_goal = ext_pblock(newext);
-	} else {
+	else
 		defrag_goal = 0;
-	}
 	/*
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2f7524f..ed3876b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -231,9 +231,6 @@ flags_err:
 
 		return err;
 	}
-	case EXT4_IOC_GET_EXTENTS:
-	case EXT4_IOC_GET_TREE_STATS:
-	case EXT4_IOC_GET_TREE_DEPTH:
 	case EXT4_IOC_FIBMAP:
 	case EXT4_IOC_DEFRAG:
 	case EXT4_IOC_GROUP_INFO:
@@ -242,7 +239,7 @@ flags_err:
 	case EXT4_IOC_RESERVE_BLOCK:
 	case EXT4_IOC_MOVE_VICTIM:
 	case EXT4_IOC_BLOCK_RELEASE: {
-		return ext4_ext_ioctl(inode, filp, cmd, arg);
+		return ext4_defrag_ioctl(inode, filp, cmd, arg);
 	}
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7f1ff75..b07f34f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2046,9 +2046,8 @@ repeat:
 				group = 0;
 
 			if (ac->ac_excepted_group != -1 &&
-			    group == ac->ac_excepted_group) {
+			    group == ac->ac_excepted_group)
 				continue;
-			}
 
 			/* quick check to skip empty groups */
 			grp = ext4_get_group_info(ac->ac_sb, group);
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 84631ec..03b4154 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -300,9 +300,6 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_MIGRATE		_IO('f', 7)
-#define EXT4_IOC_GET_EXTENTS		_IOR('f', 7, long)
-#define EXT4_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
-#define EXT4_IOC_GET_TREE_STATS		_IOR('f', 9, long)
 #define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
 #define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)
 #define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
@@ -310,7 +307,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
 #define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
 #define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
-#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 16)
+#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 8)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -1174,10 +1171,10 @@ extern void ext4_inode_table_set(struct super_block *sb,
 /* extents.c */
 extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
 /* defrag.c */
-extern int ext4_ext_defrag(struct file *filp, ext4_lblk_t block_start,
-				ext4_lblk_t defrag_size, ext4_fsblk_t goal,
-				int flag, struct ext4_extent_data *ext);
-extern int ext4_ext_ioctl(struct inode *, struct file *, unsigned int,
+extern int ext4_defrag(struct file *filp, ext4_lblk_t block_start,
+			ext4_lblk_t defrag_size, ext4_fsblk_t goal,
+			int flag, struct ext4_extent_data *ext);
+extern int ext4_defrag_ioctl(struct inode *, struct file *, unsigned int,
 				unsigned long);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 7f0140f..6fb42b1 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -124,19 +124,6 @@ struct ext4_ext_path {
 #define EXT4_EXT_CACHE_GAP	1
 #define EXT4_EXT_CACHE_EXTENT	2
 
-/*
- * to be called by ext4_ext_walk_space()
- * negative retcode - error
- * positive retcode - signal for ext4_ext_walk_space(), see below
- * callback must return valid extent (passed or newly created)
- */
-typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
-					struct ext4_ext_cache *,
-					void *);
