From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Fri, 25 Apr 2008 16:09:36 +0200
Message-ID: <20080425140936.GA19602@elf.ucw.cz>
References: <20080422095315.GA28014@elte.hu> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org> <4811090A.9030809@gmail.com> <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org> <48112C74.8000405@gmail.com> <alpine.LFD.1.10.0804241633040.2779@woody.linux-foundation.org> <481189E2.9050005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59555 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYDYOJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 10:09:03 -0400
Content-Disposition: inline
In-Reply-To: <481189E2.9050005@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> core 2 duo, 2gigs of mem, 2 sata II disks, raid0, raid1 (both 0.9), lvm2, 
> ext3 above all of it.
>
> Modules:
> Module                  Size  Used by
> tun                    11012  1 	<----- Using vpn!
> bitrev                  2240  1 tun
> ipv6                  269736  36
> arc4                    2432  2
> ecb                     3584  2
> crypto_blkcipher       18052  1 ecb
> cryptomgr               3712  0
> crypto_algapi          15872  4 arc4,ecb,crypto_blkcipher,cryptomgr
> ath5k                 104640  0
> mac80211              140240  1 ath5k
> crc32                   4416  2 tun,mac80211
> sr_mod                 15748  0
> rtc_cmos               10232  0
> rtc_core               17220  1 rtc_cmos
> floppy                 64488  0
> cfg80211               27920  2 ath5k,mac80211
> cdrom                  37800  1 sr_mod
> ohci1394               31412  0
> rtc_lib                 3328  1 rtc_core
> ieee1394               90808  1 ohci1394
> evdev                  11584  5
> usbhid                 49952  0
> hid                    73664  1 usbhid
> ff_memless              6088  1 usbhid
> ehci_hcd               37388  0

One useful trick is trying to boot with init=/bin/bash, and see if the
problem persists. If it is gone, it is likely one of the modules, and
those may be binary-searched -- which is often easier than bisect.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
