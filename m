From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Wed, 6 Apr 2016 15:52:39 -0400
Message-ID: <57056907.20705@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <20160404160228.GW7822@mtj.duckdns.org>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:32448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753181AbcDFTw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Apr 2016 15:52:56 -0400
In-Reply-To: <20160404160228.GW7822@mtj.duckdns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/04/2016 12:02 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Apr 01, 2016 at 11:09:37PM -0400, Waiman Long wrote:
> ...
>> +struct percpu_stats {
>> +	unsigned long __percpu *stats;
> I'm not sure ulong is the best choice here.  Atomic reads on 32bit are
> nice but people often need 64bit counters for stats.  It probably is a
> better idea to use u64_stats_sync.
>
>> +/*
>> + * Reset the all statistics counts to 0 in the percpu_stats structure
> Proper function description please.
>
>> + */
>> +static inline void percpu_stats_reset(struct percpu_stats *pcs)
> Why is this function inline?
>
>> +{
>> +	int cpu;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
>                                         ^^
>> +		int stat;
>> +
>> +		for (stat = 0; stat<  pcs->nstats; stat++, pstats++)
>> +			*pstats = 0;
>> +	}
>> +
>> +	/*
>> +	 * If a statistics count is in the middle of being updated, it
>> +	 * is possible that the above clearing may not work. So we need
>> +	 * to double check again to make sure that the counters are really
>> +	 * cleared. Still there is a still a very small chance that the
>> +	 * second clearing does not work.
>> +	 */
>> +	for_each_possible_cpu(cpu) {
>> +		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
>> +		int stat;
>> +
>> +		for (stat = 0; stat<  pcs->nstats; stat++, pstats++)
>> +			if (*pstats)
>> +				*pstats = 0;
>> +	}
> I don't think this is acceptable.
>
>> +}
>> +
>> +static inline int percpu_stats_init(struct percpu_stats *pcs, int num)
>> +{
>> +	pcs->nstats = num;
>> +	pcs->stats  = __alloc_percpu(sizeof(unsigned long) * num,
>> +				     __alignof__(unsigned long));
>> +	if (!pcs->stats)
>> +		return -ENOMEM;
>> +
>> +	percpu_stats_reset(pcs);
>> +	return 0;
>> +}
>> +
>> +static inline void percpu_stats_destroy(struct percpu_stats *pcs)
>> +{
>> +	free_percpu(pcs->stats);
>> +	pcs->stats  = NULL;
>> +	pcs->nstats = 0;
>> +}
> Why inline the above functions?
>
>> +static inline void
>> +__percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
>> +{
>> +	unsigned long *pstat;
>> +
>> +	if ((unsigned int)stat>= pcs->nstats)
>> +		return;
> This is a critical bug.  Please don't fail silently.  BUG_ON(),
> please.

Sure.

>
>> +	preempt_disable();
>> +	pstat = this_cpu_ptr(&pcs->stats[stat]);
>> +	*pstat += cnt;
>> +	preempt_enable();
>> +}
> this_cpu_add() is atomic w.r.t. local operations.

Will use this_cpu_add().

>> +static inline unsigned long
>> +percpu_stats_sum(struct percpu_stats *pcs, int stat)
>> +{
>> +	int cpu;
>> +	unsigned long sum = 0;
>> +
>> +	if ((unsigned int)stat>= pcs->nstats)
>> +		return sum;
> Ditto.
>
>> +	for_each_possible_cpu(cpu)
>> +		sum += per_cpu(pcs->stats[stat], cpu);
>> +	return sum;
>> +}
> Thanks.
>

Cheers,
Longman
