From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in
	each transaction.
Date: Sat, 8 Mar 2008 21:42:55 +0530
Message-ID: <20080308161255.GB6992@skywalker>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204889457.3627.43.camel@localhost.localdomain> <20080307114413.GA10824@skywalker> <1204905803.7975.17.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:50218 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752068AbYCHQNA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 11:13:00 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m28GCwbd028989
	for <linux-ext4@vger.kernel.org>; Sat, 8 Mar 2008 21:42:58 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m28GCvUk975032
	for <linux-ext4@vger.kernel.org>; Sat, 8 Mar 2008 21:42:57 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m28GCvCO016010
	for <linux-ext4@vger.kernel.org>; Sat, 8 Mar 2008 16:12:57 GMT
Content-Disposition: inline
In-Reply-To: <1204905803.7975.17.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 10:03:23AM -0600, Dave Kleikamp wrote:
> On Fri, 2008-03-07 at 17:14 +0530, Aneesh Kumar K.V wrote:
> > On Fri, Mar 07, 2008 at 03:30:57AM -0800, Mingming Cao wrote:
> > > On Fri, 2008-03-07 at 16:23 +0530, Aneesh Kumar K.V wrote:
> 
> > > > @@ -2814,8 +2834,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> > > >  		return -ENODEV;
> > > > 
> > > >  	block = offset >> blkbits;
> > > > -	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > > > -			- block;
> > > > +	max_blocks = EXT4_BLOCK_ALIGN(len, blkbits) >> blkbits;
> > > > 
> > > 
> > > Not sure about this change... Other than this looks fine to me
> > > 
> > 
> > max_blocks actually represented the number of blocks that we are
> > requesting. The above change makes it simple.
> 
> I think it's too simple.  :-(
> 
> Take an example of an empty file (no allocated blocks), offset=0xC00,
> length = 0x800, block_size = 0x1000.
> 
> The existing code will result in max_blocks = 2, accounting for both the
> blocks that the allocation spans, but your new code will result in
> max_blocks = 1.

Fixed with the above example added to comment.

Thanks
-aneesh
