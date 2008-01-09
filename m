From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Use superblock s_raid_stripe_width as stripe size
 during block allocation.
Date: Wed, 09 Jan 2008 11:21:10 -0600
Message-ID: <47850286.80001@redhat.com>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYAIRW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 12:22:57 -0500
In-Reply-To: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> The stipe size used during block allocation is calculated as below.
> a) if we specify a stripe=<value> option using mount time. Use that value.
> b) if not use the value specified in super block.
> b) If the value specfied at mount time is greater than blocks per group use
> the value specified ini the super block.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index db1edc8..10330eb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2136,6 +2136,16 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>  	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
>  	sbi->s_rsv_window_head.rsv_goal_size = 0;
>  	ext4_rsv_window_add(sb, &sbi->s_rsv_window_head);
> +	/*
> +	 * set the stripe size. If we have specified it via mount option, then
> +	 * use the mount option value. If the value specified at mount time is
> +	 * greater than the blocks per group use the super block value.
> +	 * Allocator needs it be less than blocks per group.
> +	 */
> +	if (!sbi->s_stripe ||
> +			sbi->s_stripe >= sbi->s_blocks_per_group) {

Is stripe == s_blocks_per_group problematic?

Should we warn/printk in the case that the specified size is too big?

Thanks,

-Eric

> +		sbi->s_stripe = le32_to_cpu(es->s_raid_stripe_width);
> +	}
>  
>  	/*
>  	 * set up enough so that it can read an inode
