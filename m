From: Christoph <cr2005@u-club.de>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
 (v2)
Date: Sat, 22 Oct 2011 17:14:27 +0200
Message-ID: <4EA2DDD3.8080306@u-club.de>
References: <4E1C70AD.1010101@u-club.de> <201109251532.20025.rjw@sisk.pl>	<4E7FA3C7.5050503@u-club.de> <201109260010.50649.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	Nigel Cunningham <nigel@tuxonice.net>,
	Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.uscreen.net ([62.67.233.10]:33775 "EHLO mail.uscreen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1JVPOc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Oct 2011 11:14:32 -0400
In-Reply-To: <201109260010.50649.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> PM / Freezer: Freeze filesystems while freezing processes (v2)
> 
> On Sunday, August 07, 2011, Dave Chinner wrote:
>> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>> 
>>> Freeze all filesystems during the freezing of tasks by calling 
>>> freeze_bdev() for each of them and thaw them during the thawing of
>>> tasks with the help of thaw_bdev().
>>> 
>>> This is needed by hibernation, because some filesystems (e.g. XFS) 
>>> deadlock with the preallocation of memory used by it if the memory 
>>> pressure caused by it is too heavy.
>>> 
...
> 
> Below is an alternative fix, the changelog pretty much explains the
> idea.
> 
> I've tested it on Toshiba Portege R500, but I don't have an XFS
> partition to verify that it really helps, so I'd appreciate it if
> someone able to reproduce the original issue could test it and report
> back.

Hi Rafael!

Well, the kernel bugtracker is still down and I just like to post my
experience with kernel (x64) v3.1-rc8/9 + patches. My machine is a
MacBookPro, doomed with 4GB RAM running debian.

Bug #1

on the way to hibernate, machine hangs on

"PM: Preallocating image memory..."

this patch worked for me now for weeks:
"[PATCH] PM / Freezer: Freeze filesystems while freezing processes (v2)"
https://lkml.org/lkml/2011/9/24/77

I was able to reproduce this bug with virtualbox and tested the patch ~40
cycles.

Bug#2

on resume from hibernate, hard reset (x64 only):
http://marc.info/?l=linux-kernel&m=131653513414314&w=2

With this patch I haven't got this issue again the last weeks.

I wasn't able to reproduce this bug with virtualbox.





I only got one pm-hibernate issue. Last line:

Disabling non-boot CPUs ...

This time I've enabled debug hung task :)

schedule_timeout
...
workqueue_cpu_callback
notifier_call_chain
...
__cpu_notify
_cpu_down
printk
disable_nonboot_cpus
hibernation_snapshot
hibernate
...

Any other idea besides the possibility it's caused by evil earth
radiation, isn't it?


Gruss,
chris




On 26.09.2011 00:10, Rafael J. Wysocki wrote:
> On Sunday, September 25, 2011, Christoph wrote:
>> On 25.09.2011 15:32, Rafael J. Wysocki wrote:
>>> On Sunday, September 25, 2011, Christoph wrote:
>>>> test results of the patch below:
>>>>
>>>> 1. real machine
>>>>
>>>> suspends fine but on wakeup, after loading image: hard reset. nvidia
>>>> gpu => disabled compitz  => wakeup worked two times.
>>>
>>> Hmm, so there's a separate bug related to NVidia I guess.
>>
>> Maybe.
>>
>> Just made another test: the machine (macbook) woke up, loaded image, thaw.
>> It got stuck at vt#1, displaying console with login. Cursor blinking, but
>> no (usb) keyboard or network enabled. Bricked?!!
>>
>>
>> On the other hand I've got another box with nvidia gpu:
>>
>> debian5 32bit
>> 2.6.38.2+ #3 SMP Fri Apr 1
>> nvidia 260.19.36
>>
>> It's up since I compiled the kernel: I use it twice a week and I kept it
>> freezed all the time. It was solid rock until today: hard reset on resume.
>> WTF? (I remember this version combo was stable on the macbook but the
>> kernel lacks a solid wireless driver).
> 
> If that's an x86_64 system, there is a known bug causing problems like
> this to happen.  There's a patch fixing it, but not conclusive:
> http://marc.info/?l=linux-kernel&m=131653513414314&w=2
> 
> Thanks,
> Rafael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
