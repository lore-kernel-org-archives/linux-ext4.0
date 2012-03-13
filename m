From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/3] ext4: modify the implementation of quota reservation in bigalloc-delay-allocation
Date: Tue, 13 Mar 2012 19:38:17 +0800
Message-ID: <1331638698-14796-2-git-send-email-hao.bigrat@gmail.com>
References: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2CMLic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 07:38:32 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so671109iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2012 04:38:32 -0700 (PDT)
In-Reply-To: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change the argument of i_{reserved_data,reserved_meta,allocated_meta}_blocks to i_*_clusters

In the old logic When we try writing to a block which does not have a mapping, and bigalloc is enabled:
	a) one block have been mapped, a whole cluster will be reserved.
	b) While the block has not been mapped (and so the data on disk is uninitialized)
		the cluster has indeed been allocated,
		so we don't need to reserve any additional room for the block.

Imaging s_cluster_ratio is 4 and the clusters is: (follow the comment in fs/ext4/extent.c:4100)

	[0-3], [4-7], [8-11]

The new quota-reservation logic have changed to this now:

	1. delay-allocation write blocks 10&11
		we reserve 1 cluster, the i_reserved_data_blocks is 1 now
	2. delay-allocation write blocks 3 to 8
		we reserve other 2 clusters, so 3 clusters totally, the
		i_reserved_data_blocks is 3 now
	3. writeout the blocks 3 to 8
		claim all 3 clusters, i_reserved_data_blocks is 0 now
		At this moment, we really have allocated 3 clusters, and the
		remain 10&11 block would never occupy another cluster (it would
		definitely go into the [8-11] cluster), so, we don't need to reserve one
		more cluster quota (which is the old logic).
	4.  writeout the 10&11 blocks
		the 10&11 blocks will be set EXT4_MAP_FROM_CLUSTER flag ( by
		get_implied_cluster_alloc as the 8~9 block have been allocated), and
		it will not call ext4_da_update_reserve_space any more

As this, no warning, no reserve-and-release ping pong.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/balloc.c            |    2 +-
 fs/ext4/ext4.h              |    6 +-
 fs/ext4/extents.c           |   97 +++++++++++--------------------------------
 fs/ext4/file.c              |    2 +-
 fs/ext4/inode.c             |   66 +++++++++++++++--------------
 fs/ext4/super.c             |    7 ++-
 include/trace/events/ext4.h |   42 +++++++++---------
 7 files changed, 89 insertions(+), 133 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2c518f8..1a67771 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -518,7 +518,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	if (!(*errp) &&
 	    ext4_test_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED)) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
+		EXT4_I(inode)->i_allocated_meta_clusters += ar.len;
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		dquot_alloc_block_nofail(inode,
 				EXT4_C2B(EXT4_SB(inode->i_sb), ar.len));
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..d23b521 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -869,9 +869,9 @@ struct ext4_inode_info {
 
 	/* allocation reservation info for delalloc */
 	/* In case of bigalloc, these refer to clusters rather than blocks */
-	unsigned int i_reserved_data_blocks;
-	unsigned int i_reserved_meta_blocks;
-	unsigned int i_allocated_meta_blocks;
+	unsigned int i_reserved_data_clusters;
+	unsigned int i_reserved_meta_clusters;
+	unsigned int i_allocated_meta_clusters;
 	ext4_lblk_t i_da_metadata_calc_last_lblock;
 	int i_da_metadata_calc_len;
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..5200fcc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3705,6 +3705,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent newex, *ex, *ex2;
+	struct ext4_map_blocks tmp_map;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
 	int free_on_err = 0, err = 0, depth, ret;
@@ -3901,9 +3902,31 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	if ((sbi->s_cluster_ratio > 1) &&
-	    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
+	    ext4_find_delalloc_cluster(inode, map->m_lblk, 0)) {
 		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
+		goto got_pre_alloc_blocks;
+	}
+
+	cluster_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
+	tmp_map = *map;
+	if (cluster_offset && ex &&
+	    get_implied_cluster_alloc(inode->i_sb, &tmp_map, ex, path)) {
+		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
+		goto got_pre_alloc_blocks;
+	}
+
+	ar.lright = map->m_lblk;
+	ex2 = NULL;
+	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright, &ex2);
+	if (err)
+		goto out2;
 
