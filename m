From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when allocating
 blocks via fallocate
Date: Mon, 25 Jan 2010 10:42:05 +0530
Message-ID: <87k4v6py3e.fsf@linux.vnet.ibm.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4B4F4DB7.1070501@redhat.com> <87wrzklesd.fsf@linux.vnet.ibm.com>
	<20100124182445.GA4372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59994 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0AYFMJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 00:12:09 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp06.in.ibm.com (8.14.3/8.13.1) with ESMTP id o0P5C7xR019750
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 10:42:07 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0P5C7612154516
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 10:42:07 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0P5C6ut027287
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 10:42:06 +0530
In-Reply-To: <20100124182445.GA4372@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 24 Jan 2010 13:24:46 -0500, tytso@mit.edu wrote:
> On Fri, Jan 15, 2010 at 12:00:58AM +0530, Aneesh Kumar K. V wrote:
> > From 947ca1e49381bd76b85b44a1d41336a105e421ad Mon Sep 17 00:00:00 2001
> > From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Date: Thu, 7 Jan 2010 00:48:12 +0530
> > Subject: [PATCH] ext4: unmap the underlying metadata when allocating blocks via fallocate
> > 
> > This become important when we are running with nojournal mode. We
> > may end up allocating recently freed metablocks for fallocate. We
> > want to make sure we unmap the old mapping so that when we convert
> > the fallocated uninitialized extent to initialized extent we don't
> > have the old mapping around. Leaving the old mapping can cause
> > file system corruption
> > 
> > Now that we unmap old metadata blocks we need not return blocks
> > allocated from fallocate area as new.
> 
> Is this patch still strictly necessary given commit 515f41c?  This
> clears the blocks when we convert the extent from uninitialized to
> initialized.   
> 
> Hmmm, or is the problem that this fixes the problem only for the
> zero'ed out blocks, but we can still get burned on the write path?  
> No, we fix that up in mpage_da_map_blocks.
> 
> So do we need this patch?  It seems more efficient to clear it when we
> actually write or zero out the blocks; I thought that was the
> conclusion we came to when we were discussing curtw's patch (515f41c
> above).
> 
> If we now decide that we need call unmap_underlying_blocks() at
> fallocate time, maybe we should revert 515f41c?  No point doing the
> work twice; we probably have better uses for the CPU.  :-)

My goal was to see if we can drop the BH_New flag when returning
preallocated blocks. But now i look at it again i guess you don't need
to take this patch. We cannot unmap underlying meta data during
fallocate because even if we remove the old mapping for the blocks,
we could reboot and later somebody(e2fsprogs) can directly read the blocks
and create a bh with old data. So i guess we should be doing
unmap_underlying_blocks when we are returning blocks to userspace or
when we actually zero out blocks.

-aneesh



