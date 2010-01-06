From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH -v2 2/2] ext4: Calculate metadata requirements more
 accurately
Date: Wed, 06 Jan 2010 11:27:25 -0800
Message-ID: <1262806045.17552.14.camel@mingming-laptop>
References: <1262331960-22503-1-git-send-email-tytso@mit.edu>
	 <1262331960-22503-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58211 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab0AFT1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 14:27:45 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o06JObPN026373
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:24:37 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o06JRRrF075344
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:27:28 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o06JRRPM001978
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 12:27:27 -0700
In-Reply-To: <1262331960-22503-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-01-01 at 02:46 -0500, Theodore Ts'o wrote:
> In the past, ext4_calc_metadata_amount(), and its sub-functions
> ext4_ext_calc_metadata_amount() and ext4_indirect_calc_metadata_amount()
> badly over-estimated the number of metadata blocks that might be
> required for delayed allocation blocks.  This didn't matter as much
> when functions which managed the reserved metadata blocks were more
> aggressive about dropping reserved metadata blocks as delayed
> allocation blocks were written, but unfortunately they were too
> aggressive.  This was fixed in commit 0637c6f, but as a result the
> over-estimation by ext4_calc_metadata_amount() would lead to reserving
> 2-3 times the number of pending delayed allocation blocks as
> potentially required metadata blocks.  So if there are 1 megabytes of
> blocks which have been not yet been allocation, up to 3 megabytes of
> space would get reserved out of the user's quota and from the file
> system free space pool until all of the inode's data blocks have been
> allocated.
> 
> This commit addresses this problem by much more accurately estimating
> the number of metadata blocks that will be required.  It will still
> somewhat over-estimate the number of blocks needed, since it must make
> a worst case estimate not knowing which physical blocks will be
> needed, but it is much more accurate than before.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

It's nice to have this part cleaned, passing the logical file offset and
saving the last logical file offset helped to get idea how whether we
will need new index block.
a few comments below...

> ---
>  fs/ext4/ext4.h         |    2 +
>  fs/ext4/ext4_extents.h |    3 +-
>  fs/ext4/extents.c      |   49 ++++++++++++++++++++++++-------------
>  fs/ext4/inode.c        |   62 +++++++++++++++++++++++++++--------------------
>  fs/ext4/super.c        |    1 +
>  5 files changed, 73 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56f9271..af7b626 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -699,6 +699,8 @@ struct ext4_inode_info {
>  	unsigned int i_reserved_meta_blocks;
>  	unsigned int i_allocated_meta_blocks;
>  	unsigned short i_delalloc_reserved_flag;
> +	sector_t i_da_metadata_calc_last_lblock;

There is a daya type for ext4 file logical offset, ext4_lblk_t

> +	int i_da_metadata_calc_len;
> 
>  	/* on-disk additional length */
>  	__u16 i_extra_isize;
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index 2ca6864..bdb6ce7 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -225,7 +225,8 @@ static inline void ext4_ext_mark_initialized(struct ext4_extent *ext)
>  	ext->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ext));
>  }
> 
> -extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
> +extern int ext4_ext_calc_metadata_amount(struct inode *inode,
> +					 sector_t lblocks);
>  extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
>  extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
>  extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91ae460..7d7b74e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -296,29 +296,44 @@ static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
>   * to allocate @blocks
>   * Worse case is one block per extent
>   */
> -int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks)
> +int ext4_ext_calc_metadata_amount(struct inode *inode, sector_t lblock)

The blocks argument there initially is attempt to calculate how many
metadata need to reserve for a number of contiguous blocks together.
However even with delayed allocation, the reservation is still called
one block at a time. So yeah, blocks is always 1 when it called to
reserved the space for metadata.

