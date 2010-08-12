From: Adam Huffman <bloch@verdurin.com>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 15:51:30 +0100
Message-ID: <20100812145130.GD2699@asrockhome.verdurin.salon>
References: <20100812091635.GC2699@asrockhome.verdurin.salon>
 <4C63FA81.8060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 87-194-100-54.bethere.co.uk ([87.194.100.54]:50000 "EHLO
	asrockhome.verdurin.salon" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754059Ab0HLOvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 10:51:46 -0400
Content-Disposition: inline
In-Reply-To: <4C63FA81.8060306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 12, 2010 at 09:43:29AM -0400, Eric Sandeen wrote:
> 
> > I've made a 15TB logical volume on a 21TB RAID6 iSCSI array.
> > 
> > When I try to make an ext4 filesystem I see the following error:
> > 
> > mke4fs -E stride=32 stripe-width=384 -i 65536 -j -v \
> > /dev/mapper/vg2md3000isata-homes2 
> > 
> > mke4fs 1.41.9 (22-Aug-2009)
> > mke4fs: invalid blocks count - /dev/mapper/vg2md3000isata-homes2
> 
> 
> You're not specifying the -E options correctly:
> 
> [root@host e2fsprogs]# misc/mke2fs.static -t ext4 -E stride=32 stripe-width=384 /mnt/test2/testdir/bigfile 
> mke2fs 1.41.12 (17-May-2010)
> mke2fs.static: invalid blocks count - /mnt/test2/testdir/bigfile
> 
> This works - you need comma-separated -E options:
> 
> [root@host e2fsprogs]# mke4fs -E stride=32,stripe-width=384 /mnt/test2/testdir/bigfile 
> mke4fs 1.41.12 (17-May-2010)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=32 blocks, Stripe width=384 blocks
> 1006632960 inodes, 4026531840 blocks
> ...
> 
> Without the comma, mkfs thinks you are trying to mkfs a device called
> "stripe-width=384" with a block count of "<devicename>"
> 
> Odd eh ;)
> 

Yes, thanks for that.  It's happy now.

> Perhaps echoing back the blocks count which it found to be invalid
> (in this case the devicename string) would make the failure more
> obvious...
> 

Perhaps it could check for a clearly non-numeric input and report that?
Or maybe it's just me who'd do such a thing...


> 
> > When i searched briefly yesterday, some documentation stated that the
> > filesystem limit was now 16TB, and some that the limit was much higher.
> 
> Yep that should work.
> 

Looking at
https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/521648,
specifically Ted's comment, is it correct that 64-bit blocks support is
still at the early development stage?

Adam


> -Eric
>  
> > The system is running Centos 5.5, e4fsprogs-1.41.9-3.el5.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
