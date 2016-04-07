From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH 2/3] percpu_stats: Simple per-cpu statistics count helper
 functions
Date: Thu, 7 Apr 2016 14:52:33 -0400
Message-ID: <5706AC71.3080801@hpe.com>
References: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com> <1459566578-30221-3-git-send-email-Waiman.Long@hpe.com> <20160404160228.GW7822@mtj.duckdns.org> <570584F1.10909@hpe.com> <20160406225424.GK24661@htj.duckdns.org> <57068395.1080703@hpe.com> <20160407160623.GF7822@mtj.duckdns.org>
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
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:31872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbcDGTHl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Apr 2016 15:07:41 -0400
In-Reply-To: <20160407160623.GF7822@mtj.duckdns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/07/2016 12:06 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Apr 07, 2016 at 11:58:13AM -0400, Waiman Long wrote:
>> We can certainly make it watertight. However, that will certainly require
>> adding performance overhead in the percpu stats update fast path which I am
>> not willing to pay.
> There are multiple options depending on the specific balance you want
> to hit.  Reset can be made very heavy (involving RCU sync operation)
> to make hot path overhead minimal, local locking or atomic ops can
> also be used which while more expensive than this_cpu_*() ops still
> avoids cacheline bouncing.
>
>> The purpose of this stat counters reset functionality is to allow developers
>> to reset the stat counters, run certain workload and see how things are
>> going in the kernel when the workload completes assuming that those stat
>> counters are exposed via sysfs, debugfs, etc. The developers can certainly
>> check the stat counters after the reset to make sure that they are properly
>> reset. So I don't think we need an airtight way of doing it. If you have
>> scenarios in your mind that require airtight reset of the stat counters,
>> please let me know and I will see what I can do about it.
> No matter what, don't create something which can yield a completely
> surprising result once in a blue moon.  You might think it's okay
> because the likelihood is low but that just means that the resulting
> malfunctions will be that much more obscure and difficult to
> reproduce.
>
> Thanks.
>

As long as atomic reset is an optional feature that caller can choose at 
init time, I am OK to provide this functionality. I just don't want it 
to be the default because of the performance overhead.

Cheers,
Longman