+	tmp_map = *map;
+	if ((sbi->s_cluster_ratio > 1) && ex2 &&
+	    get_implied_cluster_alloc(inode->i_sb, &tmp_map, ex2, path))
+		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
+
+got_pre_alloc_blocks:
 	/*
 	 * requested block isn't allocated yet;
 	 * we couldn't try to create block if create flag is zero
@@ -4068,80 +4091,10 @@ got_allocated_blocks:
 	 * block allocation which had been deferred till now.
 	 */
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) {
-		unsigned int reserved_clusters;
-		/*
-		 * Check how many clusters we had reserved this allocated range
-		 */
-		reserved_clusters = get_reserved_cluster_alloc(inode,
-						map->m_lblk, allocated);
-		if (map->m_flags & EXT4_MAP_FROM_CLUSTER) {
-			if (reserved_clusters) {
-				/*
-				 * We have clusters reserved for this range.
-				 * But since we are not doing actual allocation
-				 * and are simply using blocks from previously
-				 * allocated cluster, we should release the
-				 * reservation and not claim quota.
-				 */
-				ext4_da_update_reserve_space(inode,
-						reserved_clusters, 0);
-			}
-		} else {
-			BUG_ON(allocated_clusters < reserved_clusters);
+		if (!(map->m_flags & EXT4_MAP_FROM_CLUSTER))
 			/* We will claim quota for all newly allocated blocks.*/
 			ext4_da_update_reserve_space(inode, allocated_clusters,
 							1);
-			if (reserved_clusters < allocated_clusters) {
-				struct ext4_inode_info *ei = EXT4_I(inode);
-				int reservation = allocated_clusters -
-						  reserved_clusters;
-				/*
-				 * It seems we claimed few clusters outside of
-				 * the range of this allocation. We should give
-				 * it back to the reservation pool. This can
-				 * happen in the following case:
-				 *
-				 * * Suppose s_cluster_ratio is 4 (i.e., each
-				 *   cluster has 4 blocks. Thus, the clusters
-				 *   are [0-3],[4-7],[8-11]...
-				 * * First comes delayed allocation write for
-				 *   logical blocks 10 & 11. Since there were no
-				 *   previous delayed allocated blocks in the
-				 *   range [8-11], we would reserve 1 cluster
-				 *   for this write.
-				 * * Next comes write for logical blocks 3 to 8.
-				 *   In this case, we will reserve 2 clusters
-				 *   (for [0-3] and [4-7]; and not for [8-11] as
-				 *   that range has a delayed allocated blocks.
-				 *   Thus total reserved clusters now becomes 3.
-				 * * Now, during the delayed allocation writeout
-				 *   time, we will first write blocks [3-8] and
-				 *   allocate 3 clusters for writing these
-				 *   blocks. Also, we would claim all these
-				 *   three clusters above.
-				 * * Now when we come here to writeout the
-				 *   blocks [10-11], we would expect to claim
-				 *   the reservation of 1 cluster we had made
-				 *   (and we would claim it since there are no
-				 *   more delayed allocated blocks in the range
-				 *   [8-11]. But our reserved cluster count had
-				 *   already gone to 0.
-				 *
-				 *   Thus, at the step 4 above when we determine
-				 *   that there are still some unwritten delayed
-				 *   allocated blocks outside of our current
-				 *   block range, we should increment the
-				 *   reserved clusters count so that when the
-				 *   remaining blocks finally gets written, we
-				 *   could claim them.
-				 */
-				dquot_reserve_block(inode,
-						EXT4_C2B(sbi, reservation));
-				spin_lock(&ei->i_block_reservation_lock);
-				ei->i_reserved_data_blocks += reservation;
-				spin_unlock(&ei->i_block_reservation_lock);
-			}
-		}
 	}
 
 	/*
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..df0c6bd 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -43,7 +43,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1) &&
-		        !EXT4_I(inode)->i_reserved_data_blocks)
+		        !EXT4_I(inode)->i_reserved_data_clusters)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..7e27581 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -270,31 +270,31 @@ void ext4_da_update_reserve_space(struct inode *inode,
 
 	spin_lock(&ei->i_block_reservation_lock);
 	trace_ext4_da_update_reserve_space(inode, used, quota_claim);
-	if (unlikely(used > ei->i_reserved_data_blocks)) {
+	if (unlikely(used > ei->i_reserved_data_clusters)) {
 		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, used %d "
-			 "with only %d reserved data blocks\n",
+			 "with only %d reserved data clusters\n",
 			 __func__, inode->i_ino, used,
-			 ei->i_reserved_data_blocks);
+			 ei->i_reserved_data_clusters);
 		WARN_ON(1);
-		used = ei->i_reserved_data_blocks;
+		used = ei->i_reserved_data_clusters;
 	}
 
 	/* Update per-inode reservations */
