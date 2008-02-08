From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Thu, 07 Feb 2008 17:30:48 -0800
Message-ID: <1202434248.3840.22.camel@localhost.localdomain>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice>
	 <20080204060055.GC7494@skywalker>
	 <1202335188.6886.15.camel@norville.austin.ibm.com>
	 <20080207125548.GA8701@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41928 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbYBHBat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 20:30:49 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m181UmB2007278
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:30:48 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m181UmbH280498
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:30:48 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m181UlTA019997
	for <linux-ext4@vger.kernel.org>; Thu, 7 Feb 2008 20:30:48 -0500
In-Reply-To: <20080207125548.GA8701@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-02-07 at 18:25 +0530, Aneesh Kumar K.V wrote:

> ext4: Don't panic in case of corrupt bitmap
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Multiblock allocator was calling BUG_ON in many case if the free and used
> blocks count obtained looking at the bitmap is different from what
> the allocator internally accounted for. Use ext4_error in such case
> and don't panic the system.
> 

There seems a lot of BUG_ON() and BUG() in mballoc code, other than this
case. Should it always panic the whole system in those cases? Perhaps
replacing with ext4_error() or some cases just WARN_ON is enough.

Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> 
>  fs/ext4/mballoc.c |   35 +++++++++++++++++++++--------------
>  1 files changed, 21 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 06d1f52..656729b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -680,7 +680,6 @@ static void *mb_find_buddy(struct ext4_buddy *e4b, int order, int *max)
>  {
>  	char *bb;
> 
> -	/* FIXME!! is this needed */
>  	BUG_ON(EXT4_MB_BITMAP(e4b) == EXT4_MB_BUDDY(e4b));
>  	BUG_ON(max == NULL);
> 



> @@ -964,7 +963,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
>  	grp->bb_fragments = fragments;
> 
>  	if (free != grp->bb_free) {
> -		printk(KERN_DEBUG
> +		ext4_error(sb, __FUNCTION__,
>  			"EXT4-fs: group %lu: %u blocks in bitmap, %u in gd\n",
>  			group, free, grp->bb_free);
>  		grp->bb_free = free;
> @@ -1821,13 +1820,24 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
>  		i = ext4_find_next_zero_bit(bitmap,
>  						EXT4_BLOCKS_PER_GROUP(sb), i);
>  		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
> -			BUG_ON(free != 0);
> +			/*
> +			 * IF we corrupt the bitmap  we won't find any
> +			 * free blocks even though group info says we
> +			 * we have free blocks
> +			 */
> +			ext4_error(sb, __FUNCTION__, "%d free blocks as per "
> +					"group info. But bitmap says 0\n",
> +					free);
>  			break;
>  		}
> 
>  		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
>  		BUG_ON(ex.fe_len <= 0);
> -		BUG_ON(free < ex.fe_len);
> +		if (free < ex.fe_len) {
> +			ext4_error(sb, __FUNCTION__, "%d free blocks as per "
> +					"group info. But got %d blocks\n",
> +					free, ex.fe_len);
> +		}
> 
>  		ext4_mb_measure_extent(ac, &ex, e4b);
> 
> @@ -3354,13 +3364,10 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
>  	ac->ac_pa = pa;
> 
>  	/* we don't correct pa_pstart or pa_plen here to avoid
> -	 * possible race when tte group is being loaded concurrently
> +	 * possible race when the group is being loaded concurrently
>  	 * instead we correct pa later, after blocks are marked
> -	 * in on-disk bitmap -- see ext4_mb_release_context() */
> -	/*
> -	 * FIXME!! but the other CPUs can look at this particular
> -	 * pa and think that it have enought free blocks if we
> -	 * don't update pa_free here right ?
> +	 * in on-disk bitmap -- see ext4_mb_release_context()
> +	 * Other CPUs are prevented from allocating from this pa by lg_mutex
>  	 */
>  	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
>  }
> @@ -3743,13 +3750,13 @@ static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
>  		bit = next + 1;
>  	}
>  	if (free != pa->pa_free) {
> -		printk(KERN_ERR "pa %p: logic %lu, phys. %lu, len %lu\n",
> +		printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
>  			pa, (unsigned long) pa->pa_lstart,
>  			(unsigned long) pa->pa_pstart,
>  			(unsigned long) pa->pa_len);
> -		printk(KERN_ERR "free %u, pa_free %u\n", free, pa->pa_free);
> +		ext4_error(sb, __FUNCTION__, "free %u, pa_free %u\n",
> +						free, pa->pa_free);
>  	}
> -	BUG_ON(free != pa->pa_free);
>  	atomic_add(free, &sbi->s_mb_discarded);
> 
>  	return err;
> @@ -4405,7 +4412,7 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
>  			unsigned long block, unsigned long count,
>  			int metadata, unsigned long *freed)
>  {
> -	struct buffer_head *bitmap_bh = 0;
> +	struct buffer_head *bitmap_bh = NULL;
>  	struct super_block *sb = inode->i_sb;
>  	struct ext4_allocation_context ac;
>  	struct ext4_group_desc *gdp;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
