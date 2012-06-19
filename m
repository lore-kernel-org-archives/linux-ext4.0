From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 16:09:48 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab2FSOJ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 10:09:58 -0400
In-Reply-To: <4FDF9EBE.2030809@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 18 Jun 2012, Spelic wrote:

> Date: Mon, 18 Jun 2012 23:33:50 +0200
> From: Spelic <spelic@shiftmail.org>
> To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
>     device-mapper development <dm-devel@redhat.com>
> Subject: Ext4 and xfs problems in dm-thin on allocation and discard
> 
> Hello all
> I am doing some testing of dm-thin on kernel 3.4.2 and latest lvm from source
> (the rest is Ubuntu Precise 12.04).
> There are a few problems with ext4 and (different ones with) xfs
> 
> I am doing this:
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync
> lvs
> rm zeroes #optional
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
> lvs
> rm zeroes #optional
> ...
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
> lvs
> rm zeroes
> fstrim /mnt/mountpoint
> lvs
> 
> On ext4 the problem is that it always reallocates blocks at different places,
> so you can see from lvs that space occupation in the pool and thinlv increases
> at each iteration of dd, again and again, until it has allocated the whole
> thin device (really 100% of it). And this is true regardless of me doing rm or
> not between one dd and the other.
> The other problem is that by doing this, ext4 always gets the worst
> performance from thinp, about 140MB/sec on my system, because it is constantly
> allocating blocks, instead of 350MB/sec which should have been with my system
> if it used already allocated regions (see below compared to xfs). I am on an
> MD raid-5 of 5 hdds.
> I could suggest to add a "thinp mode" mount option to ext4 affecting the
> allocator, so that it tries to reallocate recently used and freed areas and
> not constantly new areas. Note that mount -o discard does work and prevents
> allocation bloating, but it still always gets the worst write performances
> from thinp. Alternatively thinp could be improved so that block allocation is
> fast :-P (*)
> However, good news is that fstrim works correctly on ext4, and is able to drop
> all space allocated by all dd's. Also mount -o discard works.

I am happy to hear that discard actually works with ext4. Regarding
the performance problem, part of it has already been explained by
Dave and I agree with him.

With thin provisioning you'll get totally different file system
layout than on fully provisioned disk as you push more and more
writes to your drive. This unfortunately has great impact on
performance since file systems usually have a lot of optimization on
where to put data/metadata on the drive and how to read them.
However in case of thinly provisioned storage those optimization
would not help. And yes, you just have to expect lower performance
with dm-thin from the file system on top of it. It is not and it
will never be ideal solution for workloads where you expect the best
performance.

However optimization have to be done on dm and fs side and the work
is currently in progress and now when we have "cheap" thinp solution
I guess that the progress will by quite faster in that regard.

-Lukas

> 
> On xfs there is a different problem.
> Xfs apparently correctly re-uses the same blocks so that after the first write
> at 140MB/sec, subsequent overwrites of the same file are at full speed such as
> 350MB/sec (same speed as with non-thin lvm), and also you don't see space
> occupation going up at every iteration of dd, either with or without rm
> in-between the dd's. [ok actually now retrying it needed 3 rewrites to
> stabilize allocation... probably an AG count thing.]
> However the problem with XFS is that discard doesn't appear to work. Fstrim
> doesn't work, and neither does "mount -o discard ... + rm zeroes" . There is
> apparently no way to drop the allocated blocks, as seen from lvs. This is in
> contrast to what it is written here http://xfs.org/index.php/FITRIM/discard
> which declare fstrim and mount -o discard to be working.
> Please note that since I am above MD raid5 (I believe this is the reason), the
> passdown of discards does not work, as my dmesg says:
> [160508.497879] device-mapper: thin: Discard unsupported by data device
> (dm-1): Disabling discard passdown.
> but AFAIU, unless there is a thinp bug, this should not affect the unmapping
> of thin blocks by fstrimming xfs... and in fact ext4 is able to do that.
> 
> (*) Strange thing is that write performance appears to be roughly the same for
> default thin chunksize and for 1MB thin chunksize. I would have expected thinp
> allocation to be faster with larger thin chunksizes but instead it is actually
> slower (note that there are no snapshots here and hence no CoW). This is also
> true if I set the thinpool to not zero newly allocated blocks: performances
> are about 240 MB/sec then, but again they don't increase with larger
> chunksizes, they actually decrease slightly with very large chunksizes such as
> 16MB. Why is that?
> 
> Thanks for your help
> S.
> 
