From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 ]Ext4 journal credits reservation fixes
Date: Fri, 15 Aug 2008 23:03:21 +0530
Message-ID: <20080815173321.GC6511@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33006 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYHORdf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 13:33:35 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FHX6gc011012
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:33:06 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FHXVfc1486866
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:33:31 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FHXUdi018220
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:33:31 +1000
Content-Disposition: inline
In-Reply-To: <1218558190.6766.37.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 09:23:10AM -0700, Mingming Cao wrote:
> This is a rework of journal credits fix patch in the ext4 patch queue.
> The patch series contains
> 
> - patch 1: helper funtions for journal credits calculation and fix the
> writepage/write_begin on nonextent files
> - patch 2: journal credit fix wirtepahe/write_begin for extents files,
> and migration
> - patch 3: credit fix for dio, fallocate
> -patch 4: rebase ext4_da_writepages_rework patch
> - patch 5: credit fix for delalloc writepages
> -patch 6: credit fix for defrag
> 
> 

I see this patch is pushed to the patch queue. Below is the review in
patch form.

commit 679a6fa1de0bc67c0a444b748696a2f2c22428c7
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Aug 15 22:13:07 2008 +0530

    cleanup

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 258cd1a..164c988 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1150,7 +1150,8 @@ extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
-extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int idxblocks);
+extern int ext4_meta_trans_blocks(struct inode *, int nrblocks,
+					int idxblocks, bool chunk);
 extern int ext4_data_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
@@ -1316,7 +1317,7 @@ extern const struct inode_operations ext4_fast_symlink_inode_operations;
 
 /* extents.c */
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
-extern int ext4_ext_writepage_trans_blocks(struct inode *, int num, int chunk);
+extern int ext4_ext_writeblock_trans_credits(struct inode *, int num, bool chunk);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2fbca0f..b38cc56 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1893,7 +1893,7 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
  * When pass the actual path, the caller should calculate credits
  * under i_data_sem.
  */
-int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
+int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
 						struct ext4_ext_path *path)
 {
 	int depth = ext_depth(inode);
@@ -1905,7 +1905,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
 			return 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
 	}
 
-	return ext4_ext_writepage_trans_blocks(inode, num, 1);
+	return ext4_ext_writeblock_trans_credits(inode, nrblocks, 1);
 }
 
 /*
@@ -1919,7 +1919,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int num,
  * If the nrblocks are discontigous, they could cause
  * the whole tree split more than once, but this is really rare.
  */
-static int ext4_ext_index_trans_blocks(struct inode *inode, int num, int chunk)
+static int ext4_ext_index_trans_blocks(struct inode *inode, int num, bool chunk)
 {
 	int index;
 	int depth = ext_depth(inode);
@@ -2993,7 +2993,7 @@ void ext4_ext_truncate(struct inode *inode)
 }
 
 /*
- * ext4_ext_writepage_trans_blocks:
+ * ext4_ext_writeblock_trans_credits:
  * calculate max number of blocks we could modify
  * in order to allocate nrblocks of blocks.
  *
@@ -3005,8 +3005,11 @@ void ext4_ext_truncate(struct inode *inode)
  * see how many bitmapblocks and block group descriptor groups need to accounted
  * At last adds up the superblock, inode, quotao and xattr blocks. These
  * all take care of in ext4_meta_trans_blocks()
+ *
+ * This doesn't account for the blocks needed for journaled
+ * data blocks.
  */
-int ext4_ext_writepage_trans_blocks(struct inode *inode, int num, int chunk)
+int ext4_ext_writeblock_trans_credits(struct inode *inode, int nrblocks, bool chunk)
 {
 	int needed;
 	int index_blocks;
@@ -3016,17 +3019,14 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num, int chunk)
 	 * insert a single extent with num blocks(chunk == 1)
 	 * or @num extents (chunk ==0)
 	 */
