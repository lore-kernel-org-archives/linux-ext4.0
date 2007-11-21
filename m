From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: add block bitmap validation
Date: Wed, 21 Nov 2007 14:43:27 -0700
Message-ID: <20071121214327.GC3116@webber.adilger.int>
References: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1195484161-14472-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:35487 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXKUVn3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2007 16:43:29 -0500
Content-Disposition: inline
In-Reply-To: <1195484161-14472-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 19, 2007  20:26 +0530, Aneesh Kumar K.V wrote:
> +static int ext4_valid_block_bitmap(struct super_block *sb,
> +					struct ext4_group_desc *desc,
> +					unsigned int block_group,
> +					struct buffer_head *bh)
> +{
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> +		/* with FLEX_BG, the inode/block bitmaps and itable
> +		 * blocks may not be in the group at all
> +		 * so the bitmap validation will be skipped for those groups
> +		 * or it has to also read the block group where the bitmaps
> +		 * are located to verify they are set.
> +		 */
> +		return 1;
> +	}

Rather than skipping the bitmap check entirely when FLEX_BG is enabled,
it is probably better to just validate whether each of the bitmap/itable
offsets are within the bitmap being read, like:

	offset = ...
	if (offset < EXT4_BLOCKS_PER_GROUP(sb) &&
	    ext4_test_bit(offset, bh->b_data))
		/* bad block bitmap */
	    	goto err_out;

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
