From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 18:38:31 -0700
Message-ID: <1240969111.5583.33.camel@BVR-FS.beaverton.ibm.com>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker>
	 <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu>
	 <20090428163554.GA27670@skywalker>  <20090428170047.GC24043@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38648 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbZD2Bid (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 21:38:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3T1axnp003871
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:36:59 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3T1cXla091262
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:38:33 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3T1cWBm029167
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:38:33 -0600
In-Reply-To: <20090428170047.GC24043@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2009-04-28 at 13:00 -0400, Theodore Tso wrote:
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
> 
> 				- Ted

Aneesh, Eric and I discussed this online today, we find a separate
issue, the lookup on the preallocated extent doesn't set the
buffer_mapped(), so loop up/write to the same preallocated block
multiple times (e.g. write 1 byte at a time, for 10 bytes total) will
end up calling ext4_get_blocks_wrap() multiple times.

It seems reasonable to set the buffer mapped for preallocated buffer,
with blocknr set to the real mapped block number (rather than faked -1
for the buffer blocknr in the V3 proposed fix for partial write garbage
issue), and later reply on unwritten flag to force the
writepage()/mpage_da_map_blocks calls get_block() to do the unintialized
extent split. But this change seems require more thoughts and heavy
auditing, and not as urgency as the data corruption problem.

Mingming

