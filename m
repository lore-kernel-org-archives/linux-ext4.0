From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Fri, 1 Aug 2008 09:36:40 +0530
Message-ID: <20080801040640.GA25255@skywalker>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080801030825.GD8736@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44500 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbYHAEGr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 00:06:47 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7146inV010184
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 09:36:44 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7146iXw1691714
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 09:36:44 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7146h4d023426
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 09:36:44 +0530
Content-Disposition: inline
In-Reply-To: <20080801030825.GD8736@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:08:25PM -0400, Theodore Tso wrote:
> On Thu, Jul 31, 2008 at 11:03:25PM +0530, Aneesh Kumar K.V wrote:
> > With the below changes we reserve credit needed to insert only one extent
> > resulting from a call to single get_block. That make sure we don't take
> > too much journal credits during writeout. We also don't limit the pages
> > to write. That means we loop through the dirty pages building largest
> > possible contiguous block request. Then we issue a single get_block request.
> > We may get less block that we requested. If so we would end up not mapping
> > some of the buffer_heads. That means those buffer_heads are still marked delay.
> > Later in the writepage callback via __mpage_writepage we redirty those pages.
> 
> If you're only redirtying the pages in the callback, that means they
> are left clean but with the delayed flag set; is that going to be
> enough to keep the mm from dropping the pages because they are clean?
> Or is the mechanism which prevents this is that you've kept the
> refcount on the pages bumped until after the callback?

writepages can use redirty_page_for_writepage to skip the pages during
writeout. We do that in most of the writepage call backs.
So I guess they would be properly marked dirty .

-aneesh
