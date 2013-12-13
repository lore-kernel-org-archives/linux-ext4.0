From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 36/74] libext2fs: detect
Date: Thu, 12 Dec 2013 23:39:38 -0500
Message-ID: <20131213043938.GF23888@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012220.30655.26226.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39581 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3LMEjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 23:39:40 -0500
Content-Disposition: inline
In-Reply-To: <20131211012220.30655.26226.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like the subject line for this commit was truncated --- I
could try to make something up, but could you suggest something?

Thanks!!

				- Ted


On Tue, Dec 10, 2013 at 05:22:20PM -0800, Darrick J. Wong wrote:
> If ext2fs_descriptor_block_loc2() is called with a meta_bg filesystem
> and group_block is not the normal value, the function will return the
> location of the backup group descriptor block in the next block group.
> Unfortunately, it fails to account for the possibility that the backup
> group contains a backup superblock but the regular superblock does
> not.  This is the case with block groups 48-49 on a meta_bg fs with 1k
> blocks; in this case, libext2fs will fail to open the filesystem.
> 
> Therefore, teach the function to adjust for superblocks in the backup
> group, if necessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/openfs.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index b2a8abb..92d9e40 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -47,7 +47,7 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
>  	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
>  	if (ext2fs_bg_has_super(fs, bg))
>  		has_super = 1;
> -	ret_blk = ext2fs_group_first_block2(fs, bg) + has_super;
> +	ret_blk = ext2fs_group_first_block2(fs, bg);
>  	/*
>  	 * If group_block is not the normal value, we're trying to use
>  	 * the backup group descriptors and superblock --- so use the
> @@ -57,10 +57,21 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
>  	 * have the infrastructure in place to do that.
>  	 */
>  	if (group_block != fs->super->s_first_data_block &&
> -	    ((ret_blk + fs->super->s_blocks_per_group) <
> -	     ext2fs_blocks_count(fs->super)))
> +	    ((ret_blk + has_super + fs->super->s_blocks_per_group) <
> +	     ext2fs_blocks_count(fs->super))) {
>  		ret_blk += fs->super->s_blocks_per_group;
> -	return ret_blk;
> +
> +		/*
> +		 * If we're going to jump forward a block group, make sure
> +		 * that we adjust has_super to account for the next group's
> +		 * backup superblock (or lack thereof).
> +		 */
> +		if (ext2fs_bg_has_super(fs, bg + 1))
> +			has_super = 1;
> +		else
> +			has_super = 0;
> +	}
> +	return ret_blk + has_super;
>  }
>  
>  blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
> 
