From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/8 bigalloc] ext4: change ext4_ext_map_blocks to allocate clusters instead of blocks
Date: Tue,  1 Nov 2011 18:53:31 +0800
Message-ID: <1320144817-16397-3-git-send-email-hao.bigrat@gmail.com>
References: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48574 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1KAKxu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 06:53:50 -0400
Received: by gyb13 with SMTP id 13so6896267gyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Nov 2011 03:53:50 -0700 (PDT)
In-Reply-To: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

We need to align to a cluster when users allocate just one block.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |   47 +++++++++++++----------------------------------
 1 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 50f208e..c96f64f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3962,20 +3962,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * Okay, we need to do block allocation.
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
-	newex.ee_block = cpu_to_le32(map->m_lblk);
+	newex.ee_block = cpu_to_le32(map->m_lblk & ~(sbi->s_cluster_ratio-1));
 	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
 
-	/*
-	 * If we are doing bigalloc, check to see if the extent returned
-	 * by ext4_ext_find_extent() implies a cluster we can use.
-	 */
-	if (cluster_offset && ex &&
-	    get_implied_cluster_alloc(inode->i_sb, map, ex, path)) {
-		ar.len = allocated = map->m_len;
-		newblock = map->m_pblk;
-		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
-		goto got_allocated_blocks;
-	}
+	if (ex)
+		BUG_ON((le32_to_cpu(ex->ee_block) +
+			EXT4_C2B(sbi, ex->ee_len)) >
+			(map->m_lblk & ~(sbi->s_cluster_ratio-1)));
 
 	/* find neighbour allocated blocks */
 	ar.lleft = map->m_lblk;
@@ -3988,16 +3981,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto out2;
 
-	/* Check if the extent after searching to the right implies a
-	 * cluster we can use. */
-	if ((sbi->s_cluster_ratio > 1) && ex2 &&
-	    get_implied_cluster_alloc(inode->i_sb, map, ex2, path)) {
-		ar.len = allocated = map->m_len;
-		newblock = map->m_pblk;
-		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
-		goto got_allocated_blocks;
-	}
-
 	/*
 	 * See if request is beyond maximum number of blocks we can have in
 	 * a single extent. For an initialized extent this limit is
@@ -4012,10 +3995,10 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		map->m_len = EXT_UNINIT_MAX_LEN;
 
 	/* Check if we can really insert (m_lblk)::(m_lblk + m_len) extent */
-	newex.ee_len = cpu_to_le16(map->m_len);
+	newex.ee_len = cpu_to_le16(EXT4_NUM_B2C(sbi, map->m_len));
 	err = ext4_ext_check_overlap(sbi, inode, &newex, path);
 	if (err)
-		allocated = EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex));
+		allocated = ext4_ext_get_actual_len(&newex);
 	else
 		allocated = map->m_len;
 
@@ -4049,14 +4032,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		  ar.goal, newblock, allocated);
 	free_on_err = 1;
 	allocated_clusters = ar.len;
-	ar.len = EXT4_C2B(sbi, ar.len) - offset;
-	if (ar.len > allocated)
-		ar.len = allocated;
 
 got_allocated_blocks:
 	/* try to insert new extent into found leaf and return */
-	ext4_ext_store_pblock(&newex, newblock + offset);
-	newex.ee_len = cpu_to_le16(ar.len);
+	ext4_ext_store_pblock(&newex, newblock);
+	newex.ee_len = cpu_to_le16(allocated_clusters);
 	/* Mark uninitialized */
 	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
 		ext4_ext_mark_uninitialized(&newex);
@@ -4079,7 +4059,8 @@ got_allocated_blocks:
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
 
-	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
+	err = check_eofblocks_fl(handle, inode, map->m_lblk, path,
+			EXT4_C2B(sbi, allocated_clusters));
 	if (!err)
 		err = ext4_ext_insert_extent(handle, inode, path,
 					     &newex, flags);
@@ -4099,8 +4080,6 @@ got_allocated_blocks:
 	/* previous routine could use block we allocated */
 	newblock = ext4_ext_pblock(&newex);
 	allocated = EXT4_C2B(sbi, ext4_ext_get_actual_len(&newex));
-	if (allocated > map->m_len)
-		allocated = map->m_len;
 	map->m_flags |= EXT4_MAP_NEW;
 
 	/*
@@ -4187,7 +4166,7 @@ got_allocated_blocks:
 	 * when it is _not_ an uninitialized extent.
 	 */
 	if ((flags & EXT4_GET_BLOCKS_UNINIT_EXT) == 0) {
-		ext4_ext_put_in_cache(inode, map->m_lblk, allocated, newblock);
+		ext4_ext_put_in_cache(inode, ar.logical, allocated, newblock);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 	} else
 		ext4_update_inode_fsync_trans(handle, inode, 0);
@@ -4196,7 +4175,7 @@ out:
 		allocated = map->m_len;
 	ext4_ext_show_leaf(inode, path);
 	map->m_flags |= EXT4_MAP_MAPPED;
-	map->m_pblk = newblock;
+	map->m_pblk = newblock + offset;
 	map->m_len = allocated;
 out2:
 	if (path) {
-- 
1.7.3.2

