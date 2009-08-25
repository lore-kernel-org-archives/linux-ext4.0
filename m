From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 01:26:01 +0200
Message-ID: <20090825232601.GF4300@elf.ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbZHYX0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 19:26:10 -0400
Content-Disposition: inline
In-Reply-To: <4A946DD1.8090906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>>> Basically, any file system (Linux, windows, OSX, etc) that writes into
>>> the page cache will lose data when you hot unplug its storage. End of
>>> story, don't do it!
>>
>> No, not ext3 on SATA disk with barriers on and proper use of
>> fsync(). I actually tested that.
>>
>> Yes, I should be able to hotunplug SATA drives and expect the data
>> that was fsync-ed to be there.
>
> You can and will lose data (even after fsync) with any type of storage at 
> some rate. What you are missing here is that data loss needs to be 
> measured in hard numbers - say percentage of installed boxes that have 
> config X that lose data.

I'm talking "by design" here.

I will lose data even on SATA drive that is properly powered on if I
wait 5 years.

> I can promise you that hot unplugging and replugging a S-ATA drive will 
> also lose you data if you are actively writing to it (ext2, 3, whatever).

I can promise you that running S-ATA drive will also lose you data,
even if you are not actively writing to it. Just wait 10 years; so
what is your point?

But ext3 is _designed_ to preserve fsynced data on SATA drive, while
it is _not_ designed to preserve fsynced data on MD RAID5.

Do you really think that's not a difference?

>>>>> I don't object to making that general statement - "Don't hot unplug a
>>>>> device with an active file system or actively used raw device" - but
>>>>> would object to the overly general statement about ext3 not working on
>>>>> flash, RAID5 not working, etc...
>>>>
>>>> You can object any way you want, but running ext3 on flash or MD RAID5
>>>> is stupid:
>>>>
>>>> * ext2 would be faster
>>>>
>>>> * ext2 would provide better protection against powerfail.
>>>
>>> Not true in the slightest, you continue to ignore the ext2/3/4 developers
>>> telling you that it will lose data.
>>
>> I know I will lose data. Both ext2 and ext3 will lose data on
>> flashdisk. (That's what I'm trying to document). But... what is the
>> benefit of ext3 journaling on MD RAID5? (On flash, ext3 at least
>> protects you against kernel panic. MD RAID5 is in software, so... that
>> additional protection is just not there).
>
> Faster recovery time on any normal kernel crash or power outage.  Data 
> loss would be equivalent with or without the journal.

No, because you'll actually repair the ext2 with fsck after the kernel
crash or power outage. Data loss will not be equivalent; in particular
you'll not lose data writen _after_ power outage to ext2.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
