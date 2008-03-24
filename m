From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
	FLEX_BG v2
Date: Mon, 24 Mar 2008 09:46:50 -0400
Message-ID: <20080324134650.GA13621@mit.edu>
References: <20080213204750.5666a560@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47507 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591AbYCXNqz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 09:46:55 -0400
Content-Disposition: inline
In-Reply-To: <20080213204750.5666a560@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm starting to audit this patch, and have a bunch of questions and
observations.

On Wed, Feb 13, 2008 at 08:47:50PM -0600, Jose R. Santos wrote:
> +void ext2fs_bgd_set_flex_meta_flag(ext2_filsys fs, blk_t block)
> +{
> +	dgrp_t	group;
> +
> +	group = ext2fs_group_of_blk(fs, block);
> +	if (!(fs->group_desc[group].bg_flags & EXT2_BG_FLEX_METADATA))
> +		fs->group_desc[group].bg_flags |= EXT2_BG_FLEX_METADATA;
> +}

This function is used nowhere else but in lib/ext2fs/alloc_tables.c,
and it's not declared in lib/ext2fs/ext2fs.h.  So I've renamed it to
bgd_set_flex_meta_flag() and declared it static, to make it clear that
it's a private function.

The other question which immediately comes to mind is *why* we need to
set this flag in the first place.  The kernel doesn't use it, and
there doesn't seem to be any reason why needs to be an on-disk flag at
all.  It seems to be used as a way of communicating to mke2fs about
whether or not we can safely set the EXT2_BG_BLOCK_UNINIT flag.  

This turns out to be a kludge whose short comings show other problems.
The real problem is that most of the libext2fs isn't BLOCK_UNINIT
aware.  So for example, if debugfs is used to write a file into the
filesystem, and the block group doesn't have an initialized bitmap,
the Wrong Thing will happen.  More to the point, if you use mke2fs to
a 1k blocksize filesystem, and the journal is bigger than 16 megs, (or
with a 4k blocksize filesystem, if the journal is bigger than 512
megs), you could easily end up allocating the journal into a block
group with BG_BLOCK_UNINIT.  Oops.

This wasn't that much of a big deal since up until now lazy_bg was
only used for debugging really big filesystems, and not much else.  It
was a quick hack for debugging purposes only.  But given that
uninititalized blockgroups are intended for more general use, we have
to make sure all of these corner cases are handled correctly.

Just looking at it quickly, it seems like the right thing to do is
split setup_lazy_bg() into two parts.  The first part sets
EXT2_BG_BLOCK_UNINIT for all block groups, and then we modify the
block allocation functions in lib/ext2fs to clear the BLOCK_UNINIT
flag --- and then later on, we update the bg_free_blocks_count and
s_free_blocks_count for the lazy_bg case.  

This needs more study though, and there is a similar issue, although
not quite so serious about making sure all of libext2fs is
INODE_UNINIT aware.

> +/*
> + * This routine searches for free blocks that can allocate a full
> + * group of bitmaps or inode tables for a flexbg group.  Returns the
> + * block number with a correct offset were the bitmaps and inode
> + * tables can be allocated continously and in order.
> + */
> +blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
> +			   ext2fs_block_bitmap bmap, int offset, int size)

See above comments about no one using this feature but
lib/ext2fs/alloc_tables.c.  Is there reason why this function isn't
declared static?  (And if it is renamed static, better to remove the
ext2fs_ prefix, to make it clear it isn't a globally visible ext2fs
library function.)

> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index a523c8e..83d7cc4 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -56,6 +56,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
>  	unsigned int meta_bg, meta_bg_size;
>  	blk_t	numblocks, old_desc_blocks;
>  	int	has_super;
> +	unsigned int flex_bg_size = 1 << fs->super->s_log_groups_per_flex;
>  
>  	group_block = ext2fs_group_first_block(fs, group);
>  

The function doesn't use this new variable; so it should be just
deleted and removed.

						- Ted
