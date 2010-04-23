From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4 benchmark questions
Date: Fri, 23 Apr 2010 11:45:40 -0400
Message-ID: <4BD1C0A4.6070102@redhat.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>	 <4BD0C50A.5050508@redhat.com>	 <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>	 <4BD0CBBF.1060300@redhat.com> <4BD1B1CA.5050502@redhat.com> <k2n1f4ef0971004230838w8bfe6b2w41d9a68bf6bda9ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Steve Brown <sbrown25@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721Ab0DWPpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Apr 2010 11:45:42 -0400
In-Reply-To: <k2n1f4ef0971004230838w8bfe6b2w41d9a68bf6bda9ee@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/23/2010 11:38 AM, Steve Brown wrote:
>>>>> not expected by me; barriers == drive write cache flushes, which I
>>>>> would never expect to speed things up...
>>>>>
>>>>>            
>>>> hmmm... this would seem to conflict with the docs in the kernel,
>>>> especially:
>>>>
>>>> "Write barriers enforce proper on-disk ordering
>>>> of journal commits, making volatile disk write caches
>>>> safe to use, at some performance penalty.  If
>>>> your disks are battery-backed in one way or another,
>>>> disabling barriers may safely improve performance."
>>>>
>>>>          
>>> what you saw is in conflict with what is expected, yes; I don't know
>>> why barriers would ever increase performance.
>>>
>>> (my description of barriers as drive write caches isn't in conflict
>>> with the docs, I just said how they're implemented)
>>>
>>>        
>> Barriers when working should never make things faster, at best, we should
>> have parity.
>>
>> Also important to note that barriers should be disabled if you hardware RAID
>> card exports itself as a "write through" cache, even if you enable barriers
>> on the command line.
>>
>> What controller are you using and what kind of drives do you have in the
>> back end?
>>      
> Thats good to know about the write barriers with WT cache.  I'm still
> setting everything manually in /etc/fstab because, well... I don't
> always trust software. ;)
>
> The controller is an LSI 9280-8e (megaraid_sas kernel module).  Drives
> are 1TB Seagate ES.2s, 16 of them in the chassis.
>
> Steve
>
>    

If you have the boot time log messages for the disks you use, you can 
see how the cache is advertised to the kernel.

Also note that having battery backed RAID cards does not mean that your 
drive's write cache will survive a power outage. You need to use vendor 
specific tools usually to poke at the drives and make sure that the 
write cache on the S-ATA disks is properly disabled (unless the LSI 
firmware does something to manage the write cache on the drives).

Thanks!

Ric


