From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Wed, 6 Apr 2016 17:53:08 -0400
Message-ID: <57058544.1000204@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <57021969.8050504@kyup.com> <5702A053.5030404@hpe.com> <alpine.DEB.2.20.1604041408110.16930@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nikolay Borisov <kernel@kyup.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Christoph Lameter <cl@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1604041408110.16930@east.gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/04/2016 03:09 PM, Christoph Lameter wrote:
> On Mon, 4 Apr 2016, Waiman Long wrote:
>
>>>> +	if ((unsigned int)stat>= pcs->nstats)
>>>> +		return;
>>>> +	preempt_disable();
>>>> +	pstat = this_cpu_ptr(&pcs->stats[stat]);
>>>> +	*pstat += cnt;
>>>> +	preempt_enable();
>>>> +}
>>> pstat = get_cpu_ptr(&pcs->stats[stat]);
>>> *pstat += cnt;
>>> put_cpu_ptr(&pcs->stats[stat]);
>>>
>>> It will generate identical code but this one uses APIs, making the
>>> intention clearer. But as I said this is just a minor nit.
>>>
>>> you can add my Reviewed-by: Nikolay Borisov<kernel@kyup.com>   for this
>>> particular patch.
>> Yes, that will certainly make it look nicer. I will update the patch once I
>> get feedback from my other ext4 patches.
> Why not
>
>     this_cpu_add(pci->stats[stat], cnt)
>
> This is a single instruction on x86.
>

Yes, using this_cpu_add() will be even simpler.

Cheers,
Longman
