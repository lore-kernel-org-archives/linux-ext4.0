From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 22:05:54 +0530
Message-ID: <20090428163554.GA27670@skywalker>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker> <20090428093145.GA13719@skywalker> <20090428124821.GJ22104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59938 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZD1QgE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 12:36:04 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id n3SGa1wT015769
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 22:06:01 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3SGa0T21228996
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 22:06:01 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n3SGa07Y006235
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 02:36:00 +1000
Content-Disposition: inline
In-Reply-To: <20090428124821.GJ22104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 08:48:21AM -0400, Theodore Tso wrote:
> On Tue, Apr 28, 2009 at 03:01:45PM +0530, Aneesh Kumar K.V wrote:
> > 
> > Looking at the source again i guess setting just b_dev is not enough.
> > unmap_underlying_metadata looks at the mapping block number, which we
> > don't have in case on unwritten buffer_head. How about the below patch ?
> > It involve vfs changes. But i guess it is correct with respect to the
> > meaning of BH_New (Disk mapping was newly created by get_block). I guess
> > BH_New implies BH_Mapped.
> 
> Argh.  So we have multiple problems going on here.  One is the
> original problem, namely that of a partial write into an preallocated
> block can leave garbage behind in that unitialized block.
> 
> The other problem seems to be in the case of a delayed allocation
> write, where we return a buffer_head which is marked new, and this
> causes block_prepare_write() to call unmap_underlying_metadata(dev, 0).

Not just that. On block allocation we are not calling
unmap_underlying_metadata(dev, blocknumber) for delayed allocated
blocks. That would imply file corruption.

> 
> In theory this could cause problems if we try installing a new
> bootloader in the filesystem's boot block while there's a delayed
> writes happening in the background, since we could end up discarding
> the write to the boot sector.  We've lived with this for quite a wihle
> though.
> 
> My concern with making the fs/buffer.c changes is that we need to make
> sure it doesn't break any of the other filesystems, so that's going to
> make it hard to try to slip this with 2.6.30-rc4 nearly upon us.
> (Silly question; why doesn't XFS get caught by this?) 
> 
> So the question is do we try to fix both bugs with one patch, and very
> likely have to wait until 2.6.31 before the patch is incorporated?  Or
> do we fix the second bug using an ext4-only fix, with the knowledge
> that post 2.6.30, we'll need undo most of it and fix it properly with
> a change that involves fs/buffer.c?
> 
> My preference is for the former, unless we belive the 2nd bug is
> serious enough that we really need to address it ASAP (in which case
> we have a lot of work ahead of us in terms of coordinating with the
> other filesystem developers).   What do other folks think?

The original reported problem is something really easy to reproduce. So
i guess if we can have a ext4 local change that would fix the original
problem that would be good. Considering that map_bh(bdev, 0) didn't
create any issues till now, what we can do is to do a similar update
for unwritten_buffer in ext4_da_block_write_prep. That's the v2 version
of the patch with the below addition
	bh_result->b_blocknr = 0;

-aneesh
