From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 19:40:50 -0400
Message-ID: <4A947682.2010204@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932670AbZHYXlW@vger.kernel.org>
In-Reply-To: <20090825232601.GF4300@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/25/2009 07:26 PM, Pavel Machek wrote:
>
>>>> Basically, any file system (Linux, windows, OSX, etc) that writes into
>>>> the page cache will lose data when you hot unplug its storage. End of
>>>> story, don't do it!
>>>
>>> No, not ext3 on SATA disk with barriers on and proper use of
>>> fsync(). I actually tested that.
>>>
>>> Yes, I should be able to hotunplug SATA drives and expect the data
>>> that was fsync-ed to be there.
>>
>> You can and will lose data (even after fsync) with any type of storage at
>> some rate. What you are missing here is that data loss needs to be
>> measured in hard numbers - say percentage of installed boxes that have
>> config X that lose data.
>
> I'm talking "by design" here.
>
> I will lose data even on SATA drive that is properly powered on if I
> wait 5 years.
>

You are dead wrong.

For RAID5 arrays, you assume that you have a hard failure and a power outage 
before you can rebuild the RAID (order of hours at full tilt).

The failure rate of S-ATA drives is at the rate of a few percentage of the 
installed base in a year. Some drives will fail faster than that (bad parts, bad 
environmental conditions, etc).

Why don't you hold all of your most precious data on that single S-ATA drive for 
five year on one box and put a second copy on a small RAID5 with ext3 for the 
same period?

Repeat experiment until you get up to something like google scale or the other 
papers on failures in national labs in the US and then we can have an informed 
discussion.


>> I can promise you that hot unplugging and replugging a S-ATA drive will
>> also lose you data if you are actively writing to it (ext2, 3, whatever).
>
> I can promise you that running S-ATA drive will also lose you data,
> even if you are not actively writing to it. Just wait 10 years; so
> what is your point?

I lost a s-ata drive 24 hours after installing it in a new box. If I had MD5 
RAID5, I would not have lost any.

My point is that you fail to take into account the rate of failures of a given 
configuration and the probability of data loss given those rates.

>
> But ext3 is _designed_ to preserve fsynced data on SATA drive, while
> it is _not_ designed to preserve fsynced data on MD RAID5.

Of course it will when you properly configure your MD RAID5.

>
> Do you really think that's not a difference?

I think that you are simply wrong.

>
>>>>>> I don't object to making that general statement - "Don't hot unplug a
>>>>>> device with an active file system or actively used raw device" - but
>>>>>> would object to the overly general statement about ext3 not working on
>>>>>> flash, RAID5 not working, etc...
>>>>>
>>>>> You can object any way you want, but running ext3 on flash or MD RAID5
>>>>> is stupid:
>>>>>
>>>>> * ext2 would be faster
>>>>>
>>>>> * ext2 would provide better protection against powerfail.
>>>>
>>>> Not true in the slightest, you continue to ignore the ext2/3/4 developers
>>>> telling you that it will lose data.
>>>
>>> I know I will lose data. Both ext2 and ext3 will lose data on
>>> flashdisk. (That's what I'm trying to document). But... what is the
>>> benefit of ext3 journaling on MD RAID5? (On flash, ext3 at least
>>> protects you against kernel panic. MD RAID5 is in software, so... that
>>> additional protection is just not there).
>>
>> Faster recovery time on any normal kernel crash or power outage.  Data
>> loss would be equivalent with or without the journal.
>
> No, because you'll actually repair the ext2 with fsck after the kernel
> crash or power outage. Data loss will not be equivalent; in particular
> you'll not lose data writen _after_ power outage to ext2.
> 									Pavel


As Ted (who wrote fsck for ext*) said, you will lose data in both.  Your 
argument is not based on fact.

You need to actually prove your point, not just state it as fact.

ric
