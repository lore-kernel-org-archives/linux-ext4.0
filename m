From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: remove metadata reservation checks
Date: Mon, 23 Jun 2014 11:56:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406231140560.2169@localhost.localdomain>
References: <1403490981-5457-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaFWJ42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 05:56:28 -0400
In-Reply-To: <1403490981-5457-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 22 Jun 2014, Theodore Ts'o wrote:

> Date: Sun, 22 Jun 2014 22:36:21 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH] ext4: remove metadata reservation checks
> 
> Commit 27dd43854227b ("ext4: introduce reserved space") reserves 2% of
> the file system space to make sure metadata allocations will always
> succeed.  Given that, tracking the reservation of metadata blocks is
> no longer necessary.

Hi Ted,

I was a bit reluctant to do this when I introduced reserved space
since I though that we need to run with it for some time to make
sure that it's solid.

However I am still on the fence about this patch, because it was not
designed, at least initially to cover all metadata reservation, but
mainly those we sometimes can not predict (unwritten extent
conversion for example), or those when the prediction failed (in
this case we would see a warning).

I think that if we can be really sure, that the reserved space will
always have enough space to cover all possible metadata blocks
needed on writeback time (is there any other time we might need
metadata block and can not fail with ENOSPC?), then this patch is
definitely very useful.

However I am not sure how to prove that. I think that the size of the
journal might be an indication of how much "reserved" metadata block
we might need at any given time, but I am not entirely sure about
that. But if true, we probably need to modify the metadata
reservation code to take that into account.

So my question is, do you think that there is a way to prove that we
will have enough reserved blocks at any time for metadata allocation ?
If so, what is the metric we use to set the size of the reservation pool
in the first place ?

Thanks!
-Lukas

> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/balloc.c  |  1 -
>  fs/ext4/ext4.h    |  1 -
>  fs/ext4/extents.c |  3 +-
>  fs/ext4/inode.c   | 93 +++----------------------------------------------------
>  fs/ext4/mballoc.c | 15 +--------
>  5 files changed, 7 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 0762d14..807071d 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -623,7 +623,6 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  	if (!(*errp) &&
>  	    ext4_test_inode_state(inode, EXT4_STATE_DELALLOC_RESERVED)) {
>  		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		dquot_alloc_block_nofail(inode,
>  				EXT4_C2B(EXT4_SB(inode->i_sb), ar.len));
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7cc5a0e..d35c78c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -591,7 +591,6 @@ enum {
>  #define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
>  #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
>  #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
> -#define EXT4_FREE_BLOCKS_RESERVE		0x0040
>  
>  /*
>   * ioctl commands
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 4da228a..b30172d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1808,8 +1808,7 @@ static void ext4_ext_try_to_merge_up(handle_t *handle,
>  
>  	brelse(path[1].p_bh);
>  	ext4_free_blocks(handle, inode, NULL, blk, 1,
> -			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET |
> -			 EXT4_FREE_BLOCKS_RESERVE);
> +			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>  }
>  
>  /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8a06473..4ccb624 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -357,35 +357,10 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  		used = ei->i_reserved_data_blocks;
>  	}
>  
> -	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
> -		ext4_warning(inode->i_sb, "ino %lu, allocated %d "
> -			"with only %d reserved metadata blocks "
> -			"(releasing %d blocks with reserved %d data blocks)",
> -			inode->i_ino, ei->i_allocated_meta_blocks,
> -			     ei->i_reserved_meta_blocks, used,
> -			     ei->i_reserved_data_blocks);
> -		WARN_ON(1);
> -		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
> -	}
> -
>  	/* Update per-inode reservations */
>  	ei->i_reserved_data_blocks -= used;
> -	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
> -	percpu_counter_sub(&sbi->s_dirtyclusters_counter,
> -			   used + ei->i_allocated_meta_blocks);
> -	ei->i_allocated_meta_blocks = 0;
> +	percpu_counter_sub(&sbi->s_dirtyclusters_counter, used);
>  
> -	if (ei->i_reserved_data_blocks == 0) {
> -		/*
> -		 * We can release all of the reserved metadata blocks
> -		 * only when we have written all of the delayed
> -		 * allocation blocks.
> -		 */
> -		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
> -				   ei->i_reserved_meta_blocks);
> -		ei->i_reserved_meta_blocks = 0;
> -		ei->i_da_metadata_calc_len = 0;
> -	}
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  
>  	/* Update quota subsystem for data blocks */
> @@ -1232,35 +1207,6 @@ static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
>  	ext4_lblk_t save_last_lblock;
>  	int save_len;
>  
> -	/*
> -	 * recalculate the amount of metadata blocks to reserve
> -	 * in order to allocate nrblocks
> -	 * worse case is one extent per block
> -	 */
> -	spin_lock(&ei->i_block_reservation_lock);
> -	/*
> -	 * ext4_calc_metadata_amount() has side effects, which we have
> -	 * to be prepared undo if we fail to claim space.
> -	 */
> -	save_len = ei->i_da_metadata_calc_len;
> -	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
> -	md_needed = EXT4_NUM_B2C(sbi,
> -				 ext4_calc_metadata_amount(inode, lblock));
> -	trace_ext4_da_reserve_space(inode, md_needed);
> -
> -	/*
> -	 * We do still charge estimated metadata to the sb though;
> -	 * we cannot afford to run out of free blocks.
> -	 */
> -	if (ext4_claim_free_clusters(sbi, md_needed, 0)) {
> -		ei->i_da_metadata_calc_len = save_len;
> -		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
> -		spin_unlock(&ei->i_block_reservation_lock);
> -		return -ENOSPC;
> -	}
> -	ei->i_reserved_meta_blocks += md_needed;
> -	spin_unlock(&ei->i_block_reservation_lock);
> -
>  	return 0;       /* success */
>  }
>  
> @@ -1295,25 +1241,15 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
>  	 * ext4_calc_metadata_amount() has side effects, which we have
>  	 * to be prepared undo if we fail to claim space.
>  	 */
> -	save_len = ei->i_da_metadata_calc_len;
> -	save_last_lblock = ei->i_da_metadata_calc_last_lblock;
> -	md_needed = EXT4_NUM_B2C(sbi,
> -				 ext4_calc_metadata_amount(inode, lblock));
> -	trace_ext4_da_reserve_space(inode, md_needed);
> +	md_needed = 0;
> +	trace_ext4_da_reserve_space(inode, 0);
>  
> -	/*
> -	 * We do still charge estimated metadata to the sb though;
> -	 * we cannot afford to run out of free blocks.
> -	 */
> -	if (ext4_claim_free_clusters(sbi, md_needed + 1, 0)) {
> -		ei->i_da_metadata_calc_len = save_len;
> -		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
> +	if (ext4_claim_free_clusters(sbi, 1, 0)) {
>  		spin_unlock(&ei->i_block_reservation_lock);
>  		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
>  		return -ENOSPC;
>  	}
>  	ei->i_reserved_data_blocks++;
> -	ei->i_reserved_meta_blocks += md_needed;
>  	spin_unlock(&ei->i_block_reservation_lock);
>  
>  	return 0;       /* success */
> @@ -1346,20 +1282,6 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
>  	}
>  	ei->i_reserved_data_blocks -= to_free;
>  
> -	if (ei->i_reserved_data_blocks == 0) {
> -		/*
> -		 * We can release all of the reserved metadata blocks
> -		 * only when we have written all of the delayed
> -		 * allocation blocks.
> -		 * Note that in case of bigalloc, i_reserved_meta_blocks,
> -		 * i_reserved_data_blocks, etc. refer to number of clusters.
> -		 */
> -		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
> -				   ei->i_reserved_meta_blocks);
> -		ei->i_reserved_meta_blocks = 0;
> -		ei->i_da_metadata_calc_len = 0;
> -	}
> -
>  	/* update fs dirty data blocks counter */
>  	percpu_counter_sub(&sbi->s_dirtyclusters_counter, to_free);
>  
> @@ -1500,10 +1422,6 @@ static void ext4_print_free_blocks(struct inode *inode)
>  	ext4_msg(sb, KERN_CRIT, "Block reservation details");
>  	ext4_msg(sb, KERN_CRIT, "i_reserved_data_blocks=%u",
>  		 ei->i_reserved_data_blocks);
> -	ext4_msg(sb, KERN_CRIT, "i_reserved_meta_blocks=%u",
> -	       ei->i_reserved_meta_blocks);
> -	ext4_msg(sb, KERN_CRIT, "i_allocated_meta_blocks=%u",
> -	       ei->i_allocated_meta_blocks);
>  	return;
>  }
>  
> @@ -2843,8 +2761,7 @@ int ext4_alloc_da_blocks(struct inode *inode)
>  {
>  	trace_ext4_alloc_da_blocks(inode);
>  
> -	if (!EXT4_I(inode)->i_reserved_data_blocks &&
> -	    !EXT4_I(inode)->i_reserved_meta_blocks)
> +	if (!EXT4_I(inode)->i_reserved_data_blocks)
>  		return 0;
>  
>  	/*
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 59e3162..4503b8f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4619,7 +4619,6 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  	struct buffer_head *gd_bh;
>  	ext4_group_t block_group;
>  	struct ext4_sb_info *sbi;
> -	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_buddy e4b;
>  	unsigned int count_clusters;
>  	int err = 0;
> @@ -4830,19 +4829,7 @@ do_more:
>  			     &sbi->s_flex_groups[flex_group].free_clusters);
>  	}
>  
> -	if (flags & EXT4_FREE_BLOCKS_RESERVE && ei->i_reserved_data_blocks) {
> -		percpu_counter_add(&sbi->s_dirtyclusters_counter,
> -				   count_clusters);
> -		spin_lock(&ei->i_block_reservation_lock);
> -		if (flags & EXT4_FREE_BLOCKS_METADATA)
> -			ei->i_reserved_meta_blocks += count_clusters;
> -		else
> -			ei->i_reserved_data_blocks += count_clusters;
> -		spin_unlock(&ei->i_block_reservation_lock);
> -		if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
> -			dquot_reclaim_block(inode,
> -					EXT4_C2B(sbi, count_clusters));
> -	} else if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
> +	if (!(flags & EXT4_FREE_BLOCKS_NO_QUOT_UPDATE))
>  		dquot_free_block(inode, EXT4_C2B(sbi, count_clusters));
>  	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
>  
> 
