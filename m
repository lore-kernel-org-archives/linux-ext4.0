From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 18/29] ext4: Restructure writeback path
Date: Wed, 8 May 2013 13:20:07 +0200
Message-ID: <20130508112007.GB30550@quack.suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-19-git-send-email-jack@suse.cz>
 <20130508034857.GA32131@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab3EHLUL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 May 2013 07:20:11 -0400
Content-Disposition: inline
In-Reply-To: <20130508034857.GA32131@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-05-13 11:48:57, Zheng Liu wrote:
> On Mon, Apr 08, 2013 at 11:32:23PM +0200, Jan Kara wrote:
> > There are two issues with current writeback path in ext4. For one we
> > don't necessarily map complete pages when blocksize < pagesize and thus
> > needn't do any writeback in one iteration. We always map some blocks
> > though so we will eventually finish mapping the page. Just if writeback
> > races with other operations on the file, forward progress is not really
> > guaranteed. The second problem is that current code structure makes it
> > hard to associate all the bios to some range of pages with one io_end
> > structure so that unwritten extents can be converted after all the bios
> > are finished. This will be especially difficult later when io_end will
> > be associated with reserved transaction handle.
> > 
> > We restructure the writeback path to a relatively simple loop which
> > first prepares extent of pages, then maps one or more extents so that
> > no page is partially mapped, and once page is fully mapped it is
> > submitted for IO. We keep all the mapping and IO submission information
> > in mpage_da_data structure to somewhat reduce stack usage. Resulting
> > code is somewhat shorter than the old one and hopefully also easier to
> > read.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> One nit below.  Otherwise the patch looks good to be.
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
  Thanks for review!

> > ---
> >  fs/ext4/ext4.h              |   15 -
> >  fs/ext4/inode.c             |  978 +++++++++++++++++++++----------------------
> >  include/trace/events/ext4.h |   64 ++-
> >  3 files changed, 508 insertions(+), 549 deletions(-)
> ...
> >  /*
> > - * write_cache_pages_da - walk the list of dirty pages of the given
> > - * address space and accumulate pages that need writing, and call
> > - * mpage_da_map_and_submit to map a single contiguous memory region
> > - * and then write them.
> > + * mpage_prepare_extent_to_map - find & lock contiguous range of dirty pages
> > + * 				 and underlying extent to map
> > + *
> > + * @mpd - where to look for pages
> > + *
> > + * Walk dirty pages in the mapping while they are contiguous and lock them.
> > + * While pages are fully mapped submit them for IO. When we find a page which
> > + * isn't mapped we start accumulating extent of buffers underlying these pages
> > + * that needs mapping (formed by either delayed or unwritten buffers). The
> > + * extent found is returned in @mpd structure (starting at mpd->lblk with
> > + * length mpd->len blocks).
> >   */
> > -static int write_cache_pages_da(handle_t *handle,
> > -				struct address_space *mapping,
> > -				struct writeback_control *wbc,
> > -				struct mpage_da_data *mpd,
> > -				pgoff_t *done_index)
> > +static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
> >  {
> > -	struct buffer_head	*bh, *head;
> > -	struct inode		*inode = mapping->host;
> > -	struct pagevec		pvec;
> > -	unsigned int		nr_pages;
> > -	sector_t		logical;
> > -	pgoff_t			index, end;
> > -	long			nr_to_write = wbc->nr_to_write;
> > -	int			i, tag, ret = 0;
> > -
> > -	memset(mpd, 0, sizeof(struct mpage_da_data));
> > -	mpd->wbc = wbc;
> > -	mpd->inode = inode;
> > -	pagevec_init(&pvec, 0);
> > -	index = wbc->range_start >> PAGE_CACHE_SHIFT;
> > -	end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > +	struct address_space *mapping = mpd->inode->i_mapping;
> > +	struct pagevec pvec;
> > +	unsigned int nr_pages;
> > +	pgoff_t index = mpd->first_page;
> > +	pgoff_t end = mpd->last_page;
> > +	bool first_page_found = false;
> > +	int tag;
> > +	int i, err = 0;
> > +	int blkbits = mpd->inode->i_blkbits;
> > +	ext4_lblk_t lblk;
> > +	struct buffer_head *head;
> >  
> > -	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
> > +	if (mpd->wbc->sync_mode == WB_SYNC_ALL || mpd->wbc->tagged_writepages)
> >  		tag = PAGECACHE_TAG_TOWRITE;
> >  	else
> >  		tag = PAGECACHE_TAG_DIRTY;
> >  
> > -	*done_index = index;
> > +	mpd->map.m_len = 0;
> > +	mpd->next_page = index;
> 
> Forgot to call pagevec_init(&pvec, 0) here.
  I actually don't think it can cause any problems here (pagevec_lookup()
simply overwrites the pvec and we call pagevec_release() only after
pagevec_lookup()) but it's certainly a good practice so I added it.

								Honza

