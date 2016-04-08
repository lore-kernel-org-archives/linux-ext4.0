From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit architectures
Date: Fri, 8 Apr 2016 13:32:52 -0400
Message-ID: <5707EB44.9020703@hpe.com>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com> <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com> <20160408164747.GM24661@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Lameter <cl@linux.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160408164747.GM24661@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/08/2016 12:47 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Fri, Apr 08, 2016 at 12:16:20PM -0400, Waiman Long wrote:
>> +/**
>> + * __percpu_stats_add - add given count to percpu value
>> + * @pcs : Pointer to percpu_stats structure
>> + * @stat: The statistics count that needs to be updated
>> + * @cnt:  The value to be added to the statistics count
>> + */
>> +void __percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
>> +{
>> +	/*
>> +	 * u64_stats_update_begin/u64_stats_update_end alone are not safe
>> +	 * against recursive add on the same CPU caused by interrupt.
>> +	 * So we need to set the PCPU_STAT_INTSAFE flag if this is required.
>> +	 */
>> +	if (IS_STATS64(pcs)) {
>> +		uint64_t *pstats64;
>> +		unsigned long flags;
>> +
>> +		pstats64 = get_cpu_ptr(pcs->stats64);
>> +		if (pcs->flags&  PCPU_STAT_INTSAFE)
>> +			local_irq_save(flags);
>> +
>> +		u64_stats_update_begin(&pcs->sync);
>> +		pstats64[stat] += cnt;
>> +		u64_stats_update_end(&pcs->sync);
>> +
>> +		if (pcs->flags&  PCPU_STAT_INTSAFE)
>> +			local_irq_restore(flags);
>> +
>> +		put_cpu_ptr(pcs->stats64);
>> +	}
>> +}
> Heh, that's a handful, and, right, u64_stats needs separate irq
> protection.  I'm not sure.  If we have to do the above, it's likely
> that it'll perform worse than percpu_counter on 32bits.  On 64bits,
> percpu_counter would incur extra preempt_disable/enable() operations
> but that comes from it not using this_cpu_add_return().  I wonder
> whether it'd be better to either use percpu_counter instead or if
> necessary extend it to handle multiple counters.  What do you think?
>
> Thanks.
>

Yes, I think it will be more efficient to use percpu_counter in this 
case. The preempt_disable/enable() calls are pretty cheap. Once in a 
while, you need to take the lock and update the global count. How about 
I change the 2nd patch to use percpu_counter internally when 64-bit 
counts are needed in 32-bit archs, but use the regular percpu counts on 
64-bit archs? If you are OK with that, I can update the patch accordingly.

Cheers,
Longman
