From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 22:15:31 +0530
Message-ID: <20080821164531.GE6509@skywalker>
References: <20080820054339.GB6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:37148 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbYHUQqB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 12:46:01 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7LGjvd0027641
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 22:15:57 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LGjv3m1384508
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 22:15:57 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7LGjuUY021953
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2008 22:15:57 +0530
Content-Disposition: inline
In-Reply-To: <20080820054339.GB6381@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 11:13:39AM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> I am getting this even with the latest patch queue. The test program is
> a modified fsstress with fallocate support.
> 
> mpage_da_map_blocks block allocation failed for inode 377954 at logical
> offset 313 with max blocks 4 with error -28
> mpage_da_map_blocks block allocation failed for inode 336367 at logical
> offset 74 with max blocks 9 with error -28
> mpage_da_map_blocks block allocation failed for inode 345560 at logical
> offset 542 with max blocks 7 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 355317 at logical
> offset 152 with max blocks 10 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 395261 at logical
> offset 462 with max blocks 1 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 323784 at logical
> offset 313 with max blocks 11 with error -28
> This should not happen.!! Data will be lost
> 

With this patch i am not seeing error. It does the below

a) use ext4_claim_free_blocks that also update the free blocks count
b) Later after block allocation update the free blocks count if we
allocated less with non-delayed mode
c) Switch to non delay mode if we are low on free blocks. 

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index dfe2d4f..5d0a676 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1602,6 +1602,64 @@ ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 	return ret;
 }
 
+int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks)
+{
+	int cpu;
+	s64 free_blocks;
+	ext4_fsblk_t root_blocks = 0;
+	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+
+	free_blocks = percpu_counter_read(fbc);
+
+	if (!capable(CAP_SYS_RESOURCE) &&
+		sbi->s_resuid != current->fsuid &&
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		root_blocks = ext4_r_blocks_count(sbi->s_es);
+#ifdef CONFIG_SMP
+	/* Each CPU can accumulate FBC_BATCH blocks in their local
+	 * counters. So we need to make sure we have free blocks more
+	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+	 */
+	if (free_blocks - (nblocks + root_blocks) <
+			(4 * (FBC_BATCH * nr_cpu_ids))) {
+		/*
+		 * We need to sum and claim under lock
+		 * This is the slow patch which will be
+		 * taken when we are very low on free blocks
+		 */
+		spin_lock(&fbc->lock);
+		free_blocks = fbc->count;
+		for_each_online_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			free_blocks += *pcount;
+			*pcount = 0;
+		}
+		fbc->count = free_blocks;
+		if (free_blocks <= root_blocks) {
+			/* we don't have free space */
+			spin_unlock(&fbc->lock);
+			return -ENOSPC;
+		}
+		if (free_blocks - root_blocks < nblocks) {
+			spin_unlock(&fbc->lock);
+			return -ENOSPC;
+		}
+		fbc->count -= nblocks;
+		spin_unlock(&fbc->lock);
+		return 0;
+	}
+#endif
+	if (free_blocks <= root_blocks)
+		/* we don't have free space */
+		return -ENOSPC;
+	if (free_blocks - root_blocks < nblocks)
+		return -ENOSPC;
+	/* reduce fs free blocks counter */
+	percpu_counter_sub(fbc, nblocks);
+	return 0;
+}
+
 /**
  * ext4_has_free_blocks()
  * @sbi:	in-core super block structure.
@@ -1624,9 +1682,15 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 #ifdef CONFIG_SMP
-	if (free_blocks - root_blocks < FBC_BATCH)
+	/* Each CPU can accumulate FBC_BATCH blocks in their local
+	 * counters. So we need to make sure we have free blocks more
+	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+	 */
+	if (free_blocks - (nblocks + root_blocks) <
+					(4 * (FBC_BATCH * nr_cpu_ids))) {
 		free_blocks =
 			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
+	}
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
@@ -1634,7 +1698,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	if (free_blocks - root_blocks < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
- }
+}
 
 
 /**
@@ -1713,14 +1777,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		*count = ext4_has_free_blocks(sbi, *count);
-	}
-	if (*count == 0) {
-		*errp = -ENOSPC;
-		return 0;	/*return with ENOSPC error */
+		if (ext4_claim_free_blocks(sbi, *count)) {
+			*errp = -ENOSPC;
+			return 0;	/*return with ENOSPC error */
+		}
 	}
