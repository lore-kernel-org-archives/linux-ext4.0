From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 06/15] mm: teach truncate_inode_pages_range() to handle
 non page aligned ranges
Date: Mon, 20 Aug 2012 12:26:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1208201221360.3975@vpn-8-6.rdu.redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com> <1343376074-28034-7-git-send-email-lczerner@redhat.com> <alpine.LSU.2.00.1208192144260.2390@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-mmc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2HTK0u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 06:26:50 -0400
In-Reply-To: <alpine.LSU.2.00.1208192144260.2390@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 19 Aug 2012, Hugh Dickins wrote:

> Date: Sun, 19 Aug 2012 21:52:48 -0700 (PDT)
> From: Hugh Dickins <hughd@google.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
>     linux-mmc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH 06/15] mm: teach truncate_inode_pages_range() to handle
>     non page aligned ranges
> 
> On Fri, 27 Jul 2012, Lukas Czerner wrote:
> 
> > This commit changes truncate_inode_pages_range() so it can handle non
> > page aligned regions of the truncate. Currently we can hit BUG_ON when
> > the end of the range is not page aligned, but we can handle unaligned
> > start of the range.
> > 
> > Being able to handle non page aligned regions of the page can help file
> > system punch_hole implementations and save some work, because once we're
> > holding the page we might as well deal with it right away.
> > 
> > In order for this to work correctly, called must register
> > invalidatepage_range address space operation, or rely solely on the
> > block_invalidatepage_range. That said it will BUG_ON() if caller
> > implements invalidatepage(), does not implement invalidatepage_range()
> > and use truncate_inode_pages_range() with unaligned end of the range.
> > 
> > This was based on the code provided by Hugh Dickins with some small
> > changes to make use of do_invalidatepage_range().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Hugh Dickins <hughd@google.com>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> This looks good to me.  I like the way you provide the same args
> to do_invalidatepage_range() as to zero_user_segment():
> 
> 		zero_user_segment(page, partial_start, top);
> 		if (page_has_private(page))
> 			do_invalidatepage_range(page, partial_start, top);
> 
> Unfortunately, that is not what patches 01-05 are expecting...

Thank for the review Hugh. The fact is that the third argument of
the invalidatepage_range() was meant to be length and the problem is
actually in this patch, where I am passing end offset as the third
argument.

But you've made it clear that you would like better the semantics
where the third argument is actually the end offset. Is that right ?
If so, I'll change it accordingly, otherwise I'll just fix this
patch.

Thanks!
-Lukas

