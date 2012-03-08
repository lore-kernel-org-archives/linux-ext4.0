From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 12:50:42 -0800
Message-ID: <4F591BA2.2080803@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57F523.3020703@redhat.com> <4F581BF6.8000305@zabbo.net> <20120308155419.GB6777@thunk.org> <20120308180951.GB29510@shiny> <4F59148A.4070001@panasas.com> <20120308203741.GE29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Chris Mason <chris.mason@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:42948 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2CHUvE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 15:51:04 -0500
In-Reply-To: <20120308203741.GE29510@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2012 12:37 PM, Chris Mason wrote:
> On Thu, Mar 08, 2012 at 12:20:26PM -0800, Boaz Harrosh wrote:
>> On 03/08/2012 10:09 AM, Chris Mason wrote:
>>>
>>> But, why are we writeback for a second or more?  Aren't there other
>>> parts of this we would want to fix as well?
>>>
>>> I'm not against only turning on stable pages when they are needed, but
>>> the code that isn't the default tends to be somewhat less used.  So it
>>> does increase testing burden when we do want stable pages, and it tends
>>> to make for awkward bugs that are hard to reproduce because someone
>>> neglects to mention it.
>>>
>>> IMHO it's much more important to nail down the 2 second writeback
>>> latency. That's not good.
>>>
>>
>> I think I understand this one. It's do to the sync nature introduced
>> by page_waiting in mkwrite.
> 
> Pages go from dirty to writeback for a few reasons.  Background
> writeout, or O_DIRECT or someone running sync
> 
> background writeout shouldn't be queueing up so much work that
> synchronous writeout has a 2 second delay.
> 
> If the latencies are coming from something that was run through
> fsync...well there's not too much we can do about that.  The problem is
> that our page_mkwrite call isn't starting the IO it is just waiting on
> it, so we can't bump the priority on it.
> 

I agree. I think the logger model is: write, than sync

Before they used to be waiting on the sync phase now their waiting
on write, when concurrent with sync. I would like to inspect this situation.
I agree with you that it's just shifting heaviness that is now hiding somewhere
else.

> -chris

Thanks
Boaz
