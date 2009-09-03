From: Ric Wheeler <rwheeler@redhat.com>
Subject: wishful thinking about atomic, multi-sector or full MD stripe width,
 writes in storage
Date: Thu, 03 Sep 2009 10:15:07 -0400
Message-ID: <4A9FCF6B.1080704@redhat.com>
References: <20090828064449.GA27528@elf.ucw.cz>	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbZICOP6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 10:15:58 -0400
In-Reply-To: <m3ab1cnn7y.fsf@intrepid.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03/2009 09:59 AM, Krzysztof Halasa wrote:
> Ric Wheeler<rwheeler@redhat.com>  writes:
>
>> We (red hat) have all kinds of different raid boxes...
>
> A have no doubt about it, but are those you know equipped with
> battery-backed write-back cache? Are they using SATA disks?
>
> We can _at_best_ compare non-battery-backed RAID using SATA disks with
> what we typically have in a PC.

The whole thread above is about software MD using commodity drives (S-ATA or 
SAS) without battery backed write cache.

We have that (and I have it personally) and do test it.

You must disable the write cache on these commodity drives *if* the MD RAID 
level does not support barriers properly.

This will greatly reduce errors after a power loss (both in degraded state and 
non-degraded state), but it will not eliminate data loss entirely. You simply 
cannot do that with any storage device!

Note that even without MD raid, the file system issues IO's in file system block 
size (4096 bytes normally) and most commodity storage devices use a 512  byte 
sector size which means that we have to update 8 512b sectors.

Drives can (and do) have multiple platters and surfaces and it is perfectly 
normal to have contiguous logical ranges of sectors map to non-contiguous 
sectors physically. Imagine a 4KB write stripe that straddles two adjacent 
tracks on one platter (requiring a seek) or mapped across two surfaces 
(requiring a head switch). Also, a remapped sector can require more or less a 
full surface seek from where ever you are to the remapped sector area of the drive.

These are all examples that can after a power loss,  even a local (non-MD) 
device,  do a partial update of that 4KB write range of sectors. Note that 
unlike unlike RAID/MD, local storage has no parity on the server to detect this 
partial write.

This is why new file systems like btrfs and zfs do checksumming of data and 
metadata. This won't prevent partial updates during a write, but can at least 
detect them and try to do some kind of recovery.

In other words, this is not just an MD issue, it is entirely possible even with 
non-MD devices.

Also, when you enable the write cache (MD or not) you are buffering multiple 
MB's of data that can go away on power loss. Far greater (10x) the exposure that 
the partial RAID rewrite case worries about.

ric
