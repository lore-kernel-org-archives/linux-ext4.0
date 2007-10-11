From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext4: Support large files
Date: Thu, 11 Oct 2007 00:07:35 -0600
Message-ID: <20071011060735.GH8122@schatzie.adilger.int>
References: <1192079462-7830-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Takashi Sato <sho@tnes.nec.co.jp>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48049 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbXJKGH7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 02:07:59 -0400
Content-Disposition: inline
In-Reply-To: <1192079462-7830-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2007  10:41 +0530, Aneesh Kumar K.V wrote:
> This patch converts ext4_inode i_blocks to represent total
> blocks occupied by the inode in file system block size.
> Earlier the variable used to represent this in 512 byte
> block size. This actually limited the total size of the file.
> 
> This is enabled only if the incompat feature flag
> EXT4_FEATURE_INCOMPAT_LARGE_BLOCK is set in super block
> and the kernel is built with CONFIG_LSF.

NACK.  This must be an old version of the patch.  The major problem is
that there is no way to incrementally enable this feature, so as soon
as some file needs to be larger than 2TB, it means that the i_blocks
count on EVERY file needs to be updated, or it will be incorrect.

The updated proposal was to set EXT4_HUGE_FILE_FL on the inodes that
are using fs-blocksize for i_blocks, and if this flag is not set then
use 512-byte i_blocks.  This allows the filesystem to be compatible
unless there really are gigantic files.

Secondly, there is an added inode field l_i_blocks_hi (replacing l_i_frag
and l_i_pad1) that make up the high 16 bits of a 48-bit i_blocks value.
To avoid errors in the code, please also rename i_blocks -> i_blocks_lo
to catch any incorrect users of that field.

Also, this was supposed to be under the EXT4_FEATURE_RO_COMPAT_HUGE_FILE
feature flag, and not the INCOPMAT_LARGE_BLOCK flag (which isn't reserved,
and it doesn't need to be incompat with the updated design).

Please see http://lkml.org/lkml/2006/5/25/108 and my comments there.  The
patch still doesn't include l_i_blocks_hi, because that was only reserved
after some later discussion (though it is in current e2fsprogs).

> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_LARGE_BLOCK)) {
> +		/*
> +		 * With __u32 i_blocks representing the total number of blocks
> +		 * of the file in file system block size, the max file size
> +		 * would be 2**(bits+32) - 1 - blocks taken by the meta data
> +		 * blocks multiplied by block size.
> +		 */
> +		/* total blocks in file system block size*/
> +		upper_limit = (1LL << 32) - 1;

Note that this can be increased to (1LL << 48) - 1 by using l_i_blocks_hi.

> +	/* indirect blocks */
> +	meta_blocks = 1;
> +	/* double indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2));
> +	/* tripple indirect blocks */
> +	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));

This should be skipped if we are mounted with extents, though at the
same time the actual extent index block overhead isn't easily determined...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
