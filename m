From: Richard Kojedzinszky <krichy@tvnetwork.hu>
Subject: Re: minix/ext2 + rd problem
Date: Wed, 15 Oct 2008 10:19:44 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0810150943350.3259@krichy.tvnetwork.hu>
References: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu> <20081015041644.GA24613@wotan.suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from krichy.tvnetwork.hu ([80.95.68.194]:53924 "HELO
	krichy.tvnetwork.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751454AbYJOITr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Oct 2008 04:19:47 -0400
In-Reply-To: <20081015041644.GA24613@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dear nick,

i have tried a sync after the remount, but that did not help. what helped 
is dropping the cache by echoing 3 to /proc/sys/vm/drop_caches, but this 
still didnt solve the problem in 100%, only in 95% of the cases.

But when i read the device with
# dd if=/dev/ram0 iflag=direct ...
then it worked. I think this bypassed some caches, and thus read the 
actual data.

But a sad result is that I experienced with it, and only with ramdisk does 
it work as expected. for example with a logical volume it behaves in the 
wrong way.

thanks in advance,
Kojedzinszky Richard
TvNetWork Nyrt.
E-mail: krichy (at) tvnetwork [dot] hu
PGP: 0x24E79141
   Fingerprint = 6847 ECFF EF58 0C09 18A5  16CF 270F 0C6F 24E7 9141

On Wed, 15 Oct 2008, Nick Piggin wrote:

> Date: Wed, 15 Oct 2008 06:16:44 +0200
> From: Nick Piggin <npiggin@suse.de>
> To: Richard Kojedzinszky <krichy@tvnetwork.hu>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: minix/ext2 + rd problem
> 
> Hi,
> Thanks for reporting this.
>
> On Tue, Oct 14, 2008 at 04:43:55PM +0200, Richard Kojedzinszky wrote:
>> dear all,
>>
>> I got an embedded system, where I use ramdisk, minix on it as a filesystem
>> for /etc. With kernels 2.4 and with 2.6.19 kernels also, the following
>> code did exactly what i wanted, creating an image of the /etc without
>> unmounting it:
>>
>> # mount -o remount,ro /etc
>> # cat /dev/ram0 > /tmp/image
>> # mount -o remount,rw /etc
>>
>> And then I had a consistent image from /etc in /tmp/image.
>>
>> This worked still with kernel version 2.6.23.14, but nowadays i upgraded
>> to 2.6.26.2, and noticed that the little code didnt work anymore. I wrote
>> a simple test script for checking, and reproducing the issue, which is
>> also attached. Unfortunately this does not work with ext2 also.
>>
>> my linux version is:
>> Linux version 2.6.26 (root@krichy.tvnetwork.hu) (gcc version 4.2.4 (Debian
>> 4.2.4-3)) #27 SMP PREEMPT Tue Oct 14 15:19:30 CEST 2008
>>
>> i use debian lenny/sid.
>>
>> Were there any intended change that made this behaviour change or was it
>> by an accident?
>
> That shouldn't have been changed on purpose, unless it is doing something
> funny that worked by accident before.
>
> /dev/ram will behave much more like any other block device now (with brd)
> wheras previously it was probably more coherent between filesystem and
> block device node. Hmm, does all the filesystems cache get written back
> before remount ro return?
>
> Could you try sticking a sync after remount,ro?
>
> Thanks,
> Nick
>
