From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/3] ext4: different maxbytes functions for bitmap &
	extent files
Date: Wed, 5 Dec 2007 16:18:04 -0700
Message-ID: <20071205231804.GA3604@webber.adilger.int>
References: <47557870.9060405@redhat.com> <47557913.3090208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:43486 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbXLEXSG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2007 18:18:06 -0500
Content-Disposition: inline
In-Reply-To: <47557913.3090208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 04, 2007  09:58 -0600, Eric Sandeen wrote:
> +static loff_t ext4_max_size(int blkbits)
> +{
> +	loff_t res;
> +	loff_t upper_limit = MAX_LFS_FILESIZE;
> +
> +	/* small i_blocks in vfs inode? */
> +	if (sizeof(blkcnt_t) < sizeof(u64)) {

It would probably be more future-proof by having a struct inode here and
using "if (sizeof(inode->i_blocks) < sizeof(__u64))".

> +		upper_limit = (1LL << 32) - 1;
> +
> +		/* total blocks in file system block size */
> +		upper_limit >>= (blkbits - 9);
> +		upper_limit <<= blkbits;

There is probably a cleaner way to do this, maybe:

		upper_limit = (1LL << (32 + 9) - 1) & ~((1 << blkbits) - 1);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
