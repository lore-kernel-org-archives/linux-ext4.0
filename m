From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Return unwritten buffer head when trying to
	read from prealloc space.
Date: Mon, 24 Mar 2008 13:41:41 +0530
Message-ID: <20080324081141.GA6581@skywalker>
References: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1206080337-8732-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1206137638.3605.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, Solofo.Ramangalahy@bull.net,
	dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:59273 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYCXILp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 04:11:45 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2O8BgMW023820
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 13:41:42 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2O8Bg2g741414
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 13:41:42 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2O8BfkM015194
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 08:11:42 GMT
Content-Disposition: inline
In-Reply-To: <1206137638.3605.36.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 21, 2008 at 03:13:58PM -0700, Mingming Cao wrote:
> On Fri, 2008-03-21 at 11:48 +0530, Aneesh Kumar K.V wrote:
> > ext4_ext_get_blocks  returns number of blocks allocated with buffer head
> > unmapped for a read from prealloc space. This is needed so that delayed
> > allocation doesn't do block reservation for prealloc space since the blocks
> > are already resevred on disk. Fix ext4_ext_get_blocks to not return greater
> > than max_blocks and also mark the buffer head unwritten. Some code path tries
> > to read the block if buffer_head is not new and no uptodate. Marking the buffer
> > head unwritten avoid this reading.
> > 
> 
> Seems this patch fixes two bugs together, it would be nice to split to
> two as they cause two different problems.

Split patches here.

http://www.radian.org/~kvaneesh/ext4/patches-to-patchqueue/

> 
> To fix the bh->b_size warning solof founds for delayed allocation, I
> would say we need to fix it in ext4_get_blocks_handle() (for indirect
> files) and ext4_ext_get_blocks()(for extent files) both, not allowing
> returning b_size greater than what the caller asking for. Also, the
> patch below seems only address the preallocation map case, we need to
> fix in in general block lookup case.
> 

ext4_ext_get_blocks already make sure we doesn't return > max_blocks.
for normal allocation.

2694 out:
2695         if (allocated > max_blocks)
2696                 allocated = max_blocks;


-aneesh
