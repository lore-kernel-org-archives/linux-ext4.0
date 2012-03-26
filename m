From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Sun, 25 Mar 2012 22:39:07 -0400
Message-ID: <20120326023907.GB16642@thunk.org>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213740.GO6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57797 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab2CZDSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Mar 2012 23:18:34 -0400
Content-Disposition: inline
In-Reply-To: <20120310213740.GO6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 11:37:40PM +0200, Sami Liedes wrote:
> @@ -128,16 +129,27 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
>  		return EXT2_ET_INODE_ALLOC_FAIL;
>  	i = start_inode;
>  	modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
> -
>  	do {
>  		if (modulo == 0)
>  			check_inode_uninit(fs, map, (i - 1) /
>  					   EXT2_INODES_PER_GROUP(fs->super));
>  
> -		if (!ext2fs_fast_test_inode_bitmap2(map, i))
> +		upto = i + (EXT2_INODES_PER_GROUP(fs->super) - modulo);
> +		if (i < start_inode && upto >= start_inode)
> +			upto = start_inode - 1;
> +		if (upto > fs->super->s_inodes_count)
> +			upto = fs->super->s_inodes_count;
> +
> +		err = ext2fs_find_first_zero_inode_bitmap2(map, i, upto, &first_zero);
> +		if (!err) {
> +			i = first_zero;
>  			break;
> -		if (++modulo == EXT2_INODES_PER_GROUP(fs->super))
> -			modulo = 0;
> +		} else {
> +			if (err != ENOENT)
> +				return EXT2_ET_INODE_ALLOC_FAIL;
> +			i = upto;
> +		}
> +
>  		if (++i > fs->super->s_inodes_count) {
>  			i = EXT2_FIRST_INODE(fs->super);
>  			modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);

There a bug in this code.  modulo (which I've renamed to ino_in_group
per Andreas's suggestion) isn't getting updated, and after the first
pass through the loop modulo needs to be zero.  Otherwise the code
will end up spanning group boundaries and check_inode_uninit won't get
called at the right times.

I've fixed this up and applied it, with some changes to make sure
ext2fs_new_inode() is easier to understand, and hence audit for
correctness.  It now looks like this:

errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
			   int mode EXT2FS_ATTR((unused)),
			   ext2fs_inode_bitmap map, ext2_ino_t *ret)
{
	ext2_ino_t	start_inode = 0;
	ext2_ino_t	i, ino_in_group, upto, first_zero;
	errcode_t	retval;
	dgrp_t		group;

	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

	if (!map)
		map = fs->inode_map;
	if (!map)
		return EXT2_ET_NO_INODE_BITMAP;

	if (dir > 0) {
		group = (dir - 1) / EXT2_INODES_PER_GROUP(fs->super);
		start_inode = (group * EXT2_INODES_PER_GROUP(fs->super)) + 1;
	}
	if (start_inode < EXT2_FIRST_INODE(fs->super))
		start_inode = EXT2_FIRST_INODE(fs->super);
	if (start_inode > fs->super->s_inodes_count)
		return EXT2_ET_INODE_ALLOC_FAIL;
	i = start_inode;
	do {
		ino_in_group = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
		group = (i - 1) / EXT2_INODES_PER_GROUP(fs->super);

		check_inode_uninit(fs, map, group);
		upto = i + (EXT2_INODES_PER_GROUP(fs->super) - ino_in_group);
		if (i < start_inode && upto >= start_inode)
			upto = start_inode - 1;
		if (upto > fs->super->s_inodes_count)
			upto = fs->super->s_inodes_count;

		retval = ext2fs_find_first_zero_inode_bitmap2(map, i, upto,
							      &first_zero);
		if (retval == 0) {
			i = first_zero;
			break;
		}
		if (retval != ENOENT)
			return EXT2_ET_INODE_ALLOC_FAIL;
		i = upto + 1;
		if (i > fs->super->s_inodes_count)
			i = EXT2_FIRST_INODE(fs->super);
	} while (i != start_inode);

	if (ext2fs_test_inode_bitmap2(map, i))
		return EXT2_ET_INODE_ALLOC_FAIL;
	*ret = i;
	return 0;
}

					- Ted
