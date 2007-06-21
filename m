From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 2/11][take 2] add new macro EXT2_DESC_PER_BLOCK in e2fsprogs
Date: Thu, 21 Jun 2007 13:16:14 -0600
Message-ID: <20070621191614.GX5181@schatzie.adilger.int>
References: <467A95F5.6050300@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54602 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXFUTQQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 15:16:16 -0400
Content-Disposition: inline
In-Reply-To: <467A95F5.6050300@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:15 +0200, Valerie Clement wrote:
> -#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / sizeof (struct ext2_group_desc))
> +#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / \
> +	((EXT2_DESC_SIZE(s) >= EXT2_MIN_DESC_SIZE_64BIT) ? \
> +	 (s)->s_desc_size : sizeof(struct ext2_group_desc)))

If EXT2_DESC_SIZE() is already checking the superblock flag, why not just use:

#define EXT2_DESC_PER_BLOCK(s)		(EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))

Even better would be (1 << (EXT2_BLOCK_SIZE_BITS(s) - EXT2_DESC_SIZE_BITS(s))).

Having the s_desc_size stored as an integer shift (128 << s_desc_bits) instead
of a number of bytes makes a lot of sense (forces power-of-two size, makes
math easy), but it might be too much of a format change at this point?


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
