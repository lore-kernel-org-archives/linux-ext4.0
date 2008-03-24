From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Return unwritten buffer head when trying to
	read from prealloc space.
Date: Mon, 24 Mar 2008 09:04:23 -0700
Message-ID: <1206374663.3606.2.camel@localhost.localdomain>
References: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1206080337-8732-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1206137638.3605.36.camel@localhost.localdomain>
	 <20080324081141.GA6581@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, Solofo.Ramangalahy@bull.net,
	dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48892 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYCXQE3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 12:04:29 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2OG35vj023059
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 12:03:05 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OG4Rve221250
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 10:04:27 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OG4QG0015895
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 10:04:27 -0600
In-Reply-To: <20080324081141.GA6581@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-03-24 at 13:41 +0530, Aneesh Kumar K.V wrote:
> On Fri, Mar 21, 2008 at 03:13:58PM -0700, Mingming Cao wrote:
> > On Fri, 2008-03-21 at 11:48 +0530, Aneesh Kumar K.V wrote:
> > > ext4_ext_get_blocks  returns number of blocks allocated with buffer head
> > > unmapped for a read from prealloc space. This is needed so that delayed
> > > allocation doesn't do block reservation for prealloc space since the blocks
> > > are already resevred on disk. Fix ext4_ext_get_blocks to not return greater
> > > than max_blocks and also mark the buffer head unwritten. Some code path tries
> > > to read the block if buffer_head is not new and no uptodate. Marking the buffer
> > > head unwritten avoid this reading.
> > > 
> > 
> > Seems this patch fixes two bugs together, it would be nice to split to
> > two as they cause two different problems.
> 
> Split patches here.
> 
> http://www.radian.org/~kvaneesh/ext4/patches-to-patchqueue/
> 
I will pick them up in patch queue.
> > 
> > To fix the bh->b_size warning solof founds for delayed allocation, I
> > would say we need to fix it in ext4_get_blocks_handle() (for indirect
> > files) and ext4_ext_get_blocks()(for extent files) both, not allowing
> > returning b_size greater than what the caller asking for. Also, the
> > patch below seems only address the preallocation map case, we need to
> > fix in in general block lookup case.
> > 
> 
> ext4_ext_get_blocks already make sure we doesn't return > max_blocks.
> for normal allocation.
> 
> 2694 out:
> 2695         if (allocated > max_blocks)
> 2696                 allocated = max_blocks;
> 

Oh I see, I missed that.

Regards,
Mingming
> 
> -aneesh

