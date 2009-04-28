From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 13:00:47 -0400
Message-ID: <20090428170047.GC24043@mit.edu>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker> <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu> <20090428163554.GA27670@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36060 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328AbZD1RA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 13:00:58 -0400
Content-Disposition: inline
In-Reply-To: <20090428163554.GA27670@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 10:05:54PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Apr 28, 2009 at 08:48:21AM -0400, Theodore Tso wrote:
> > On Tue, Apr 28, 2009 at 03:01:45PM +0530, Aneesh Kumar K.V wrote:
> > > 
> > > Looking at the source again i guess setting just b_dev is not enough.
> > > unmap_underlying_metadata looks at the mapping block number, which we
> > > don't have in case on unwritten buffer_head. How about the below patch ?
> > > It involve vfs changes. But i guess it is correct with respect to the
> > > meaning of BH_New (Disk mapping was newly created by get_block). I guess
> > > BH_New implies BH_Mapped.
> > 
> > Argh.  So we have multiple problems going on here.  One is the
> > original problem, namely that of a partial write into an preallocated
> > block can leave garbage behind in that unitialized block.
> > 
> > The other problem seems to be in the case of a delayed allocation
> > write, where we return a buffer_head which is marked new, and this
> > causes block_prepare_write() to call unmap_underlying_metadata(dev, 0).
> 
> Not just that. On block allocation we are not calling
> unmap_underlying_metadata(dev, blocknumber) for delayed allocated
> blocks. That would imply file corruption.

I don't think I'm following you .  If we write into block that was
delayed allocated.  Are you saying we might get in trouble of the
delayed allocation block is mmap'ed in?

> The original reported problem is something really easy to reproduce. So
> i guess if we can have a ext4 local change that would fix the original
> problem that would be good. Considering that map_bh(bdev, 0) didn't
> create any issues till now, what we can do is to do a similar update
> for unwritten_buffer in ext4_da_block_write_prep. That's the v2 version
> of the patch with the below addition
> 	bh_result->b_blocknr = 0;

OK, I can put togehter a patch to do this.  Whatever we do, I think
we're going to need a *lot* of testing.

				- Ted
