From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Thu, 27 Aug 2015 17:23:58 +0300
Message-ID: <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
 <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca> <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36300 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbH0OYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2015 10:24:38 -0400
Received: by obkg7 with SMTP id g7so17257229obk.3
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2015 07:24:37 -0700 (PDT)
In-Reply-To: <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've restarted fsck ~6 hours ago. It's again occupied ~30GB RAM and
strace shows that number of syscalls per second becomes fewer and
fewer.

Regards,
Alexander

On Thu, Aug 27, 2015 at 8:28 AM, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> The last output (2 days ago) from fsck:
>
> [skipped]
> Block #524296 (1235508688) causes directory to be too big.  CLEARED.
> Block #524297 (4003498426) causes directory to be too big.  CLEARED.
> Block #524298 (3113378389) causes directory to be too big.  CLEARED.
> Block #524299 (1368545889) causes directory to be too big.  CLEARED.
> Too many illegal blocks in inode 4425477.
> Clear inode? yes
>
> ---------------------------
> iostat output:
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.00    0.00    0.00   14.52    0.00   85.48
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> loop0             0.00     0.00    2.00    0.00    12.00     0.00
> 12.00     0.09   46.00   46.00    0.00  46.00   9.20
> sda               0.00     0.00   87.00    0.00   348.00     0.00
> 8.00     1.00   11.86   11.86    0.00  11.45  99.60
>
> ---------------------------
> strace ouput:
>
> root@rescue ~ # strace -f -t -p 4779
> Process 4779 attached - interrupt to quit
> 07:26:54 lseek(4, 14154266963968, SEEK_SET) = 14154266963968
> 07:26:54 read(4,
> "\277\224\312\371\302\356\tJC{P\244#3\"2P\327*2Q5\372\206\262\20\\\373\226\262\21\316"...,
> 4096) = 4096
> 07:27:02 lseek(4, 1408506736640, SEEK_SET) = 1408506736640
> 07:27:02 read(4,
> "\352\3041\345\1\337p\263l;\354\377E[\17\350\235\260\r\344\265\337\3655\223E\216\226\376\263!\n"...,
> 4096) = 4096
> 07:27:08 lseek(4, 5948177264640, SEEK_SET) = 5948177264640
> 07:27:08 read(4,
> "\321}\226m;1\253Z\301f\205\235\25\201\334?\311AQN(\22!\23{\345\214Vi\240=y"...,
> 4096) = 4096
> 07:27:10 brk(0x8cf18e000)               = 0x8cf18e000
> 07:27:14 lseek(4, 6408024879104, SEEK_SET) = 6408024879104
> 07:27:14 read(4,
> "\254n\fn\r\302$\t\213\231\256\2774\326\34\364\fY\v\365`*Br\354X\7T3J\243K"...,
> 4096) = 4096
> 07:27:21 lseek(4, 8640894586880, SEEK_SET) = 8640894586880
> 07:27:21 read(4,
> "3\372\24\357\3579\254\31\214L\rYrurj\376\250\352%\2\242\255\252\22\347XU\327\235\362\337"...,
> 4096) = 4096
> ^CProcess 4779 detached
>
> Regards,
> Alexander
>
> On Tue, Aug 25, 2015 at 10:43 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On Aug 25, 2015, at 9:30 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
>>>
>>> Hi,
>>>
>>> Recently I had to run fsck on 47TB ext4 partition backed by hardware
>>> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
>>> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
>>> 100% of single CPU. It detected errors (and fixed them) but doesn't
>>> finish yet.
>>>
>>> Rescue disc is based on Debian 7.8.
>>> kernel: 4.1.4-5
>>> e2fsprogs: 1.42.5-1.1+deb7u1
>>>
>>> Any suggestions?
>>
>> Usually the only reason for e2fsck to run so long is because of
>> duplicate block pass 1b/1c.
>>
>> Having some of the actual output of e2fsck would allow us to give
>> some useful advice.
>>
>> The only thing I can offer is for you to run "strace -p <e2fsck_pid>"
>> and/or "ltrace -p <e2fsck_pid>" to see what it is doing.
>>
>> Cheers, Andreas
>>
>>
>>
>>
>>
