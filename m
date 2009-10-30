From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
 with 	2.6.32-rc1 and upwards]
Date: Fri, 30 Oct 2009 12:13:02 -0500
Message-ID: <4AEB1E9E.9020408@redhat.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>	 <4AEB02F0.5040309@redhat.com> <1256916681.3145.8.camel@mini>	 <4AEB10DF.6090106@redhat.com> <1256921545.3145.51.camel@mini>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Ted Augustine <taugustine@techpathways.com>,
	linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbZJ3RNM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Oct 2009 13:13:12 -0400
In-Reply-To: <1256921545.3145.51.camel@mini>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alexey Fisher wrote:
> Am Freitag, den 30.10.2009, 11:14 -0500 schrieb Eric Sandeen:
>> Alexey Fisher wrote:
>>> Am Freitag, den 30.10.2009, 10:14 -0500 schrieb Eric Sandeen:
>> ...
>>
>>>> After a little brief digging I'm not sure when the xfs mount option went 
>>>> in or why...
>>>>
>>>> But for both
>>>>
>>>> xfs: mount -o ro,norecovery
>>>>
>>>> and
>>>>
>>>> ext[34]: mount -o ro,noload
>>>>
>>>> I don't think either one should touch the disk.
>>>>
>>>> Also, both should skip journal replay if you set the block device 
>>>> readonly prior to mount (hdparm -r can do this).
>>> Interesting tip, thank you.
>>> But there is some problems:
>>> 1. "hdparm -r" will set complete drive to ro mode. This is bad if i
>>> use /dev/sda1 for root and /dev/sda5 need to be forced readonly.
>> So point it at the partition not the drive:
>>
>> [root@neon ~]# hdparm -r 1 /dev/sda1
>>
>> /dev/sda1:
>>   setting readonly to 1 (on)
>>   readonly      =  1 (on)
>> [root@neon ~]# hdparm -r /dev/sda2
>>
>> /dev/sda2:
>>   readonly      =  0 (off)
>>
>> It doesn't change the hardware, it sets a flag on the kernel's block 
>> device structure.
> 
> ok, got it. Every day learning something new.
> It was not clear for me, after i read man hdparm: "Get/set read-only
> flag for the device.  When set,  Linux  disallows write operations on
> the device."
> 
>>> 2. the fact xfs and ext[3,4] use different options for true_ro make
>>> things complicated.
>> the hazards of being an open source sysadmin I guess.
> 
> :( are there any plans to unify mount options?

Some of this gets done; barrier options now match across xfs & ext4, I'm 
actually just writing a patch for ext3.

Doing the same for noload/norecovery would be pretty trivial.

>>> 3. the definition of ro is broken.
>> depends on what you mean by ro.  A user can only read from the 
>> filesystem so it is accurate in that respect.  Is "ro" for the fs or the 
>> bdev?  Semantic differences but not necessarily broken.
> 
> Hmm... bdev. any chance to do temporary recovery and load it as external
> journal if ro used? Anyway, you already pointed me to hdparm, so i can
> use it too.

There were patches floated to in-ram recovery for those blocks so that 
you could have a consistent fs w/o touching the disk but it didn't seem 
to get far.

>>> 4. many frustrated admins who mounted part of raid1 only with "-o ro"
>> Dunno what you mean by that ...
> 
> raid1 is down, so you need for some reasons to mount ro only one disk of
> the array. Needed to do it for short time (i used -o ro), now i know
> this probably was a bad idea (bad me, should read documentation). Need
> to check my raid now.  Suddenly i'm not alone who doing this :(


oh I see.  Yup....

-Eric
