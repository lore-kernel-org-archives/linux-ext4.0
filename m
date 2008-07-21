From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: e2fsprogs and blocks outside i_size
Date: Mon, 21 Jul 2008 11:29:18 +0530
Message-ID: <20080721055918.GA8788@skywalker>
References: <20080718121130.GB23898@skywalker> <20080718123706.GE11221@mit.edu> <20080721050825.GE3370@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:55189 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753976AbYGUF70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:59:26 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6L5xMcM031474
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:29:22 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6L5xLeC1409058
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:29:21 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6L5xLOh019061
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 11:29:21 +0530
Content-Disposition: inline
In-Reply-To: <20080721050825.GE3370@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 20, 2008 at 11:08:25PM -0600, Andreas Dilger wrote:
> On Jul 18, 2008  08:37 -0400, Theodore Ts'o wrote:
> > On Fri, Jul 18, 2008 at 05:41:30PM +0530, Aneesh Kumar K.V wrote:
> > > With fallocate FALLOC_FL_KEEP_SIZE option, when we write to prealloc
> > > space and if we hit ENOSPC when trying to insert the extent,
> > > we actually zero out the extent. That means we can have blocks
> > > outside i_size for an inode.
> 
> To clarify, doesn't FALLOC_FL_KEEP_SIZE put the extent beyond i_size,
> regardless of whether the ENOSPC problem is hit?

But the extent in that case would be marked as uninit using the extent
len. So e2fsck can check for that.


> 
> > > I guess e2fsck currently doesn't handle this. Or should we fix kernel
> > > to update i_size to the right value if we do a zero out of the extent ?
> > > 
> > > With fallocate if the prealloc area is small we also aggressively zeroout.
> > > This was needed so that a random write pattern on falloc area doesn't
> > > results in too many extents.  That also can result in the above
> > > error on fsck.
> > 
> > It would seem to me that e2fsck should be fixed to not complain about
> > blocks outside of i_size, *if* the blocks in question are marked as
> > being unitialized.
> 
> Yes, I think that is the right approach.



That is fine for extents marked uninit. But when we zero out we zero out
the full extent. So that means a write of few bytes can result in blocks
being zeroed out outside i_size.  My question was how e2fsck can handle
this. Because the extent will no more be marked as uninit and  there
would be blocks outside i_size all carrying zero. 


> 
> > I suppose the other hack we could do is have e2fsck check the blocks
> > that are outside of i_size, and if they are all zero and extents are
> > involved, that it's a case of pre-allocated blocks that needed to be
> > zero'ed for some reason, as opposed to a corrupted i_size.  That seems
> > to be a really gross hack, though.
> 
> Yuck, with the added problem that there is no guarantee that these
> data blocks ARE all zero.
> 

-aneesh
