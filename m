From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/12] libext2fs: further clean up and rename
 check_block_uninit
Date: Mon, 20 Jan 2014 12:17:36 -0800
Message-ID: <20140120201736.GN9229@birch.djwong.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATURm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jan 2014 15:17:42 -0500
Content-Disposition: inline
In-Reply-To: <1390197254-14583-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:54:08AM -0500, Theodore Ts'o wrote:
> Commit 8e44eb64bb (libext2fs: mark group data blocks when loading
> block bitmap) simplified check_block_uninit since we are now
> initializing the bitmap when it is loaded from disk.  It left some
> variables which were being set but never used, however.  In addition,
> since we only need check_block_uninit() to clear the block bitmap's
> uninit flag, rename it to clear_block_uninit(), and only call it once
> we have found a free block in ext2fs_new_blocks2().
> 
> This cleans up the code some and optimizes things if we need to search
> multiple block groups trying to find a free block.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>

Looks reasonable, so you can:
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> ---
>  lib/ext2fs/alloc.c | 33 +++++----------------------------
>  1 file changed, 5 insertions(+), 28 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 42096a4..91637dd 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -27,31 +27,15 @@
>  #include "ext2fs.h"
>  
>  /*
> - * Check for uninit block bitmaps and deal with them appropriately
> + * Clear the uninit block bitmap flag if necessary
>   */
> -static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
> -			       dgrp_t group)
> +static void clear_block_uninit(ext2_filsys fs, dgrp_t group)
>  {
> -	blk_t		i;
> -	blk64_t		blk, super_blk, old_desc_blk, new_desc_blk;
> -	int		old_desc_blocks;
> -
>  	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
>  	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
>  		return;
>  
> -	blk = ext2fs_group_first_block2(fs, group);
> -
> -	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
> -				  &old_desc_blk, &new_desc_blk, 0);
> -
> -	if (fs->super->s_feature_incompat &
> -	    EXT2_FEATURE_INCOMPAT_META_BG)
> -		old_desc_blocks = fs->super->s_first_meta_bg;
> -	else
> -		old_desc_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
> -
>  	/* uninit block bitmaps are now initialized in read_bitmaps() */
>  
>  	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> @@ -78,10 +62,11 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
>  		ext2fs_fast_unmark_inode_bitmap2(map, ino);
>  
>  	ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
> +	/* Mimics what the kernel does */
> +	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>  	ext2fs_group_desc_csum_set(fs, group);
>  	ext2fs_mark_ib_dirty(fs);
>  	ext2fs_mark_super_dirty(fs);
> -	check_block_uninit(fs, fs->block_map, group);
>  }
>  
>  /*
> @@ -167,17 +152,9 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
>  	c_ratio = 1 << ext2fs_get_bitmap_granularity(map);
>  	if (c_ratio > 1)
>  		goal &= ~EXT2FS_CLUSTER_MASK(fs);
> -	check_block_uninit(fs, map,
> -			   (i - fs->super->s_first_data_block) /
> -			   EXT2_BLOCKS_PER_GROUP(fs->super));
>  	do {
> -		if (((i - fs->super->s_first_data_block) %
> -		     EXT2_BLOCKS_PER_GROUP(fs->super)) == 0)
> -			check_block_uninit(fs, map,
> -					   (i - fs->super->s_first_data_block) /
> -					   EXT2_BLOCKS_PER_GROUP(fs->super));
> -
>  		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
> +			clear_block_uninit(fs, ext2fs_group_of_blk2(fs, i));
>  			*ret = i;
>  			return 0;
>  		}
> -- 
> 1.8.5.rc3.362.gdf10213
> 
