From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 2/6 ]Ext4: journal credits reservation fixes for extent
	file writepage
Date: Tue, 12 Aug 2008 09:27:53 -0700
Message-ID: <1218558473.6766.44.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35231 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYHLQ2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 12:28:17 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CGSGfD016978
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:28:16 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CGSGtf197400
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:28:16 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CGSFLL016420
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:28:15 -0400
In-Reply-To: <1218558190.6766.37.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4: journal credits reservation fixes for extent file writepage

From: Mingming Cao <cmm@us.ibm.com>

This patch modified the writepage/write_begin credit calculation for
extent files, to use the credits calculation helper function. 

The current calculation of how many index/leaf blocks should be
accounted is too Conservative, it always consider the worse case, where
the tree level is 5, and in the case of multiple chunk allocation, it
always multiple the needed credits. This path uses the accurate depth of
the inode with some extras to calculate the index blocks, and also less
Conservative in the case of multiple allocation accounting.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
---
 fs/ext4/ext4.h         |    2 
 fs/ext4/ext4_extents.h |    3 -
 fs/ext4/extents.c      |  100 +++++++++++++++++++++++++++----------------------
 fs/ext4/inode.c        |    2 
 fs/ext4/migrate.c      |    3 -
 5 files changed, 62 insertions(+), 48 deletions(-)

Index: linux-2.6.27-rc1/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/ext4_extents.h	2008-08-12 07:26:48.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/ext4_extents.h	2008-08-12 07:46:29.000000000 -0700
@@ -216,7 +216,8 @@ extern int ext4_ext_calc_metadata_amount
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
-extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
+						   struct ext4_ext_path *path);
 extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
Index: linux-2.6.27-rc1/fs/ext4/extents.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/extents.c	2008-08-12 07:26:48.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/extents.c	2008-08-12 07:50:27.000000000 -0700
@@ -1747,54 +1747,50 @@ static int ext4_ext_rm_idx(handle_t *han
 }
 
 /*
- * ext4_ext_calc_credits_for_insert:
- * This routine returns max. credits that the extent tree can consume.
- * It should be OK for low-performance paths like ->writepage()
- * To allow many writing processes to fit into a single transaction,
- * the caller should calculate credits under i_data_sem and
- * pass the actual path.
+ * ext4_ext_calc_credits_for_single_extent:
+ * This routine returns max. credits that needed to insert an extent
+ * to the extent tree.
+ * When pass the actual path, the caller should calculate credits
+ * under i_data_sem.
  */
-int ext4_ext_calc_credits_for_insert(struct inode *inode,
+int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
 						struct ext4_ext_path *path)
 {
-	int depth, needed;
+	int depth = ext_depth(inode);
 
 	if (path) {
 		/* probably there is space in leaf? */
-		depth = ext_depth(inode);
 		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
 				< le16_to_cpu(path[depth].p_hdr->eh_max))
-			return 1;
+			return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
 	}
 
-	/*
-	 * given 32-bit logical block (4294967296 blocks), max. tree
-	 * can be 4 levels in depth -- 4 * 340^4 == 53453440000.
-	 * Let's also add one more level for imbalance.
-	 */
-	depth = 5;
-
-	/* allocation of new data block(s) */
-	needed = 2;
+	return ext4_ext_writepage_trans_blocks(inode, num, 1);
+}
 
-	/*
-	 * tree can be full, so it would need to grow in depth:
-	 * we need one credit to modify old root, credits for
-	 * new root will be added in split accounting
-	 */
-	needed += 1;
+/*
+ * How many index/leaf blocks need to change/allocate to modify nrblocks?
+ *
+ * if nrblocks are fit in a single extent (chunk flag is 1), then
+ * in the worse case, each tree level index/leaf need to be changed
+ * if the tree split due to insert a new extent, then the old tree
+ * index/leaf need to be updated too
+ *
+ * If the nrblocks are discontigous, they could cause
+ * the whole tree split more than once, but this is really rare.
+ */
+static int ext4_ext_index_trans_blocks(struct inode *inode, int num, int chunk)
+{
+	int index;
+	int depth = ext_depth(inode);
 
-	/*
-	 * Index split can happen, we would need:
-	 *    allocate intermediate indexes (bitmap + group)
-	 *  + change two blocks at each level, but root (already included)
-	 */
-	needed += (depth * 2) + (depth * 2);
 
-	/* any allocation modifies superblock */
-	needed += 1;
+	if (chunk)
+		index = depth * 2;
+	else
+		index = depth * 3;
 
-	return needed;
+	return index;
 }
 
 static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
