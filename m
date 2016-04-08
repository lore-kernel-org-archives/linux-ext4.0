From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit architectures
Date: Fri, 8 Apr 2016 14:45:38 -0400
Message-ID: <5707FC52.3070707@hpe.com>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com> <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com> <20160408164747.GM24661@htj.duckdns.org> <5707EB44.9020703@hpe.com> <20160408174628.GN24661@htj.duckdns.org>
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
In-Reply-To: <20160408174628.GN24661@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/08/2016 01:46 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Apr 08, 2016 at 01:32:52PM -0400, Waiman Long wrote:
>> Yes, I think it will be more efficient to use percpu_counter in this case.
>> The preempt_disable/enable() calls are pretty cheap. Once in a while, you
>> need to take the lock and update the global count. How about I change the
>> 2nd patch to use percpu_counter internally when 64-bit counts are needed in
>> 32-bit archs, but use the regular percpu counts on 64-bit archs? If you are
>> OK with that, I can update the patch accordingly.
> Does having percpu_stats as a separate construct make sense after
> that?  Just use percpu_counter directly?  You end up wasting a bit
> more space that way but most of space overhead for these things are in
> percpu part anyway, so in proportion it shouldn't make that much of a
> difference.
>
> Thanks.
>

The percpu_stats construct allows minimal overhead in maintaining 
statistics counts. The percpu_counter construct, on the other hand, has 
a higher performance overhead and a bit more complex to set up and tear 
down when more than one statistics counts are needed. In fact, my first 
draft of the ext4 patch used percpu_counter for that purpose. However, I 
just feel that using percpu_counter is kind of an overkill if what we 
just  want is to keep some counts that we want to have their sums 
returned when requested. That are the main reasons for creating a 
separate percpu_stats.

Of course, if you think we don't need a separate percpu_stats construct. 
I am fine with that and I can rework the ext4 patch to use 
percpu_counter instead.

Cheers,
Longman
