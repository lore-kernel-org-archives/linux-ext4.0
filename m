From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 16:03:18 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251600280.28411@asgard.lang.hm>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz>
 <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz> <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:39378 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbZHYXEO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 19:04:14 -0400
In-Reply-To: <20090825225114.GE4300@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Aug 2009, Pavel Machek wrote:

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

the block device can loose data, it has absolutly nothing to do with the 
filesystem

>>> "ext3 works on flash and MD RAID5, as long as you do not have
>>> powerfail" seems to be the accurate statement, and if you don't need
>>> to protect against powerfails, you can just use ext2.
>>
>> Strange how your personal preference is totally out of sync with the
>> entire enterprise class user base.
>
> Perhaps noone told them MD RAID5 is dangerous? You see, that's exactly
> what I'm trying to document here.

a MD raid array that's degraded to the point where there is no redundancy 
is dangerous, but I don't think that any of the enterprise users would be 
surprised.

I think they will be surprised that it's possible that a prior failed 
write that hasn't been scrubbed can cause data loss when the array later 
degrades.

David Lang
