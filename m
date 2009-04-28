From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Wed, 29 Apr 2009 00:27:49 +0530
Message-ID: <20090428185749.GA3275@skywalker>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker> <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu> <20090428163554.GA27670@skywalker> <20090428170047.GC24043@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57390 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZD1S6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 14:58:01 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3SIYF8T024615
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:34:15 -0400
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3SIvw2V933892
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 04:57:58 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3SIvvNu031040
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 04:57:57 +1000
Content-Disposition: inline
In-Reply-To: <20090428170047.GC24043@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 01:00:47PM -0400, Theodore Tso wrote:
> On Tue, Apr 28, 2009 at 10:05:54PM +0530, Aneesh Kumar K.V wrote:
> > On Tue, Apr 28, 2009 at 08:48:21AM -0400, Theodore Tso wrote:
> > > On Tue, Apr 28, 2009 at 03:01:45PM +0530, Aneesh Kumar K.V wrote:
> > > > 
> > > > Looking at the source again i guess setting just b_dev is not enough.
> > > > unmap_underlying_metadata looks at the mapping block number, which we
> > > > don't have in case on unwritten buffer_head. How about the below patch ?
> > > > It involve vfs changes. But i guess it is correct with respect to the
> > > > meaning of BH_New (Disk mapping was newly created by get_block). I guess
> > > > BH_New implies BH_Mapped.
> > > 
> > > Argh.  So we have multiple problems going on here.  One is the
> > > original problem, namely that of a partial write into an preallocated
> > > block can leave garbage behind in that unitialized block.
> > > 
> > > The other problem seems to be in the case of a delayed allocation
> > > write, where we return a buffer_head which is marked new, and this
> > > causes block_prepare_write() to call unmap_underlying_metadata(dev, 0).
> > 
> > Not just that. On block allocation we are not calling
> > unmap_underlying_metadata(dev, blocknumber) for delayed allocated
> > blocks. That would imply file corruption.
> 
> I don't think I'm following you .  If we write into block that was
> delayed allocated.  Are you saying we might get in trouble of the
> delayed allocation block is mmap'ed in?

We allocate blocks for delayed buffer during writepage. Now we need to
make sure after getting the blocks we drop the old buffer_head mapping
that we may have with this particular block attached to the block
device. That is done by calling unmap_underlying_metadata. Now the
current code doesn't call unmap_underlying_metadata for delayed
allocated blocks. That would mean we can see corrupt files if old
buffer_head mapping gets synced to disk AFTER we write the new
buffer_head mapping.

> 
> > The original reported problem is something really easy to reproduce. So
> > i guess if we can have a ext4 local change that would fix the original
> > problem that would be good. Considering that map_bh(bdev, 0) didn't
> > create any issues till now, what we can do is to do a similar update
> > for unwritten_buffer in ext4_da_block_write_prep. That's the v2 version
> > of the patch with the below addition
> > 	bh_result->b_blocknr = 0;
> 
> OK, I can put togehter a patch to do this.  Whatever we do, I think
> we're going to need a *lot* of testing.

I just sent -v3 version 

-aneesh
