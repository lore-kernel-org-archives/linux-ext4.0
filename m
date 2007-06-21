From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 10/11][take 2] convert blk_t to 64-bit for ext4 FS in e2fsprogs
Date: Thu, 21 Jun 2007 15:27:54 -0600
Message-ID: <20070621212754.GC5181@schatzie.adilger.int>
References: <467A9C5F.3080004@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:48228 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbXFUV15 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 17:27:57 -0400
Content-Disposition: inline
In-Reply-To: <467A9C5F.3080004@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:42 +0200, Valerie Clement wrote:
> @@ -1273,6 +1273,17 @@ static void PRS(int argc, char *argv[])
> +			if (dev_size > ((unsigned) 1 << 31) &&
> +				fs_param.s_feature_incompat |=
> +					EXT4_FEATURE_INCOMPAT_64BIT;
> +				fs_param.s_desc_size =
> +					EXT2_MIN_DESC_SIZE_64BIT;

This should also set EXT4_FEATURE_INCOMPAT_EXTENTS, as that is required
for 64-bit filesystems.

> -	if (!force && EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
> +	if (!force && (fs_param.s_desc_size < EXT2_MIN_DESC_SIZE_64BIT)
> +		&& EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
>  		com_err(program_name, 0,
>  			_("Filesystem too large.  No more than 2**31-1 blocks\n"
>  			  "\t (8TB using a blocksize of 4k) are currently supported."));

Ah, is this where you got the (1 << 31) limit from?  I thought Eric fixed
ext2/ext3 to handle 2^32 - 1 block filesystems, but since there are a large
number of bugs for > 8TB filesystems I don't object to forcing INCOMPAT_64BIT
for larger ones.

> @@ -73,7 +73,12 @@ extern "C" {
> +#ifdef _EXT4FS_
> +#define _EXT2_64BIT_BLK_T	1
> +typedef __u64		blk_t;
> +#else
>  typedef __u32		blk_t;
> +#endif

This should force the library .so version to be different, so that we
don't have applications suddenly failing when the ABI changes.

> @@ -1263,7 +1270,7 @@ _INLINE_ int ext2fs_group_of_ino(ext2_fi
>  _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
>  {
>  	return fs->super->s_first_data_block +
> +		(group * (blk_t) EXT2_BLOCKS_PER_GROUP(fs->super));

The (blk_t) cast should be handled inside the macro to avoid subtle errors.
I suspect it already has to do this, or it wouldn't be able to return a
large enough value for a 64-bit filesystem?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
