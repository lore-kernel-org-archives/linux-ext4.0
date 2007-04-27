From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Fri, 27 Apr 2007 14:33:11 -0600
Message-ID: <20070427203311.GI5967@schatzie.adilger.int>
References: <4631FD7F.9030008@bull.net> <20070427183345.GJ24852@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54293 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbXD0UdO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 16:33:14 -0400
Content-Disposition: inline
In-Reply-To: <20070427183345.GJ24852@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 27, 2007  14:33 -0400, Theodore Tso wrote:
> > Here are the results obtained with a not very fragmented 100-GB file:
> > 
> >                  |     ext3       ext4 + extents      xfs
> > ------------------------------------------------------------
> >  nb of fragments |     796             798             15
> >  elapsed time    |  2m0.306s        0m11.127s       0m0.553s
> >                  |
> >  blks read       |  206600            6416            352
> >  blks written    |   13592           13064            104
> > ------------------------------------------------------------
> 
> The metablockgroups feature should help the file fragmentation level
> with extents.  It's easy enough to enable this for ext4 (we just need
> to remove some checks in ext4_check_descriptors), so we should just do
> it.

I agree in this case that the META_BG feature would help here (100GB / 128MB
is in fact the 800 fragments shown), I don't think that is the major
performance hit.

The fact that we need to read 6000 blocks and write 13000 blocks is the
more serious part.  I assume that since there are only 800 fragments
there should be only 800 extents.  We can fit (4096 / 12 - 1) = 340
extents into each block, and 4 index blocks into the inode, so this
should allow all 800 extents in only 3 index blocks.  It would be useful
to know where those 6416 block reads are going in the extent case.

I suspect that is because the "tail first" truncation mechanism of ext3
causes it to zero out FAR more blocks than needed.  With extents and a
default 128MB journal we should be able to truncate + unlink a file with
only writes to the inode and the 800 bitmap + gdt blocks.  The reads should
also be limited to the bitmap blocks and extent indexes (gdt being read at
mount time).

What is needed is for truncate to walk the inode block tree (extents or
indirect blocks) and count the bitmaps + gdt blocks dirtied, and then try
and do the whole truncate under a single transaction.  That avoids any need
for truncate to be "restartable" and then there is no need to zero out the
indirect blocks from the end one-at-a-time.

Doing the bitmap read/write will definitely be more efficient with META_BG,
but that doesn't explain the other 19k blocks undergoing IO.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
