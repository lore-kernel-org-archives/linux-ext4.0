From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Thu, 18 Jan 2007 11:38:56 +0530
Message-ID: <20070118060856.GA5620@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45AEA13B.6070606@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57615 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXARGJD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jan 2007 01:09:03 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0I692QL012302
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2007 01:09:02 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0I692M1230198
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2007 01:09:02 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0I691bM009435
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2007 01:09:02 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <45AEA13B.6070606@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 17, 2007 at 02:20:43PM -0800, Mingming Cao wrote:
> Amit K. Arora wrote:
> >  If we go with ioctl interface, we need to chose the return
> >value from the ioctl. We should either return "0" for success and
> >errno for failure, or we should be returning number of bytes
> >preallocated.
> 
> Now I am more prefer just return 0 for success. Returning the number of
> bytes preallocated back to userspace might be helpful in the case when
> the specified window contains blocks already being allocated, but this
> should not be a common case.

Agreed. Even xfs preallocation ioctl and posix_fallocate return 0 on
success.

> >(2) Also, we need to decide on what should happen in case of a
> >partial success scenario. i.e. after few blocks get preallocated, we hit
> >some error - say ENOSPC. Should the call just return the number of bytes
> >preallocated, or should it "undo" the partial preallocation and then
> >exit with error code ?
> >
> I think we should try to avoid this partial preallocation at the first
> place. Probably checking the number of free blocks before calling
> ext4_ext_get_blocks() and returns -ENOSPC if there isn't enough free
> blocks to allocate. Otherwise, if it still hits ENOSPC error, I think it
> doesn't hurt to leave the partial preallocated blocks there.

True. But, there might be a small issue with this. Before calling
ext4_ext_get_blocks(), we really don't know how many of the requested
blocks are already allocated. Consider a scenario where out of 100
blocks requested for preallocation, say, only 10 need to be physically
allocated (90 being already allocated to the file). Now, we will be
checking for 100 free blocks in the filesystem, whereas ideally we
should be checking for only 10.

--
Regards,
Amit Arora