> >  	while (index <= end) {
> >  		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
> >  			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
> >  		if (nr_pages == 0)
> > -			return 0;
> > +			goto out;
> >  
> >  		for (i = 0; i < nr_pages; i++) {
> >  			struct page *page = pvec.pages[i];
> > @@ -2145,31 +2138,21 @@ static int write_cache_pages_da(handle_t *handle,
> >  			if (page->index > end)
> >  				goto out;
> >  
> > -			*done_index = page->index + 1;
> > -
> > -			/*
> > -			 * If we can't merge this page, and we have
> > -			 * accumulated an contiguous region, write it
> > -			 */
> > -			if ((mpd->next_page != page->index) &&
> > -			    (mpd->next_page != mpd->first_page)) {
> > -				mpage_da_map_and_submit(mpd);
> > -				goto ret_extent_tail;
> > -			}
> > +			/* If we can't merge this page, we are done. */
> > +			if (first_page_found && mpd->next_page != page->index)
> > +				goto out;
> >  
> >  			lock_page(page);
> > -
> >  			/*
> > -			 * If the page is no longer dirty, or its
> > -			 * mapping no longer corresponds to inode we
> > -			 * are writing (which means it has been
> > -			 * truncated or invalidated), or the page is
> > -			 * already under writeback and we are not
> > -			 * doing a data integrity writeback, skip the page
> > +			 * If the page is no longer dirty, or its mapping no
> > +			 * longer corresponds to inode we are writing (which
> > +			 * means it has been truncated or invalidated), or the
> > +			 * page is already under writeback and we are not doing
> > +			 * a data integrity writeback, skip the page
> >  			 */
> >  			if (!PageDirty(page) ||
> >  			    (PageWriteback(page) &&
> > -			     (wbc->sync_mode == WB_SYNC_NONE)) ||
> > +			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
> >  			    unlikely(page->mapping != mapping)) {
> >  				unlock_page(page);
> >  				continue;
> > @@ -2178,101 +2161,60 @@ static int write_cache_pages_da(handle_t *handle,
> >  			wait_on_page_writeback(page);
> >  			BUG_ON(PageWriteback(page));
> >  
> > -			/*
> > -			 * If we have inline data and arrive here, it means that
> > -			 * we will soon create the block for the 1st page, so
> > -			 * we'd better clear the inline data here.
> > -			 */
> > -			if (ext4_has_inline_data(inode)) {
> > -				BUG_ON(ext4_test_inode_state(inode,
> > -						EXT4_STATE_MAY_INLINE_DATA));
> > -				ext4_destroy_inline_data(handle, inode);
> > -			}
> > -
> > -			if (mpd->next_page != page->index)
> > +			if (!first_page_found) {
> >  				mpd->first_page = page->index;
> > +				first_page_found = true;
> > +			}
> >  			mpd->next_page = page->index + 1;
> > -			logical = (sector_t) page->index <<
> > -				(PAGE_CACHE_SHIFT - inode->i_blkbits);
> > +			lblk = ((ext4_lblk_t)page->index) <<
> > +				(PAGE_CACHE_SHIFT - blkbits);
> >  
> >  			/* Add all dirty buffers to mpd */
> >  			head = page_buffers(page);
> > -			bh = head;
> > -			do {
> > -				BUG_ON(buffer_locked(bh));
> > -				/*
> > -				 * We need to try to allocate unmapped blocks
> > -				 * in the same page.  Otherwise we won't make
> > -				 * progress with the page in ext4_writepage
> > -				 */
> > -				if (ext4_bh_delay_or_unwritten(NULL, bh)) {
> > -					mpage_add_bh_to_extent(mpd, logical,
> > -							       bh->b_state);
> > -					if (mpd->io_done)
> > -						goto ret_extent_tail;
> > -				} else if (buffer_dirty(bh) &&
> > -					   buffer_mapped(bh)) {
> > -					/*
> > -					 * mapped dirty buffer. We need to
> > -					 * update the b_state because we look
> > -					 * at b_state in mpage_da_map_blocks.
> > -					 * We don't update b_size because if we
> > -					 * find an unmapped buffer_head later
> > -					 * we need to use the b_state flag of
> > -					 * that buffer_head.
> > -					 */
> > -					if (mpd->b_size == 0)
> > -						mpd->b_state =
> > -							bh->b_state & BH_FLAGS;
> > -				}
> > -				logical++;
> > -			} while ((bh = bh->b_this_page) != head);
> > -
> > -			if (nr_to_write > 0) {
> > -				nr_to_write--;
> > -				if (nr_to_write == 0 &&
> > -				    wbc->sync_mode == WB_SYNC_NONE)
> > -					/*
> > -					 * We stop writing back only if we are
> > -					 * not doing integrity sync. In case of
> > -					 * integrity sync we have to keep going
> > -					 * because someone may be concurrently
> > -					 * dirtying pages, and we might have
> > -					 * synced a lot of newly appeared dirty
> > -					 * pages, but have not synced all of the
> > -					 * old dirty pages.
> > -					 */
> > +			if (!add_page_bufs_to_extent(mpd, head, head, lblk))
> > +				goto out;
> > +			/* So far everything mapped? Submit the page for IO. */
> > +			if (mpd->map.m_len == 0) {
> > +				err = mpage_submit_page(mpd, page);
> > +				if (err < 0)
> >  					goto out;
> >  			}
> > +
> > +			/*
> > +			 * Accumulated enough dirty pages? This doesn't apply
> > +			 * to WB_SYNC_ALL mode. For integrity sync we have to
> > +			 * keep going because someone may be concurrently
> > +			 * dirtying pages, and we might have synced a lot of
> > +			 * newly appeared dirty pages, but have not synced all
> > +			 * of the old dirty pages.
> > +			 */
> > +			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
> > +			    mpd->next_page - mpd->first_page >=
> > +							mpd->wbc->nr_to_write)
> > +				goto out;
> >  		}
> >  		pagevec_release(&pvec);
> >  		cond_resched();
> >  	}
> >  	return 0;
> > -ret_extent_tail:
> > -	ret = MPAGE_DA_EXTENT_TAIL;
> >  out:
> >  	pagevec_release(&pvec);
> > -	cond_resched();
> > -	return ret;
> > +	return err;
> >  }
> >  
> > -
> >  static int ext4_da_writepages(struct address_space *mapping,
> >  			      struct writeback_control *wbc)
> >  {
> > -	pgoff_t	index;
> > +	pgoff_t	writeback_index = 0;
> > +	long nr_to_write = wbc->nr_to_write;
> >  	int range_whole = 0;
> > +	int cycled = 1;
> >  	handle_t *handle = NULL;
> >  	struct mpage_da_data mpd;
> >  	struct inode *inode = mapping->host;
> > -	int pages_written = 0;
> > -	int range_cyclic, cycled = 1, io_done = 0;
> >  	int needed_blocks, ret = 0;
> > -	loff_t range_start = wbc->range_start;
> >  	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
> > -	pgoff_t done_index = 0;
> > -	pgoff_t end;
> > +	bool done;
> >  	struct blk_plug plug;
> >  
> >  	trace_ext4_da_writepages(inode, wbc);
> > @@ -2298,40 +2240,65 @@ static int ext4_da_writepages(struct address_space *mapping,
> >  	if (unlikely(sbi->s_mount_flags & EXT4_MF_FS_ABORTED))
> >  		return -EROFS;
> >  
> > +	/*
> > +	 * If we have inline data and arrive here, it means that
> > +	 * we will soon create the block for the 1st page, so
> > +	 * we'd better clear the inline data here.
> > +	 */
> > +	if (ext4_has_inline_data(inode)) {
> > +		/* Just inode will be modified... */
> > +		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> > +			goto out_writepages;
> > +		}
> > +		BUG_ON(ext4_test_inode_state(inode,
> > +				EXT4_STATE_MAY_INLINE_DATA));
> > +		ext4_destroy_inline_data(handle, inode);
> > +		ext4_journal_stop(handle);
> > +	}
> > +
> >  	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
> >  		range_whole = 1;
> >  
> > -	range_cyclic = wbc->range_cyclic;
> >  	if (wbc->range_cyclic) {
> > -		index = mapping->writeback_index;
> > -		if (index)
> > +		writeback_index = mapping->writeback_index;
> > +		if (writeback_index)
> >  			cycled = 0;
> > -		wbc->range_start = index << PAGE_CACHE_SHIFT;
> > -		wbc->range_end  = LLONG_MAX;
> > -		wbc->range_cyclic = 0;
> > -		end = -1;
> > +		mpd.first_page = writeback_index;
> > +		mpd.last_page = -1;
> >  	} else {
> > -		index = wbc->range_start >> PAGE_CACHE_SHIFT;
> > -		end = wbc->range_end >> PAGE_CACHE_SHIFT;
> > +		mpd.first_page = wbc->range_start >> PAGE_CACHE_SHIFT;
> > +		mpd.last_page = wbc->range_end >> PAGE_CACHE_SHIFT;
> >  	}
> >  
> > +	mpd.inode = inode;
> > +	mpd.wbc = wbc;
> > +	ext4_io_submit_init(&mpd.io_submit, wbc);
> >  retry:
> >  	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
> > -		tag_pages_for_writeback(mapping, index, end);
> > -
> > +		tag_pages_for_writeback(mapping, mpd.first_page, mpd.last_page);
> > +	done = false;
> >  	blk_start_plug(&plug);
> > -	while (!ret && wbc->nr_to_write > 0) {
> > +	while (!done && mpd.first_page <= mpd.last_page) {
> > +		/* For each extent of pages we use new io_end */
> > +		mpd.io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
> > +		if (!mpd.io_submit.io_end) {
> > +			ret = -ENOMEM;
> > +			break;
> > +		}
> >  
> >  		/*
> > -		 * we  insert one extent at a time. So we need
> > -		 * credit needed for single extent allocation.
> > -		 * journalled mode is currently not supported
> > -		 * by delalloc
> > +		 * We have two constraints: We find one extent to map and we
> > +		 * must always write out whole page (makes a difference when
> > +		 * blocksize < pagesize) so that we don't block on IO when we
> > +		 * try to write out the rest of the page. Journalled mode is
> > +		 * not supported by delalloc.
> >  		 */
> >  		BUG_ON(ext4_should_journal_data(inode));
> >  		needed_blocks = ext4_da_writepages_trans_blocks(inode);
> >  
> > -		/* start a new transaction*/
> > +		/* start a new transaction */
> >  		handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
> >  					    needed_blocks);
> >  		if (IS_ERR(handle)) {
> > @@ -2339,76 +2306,67 @@ retry:
> >  			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
> >  			       "%ld pages, ino %lu; err %d", __func__,
> >  				wbc->nr_to_write, inode->i_ino, ret);
> > -			blk_finish_plug(&plug);
> > -			goto out_writepages;
> > +			/* Release allocated io_end */
> > +			ext4_put_io_end(mpd.io_submit.io_end);
> > +			break;
> >  		}
> >  
> > -		/*
> > -		 * Now call write_cache_pages_da() to find the next
> > -		 * contiguous region of logical blocks that need
> > -		 * blocks to be allocated by ext4 and submit them.
> > -		 */
> > -		ret = write_cache_pages_da(handle, mapping,
> > -					   wbc, &mpd, &done_index);
> > -		/*
> > -		 * If we have a contiguous extent of pages and we
> > -		 * haven't done the I/O yet, map the blocks and submit
> > -		 * them for I/O.
> > -		 */
> > -		if (!mpd.io_done && mpd.next_page != mpd.first_page) {
> > -			mpage_da_map_and_submit(&mpd);
> > -			ret = MPAGE_DA_EXTENT_TAIL;
> > +		trace_ext4_da_write_pages(inode, mpd.first_page, mpd.wbc);
> > +		ret = mpage_prepare_extent_to_map(&mpd);
> > +		if (!ret) {
> > +			if (mpd.map.m_len)
> > +				ret = mpage_map_and_submit_extent(handle, &mpd);
> > +			else {
> > +				/*
> > +				 * We scanned the whole range (or exhausted
> > +				 * nr_to_write), submitted what was mapped and
> > +				 * didn't find anything needing mapping. We are
> > +				 * done.
> > +				 */
> > +				done = true;
> > +			}
> >  		}
> > -		trace_ext4_da_write_pages(inode, &mpd);
> > -		wbc->nr_to_write -= mpd.pages_written;
> > -
> >  		ext4_journal_stop(handle);
> > -
> > -		if ((mpd.retval == -ENOSPC) && sbi->s_journal) {
> > -			/* commit the transaction which would
> > +		/* Submit prepared bio */
> > +		ext4_io_submit(&mpd.io_submit);
> > +		/* Unlock pages we didn't use */
> > +		mpage_release_unused_pages(&mpd, false);
> > +		/* Drop our io_end reference we got from init */
> > +		ext4_put_io_end(mpd.io_submit.io_end);
> > +
> > +		if (ret == -ENOSPC && sbi->s_journal) {
> > +			/*
> > +			 * Commit the transaction which would
> >  			 * free blocks released in the transaction
> >  			 * and try again
> >  			 */
> >  			jbd2_journal_force_commit_nested(sbi->s_journal);
> >  			ret = 0;
> > -		} else if (ret == MPAGE_DA_EXTENT_TAIL) {
> > -			/*
> > -			 * Got one extent now try with rest of the pages.
> > -			 * If mpd.retval is set -EIO, journal is aborted.
> > -			 * So we don't need to write any more.
> > -			 */
> > -			pages_written += mpd.pages_written;
> > -			ret = mpd.retval;
> > -			io_done = 1;
> > -		} else if (wbc->nr_to_write)
> > -			/*
> > -			 * There is no more writeout needed
> > -			 * or we requested for a noblocking writeout
> > -			 * and we found the device congested
> > -			 */
> > +			continue;
> > +		}
> > +		/* Fatal error - ENOMEM, EIO... */
> > +		if (ret)
> >  			break;
> >  	}
> >  	blk_finish_plug(&plug);
> > -	if (!io_done && !cycled) {
> > +	if (!ret && !cycled) {
> >  		cycled = 1;
> > -		index = 0;
> > -		wbc->range_start = index << PAGE_CACHE_SHIFT;
> > -		wbc->range_end  = mapping->writeback_index - 1;
> > +		mpd.last_page = writeback_index - 1;
> > +		mpd.first_page = 0;
> >  		goto retry;
> >  	}
> >  
> >  	/* Update index */
> > -	wbc->range_cyclic = range_cyclic;
> >  	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> >  		/*
> > -		 * set the writeback_index so that range_cyclic
> > +		 * Set the writeback_index so that range_cyclic
> >  		 * mode will write it back later
> >  		 */
> > -		mapping->writeback_index = done_index;
> > +		mapping->writeback_index = mpd.first_page;
> >  
> >  out_writepages:
> > -	wbc->range_start = range_start;
> > -	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
> > +	trace_ext4_da_writepages_result(inode, wbc, ret,
> > +					nr_to_write - wbc->nr_to_write);
> >  	return ret;
> >  }
> >  
> > diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> > index a601bb3..203dcd5 100644
> > --- a/include/trace/events/ext4.h
> > +++ b/include/trace/events/ext4.h
> > @@ -332,43 +332,59 @@ TRACE_EVENT(ext4_da_writepages,
> >  );
> >  
> >  TRACE_EVENT(ext4_da_write_pages,
> > -	TP_PROTO(struct inode *inode, struct mpage_da_data *mpd),
> > +	TP_PROTO(struct inode *inode, pgoff_t first_page,
> > +		 struct writeback_control *wbc),
> >  
> > -	TP_ARGS(inode, mpd),
> > +	TP_ARGS(inode, first_page, wbc),
> >  
> >  	TP_STRUCT__entry(
> >  		__field(	dev_t,	dev			)
> >  		__field(	ino_t,	ino			)
> > -		__field(	__u64,	b_blocknr		)
> > -		__field(	__u32,	b_size			)
> > -		__field(	__u32,	b_state			)
> > -		__field(	unsigned long,	first_page	)
> > -		__field(	int,	io_done			)
> > -		__field(	int,	pages_written		)
> > -		__field(	int,	sync_mode		)
> > +		__field(      pgoff_t,	first_page		)
> > +		__field(	 long,	nr_to_write		)
> > +		__field(	  int,	sync_mode		)
> >  	),
> >  
> >  	TP_fast_assign(
> >  		__entry->dev		= inode->i_sb->s_dev;
> >  		__entry->ino		= inode->i_ino;
> > -		__entry->b_blocknr	= mpd->b_blocknr;
> > -		__entry->b_size		= mpd->b_size;
> > -		__entry->b_state	= mpd->b_state;
> > -		__entry->first_page	= mpd->first_page;
> > -		__entry->io_done	= mpd->io_done;
> > -		__entry->pages_written	= mpd->pages_written;
> > -		__entry->sync_mode	= mpd->wbc->sync_mode;
> > +		__entry->first_page	= first_page;
> > +		__entry->nr_to_write	= wbc->nr_to_write;
> > +		__entry->sync_mode	= wbc->sync_mode;
> >  	),
> >  
> > -	TP_printk("dev %d,%d ino %lu b_blocknr %llu b_size %u b_state 0x%04x "
> > -		  "first_page %lu io_done %d pages_written %d sync_mode %d",
> > +	TP_printk("dev %d,%d ino %lu first_page %lu nr_to_write %ld "
> > +		  "sync_mode %d",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  (unsigned long) __entry->ino,
> > -		  __entry->b_blocknr, __entry->b_size,
> > -		  __entry->b_state, __entry->first_page,
> > -		  __entry->io_done, __entry->pages_written,
> > -		  __entry->sync_mode
> > -                  )
> > +		  (unsigned long) __entry->ino, __entry->first_page,
> > +		  __entry->nr_to_write, __entry->sync_mode)
> > +);
> > +
> > +TRACE_EVENT(ext4_da_write_pages_extent,
> > +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map),
> > +
> > +	TP_ARGS(inode, map),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	dev_t,	dev			)
> > +		__field(	ino_t,	ino			)
> > +		__field(	__u64,	lblk			)
> > +		__field(	__u32,	len			)
> > +		__field(	__u32,	flags			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->dev		= inode->i_sb->s_dev;
> > +		__entry->ino		= inode->i_ino;
> > +		__entry->lblk		= map->m_lblk;
> > +		__entry->len		= map->m_len;
> > +		__entry->flags		= map->m_flags;
> > +	),
> > +
> > +	TP_printk("dev %d,%d ino %lu lblk %llu len %u flags 0x%04x",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  (unsigned long) __entry->ino, __entry->lblk, __entry->len,
> > +		  __entry->flags)
> >  );
> >  
> >  TRACE_EVENT(ext4_da_writepages_result,
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
