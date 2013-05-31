From: Jan Kara <jack@suse.cz>
Subject: [PATCH 14/26] ext4: Better estimate credits needed for ext4_da_writepages()
Date: Fri, 31 May 2013 11:42:47 +0200
Message-ID: <1369993379-13017-15-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3EaJnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:17 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We limit the number of blocks written in a single loop of
ext4_da_writepages() to 64 when inode uses indirect blocks. That is
unnecessary as credit estimates for mapping logically continguous run of
blocks is rather low even for inode with indirect blocks. So just lift
this limitation and properly calculate the number of necessary credits.

This better credit estimate will also later allow us to always write at
least a single page in one iteration.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  3 +--
 fs/ext4/extents.c | 16 +++++++-------
 fs/ext4/inode.c   | 63 +++++++++++++++++++++++++------------------------------
 3 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bca9889..4ed13c4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2598,8 +2598,7 @@ struct ext4_extent;
 
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
-extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
-				       int chunk);
+extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
 extern void ext4_ext_truncate(handle_t *, struct inode *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc0f191..e455141 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2328,17 +2328,15 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
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
@@ -2349,7 +2347,7 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 
 	depth = ext_depth(inode);
 
-	if (chunk)
+	if (extents <= 1)
 		index = depth * 2;
 	else
 		index = depth * 3;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 27b8504..db33a00 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -138,6 +138,9 @@ static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
 static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		struct inode *inode, struct page *page, loff_t from,
 		loff_t length, int flags);
+static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
+				  int pextents);
+
 
 /*
  * Test whether an inode is a fast symlink.
@@ -2198,28 +2201,25 @@ static int ext4_writepage(struct page *page,
 }
 
 /*
- * This is called via ext4_da_writepages() to
- * calculate the total number of credits to reserve to fit
- * a single extent allocation into a single transaction,
- * ext4_da_writpeages() will loop calling this before
- * the block allocation.
+ * mballoc gives us at most this number of blocks...
+ * XXX: That seems to be only a limitation of ext4_mb_normalize_request().
+ * The rest of mballoc seems to handle chunks upto full group size.
  */
+#define MAX_WRITEPAGES_EXTENT_LEN 2048
 
+/*
+ * Calculate the total number of credits to reserve for one writepages
+ * iteration. This is called from ext4_da_writepages(). We map an extent of
+ * upto MAX_WRITEPAGES_EXTENT_LEN blocks and then we go on and finish mapping
+ * the last partial page. So in total we can map MAX_WRITEPAGES_EXTENT_LEN +
+ * bpp - 1 blocks in bpp different extents.
+ */
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
@@ -4753,11 +4753,12 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
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
@@ -4771,7 +4772,8 @@ static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
  *
  * Also account for superblock, inode, quota and xattr blocks
  */
-static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
+				  int pextents)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
@@ -4779,14 +4781,10 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
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
 
@@ -4794,12 +4792,7 @@ static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 	 * Now let's see how many group bitmaps and group descriptors need
 	 * to account
 	 */
-	groups = idxblocks;
-	if (chunk)
-		groups += 1;
-	else
-		groups += nrblocks;
