From: Andreas Dilger <adilger@sun.com>
Subject: Re: patch queue update
Date: Thu, 10 Jan 2008 14:43:23 -0700
Message-ID: <20080110214323.GL3351@webber.adilger.int>
References: <20080110153358.GA9367@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55824 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYAJVnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2008 16:43:25 -0500
Content-Disposition: inline
In-Reply-To: <20080110153358.GA9367@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 10, 2008  21:03 +0530, Aneesh Kumar K.V wrote:
>  	if (i >= sbi->s_mb_order2_reqs) {
> -		i--;
> -		if ((ac->ac_g_ex.fe_len & (~(1 << i))) == 0)
> +		/*
> +		 * This should tell if fe_len is exactly power of 2
> +		 */
> +		if ((ac->ac_g_ex.fe_len & (~(1 << (i - 1)))) == 0)
>  			ac->ac_2order = i;

While you changed i to (i - 1) in the "if" you didn't change it when
setting ac_2order...  Is that incorrect?

>  		/*
> +		 * Yield the CPU here so that we don't get soft lockup
>  		 */
> -		schedule_timeout(HZ);
> +		schedule();
>  		goto repeat;
>  	}
>  
> @@ -3808,7 +3820,7 @@ repeat:
>  			printk(KERN_ERR "uh-oh! used pa while discarding\n");
>  			dump_stack();
>  			current->state = TASK_UNINTERRUPTIBLE;
> -			schedule();
> +			schedule_timeout(HZ);
>  			goto repeat;

Is this change to schedule_timeout() intentional?  The earlier code is
removing the use of schedule_timeout.  I could be wrong, as I didn't
follow this discussion closely, but sometimes changes like this happen
accidentally and people don't look at the patch itself...

> +static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
> +{
> +	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
> +	unsigned long stripe_width = le32_to_cpu(sbi->s_es->s_raid_stripe_width);
> +
> +	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group) {
> +		return sbi->s_stripe;
> +	} else if (stripe_width <= sbi->s_blocks_per_group) {
> +		return stripe_width;
> +	} else if (stride <= sbi->s_blocks_per_group) {
> +		return stride;
> +	}

If you are doing "return XXX" you don't need "else".

> +	/*
> +	 * set the stripe size. If we have specified it via mount option, then
> +	 * use the mount option value. If the value specified at mount time is
> +	 * greater than the blocks per group use the super block value.
> +	 * Allocator needs it be less than blocks per group.
> +	 */
> +	sbi->s_stripe = ext4_get_stripe_size(sbi);

This comment should probably go by ext4_get_stripe_size() definition instead
of here at the caller.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
