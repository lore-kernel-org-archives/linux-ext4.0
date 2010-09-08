From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/5] Add helper function for blkdev_issue_zeroout
Date: Wed, 8 Sep 2010 14:36:55 -0600
Message-ID: <60EEB7F1-715A-4952-87ED-DFEE46B0C0D0@dilger.ca>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com> <1283965160-31597-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22378 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0IHUg4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 16:36:56 -0400
In-Reply-To: <1283965160-31597-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-08, at 10:59, Lukas Czerner wrote:
> +static inline int sb_issue_zeroout(struct super_block *sb,
> +				   sector_t block, sector_t nr_blocks)
> +{
> +	block <<= (sb->s_blocksize_bits - 9);
> +	nr_blocks <<= (sb->s_blocksize_bits - 9);
> +	return blkdev_issue_zeroout(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> +				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
> +}

While I can understand that we might need a barrier for this (to avoid
it being reordered with later writes that are using these blocks), I'm
not sure it needs to wait for previous IO to complete.

Cheers, Andreas





