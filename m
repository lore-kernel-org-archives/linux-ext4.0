From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 8/12] 48-bit extents in e2fsprogs
Date: Tue, 12 Jun 2007 04:10:20 -0600
Message-ID: <20070612101020.GO5181@schatzie.adilger.int>
References: <466D7C9C.10500@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39154 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXFLKKV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 06:10:21 -0400
Content-Disposition: inline
In-Reply-To: <466D7C9C.10500@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 11, 2007  18:47 +0200, Valerie Clement wrote:
> +#ifdef _EXT4FS_
> +#define EXT4_EE_START(e) (((__u64)(e)->ee_start_hi << 32) + (e)->ee_start)
> +#define EXT4_EI_LEAF(ix) (((__u64)(ix)->ei_leaf_hi << 32) + (ix)->ei_leaf)
> +
> +#define EXT4_EE_START_SET(e,blk)			\
> +	do {						\
> +		(e)->ee_start = (blk);			\
> +		(e)->ee_start_hi = (blk) >> 32;		\
> +	} while(0)
> +
> +#define EXT4_EI_LEAF_SET(e,blk)				\
> +	do {						\
> +		(ix)->ei_leaf = (blk);			\
> +		(ix)->ei_leaf_hi = (blk) >> 32;		\
> +	} while(0)
> +#else
> +#define EXT4_EE_START(e)	((e)->ee_start)
> +#define EXT4_EI_LEAF(ix)	((ix)->ei_leaf)
> +
> +#define EXT4_EE_START_SET(e,blk)			\
> +	do {						\
> +		(e)->ee_start = (blk);			\
> +	} while(0)
> +
> +#define EXT4_EI_LEAF_SET(e,blk)				\
> +	do {						\
> +		(ix)->ei_leaf = (blk);			\
> +	} while(0)
> +#endif

Ideally this would also be conditional upon INCOMPAT_64BIT and the fs > 2^32
blocks, because some older versions of the extents code didn't clear the
ee_start_hi and ei_lead fields correctly.

That said, I'm not always sure we have access to a superblock somehow
in every function where we need this macro, and we've been shipping
extents patches and e2fsck which has fixed this problem, but not all of
our customers/partners are using the latest lustre or e2fsprogs, or
have necessarily run e2fsck on their filesystems..

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