-	num = *count;
-
 	/*
 	 * Check quota for allocation of this block.
 	 */
@@ -1915,9 +1976,13 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
-		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
-
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag && (*count != num)) {
+		/*
+		 * we allocated less blocks than we
+		 * claimed. Add the difference back.
+		 */
+		percpu_counter_add(&sbi->s_freeblocks_counter, *count - num);
+	}
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
 		spin_lock(sb_bgl_lock(sbi, flex_group));
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7f11b25..3738039 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1047,6 +1047,8 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks);
 extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bf612a7..52902cc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2815,6 +2815,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 								path, iblock,
 								max_blocks);
 			if (ret <= 0) {
+				printk(KERN_CRIT "fallocate conversion failed %d\n", ret);
 				err = ret;
 				goto out2;
 			} else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c289c1..087abca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1030,11 +1030,17 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
 
-	/* Account for allocated meta_blocks */
-	mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+	if (mdb_free) {
+		/* Account for allocated meta_blocks */
+		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
 
-	/* update fs free blocks counter for truncate case */
-	percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+		/*
+		 * We have reserved more blocks.
+		 * Now free the extra blocks reserved
+		 */
+		percpu_counter_add(&sbi->s_freeblocks_counter, mdb_free);
+		EXT4_I(inode)->i_allocated_meta_blocks = 0;
+	}
 
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
@@ -1042,7 +1048,6 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	EXT4_I(inode)->i_allocated_meta_blocks = 0;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
@@ -1537,13 +1542,10 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	if (ext4_has_free_blocks(sbi, total) < total) {
+	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -ENOSPC;
 	}
-	/* reduce fs free blocks counter */
-	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
-
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
 	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
 
@@ -2462,11 +2464,21 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	unsigned from, to;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	s64 free_blocks;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	if (free_blocks < (4 * (FBC_BATCH * nr_cpu_ids))) {
+		/* switch to non delalloc mode */
+		*fsdata = (void *)1;
+		return ext4_write_begin(file, mapping, pos,
+					len, flags, pagep, fsdata);
+	}
+	*fsdata = (void *)0;
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2535,6 +2547,19 @@ static int ext4_da_write_end(struct file *file,
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
 	unsigned long start, end;
+	int low_free_blocks = (int)fsdata;
+
+	if (low_free_blocks) {
+		if (ext4_should_order_data(inode)) {
+			return ext4_ordered_write_end(file, mapping, pos,
+					len, copied, page, fsdata);
+		} else if (ext4_should_writeback_data(inode)) {
+			return ext4_writeback_write_end(file, mapping, pos,
+					len, copied, page, fsdata);
+		} else {
+			BUG();
+		}
+	}
 
 	start = pos & (PAGE_CACHE_SIZE - 1);
 	end = start + copied -1;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 96319b2..7d94119 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2977,9 +2977,15 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	 * at write_begin() time for delayed allocation
 	 * do not double accounting
 	 */
-	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
-		percpu_counter_sub(&sbi->s_freeblocks_counter,
-					ac->ac_b_ex.fe_len);
+	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
+			ac->ac_o_ex.fe_len != ac->ac_b_ex.fe_len) {
+		/*
+		 * we allocated less blocks than we calimed
+		 * Add the difference back
+		 */
+		percpu_counter_add(&sbi->s_freeblocks_counter,
+				ac->ac_o_ex.fe_len -ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4097,7 +4103,8 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, smp_processor_id());
+	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, get_cpu());
+	put_cpu();
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
@@ -4391,14 +4398,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		ar->len = ext4_has_free_blocks(sbi, ar->len);
-	}
-
-	if (ar->len == 0) {
-		*errp = -ENOSPC;
-		return 0;
+		if (ext4_claim_free_blocks(sbi, ar->len)) {
+			*errp = -ENOSPC;
+			return 0;
+		}
 	}
