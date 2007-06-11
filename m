From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 1/12] new ext4 group desc struct in e2fsprogs
Date: Mon, 11 Jun 2007 17:21:20 -0600
Message-ID: <20070611232120.GF5181@schatzie.adilger.int>
References: <466D7B60.3050108@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38284 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXFKXVW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 19:21:22 -0400
Content-Disposition: inline
In-Reply-To: <466D7B60.3050108@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:42 +0200, Valerie Clement wrote:
> @@ -213,7 +213,11 @@ struct struct_ext2_filsys {
>  	int				fragsize;
>  	dgrp_t				group_desc_count;
>  	unsigned long			desc_blocks;
> +#ifdef _EXT4FS_
> +	struct ext4_group_desc *	group_desc;
> +#else
>  	struct ext2_group_desc *	group_desc;
> +#endif

The way similar changes were incorporated into e2fsprogs in the past
(e.g. large inode support) is to pass an ext2_group_desc around and
in places where access to the "large" part of the struct are needed
this is typecast and conditional upon the appropriate superblock field
or feature, as it is in the kernel.  This also avoids the need to change
the parameter everywhere.

This is important because even "ext4" filesystems may only have 32-byte
group descriptors if they are formatted as ext3 and upgraded.

For large inodes, this is using "s_inode_size", and for the group
descriptor it should use "s_desc_size" and INCOMPAT_64BIT.

> --- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/swapfs.c	2007-06-08 12:40:04.000000000 +0200
> +++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/swapfs.c	2007-06-08 12:40:21.000000000 +0200
> +#ifdef _EXT4FS_
> +void ext2fs_swap_group_desc(struct ext4_group_desc *gdp)
> +#else
>  void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
> +#endif
>  {
>  	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
>  	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);

This does not swap the new fields in the group descriptor.  Swabbing the
ext4_group_desc fields should also be conditional upon INCOMPAT_64BIT
and s_desc_size > sizeof(struct ext2_group_desc).


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
