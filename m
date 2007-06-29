From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 16:24:55 -0500
Message-ID: <1183152295.12702.20.camel@kleikamp.austin.ibm.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
	 <1183149414.12702.10.camel@kleikamp.austin.ibm.com>
	 <46857107.2000106@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Waychison <mikew@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34829 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbXF2VZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2007 17:25:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5TKLa6P014138
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 16:21:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5TLOv4E455960
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 17:24:57 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5TLOuko028167
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jun 2007 17:24:57 -0400
In-Reply-To: <46857107.2000106@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-29 at 16:52 -0400, Mike Waychison wrote:
> Dave Kleikamp wrote:
> > 
> > By truncating the blocks file at the correct byte offset, only needing
> > to zero some bits of the last byte of the file.
> 
> We were thinking the unwritten blocks file would be indexed by physical 
> block number of the block device.  There wouldn't be a logical to 
> physical relationship for the blocks, so we wouldn't be able to get away 
> with truncating the blocks file itself.

I misunderstood.  I was thinking about a block-file per regular file
(that had preallocated blocks).  Ignore that comment.

> >>- When the fs comes to read a block from disk, it will need to consult
> >>  the unwritten blocks file to see if that block should be zeroed by the
> >>  CPU.
> >>
> >>- When the unwritten-block is written to, its bit in the unwritten blocks
> >>  file gets zeroed.
> >>
> >>- An obvious efficiency concern: if a user file has no unwritten blocks
> >>  in it, we don't need to consult the unwritten blocks file.
> >>
> >>  Need to work out how to do this.  An obvious solution would be to have
> >>  a number-of-unwritten-blocks counter in the inode.  But do we have space
> >>  for that?
> > 
> > 
> > Would it be too expensive to test the blocks-file page each time a bit
> > is cleared to see if it is all-zero, and then free the page, making it a
> > hole?  This test would stop if if finds any non-zero word, so it may not
> > be too bad.  (This could further be done on a block basis if the block
> > size is less than a page.)
> 
> When clearing the bits, we'd likely see a large stream of writes to the 
> unwritten blocks, which could result in a O(n^2) pass of rescanning the 
> page over and over.  

If you start checking for zero at the bit that was just zeroed, you'd
likely find a non-zero bit right away, so you wouldn't be looking at too
much of the page in the typical case.

> Maybe a per-unwritten-block-file block 
> per-block-header with a count that could be cheaply tested?  Ie: the 
> unwritten block file is composed of blocks that each have a small header 
> that contains count -- when the count hits zero, we could punch a hole 
> in the file.

Having the data be just a bitmap seems more elegant to me.  It would be
nice to avoid keeping a count in the bitmap page if possible.
-- 
David Kleikamp
IBM Linux Technology Center
