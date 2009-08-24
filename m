From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 00:44:27 +0200
Message-ID: <20090824224427.GI29763@elf.ucw.cz>
References: <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <4A930EB9.8030903@redhat.com> <4A93129E.6080704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48541 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZHXWoc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 18:44:32 -0400
Content-Disposition: inline
In-Reply-To: <4A93129E.6080704@acm.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 2009-08-24 16:22:22, Zan Lynx wrote:
> Ric Wheeler wrote:
>> Pavel Machek wrote:
>>> Degraded MD RAID5 does not work by design; whole stripe will be
>>> damaged on powerfail or reset or kernel bug, and ext3 can not cope
>>> with that kind of damage. [I don't see why statistics should be
>>> neccessary for that; the same way we don't need statistics to see that
>>> ext2 needs fsck after powerfail.]
>>>                                     Pavel
>>>   
>> What you are describing is a double failure and RAID5 is not double  
>> failure tolerant regardless of the file system type....
>
> Are you sure he isn't talking about how RAID must write all the data  
> chunks to make a complete stripe and if there is a power-loss, some of  
> the chunks may be written and some may not?
>
> As I read Pavel's point he is saying that the incomplete write can be  
> detected by the incorrect parity chunk, but degraded RAID-5 has no  
> working parity chunk so the incomplete write would go undetected.

Yep.

> I know this is a RAID failure mode. However, I actually thought this was  
> a problem even for a intact RAID-5. AFAIK, RAID-5 does not generally  
> read the complete stripe and perform verification unless that is  
> requested, because doing so would hurt performance and lose the entire  
> point of the RAID-5 rotating parity blocks.

Not sure; is not RAID expected to verify the array after unclean
shutdown?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