-	index_blocks = ext4_ext_index_trans_blocks(inode, num, chunk);
+	index_blocks = ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 
 	/* How many metadat blocks need to modify to modify the @num
 	 * of data blocks and index_blocks? Include, index/leaf blocks,
 	 * bitmaps,block group descriptor block for modifying both data
 	 * and index/leaf blocks, superblock, inode, quota and xattrs
 	 */
-	needed = ext4_meta_trans_blocks(inode, num, index_blocks);
-
-	if (ext4_should_journal_data(inode))
-		needed += num;
+	needed = ext4_meta_trans_blocks(inode, nrblocks, index_blocks, chunk);
 
 	return needed;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0b34998..a843cd3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1568,9 +1568,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 		 * but since this function is called from invalidate
 		 * page, it's harmless to return without any action
 		 */
-		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
-			    "blocks for inode %lu, but there is no reserved"
-			    "data blocks\n", inode->i_ino, to_free);
+		printk(KERN_INFO "ext4 delalloc try to release %d reserved "
+			    "blocks for inode %lu, but there is no reserved "
+			    "data blocks\n", to_free, inode->i_ino);
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return;
 	}
@@ -2303,13 +2303,13 @@ static int ext4_da_writepage(struct page *page,
  * get_block is calculated
  */
 
-#define		EXT4_MAX_WRITEPAGES_SIZE	PAGEVEC_SIZE
-static int ext4_writepages_trans_blocks(struct inode *inode)
+static int ext4_da_writepages_trans_blocks(struct inode *inode)
 {
-	int bpp = ext4_journal_blocks_per_page(inode);
-	int max_blocks = EXT4_MAX_WRITEPAGES_SIZE * bpp;
-
-	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
+	int max_blocks;
+	if (EXT4_I(inode)->i_reserved_data_blocks >
+				EXT4_BLOCKS_PER_GROUP(inode->i_sb))
+		max_blocks =  EXT4_BLOCKS_PER_GROUP(inode->i_sb);
+	else
 		max_blocks =  EXT4_I(inode)->i_reserved_data_blocks;
 
 	return ext4_data_trans_blocks(inode, max_blocks);
@@ -2364,7 +2364,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 		 * by delalloc
 		 */
 		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = ext4_writepages_trans_blocks(inode);
+		needed_blocks = ext4_da_writepages_trans_blocks(inode);
 
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
@@ -4459,13 +4459,19 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
  * over different block groups
  *
  * Also account for superblock, inode, quota and xattr blocks
+ * This doesn't account for the blocks needed for journaled
+ * data blocks.
  */
-int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int idxblocks)
+int ext4_meta_trans_blocks(struct inode* inode,
+				int nrblocks, int idxblocks, bool chunk)
 {
 	int groups, gdpblocks;
 	int ret = 0;
 
-	groups = nrblocks + idxblocks;
+	if (chunk)
+		groups = 1 + idxblocks;
+	else
+		groups = nrblocks + idxblocks;
 	gdpblocks = groups;
 	if (groups > EXT4_SB(inode->i_sb)->s_groups_count)
 		groups = EXT4_SB(inode->i_sb)->s_groups_count;
@@ -4473,14 +4479,10 @@ int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int idxblocks)
 		gdpblocks = EXT4_SB(inode->i_sb)->s_gdb_count;
 
 	/* bitmaps and block group descriptor blocks */
-	ret += groups + gdpblocks;
+	ret = groups + gdpblocks;
 
 	ret += idxblocks;
 
-	/* journalled mode, include buffer to modify data blocks */
-	if (ext4_should_journal_data(inode))
-		ret += nrblocks;
-
 	/* Blocks for super block, inode, quota and xattr blocks */
 	ret += EXT4_META_TRANS_BLOCKS(inode->i_sb);
 
@@ -4488,14 +4490,14 @@ int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int idxblocks)
 }
 
 static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
