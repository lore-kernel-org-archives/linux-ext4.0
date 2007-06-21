From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 5/11][take 2] new bitmaps interface in e2fsprogs
Date: Thu, 21 Jun 2007 14:22:08 -0600
Message-ID: <20070621202208.GY5181@schatzie.adilger.int>
References: <467A9772.5040903@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33769 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbXFUUWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 16:22:11 -0400
Content-Disposition: inline
In-Reply-To: <467A9772.5040903@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Note - most of these comments relate to making these changes compatible
with existing e2fsprogs.  I don't object to such patches for the short term
to make 64-bit usable e2fsprogs, but I don't think they should go into the
upstream e2fsprogs.  I wonder if having _EXT4FS_ should force the .so version
to be 2.0 or something, to make it clear if any applications are linking
against it.

On Jun 21, 2007  17:21 +0200, Valerie Clement wrote:
> +struct ext4fs_struct_generic_bitmap {
> +	errcode_t	magic;
> +	ext2_filsys 	fs;
> +	blk64_t		start, end;
> +	blk64_t		real_end;
> +	char	*	description;
> +	char	*	bitmap;
> +	errcode_t	base_error_code;
> +	__u32		reserved[7];
> +};
> +
>  #define EXT2FS_MARK_ERROR 	0
>  #define EXT2FS_UNMARK_ERROR 	1
>  #define EXT2FS_TEST_ERROR	2
>  
> +#ifdef _EXT4FS_
> +typedef struct ext4fs_struct_generic_bitmap *ext2fs_generic_bitmap;
> +typedef struct ext4fs_struct_generic_bitmap *ext2fs_inode_bitmap;
> +typedef struct ext4fs_struct_generic_bitmap *ext2fs_block_bitmap;
> +#else
>  typedef struct ext2fs_struct_generic_bitmap *ext2fs_generic_bitmap;
>  typedef struct ext2fs_struct_generic_bitmap *ext2fs_inode_bitmap;
>  typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
> +#endif

Ideally, it would be good if we could hide the internals of the bitmap
types, layouts, etc from the caller.  Allocating several 2^48 bits
bitmaps for a large filesystem is just not practical, so we may as well
start taking steps toward fixing that.

Instead, we should keep a backward-compatible 32-bit interface to the
bitmaps (using the same ext2fs_struct_generic_bitmap), and then use
the magic to distinguish between 32-bit and 64-bit bitmaps.  This
implies that "#ifdef _EXT4FS_" would not be needed, and everything
can be decided at runtime based on the size of the bitmap.  Callers
using the 32-bit interface could obviously only specify 2^32-bit bitmaps.

It might be initially OK to just keep the "array of bits" interface for
simplicity but at some point in the (likely near) future we will want
to move to an "extent" structure as Ted proposed, having an {offset, count}
list of bits in a tree to manage bitmaps that are nearly full and nearly
empty efficiently.  It might make sense to have real bitmaps for fragmented
parts of the tree where {offset, count} would be less efficient.

> @@ -580,11 +597,19 @@ extern errcode_t ext2fs_write_inode_bitm
> +#ifndef _EXT4FS_
>  extern errcode_t ext2fs_allocate_generic_bitmap(__u32 start,
>  						__u32 end,
>  						__u32 real_end,
>  						const char *descr,
>  						ext2fs_generic_bitmap *ret);
> +#else
> +extern errcode_t ext2fs_allocate_generic_bitmap(blk64_t start,
> +						blk64_t end,
> +						blk64_t real_end,
> +						const char *descr,
> +						ext2fs_generic_bitmap *ret);

This should become ext2fs_allocate_generic_bitmap_64(), and
ext2fs_allocate_generic_bitmap().

> +void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
> +{
> +	/* Protect loop from wrap-around if map->real_end is maxed */
> +	for (i=map->end+1, j = i - map->start; 

Please, spaces around '=' and '+'.

> +#else
> +int ext2fs_set_bit(blk64_t nr,void * addr)
> +{
> +	int		mask, retval;
> +	unsigned char	*ADDR = (unsigned char *) addr;
> +
> +	ADDR += nr >> 3;
> +	mask = 1 << (nr & 0x07);
> +	retval = mask & *ADDR;
> +	*ADDR |= mask;
> +	return retval;
> +}
> +
> +int ext2fs_clear_bit(blk64_t nr, void * addr)
> +{
> +	int		mask, retval;
> +	unsigned char	*ADDR = (unsigned char *) addr;
> +
> +	ADDR += nr >> 3;
> +	mask = 1 << (nr & 0x07);
> +	retval = mask & *ADDR;
> +	*ADDR &= ~mask;
> +	return retval;
> +}
> +
> +int ext2fs_test_bit(blk64_t nr, const void * addr)
> +{
> +	int			mask;
> +	const unsigned char	*ADDR = (const unsigned char *) addr;
> +
> +	ADDR += nr >> 3;
> +	mask = 1 << (nr & 0x07);
> +	return (mask & *ADDR);
> +}
> +#endif

These functions are almost all used only internally, so it should be
acceptable to add ext2fs_test_bit_64(), use that everywhere in e2fsprogs
and leave only the old functions for compatibility.

This percolates up to ext2fs_{mark,unmark,test}_{block,inode}_bitmap(),
via ext2fs_{mark,unmark,test}_generic_bitmap().  Since these interface
with an ext2fs_{block,inode}_bitmap (that presumably has a magic to
determine whether it is 32 bits or 64 bits counts, it should be possible
to leave them as simple compatibility wrappers for applications linking
against e2fsprogs (using ext2fs_*bitmap_64() internallY), and change the
e2fsprogs to use ext2fs_*bitmap_64() internally (though there are a large
number of callsites).

The other issue is that applications which are using the old API but are
actually using these functions against a 64-bit filesystem should fail
gracefully.  For many apps this might never be a problem, since they only
deal with high-level library/filesystem operations.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
