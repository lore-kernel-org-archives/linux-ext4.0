From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Tue, 02 Apr 2013 21:19:20 +0400
Message-ID: <87wqskrgtj.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304020955280.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48179 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761909Ab3DBRT0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 13:19:26 -0400
In-Reply-To: <alpine.DEB.2.10.1304020955280.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2 Apr 2013 09:58:46 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> On Tue, 2 Apr 2013 at 13:47, Dmitry Monakhov wrote:
> > Unfortunately it is like a regression which we missed
> > due to s390x and ppc is not well tested.
> 
> :-(
> 
> > Ohh that is sad. Unfortunately I can't reproduce this on my own
> > environment. I have power mac pro G5 but w/o graphics card, so i cant
> > install linux on it. If you know how to do that w/o monitor please let
> > me know.
> 
> Hm, w/o a graphics card..the only way to install any OS would be via a 
> serial line, I assume.
I've tried to use qemu but I can not even boot the kernel:
Preparing to boot Linux version 3.9.0-rc4 (root@dbuild4.qa.sw.ru) (gcc
version 4.4.5 (Debian 4.4.5-8) ) #6 Tue Apr 2 19:12:42 MSK 2013
Detected machine type: 00000400
command line: console=ttyS0,9600 console=tty0
memory layout at init:
  memory_limit : 00000000 (16 MB aligned)
  alloc_bottom : 0164d000
  alloc_top    : 20000000
  alloc_top_hi : 20000000
  rmo_top      : 20000000
  ram_top      : 20000000
found display   : /pci@80000000/QEMU,VGA@1, opening... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0164e000 -> 0x0164e4d7
Device tree struct  0x0164f000 -> 0x01651000
Calling quiesce...
returning from prom_init
Trying to write invalid spr 1015 3f7 at c0008bc0

Can anybody help me with simple thing
Build and boot kernel via qemu

> 
> > So you just do bunch of writes/mmap to fallocated area.
> > The only guess I have is that some bug in extent status tree
> 
> "writes/mmap to fallocated area" - this sounds like the exact thing this 
> bittorrent client is doing!
> 
> > Please run test with a patch which was posted here:
> > http://marc.info/?l=linux-kernel&m=136455173926544&w=2
> > This patch enable sanity checks for extent_status tree.
> > Also please try following patch. It voluntary disable es_lookup functionality.
> 
> I'll find a way to reproduce this first and then play around with those patches.
Probably all you need is just run fsstress
(https://github.com/dmonakhov/xfstests/blob/master/ltp/fsstress.c)
And run in like follows:
#fsstress -d $YOUR_PATH -p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 \
-f rename=30 -f stat=30 -f unlink=30 -f truncate=20 -n99999999
> 
> Thanks for your response,
> Christian.
> -- 
> BOFH excuse #415:
> 
> Maintenance window broken
