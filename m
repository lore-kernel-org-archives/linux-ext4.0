From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Thu, 27 Aug 2015 10:39:12 -0600
Message-ID: <B71D47F8-F061-431C-B7F4-6CEF102F5C98@dilger.ca>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com> <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca> <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com> <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35001 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbH0QjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2015 12:39:15 -0400
Received: by pacdd16 with SMTP id dd16so30926396pac.2
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2015 09:39:15 -0700 (PDT)
In-Reply-To: <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 27, 2015, at 8:23 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
> 
> Hi,
> 
> I've restarted fsck ~6 hours ago. It's again occupied ~30GB RAM and
> strace shows that number of syscalls per second becomes fewer and
> fewer.

My first suggestion would be to upgrade e2fsprogs to the latest
stable version - 1.42.13 so that you are not hitting any older bugs.

What was the original problem reported that caused the e2fsck
to be run?

Next, please include the full output from the start of e2fsck,
unless it is just a lot of the same lines repeated.  There are
a lot of Lustre users with 32TB or 48TB ext4 filesystems that can
finish a full e2fsck in a few hours, unless there is some kind
of major corruption.  It may be possible to fix some of the
corruption manually with debugfs to avoid a lengthy e2fsck run.

If you can run "ltrace -p <e2fsck_pid>" on the e2fsck then it
would tell us what code it is running.  It doesn't seem to be
IO bound (only one seek+read per 6 seconds).

Are there any special formatting options that were used for the
filesystem originally?  What does "debugfs -c -R stats <dev>"
report about the filesystem?

Cheers, Andreas


> Regards,
> Alexander
> 
> On Thu, Aug 27, 2015 at 8:28 AM, Alexander Afonyashin
> <a.afonyashin@madnet-team.ru> wrote:
>> Hi,
>> 
>> The last output (2 days ago) from fsck:
>> 
>> [skipped]
>> Block #524296 (1235508688) causes directory to be too big.  CLEARED.
>> Block #524297 (4003498426) causes directory to be too big.  CLEARED.
>> Block #524298 (3113378389) causes directory to be too big.  CLEARED.
>> Block #524299 (1368545889) causes directory to be too big.  CLEARED.
>> Too many illegal blocks in inode 4425477.
>> Clear inode? yes
>> 
>> ---------------------------
>> iostat output:
>> 
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>           0.00    0.00    0.00   14.52    0.00   85.48
>> 
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> loop0             0.00     0.00    2.00    0.00    12.00     0.00
>> 12.00     0.09   46.00   46.00    0.00  46.00   9.20
>> sda               0.00     0.00   87.00    0.00   348.00     0.00
>> 8.00     1.00   11.86   11.86    0.00  11.45  99.60
>> 
>> ---------------------------
>> strace ouput:
>> 
>> root@rescue ~ # strace -f -t -p 4779
>> Process 4779 attached - interrupt to quit
>> 07:26:54 lseek(4, 14154266963968, SEEK_SET) = 14154266963968
>> 07:26:54 read(4,
>> "\277\224\312\371\302\356\tJC{P\244#3\"2P\327*2Q5\372\206\262\20\\\373\226\262\21\316"...,
>> 4096) = 4096
>> 07:27:02 lseek(4, 1408506736640, SEEK_SET) = 1408506736640
>> 07:27:02 read(4,
>> "\352\3041\345\1\337p\263l;\354\377E[\17\350\235\260\r\344\265\337\3655\223E\216\226\376\263!\n"...,
>> 4096) = 4096
>> 07:27:08 lseek(4, 5948177264640, SEEK_SET) = 5948177264640
>> 07:27:08 read(4,
>> "\321}\226m;1\253Z\301f\205\235\25\201\334?\311AQN(\22!\23{\345\214Vi\240=y"...,
>> 4096) = 4096
>> 07:27:10 brk(0x8cf18e000)               = 0x8cf18e000
>> 07:27:14 lseek(4, 6408024879104, SEEK_SET) = 6408024879104
>> 07:27:14 read(4,
>> "\254n\fn\r\302$\t\213\231\256\2774\326\34\364\fY\v\365`*Br\354X\7T3J\243K"...,
>> 4096) = 4096
>> 07:27:21 lseek(4, 8640894586880, SEEK_SET) = 8640894586880
>> 07:27:21 read(4,
>> "3\372\24\357\3579\254\31\214L\rYrurj\376\250\352%\2\242\255\252\22\347XU\327\235\362\337"...,
>> 4096) = 4096
>> ^CProcess 4779 detached
>> 
>> Regards,
>> Alexander
>> 
>> On Tue, Aug 25, 2015 at 10:43 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>>> On Aug 25, 2015, at 9:30 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
>>>> 
>>>> Hi,
>>>> 
>>>> Recently I had to run fsck on 47TB ext4 partition backed by hardware
>>>> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
>>>> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
>>>> 100% of single CPU. It detected errors (and fixed them) but doesn't
>>>> finish yet.
>>>> 
>>>> Rescue disc is based on Debian 7.8.
>>>> kernel: 4.1.4-5
>>>> e2fsprogs: 1.42.5-1.1+deb7u1
>>>> 
>>>> Any suggestions?
>>> 
>>> Usually the only reason for e2fsck to run so long is because of
>>> duplicate block pass 1b/1c.
>>> 
>>> Having some of the actual output of e2fsck would allow us to give
>>> some useful advice.
>>> 
>>> The only thing I can offer is for you to run "strace -p <e2fsck_pid>"
>>> and/or "ltrace -p <e2fsck_pid>" to see what it is doing.
>>> 
>>> Cheers, Andreas
>>> 
>>> 
>>> 
>>> 
>>> 


Cheers, Andreas





