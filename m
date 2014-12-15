From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 29/47] resize2fs: don't mark unallocated bg metadata
 blocks when fixing bg flags
Date: Sun, 14 Dec 2014 21:17:48 -0500
Message-ID: <20141215021748.GE17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215354.883.35283.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55862 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOCRs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 21:17:48 -0500
Content-Disposition: inline
In-Reply-To: <20141107215354.883.35283.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:53:54PM -0800, Darrick J. Wong wrote:
> When fixing up block group bitmaps on the new fs, don't try to mark
> unallocated group metadata blocks; these will be allocated (and
> marked) later.

The commit description doesn't match the diff.  It looks like what you
are doing is adding a check in case ext2fs_{block,inode}_bitmap_loc is
zero (which is not bad, but when can that happen; and if it's
something that _can_ happen, should we be triggering an assert
failure), and using ext2fs_mark_block_bitmap_range2() instead of a for
loop.

Is there a back story to this patch?

Thanks,

						- Ted

> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 94c0643..a760593 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -242,7 +242,6 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
>  {
>  	blk64_t		blk, lblk;
>  	dgrp_t		g;
> -	int		i;
>  
>  	if (!ext2fs_has_group_desc_csum(fs))
>  		return;
> @@ -257,14 +256,16 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
>  						  lblk - blk + 1);
>  
>  		ext2fs_reserve_super_and_bgd(fs, g, fs->block_map);
> -		ext2fs_mark_block_bitmap2(fs->block_map,
> -					  ext2fs_block_bitmap_loc(fs, g));
> -		ext2fs_mark_block_bitmap2(fs->block_map,
> -					  ext2fs_inode_bitmap_loc(fs, g));
> -		for (i = 0, blk = ext2fs_inode_table_loc(fs, g);
> -		     i < (unsigned int) fs->inode_blocks_per_group;
> -		     i++, blk++)
> +		blk = ext2fs_block_bitmap_loc(fs, g);
> +		if (blk)
> +			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> +		blk = ext2fs_inode_bitmap_loc(fs, g);
> +		if (blk)
>  			ext2fs_mark_block_bitmap2(fs->block_map, blk);
> +		blk = ext2fs_inode_table_loc(fs, g);
> +		if (blk)
> +			ext2fs_mark_block_bitmap_range2(fs->block_map, blk,
> +						fs->inode_blocks_per_group);
>  	}
>  }
>  
> 
