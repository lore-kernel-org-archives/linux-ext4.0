From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit
 architectures
Date: Fri, 8 Apr 2016 12:47:47 -0400
Message-ID: <20160408164747.GM24661@htj.duckdns.org>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
 <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Lameter <cl@linux.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <Waiman.Long@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:35905 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbcDHQru (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2016 12:47:50 -0400
Content-Disposition: inline
In-Reply-To: <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, Waiman.

On Fri, Apr 08, 2016 at 12:16:20PM -0400, Waiman Long wrote:
> +/**
> + * __percpu_stats_add - add given count to percpu value
> + * @pcs : Pointer to percpu_stats structure
> + * @stat: The statistics count that needs to be updated
> + * @cnt:  The value to be added to the statistics count
> + */
> +void __percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
> +{
> +	/*
> +	 * u64_stats_update_begin/u64_stats_update_end alone are not safe
> +	 * against recursive add on the same CPU caused by interrupt.
> +	 * So we need to set the PCPU_STAT_INTSAFE flag if this is required.
> +	 */
> +	if (IS_STATS64(pcs)) {
> +		uint64_t *pstats64;
> +		unsigned long flags;
> +
> +		pstats64 = get_cpu_ptr(pcs->stats64);
> +		if (pcs->flags & PCPU_STAT_INTSAFE)
> +			local_irq_save(flags);
> +
> +		u64_stats_update_begin(&pcs->sync);
> +		pstats64[stat] += cnt;
> +		u64_stats_update_end(&pcs->sync);
> +
> +		if (pcs->flags & PCPU_STAT_INTSAFE)
> +			local_irq_restore(flags);
> +
> +		put_cpu_ptr(pcs->stats64);
> +	}
> +}

Heh, that's a handful, and, right, u64_stats needs separate irq
protection.  I'm not sure.  If we have to do the above, it's likely
that it'll perform worse than percpu_counter on 32bits.  On 64bits,
percpu_counter would incur extra preempt_disable/enable() operations
but that comes from it not using this_cpu_add_return().  I wonder
whether it'd be better to either use percpu_counter instead or if
necessary extend it to handle multiple counters.  What do you think?

Thanks.

-- 
tejun
