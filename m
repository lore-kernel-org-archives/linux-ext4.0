From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 08:18:11 -0600
Message-ID: <20090918141811.GT2537@webber.adilger.int>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48356 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZIROSI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 10:18:08 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8IEIBcK002229
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 07:18:11 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ6000007IDKD00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 18 Sep 2009 07:18:11 -0700 (PDT)
In-reply-to: <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2009  02:13 -0400, Martin K. Petersen wrote:
> >>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:
> Eric> This is just a rough cut, due to the blkid header selection issues
> Eric> I mentioned earlier on the list.  It'll also need some config-fu
> Eric> to be sure we've got a blkid which has these calls, but with it in
> Eric> place, we'll finally have automatic selection of stride/stripe:
> 
> What about alignment?

As yet we don't handle wacky alignment.  For Lustre customers we tell them
not to create partition tables, but it would be nice to handle all of the
strange alignment issues internally.

> I know that in our friendly DM universe the volume will be aligned.  But
> what if the user does mkfs on /dev/sdX and the drive isn't naturally
> aligned?
> 
> How flexible is the extN on-disk format?  Can you pad and shift things
> if need be?

Not in sub-block offsets, which means that partition tables and drive
geometry, etc. should at least align on multiples of the blocksize,
and ideally multiples of the "minimum" IO size.

The mballoc allocator CAN handle non-power-of-two allocations, if the
geometry tells it the minimum/optimum IO size needs it, but as yet it
doesn't have an "offset" parameter.  It just assumes that block 0 is
aligned properly.  I suspect it wouldn't be hard to add this, though
to make it efficient it would require munging the buddy bitmaps.

> Also, are you guys affected by the previously-acked-sectors-are-now-gone
> problems with 512-byte logical/4KB physical drives?

Not that I'm aware of.  The ext4 journal commit block is below 512 bytes,
and virtually all ext4 filesystems are using 4kB blocks.  

Maybe that was XFS?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

