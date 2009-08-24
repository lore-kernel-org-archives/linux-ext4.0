From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Mon, 24 Aug 2009 16:42:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908241638551.28411@asgard.lang.hm>
References: <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz>
 <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <4A930EB9.8030903@redhat.com> <4A93129E.6080704@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:59061 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZHXXnc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 19:43:32 -0400
In-Reply-To: <4A93129E.6080704@acm.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Aug 2009, Zan Lynx wrote:

> Ric Wheeler wrote:
>> Pavel Machek wrote:
>>> Degraded MD RAID5 does not work by design; whole stripe will be
>>> damaged on powerfail or reset or kernel bug, and ext3 can not cope
>>> with that kind of damage. [I don't see why statistics should be
>>> neccessary for that; the same way we don't need statistics to see that
>>> ext2 needs fsck after powerfail.]
>>>                                     Pavel
>>> 
>> What you are describing is a double failure and RAID5 is not double failure 
>> tolerant regardless of the file system type....
>
> Are you sure he isn't talking about how RAID must write all the data chunks 
> to make a complete stripe and if there is a power-loss, some of the chunks 
> may be written and some may not?

q write to raid 5 doesn't need to write to all drives, but it does need to 
write to two drives (the drive you are modifying and the parity drive)

if you are not degraded and only suceed on one write you will detect the 
corruption later when you try to verify the data.

if you are degraded and only suceed on one write, then the entire stripe 
gets corrupted.

but this is a double failure (one drive + unclean shutdown)

if you have battery-backed cache you will finish the writes when you 
reboot.

if you don't have battery-backed cache (or are using software raid and 
crashed in the middle of sending the writes to the drive) you loose, but 
unless you disable write buffers and do sync writes (which nobody is going 
to do because of the performance problems) you will loose data in an 
unclean shutdown anyway.

David Lang

> As I read Pavel's point he is saying that the incomplete write can be 
> detected by the incorrect parity chunk, but degraded RAID-5 has no working 
> parity chunk so the incomplete write would go undetected.
>
> I know this is a RAID failure mode. However, I actually thought this was a 
> problem even for a intact RAID-5. AFAIK, RAID-5 does not generally read the 
> complete stripe and perform verification unless that is requested, because 
> doing so would hurt performance and lose the entire point of the RAID-5 
> rotating parity blocks.
>
>
