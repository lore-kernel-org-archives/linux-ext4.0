From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s limitation/bug?
Date: Sun, 28 Feb 2010 09:26:44 -0500
Message-ID: <4B8A7D24.5040404@tmr.com>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan> <20100228080100.092c24c2@notabene.brown> <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan> <4B89B44A.70005@tmr.com> <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:35017 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968155Ab0B1O1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Feb 2010 09:27:03 -0500
In-Reply-To: <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Piszcz wrote:
>
>
> On Sat, 27 Feb 2010, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>>
>>>
>>> On Sun, 28 Feb 2010, Neil Brown wrote:
>>>
>>>> On Sat, 27 Feb 2010 08:47:48 -0500 (EST)
>>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I have two separate systems and with ext4 I cannot get speeds 
>>>>> greater than
>>>>> ~350MiB/s when using ext4 as the filesystem on top of a raid5 or 
>>>>> raid0.
>>>>> It appears to be a bug with ext4 (or its just that ext4 is slower 
>>>>> for this
>>>>> test)?
>>>>>
>>>>> Each system runs 2.6.33 x86_64.
>>>>
>>>> Could be related to the recent implementation of IO barriers in md.
>>>> Can you try mounting your filesystem with
>>>>   -o barrier=0
>>>>
>>>> and see how that changes the result.
>>>>
>>>> NeilBrown
>>>
>>> Hi Neil,
>>>
>>> Thanks for the suggestion, it has been used here:
>>> http://lkml.org/lkml/2010/2/27/66
>>>
>>> Looks like an EXT4 issue as XFS does ~600MiB/s..?
>>>
>>> Its strange though, on a single hard disk, I get approximately the 
>>> same speed for XFS and EXT4, but when it comes to scaling across 
>>> multiple disks,
>>> in RAID-0 or RAID-5 (tested), there is a performance problem as it 
>>> hits a
>>> performance problem at ~350MiB/s.  I tried multiple chunk sizes but 
>>> nothing
>>> seemed to made a difference (whether 64KiB or 1024KiB), XFS performs at
>>> 500-600MiB/s no matter what and EXT4 does not exceed ~350MiB/s.
>>>
>>> Is there anyone on any of the lists that gets > 350MiB/s on a 
>>> mdadm/sw raid
>>> with EXT4?
>>>
>>> A single raw disk, no partitions:
>>> p63:~# dd if=/dev/zero of=/dev/sdm bs=1M count=10240
>>> 10240+0 records in
>>> 10240+0 records out
>>> 10737418240 bytes (11 GB) copied, 92.4249 s, 116 MB/s
>>
>> I hate to say it, but I don't think this measures anything useful. 
>> When I was doing similar things I got great variabilty in my results 
>> until I learned about the fdatasync option so you measure the actual 
>> speed to the destination and not the disk cache. After that my 
>> results were far slower and reproducible.
>
> fdatasync:
> http://lkml.indiana.edu/hypermail/linux/kernel/1002.3/01507.html
>
I wasn't expecting a huge change in value, your data size is large. But 
thanks, the total time without sync can be off by at least seconds, 
making it hard to duplicate results. You missed nothing this time.

Did you use any of the options with ext4? I found about 15-20% with 
options, but I didn't take good enough notes to quote now. :-(
That doesn't mean there wasn't more, I tested on FC9, ext4 was 
experimental then.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

