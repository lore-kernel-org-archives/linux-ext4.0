From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 7/12] handling of 64-bit block numbers in group desc in e2fsprogs
Date: Tue, 12 Jun 2007 04:05:37 -0600
Message-ID: <20070612100537.GN5181@schatzie.adilger.int>
References: <466D7C34.20909@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58314 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXFLKFj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 06:05:39 -0400
Content-Disposition: inline
In-Reply-To: <466D7C34.20909@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:45 +0200, Valerie Clement wrote:
> +#define EXT2_BLOCK_BITMAP(bg)		\
> +	((bg)->bg_block_bitmap + ((__u64)(bg)->bg_block_bitmap_hi << 32))
> +#define EXT2_INODE_BITMAP(bg)		\
> +	((bg)->bg_inode_bitmap + ((__u64)(bg)->bg_inode_bitmap_hi << 32))
> +#define EXT2_INODE_TABLE(bg)		\
> +	((bg)->bg_inode_table  + ((__u64)(bg)->bg_inode_table_hi  << 32))
> +
> +
> +#define EXT2_BLOCK_BITMAP(bg)		(bg)->bg_block_bitmap
> +#define EXT2_INODE_BITMAP(bg)		(bg)->bg_inode_bitmap
> +#define EXT2_INODE_TABLE(bg)		(bg)->bg_inode_table

This patch could go straight into e2fsprogs without compatibility problems
if they were properly conditional upon INCOMPAT_64BIT and s_desc_size.

> @@ -95,6 +95,11 @@ void ext2fs_swap_group_desc(struct ext2_
>  	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
>  	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
>  	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
> +#ifdef _EXT4FS_
> +	gdp->bg_block_bitmap_hi = ext2fs_swab32(gdp->bg_block_bitmap_hi);
> +	gdp->bg_inode_bitmap_hi = ext2fs_swab32(gdp->bg_inode_bitmap_hi);
> +	gdp->bg_inode_table_hi = ext2fs_swab32(gdp->bg_inode_table_hi);
> +#endif

Same comment.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
