From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Data integrity built into the storage stack
Date: Tue, 01 Sep 2009 01:19:49 -0400
Message-ID: <yq1hbvntf62.fsf@sermon.lab.mkp.net>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:59381 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZIAFTx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 01:19:53 -0400
In-Reply-To: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com>
	(Greg Freemyer's message of "Sat, 29 Aug 2009 17:23:50 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> We already have the scsi data integrity patches that went in last
Greg> winter and I believe fit into the storage stack below the
Greg> filesystem layer.

The filesystems can actually use it.  It's exposed at the bio level.


Greg> I do believe there is a patch floating around for device mapper to
Greg> add some integrity capability.

The patch is in mainline.  It allows passthrough so the filesystems can
access the integrity features.  But DM itself doesn't use any of them,
it merely acts as a conduit.

DIF is inherently tied to storage device's logical blocks.  These are
likely to be smaller than the blocks we're interested in protecting.
However, you could conceivably use the application tag space to add a
checksum with filesystem or MD/DM blocking size granularity.  All the
hooks are there.

The application tag space is pretty much only available on disk
drives--array vendors use it for internal purposes.  But in the MD/DM
case we're likely to run on raw disk so that's probably ok.

That said, I really think btrfs is the right answer to many of the
concerns raised in this thread.  Everything is properly checksummed and
can be verified at read time.

The strength of DIX/DIF is that we can detect corruption at write time
while we still have the buffer we care about write sitting in memory.

So btrfs and DIX/DIF go hand in hand as far as I'm concerned.  They
solve different problems but both are squarely aimed at preventing
silent data corruption.

I do agree that we do have to be more prepared for collateral damage
scenarios.  As we discussed at LS we have 4KB drives coming out that can
invalidate previously acknowledged I/Os if it gets a subsequent write
failure on a sector.  And there's also the issue of fractured writes
when talking to disk arrays.  That's really what my I/O topology changes
were all about: Correctness.  The fact that they may increase
performance is nice but that was not the main motivator.

-- 
Martin K. Petersen	Oracle Linux Engineering
