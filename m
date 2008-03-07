From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in
	each transaction.
Date: Fri, 07 Mar 2008 09:59:18 -0800
Message-ID: <1204912758.14884.0.camel@localhost.localdomain>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1204889457.3627.43.camel@localhost.localdomain>
	 <20080307114413.GA10824@skywalker>
	 <1204905803.7975.17.camel@norville.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39482 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYCGR7y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 12:59:54 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m27HxrmU030749
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 12:59:53 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27Hxr0t234406
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 12:59:53 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27HxrcL020383
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 12:59:53 -0500
In-Reply-To: <1204905803.7975.17.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-07 at 10:03 -0600, Dave Kleikamp wrote:
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

I agree with you.

Mingming