@@ -1921,9 +1917,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 			correct_index = 1;
 			credits += (ext_depth(inode)) + 1;
 		}
-#ifdef CONFIG_QUOTA
 		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
 
 		err = ext4_ext_journal_restart(handle, credits);
 		if (err)
@@ -2861,20 +2855,38 @@ out_stop:
 /*
  * ext4_ext_writepage_trans_blocks:
  * calculate max number of blocks we could modify
- * in order to allocate new block for an inode
+ * in order to allocate nrblocks of blocks.
+ *
+ * The chunk flag indicating whether the nrblocks are a single extent
+ * or discountigous on disk, that is used to determine how many index/leaf
+ * blocks needs credit for logging.
+ *
+ * Based on the index blocks and the nrblocks data blocks, we need to
+ * see how many bitmapblocks and block group descriptor groups need to accounted
+ * At last adds up the superblock, inode, quotao and xattr blocks. These
+ * all take care of in ext4_meta_trans_blocks()
  */
-int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
+int ext4_ext_writepage_trans_blocks(struct inode *inode, int num, int chunk)
 {
 	int needed;
+	int index_blocks;
 
-	needed = ext4_ext_calc_credits_for_insert(inode, NULL);
+	/*
+	 * How many index/leaf blocks need to modify/allocate to
+	 * insert a single extent with num blocks(chunk == 1)
+	 * or @num extents (chunk ==0)
+	 */
+	index_blocks = ext4_ext_index_trans_blocks(inode, num, chunk);
 
-	/* caller wants to allocate num blocks, but note it includes sb */
-	needed = needed * num - (num - 1);
+	/* How many metadat blocks need to modify to modify the @num
+ 	 * of data blocks and index_blocks? Include, index/leaf blocks,
+ 	 * bitmaps,block group descriptor block for modifying both data
+ 	 * and index/leaf blocks, superblock, inode, quota and xattrs
+ 	 */
+	needed = ext4_meta_trans_blocks(inode, num, index_blocks);
 
-#ifdef CONFIG_QUOTA
-	needed += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
+	if (ext4_should_journal_data(inode))
+		needed += num;
 
 	return needed;
 }
Index: linux-2.6.27-rc1/fs/ext4/migrate.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/migrate.c	2008-08-12 07:26:48.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/migrate.c	2008-08-12 07:46:29.000000000 -0700
@@ -53,7 +53,8 @@ static int finish_range(handle_t *handle
 	 * credit. But below we try to not accumalate too much
 	 * of them by restarting the journal.
 	 */
-	needed = ext4_ext_calc_credits_for_insert(inode, path);
+	needed = ext4_ext_calc_credits_for_single_extent(inode,
+		    lb->last_block - lb->first_block + 1, path);
 
 	/*
 	 * Make sure the credit we accumalated is not really high
Index: linux-2.6.27-rc1/fs/ext4/ext4.h
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/ext4.h	2008-08-12 07:26:48.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/ext4.h	2008-08-12 07:46:29.000000000 -0700
@@ -1227,7 +1227,7 @@ extern const struct inode_operations ext
 
 /* extents.c */
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
-extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
+extern int ext4_ext_writepage_trans_blocks(struct inode *, int num, int chunk);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
Index: linux-2.6.27-rc1/fs/ext4/inode.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/inode.c	2008-08-12 07:26:48.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/inode.c	2008-08-12 07:52:30.000000000 -0700
@@ -4449,7 +4449,7 @@ int ext4_writepage_trans_blocks(struct i
 
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
 		return ext4_writeblocks_trans_credits_old(inode, bpp, 0);
-	return ext4_ext_writepage_trans_blocks(inode, bpp);
+	return ext4_ext_writepage_trans_blocks(inode, bpp, 0);
 }
 /*
  * The caller must have previously called ext4_reserve_inode_write().


