From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Mon, 2 Jun 2008 15:29:56 +0530
Message-ID: <20080602095956.GB9225@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50429 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbYFBKAV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 06:00:21 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m529xaWW009381
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 19:59:36 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m52A4G7q285740
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 20:04:16 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m52A04ir000926
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 20:00:04 +1000
Content-Disposition: inline
In-Reply-To: <20080602093459.GC30613@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 11:35:00AM +0200, Jan Kara wrote:
> > @@ -1052,6 +1051,7 @@ static int __mpage_da_writepage(struct page *page,
> >  		head = page_buffers(page);
> >  		bh = head;
> >  		do {
> > +
>   I guess this line is a typo.
> 

Yes, Mostly some debug lines I removed, but missed the newline added.


> >  			BUG_ON(buffer_locked(bh));
> >  			if (buffer_dirty(bh))
> >  				mpage_add_bh_to_extent(mpd, logical, bh);
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 789b6ad..655b8bf 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -881,7 +881,12 @@ int write_cache_pages(struct address_space *mapping,
> >  	pagevec_init(&pvec, 0);
> >  	if (wbc->range_cyclic) {
> >  		index = mapping->writeback_index; /* Start from prev offset */
> > -		end = -1;
> > +		/*
> > +		 * write only till the specified range_end even in cyclic mode
> > +		 */
> > +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > +		if (!end)
> > +			end = -1;
> >  	} else {
> >  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> >  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
>   Are you sure you won't break other users of range_cyclic with this
> change?
>

I haven't run any specific test to verify that. The concern was that if
we force cyclic mode for writeout in delalloc we may be starting the
writeout from a different offset than specified and would be writing
more. So the changes was to use the offset specified. A quick look at
the kernel suggested most of them had range_end as 0 with cyclic_mode.
I haven't audited the full kernel. I will do that. Meanwhile if you
think it is risky to make this changes i guess we should drop this
part. But i guess we can keep the below change

+       index =  mapping->writeback_index;
+       if (!range_cyclic) {
+               /*
+                * We force cyclic write out of pages. If the
+                * caller didn't request for range_cyclic update
+                * set the writeback_index to what the caller requested.
+                */
+               mapping->writeback_index = wbc->range_start >> PAGE_CACHE_SHIFT;
+       }


-aneesh
