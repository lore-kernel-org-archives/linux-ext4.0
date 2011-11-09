From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 4/9] ext4: remove unused functions and tags
Date: Wed,  9 Nov 2011 19:17:03 +0800
Message-ID: <1320837428-8516-5-git-send-email-hao.bigrat@gmail.com>
References: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46160 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1KILRd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:33 -0500
Received: by mail-gx0-f174.google.com with SMTP id b2so1603917ggn.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:33 -0800 (PST)
In-Reply-To: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |  109 -----------------------------------------------------
 1 files changed, 0 insertions(+), 109 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4f764ee..ccf12a0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3662,111 +3662,6 @@ out2:
 }
 
 /*
- * get_implied_cluster_alloc - check to see if the requested
- * allocation (in the map structure) overlaps with a cluster already
- * allocated in an extent.
- *	@sb	The filesystem superblock structure
- *	@map	The requested lblk->pblk mapping
- *	@ex	The extent structure which might contain an implied
- *			cluster allocation
- *
- * This function is called by ext4_ext_map_blocks() after we failed to
- * find blocks that were already in the inode's extent tree.  Hence,
- * we know that the beginning of the requested region cannot overlap
- * the extent from the inode's extent tree.  There are three cases we
- * want to catch.  The first is this case:
- *
- *		 |--- cluster # N--|
- *    |--- extent ---|	|---- requested region ---|
- *			|==========|
- *
- * The second case that we need to test for is this one:
- *
- *   |--------- cluster # N ----------------|
- *	   |--- requested region --|   |------- extent ----|
- *	   |=======================|
- *
- * The third case is when the requested region lies between two extents
- * within the same cluster:
- *          |------------- cluster # N-------------|
- * |----- ex -----|                  |---- ex_right ----|
- *                  |------ requested region ------|
- *                  |================|
- *
- * In each of the above cases, we need to set the map->m_pblk and
- * map->m_len so it corresponds to the return the extent labelled as
- * "|====|" from cluster #N, since it is already in use for data in
- * cluster EXT4_B2C(sbi, map->m_lblk).	We will then return 1 to
- * signal to ext4_ext_map_blocks() that map->m_pblk should be treated
- * as a new "allocated" block region.  Otherwise, we will return 0 and
- * ext4_ext_map_blocks() will then allocate one or more new clusters
- * by calling ext4_mb_new_blocks().
- */
-static int get_implied_cluster_alloc(struct super_block *sb,
-				     struct ext4_map_blocks *map,
-				     struct ext4_extent *ex,
-				     struct ext4_ext_path *path)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_lblk_t c_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
-	ext4_lblk_t ex_cluster_start, ex_cluster_end;
-	ext4_lblk_t rr_cluster_start, rr_cluster_end;
-	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
-	ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
-	unsigned int ee_len = ext4_ext_get_actual_blocks(ex, sb);
-
-	/* The extent passed in that we are trying to match */
-	ex_cluster_start = EXT4_B2C(sbi, ee_block);
-	ex_cluster_end = EXT4_B2C(sbi, ee_block + ee_len - 1);
-
-	/* The requested region passed into ext4_map_blocks() */
-	rr_cluster_start = EXT4_B2C(sbi, map->m_lblk);
-	rr_cluster_end = EXT4_B2C(sbi, map->m_lblk + map->m_len - 1);
-
-	if ((rr_cluster_start == ex_cluster_end) ||
-	    (rr_cluster_start == ex_cluster_start)) {
-		if (rr_cluster_start == ex_cluster_end)
-			ee_start += ee_len - 1;
-		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
-			c_offset;
-		map->m_len = min(map->m_len,
-				 (unsigned) sbi->s_cluster_ratio - c_offset);
-		/*
-		 * Check for and handle this case:
-		 *
-		 *   |--------- cluster # N-------------|
-		 *		       |------- extent ----|
-		 *	   |--- requested region ---|
-		 *	   |===========|
-		 */
-
-		if (map->m_lblk < ee_block)
-			map->m_len = min(map->m_len, ee_block - map->m_lblk);
-
-		/*
-		 * Check for the case where there is already another allocated
-		 * block to the right of 'ex' but before the end of the cluster.
-		 *
-		 *          |------------- cluster # N-------------|
-		 * |----- ex -----|                  |---- ex_right ----|
-		 *                  |------ requested region ------|
-		 *                  |================|
-		 */
-		if (map->m_lblk > ee_block) {
-			ext4_lblk_t next = 0;//ext4_ext_next_allocated_block(path);
-			map->m_len = min(map->m_len, next - map->m_lblk);
-		}
-
-		trace_ext4_get_implied_cluster_alloc_exit(sb, map, 1);
-		return 1;
-	}
-
-	trace_ext4_get_implied_cluster_alloc_exit(sb, map, 0);
-	return 0;
-}
-
-
-/*
  * Block allocation/map/preallocation routine for extents based files
  *
  *
@@ -3798,7 +3693,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	unsigned int result = 0;
 	struct ext4_allocation_request ar;
 	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
-	ext4_lblk_t cluster_offset;
 	struct ext4_map_blocks punch_map;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
@@ -4010,7 +3904,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = EXT4_B2C(sbi,
 			cpu_to_le32(map->m_lblk & ~(sbi->s_cluster_ratio-1)));
-	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
 
 	if (ex)
 		BUG_ON((EXT4_C2B(sbi, le32_to_cpu(ex->ee_block)) +
@@ -4072,7 +3965,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		ar.flags = 0;
 	if (flags & EXT4_GET_BLOCKS_NO_NORMALIZE)
 		ar.flags |= EXT4_MB_HINT_NOPREALLOC;
-	printk(KERN_ERR "ar: %lu, %lu, %lu\n", ar.len, ar.goal, ar.logical);
 	newblock = ext4_mb_new_blocks(handle, &ar, &err);
 	if (!newblock)
 		goto out2;
@@ -4081,7 +3973,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	free_on_err = 1;
 	allocated_clusters = ar.len;
 
-got_allocated_blocks:
 	/* try to insert new extent into found leaf and return */
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated_clusters);
-- 
1.7.3.2

