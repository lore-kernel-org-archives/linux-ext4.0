From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Thu, 7 Apr 2016 17:38:54 -0400
Message-ID: <5706D36E.3060205@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <20160404160228.GW7822@mtj.duckdns.org> <570584F1.10909@hpe.com> <20160406225424.GK24661@htj.duckdns.org> <57068395.1080703@hpe.com> <20160407160623.GF7822@mtj.duckdns.org> <5706AC71.3080801@hpe.com> <20160407185827.GH7822@mtj.duckdns.org> <5706C4F2.6020108@hpe.com> <20160407204114.GJ7822@mtj.duckdns.org>
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
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:35760
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753800AbcDGVjT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Apr 2016 17:39:19 -0400
In-Reply-To: <20160407204114.GJ7822@mtj.duckdns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/07/2016 04:41 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Apr 07, 2016 at 04:37:06PM -0400, Waiman Long wrote:
>> I would say that because I am lazy, I don't want compute the deltas every
>> time I want to see the effect of running a certain type of workload on the
>> statistics counts. I have use case that I need to track 10 or so statistics
>> counts and monitor their changes after running a job. It is much more
>> convenient to do a reset and see what you get than doing manual subtractions
>> to find out.
> I don't know.  Write a simple script?  Even if you wanna keep it in
> kernel, you can just have a base counter which offsets the summed up
> value on read.
>
>> I had taken a look at percpu-refcount.[ch]. I think the synchronization code
>> is a bit overkill for this purpose as no one really need a very precise
>> statistics counts nor precise atomic reset. I would prefer providing an
>> optional atomic reset feature with slower statistics count update path for
>> the time being. If we come across a use case where we need atomic reset with
>> negligible slowdown, we could then refactor the code to use something
>> similar to  what the percpu-refcount code is doing.
> Please either drop reset or make it actually work; otherwise, I don't
> think this should go in.
>
> Thanks.
>

In this case, I think I will drop this reset functionality. It is not 
really needed for this patchset.

Thanks for the feedback!

Cheers,
Longman
