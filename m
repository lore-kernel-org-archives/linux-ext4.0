From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3: bogus i_mode errors with 2.6.18.1
Date: Tue, 24 Oct 2006 14:27:16 -0600
Message-ID: <20061024202716.GX3509@schatzie.adilger.int>
References: <20061023144556.GY22487@skl-net.de> <20061023164416.GM3509@schatzie.adilger.int> <20061023200242.GA5015@schatzie.adilger.int> <20061024091449.GZ22487@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:16267 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1030438AbWJXU1T
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 16:27:19 -0400
To: Andre Noll <maan@systemlinux.org>
Content-Disposition: inline
In-Reply-To: <20061024091449.GZ22487@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 24, 2006  11:14 +0200, Andre Noll wrote:
> On 14:02, Andreas Dilger wrote:
> Something like the this? (only compile tested). And no, I do _not_ know,
> what I'm doing ;)

Don't worry, everyone starts out not knowing what they are doing.
The ext3_free_blocks() part looks OK from a cursory review.

> @@ -1372,12 +1370,24 @@ allocated:
>  	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
>  		      EXT3_SB(sb)->s_itb_per_group) ||
>  	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
> +		      EXT3_SB(sb)->s_itb_per_group)) {
> +		int j;
> +		ext3_error(sb, __FUNCTION__,
>  			    "Allocating block in system zone - "
>  			    "blocks from "E3FSBLK", length %lu",
>  			     ret_block, num);
> -
> +		/* Note: This will potentially use up one of the handle's
> +		 * buffer credits.  Normally we have way too many credits,
> +		 * so that is OK.  In _very_ rare cases it might not be OK.
> +		 * We will trigger an assertion if we run out of credits,
> +		 * and we will have to do a full fsck of the filesystem -
> +		 * better than randomly corrupting filesystem metadata.
> +		 */
> +		j = find_next_usable_block(-1, gdp, EXT3_BLOCKS_PER_GROUP(sb));

I'm not sure why the "find_next_usable_block()" part is in here?  At this
point we KNOW that ret_block is not a block we should be allocating, yet
it is marked free in the bitmap.  So we should just mark the block(s) in-use
in the bitmap and look for a different block(s).

> +		if (j >= 0)
> +			ext3_set_bit(j, gdp_bh->b_data);

Note that we need to loop over "num" blocks and set any bits that should
be set, as is done in the ext3_free_blocks() code.  This function has
changed since 2.4 in that it can now potentially allocate multiple blocks.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
