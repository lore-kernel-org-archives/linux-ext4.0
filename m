From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add lazyinit stats support
Date: Mon, 16 May 2016 23:22:35 -0500
Message-ID: <43a7d624-5fd1-a3a5-5f18-a84ebde86f1f@redhat.com>
References: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
 <e7de9f2f-6a12-026c-c9fb-2e676fdc37e4@redhat.com>
 <CAP9B-Q=7BUzkODy_PAsWi3YT3pYBcqMDWPR6kR6pCqFMDa_tzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca,
	Shuichi Ihara <sihara@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbcEQEWi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 00:22:38 -0400
In-Reply-To: <CAP9B-Q=7BUzkODy_PAsWi3YT3pYBcqMDWPR6kR6pCqFMDa_tzA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/16 11:14 PM, Wang Shilong wrote:
> On Tue, May 17, 2016 at 11:59 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 5/16/16 10:41 PM, Wang Shilong wrote:
>>> From: Wang Shilong <wshilong@ddn.com>
>>>
>>> Somtimes, we need figure out progress of Lazyinit
>>> in the background, this patch try to add stats support
>>> for it, output is something like:
>>>
>>> $ cat /sys/fs/ext4/vda/lazyinit_stats
>>> groups_finished: 80
>>> groups_total: 80
>>
>> A few thoughts:
>>
>> If this goes in, it should be documented in
>> Documentation/fs/ext4.txt, as well.
>>
>> I suppose it might be nice, but when do you think this
>> might be needed in real life?
> 
> In our performances benchmarking, we want to wait
> Lazyinit finished before starting really benchmarking sometimes.
> (Since Lazyinit thread trigger some write background here)
> 
> but there is no way to see what is progress of lazyinit.
> and we can only make sure there is no write from Device
> counter...

In that case you should just specify no lazyinit at mkfs time :)

>> Also: sysfs is technically supposed to be one value per
>> file, and (I think) just a number, no text.  At least,
>> that's what every other ext4 device sysfs file has today,
>> so this should follow that precedent.
>>
>> And as far as I can tell, "groups total" is the total
>> uninit groups at mount time, not total  in the filesystem,
>> so this would change on a remount? I think that's unexpected,
>> and not very useful.
> 
> Yeah, From our usage, we need know progress of lazyiniting.
> So after remoutning, 'total' will be dynamically changed.
> 
> We could store 'total' in superblock etc, but IMO it is
> a bit overhead here.

Agreed.

>>
>> Simply printing the remaining uninitialized block group
>> count might be enough, i.e.:
>>
>> $ cat /sys/fs/ext4/vda/lazyinit_remaining
>> 42
> 
> Yup, this works fine for me.
> 
> Thank you for your coments!

Sure thing; I'm still on the fence about usefulness, because if
anyone really cares to wait for it to hit zero, they probably
should have just changed their mkfs options to disable lazyinit.

But if you simply print remaining groups I think it is a very
simple and low-risk patch, so I wouldn't NAK it, either.

-Eric

>>
>> -Eric

