From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mballoc changes from ldiskfs
Date: Tue, 8 Jan 2008 00:27:58 +0530
Message-ID: <20080107185758.GB15183@skywalker>
References: <20080107182800.GA15183@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:57521 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYAGS6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jan 2008 13:58:07 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m07IvpQe031213
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:57:51 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m07Iw5Ui3256342
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:58:05 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m07Iw5oO002938
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 05:58:05 +1100
Content-Disposition: inline
In-Reply-To: <20080107182800.GA15183@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 07, 2008 at 11:58:00PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> This patch is  not even compile tested. I am sending it over to find out
> whether some of the changes are even needed and to make sure i didn't
> drop any bug fix in the merge.
> 
> something I noticed.
> 
> a) prealloc table is completely gone.
> b) ext4_mb_put_pa change. ( I guess that is a bug with ldiskfs ).
> 
> 
> now by default request less that 64K use locality group preallocation.
> 
> The ldiskfs change i looked at is from
> lustre/ldiskfs/kernel_patches/patches/ext3-mballoc3-core.patch

[... snip... ]

> 
>  	BUG_ON(ex->fe_len <= 0);
> -	BUG_ON(ex->fe_len >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
> -	BUG_ON(ex->fe_start >= (1 << ac->ac_sb->s_blocksize_bits) * 8);
> +	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> +	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
>  	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
> 
>  	ac->ac_found++;
> @@ -1553,7 +1546,6 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
>  		/* if the request is satisfied, then we try to find
>  		 * an extent that still satisfy the request, but is
>  		 * smaller than previous one */
> -		if (ex->fe_len < bex->fe_len)
>  			*bex = *ex;
>  	}


This one is a bug fix for ext4 patch queue from Alex. So this change is needed.


