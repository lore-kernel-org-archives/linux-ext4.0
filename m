From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 6/12] handling of 64-bit block counts in e2fsprofs
Date: Tue, 12 Jun 2007 04:02:20 -0600
Message-ID: <20070612100220.GM5181@schatzie.adilger.int>
References: <466D7B83.2010508@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52705 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXFLKCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 06:02:22 -0400
Content-Disposition: inline
In-Reply-To: <466D7B83.2010508@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:42 +0200, Valerie Clement wrote:
> +#ifdef _EXT4FS_
> +#define EXT2_BLOCKS_PER_GROUP(s)	((__u64)EXT2_SB(s)->s_blocks_per_group)
> +#else
>  #define EXT2_BLOCKS_PER_GROUP(s)	(EXT2_SB(s)->s_blocks_per_group)
> +#endif

Are there actually plans for s_blocks_per_group > 2^32?  We can already handle
up to 2^32 groups, so we have plenty of room to spare.

> @@ -573,6 +577,54 @@ struct ext2_super_block {
>  	__u32	s_reserved[167];	/* Padding to the end of the block */
>  };
>  
> +#ifdef _EXT4FS_
> +#define EXT2_BLOCKS_COUNT(s)						\
> +	((s)->s_blocks_count + ((__u64)(s)->s_blocks_count_hi << 32))
> +
> +#define EXT2_BLOCKS_COUNT_SET(s, v)			\
> +	do {						\
> +		(s)->s_blocks_count = (v);		\
> +		(s)->s_blocks_count_hi = (v) >> 32;	\
> +	} while (0)
> +
> +#define EXT2_R_BLOCKS_COUNT(s)						\
> +	((s)->s_r_blocks_count + ((__u64)(s)->s_r_blocks_count_hi << 32))
> +
> +#define EXT2_R_BLOCKS_COUNT_SET(s, v)			\
> +	do {						\
> +		(s)->s_r_blocks_count = (v);		\
> +		(s)->s_r_blocks_count_hi = (v) >> 32;	\
> +	} while (0)
> +
> +#define EXT2_FREE_BLOCKS_COUNT(s)					\
> +	((s)->s_free_blocks_count + ((__u64)(s)->s_free_blocks_hi << 32))
> +
> +#define EXT2_FREE_BLOCKS_COUNT_SET(s, v)		\
> +	do {						\
> +		(s)->s_free_blocks_count = (v);		\
> +		(s)->s_free_blocks_hi = (v) >> 32;	\
> +	} while (0)
> +#else
> +#define EXT2_BLOCKS_COUNT(s)		((s)->s_blocks_count)
> +#define EXT2_R_BLOCKS_COUNT(s)		((s)->s_r_blocks_count)
> +#define EXT2_FREE_BLOCKS_COUNT(s)	((s)->s_free_blocks_count)

I don't think any of this (above or in most/all of the rest of this patch)
should be conditional upon #ifdef _EXT4FS_.  Instead, it should depend on
INCOMPAT_64BIT being set in the superblock.  I don't think it introduces
any compatibility issues by itself.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
