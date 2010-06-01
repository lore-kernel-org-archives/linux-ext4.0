From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Is >16TB support considered stable?
Date: Tue, 01 Jun 2010 10:18:42 -0400
Message-ID: <4C0516C2.8070007@gmail.com>
References: <4BFFF4D2.6020908@van-ness.com> <4C001BEC.9080906@redhat.com> <4C00804D.7010000@van-ness.com> <87ljb3gwee.fsf@willster.local.flamingspork.com> <4C017BAC.2000000@van-ness.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Sandon Van Ness <sandon@van-ness.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63954 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0FAOTC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 10:19:02 -0400
Received: by vws11 with SMTP id 11so1077146vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jun 2010 07:19:01 -0700 (PDT)
In-Reply-To: <4C017BAC.2000000@van-ness.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/29/2010 04:40 PM, Sandon Van Ness wrote:
> On 05/28/2010 09:32 PM, Stewart Smith wrote:
>    
>> On Fri, 28 May 2010 19:47:41 -0700, Sandon Van Ness<sandon@van-ness.com>  wrote:
>>
>>      
>>> able to allocate blocks or memory (it was a while back so I forget). I
>>> spent 24 hours defraging it getting the fragmentation down from like
>>> 99.9995% to 99.2% and the problem went away. XFS seems to excessively
>>> fragment (that horribly fragmented system was running mythtv and after
>>> switching to JFS I see way less fragmented files).
>>>
>>>        
>> MythTV's IO path is well... hacked to get around all of ext3's quirks.
>>
>> You can:
>> - mount XFS with allocsize=64m (or similar)
>> - possibly use the XFS filestreams allocator
>> - comment out the fsync() in the mythtv tree
>> - LD_PRELOAD libeatmydata for myth.
>>
>> it turns out that writing a rather small amount of data and fsync()ing
>> (and repeating 1,000,000 times) makes the allocator cry a bit with
>> default settings. Especially if you were recording a few things at once.
>>
>>      
> Well JFS has absolutely no problems with files created via mythtv. I
> also am not going to be using mythtv on this system at all and I was
> just giving some examples of my past experience with XFS and why I will
> never use it. Anyway please no more XFS discussion or suggestions for
> other file-systems I was mainly curious on what the stability or peoples
> experiences are with ext4 and 64-bit addressing. I have long since
> decided I will never run XFS again as I can't ever trust it with my data
> again. I mainly wrote this list to try to find out what the opinions
> were on ext4 with>16 TiB file-systems.
>
>    

The short answer is no.

Ric

