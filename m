From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 7/11][take 2] handling of 64-bit block numbers in group desc in e2fsprogs
Date: Thu, 21 Jun 2007 15:07:07 -0600
Message-ID: <20070621210707.GA5181@schatzie.adilger.int>
References: <467A9977.3050400@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36157 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbXFUVHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 17:07:09 -0400
Content-Disposition: inline
In-Reply-To: <467A9977.3050400@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:29 +0200, Valerie Clement wrote:
> @@ -91,6 +92,12 @@ void ext2fs_swap_group_desc(struct ext2_
>  	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
>  	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
>  	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
> +	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT) &&
> +			sb->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
> +		gdp->bg_block_bitmap_hi = ext2fs_swab32(gdp->bg_block_bitmap_hi);
> +		gdp->bg_inode_bitmap_hi = ext2fs_swab32(gdp->bg_inode_bitmap_hi);
> +		gdp->bg_inode_table_hi = ext2fs_swab32(gdp->bg_inode_table_hi);
> +	}

You could also use "if (EXT2_DESC_SIZE(sb) > EXT2_MIN_DESC_SIZE)" to be
cleaner.

> @@ -367,8 +369,13 @@ retry:
> +		if (EXT2_HAS_INCOMPAT_FEATURE(old_fs->super,
> +					EXT4_FEATURE_INCOMPAT_64BIT) &&
> +				old_fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
> +			memset(gdp, 0, sizeof(struct ext4_group_desc));
> +		else
> +			memset(gdp, 0, sizeof(struct ext2_group_desc));

Use "memset(gdp, 0, EXT2_DESC_SIZE(sb))"

> +extern blk_t ext2_block_bitmap(ext2_filsys fs, dgrp_t group);
> +extern blk_t ext2_inode_bitmap(ext2_filsys fs, dgrp_t group);
> +extern blk_t ext2_inode_table(ext2_filsys fs, dgrp_t group);
> +extern void ext2_block_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk);
> +extern void ext2_inode_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk);
> +extern void ext2_inode_table_set(ext2_filsys fs, dgrp_t group, blk_t blk);
> +extern struct ext4_group_desc *ext2_get_group_desc(ext2_filsys fs,
> +							dgrp_t group);

Since you are adding these functions newly, why use blk_t instead of __u64
or blk64_t?

> +_INLINE_ blk_t ext2_block_bitmap(ext2_filsys fs, dgrp_t group)
> +{
> +	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)
> +	    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {

	if (EXT2_DESC_SIZE(sb) > EXT2_MIN_DESC_SIZE) {

> +		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
> +		return ((blk64_t) gdp->bg_block_bitmap_hi << 32) +
> +			gdp->bg_block_bitmap;

This can't return a blk64_t value through the blk_t return type.


Also, this cannot work for s_desc_size != sizeof(struct ext4_group_desc).
You need to have a helper macro here which depends only on s_desc_size:

		gdp = (struct ext4_group_desc *)((char *)fs->group_desc +
						  group * EXT2_DESC_SIZE(sb));

> +_INLINE_ blk_t ext2_inode_bitmap(ext2_filsys fs, dgrp_t group)
> +_INLINE_ blk_t ext2_inode_table(ext2_filsys fs, dgrp_t group)
> +_INLINE_ void ext2_block_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk)
> +_INLINE_ void ext2_inode_bitmap_set(ext2_filsys fs, dgrp_t group, blk_t blk)
> +_INLINE_ void ext2_inode_table_set(ext2_filsys fs, dgrp_t group, blk_t blk)
> +_INLINE_ struct ext4_group_desc *ext2_get_group_desc(ext2_filsys fs, dgrp_t group)

Same as above.

These do not need to be typecast.

> @@ -288,9 +289,18 @@ errcode_t ext2fs_open2(const char *name,
>  		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
> +			if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> +						EXT4_FEATURE_INCOMPAT_64BIT)
> +			    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {

	if (EXT2_DESC_SIZE(sb) > EXT2_MIN_DESC_SIZE)

> +				gdpe = (struct ext4_group_desc *) dest;
> +				for (j=0; j < groups_per_block; j++, gdpe++)
> +					ext2fs_swap_group_desc(fs->super, gdpe);
> +			} else {
> +				gdp = (struct ext2_group_desc *) dest;
> +				for (j=0; j < groups_per_block; j++, gdp++)
> +					ext2fs_swap_group_desc(fs->super,
> +						(struct ext4_group_desc *) gdp);
> +			}

In fact, anywhere that uses "sizeof(struct ext4_group_desc)" (including
array indexing or incrementing a pointer to this struct) to walk the
group descriptor table is broken if s_desc_size != 64.  All such places
should be changed to use only EXT2_DESC_SIZE(sb) like:

        for (i=0 ; i < fs->desc_blocks; i++) {
                blk = ext2fs_descriptor_block_loc(fs, group_block, i);
                retval = io_channel_read_blk(fs->io, blk, 1, dest);
                if (retval)
                        goto cleanup;
#ifdef EXT2FS_ENABLE_SWAPFS
                if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
			for (j = 0; j < EXT2_DESC_PER_BLOCK(sb);
			     j++, dest += EXT2_DESC_SIZE(sb)) {
				gdp = (struct ext2_group_desc *)dest;
				ext2fs_swap_group_desc(fs->super, gdp);
			}
                } else
#endif
                dest += fs->blocksize;
        }


or some equivalent that adds EXT2_DESC_SIZE(sb) to dest each loop
This will work regardless of the descriptor size.  I think this can be
limited to a few places because of your changes to use accessor macros
everywhere.

> @@ -234,10 +234,18 @@ errcode_t ext2fs_flush(ext2_filsys fs)
> +		for (j=0; j < fs->group_desc_count; j++) {
> +			if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> +						EXT4_FEATURE_INCOMPAT_64BIT)
> +			    && fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
> +				s = (struct ext4_group_desc *) (fs->group_desc) + j;
> +				t = (struct ext4_group_desc *) (group_shadow) + j;
> +				*t = *s;
> +			} else {
> +				*(group_shadow +j) = *(fs->group_desc + j);
> +				t = (struct ext4_group_desc *) (group_shadow +j);
> +			}
> +			ext2fs_swap_group_desc(fs->super, t);

Same as above.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
