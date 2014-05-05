From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix data integrity sync in ordered mode
Date: Mon, 5 May 2014 19:16:21 +0200
Message-ID: <20140505171621.GG23927@quack.suse.cz>
References: <004201cf645b$430004f0$c9000ed0$@samsung.com>
 <20140430160118.GB802@quack.suse.cz>
 <001f01cf65fa$aec13240$0c4396c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Jan Kara' <jack@suse.cz>, 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbaEERQZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 13:16:25 -0400
Content-Disposition: inline
In-Reply-To: <001f01cf65fa$aec13240$0c4396c0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 02-05-14 20:35:56, Namjae Jeon wrote:
> > On Wed 30-04-14 19:02:14, Namjae Jeon wrote:
> > > When we perform a data integrity sync we tag all the dirty pages with
> > > PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.
> > > Later we check for this tag in write_cache_pages_da and creates a
> > > struct mpage_da_data containing contiguously indexed pages tagged with this
> > > tag and sync these pages with a call to mpage_da_map_and_submit.
> > > This process is done in while loop until all the PAGECACHE_TAG_TOWRITE pages
> > > are synced. We also do journal start and stop in each iteration.
> > > journal_stop could initiate journal commit which would call ext4_writepage
> > > which in turn will call ext4_bio_write_page even for delayed OR unwritten
> > > buffers. When ext4_bio_write_page is called for such buffers, even though it
> > > does not sync them but it clears the PAGECACHE_TAG_TOWRITE of the corresponding
> > > page and hence these pages are also not synced by the currently running data
> > > integrity sync. We will end up with dirty pages although sync is completed.
> > >
> > > This could cause a potential data loss when the sync call is followed by a
> > > truncate_pagecache call, which is exactly the case in collapse_range.
> > > (It will cause generic/127 failure in xfstests)
> >   This is well spotted. Thanks for finding this bug. See my comment below
> > regarding the fix.
> > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Jan kara <jack@suse.de>
> > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > ---
> > >  fs/ext4/inode.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index b1dc334..bd85712 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1865,12 +1865,19 @@ static int ext4_writepage(struct page *page,
> > >  	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> > >  				   ext4_bh_delay_or_unwritten)) {
> > >  		redirty_page_for_writepage(wbc, page);
> > > -		if (current->flags & PF_MEMALLOC) {
> > > +		if ((current->flags & PF_MEMALLOC) ||
> > > +		     radix_tree_tag_get(&page->mapping->page_tree,
> > > +					page->index, PAGECACHE_TAG_TOWRITE)) {
> >   I don't think your fix is correct. journal_submit_inode_data_buffers()
> > uses WB_SYNC_ALL mode to write the pages and thus all the pages you'll see
> > in ext4_writepage() are going to have TOWRITE tag set. And even if that
> > wasn't the case you'll have problems when blocksize < pagesize. Because in
> > data=ordered mode we want to writeout allocated (mapped) blocks in the page
> > to avoid exposure of uninitialized data after a crash (e.g. in case we have
> > allocated some blocks in the current transaction but not yet finished
> > writing them out and there are other blocks underlying the page which
> > aren't allocated yet). Fixing this isn't easy I'm afraid.
> > 
> > What we could do is to create a variant of set_page_writeback() which
> > doesn't clear TOWRITE tag and use that in ext4_bio_write_page() if we are
> > writing out just some buffers in a page and leaving other dirty buffers
> > behind. It would have a down side that we would be leaving TOWRITE tagged
> > pages behind in case when we actually don't race with other writeback but
> > I don't see that causing any real problems.
> 
> I agree about your opinion. But set_page_writeback is used on many place.
> So I think it is expected to change too much if set_page_writeback is
> modified.
  I meant we would create a new variant of set_page_writeback() which would
not clear TOWRITE tag (something like set_page_writeback_keepwrite()) and
then use this variant from ext4_writepage() during writeback from JBD2.

Regarding your patch:
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 4acf1f7..680f12f 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
...
> @@ -425,8 +427,21 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>  		}
>  		set_buffer_async_write(bh);
> +		dirty_buffers++;
>  	} while ((bh = bh->b_this_page) != head);
>  
> +	if (!dirty_buffers) {
> +		unlock_page(page);
> +		return ret;
> +	}
> +
> +	if (unmapped_dirty_buffers &&
> +	    radix_tree_tag_get(&page->mapping->page_tree, page->index,
> +			       PAGECACHE_TAG_TOWRITE))
> +		needs_tag_towrite = 1;
> +
> +	set_page_writeback(page);
  You cannot call set_page_writeback() here. There might be bios against
this page already in flight at this moment and so IO completion could race
with set_page_writeback(). 
  
>  	/* Now submit buffers to write */
>  	bh = head = page_buffers(page);
>  	do {
> @@ -457,5 +472,10 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  	/* Nothing submitted - we have to end page writeback */
>  	if (!nr_submitted)
>  		end_page_writeback(page);
> +
> +	if (needs_tag_towrite)
> +		tag_pages_for_writeback(page->mapping, page->index,
> +					page->index);
> +	
  And this is racy. Data integrity sync can do tagged lookup just after
set_page_writeback() cleared the tag and so it won't find the dirty page.
Really the only race free way is not to clear the tag in set_page_writeback().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
