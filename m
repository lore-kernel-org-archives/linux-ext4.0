From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Fri, 1 Aug 2008 10:24:12 +0530
Message-ID: <20080801045412.GB25255@skywalker>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080731201055.GM3292@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:32849 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbYHAEyY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 00:54:24 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m714sLsG012988
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 10:24:21 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m714sLTc458962
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 10:24:21 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m714sIbo002998
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 10:24:20 +0530
Content-Disposition: inline
In-Reply-To: <20080731201055.GM3292@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 02:10:55PM -0600, Andreas Dilger wrote:
> On Jul 31, 2008  23:03 +0530, Aneesh Kumar wrote:
> > With the below changes we reserve credit needed to insert only one extent
> > resulting from a call to single get_block. That make sure we don't take
> > too much journal credits during writeout. We also don't limit the pages
> > to write. That means we loop through the dirty pages building largest
> > possible contiguous block request. Then we issue a single get_block request.
> > We may get less block that we requested. If so we would end up not mapping
> > some of the buffer_heads. That means those buffer_heads are still marked delay.
> > Later in the writepage callback via __mpage_writepage we redirty those pages.
> 
> Can you please clarify this?  Does this mean we take one pass through the
> dirty pages, but possibly do not allocate some subset of the pages.  Then,
> at some later time these holes are written out separately?  This seems
> like it would produce fragmentation if we do not work to ensure the pages
> are allocated in sequence.  Maybe I'm misunderstanding your comment and
> the unmapped pages are immediately mapped on the next loop?

We take multiple pass through the dirty pages until wbc->nr_to_write is
<= 0 or we don't have anything more to write. But if get_block doesn't
return the requested number of blocks we may possibly not writeout
some of the pages. Whether this can result in a disk layout worse than
the current, I am not sure. I haven't looked at the layout yet.
But these pages which are skipped are redirtied again via
reditry_pages_for_writepage and will be forced for writeout. Well
we can do better by setting  wbc->encountered_congestion = 1; even
though we are not really congested. That would cause most of the pdflush
work func to retry writeback_indoes.

for(;;) {
...
wbc.pages_skipped = 0;
writeback_inodes(&wbc);
...

if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
	/* Wrote less than expected */
	if (wbc.encountered_congestion || wbc.more_io)
		congestion_wait(WRITE, HZ/10);
	else
		break;
}

}

> 
> It is great that this will potentially allocate huge amounts of space
> (up to 128MB ideally) in a single call if the pages are contiguous.
> 
> The only danger I can see of having many smaller transactions instead
> of a single larger one is if this is causing many more transactions
> in the case of e.g. O_SYNC or similar, but AFAIK that is handled at
> a higher level and we should be OK.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

-aneesh
