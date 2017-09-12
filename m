From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] libext2fs: Prevent allocating inode table from
 already used blocks
Date: Tue, 12 Sep 2017 13:20:29 +0200
Message-ID: <20170912112029.jqkzpjt7hnnh6xu5@rh_laptop>
References: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751289AbdILLUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Sep 2017 07:20:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E30EA4E4C3
        for <linux-ext4@vger.kernel.org>; Tue, 12 Sep 2017 11:20:31 +0000 (UTC)
Received: from rh_laptop (unknown [10.43.17.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65D5E6F9FA
        for <linux-ext4@vger.kernel.org>; Tue, 12 Sep 2017 11:20:31 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 24, 2017 at 03:35:38PM +0200, Lukas Czerner wrote:
> Currently it's possible for ext2fs_allocate_group_table() to place inode
> tables to blocks that are already occupied by different inode table.
> This can be reproduced by resize2fs on the file system where we need to
> move more than one inode table to a different location due to increase
> in group descriptor blocks, inode and block bitmaps.
> 
> Best way I can reproduce this is to create big enough file system with
> huge amount of inodes and without resize_inode
> 
> mke2fs -F -b 1024 -i 1024 -O ^resize_inode -t ext4 /dev/loop0 1024000
> resize2fs /dev/loop0 10240000
> 
> e2fsck -fn /dev/loop0 | less
> e2fsck 1.43.5 (04-Aug-2017)
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> e2fsck: Group descriptors look bad... trying backup blocks...
> e2fsck: The journal superblock is corrupt while checking journal for /dev/loop0
> e2fsck: Cannot proceed with file system check
> Superblock has an invalid journal (inode 8).
> Clear? no
> 
> /dev/loop0: ********** WARNING: Filesystem still has errors **********
> 
> None of the settings are strictly necessary and it can be reproducer in
> various ways. This is just an example of one easy way to reproduce this.
> 
> This bug was introduced with commit fccdbac39454 ("libext2fs: optimize
> ext2fs_allocate_group_table()") and is caused by the fact that wrong
> bitmap is used to mark the blocks as used.
> 
> Fix this by using ext2fs_mark_block_bitmap_range2() in both (flex_bg and
> non flex_bg) cases and handle flex_bg case manually instead of relying
> on ext2fs_block_alloc_stats_range() because there is no way in that
> function to use different bitmap than fs->block_map.

ping

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/alloc_tables.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> index da0b15b..407283f 100644
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> @@ -222,12 +222,32 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>  						bmap, &new_blk);
>  		if (retval)
>  			return retval;
> -		if (flexbg_size)
> -			ext2fs_block_alloc_stats_range(fs, new_blk,
> -				       fs->inode_blocks_per_group, +1);
> -		else
> -			ext2fs_mark_block_bitmap_range2(fs->block_map,
> -					new_blk, fs->inode_blocks_per_group);
> +
> +		ext2fs_mark_block_bitmap_range2(bmap,
> +			new_blk, fs->inode_blocks_per_group);
> +		if (flexbg_size) {
> +			blk64_t num, blk;
> +			num = fs->inode_blocks_per_group;
> +			blk = new_blk;
> +			while (num) {
> +				int gr = ext2fs_group_of_blk2(fs, blk);
> +				last_blk = ext2fs_group_last_block2(fs, gr);
> +				blk64_t n = num;
> +
> +				if (blk + num > last_blk)
> +					n = last_blk - blk + 1;
> +
> +				ext2fs_bg_free_blocks_count_set(fs, gr,
> +					ext2fs_bg_free_blocks_count(fs, gr) -
> +					n/EXT2FS_CLUSTER_RATIO(fs));
> +				ext2fs_bg_flags_clear(fs, gr,
> +					EXT2_BG_BLOCK_UNINIT);
> +				ext2fs_group_desc_csum_set(fs, gr);
> +				ext2fs_free_blocks_count_add(fs->super, -n);
> +				blk += n;
> +				num -= n;
> +			}
> +		}
>  		ext2fs_inode_table_loc_set(fs, group, new_blk);
>  	}
>  	ext2fs_group_desc_csum_set(fs, group);
> -- 
> 2.7.5
> 
