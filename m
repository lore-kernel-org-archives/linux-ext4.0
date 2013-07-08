From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
Date: Mon, 8 Jul 2013 10:56:03 +0200
Message-ID: <20130708085603.GB5988@quack.suse.cz>
References: <alpine.LFD.2.00.1307041730590.30302@localhost.localdomain>
 <1373269107-9678-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3GHI4H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 04:56:07 -0400
Content-Disposition: inline
In-Reply-To: <1373269107-9678-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-07-13 09:38:27, Lukas Czerner wrote:
> Currently if the block allocator can not find the goal to allocate we
> would use global goal for stream allocation. However the global goal
> (s_mb_last_group and s_mb_last_start) will move further every time such
> allocation appears and never move backwards.
> 
> This causes several problems in certain scenarios:
> 
> - the goal will move further and further preventing us from reusing
>   space which might have been freed since then. This is ok from the file
>   system point of view because we will reuse that space eventually,
>   however we're allocating block from slower parts of the spinning disk
>   even though it might not be necessary.
> - The above also causes more serious problem for example for thinly
>   provisioned storage (sparse images backed storage as well), because
>   instead of reusing blocks which are already provisioned we would try
>   to use new blocks. This would unnecessarily drain storage free blocks
>   pool.
> - This will also cause blocks to be allocated further from the given
>   goal than it's necessary. Consider for example truncating, or removing
>   and rewriting the file in the loop. This workload will never reuse
>   freed blocks until we continually claim and free all the block in the
>   file system.
> 
> Note that file systems like xfs, ext3, or btrfs does not have this
> problem. This is simply caused by the notion of global pool.
> 
> Fix this by changing the global goal to be goal per inode. This will
> allow us to invalidate the goal every time the inode has been truncated,
> or newly created, so in those cases we would try to use the proper more
> specific goal which is based on inode position.
  When looking at your patch for second time, I started wondering, whether
we need per-inode stream goal at all. We already do set goal in the
allocation request for mballoc (ar->goal) e.g. in ext4_ext_find_goal().
It seems strange to then reset it inside mballoc and I don't even think
mballoc will change it to something else now when the goal is per-inode and
not global.

Which makes me think again about why someone introduced global goal for
stream allocations in the first place? Maybe the motivation was that at
each moment we will have only one area from where we allocate streaming
data (large chunks of blocks) which may presumably reduce fragmentation.
I've added Andreas to CC, maybe he'll remember the purpose.

								Honza

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: Use proper types. Define invalid value
> 
>  fs/ext4/ext4.h    | 12 +++++++++---
>  fs/ext4/inode.c   |  8 ++++++++
>  fs/ext4/mballoc.c | 20 ++++++++------------
>  3 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6ed348d..d3e9d10 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -917,9 +917,18 @@ struct ext4_inode_info {
>  
>  	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
>  	__u32 i_csum_seed;
> +
> +	/* Where last allocation was done - for stream allocation */
> +	ext4_group_t i_last_group;
> +	ext4_grpblk_t i_last_start;
>  };
>  
>  /*
> + * Invalid value for last allocation pointer
> + */
> +#define EXT4_INVAL_GRPNO		UINT_MAX
> +
> +/*
>   * File system states
>   */
>  #define	EXT4_VALID_FS			0x0001	/* Unmounted cleanly */
> @@ -1242,9 +1251,6 @@ struct ext4_sb_info {
>  	unsigned int s_mb_order2_reqs;
>  	unsigned int s_mb_group_prealloc;
>  	unsigned int s_max_dir_size_kb;
> -	/* where last allocation was done - for stream allocation */
> -	unsigned long s_mb_last_group;
> -	unsigned long s_mb_last_start;
>  
>  	/* stats for buddy allocator */
>  	atomic_t s_bal_reqs;	/* number of reqs with len > 1 */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0188e65..8d3e67c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3702,6 +3702,10 @@ void ext4_truncate(struct inode *inode)
>  	else
>  		ext4_ind_truncate(handle, inode);
>  
> +	/* Invalidate last allocation pointers */
> +	ei->i_last_group = EXT4_INVAL_GRPNO;
> +	ei->i_last_start = 0;
> +
>  	up_write(&ei->i_data_sem);
>  
>  	if (IS_SYNC(inode))
> @@ -4060,6 +4064,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>  	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
>  	ei->i_block_group = iloc.block_group;
>  	ei->i_last_alloc_group = ~0;
> +
> +	/* Invalidate last allocation counters */
> +	ei->i_last_group = EXT4_INVAL_GRPNO;
> +	ei->i_last_start = 0;
>  	/*
>  	 * NOTE! The in-memory inode i_data array is in little-endian order
>  	 * even on big-endian machines: we do NOT byteswap the block numbers!
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a9ff5e5..7609f77 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1591,7 +1591,6 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
>  static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
>  					struct ext4_buddy *e4b)
>  {
> -	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
>  	int ret;
>  
>  	BUG_ON(ac->ac_b_ex.fe_group != e4b->bd_group);
> @@ -1622,10 +1621,8 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
>  	get_page(ac->ac_buddy_page);
>  	/* store last allocated for subsequent stream allocation */
>  	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
> -		spin_lock(&sbi->s_md_lock);
> -		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
> -		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
> -		spin_unlock(&sbi->s_md_lock);
> +		EXT4_I(ac->ac_inode)->i_last_group = ac->ac_f_ex.fe_group;
> +		EXT4_I(ac->ac_inode)->i_last_start = ac->ac_f_ex.fe_start;
>  	}
>  }
>  
> @@ -2080,13 +2077,12 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  			ac->ac_2order = i - 1;
>  	}
>  
> -	/* if stream allocation is enabled, use global goal */
> -	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
> -		/* TBD: may be hot point */
> -		spin_lock(&sbi->s_md_lock);
> -		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
> -		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
> -		spin_unlock(&sbi->s_md_lock);
> +	/* if stream allocation is enabled and per inode goal is
> +	 * set, use it */
> +	if ((ac->ac_flags & EXT4_MB_STREAM_ALLOC) &&
> +	   (EXT4_I(ac->ac_inode)->i_last_group != EXT4_INVAL_GRPNO)) {
> +		ac->ac_g_ex.fe_group = EXT4_I(ac->ac_inode)->i_last_group;
> +		ac->ac_g_ex.fe_start = EXT4_I(ac->ac_inode)->i_last_start;
>  	}
>  
>  	/* Let's just scan groups to find more-less suitable blocks */
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