-	ei->i_reserved_data_blocks -= used;
-	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
+	ei->i_reserved_data_clusters -= used;
+	ei->i_reserved_meta_clusters -= ei->i_allocated_meta_clusters;
 	percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-			   used + ei->i_allocated_meta_blocks);
-	ei->i_allocated_meta_blocks = 0;
+			   used + ei->i_allocated_meta_clusters);
+	ei->i_allocated_meta_clusters = 0;
 
-	if (ei->i_reserved_data_blocks == 0) {
+	if (ei->i_reserved_data_clusters == 0) {
 		/*
 		 * We can release all of the reserved metadata blocks
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 */
 		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-				   ei->i_reserved_meta_blocks);
-		ei->i_reserved_meta_blocks = 0;
+				   ei->i_reserved_meta_clusters);
+		ei->i_reserved_meta_clusters = 0;
 		ei->i_da_metadata_calc_len = 0;
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
@@ -316,7 +316,7 @@ void ext4_da_update_reserve_space(struct inode *inode,
 	 * there aren't any writers on the inode, we can discard the
 	 * inode's preallocations.
 	 */
-	if ((ei->i_reserved_data_blocks == 0) &&
+	if ((ei->i_reserved_data_clusters == 0) &&
 	    (atomic_read(&inode->i_writecount) == 0))
 		ext4_discard_preallocations(inode);
 }
@@ -1138,8 +1138,8 @@ repeat:
 		return -ENOSPC;
 	}
 	spin_lock(&ei->i_block_reservation_lock);
-	ei->i_reserved_data_blocks++;
-	ei->i_reserved_meta_blocks += md_needed;
+	ei->i_reserved_data_clusters++;
+	ei->i_reserved_meta_clusters += md_needed;
 	spin_unlock(&ei->i_block_reservation_lock);
 
 	return 0;       /* success */
@@ -1156,33 +1156,33 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	trace_ext4_da_release_space(inode, to_free);
-	if (unlikely(to_free > ei->i_reserved_data_blocks)) {
+	if (unlikely(to_free > ei->i_reserved_data_clusters)) {
 		/*
-		 * if there aren't enough reserved blocks, then the
+		 * if there aren't enough reserved clusters, then the
 		 * counter is messed up somewhere.  Since this
 		 * function is called from invalidate page, it's
 		 * harmless to return without any action.
 		 */
 		ext4_msg(inode->i_sb, KERN_NOTICE, "ext4_da_release_space: "
 			 "ino %lu, to_free %d with only %d reserved "
-			 "data blocks\n", inode->i_ino, to_free,
-			 ei->i_reserved_data_blocks);
+			 "data clusters\n", inode->i_ino, to_free,
+			 ei->i_reserved_data_clusters);
 		WARN_ON(1);
-		to_free = ei->i_reserved_data_blocks;
+		to_free = ei->i_reserved_data_clusters;
 	}
