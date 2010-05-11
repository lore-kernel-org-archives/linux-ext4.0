From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: RE: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
	88f5182)
Date: Tue, 11 May 2010 16:44:47 +0530
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
References: <1273569821.21352.19.camel@pasglop>
 <1273575478.21352.29.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Nicolas Pitre <nico@marvell.com>,
	Saeed Bishara <saeed@marvell.com>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51069 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0EKLPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 May 2010 07:15:18 -0400
In-Reply-To: <1273575478.21352.29.camel@pasglop>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Benjamin Herrenschmidt
> Sent: Tuesday, May 11, 2010 4:28 PM
> To: linux-kernel@vger.kernel.org
> Cc: Nicolas Pitre; Saeed Bishara; James E.J. Bottomley; Andrew Morton; linux-ext4@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell 88f5182)
> 
> On Tue, 2010-05-11 at 19:23 +1000, Benjamin Herrenschmidt wrote:
> 
> > Since I doubt ext3 is busted so dramatically in mainline for "normal" machines,
> > I tend to suspect things could be related to the infamous vivt caches. On the
> > other hand, it's pretty clearly metadata or journal corruption and I'm not
> > sure we ever do things that could cause aliases (such as vmap etc..) on
> > these things, and they shouldn't be mapped into userspace... unless it's fsck
> > itself that causes aliases to occur at the block device level ? (I do unmount
> > though before I run fsck).
> >
> > On the other hand, it could also be a busticated marvell SATA driver :-)
> >
> > I have no problem with the vendor kernel, but it's ancient (2.6.12) and based
> > on an out of tree variant of a Marvell originated BSP, so everything is
> > completely different, especially in the area of drivers for the chipset.
> >
> > Anyways, I'll see if I can gather more data tomorrow as time, viruses and sick
> > kids permits.
> >
> > In the meantime, any hint appreciated.
> 
> A quick other test which brings more infos, using a smaller (about 5GB)
> partition and no md or raid involved:
> 
>  - Boot with NFS root
>  - mkfs /dev/sdb2 (no md or raid involved)
>  - mount /dev/sdb2 /mnt/test
>  - rsync -avx /test-stuff /mnt/test
>  - cd /mnt/test
>  - md5sum -c ~/test-stuff-sums.txt
> 
> That gives me a whole bunch of:
> 
> md5sum: ./usr/bin/debconf-escape: No such file or directory
> ./usr/bin/debconf-escape: FAILED open or read
> ./usr/bin/stat: OK
> md5sum: ./usr/bin/chrt: No such file or directory
> ./usr/bin/chrt: FAILED open or read
> 
> In fact, if I do ls /mnt/test/usr/bin/ I see debconf but if I do
> ls /mnt/test/usr/bin/chrt then I get No such file or directory.
> 
> So something is badly wrong :-)
> 
> Now, trying without the dir_index feature (mkfs.ext3 -O ^dir_index)
> and it works fine. All my md5sum's are correct and fsck passes.
> 
> So there's what looks like a problem specific to htree's. I don't think
> it's a SATA driver problem (doesn't smell like it but we can't
> completely dismiss the possibility yet). Could be a VIVT issue but then
> why ? I don't see ext3 playing with virtual mappings and none of that
> should alias with userspace...
> 
> Or is it incorrectly accessing pages while they are DMA'ed to or from ?
> IE. Accessing with the CPU pages between dma_map_* and dma_unmap_* ?
> That will break on a number of setups including swiotlb on x86 so I tend
> to doubt it but who knows...

Not sure if it is related but we saw similar issue with MMC driver on
Cortex-A9 MP core. I was seeing similar weird issues with EXT3 and 
everything use to be fine with EXT2.

All those errors you mentioned use to come and at times whole FS
Use to get corrupted.

It was root-caused to MMC driver which uses DMA engine for TX/RX. The
issue was mainly with writes and hence EXT3 was having issue which does
journaling and hence more writes.
There was a memory write barrier missing before the DMA descriptors 
are handed over to DMA controller.

Regards,
Santosh

