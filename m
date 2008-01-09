From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Use superblock s_raid_stripe_width as stripe
	size during block allocation.
Date: Wed, 09 Jan 2008 14:02:11 -0800
Message-ID: <1199916131.4011.5.camel@localhost.localdomain>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47273 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYAIWCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 17:02:21 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m09M2IUg021171
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:18 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09M2I8w106224
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:18 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m09M2ITB012908
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:02:18 -0500
In-Reply-To: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-01-09 at 22:37 +0530, Aneesh Kumar K.V wrote:
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

Is that still true with flex bg?

> +	 */
> +	if (!sbi->s_stripe ||
> +			sbi->s_stripe >= sbi->s_blocks_per_group) {
> +		sbi->s_stripe = le32_to_cpu(es->s_raid_stripe_width);
> +	}
> 
>  	/*
>  	 * set up enough so that it can read an inode
