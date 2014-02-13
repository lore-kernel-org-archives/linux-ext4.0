From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/12] libext2fs: add ext2fs_block_alloc_stats_range()
Date: Thu, 13 Feb 2014 13:50:29 -0800
Message-ID: <20140213215029.GG9176@birch.djwong.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27282 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBMVuf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Feb 2014 16:50:35 -0500
Content-Disposition: inline
In-Reply-To: <1390197254-14583-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:54:09AM -0500, Theodore Ts'o wrote:
> This function is more efficient than using ext2fs_block_alloc_stats2()
> for each block in a range.  The efficiencies come from being able to
> set a block range in the block bitmap at once, and from being update
> the block group descriptors once per block group.  Especially now that
> we are checksuming the block group descriptors, and we are using red
> black trees for the allocation bitmaps, these changes can make a huge
> difference in the CPU time used by mke2fs when creating very large
> file systems.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/alloc_stats.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/ext2fs.h      |  2 ++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
> index adec363..7919c09 100644
> --- a/lib/ext2fs/alloc_stats.c
> +++ b/lib/ext2fs/alloc_stats.c
> @@ -106,3 +106,44 @@ void ext2fs_set_block_alloc_stats_callback(ext2_filsys fs,
>  
>  	fs->block_alloc_stats = func;
>  }
> +
> +void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
> +				    blk_t num, int inuse)
> +{
> +#ifndef OMIT_COM_ERR
> +	if (blk + num >= ext2fs_blocks_count(fs->super)) {
> +		com_err("ext2fs_block_alloc_stats_range", 0,
> +			"Illegal block range: %llu (%u) ",
> +			(unsigned long long) blk, num);
> +		return;
> +	}
> +#endif
> +	if (inuse == 0)
> +		return;
> +	if (inuse > 0) {
> +		ext2fs_mark_block_bitmap_range2(fs->block_map, blk, num);
> +		inuse = 1;
> +	} else {
> +		ext2fs_unmark_block_bitmap_range2(fs->block_map, blk, num);
> +		inuse = -1;
> +	}
> +	while (num) {
> +		int group = ext2fs_group_of_blk2(fs, blk);
> +		blk64_t last_blk = ext2fs_group_last_block2(fs, group);
> +		blk_t n = num;
> +
> +		if (blk + num > last_blk)
> +			n = last_blk - blk + 1;
> +
> +		ext2fs_bg_free_blocks_count_set(fs, group,
> +			ext2fs_bg_free_blocks_count(fs, group) -
> +			inuse*n/EXT2FS_CLUSTER_RATIO(fs));
> +		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> +		ext2fs_group_desc_csum_set(fs, group);
> +		ext2fs_free_blocks_count_add(fs->super, -inuse * n);

When I use this function, e2fsck complains:
"Free blocks count wrong (124554823344, counted=771760)."

It looks like "-inuse * n" is an 32bit quantity that isn't correctly
sign-extended to the blk64_t that ext2fs_free_blocks_count_add() requires.
A trivial fix is to change n to blk64_t to force a conversion.

Will send a patch soon.

(gcc 4.6.3, Ubuntu 12.04)

--D

> +		blk += n;
> +		num -= n;
> +	}
> +	ext2fs_mark_super_dirty(fs);
> +	ext2fs_mark_bb_dirty(fs);
> +}
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 1e07f88..47340dd 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -683,6 +683,8 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
>  			       int inuse, int isdir);
>  void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse);
>  void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse);
> +void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
> +				    blk_t num, int inuse);
>  
>  /* alloc_tables.c */
>  extern errcode_t ext2fs_allocate_tables(ext2_filsys fs);
> -- 
> 1.8.5.rc3.362.gdf10213
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
