From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Is >16TB support considered stable?
Date: Tue, 01 Jun 2010 11:30:45 -0500
Message-ID: <4C0535B5.20508@redhat.com>
References: <4BFFF4D2.6020908@van-ness.com> <4C001BEC.9080906@redhat.com> <4C00804D.7010000@van-ness.com> <87ljb3gwee.fsf@willster.local.flamingspork.com> <4C017BAC.2000000@van-ness.com> <4C0516C2.8070007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sandon Van Ness <sandon@van-ness.com>, linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0FAQhW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:37:22 -0400
In-Reply-To: <4C0516C2.8070007@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler wrote:
> On 05/29/2010 04:40 PM, Sandon Van Ness wrote:
>> On 05/28/2010 09:32 PM, Stewart Smith wrote:
>>   
>>> On Fri, 28 May 2010 19:47:41 -0700, Sandon Van
>>> Ness<sandon@van-ness.com>  wrote:
>>>
>>>     
>>>> able to allocate blocks or memory (it was a while back so I forget). I
>>>> spent 24 hours defraging it getting the fragmentation down from like
>>>> 99.9995% to 99.2% and the problem went away. XFS seems to excessively
>>>> fragment (that horribly fragmented system was running mythtv and after
>>>> switching to JFS I see way less fragmented files).
>>>>
>>>>        
>>> MythTV's IO path is well... hacked to get around all of ext3's quirks.
>>>
>>> You can:
>>> - mount XFS with allocsize=64m (or similar)
>>> - possibly use the XFS filestreams allocator
>>> - comment out the fsync() in the mythtv tree
>>> - LD_PRELOAD libeatmydata for myth.
>>>
>>> it turns out that writing a rather small amount of data and fsync()ing
>>> (and repeating 1,000,000 times) makes the allocator cry a bit with
>>> default settings. Especially if you were recording a few things at once.
>>>
>>>      
>> Well JFS has absolutely no problems with files created via mythtv. I
>> also am not going to be using mythtv on this system at all and I was
>> just giving some examples of my past experience with XFS and why I will
>> never use it. Anyway please no more XFS discussion or suggestions for
>> other file-systems I was mainly curious on what the stability or peoples
>> experiences are with ext4 and 64-bit addressing. I have long since
>> decided I will never run XFS again as I can't ever trust it with my data
>> again. I mainly wrote this list to try to find out what the opinions
>> were on ext4 with>16 TiB file-systems.
>>
>>    
> 
> The short answer is no.
> 
> Ric

As in, no, ext4 (specifically e2fsprogs) doesn't support > 16T today and 
nobody seems -really- interested in making it do so, at least not with any 
sense of urgency.  Once the right bits are upstream there will be soak
time to take into account as well.

I know you don't want to discuss XFS, but honestly it's what you should use
for a filesystem of this size.  Most of your concerns are either too vague
to address (everyone has a filesystem horror story) or addressed since you
last tested (xfs_repair had a lot of memory-footprint reduction in recent
releases for example, and a btree corruption was fixed years back, probably
related to your very-fragmented-file problems).

But anyway, I guess you need to stick with JFS based on your preferences and
the rate at which ext4 >16T is maturing.

-Eric
