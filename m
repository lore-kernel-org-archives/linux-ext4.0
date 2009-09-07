From: Pavel Machek <pavel@ucw.cz>
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe
	width, writes in storage
Date: Mon, 7 Sep 2009 13:45:34 +0200
Message-ID: <20090907114534.GP23450@elf.ucw.cz>
References: <20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca> <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com> <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com> <m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZIGLpj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 07:45:39 -0400
Content-Disposition: inline
In-Reply-To: <4A9FCF6B.1080704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> Note that even without MD raid, the file system issues IO's in file 
> system block size (4096 bytes normally) and most commodity storage 
> devices use a 512  byte sector size which means that we have to update 8 
> 512b sectors.
>
> Drives can (and do) have multiple platters and surfaces and it is 
> perfectly normal to have contiguous logical ranges of sectors map to 
> non-contiguous sectors physically. Imagine a 4KB write stripe that 
> straddles two adjacent tracks on one platter (requiring a seek) or mapped 
> across two surfaces (requiring a head switch). Also, a remapped sector 
> can require more or less a full surface seek from where ever you are to 
> the remapped sector area of the drive.

Yes, but ext3 was designed to handle the partial write  (according to
tytso).

> These are all examples that can after a power loss,  even a local 
> (non-MD) device,  do a partial update of that 4KB write range of
> sectors. 

Yes, but ext3 journal protects metadata integrity in that case.

> In other words, this is not just an MD issue, it is entirely possible 
> even with non-MD devices.
>
> Also, when you enable the write cache (MD or not) you are buffering 
> multiple MB's of data that can go away on power loss. Far greater (10x) 
> the exposure that the partial RAID rewrite case worries about.

Yes, that's what barriers are for. Except that they are not there on
MD0/MD5/MD6. They actually work on local sata drives...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