-	ei->i_reserved_data_blocks -= to_free;
+	ei->i_reserved_data_clusters -= to_free;
 
-	if (ei->i_reserved_data_blocks == 0) {
+	if (ei->i_reserved_data_clusters == 0) {
 		/*
 		 * We can release all of the reserved metadata blocks
 		 * only when we have written all of the delayed
 		 * allocation blocks.
 		 * Note that in case of bigalloc, i_reserved_meta_blocks,
-		 * i_reserved_data_blocks, etc. refer to number of clusters.
+		 * i_reserved_data_clusters, etc. refer to number of clusters.
 		 */
 		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-				   ei->i_reserved_meta_blocks);
-		ei->i_reserved_meta_blocks = 0;
+				   ei->i_reserved_meta_clusters);
+		ei->i_reserved_meta_clusters = 0;
 		ei->i_da_metadata_calc_len = 0;
 	}
 
@@ -1439,10 +1439,10 @@ static void ext4_print_free_blocks(struct inode *inode)
 	       (long long) EXT4_C2B(EXT4_SB(inode->i_sb),
 		percpu_counter_sum(&sbi->s_dirtyclusters_counter)));
 	printk(KERN_CRIT "Block reservation details\n");
-	printk(KERN_CRIT "i_reserved_data_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_data_blocks);
-	printk(KERN_CRIT "i_reserved_meta_blocks=%u\n",
-	       EXT4_I(inode)->i_reserved_meta_blocks);
+	printk(KERN_CRIT "i_reserved_data_clusters=%u\n",
+	       EXT4_I(inode)->i_reserved_data_clusters);
+	printk(KERN_CRIT "i_reserved_meta_clusters=%u\n",
+	       EXT4_I(inode)->i_reserved_meta_clusters);
 	return;
 }
 
@@ -1978,7 +1978,8 @@ static int ext4_writepage(struct page *page,
 
 static int ext4_da_writepages_trans_blocks(struct inode *inode)
 {
-	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+	int max_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
+			EXT4_I(inode)->i_reserved_data_clusters);
 
 	/*
 	 * With non-extent format the journal credit needed to
@@ -2562,8 +2563,8 @@ int ext4_alloc_da_blocks(struct inode *inode)
 {
 	trace_ext4_alloc_da_blocks(inode);
 
-	if (!EXT4_I(inode)->i_reserved_data_blocks &&
-	    !EXT4_I(inode)->i_reserved_meta_blocks)
+	if (!EXT4_I(inode)->i_reserved_data_clusters &&
+	    !EXT4_I(inode)->i_reserved_meta_clusters)
 		return 0;
 
 	/*
@@ -4200,7 +4201,8 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * will return the blocks that include the delayed allocation
 	 * blocks for this file.
 	 */
-	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
+			EXT4_I(inode)->i_reserved_data_clusters);
 
 	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
 	return 0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..1cf8321 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -899,9 +899,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-	ei->i_reserved_data_blocks = 0;
-	ei->i_reserved_meta_blocks = 0;
-	ei->i_allocated_meta_blocks = 0;
+	ei->i_reserved_data_clusters = 0;
+	ei->i_reserved_meta_clusters = 0;
+	ei->i_allocated_meta_clusters = 0;
 	ei->i_da_metadata_calc_len = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
@@ -4646,6 +4646,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 			 EXT4_C2B(sbi, sbi->s_overhead_last));
 	bfree = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
 		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
+
 	/* prevent underflow in case that few free space is available */
 	buf->f_bfree = EXT4_C2B(sbi, max_t(s64, bfree, 0));
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 319538b..280a1ea 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -829,21 +829,21 @@ TRACE_EVENT(ext4_alloc_da_blocks,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field( unsigned int,	data_blocks	)
-		__field( unsigned int,	meta_blocks	)
+		__field( unsigned int,	data_clusters	)
+		__field( unsigned int,	meta_clusters	)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->ino	= inode->i_ino;
-		__entry->data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-		__entry->meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+		__entry->data_clusters = EXT4_I(inode)->i_reserved_data_clusters;
+		__entry->meta_clusters = EXT4_I(inode)->i_reserved_meta_clusters;
 	),
 
