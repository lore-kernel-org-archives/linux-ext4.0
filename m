From: Nick Piggin <npiggin@suse.de>
Subject: Re: minix/ext2 + rd problem
Date: Wed, 15 Oct 2008 16:34:25 +0200
Message-ID: <20081015143425.GA2316@wotan.suse.de>
References: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu> <20081015041644.GA24613@wotan.suse.de> <alpine.DEB.1.10.0810150943350.3259@krichy.tvnetwork.hu> <20081015140523.GA30641@wotan.suse.de> <alpine.DEB.1.10.0810151609230.21953@krichy.tvnetwork.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Richard Kojedzinszky <krichy@tvnetwork.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:39249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYJOOep (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 10:34:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810151609230.21953@krichy.tvnetwork.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 15, 2008 at 04:10:08PM +0200, Richard Kojedzinszky wrote:
> Dear Nick,
> 
> Sorry for my stupid question, but how can i flush a blockdev? If i can 
> do it without unmounting the fs i will be happy.
> 
> Thanks in advance,

Not a stupid question. Actually I meant that maybe the kernel should do
the flush so people don't get surprised like this.

You can flush and invalidate the blockdev with the --flushbufs argument
to blockdev command. However you can't use this with ramdisk devices:
someone thought it would be a good idea to save on precious ioctl space
and implemented totally different semantics on that device with the
same ioctl (it throws away the underlying data as well as the cache).

Your direct io reads essentially do the same thing (and the kernel flushes
the cache in that case to avoid a similar aliasing problem). Actually I
would say direct IO to the block device is the safest option when you are
working on the block device like this (does the direct IO read work for
logical volumes?)

Thanks,
Nick

> 
> 
> Kojedzinszky Richard
> TvNetWork Nyrt.
> E-mail: krichy (at) tvnetwork [dot] hu
> PGP: 0x24E79141
>   Fingerprint = 6847 ECFF EF58 0C09 18A5  16CF 270F 0C6F 24E7 9141
> 
> On Wed, 15 Oct 2008, Nick Piggin wrote:
> 
> >Date: Wed, 15 Oct 2008 16:05:23 +0200
> >From: Nick Piggin <npiggin@suse.de>
> >To: Richard Kojedzinszky <krichy@tvnetwork.hu>
> >Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> >Subject: Re: minix/ext2 + rd problem
> >
> >On Wed, Oct 15, 2008 at 10:19:44AM +0200, Richard Kojedzinszky wrote:
> >>dear nick,
> >>
> >>i have tried a sync after the remount, but that did not help. what helped
> >>is dropping the cache by echoing 3 to /proc/sys/vm/drop_caches, but this
> >>still didnt solve the problem in 100%, only in 95% of the cases.
> >>
> >>But when i read the device with
> >># dd if=/dev/ram0 iflag=direct ...
> >>then it worked. I think this bypassed some caches, and thus read the
> >>actual data.
> >>
> >>But a sad result is that I experienced with it, and only with ramdisk does
> >>it work as expected. for example with a logical volume it behaves in the
> >>wrong way.
> >
> >I've reproduced this problem (ext2 image corruption flagged in e2fsck
> >even though it was remounted ro and marked clean in the sb).
> >
> >Issuing a sync, then drop_caches, seems to fix it here for me.
> >
> >On the other hand, I also see problems with inconsistencies even after
> >unmounting if I hold the /dev/ram0 device open with something else (which
> >causes the buffer cache not to be invalidated on unmount).
> >
> >I think what is happening is that the block device is being modified
> >without going through the buffer cache (ie. via pagecache or direct
> >writes), but the buffer cache doesn't get invalidated. So you get stale
> >data when reading from /dev/ram0.
> >
> >I don't think we're going to want the overhead in the kernel to detect
> >these kinds of aliases. It might be reasonable to flush the blockdev
> >on unmount and remount,ro after syncing the filesystem.
> >
> >The old rd driver's backing store was actually its buffercache, so that
> >particular issue wouldn't cause aliasing.
> >
> >Thanks,
> >Nick
> >
