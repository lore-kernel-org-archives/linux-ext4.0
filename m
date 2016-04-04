From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: [PATCH] ext4:Remove unneeded function definition and prototype for ext4_ext_calc_metadata_amount
Date: Sun,  3 Apr 2016 23:04:11 -0400
Message-ID: <1459739051-5000-1-git-send-email-bastienphilbert@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This removes the unneeded function definition and prototype for
ext4_ext_calc_metadata_amount in the files ext4.c and extents.c
as there are no more callers of this particular function and thus
it can now be removed without issues in order to remove unnessary
code from ext4 codebase.

Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 fs/ext4/ext4.h    |  2 --
 fs/ext4/extents.c | 47 -----------------------------------------------
 2 files changed, 49 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c047435..557cc35 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3180,8 +3180,6 @@ extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 					  loff_t offset, ssize_t len);
 extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
-extern int ext4_ext_calc_metadata_amount(struct inode *inode,
-					 ext4_lblk_t lblocks);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 95bf467..e06a09e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -304,53 +304,6 @@ ext4_force_split_extent_at(handle_t *handle, struct inode *inode,
 			(nofail ? EXT4_GET_BLOCKS_METADATA_NOFAIL:0));
 }
 
-/*
- * Calculate the number of metadata blocks needed
- * to allocate @blocks
- * Worse case is one block per extent
- */
-int ext4_ext_calc_metadata_amount(struct inode *inode, ext4_lblk_t lblock)
-{
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	int idxs;
-
-	idxs = ((inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
-		/ sizeof(struct ext4_extent_idx));
-
-	/*
-	 * If the new delayed allocation block is contiguous with the
-	 * previous da block, it can share index blocks with the
-	 * previous block, so we only need to allocate a new index
-	 * block every idxs leaf blocks.  At ldxs**2 blocks, we need
-	 * an additional index block, and at ldxs**3 blocks, yet
-	 * another index blocks.
-	 */
-	if (ei->i_da_metadata_calc_len &&
-	    ei->i_da_metadata_calc_last_lblock+1 == lblock) {
-		int num = 0;
-
-		if ((ei->i_da_metadata_calc_len % idxs) == 0)
-			num++;
-		if ((ei->i_da_metadata_calc_len % (idxs*idxs)) == 0)
-			num++;
-		if ((ei->i_da_metadata_calc_len % (idxs*idxs*idxs)) == 0) {
-			num++;
-			ei->i_da_metadata_calc_len = 0;
-		} else
-			ei->i_da_metadata_calc_len++;
-		ei->i_da_metadata_calc_last_lblock++;
-		return num;
-	}
-
-	/*
-	 * In the worst case we need a new set of index blocks at
-	 * every level of the inode's extent tree.
-	 */
-	ei->i_da_metadata_calc_len = 1;
-	ei->i_da_metadata_calc_last_lblock = lblock;
-	return ext_depth(inode) + 1;
-}
-
 static int
 ext4_ext_max_entries(struct inode *inode, int depth)
 {
-- 
2.5.0
