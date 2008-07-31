From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 22:38:56 +0530
Message-ID: <20080731170856.GD20838@skywalker>
References: <20080731161058.GA20838@skywalker> <20080731164728.GF11632@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46119 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751724AbYGaRJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 13:09:17 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6VH9688000652
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:39:06 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VH96jQ1462522
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:39:06 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6VH95wT013646
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 22:39:06 +0530
Content-Disposition: inline
In-Reply-To: <20080731164728.GF11632@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 12:47:28PM -0400, Theodore Tso wrote:
> On Thu, Jul 31, 2008 at 09:40:59PM +0530, Aneesh Kumar K.V wrote:
> > Hi Ted,
> > 
> > I haven't yet looked at whether it is kernel or e2fsck bug.
> > But I am having this with the latest patch queue when running
> > fsstress. The fsstress have falloc added as a supported operation.
> > So it is mostly to do with fallocate. Architecture is x86.
> 
> Part of this is definitely an e2fsck bug, because e2fsck isn't
> currently checking the EXT2_EXTENT_FLAGS_UNINIT flag.  In line 1715 of
> e2fsck/pass1.c:
> 
> 	start_block = pb->last_block = extent.e_lblk + extent.e_len - 1;
> 
> We shouldn't be setting pb->last_block if this is an unitialized
> extent.


What I am wondering is that why we didn't observe these errors before.
I used to run the same test before and I haven't seen the errors before.
I will check the logs again to verify this.

Also note that fallocate is called with update i_size option.


>
> I suspect this is also related though to the issue you raised in the
> "e2fsprogs and blocks outside i_size" thread about two weeks ago.  So
> even after we fix this e2fsck bug, we may still have some fsstress
> failures until we decide how to deal with that particular issue.


fallocate is called in the test with update i_size. So it should not
happen.

>
> Do you have a quickie program that calls fallocate to preallocate
> space for a particular program easily to hand?  If not, I can write
> one in about 5-10 minutes, but if you have one written already, it'll
> save me the effort.  Thanks!!


-aneesh
