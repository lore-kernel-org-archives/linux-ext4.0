From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/29] ext4: Better estimate credits needed for ext4_da_writepages()
Date: Mon,  8 Apr 2013 23:32:22 +0200
Message-ID: <1365456754-29373-18-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936335Ab3DHVdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:06 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We limit the number of blocks written in a single loop of
ext4_da_writepages() to 64 when inode uses indirect blocks. That is
unnecessary as credit estimates for mapping logically continguous run of
blocks is rather low even for inode with indirect blocks. So just lift
this limitation and properly calculate the number of necessary credits.

This better credit estimate will also later allow us to always write at
least a single page in one iteration.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |    3 +-
 fs/ext4/extents.c |   16 ++++++--------
 fs/ext4/inode.c   |   58 ++++++++++++++++++++--------------------------------
 3 files changed, 30 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d3a54f2..a6f7331 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2555,8 +2555,7 @@ struct ext4_extent;
 
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
-extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
-				       int chunk);
+extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
 extern void ext4_ext_truncate(struct inode *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9dba80b..8064b71 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2269,17 +2269,15 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
 }
 
 /*
- * How many index/leaf blocks need to change/allocate to modify nrblocks?
+ * How many index/leaf blocks need to change/allocate to add @extents extents?
  *
- * if nrblocks are fit in a single extent (chunk flag is 1), then
- * in the worse case, each tree level index/leaf need to be changed
- * if the tree split due to insert a new extent, then the old tree
- * index/leaf need to be updated too
+ * If we add a single extent, then in the worse case, each tree level
+ * index/leaf need to be changed in case of the tree split.
  *
- * If the nrblocks are discontiguous, they could cause
- * the whole tree split more than once, but this is really rare.
+ * If more extents are inserted, they could cause the whole tree split more
+ * than once, but this is really rare.
  */
-int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
 {
 	int index;
 	int depth;
@@ -2290,7 +2288,7 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 
 	depth = ext_depth(inode);
 
-	if (chunk)
+	if (extents <= 1)
 		index = depth * 2;
 	else
 		index = depth * 3;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index aa26f4c..9cb4e75 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -137,6 +137,9 @@ static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
 static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		struct inode *inode, struct page *page, loff_t from,
 		loff_t length, int flags);
+static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
+				  int pextents);
+
 
 /*
  * Test whether an inode is a fast symlink.
@@ -2075,28 +2078,18 @@ static int ext4_writepage(struct page *page,
 }
 
 /*
- * This is called via ext4_da_writepages() to
- * calculate the total number of credits to reserve to fit
- * a single extent allocation into a single transaction,
- * ext4_da_writpeages() will loop calling this before
- * the block allocation.
+ * Calculate the total number of credits to reserve for one writepages
+ * iteration. This is called from ext4_da_writepages(). We map an extent of
+ * upto MAX_WRITEPAGES_EXTENT_LEN blocks and then we go on and finish mapping
+ * the last partial page. So in total we can map MAX_WRITEPAGES_EXTENT_LEN +
+ * bpp - 1 blocks in bpp different extents.
  */
-
 static int ext4_da_writepages_trans_blocks(struct inode *inode)
 {
-	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-
-	/*
-	 * With non-extent format the journal credit needed to
-	 * insert nrblocks contiguous block is dependent on
-	 * number of contiguous block. So we will limit
-	 * number of contiguous block to a sane value
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
-	    (max_blocks > EXT4_MAX_TRANS_DATA))
-		max_blocks = EXT4_MAX_TRANS_DATA;
+	int bpp = ext4_journal_blocks_per_page(inode);
 
-	return ext4_chunk_trans_blocks(inode, max_blocks);
+	return ext4_meta_trans_blocks(inode,
+				MAX_WRITEPAGES_EXTENT_LEN + bpp - 1, bpp);
 }
 
 /*
@@ -4396,11 +4389,12 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return 0;
 }
 
-static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
+				   int pextents)
 {
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return ext4_ind_trans_blocks(inode, nrblocks);
-	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
+		return ext4_ind_trans_blocks(inode, lblocks);
+	return ext4_ext_index_trans_blocks(inode, pextents);
 }
 
 /*
@@ -4414,7 +4408,8 @@ static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
  *
  * Also account for superblock, inode, quota and xattr blocks
  */
-static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
+				  int pextents)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
@@ -4422,14 +4417,10 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 	int ret = 0;
 
 	/*
-	 * How many index blocks need to touch to modify nrblocks?
-	 * The "Chunk" flag indicating whether the nrblocks is
-	 * physically contiguous on disk
-	 *
-	 * For Direct IO and fallocate, they calls get_block to allocate
-	 * one single extent at a time, so they could set the "Chunk" flag
+	 * How many index blocks need to touch to map @lblocks logical blocks
+	 * to @pextents physical extents?
 	 */
-	idxblocks = ext4_index_trans_blocks(inode, nrblocks, chunk);
+	idxblocks = ext4_index_trans_blocks(inode, lblocks, pextents);
 
 	ret = idxblocks;
 
@@ -4437,12 +4428,7 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 	 * Now let's see how many group bitmaps and group descriptors need
 	 * to account
 	 */
-	groups = idxblocks;
-	if (chunk)
-		groups += 1;
-	else
-		groups += nrblocks;
