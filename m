From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4-block-reservation.patch
Date: Tue, 19 Jun 2007 16:10:49 -0600
Message-ID: <20070619221048.GW5181@schatzie.adilger.int>
References: <4677B00A.3010600@linux.vnet.ibm.com> <4677F0B3.4050805@redhat.com> <46780D76.9040706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46181 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXFSWKv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 18:10:51 -0400
Content-Disposition: inline
In-Reply-To: <46780D76.9040706@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 19, 2007  22:38 +0530, Aneesh Kumar K.V wrote:
> This is what i have modified. I am yet to build test it. I am looking at 
> forward porting the
> mballoc patches and was planning to send it together.

> +int ext4_reserve_local(struct super_block *sb, int blocks)
> +{
> +	preempt_disable();
> +	rs = sbi->s_reservation_slots + smp_processor_id();

Should this be instead "rs = sbi->s_reservation_slots + get_cpu()"

> +	spin_lock(&rs->rs_lock);
> +	if (likely(rs->rs_reserved >= blocks)) {
> +		rs->rs_reserved -= blocks;
> +		rc = 0;
> +	}
> +	spin_unlock(&rs->rs_lock);
> +
> +	preempt_enable();

And "put_cpu()" here?

> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
> +{
> +	/* chunk is a number of block every used
> +	 * slot will get. make sure it isn't 0 */
> +	chunk = free + used_slots - 1;
> +	do_div(chunk, used_slots);
> +
> +	for_each_possible_cpu(i) {
> +		if (free < chunk)
> +			chunk = free;
> +		if (rs[i].rs_reserved || i == smp_processor_id()) {
> +			rs[i].rs_reserved = chunk;
> +			free -= chunk;
> +			BUG_ON(free < 0);
> +		}
> +	}

Should we be assigning reservations to offline CPUs?  Doesn't it make sense
to assign 0 reservation to offline CPUs until they come back?  In the first
loop, if it is "for_each_possible_cpu()" it would drop reservations from
offline CPUs, and then the bottom one is "for_each_online_cpu()".

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
