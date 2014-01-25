From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] [RFC] mke2fs: handle flex_bg collision with backup descriptors
Date: Fri, 24 Jan 2014 23:01:41 -0700
Message-ID: <F504F1BE-6288-4A70-9CAC-397FC8A3ACB0@dilger.ca>
References: <1390614277-31219-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50355 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaAYGBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jan 2014 01:01:42 -0500
Received: by mail-pd0-f181.google.com with SMTP id y10so3882312pdj.40
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 22:01:42 -0800 (PST)
In-Reply-To: <1390614277-31219-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note that this patch isn't solving the whole problem - I was in a bit of a rush writing the commit comment and pushing it out. 

There still is an issue in that the inode bitmap and inode table staring offset do not take the backup superblock and group descriptors into account, and as a result (when creating with -G 131072 at least) it overlaps three backups of 2049 blocks, and then collides with the next set of flexbg metadata blocks at the end. 

It is still a major improvement over the old code - only the last 4099 groups overlap in a 16TB filesystem instead of the last 124k groups as without it. I put RFC on it in case there is some easy way to fix this that should go into the patch. Otherwise, it would be ok to land. 

The current patch would work as expected with sparse_super2 if it put the first backup in group #9, since the bitmaps would exactly fill the first 8 groups, and the inode table would fill the next 32 or so (depending on what inode ratio was used). 

Cheers, Andreas

> On Jan 24, 2014, at 18:44, Andreas Dilger <adilger@dilger.ca> wrote:
> 
> If the flex_bg allocator is laying out block or inode bitmaps or
> inode tables, and collides with previously allocated metadata (for
> example the backup superblock or group descriptors) don't reset
> the allocator to the beginning of the flex_bg, but rather skip the
> intervening blocks if there aren't too many of them.
> 
> Otherwise, if a large flex_bg factor is specified (e.g. 131072) the
> inode table will hit the backup descriptors in groups 1, 3, 5, 7, 9
> and start interleaving with the block and inode bitmaps.  That ends
> up producing poorly allocated bitmaps and inode tables that are
> interleaved and not contiguous as was intended for flex_bg.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
> lib/ext2fs/alloc_tables.c |   17 ++++++++++++-----
> 1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> index 9f3d4e0..6b4392a 100644
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> @@ -47,16 +47,17 @@ static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
>    flexbg = group / flexbg_size;
>    size = rem_grp * elem_size;
> 
> -    if (size > (int) (fs->super->s_blocks_per_group / 8))
> -        size = (int) fs->super->s_blocks_per_group / 8;
> +    if (size > (int) (fs->super->s_blocks_per_group / 4))
> +        size = (int) fs->super->s_blocks_per_group / 4;
> 
>    /*
>     * Don't do a long search if the previous block
>     * search is still valid.
>     */
> -    if (start_blk && ext2fs_test_block_bitmap_range2(bmap, start_blk,
> -                             elem_size))
> -        return start_blk;
> +    if (start_blk && ext2fs_get_free_blocks2(fs, start_blk,
> +                         start_blk + size, elem_size,
> +                         bmap, &first_free) == 0)
> +        return first_free;
> 
>    start_blk = ext2fs_group_first_block2(fs, flexbg_size * flexbg);
>    last_grp = group | (flexbg_size - 1);
> @@ -126,6 +127,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> 
>        if (group % flexbg_size)
>            prev_block = ext2fs_block_bitmap_loc(fs, group - 1) + 1;
> +        /* FIXME: Take backup group descriptor blocks into account
> +         * if the flexbg allocations will grow to overlap them... */
>        start_blk = flexbg_offset(fs, group, prev_block, bmap,
>                      rem_grps, 1);
>        last_blk = ext2fs_group_last_block2(fs, last_grp);
> @@ -157,6 +160,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>        else
>            prev_block = ext2fs_block_bitmap_loc(fs, group) +
>                flexbg_size;
> +        /* FIXME: Take backup group descriptor blocks into account
> +         * if the flexbg allocations will grow to overlap them... */
>        start_blk = flexbg_offset(fs, group, prev_block, bmap,
>                      rem_grps, 1);
>        last_blk = ext2fs_group_last_block2(fs, last_grp);
> @@ -194,6 +199,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>            prev_block = ext2fs_inode_bitmap_loc(fs, group) +
>                flexbg_size;
> 
> +        /* FIXME: Take backup group descriptor blocks into account
> +         * if the flexbg allocations will grow to overlap them... */
>        group_blk = flexbg_offset(fs, group, prev_block, bmap,
>                      rem_grps, fs->inode_blocks_per_group);
>        last_blk = ext2fs_group_last_block2(fs, last_grp);
> -- 
> 1.7.3.4
> 
