From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Sat, 12 May 2007 08:26:37 -0700
Message-ID: <20070512152637.GS6375@schatzie.adilger.int>
References: <20070512020248.GQ6375@schatzie.adilger.int> <1178957506.20145.41.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34108 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbXELPu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 May 2007 11:50:57 -0400
Content-Disposition: inline
In-Reply-To: <1178957506.20145.41.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 12, 2007  01:11 -0700, Eric wrote:
> The concept is really tempting. RAID is good, and not asking the user
> for information that the system can find out for itself is good too.
> 
> In the unlikely event that the RAID stride were to change, I think the
> autodetect-each-time method would be superior to the store-in-superblock
> method. Doubly so if the code to detect MD and LVM stride is lean and
> clean.

I've asked the block layer folks a couple of times if it would be possible
to have an interface for this in the kernel, but so far I've had little
success in getting them to do it and I don't have time for it myself.

I agree that auto-detection is best (would need a userspace interface too)
but a lot can be done with a format-time detection.  It is unlikely that
the RAID striping will change under the filesystem, and if it does then
the stripe size is usually kept the same (e.g. RAID 5 restriping to add
a disk).

Even if the stiping does change, the current alignment of bitmaps is
about the worst possible case for power-of-two stride sizes because a
single disk has all of the bitmaps (using the terms "stripe = N * stride"
for N+1 RAID5 or N+2 RAID6 - if anyone knows the "more correct" terms
please speak up).  It would also be possible to use tune2fs to change
the stride + stripe size in the superblock to at least tune the mballoc
allocation even if we can't move the bitmaps around very easily.

> I wonder if, in a RAID 0 configuration, deliberately misaligning data
> structures smaller than (size of stride * number of disks in array)
> would yield a performance benefit.

Yes, that would definitely be something to do.  If you have N-disk RAID0,
each disk having "stride" blocks at a time, then offsetting the bitmaps by
"stride" blocks each is exactly what "mke2fs -E stride=" does.  The
mballoc "stripe" option tries to put large allocations covering the whole
stripe to avoid parity read-modify-write if possible.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
