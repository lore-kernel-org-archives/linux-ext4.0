From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 00:41:54 +0200
Message-ID: <20090824224154.GH29763@elf.ucw.cz>
References: <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <4A930EB9.8030903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58480 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZHXWmB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 18:42:01 -0400
Content-Disposition: inline
In-Reply-To: <4A930EB9.8030903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>> I have to admit that I have not paid enough attention to this 
>>> specifics  of your ext3 + flash card issue - is it the ftl stuff 
>>> doing out of order  IO's?     
>>
>> The problem is that flash cards destroy whole erase block on unplug,
>> and ext3 can't cope with that.
>
> Even if you unmount the file system? Why isn't this an issue with
> ext2?

No, I'm talking hot unplug here. It is the issue with ext2, but ext2
will run fsck on next mount, making it less severe.


>>> Pull them even after an unmount, or pull them hot?
>>>     
>>
>> Pull them hot.
>>
>> [Some people try -osync to avoid data loss on flash cards... that will
>> not do the trick. Flashcard will still kill the eraseblock.]
>
> Pulling hot any device will cause data loss for recent data loss, even  
> with ext2 you will have data in the page cache, right?

Right. But in ext3 case you basically loose whole filesystem, because
fs is inconsistent and you did not run fsck.

>>> Again, you say RAID5 without enough specifics.  Are you pointing just 
>>> at  MD RAID5 on S-ATA? Hardware RAID cards? A specific commercial 
>>> RAID5 vendor?
>>>     
>>
>> Degraded MD RAID5 on anything, including SATA, and including
>> hypothetical "perfect disk".
>
> Degraded is one faulted drive while MD is doing a rebuild? And then you  
> hot unplug it or power cycle? I think that would certainly cause failure  
> for ext2 as well (again, you would lose any data in the page cache).

Losing data in page cache is expected. Losing fs consistency is not.

>> Degraded MD RAID5 does not work by design; whole stripe will be
>> damaged on powerfail or reset or kernel bug, and ext3 can not cope
>> with that kind of damage. [I don't see why statistics should be
>> neccessary for that; the same way we don't need statistics to see that
>> ext2 needs fsck after powerfail.]

> What you are describing is a double failure and RAID5 is not double  
> failure tolerant regardless of the file system type....

You get single disk failure then powerfail (or reset or kernel
panic). I would not call that double failure. I agree that it will
mean problems for most filesystems.

Anyway, even if that can be called a double failure, this limitation
should be clearly documented somewhere.

...and that's exactly what I'm trying to fix.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