-	TP_printk("dev %d,%d ino %lu data_blocks %u meta_blocks %u",
+	TP_printk("dev %d,%d ino %lu data_clusters %u meta_clusters %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
-		  __entry->data_blocks, __entry->meta_blocks)
+		  __entry->data_clusters, __entry->meta_clusters)
 );
 
 TRACE_EVENT(ext4_mballoc_alloc,
@@ -1058,11 +1058,11 @@ TRACE_EVENT(ext4_da_update_reserve_space,
 		__entry->i_blocks = inode->i_blocks;
 		__entry->used_blocks = used_blocks;
 		__entry->reserved_data_blocks =
-				EXT4_I(inode)->i_reserved_data_blocks;
+				EXT4_I(inode)->i_reserved_data_clusters;
 		__entry->reserved_meta_blocks =
-				EXT4_I(inode)->i_reserved_meta_blocks;
+				EXT4_I(inode)->i_reserved_meta_clusters;
 		__entry->allocated_meta_blocks =
-				EXT4_I(inode)->i_allocated_meta_blocks;
+				EXT4_I(inode)->i_allocated_meta_clusters;
 		__entry->quota_claim = quota_claim;
 	),
 
@@ -1098,8 +1098,8 @@ TRACE_EVENT(ext4_da_reserve_space,
 		__entry->mode	= inode->i_mode;
 		__entry->i_blocks = inode->i_blocks;
 		__entry->md_needed = md_needed;
-		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
+		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_clusters;
+		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_clusters;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o i_blocks %llu md_needed %d "
@@ -1122,9 +1122,9 @@ TRACE_EVENT(ext4_da_release_space,
 		__field(	__u16,  mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	freed_blocks		)
-		__field(	int,	reserved_data_blocks	)
-		__field(	int,	reserved_meta_blocks	)
-		__field(	int,	allocated_meta_blocks	)
+		__field(	int,	reserved_data_clusters	)
+		__field(	int,	reserved_meta_clusters	)
+		__field(	int,	allocated_meta_clusters	)
 	),
 
 	TP_fast_assign(
@@ -1133,19 +1133,19 @@ TRACE_EVENT(ext4_da_release_space,
 		__entry->mode	= inode->i_mode;
 		__entry->i_blocks = inode->i_blocks;
 		__entry->freed_blocks = freed_blocks;
-		__entry->reserved_data_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-		__entry->reserved_meta_blocks = EXT4_I(inode)->i_reserved_meta_blocks;
-		__entry->allocated_meta_blocks = EXT4_I(inode)->i_allocated_meta_blocks;
+		__entry->reserved_data_clusters = EXT4_I(inode)->i_reserved_data_clusters;
+		__entry->reserved_meta_clusters = EXT4_I(inode)->i_reserved_meta_clusters;
+		__entry->allocated_meta_clusters = EXT4_I(inode)->i_allocated_meta_clusters;
 	),
 
 	TP_printk("dev %d,%d ino %lu mode 0%o i_blocks %llu freed_blocks %d "
-		  "reserved_data_blocks %d reserved_meta_blocks %d "
-		  "allocated_meta_blocks %d",
+		  "reserved_data_clusters %d reserved_meta_clusters %d "
+		  "allocated_meta_clusters %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->mode, __entry->i_blocks,
-		  __entry->freed_blocks, __entry->reserved_data_blocks,
-		  __entry->reserved_meta_blocks, __entry->allocated_meta_blocks)
+		  __entry->freed_blocks, __entry->reserved_data_clusters,
+		  __entry->reserved_meta_clusters, __entry->allocated_meta_clusters)
 );
 
 DECLARE_EVENT_CLASS(ext4__bitmap_load,
-- 
1.7.3.2

