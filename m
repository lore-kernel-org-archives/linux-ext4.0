From: Sandon Van Ness <sandon@van-ness.com>
Subject: Re: Is >16TB support considered stable?
Date: Sat, 29 May 2010 13:40:12 -0700
Message-ID: <4C017BAC.2000000@van-ness.com>
References: <4BFFF4D2.6020908@van-ness.com> <4C001BEC.9080906@redhat.com> <4C00804D.7010000@van-ness.com> <87ljb3gwee.fsf@willster.local.flamingspork.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from box.houkouonchi.jp ([208.97.140.21]:33454 "EHLO
	box.houkouonchi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0E2UkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 May 2010 16:40:23 -0400
Received: from [127.0.0.1] (houkouonchi.dreamhost.com [127.0.0.1])
	by box.houkouonchi.net (Postfix) with ESMTPA id 8F51B100E3
	for <linux-ext4@vger.kernel.org>; Sat, 29 May 2010 13:40:22 -0700 (PDT)
In-Reply-To: <87ljb3gwee.fsf@willster.local.flamingspork.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 09:32 PM, Stewart Smith wrote:
> On Fri, 28 May 2010 19:47:41 -0700, Sandon Van Ness <sandon@van-ness.com> wrote:
>   
>> able to allocate blocks or memory (it was a while back so I forget). I
>> spent 24 hours defraging it getting the fragmentation down from like
>> 99.9995% to 99.2% and the problem went away. XFS seems to excessively
>> fragment (that horribly fragmented system was running mythtv and after
>> switching to JFS I see way less fragmented files).
>>     
> MythTV's IO path is well... hacked to get around all of ext3's quirks.
>
> You can:
> - mount XFS with allocsize=64m (or similar)
> - possibly use the XFS filestreams allocator
> - comment out the fsync() in the mythtv tree
> - LD_PRELOAD libeatmydata for myth.
>
> it turns out that writing a rather small amount of data and fsync()ing
> (and repeating 1,000,000 times) makes the allocator cry a bit with
> default settings. Especially if you were recording a few things at once.
>   
Well JFS has absolutely no problems with files created via mythtv. I
also am not going to be using mythtv on this system at all and I was
just giving some examples of my past experience with XFS and why I will
never use it. Anyway please no more XFS discussion or suggestions for
other file-systems I was mainly curious on what the stability or peoples
experiences are with ext4 and 64-bit addressing. I have long since
decided I will never run XFS again as I can't ever trust it with my data
again. I mainly wrote this list to try to find out what the opinions
were on ext4 with >16 TiB file-systems.

