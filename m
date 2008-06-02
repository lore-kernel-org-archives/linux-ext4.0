From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Mon, 2 Jun 2008 12:27:59 +0200
Message-ID: <20080602102759.GG30613@duck.suse.cz>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093459.GC30613@duck.suse.cz> <20080602095956.GB9225@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35596 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755864AbYFBK2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 06:28:01 -0400
Content-Disposition: inline
In-Reply-To: <20080602095956.GB9225@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-06-08 15:29:56, Aneesh Kumar K.V wrote:
> On Mon, Jun 02, 2008 at 11:35:00AM +0200, Jan Kara wrote:
> > >  			BUG_ON(buffer_locked(bh));
> > >  			if (buffer_dirty(bh))
> > >  				mpage_add_bh_to_extent(mpd, logical, bh);
> > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > index 789b6ad..655b8bf 100644
> > > --- a/mm/page-writeback.c
> > > +++ b/mm/page-writeback.c
> > > @@ -881,7 +881,12 @@ int write_cache_pages(struct address_space *mapping,
> > >  	pagevec_init(&pvec, 0);
> > >  	if (wbc->range_cyclic) {
> > >  		index = mapping->writeback_index; /* Start from prev offset */
> > > -		end = -1;
> > > +		/*
> > > +		 * write only till the specified range_end even in cyclic mode
> > > +		 */
> > > +		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > > +		if (!end)
> > > +			end = -1;
> > >  	} else {
> > >  		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> > >  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> >   Are you sure you won't break other users of range_cyclic with this
> > change?
> >
> I haven't run any specific test to verify that. The concern was that if
> we force cyclic mode for writeout in delalloc we may be starting the
> writeout from a different offset than specified and would be writing
> more. So the changes was to use the offset specified. A quick look at
> the kernel suggested most of them had range_end as 0 with cyclic_mode.
> I haven't audited the full kernel. I will do that. Meanwhile if you
> think it is risky to make this changes i guess we should drop this
> part. But i guess we can keep the below change
  Hmm, I've just got an idea that it may be better to introduce a new flag
for wbc like range_cont and it would mean that we start scan at
writeback_index (we use range_start if writeback_index is not set) and
end with range_end. That way we don't have to be afraid of interference
with other range_cyclic users and in principle, range_cyclic is originally
meant for other uses...

> +       index =  mapping->writeback_index;
> +       if (!range_cyclic) {
> +               /*
> +                * We force cyclic write out of pages. If the
> +                * caller didn't request for range_cyclic update
> +                * set the writeback_index to what the caller requested.
> +                */
> +               mapping->writeback_index = wbc->range_start >> PAGE_CACHE_SHIFT;
> +       }

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
