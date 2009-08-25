From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 19:03:45 -0400
Message-ID: <4A946DD1.8090906@redhat.com>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz>
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090825225114.GE4300@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/25/2009 06:51 PM, Pavel Machek wrote:
>
>
>>>> I really think that the expectation that all OS's (windows, mac, even
>>>> your ipod) all teach you not to hot unplug a device with any file system.
>>>> Users have an "eject" or "safe unload" in windows, your iPod tells you
>>>> not to power off or disconnect, etc.
>>>
>>> That was before journaling filesystems...
>>
>> Not true - that is true today with or without journals as we have
>> discussed in great detail. Including specifically ext2.
>>
>> Basically, any file system (Linux, windows, OSX, etc) that writes into
>> the page cache will lose data when you hot unplug its storage. End of
>> story, don't do it!
>
> No, not ext3 on SATA disk with barriers on and proper use of
> fsync(). I actually tested that.
>
> Yes, I should be able to hotunplug SATA drives and expect the data
> that was fsync-ed to be there.

You can and will lose data (even after fsync) with any type of storage at some 
rate. What you are missing here is that data loss needs to be measured in hard 
numbers - say percentage of installed boxes that have config X that lose data.

Strangely enough, this is what high end storage companies do for a living, 
configure, deploy and then measure results.

A long winded way of saying that just because you can induce data failure by 
recreating an event that happens almost never (power loss while rebuilding a 
RAID5 group specifically) does not mean that this makes RAID5 with ext3 unreliable.

What does happen all of the time is single bad sector IO's and (less often, but 
more than your scenario) complete drive failures. In both cases, MD RAID5 will 
repair that damage before a second failure (including a power failure) happens 
99.99% of the time.

I can promise you that hot unplugging and replugging a S-ATA drive will also 
lose you data if you are actively writing to it (ext2, 3, whatever).

Your micro datah loss benchmark is not a valid reflection of the wider 
experience and I fear that you will cause people to lose more data, not less, 
but moving them away from ext3 and MD RAID5.

>
>>>> I don't object to making that general statement - "Don't hot unplug a
>>>> device with an active file system or actively used raw device" - but
>>>> would object to the overly general statement about ext3 not working on
>>>> flash, RAID5 not working, etc...
>>>
>>> You can object any way you want, but running ext3 on flash or MD RAID5
>>> is stupid:
>>>
>>> * ext2 would be faster
>>>
>>> * ext2 would provide better protection against powerfail.
>>
>> Not true in the slightest, you continue to ignore the ext2/3/4 developers
>> telling you that it will lose data.
>
> I know I will lose data. Both ext2 and ext3 will lose data on
> flashdisk. (That's what I'm trying to document). But... what is the
> benefit of ext3 journaling on MD RAID5? (On flash, ext3 at least
> protects you against kernel panic. MD RAID5 is in software, so... that
> additional protection is just not there).

Faster recovery time on any normal kernel crash or power outage.  Data loss 
would be equivalent with or without the journal.

>
>>> "ext3 works on flash and MD RAID5, as long as you do not have
>>> powerfail" seems to be the accurate statement, and if you don't need
>>> to protect against powerfails, you can just use ext2.
>>
>> Strange how your personal preference is totally out of sync with the
>> entire enterprise class user base.
>
> Perhaps noone told them MD RAID5 is dangerous? You see, that's exactly
> what I'm trying to document here.
> 								Pavel

Using MD RAID5 will save more people from commonly occurring errors (sector and 
disk failures) than will lose it because of your rebuild interrupted by a power 
failure worry.

What you are trying to do is to document a belief you have that is not born out 
by real data across actual user boxes running real work loads.

Unfortunately, getting that data is hard work and one of the things that we as a 
community do especially poorly.  All of the data (secret data from my past and 
published data by NetApp, Google, etc) that I have seen would directly 
contradict your assertions and you will cause harm to our users with this.

Ric


