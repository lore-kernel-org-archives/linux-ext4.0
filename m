From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
 ^resize_inode
Date: Fri, 22 Nov 2013 17:33:36 -0800
Message-ID: <20131123013336.GD10269@birch.djwong.org>
References: <52662BBA.70503@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21675 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab3KWBdp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Nov 2013 20:33:45 -0500
Content-Disposition: inline
In-Reply-To: <52662BBA.70503@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 22, 2013 at 04:39:38PM +0900, Akira Fujita wrote:
> If we create ext4 filesystem without resize_inode feature,
> mke2fs command does not initialize block groups
> which have backup superblock and/or group descriptor block
> (With meta_bg feature, backup superblock and group descriptor block
> are located separately).
> So we have to fix block bitmaps when we run "e2fsck -b superblock device".
> This patch fixes the issue by initializing block bitmaps correctly.
> 
> Steps to reproduce:
> 1. mke2fs -t ext4 -b 4096 -O ^resize_inode device
> 2. e2fsck -b 32768 DEV 
>   <snip>
>   Pass 1: Checking inodes, blocks, and sizes
>   Pass 2: Checking directory structure
>   Pass 3: Checking directory connectivity
>   Pass 4: Checking reference counts
>   Pass 5: Checking group summary information
>   Block bitmap differences:  +(32768--32769) +(98304--98305) +(163840--163841)
>   Fix<y>? 
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  lib/ext2fs/alloc_sb.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
> index 223ec51..5419d0d 100644
> --- a/lib/ext2fs/alloc_sb.c
> +++ b/lib/ext2fs/alloc_sb.c
> @@ -58,23 +58,25 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
>  		old_desc_blocks =
>  			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
>  
> -	if (super_blk || (group == 0))
> +	if (super_blk || (group == 0)) {
> +		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);

I'm not sure I agree with clearing the uninit flag unconditionally.  Consider
the case where bmap != fs->block_map, which happens in mark_table_blocks()
(e2fsck pass1) and ext2fs_check_desc (libext2fs).  In these two cases, the
function will mark superblock and group descriptor blocks in a separate bitmap,
leaving everything under fs alone.  IOW: It doesn't make sense to mess with the
fs' uninit flags if we're not marking the fs' bitmap.

As you point out, however, if we /are/ being called with fs->block_bitmap ==
bmap, then we're probably initializing the fs and it makes sense to clear the
uninit flags.

Maybe something like this, just after the call to ext2fs_super_and_bgd_loc2?

if (fs->block_map == bmap && (new_desc_block || old_desc_block || super_blk))
	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);

<shrug>

I've been wondering for a while -- if we have a FS with meta_bg and
s_first_meta_bg > 0, does that mean we have "old" style group descriptor
layouts up to whatever block group s_first_meta_bg points to?  And why do we
set old_desc_blocks to s_first_meta_bg, since the former is used as a block
length offset for old_desc_blk for block groups beneath s_first_meta_bg?  
Group descriptors aren't the same size as a block.

This all seems kinda moot since the only initialization I can find for
s_first_meta_bg sets it to zero.

<confused>

>  		ext2fs_mark_block_bitmap2(bmap, super_blk);
> +	}
>  	if ((group == 0) && (fs->blocksize == 1024) &&
>  	    EXT2FS_CLUSTER_RATIO(fs) > 1)
>  		ext2fs_mark_block_bitmap2(bmap, 0);
>  
>  	if (old_desc_blk) {
> -		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
> -			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);

Why remove this?

>  		num_blocks = old_desc_blocks;
>  		if (old_desc_blk + num_blocks >= ext2fs_blocks_count(fs->super))
>  			num_blocks = ext2fs_blocks_count(fs->super) -
>  				old_desc_blk;
>  		ext2fs_mark_block_bitmap_range2(bmap, old_desc_blk, num_blocks);
>  	}
> -	if (new_desc_blk)
> +	if (new_desc_blk) {
> +		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);

Same comment here as that first chunk of reply.

--D
>  		ext2fs_mark_block_bitmap2(bmap, new_desc_blk);
> +	}
>  
>  	num_blocks = ext2fs_group_blocks_count(fs, group);
>  	num_blocks -= 2 + fs->inode_blocks_per_group + used_blks;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
