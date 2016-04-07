From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Thu, 7 Apr 2016 16:37:06 -0400
Message-ID: <5706C4F2.6020108@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <20160404160228.GW7822@mtj.duckdns.org> <570584F1.10909@hpe.com> <20160406225424.GK24661@htj.duckdns.org> <57068395.1080703@hpe.com> <20160407160623.GF7822@mtj.duckdns.org> <5706AC71.3080801@hpe.com> <20160407185827.GH7822@mtj.duckdns.org>
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
In-Reply-To: <20160407185827.GH7822@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/07/2016 02:58 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Apr 07, 2016 at 02:52:33PM -0400, Waiman Long wrote:
>> As long as atomic reset is an optional feature that caller can choose at
>> init time, I am OK to provide this functionality. I just don't want it to be
>> the default because of the performance overhead.
> Please take a look at how percpu-ref coordinates global
> synchronization.  The hot path overhead is one branch which is
> extremely easy to predict and shouldn't show up anywhere.  If you're
> gonna provide reset at all (which btw always kinda baffles me, what's
> wrong with taking a snapshot value and taking delta from there?), you
> need to make it actually work reliably.
>
> Thanks.
>

I would say that because I am lazy, I don't want compute the deltas 
every time I want to see the effect of running a certain type of 
workload on the statistics counts. I have use case that I need to track 
10 or so statistics counts and monitor their changes after running a 
job. It is much more convenient to do a reset and see what you get than 
doing manual subtractions to find out.

I had taken a look at percpu-refcount.[ch]. I think the synchronization 
code is a bit overkill for this purpose as no one really need a very 
precise statistics counts nor precise atomic reset. I would prefer 
providing an optional atomic reset feature with slower statistics count 
update path for the time being. If we come across a use case where we 
need atomic reset with negligible slowdown, we could then refactor the 
code to use something similar to  what the percpu-refcount code is doing.

Cheers,
Longman
