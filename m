From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Check for only delay or unwritten buffer_heads
Date: Thu, 28 May 2009 15:19:29 +0530
Message-ID: <20090528094929.GA27978@skywalker>
References: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090528082711.GB29199@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46360 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZE1Jtv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2009 05:49:51 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4S9lYmU032442
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 19:47:34 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4S9npAu790594
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 19:49:51 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4S9no4Q001989
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 19:49:51 +1000
Content-Disposition: inline
In-Reply-To: <20090528082711.GB29199@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 28, 2009 at 10:27:11AM +0200, Jan Kara wrote:
> On Wed 27-05-09 21:28:07, Aneesh Kumar K.V wrote:
> > Even with changes to make pages writeprotech on truncate/i_size update we
> > can still see buffer_heads which are not mapped in the writepage
> > callback. Consider the below case.
> > 
> > 1) truncate(f, 1024)
> > 2) mmap(f, 0, 4096)
> > 3) a[0] = 'a'
> > 4) truncate(f, 4096)
> > 5) writepage(...)
> > 
> > Now if we get a writepage callback immediately after (4) and before an
> > attempt to write at any other offset via mmap address (which implies we
> > are yet to get a pagefault and do a get_block) what we would have is the
> > page which is dirty have first block allocated and the other three
> > buffer_heads unmapped.
> > 
> > In the above case the writepage should go ahead and try to write
> > the first blocks and clear the page_dirty flag. Because the further
> > attempt to write to the page will again create a fault and result in
> > allocating blocks and marking page dirty. Also if we don't write
> > any other offset via mmap address we would still have written the first
> > block to the disk and rest of the space will be considered as a hole.
>   OK, but this requires my patches to not cause data loss, doesn't it?
> Nothing prevents user from writing data into the full page just after
> truncate(f, 4096) before the writepage is called.  And without my patches,
> fault will not happen for such user write.
>   Just that we should have this dependency in mind. Otherwise the patch
> looks fine to me.

Yes the entire series is on top of your patches

-aneesh
