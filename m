From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Wed, 26 Aug 2009 00:51:14 +0200
Message-ID: <20090825225114.GE4300@elf.ucw.cz>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com>
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
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51326 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZHYWvW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 18:51:22 -0400
Content-Disposition: inline
In-Reply-To: <4A9468E8.607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



>>> I really think that the expectation that all OS's (windows, mac, even
>>> your ipod) all teach you not to hot unplug a device with any file system.
>>> Users have an "eject" or "safe unload" in windows, your iPod tells you
>>> not to power off or disconnect, etc.
>>
>> That was before journaling filesystems...
>
> Not true - that is true today with or without journals as we have 
> discussed in great detail. Including specifically ext2.
>
> Basically, any file system (Linux, windows, OSX, etc) that writes into 
> the page cache will lose data when you hot unplug its storage. End of 
> story, don't do it!

No, not ext3 on SATA disk with barriers on and proper use of
fsync(). I actually tested that.

Yes, I should be able to hotunplug SATA drives and expect the data
that was fsync-ed to be there.

>>> I don't object to making that general statement - "Don't hot unplug a
>>> device with an active file system or actively used raw device" - but
>>> would object to the overly general statement about ext3 not working on
>>> flash, RAID5 not working, etc...
>>
>> You can object any way you want, but running ext3 on flash or MD RAID5
>> is stupid:
>>
>> * ext2 would be faster
>>
>> * ext2 would provide better protection against powerfail.
>
> Not true in the slightest, you continue to ignore the ext2/3/4 developers 
> telling you that it will lose data.

I know I will lose data. Both ext2 and ext3 will lose data on
flashdisk. (That's what I'm trying to document). But... what is the
benefit of ext3 journaling on MD RAID5? (On flash, ext3 at least
protects you against kernel panic. MD RAID5 is in software, so... that
additional protection is just not there).

>> "ext3 works on flash and MD RAID5, as long as you do not have
>> powerfail" seems to be the accurate statement, and if you don't need
>> to protect against powerfails, you can just use ext2.
>
> Strange how your personal preference is totally out of sync with the 
> entire enterprise class user base.

Perhaps noone told them MD RAID5 is dangerous? You see, that's exactly
what I'm trying to document here.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
