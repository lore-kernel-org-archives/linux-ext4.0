From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 20:42:57 +0530
Message-ID: <20080821151257.GB6509@skywalker>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49923 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYHUPN0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 11:13:26 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7LFCXnf016605
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:12:33 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LFDNhm297038
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:13:24 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LFDN3X032048
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:13:23 +1000
Content-Disposition: inline
In-Reply-To: <20080820115331.GA9965@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 07:53:31AM -0400, Theodore Tso wrote:
> On Wed, Aug 20, 2008 at 04:16:44PM +0530, Aneesh Kumar K.V wrote:
> > > mpage_da_map_blocks block allocation failed for inode 323784 at logical
> > > offset 313 with max blocks 11 with error -28
> > > This should not happen.!! Data will be lost
> 
> We don't actually lose the data if free blocks are subsequently made
> available, correct?
> 
> > I tried this patch. There are still multiple ways we can get wrong free
> > block count. The patch reduced the number of errors. So we are doing
> > better with patch. But I guess we can't use the percpu_counter based
> > free block accounting with delalloc. Without delalloc it is ok even if
> > we find some wrong free blocks count . The actual block allocation will fail in
> > that case and we handle it perfectly fine. With delalloc we cannot
> > afford to fail the block allocation. Should we look at a free block
> > accounting rewrite using simple ext4_fsblk_t and and a spin lock ?
> 
> It would be a shame if we did given that the whole point of the percpu
> counter was to avoid a scalability bottleneck.  Perhaps we could take
> a filesystem-level spinlock only when the number of free blocks as
> reported by the percpu_counter falls below some critical level?
> 
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1543,7 +1543,14 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
> >  	}
> >  	/* reduce fs free blocks counter */
> >  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> > -
> > +	/*
> > +	 * Now check whether the block count has gone negative.
> > +	 * Some other CPU could have reserved blocks in between
> > +	 */
> > +	if (percpu_counter_read(&sbi->s_freeblocks_counter) < 0) {
> > +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +		return -ENOSPC;
> > +	}
> 
> 
> I think you want to do the check before calling percpu_counter_sub();
> otherwise when you return ENOSPC the free blocks counter ends up
> getting reduced (and gets left negative).
> 
> Also, this is one of the places where it might help if we did
> something like:
> 
> 	freeblocks = percpu_counter_read(&sbi->s_freeblocks_counter);
> 	if (freeblocks < NR_CPUS*4)
> 		freeblocks = percpu_counter_sum(&sbi->s_freeblocks_counter);
> 
> 	if (freeblocks < total) {
> 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 		return -ENOSPC;
> 	}
> 
> BTW, I was looking at the percpu_counter interface, and I'm confused
> why we have percpu_counter_sum_and_set() and percpu_counter_sum().  If
> we're taking the fbc->lock to calculate the precise value of the
> counter, why not simply set fbc->count?  
> 
> Also, it is singularly unfortunate that certain interfaces, such as
> percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
> definitely post-2.6.27, but it seems to me that we probably want
> something like percpu_counter_compare_lt() which does something like this:
> 
> static inline int percpu_counter_compare_lt(struct percpu_counter *fbc,
> 					    s64 amount)
> {
> #ifdef CONFIG_SMP
> 	if ((fbc->count - amount) < FBC_BATCH)
> 		percpu_counter_sum_and_set(fbc);
> #endif
> 	return 	(fbc->count < amount);
> }
> 
> ... which we would then use in ext4_has_free_blocks() and
> ext4_da_reserve_space().
> 

This is what i am testing now. It is much better. I am getting few
errors now. But I guess that may be due to our meta-data block
reservation going wrong. Still debugging.

-aneesh

commit be0a76f17f45b1009c40b2adb7d95f93dfdbb95a
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu Aug 21 15:56:19 2008 +0530

   ENOSPC handling 

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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c289c1..d965a05 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1537,13 +1537,10 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
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
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5267efc..7d94119 100644
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
@@ -4392,14 +4398,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