> 
> @@ -1702,8 +1694,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
>  	i = e4b->bd_info->bb_first_free;
> 
>  	while (free && ac->ac_status == AC_STATUS_CONTINUE) {
> -		i = ext4_find_next_zero_bit(bitmap, sb->s_blocksize * 8, i);
> -		if (i >= sb->s_blocksize * 8) {
> +		i = ext4_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
> +		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
>  			BUG_ON(free != 0);
>  			break;
>  		}
> @@ -1744,7 +1736,7 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
>  	i = (i - le32_to_cpu(sbi->s_es->s_first_data_block))
>  			% EXT4_BLOCKS_PER_GROUP(sb);
> 
> -	while (i < sb->s_blocksize * 8) {
> +	while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
>  		if (!mb_test_bit(i, bitmap)) {
>  			max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
>  			if (max >= sbi->s_stripe) {
> @@ -1839,20 +1831,6 @@ static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  			ac->ac_2order = i;
>  	}
> 
> -	/* if stream allocation is enabled, use global goal */
> -
> -	/* FIXME!!
> -	 * Need more explanation on what it is and how stream
> -	 * allocation is represented by the below conditional
> -	 */
> -	if ((ac->ac_g_ex.fe_len < sbi->s_mb_large_req) &&
> -			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
> -		/* TBD: may be hot point */
> -		spin_lock(&sbi->s_md_lock);
> -		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
> -		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
> -		spin_unlock(&sbi->s_md_lock);
> -	}
> 
>  	group = ac->ac_g_ex.fe_group;
> 
> @@ -2291,7 +2269,8 @@ static void ext4_mb_history_init(struct super_block *sb)
>  	spin_lock_init(&sbi->s_mb_history_lock);
>  	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
>  	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
> -	memset(sbi->s_mb_history, 0, i);
> +	if (likely(sbi->s_mb_history != NULL))
> +		memset(sbi->s_mb_history, 0, i);
>  	/* if we can't allocate history, then we simple won't use it */
>  }
> 
> @@ -2300,7 +2279,7 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
>  	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
>  	struct ext4_mb_history h;
> 
> -	if (likely(sbi->s_mb_history == NULL))
> +	if (unlikely(sbi->s_mb_history == NULL))
>  		return;
> 
>  	if (!(ac->ac_op & sbi->s_mb_history_filter))
> @@ -2312,11 +2291,6 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
>  	h.orig = ac->ac_o_ex;
>  	h.result = ac->ac_b_ex;
>  	h.flags = ac->ac_flags;
> -	h.found = ac->ac_found;
> -	h.groups = ac->ac_groups_scanned;
> -	h.cr = ac->ac_criteria;
> -	h.tail = ac->ac_tail;
> -	h.buddy = ac->ac_buddy;
>  	h.merged = 0;


This one is a bug for ext4 patch queue from Alex. So this change is
needed.


[....]
> +
> +	/* first, try to predict filesize */
> +	/* XXX: should this table be tunable? */

Here we says we need to have tunables. Does that mean prealloc table is
needed ?


> +	start = 0;
> +	if (size <= 16 * 1024) {
> +		size = 16 * 1024;
> +	} else if (size <= 32 * 1024) {
> +		size = 32 * 1024;
> +	} else if (size <= 64 * 1024) {
> +		size = 64 * 1024;
> +	} else if (size <= 128 * 1024) {
> +		size = 128 * 1024;
> +	} else if (size <= 256 * 1024) {
> +		size = 256 * 1024;
> +	} else if (size <= 512 * 1024) {
> +		size = 512 * 1024;
> +	} else if (size <= 1024 * 1024) {
> +		size = 1024 * 1024;
> +	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
> +		start = ac->ac_o_ex.fe_logical << bsbits;
> +		start = (start / (1024 * 1024)) * (1024 * 1024);
> +		size = 1024 * 1024;
> +	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
> +		start = ac->ac_o_ex.fe_logical << bsbits;
> +		start = (start / (4 * (1024 * 1024))) * 4 * (1024 * 1024);
> +		size = 4 * 1024 * 1024;
> +	} else if(NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,(8<<20)>>bsbits,max,bsbits)){
> +		start = ac->ac_o_ex.fe_logical;
> +		start = start << bsbits;
> +		start = (start / (8 * (1024 * 1024))) * 8 * (1024 * 1024);
> +		size = 8 * 1024 * 1024;
> +	} else {
> +		start = ac->ac_o_ex.fe_logical;
> +		start = start << bsbits;
> +		size = ac->ac_o_ex.fe_len << bsbits;
>  	}
> -	orig_size = size;
> -	orig_start = start;
> +	orig_size = size = size >> bsbits;
> +	orig_start = start = start >> bsbits;
> 
>  	/* don't cover already allocated blocks in selected range */
>  	if (ar->pleft && start <= ar->lleft) {
> @@ -3203,22 +3098,6 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  	ac->ac_g_ex.fe_logical = start;
>  	ac->ac_g_ex.fe_len = size;
> 
> -	/* define goal start in order to merge */
> -	if (ar->pright && (ar->lright == (start + size))) {
> -		/* merge to the right */
> -		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> -		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
> -	}
> -	if (ar->pleft && (ar->lleft + 1 == start)) {
> -		/* merge to the left */
> -		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> -		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
> -	}
> -
>  	mb_debug("goal: %u(was %u) blocks at %u\n", (unsigned) size,
>  		(unsigned) orig_size, (unsigned) start);
>  }
> @@ -3395,8 +3274,10 @@ static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
>  					     &groupnr, &start);
>  		len = pa->pa_len;
>  		spin_unlock(&pa->pa_lock);
> +		if (unlikely(len == 0))
> +			continue;
>  		BUG_ON(groupnr != group);
> -		mb_set_bits(bitmap, start, len);
> +		mb_set_bits(sb_bgl_lock(EXT4_SB(sb), group), bitmap, start, len);
>  		preallocated += len;
>  		count++;
>  	}
> @@ -3425,7 +3306,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
> 
>  	/* in this short window concurrent discard can set pa_deleted */
>  	spin_lock(&pa->pa_lock);
> -	if (pa->pa_deleted == 1) {
> +	if (pa->pa_deleted == 0) {
>  		spin_unlock(&pa->pa_lock);
>  		return;
>  	}


I think that should == 1 (ldiskfs have it == 0)
