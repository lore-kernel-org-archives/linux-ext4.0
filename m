From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 3/3] ext4: quota handling for delayed allocation
Date: Tue, 4 Nov 2008 17:32:15 -0800
Message-ID: <20081104173215.92ac3585.akpm@linux-foundation.org>
References: <1225488451.7600.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1225488451.7600.14.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 31 Oct 2008 14:27:31 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> ext4: quota reservation for delayed allocation
> 
> Uses quota reservation/claim/release to handle quota properly for delayed
> allocation in the three steps: 1) quotas are reserved when data being copied
> to cache when block allocation is defered 2) when new blocks are allocated.
> reserved quotas are converted to the real allocated quota, 2) over-booked
> quotas for metadata blocks are released back.
> 
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c   |   25 ++++++++++++++++++++++++-
>  fs/ext4/mballoc.c |   18 +++++++++---------
>  fs/ext4/super.c   |    2 ++
>  3 files changed, 35 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6.28-rc2/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/ext4/inode.c	2008-10-29 13:26:55.000000000 -0700
> +++ linux-2.6.28-rc2/fs/ext4/inode.c	2008-10-30 14:25:47.000000000 -0700
> @@ -994,7 +994,9 @@ static void ext4_da_update_reserve_space
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	int total, mdb, mdb_free;
> +	int claim_quota, free_quota = 0;
>  
> +	claim_quota = used;
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	/* recalculate the number of metablocks still need to be reserved */
>  	total = EXT4_I(inode)->i_reserved_data_blocks - used;
> @@ -1007,6 +1009,8 @@ static void ext4_da_update_reserve_space
>  	if (mdb_free) {
>  		/* Account for allocated meta_blocks */
>  		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
> +		free_quota = mdb_free;
> +		claim_quota += EXT4_I(inode)->i_allocated_meta_blocks;
>  
>  		/* update fs dirty blocks counter */
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> @@ -1017,8 +1021,14 @@ static void ext4_da_update_reserve_space
>  	/* update per-inode reservations */
>  	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
>  	EXT4_I(inode)->i_reserved_data_blocks -= used;
> -
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
> +	/*
> +	 * free those over-booking quota for metadata blocks
> +	 */
> +
> +	if (free_quota)
> +		DQUOT_RELEASE_RSV_BLOCK(inode, free_quota);
>  }
>  
>  /*
> @@ -1514,8 +1524,8 @@ static int ext4_journalled_write_end(str
>  static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>  {
>  	int retries = 0;
> -       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -       unsigned long md_needed, mdblocks, total = 0;
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	unsigned long md_needed, mdblocks, total = 0;
>  
>  	/*
>  	 * recalculate the amount of metadata blocks to reserve
> @@ -1531,12 +1541,23 @@ repeat:
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
>  
> +	/*
> +	 * Make quota reservation here, to prevent quota overflow
> +	 * later.Real quota accounting is done at pages writeout
> +	 * time

"Make the quota reservation here to prevent quota overflow later.  Real
quota accounting is performed and page writeout time."


> +	 */
> +	 if (DQUOT_RESERVE_BLOCK(inode, total)) {
> +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +		return -EDQUOT;
> +	}

Mangled whitespace.  checkpatch seems to miss this (but you didn't run
checkpatch anyway.  Please do so?)

>  	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
>  		}
> +		DQUOT_RELEASE_RSV_BLOCK(inode,total);
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> @@ -1590,6 +1611,8 @@ static void ext4_da_release_space(struct
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
> +	DQUOT_RELEASE_RSV_BLOCK(inode, release);
>  }

DQUOT_RESERVE_BLOCK needs i_block_reservation_lock?  And
DQUOT_RELEASE_RSV_BLOCK does not?  Seems peculiar.

Please see if we can avoid the bad multiple-return-statements?

This function evaluates EXT4_I(inode) many times.  I'd suggest that you
look at caching the result of that expression in a local variable, see
if that results in improved code generation on common architectures.

>  static void ext4_da_page_release_reservation(struct page *page,
> Index: linux-2.6.28-rc2/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/ext4/super.c	2008-10-29 13:26:55.000000000 -0700
> +++ linux-2.6.28-rc2/fs/ext4/super.c	2008-10-29 14:00:27.000000000 -0700
> @@ -795,6 +795,9 @@ static struct dquot_operations ext4_quot
>  	.initialize	= ext4_dquot_initialize,
>  	.drop		= ext4_dquot_drop,
>  	.alloc_space	= dquot_alloc_space,
> +	.reserve_space	= dquot_reserve_space,
> +	.claim_space	= dquot_claim_space,
> +	.release_rsv	= dquot_release_reserved_space,
>  	.alloc_inode	= dquot_alloc_inode,
>  	.free_space	= dquot_free_space,
>  	.free_inode	= dquot_free_inode,
> Index: linux-2.6.28-rc2/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/ext4/mballoc.c	2008-10-29 13:26:55.000000000 -0700
> +++ linux-2.6.28-rc2/fs/ext4/mballoc.c	2008-10-30 14:30:39.000000000 -0700
> @@ -2887,9 +2887,11 @@ ext4_mb_mark_diskspace_used(struct ext4_
>  	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
>  		/* release all the reserved blocks if non delalloc */
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
> -	else
> +	else {
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
>  						ac->ac_b_ex.fe_len);
> +		DQUOT_CLAIM_BLOCK(ac->ac_inode, ac->ac_b_ex.fe_len);
> +	}
>  
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,
> @@ -4286,15 +4288,24 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
>  	struct ext4_sb_info *sbi;
>  	struct super_block *sb;
>  	ext4_fsblk_t block = 0;
> -	unsigned long inquota;
> +	unsigned long inquota = 0;
>  	unsigned long reserv_blks = 0;
>  
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
>  
> -	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
> +	/*
> +	 * For delayed allocation, we could skip the ENOSPC and
> +	 * EDQUOT check, as blocks and quotas have been already
> +	 * reserved when data being copied to cache

"when data was copied into pagecache"?

> +	 */
> +	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> +		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
> +	else {
>  		/*
> -		 * With delalloc we already reserved the blocks
> +		 * Without delayed allocation we need to verify
> +		 * there is enough free blocks to do block allocation
> +		 * and under the quota limits

I don't understand the "and under the quota limits" bit.  What is this
referring to?

The comment needs a bit of attention.

>  		 */
>  		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
>  			/* let others to free the space */
> @@ -4306,19 +4317,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
>  			return 0;
>  		}
>  		reserv_blks = ar->len;
> +		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> +			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
> +			ar->len--;
> +		}

What's this doing?  Trying increasingly small quota allocations until
one of them succeeds?  This sounds like a good way to burn up a large
number of cycles.

Isn't there some way we can be smarter about this?  Surely the quota
layer knows exactly how many blocks we can reserve.

> +		if (ar->len == 0) {
> +			*errp = -EDQUOT;
> +			return 0;
> +		}
> +		inquota = ar->len;
>  	}
> -	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> -		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
> -		ar->len--;
> -	}

Oh, it already sucked :)

> -	if (ar->len == 0) {
> -		*errp = -EDQUOT;
> -		return 0;
> -	}
> -	inquota = ar->len;
> -
> -	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> -		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
>  
>  	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
>  	if (!ac) {
> @@ -4380,7 +4388,7 @@ repeat:
>  out2:
>  	kmem_cache_free(ext4_ac_cachep, ac);
>  out1:
> -	if (ar->len < inquota)
> +	if (inquota && ar->len < inquota)
>  		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
>  
>  	return block;
> 
