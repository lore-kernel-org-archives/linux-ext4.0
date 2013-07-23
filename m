From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/5] ext4: Mark block group as corrupt on block bitmap
 error
Date: Mon, 22 Jul 2013 20:38:33 -0700
Message-ID: <20130723033833.GF5785@blackbox.djwong.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235552.24017.26642.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42228 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3GWDim (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jul 2013 23:38:42 -0400
Content-Disposition: inline
In-Reply-To: <20130719235552.24017.26642.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:55:52PM -0700, Darrick J. Wong wrote:
> When we notice a block-bitmap corruption (because of device failure or
> something else), we should mark this group as corrupt and prevent further block
> allocations/deallocations from it. Currently, we end up generating one error
> message for every block in the bitmap. This potentially could make the system
> unstable as noticed in some bugs. With this patch, the error will be printed
> only the first time and mark the entire block group as corrupted. This prevents
> future access allocations/deallocations from it.
> 
> Also tested by corrupting the block
> bitmap and forcefully introducing the mb_free_blocks error:
> (1) create a largefile (2Gb)
> $ dd if=/dev/zero of=largefile oflag=direct bs=10485760 count=200
> (2) umount filesystem. use dumpe2fs to see which block-bitmaps
> are in use by largefile and note their block numbers
> (3) use dd to zero-out the used block bitmaps
> $ dd if=/dev/zero of=/dev/hdc4 bs=4096 seek=14 count=8 oflag=direct
> (4) mount the FS and delete the largefile.
> (5) recreate the largefile. verify that the new largefile does not
> get any blocks from the groups marked as bad.
> Without the patch, we will see mb_free_blocks error for each bit in
> each zero'ed out bitmap at (4). With the patch, we only see the error
> once per blockgroup:
> [  309.706803] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 15: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> [  309.720824] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 14: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> [  309.732858] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
> [  309.748321] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 13: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> [  309.760331] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
> [  309.769695] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 12: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> [  309.781721] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
> [  309.798166] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 11: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> [  309.810184] EXT4-fs error (device sdb4) in ext4_free_blocks:4802: IO failure
> [  309.819532] EXT4-fs error (device sdb4): ext4_mb_generate_buddy:735: group 10: 32768 clusters in bitmap, 0 in gd. blk grp corrupted.
> 
> Google-Bug-Id: 7258357

Hmm.  I think we need to have ext4_count_free_clusters() act as though corrupt
block groups have "zero" free blocks so that mballoc will pass the -ENOSPC
errors back to the upper layers.  Afaict, if one doesn't do this, ext4
encounters the situation where marking the blocks in use fails, yet the fs
thinks there are free blocks still and ... leaves the pages dirty forever,
instead of simply failing.

Just trying this really quickly, if I blast /all/ the block groups, I see
unstoppable errors in dmesg.

The other thing I noticed is that if one turns delalloc mode on, performs a
live corruption of the bg descriptors, and then dd's a big file to the fs,
there's no error reported back to userspace either in write(), sync(), or even
umount().  Meanwhile, dmesg is getting hit with tons of corrupted-bitmap
errors.

More for me to ponder....

--D

> [darrick.wong@oracle.com]
> Further modifications (by Darrick) to make more obvious that this corruption
> bit applies to blocks only.  Set the corruption flag if the block group bitmap
> verification fails.
> 
> Original-author: Aditya Kali <adityakali@google.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/balloc.c  |    3 +++
>  fs/ext4/ext4.h    |    3 +++
>  fs/ext4/mballoc.c |   28 +++++++++++++++++++++++++---
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 735e701..b4c406b 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -356,6 +356,7 @@ void ext4_validate_block_bitmap(struct super_block *sb,
>  			       struct buffer_head *bh)
>  {
>  	ext4_fsblk_t	blk;
> +	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
>  
>  	if (buffer_verified(bh))
>  		return;
> @@ -366,12 +367,14 @@ void ext4_validate_block_bitmap(struct super_block *sb,
>  		ext4_unlock_group(sb, block_group);
>  		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
>  			   block_group, blk);
> +		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>  		return;
>  	}
>  	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
>  			desc, bh))) {
>  		ext4_unlock_group(sb, block_group);
>  		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
> +		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>  		return;
>  	}
>  	set_buffer_verified(bh);
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 39d24e2..45cc955 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2448,9 +2448,12 @@ struct ext4_group_info {
>  
>  #define EXT4_GROUP_INFO_NEED_INIT_BIT		0
>  #define EXT4_GROUP_INFO_WAS_TRIMMED_BIT		1
> +#define EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT	2
>  
>  #define EXT4_MB_GRP_NEED_INIT(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
> +#define EXT4_MB_GRP_BBITMAP_CORRUPT(grp)	\
> +	(test_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &((grp)->bb_state)))
>  
>  #define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
>  	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4bbbf13b..40ebcf6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -751,13 +751,15 @@ void ext4_mb_generate_buddy(struct super_block *sb,
>  
>  	if (free != grp->bb_free) {
>  		ext4_grp_locked_error(sb, group, 0, 0,
> -				      "%u clusters in bitmap, %u in gd",
> +				      "%u clusters in bitmap, %u in gd; "
> +				      "block bitmap corrupt.",
>  				      free, grp->bb_free);
>  		/*
> -		 * If we intent to continue, we consider group descritor
> +		 * If we intend to continue, we consider group descriptor
>  		 * corrupt and update bb_free using bitmap value
>  		 */
>  		grp->bb_free = free;
> +		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
>  	}
>  	mb_set_largest_free_order(sb, grp);
>  
> @@ -1398,6 +1400,10 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>  
>  	BUG_ON(last >= (sb->s_blocksize << 3));
>  	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
> +	/* Don't bother if the block group is corrupt. */
> +	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
> +		return;
> +
>  	mb_check_buddy(e4b);
>  	mb_free_blocks_double(inode, e4b, first, count);
>  
> @@ -1423,7 +1429,11 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
>  				      inode ? inode->i_ino : 0,
>  				      blocknr,
>  				      "freeing already freed block "
> -				      "(bit %u)", block);
> +				      "(bit %u); block bitmap corrupt.",
> +				      block);
> +		/* Mark the block group as corrupt. */
> +		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
> +			&e4b->bd_info->bb_state);
>  		mb_regenerate_buddy(e4b);
>  		goto done;
>  	}
> @@ -1790,6 +1800,11 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
>  	if (err)
>  		return err;
>  
> +	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
> +		ext4_mb_unload_buddy(e4b);
> +		return 0;
> +	}
> +
>  	ext4_lock_group(ac->ac_sb, group);
>  	max = mb_find_extent(e4b, ac->ac_g_ex.fe_start,
>  			     ac->ac_g_ex.fe_len, &ex);
> @@ -1987,6 +2002,9 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
>  	if (cr <= 2 && free < ac->ac_g_ex.fe_len)
>  		return 0;
>  
> +	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
> +		return 0;
> +
>  	/* We only do this if the grp has never been initialized */
>  	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
>  		int ret = ext4_mb_init_group(ac->ac_sb, group);
> @@ -4673,6 +4691,10 @@ do_more:
>  	overflow = 0;
>  	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
>  
> +	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(
> +			ext4_get_group_info(sb, block_group))))
> +		return;
> +
>  	/*
>  	 * Check to see if we are freeing blocks across a group
>  	 * boundary.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
