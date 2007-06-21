From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 8/11][take 2] 48-bit extents in e2fsprogs
Date: Thu, 21 Jun 2007 15:17:32 -0600
Message-ID: <20070621211732.GB5181@schatzie.adilger.int>
References: <467A99EB.7090600@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32931 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbXFUVRf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 17:17:35 -0400
Content-Disposition: inline
In-Reply-To: <467A99EB.7090600@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:31 +0200, Valerie Clement wrote:
> +#define EXT4_EE_START(s, e)						\
> +	((e)->ee_start +						\
> +	(((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&	\
> +	 (EXT2_BLOCKS_COUNT(s) > ((unsigned) 1 << 31)) ?		\
> +	 (__u64)(e)->ee_start_hi << 32 : 0))

Isn't the INCOMPAT_64BIT check already part of EXT2_BLOCKS_COUNT()?
It should be impossible to have the "> (1 << 31)" check be true for
a non-64-bit filesystem in that case.  Also, why check for > (1 << 31)
instead of >= (1 << 32)?

> +#define EXT4_EE_START_SET(s,e,blk)					\
> +	do {								\
> +		(e)->ee_start = (blk);					\
> +		if ((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT \
> +		    && EXT2_BLOCKS_COUNT(s) > ((unsigned) 1 << 31))	\
> +		(e)->ee_start_hi = (__u64)(blk) >> 32;			\

Here you should always set ee_start_hi = 0, so there is no need for
a conditional here.  It is only needed for the read because initial versions
of the extents code didn't clear ee_start_hi, so it deserves making a comment
to that effect above EXT4_EE_START() and EXT4_EI_LEAF().  One day we may
want to remove that hack and assume *_hi == 0 for all filesystems.

> +#define EXT4_EI_LEAF_SET(s,e,blk)					\
> +	do {								\
> +		(ix)->ei_leaf = (blk);					\
> +		if ((s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT \
> +		    && EXT2_BLOCKS_COUNT(s) > ((unsigned) 1 << 31))	\
> +			(ix)->ei_leaf_hi = (__u64)(blk) >> 32;		\
> +	} while(0)

Same as above.

> @@ -1604,6 +1604,10 @@ static int e2fsck_ext_block_verify(struc
>  	e2fsck_t ctx = p->ctx;
>  	struct problem_context *pctx = p->pctx;
>  	int i, problem = 0;
> +	int flag_64bit;
> +
> +	flag_64bit = p->ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_64BIT;

Presumably we have verified INCOMPAT_64BIT is set for filesystems with
more than 2^32 blocks in the superblock and the device size?


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