ext4_ext_calc_metadata_amount() used to be called after blocks are
really allocated, to evaluate how many metadata blocks are really need
to reserved still, in the hope to release the over-booked metadata. that
was another of reason why this function consider the number of blocks...
But it seems the current kernel dropped this re-evaluation, simply just
update the reserved metadata from what is actually being allocated. 
>  {
> -	int lcap, icap, rcap, leafs, idxs, num;
> -	int newextents = blocks;
> -
> -	rcap = ext4_ext_space_root_idx(inode, 0);
> -	lcap = ext4_ext_space_block(inode, 0);
> -	icap = ext4_ext_space_block_idx(inode, 0);
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	int idxs, num = 0;
> 
> -	/* number of new leaf blocks needed */
> -	num = leafs = (newextents + lcap - 1) / lcap;
> +	idxs = ((inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
> +		/ sizeof(struct ext4_extent_idx));
> 
>  	/*
> -	 * Worse case, we need separate index block(s)
> -	 * to link all new leaf blocks
> +	 * If the new delayed allocation block is contiguous with the
> +	 * previous da block, it can share index blocks with the
> +	 * previous block, so we only need to allocate a new index
> +	 * block every idxs leaf blocks.  At ldxs**2 blocks, we need
> +	 * an additional index block, and at ldxs**3 blocks, yet
> +	 * another index blocks.
>  	 */
> -	idxs = (leafs + icap - 1) / icap;
> -	do {
> -		num += idxs;
> -		idxs = (idxs + icap - 1) / icap;
> -	} while (idxs > rcap);
> +	if (ei->i_da_metadata_calc_len &&
> +	    ei->i_da_metadata_calc_last_lblock+1 == lblock) {
> +		if ((ei->i_da_metadata_calc_len % idxs) == 0)
> +			num++;
> +		if ((ei->i_da_metadata_calc_len % (idxs*idxs)) == 0)
> +			num++;
> +		if ((ei->i_da_metadata_calc_len % (idxs*idxs*idxs)) == 0) {
> +			num++;
> +			ei->i_da_metadata_calc_len = 0;
> +		} else
> +			ei->i_da_metadata_calc_len++;
> +		ei->i_da_metadata_calc_last_lblock++;
> +		return num;
> +	}
> 
> -	return num;
> +	/*
> +	 * In the worst case we need a new set of index blocks at
> +	 * every level of the inode's extent tree.
> +	 */
> +	ei->i_da_metadata_calc_len = 1;
> +	ei->i_da_metadata_calc_last_lblock = lblock;
> +	return ext_depth(inode) + 1;

Maybe some optimize could done here for the case the depth was 0 and
inode body still have room to add new extent without growing the tree. 


But how about the worse case where two threads writing to different
logical offset of the same file at the same time? that will result in
double booking the metadata and overcommit the metadata blocks crazely.

>  }
> 
>  static int
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bdaa92a..c818972 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1009,38 +1009,44 @@ qsize_t *ext4_get_reserved_space(struct inode *inode)
>  	return &EXT4_I(inode)->i_reserved_quota;
>  }
>  #endif
> +
>  /*
>   * Calculate the number of metadata blocks need to reserve
> - * to allocate @blocks for non extent file based file
> + * to allocate a new block at @lblocks for non extent file based file
>   */
> -static int ext4_indirect_calc_metadata_amount(struct inode *inode, int blocks)
> +static int ext4_indirect_calc_metadata_amount(struct inode *inode,
> +					      sector_t lblock)
>  {
> -	int icap = EXT4_ADDR_PER_BLOCK(inode->i_sb);
> -	int ind_blks, dind_blks, tind_blks;
> -
> -	/* number of new indirect blocks needed */
> -	ind_blks = (blocks + icap - 1) / icap;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	int dind_mask = EXT4_ADDR_PER_BLOCK(inode->i_sb) - 1;
> +	int blk_bits;
> 
> -	dind_blks = (ind_blks + icap - 1) / icap;
> +	if (lblock < EXT4_NDIR_BLOCKS)
> +		return 0;
> 
> -	tind_blks = 1;
> +	lblock -= EXT4_NDIR_BLOCKS;
> 
> -	return ind_blks + dind_blks + tind_blks;
> +	if (ei->i_da_metadata_calc_len &&
> +	    (lblock & dind_mask) == ei->i_da_metadata_calc_last_lblock) {
> +		ei->i_da_metadata_calc_len++;
> +		return 0;
> +	}
> +	ei->i_da_metadata_calc_last_lblock = lblock & dind_mask;
> +	ei->i_da_metadata_calc_len = 1;
> +	blk_bits = roundup_pow_of_two(lblock + 1);
> +	return (blk_bits / EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb)) + 1;
>  }
> 
>  /*
>   * Calculate the number of metadata blocks need to reserve
> - * to allocate given number of blocks
> + * to allocate a block located at @lblock
>   */
> -static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
> +static int ext4_calc_metadata_amount(struct inode *inode, sector_t lblock)
>  {
> -	if (!blocks)
> -		return 0;
> -
>  	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> -		return ext4_ext_calc_metadata_amount(inode, blocks);
> +		return ext4_ext_calc_metadata_amount(inode, lblock);
> 
> -	return ext4_indirect_calc_metadata_amount(inode, blocks);
> +	return ext4_indirect_calc_metadata_amount(inode, lblock);
>  }
> 
>  /*
> @@ -1078,6 +1084,7 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  		 */
>  		mdb_free = ei->i_reserved_meta_blocks;
>  		ei->i_reserved_meta_blocks = 0;
> +		ei->i_da_metadata_calc_len = 0;
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
>  	}
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> @@ -1802,12 +1809,15 @@ static int ext4_journalled_write_end(struct file *file,
>  	return ret ? ret : copied;
>  }
> 
> -static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
> +/*
> + * Reserve a single block located at lblock
> + */
> +static int ext4_da_reserve_space(struct inode *inode, sector_t lblock)
>  {
>  	int retries = 0;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	unsigned long md_needed, md_reserved, total = 0;
> +	unsigned long md_needed, md_reserved;
> 
>  	/*
>  	 * recalculate the amount of metadata blocks to reserve
> @@ -1817,8 +1827,7 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
>  repeat:
>  	spin_lock(&ei->i_block_reservation_lock);
>  	md_reserved = ei->i_reserved_meta_blocks;
> -	md_needed = ext4_calc_metadata_amount(inode, nrblocks);
> -	total = md_needed + nrblocks;
> +	md_needed = ext4_calc_metadata_amount(inode, lblock);
>  	spin_unlock(&ei->i_block_reservation_lock);
> 
>  	/*
> @@ -1826,7 +1835,7 @@ repeat:
>  	 * later. Real quota accounting is done at pages writeout
>  	 * time.
>  	 */
> -	if (vfs_dq_reserve_block(inode, total)) {
> +	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
>  		/* 
>  		 * We tend to badly over-estimate the amount of
>  		 * metadata blocks which are needed, so if we have
> @@ -1838,8 +1847,8 @@ repeat:
>  		return -EDQUOT;
>  	}
> 
> -	if (ext4_claim_free_blocks(sbi, total)) {
> -		vfs_dq_release_reservation_block(inode, total);
> +	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
> +		vfs_dq_release_reservation_block(inode, md_needed + 1);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  		retry:
>  			if (md_reserved)
> @@ -1850,7 +1859,7 @@ repeat:
>  		return -ENOSPC;
>  	}
>  	spin_lock(&ei->i_block_reservation_lock);
> -	ei->i_reserved_data_blocks += nrblocks;
> +	ei->i_reserved_data_blocks++;
>  	ei->i_reserved_meta_blocks += md_needed;
>  	spin_unlock(&ei->i_block_reservation_lock);
> 
> @@ -1891,6 +1900,7 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
>  		 */
>  		to_free += ei->i_reserved_meta_blocks;
>  		ei->i_reserved_meta_blocks = 0;
> +		ei->i_da_metadata_calc_len = 0;
>  	}
> 
>  	/* update fs dirty blocks counter */
> @@ -2504,7 +2514,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		 * XXX: __block_prepare_write() unmaps passed block,
>  		 * is it OK?
>  		 */
> -		ret = ext4_da_reserve_space(inode, 1);
> +		ret = ext4_da_reserve_space(inode, iblock);
>  		if (ret)
>  			/* not enough space to reserve */
>  			return ret;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7cccb35..735c20d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -702,6 +702,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ei->i_reserved_data_blocks = 0;
>  	ei->i_reserved_meta_blocks = 0;
>  	ei->i_allocated_meta_blocks = 0;
> +	ei->i_da_metadata_calc_len = 0;
>  	ei->i_delalloc_reserved_flag = 0;
>  	spin_lock_init(&(ei->i_block_reservation_lock));
>  #ifdef CONFIG_QUOTA