-				      int chunk)
+				      bool chunk)
 {
 	int indirects;
 
-	/* if nrblocks are contigous */
+	/* if nrblocks are contiguous */
 	if (chunk) {
 		/*
-		 * With N contigous data blocks, it need at most
+		 * With N contiguous data blocks, it need at most
 		 * N/EXT4_ADDR_PER_BLOCK(inode->i_sb) indirect blocks
 		 * 2 dindirect blocks
 		 * 1 tindirect block
@@ -4504,7 +4506,7 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 		return indirects + 3;
 	}
 	/*
-	 * if nrblocks are not contigous, worse case, each block touch
+	 * if nrblocks are not contiguous, worse case, each block touch
 	 * a indirect block, and each indirect block touch a double indirect
 	 * block, plus a triple indirect block
 	 */
@@ -4512,18 +4514,21 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 	return indirects;
 }
 /*
- * How many journal blocks are need to modify N blocks contigous data()?
+ * How many journal blocks are need to modify N blocks contiguous data()?
  *
  * It need to account indirect blocks, data blocks, and
  * bitmap blocks and group descriptor blocks.
  *
  * This still overestimates under most circumstances.  If we were to pass the
  * start and end offsets in here as well we could do block_to_path() on each
- * block and work out the exact number of indirects which are touched.  Pah.
+ * block and work out the exact number of indirects which are touched.
+ *
+ * This doesn't account for the blocks needed for journaled
+ * data blocks.
  */
 
 static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks,
-					      int chunk)
+					      bool chunk)
 {
 	int indirects;
 	int ret;
@@ -4531,7 +4536,7 @@ static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks,
 	/*
 	 * How many index blocks need to touch to modify nrblocks?
 	 * The "Chunk" flag indicating whether the nrblocks is
-	 * physically contigous on disk
+	 * physically contiguous on disk
 	 *
 	 * For Direct IO and fallocate, they calls get_block to allocate
 	 * one single extent at a time, so they could set the "Chunk" flag
@@ -4542,7 +4547,7 @@ static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks,
 	 * descriptors.Worse case, the nrblocks+indirects blocks spread
 	 * over different block groups
 	 */
-	ret = ext4_meta_trans_blocks(inode, nrblocks, indirects);
+	ret = ext4_meta_trans_blocks(inode, nrblocks, indirects, chunk);
 
 	return ret;
 }
@@ -4559,11 +4564,17 @@ static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks,
  */
 int ext4_writepage_trans_blocks(struct inode *inode)
 {
+	int ret;
 	int bpp = ext4_journal_blocks_per_page(inode);
 
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-		return ext4_writeblocks_trans_credits_old(inode, bpp, 0);
-	return ext4_ext_writepage_trans_blocks(inode, bpp, 0);
+		ret = ext4_writeblocks_trans_credits_old(inode, bpp, 0);
+	ret = ext4_ext_writeblock_trans_credits(inode, bpp, 0);
+
+	/* journalled mode, include buffer to modify data blocks */
+	if (ext4_should_journal_data(inode))
+		ret  += bpp;
+	return ret;
 }
 
 /*
@@ -4575,13 +4586,16 @@ int ext4_writepage_trans_blocks(struct inode *inode)
  * chunk of allocation needs.
  *
  * This is called from DIO, fallocate or whoever calling
- * ext4_get_blocks_wrap() to map/allocate a chunk of contigous disk blocks
+ * ext4_get_blocks_wrap() to map/allocate a chunk of contiguous disk blocks
+ *
+ * This doesn't account for the blocks needed for journaled
+ * data blocks.
  */
 int ext4_data_trans_blocks(struct inode *inode, int nrblocks)
 {
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
 		return ext4_writeblocks_trans_credits_old(inode, nrblocks, 1);
-	return ext4_ext_writepage_trans_blocks(inode, nrblocks, 1);
+	return ext4_ext_writeblock_trans_credits(inode, nrblocks, 1);
 }
 
 /*