> 
> Hugh
> 
> > ---
> >  mm/truncate.c |   77 +++++++++++++++++++++++++++++++++++++--------------------
> >  1 files changed, 50 insertions(+), 27 deletions(-)
> > 
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index e29e5ea..1f6ea8b 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -71,14 +71,6 @@ void do_invalidatepage_range(struct page *page, unsigned long offset,
> >  #endif
> >  }
> >  
> > -static inline void truncate_partial_page(struct page *page, unsigned partial)
> > -{
> > -	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
> > -	cleancache_invalidate_page(page->mapping, page);
> > -	if (page_has_private(page))
> > -		do_invalidatepage(page, partial);
> > -}
> > -
> >  /*
> >   * This cancels just the dirty bit on the kernel page itself, it
> >   * does NOT actually remove dirty bits on any mmap's that may be
> > @@ -212,8 +204,8 @@ int invalidate_inode_page(struct page *page)
> >   * @lend: offset to which to truncate
> >   *
> >   * Truncate the page cache, removing the pages that are between
> > - * specified offsets (and zeroing out partial page
> > - * (if lstart is not page aligned)).
> > + * specified offsets (and zeroing out partial pages
> > + * if lstart or lend + 1 is not page aligned).
> >   *
> >   * Truncate takes two passes - the first pass is nonblocking.  It will not
> >   * block on page locks and it will not block on writeback.  The second pass
> > @@ -224,35 +216,44 @@ int invalidate_inode_page(struct page *page)
> >   * We pass down the cache-hot hint to the page freeing code.  Even if the
> >   * mapping is large, it is probably the case that the final pages are the most
> >   * recently touched, and freeing happens in ascending file offset order.
> > + *
> > + * Note that it is able to handle cases where lend + 1 is not page aligned.
> > + * However in order for this to work caller have to register
> > + * invalidatepage_range address space operation or rely solely on
> > + * block_invalidatepage_range(). That said, do_invalidatepage_range() will
> > + * BUG_ON() if caller implements invalidatapage(), does not implement
>                                     invalidatepage()
> > + * invalidatepage_range() and uses truncate_inode_pages_range() with lend + 1
> > + * unaligned to the page cache size.
> >   */
> >  void truncate_inode_pages_range(struct address_space *mapping,
> >  				loff_t lstart, loff_t lend)
> >  {
> > -	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
> > -	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
> > +	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> > +	pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
> > +	unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
> > +	unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
> >  	struct pagevec pvec;
> >  	pgoff_t index;
> > -	pgoff_t end;
> >  	int i;
> >  
> >  	cleancache_invalidate_inode(mapping);
> >  	if (mapping->nrpages == 0)
> >  		return;
> >  
> > -	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
> > -	end = (lend >> PAGE_CACHE_SHIFT);
> > +	if (lend == -1)
> > +		end = -1;	/* unsigned, so actually very big */
> >  
> >  	pagevec_init(&pvec, 0);
> >  	index = start;
> > -	while (index <= end && pagevec_lookup(&pvec, mapping, index,
> > -			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
> > +	while (index < end && pagevec_lookup(&pvec, mapping, index,
> > +			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
> >  		mem_cgroup_uncharge_start();
> >  		for (i = 0; i < pagevec_count(&pvec); i++) {
> >  			struct page *page = pvec.pages[i];
> >  
> >  			/* We rely upon deletion not changing page->index */
> >  			index = page->index;
> > -			if (index > end)
> > +			if (index >= end)
> >  				break;
> >  
> >  			if (!trylock_page(page))
> > @@ -271,27 +272,51 @@ void truncate_inode_pages_range(struct address_space *mapping,
> >  		index++;
> >  	}
> >  
> > -	if (partial) {
> > +	if (partial_start) {
> >  		struct page *page = find_lock_page(mapping, start - 1);
> >  		if (page) {
> > +			unsigned int top = PAGE_CACHE_SIZE;
> > +			if (start > end) {
> > +				top = partial_end;
> > +				partial_end = 0;
> > +			}
> > +			wait_on_page_writeback(page);
> > +			zero_user_segment(page, partial_start, top);
> > +			cleancache_invalidate_page(mapping, page);
> > +			if (page_has_private(page))
> > +				do_invalidatepage_range(page, partial_start,
> > +							top);
> > +			unlock_page(page);
> > +			page_cache_release(page);
> > +		}
> > +	}
> > +	if (partial_end) {
> > +		struct page *page = find_lock_page(mapping, end);
> > +		if (page) {
> >  			wait_on_page_writeback(page);
> > -			truncate_partial_page(page, partial);
> > +			zero_user_segment(page, 0, partial_end);
> > +			cleancache_invalidate_page(mapping, page);
> > +			if (page_has_private(page))
> > +				do_invalidatepage_range(page, 0,
> > +							partial_end);
> >  			unlock_page(page);
> >  			page_cache_release(page);
> >  		}
> >  	}
> > +	if (start >= end)
> > +		return;
> >  
> >  	index = start;
> >  	for ( ; ; ) {
> >  		cond_resched();
> >  		if (!pagevec_lookup(&pvec, mapping, index,
> > -			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
> > +			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
> >  			if (index == start)
> >  				break;
> >  			index = start;
> >  			continue;
> >  		}
> > -		if (index == start && pvec.pages[0]->index > end) {
> > +		if (index == start && pvec.pages[0]->index >= end) {
> >  			pagevec_release(&pvec);
> >  			break;
> >  		}
> > @@ -301,7 +326,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
> >  
> >  			/* We rely upon deletion not changing page->index */
> >  			index = page->index;
> > -			if (index > end)
> > +			if (index >= end)
> >  				break;
> >  
> >  			lock_page(page);
> > @@ -646,10 +671,8 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
> >  	 * This rounding is currently just for example: unmap_mapping_range
> >  	 * expands its hole outwards, whereas we want it to contract the hole
> >  	 * inwards.  However, existing callers of truncate_pagecache_range are
> > -	 * doing their own page rounding first; and truncate_inode_pages_range
> > -	 * currently BUGs if lend is not pagealigned-1 (it handles partial
> > -	 * page at start of hole, but not partial page at end of hole).  Note
> > -	 * unmap_mapping_range allows holelen 0 for all, and we allow lend -1.
> > +	 * doing their own page rounding first.  Note that unmap_mapping_range
> > +	 * allows holelen 0 for all, and we allow lend -1 for end of file.
> >  	 */
> >  
> >  	/*
> > -- 
> > 1.7.7.6
> > 
> > 
> 
