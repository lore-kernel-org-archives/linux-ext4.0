From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 2/6  V2]Ext4: journal credits reservation fixes for extent
	file writepage
Date: Fri, 15 Aug 2008 17:38:33 -0700
Message-ID: <1218847113.8183.45.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
	 <1218558473.6766.44.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57048 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYHPAii (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 20:38:38 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7G0caph013398
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 20:38:36 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7G0caJK181724
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 18:38:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7G0cZC8004672
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 18:38:35 -0600
In-Reply-To: <1218558473.6766.44.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ext4: journal credits reservation fixes for extent file writepage

From: Mingming Cao <cmm@us.ibm.com>

This patch modified the writepage/write_begin credit caculation for
extent files, to use the credits caculation helper function. 

The current calculation of how many index/leaf blocks should be
accounted is too conservetive, it always consider the worse case, where
the tree level is 5, and in the case of multiple chunk allocation, it
always multiple the needed credits. This path uses the accurate depth of
the inode with some extras to caluate the index blocks, and also less
conservetive in the case of multiple allocation accounting.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
---
 fs/ext4/ext4_extents.h |    3 +
 fs/ext4/extents.c      |   88 ++++++++++++++++---------------------------------
 fs/ext4/migrate.c      |    3 +
 3 files changed, 34 insertions(+), 60 deletions(-)

Index: linux-2.6.27-rc3/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext4/ext4_extents.h	2008-08-15 14:43:20.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext4/ext4_extents.h	2008-08-15 14:44:15.000000000 -0700
@@ -216,7 +216,9 @@ extern int ext4_ext_calc_metadata_amount
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
-extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
+						   int num,
+						   struct ext4_ext_path *path);
 extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
Index: linux-2.6.27-rc3/fs/ext4/extents.c
===================================================================
--- linux-2.6.27-rc3.orig/fs/ext4/extents.c	2008-08-15 14:43:20.000000000 -0700
+++ linux-2.6.27-rc3/fs/ext4/extents.c	2008-08-15 14:51:07.000000000 -0700
@@ -1747,54 +1747,62 @@ static int ext4_ext_rm_idx(handle_t *han
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
-
 	if (path) {
+		int depth = ext_depth(inode);
+		int ret;
+
 		/* probably there is space in leaf? */
-		depth = ext_depth(inode);
 		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
-				< le16_to_cpu(path[depth].p_hdr->eh_max))
-			return 1;
-	}
-
-	/*
-	 * given 32-bit logical block (4294967296 blocks), max. tree
-	 * can be 4 levels in depth -- 4 * 340^4 == 53453440000.
-	 * Let's also add one more level for imbalance.
-	 */
-	depth = 5;
+				< le16_to_cpu(path[depth].p_hdr->eh_max)) {
 
-	/* allocation of new data block(s) */
-	needed = 2;
+			/*
+			 *  There are some space in the leaf tree, no
+			 *  need to account for leaf block credit
+			 *
+			 *  bitmaps and block group descriptor blocks
+			 *  and other metadat blocks still need to be
+			 *  accounted.
+			ret = (num + EXT4_BLOCKS_PER_GROUP(inode->i_sb) -1)
+                             /EXT4_BLOCKS_PER_GROUP(inode->i_sb);
+			/* 1 one bitmap, 1 block group descriptor */
+			ret = ret*2  + EXT4_META_TRANS_BLOCKS(inode->i_sb);
+		}
+	}
 
-	/*
-	 * tree can be full, so it would need to grow in depth:
-	 * we need one credit to modify old root, credits for
-	 * new root will be added in split accounting
-	 */
-	needed += 1;
+	return ext4_meta_trans_blocks(inode, num, 1);
+}
 
-	/*
-	 * Index split can happen, we would need:
-	 *    allocate intermediate indexes (bitmap + group)
-	 *  + change two blocks at each level, but root (already included)
-	 */
-	needed += (depth * 2) + (depth * 2);
+/*
+ * How many index/leaf blocks need to change/allocate to modify nrblocks?
+ *
+ * if nrblocks are fit in a single extent (chunk flag is 1), then
+ * in the worse case, each tree level index/leaf need to be changed
+ * if the tree split due to insert a new extent, then the old tree
+ * index/leaf need to be updated too
+ *
+ * If the nrblocks are discontiguous, they could cause
+ * the whole tree split more than once, but this is really rare.
+ */
+int ext4_ext_index_trans_blocks(struct inode *inode, int num, int chunk)
+{
+	int index;
+	int depth = ext_depth(inode);
 
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
@@ -1921,9 +1929,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 			correct_index = 1;
 			credits += (ext_depth(inode)) + 1;
 		}
-#ifdef CONFIG_QUOTA
 		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
 
 		err = ext4_ext_journal_restart(handle, credits);
 		if (err)
@@ -2858,27 +2864,6 @@ out_stop:
 	ext4_journal_stop(handle);
 }
 
-/*
- * ext4_ext_writepage_trans_blocks:
- * calculate max number of blocks we could modify
- * in order to allocate new block for an inode
- */
-int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
-{
-	int needed;
-
-	needed = ext4_ext_calc_credits_for_insert(inode, NULL);
-
-	/* caller wants to allocate num blocks, but note it includes sb */
-	needed = needed * num - (num - 1);
-
-#ifdef CONFIG_QUOTA
-	needed += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
-
-	return needed;
-}
