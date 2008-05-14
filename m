From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix FLEX_BG and uninit group usage.
Date: Wed, 14 May 2008 14:08:02 -0500
Message-ID: <20080514140802.5621167d@gara>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1210790832-20680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55366 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbYENTIF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 15:08:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4EJAEhE007068
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 15:10:14 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4EJ84pg141504
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 15:08:04 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4EJ83nf004070
	for <linux-ext4@vger.kernel.org>; Wed, 14 May 2008 15:08:03 -0400
In-Reply-To: <1210790832-20680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 15 May 2008 00:17:12 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> With FLEX_BG we allocate block bitmap, inode bitmap, and
> inode table outside the group. So when initialzing the
> uninit block group we don't need to set bits corresponding
> to these meta-data in the bitmaps. Also return the right
> number of free blocks when counting the available free
> blocks in uninit group.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 5c80eb5..fb63f01 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -109,7 +109,14 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
> 
>  		for (bit = 0; bit < bit_max; bit++)
>  			ext4_set_bit(bit, bh->b_data);
> -
> +		/*
> +		 * With FLEX_BG uninit group we have all the
> +		 * blocks available for use. So no need
> +		 * to set any bits in bitmap
> +		 */
> +		 if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> +					 EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +			return free_blocks;
>  		start = ext4_group_first_block_no(sb, block_group);
> 
>  		/* Set bits for block and inode bitmaps, and inode table */
> @@ -126,6 +133,12 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
>  		 */
>  		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
>  	}
> +	/*
> +	 * With FLEX_BG uninit group we have all the
> +	 * blocks available for use.
> +	 */
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +		return free_blocks;
> 
>  	return free_blocks - sbi->s_itb_per_group - 2;
>  }

This assumes that if the FLEX_BG feature is enable that all block
groups have no bitmaps or inode tables (which is wrong).

Something like this (ignore the fact that doesnt handle hi bits) should be better.

	used_blocks = sbi->s_itb_per_group + 2;
	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
		ext4_get_group_no_and_offset(sbi, bgd->bg_block_bitmap_lo, tmp, 0);
		if (tmp != block_group)
			used_blocks--;
		ext4_get_group_no_and_offset(sbi, bgd->bg_inode_bitmap_lo, tmp, 0);
		if (tmp != block_group)
			used_blocks--;
		ext4_get_group_no_and_offset(sbi, bgd->bg_inode_table_lo, tmp, 0);
		if (tmp != block_group)
			used_blocks -= sbi->s_itb_per_group;
	}

 	return free_blocks - used_blocks;
 }

-JRS
