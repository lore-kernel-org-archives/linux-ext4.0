From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Mon, 4 Apr 2016 12:02:28 -0400
Message-ID: <20160404160228.GW7822@mtj.duckdns.org>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
 <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Fri, Apr 01, 2016 at 11:09:37PM -0400, Waiman Long wrote:
...
> +struct percpu_stats {
> +	unsigned long __percpu *stats;

I'm not sure ulong is the best choice here.  Atomic reads on 32bit are
nice but people often need 64bit counters for stats.  It probably is a
better idea to use u64_stats_sync.

> +/*
> + * Reset the all statistics counts to 0 in the percpu_stats structure

Proper function description please.

> + */
> +static inline void percpu_stats_reset(struct percpu_stats *pcs)

Why is this function inline?

> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
                                       ^^
> +		int stat;
> +
> +		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
> +			*pstats = 0;
> +	}
> +
> +	/*
> +	 * If a statistics count is in the middle of being updated, it
> +	 * is possible that the above clearing may not work. So we need
> +	 * to double check again to make sure that the counters are really
> +	 * cleared. Still there is a still a very small chance that the
> +	 * second clearing does not work.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
> +		int stat;
> +
> +		for (stat = 0; stat < pcs->nstats; stat++, pstats++)
> +			if (*pstats)
> +				*pstats = 0;
> +	}

I don't think this is acceptable.

> +}
> +
> +static inline int percpu_stats_init(struct percpu_stats *pcs, int num)
> +{
> +	pcs->nstats = num;
> +	pcs->stats  = __alloc_percpu(sizeof(unsigned long) * num,
> +				     __alignof__(unsigned long));
> +	if (!pcs->stats)
> +		return -ENOMEM;
> +
> +	percpu_stats_reset(pcs);
> +	return 0;
> +}
> +
> +static inline void percpu_stats_destroy(struct percpu_stats *pcs)
> +{
> +	free_percpu(pcs->stats);
> +	pcs->stats  = NULL;
> +	pcs->nstats = 0;
> +}

Why inline the above functions?

> +static inline void
> +__percpu_stats_add(struct percpu_stats *pcs, int stat, int cnt)
> +{
> +	unsigned long *pstat;
> +
> +	if ((unsigned int)stat >= pcs->nstats)
> +		return;

This is a critical bug.  Please don't fail silently.  BUG_ON(),
please.

> +	preempt_disable();
> +	pstat = this_cpu_ptr(&pcs->stats[stat]);
> +	*pstat += cnt;
> +	preempt_enable();
> +}

this_cpu_add() is atomic w.r.t. local operations.

> +static inline unsigned long
> +percpu_stats_sum(struct percpu_stats *pcs, int stat)
> +{
> +	int cpu;
> +	unsigned long sum = 0;
> +
> +	if ((unsigned int)stat >= pcs->nstats)
> +		return sum;

Ditto.

> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(pcs->stats[stat], cpu);
> +	return sum;
> +}

Thanks.

-- 
tejun
