From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Thu, 7 Apr 2016 11:58:13 -0400
Message-ID: <57068395.1080703@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <20160404160228.GW7822@mtj.duckdns.org> <570584F1.10909@hpe.com> <20160406225424.GK24661@htj.duckdns.org>
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
In-Reply-To: <20160406225424.GK24661@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/06/2016 06:54 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Apr 06, 2016 at 05:51:45PM -0400, Waiman Long wrote:
>>>> +	/*
>>>> +	 * If a statistics count is in the middle of being updated, it
>>>> +	 * is possible that the above clearing may not work. So we need
>>>> +	 * to double check again to make sure that the counters are really
>>>> +	 * cleared. Still there is a still a very small chance that the
>>>> +	 * second clearing does not work.
>>>> +	 */
>>>> +	for_each_possible_cpu(cpu) {
>>>> +		unsigned long *pstats =  per_cpu_ptr(pcs->stats, cpu);
>>>> +		int stat;
>>>> +
>>>> +		for (stat = 0; stat<   pcs->nstats; stat++, pstats++)
>>>> +			if (*pstats)
>>>> +				*pstats = 0;
>>>> +	}
>>> I don't think this is acceptable.
>> I am not sure what you mean here by not acceptable. Please enlighten me on
>> that.
> Hmmm... I thought that was pretty clear.  Try-twice-and-we-are-probably-okay
> is simply not acceptable.  Please make it watertight.
>
> Thanks.

OK, I got it now.

We can certainly make it watertight. However, that will certainly 
require adding performance overhead in the percpu stats update fast path 
which I am not willing to pay.

The purpose of this stat counters reset functionality is to allow 
developers to reset the stat counters, run certain workload and see how 
things are going in the kernel when the workload completes assuming that 
those stat counters are exposed via sysfs, debugfs, etc. The developers 
can certainly check the stat counters after the reset to make sure that 
they are properly reset. So I don't think we need an airtight way of 
doing it. If you have scenarios in your mind that require airtight reset 
of the stat counters, please let me know and I will see what I can do 
about it.

Cheers,
Longman
