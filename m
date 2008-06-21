From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] delalloc: add quota handling
Date: Sat, 21 Jun 2008 16:18:14 +0530
Message-ID: <20080621104814.GB9584@skywalker>
References: <1214010878.27507.228.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34405 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYFUKtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 06:49:16 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5LAmPvb000709
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 20:48:25 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5LAmqiM4591786
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 20:48:52 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5LAnEHu018801
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 20:49:14 +1000
Content-Disposition: inline
In-Reply-To: <1214010878.27507.228.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2008 at 06:14:38PM -0700, Mingming wrote:
> Correct quota handling in delayed allocation. With this patch,
> the quota for blocks are counted at block reservation time when
> the fs free blocks counter are updated, instead of at later 
> block allocation time.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/balloc.c  |    8 +++++---
>  fs/ext4/inode.c   |    5 +++++
>  fs/ext4/mballoc.c |   22 ++++++++++++----------
>  3 files changed, 22 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6.26-rc6/fs/ext4/balloc.c
> ===================================================================
> --- linux-2.6.26-rc6.orig/fs/ext4/balloc.c	2008-06-20 18:06:02.000000000 -0700
> +++ linux-2.6.26-rc6/fs/ext4/balloc.c	2008-06-20 18:06:05.000000000 -0700
> @@ -1716,7 +1716,8 @@ ext4_fsblk_t ext4_old_new_blocks(handle_
>  	/*
>  	 * Check quota for allocation of this block.
>  	 */
> -	if (DQUOT_ALLOC_BLOCK(inode, num)) {
> +	if (!EXT4_I(inode)->i_delalloc_reserved_flag &&
> +	     DQUOT_ALLOC_BLOCK(inode, num)) {
>  		*errp = -EDQUOT;
>  		return 0;
>  	}
> @@ -1928,7 +1929,8 @@ allocated:
> 
>  	*errp = 0;
>  	brelse(bitmap_bh);
> -	DQUOT_FREE_BLOCK(inode, *count-num);
> +	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
> +		DQUOT_FREE_BLOCK(inode, *count-num);
>  	*count = num;
>  	return ret_block;
> 
> @@ -1942,7 +1944,7 @@ out:
>  	/*
>  	 * Undo the block allocation
>  	 */
> -	if (!performed_allocation)
> +	if (!EXT4_I(inode)->i_delalloc_reserved_flag && !performed_allocation)
>  		DQUOT_FREE_BLOCK(inode, *count);
>  	brelse(bitmap_bh);
>  	return 0;
> Index: linux-2.6.26-rc6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-20 18:06:02.000000000 -0700
> +++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-20 18:06:05.000000000 -0700
> @@ -1450,6 +1450,9 @@ static int ext4_da_reserve_space(struct 
>  		return -ENOSPC;
>  	}
> 
> +	if (DQUOT_ALLOC_BLOCK(inode, total))
> +		return -EDQUOT;
> +

We should not be counting meta-data blocks for quota. I guess this
should be 

	if (DQUOT_ALLOC_BLOCK(inode, nrblocks))
		return -EDQUOT;

Also i think we should be doing quota check first. In mballoc we request
for less number of blocks if quota is limited. In case of
ext4_da_reserve_space even though we get called only with one block
reservation request to make the code correct i guess we should do the
mballoc equivalent.

while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
	ar->flags |= EXT4_MB_HINT_NOPREALLOC;
	ar->len--;
}


Also in mballoc we should do some test for free quota blocks and
should set the EXT4_MB_HINT_NOPREALLOC even for delalloc.

>  	/* reduce fs free blocks counter */
>  	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> 
> @@ -1479,6 +1482,8 @@ void ext4_da_release_space(struct inode 
> 
>  	release = to_free + mdb_free;
> 
> +	DQUOT_FREE_BLOCK(inode, release);


This should be
	DQUOT_FREE_BLOCK(inode, to_free);

> +
>  	/* update fs free blocks counter for truncate case */
>  	percpu_counter_add(&sbi->s_freeblocks_counter, release);
> 
> Index: linux-2.6.26-rc6/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.26-rc6.orig/fs/ext4/mballoc.c	2008-06-20 18:06:01.000000000 -0700
> +++ linux-2.6.26-rc6/fs/ext4/mballoc.c	2008-06-20 18:06:05.000000000 -0700
> @@ -4037,7 +4037,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
>  	struct super_block *sb;
>  	ext4_fsblk_t block = 0;
>  	int freed;
> -	int inquota;
> +	int inquota = 0;
> 
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
> @@ -4059,15 +4059,17 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
>  		return 0;
>  	}
> 
> -	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> -		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
> -		ar->len--;
> -	}
> -	if (ar->len == 0) {
> -		*errp = -EDQUOT;
> -		return 0;
> +	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
> +		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> +			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
> +			ar->len--;
> +		}


We need to set ar->flags even for delalloc. Otherwise we will try to
normalize the request in mballoc.


> +		if (ar->len == 0) {
> +			*errp = -EDQUOT;
> +			return 0;
> +		}
> +		inquota = ar->len;
>  	}
> -	inquota = ar->len;
> 
>  	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
>  		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
> @@ -4134,7 +4136,7 @@ repeat:
>  out2:
>  	kmem_cache_free(ext4_ac_cachep, ac);
>  out1:
> -	if (ar->len < inquota)
> +	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag && ar->len < inquota)
>  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> 
>  	return block;
> 
> 

-aneesh
