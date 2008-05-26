From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Mon, 26 May 2008 19:21:24 +0200
Message-ID: <20080526172124.GK32407@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <20080521082109.GA18746@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44943 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753852AbYEZRV0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 13:21:26 -0400
Content-Disposition: inline
In-Reply-To: <20080521082109.GA18746@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-05-08 13:51:09, Aneesh Kumar K.V wrote:
> On Tue, Apr 15, 2008 at 06:14:30PM +0200, Jan Kara wrote:
> >   Hi,
> > 
> >   I've ported my patch inversing locking ordering of page_lock and
> > transaction start to ext4 (on top of ext4 patch queue). Everything except
> > delayed allocation is converted (the patch is below for interested
> > readers). The question is how to proceed with delayed allocation. Its
> > current implementation in VFS is designed to work well with the old
> > ordering (page lock first, then start a transaction). We could bend it to
> > work with the new locking ordering but I really see no point since ext4 is
> > the only user. Also XFS has AFAIK ordering first start transaction, then
> > lock pages so if we should ever merge delayed alloc implementations the new
> > ordering would make it easier.
> >   So what do people think here? Do you agree with reimplementing current
> > mpage_da_... functions? Eric, I guess you have the best clue how XFS does
> > this, do you have some advices? Also maybe pointers into XFS code would be
> > useful if it is reasonably readable :). Thanks.
> > 
> > 								Honza
> 
> 
> [....snip....]
> 
> >   */
> > -static int ext4_ordered_writepage(struct page *page,
> > +static int __ext4_ordered_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> >  	struct inode *inode = page->mapping->host;
> > @@ -1723,22 +1694,6 @@ static int ext4_ordered_writepage(struct page *page,
> >  	int ret = 0;
> >  	int err;
> > 
> > -	J_ASSERT(PageLocked(page));
> > -
> > -	/*
> > -	 * We give up here if we're reentered, because it might be for a
> > -	 * different filesystem.
> > -	 */
> > -	if (ext4_journal_current_handle())
> > -		goto out_fail;
> > -
> > -	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > -
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -		goto out_fail;
> > -	}
> > -
> >  	if (!page_has_buffers(page)) {
> >  		create_empty_buffers(page, inode->i_sb->s_blocksize,
> >  				(1 << BH_Dirty)|(1 << BH_Uptodate));
> > @@ -1762,114 +1717,139 @@ static int ext4_ordered_writepage(struct page *page,
> >  	 * and generally junk.
> >  	 */
> >  	if (ret == 0) {
> > -		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
> > +		handle = ext4_journal_start(inode,
> > +					ext4_writepage_trans_blocks(inode));
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> > +			goto out_put;
> > +		}
> > +
> > +		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
> >  					NULL, jbd2_journal_dirty_data_fn);
> > +		err = ext4_journal_stop(handle);
> >  		if (!ret)
> >  			ret = err;
> >  	}
> > -	walk_page_buffers(handle, page_bufs, 0,
> > -			PAGE_CACHE_SIZE, NULL, bput_one);
> > -	err = ext4_journal_stop(handle);
> > -	if (!ret)
> > -		ret = err;
> > +out_put:
> > +	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> > +			  bput_one);
> >  	return ret;
> > +}
> > +
> > +static int ext4_ordered_writepage(struct page *page,
> > +				struct writeback_control *wbc)
> > +{
> > +	J_ASSERT(PageLocked(page));
> > +
> > +	/*
> > +	 * We give up here if we're reentered, because it might be for a
> > +	 * different filesystem.
> > +	 */
> > +	if (!ext4_journal_current_handle())
> > +		return __ext4_ordered_writepage(page, wbc);
> > 
> > -out_fail:
> >  	redirty_page_for_writepage(wbc, page);
> >  	unlock_page(page);
> > -	return ret;
> > +	return 0;
> >  }
> 
> 
> How about change below to make sure we don't have a deadlock.
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9d1d07b..85de163 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1718,6 +1718,10 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
>  	return 0;
>  }
>  
> +static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
> +{
> +	return !buffer_mapped(bh);
> +}
>  /*
>   * Note that we don't need to start a transaction unless we're journaling
>   * data because we should have holes filled from ext4_page_mkwrite(). If
> @@ -1767,20 +1771,33 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
>   * us.
>   *
>   */
> -static int __ext4_ordered_writepage(struct page *page,
> -				struct writeback_control *wbc)
> +static int __ext4_ordered_alloc_and_writepage(struct page *page,
> +				struct writeback_control *wbc, int alloc)
>  {
> -	struct inode *inode = page->mapping->host;
> -	struct buffer_head *page_bufs;
> +	int ret = 0, err;
> +	unsigned long len;
>  	handle_t *handle = NULL;
> -	int ret = 0;
> -	int err;
> +	struct buffer_head *page_bufs;
> +	struct inode *inode = page->mapping->host;
> +	loff_t size = i_size_read(inode);
>  
>  	if (!page_has_buffers(page)) {
>  		create_empty_buffers(page, inode->i_sb->s_blocksize,
>  				(1 << BH_Dirty)|(1 << BH_Uptodate));
>  	}
>  	page_bufs = page_buffers(page);
> +
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
> +
> +	if (!alloc && walk_page_buffers(NULL, page_bufs, 0,
> +					len, NULL, ext4_bh_unmapped)) {
> +		printk(KERN_CRIT "%s called with unmapped buffer\n",
> +								__func__);
> +		BUG();
> +	}
>  	walk_page_buffers(handle, page_bufs, 0,
>  			PAGE_CACHE_SIZE, NULL, bget_one);
>  
> @@ -1828,7 +1845,7 @@ static int ext4_ordered_writepage(struct page *page,
>  	 * different filesystem.
>  	 */
>  	if (!ext4_journal_current_handle())
> -		return __ext4_ordered_writepage(page, wbc);
> +		return __ext4_ordered_alloc_and_writepage(page, wbc, 0);
>  
>  	redirty_page_for_writepage(wbc, page);
>  	unlock_page(page);
> @@ -3777,10 +3794,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  	return err;
>  }
>  
> -static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
> -{
> -	return !buffer_mapped(bh);
> -}
>  
>  int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  {
> @@ -3837,7 +3850,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  	if (ext4_should_writeback_data(inode))
>  		ret = __ext4_writeback_writepage(page, &wbc);
>  	else if (ext4_should_order_data(inode))
> -		ret = __ext4_ordered_writepage(page, &wbc);
> +		ret = __ext4_ordered_alloc_and_writepage(page, &wbc, 1);
>  	else
>  		ret = __ext4_journalled_writepage(page, &wbc);
>  	/* Page got unlocked in writepage */
> 
> 
> 
> ie we call __ext4_ordered_alloc_and_writepage with alloc = 1 only in
> case of page_mkwrite. All the other case we should have all the buffer
> heads mapped. Otherwise we will try to allocate new blocks which starts
> a new transaction holding page lock.
  When do we try to allocate new blocks in writepage now? ext4_page_mkwrite()
should have done the allocation before writepage() was called so there
should be no need to allocate anything... But maybe I miss something.

> > -static int ext4_writeback_writepage(struct page *page,
> > +static int __ext4_writeback_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> >  	struct inode *inode = page->mapping->host;
> > +
> > +	if (test_opt(inode->i_sb, NOBH))
> > +		return nobh_writepage(page, ext4_get_block, wbc);
> > +	else
> > +		return block_write_full_page(page, ext4_get_block, wbc);
> > +}
> > +
> > +
> > +static int ext4_writeback_writepage(struct page *page,
> > +				struct writeback_control *wbc)
> > +{
> > +	if (!ext4_journal_current_handle())
> > +		return __ext4_writeback_writepage(page, wbc);
> > +
> > +	redirty_page_for_writepage(wbc, page);
> > +	unlock_page(page);
> > +	return 0;
> > +}
> > +
> > +static int __ext4_journalled_writepage(struct page *page,
> > +				struct writeback_control *wbc)
> > +{
> > +	struct address_space *mapping = page->mapping;
> > +	struct inode *inode = mapping->host;
> > +	struct buffer_head *page_bufs;
> >  	handle_t *handle = NULL;
> >  	int ret = 0;
> >  	int err;
> > 
> > -	if (ext4_journal_current_handle())
> > -		goto out_fail;
> > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > +	if (ret != 0)
> > +		goto out_unlock;
> > +
> > +	page_bufs = page_buffers(page);
> > +	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> > +								bget_one);
> > +	/* As soon as we unlock the page, it can go away, but we have
> > +	 * references to buffers so we are safe */
> > +	unlock_page(page);
> > 
> >  	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> >  	if (IS_ERR(handle)) {
> >  		ret = PTR_ERR(handle);
> > -		goto out_fail;
> > +		goto out;
> >  	}
> > 
> > -	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> > -		ret = nobh_writepage(page, ext4_get_block, wbc);
> > -	else
> > -		ret = block_write_full_page(page, ext4_get_block, wbc);
> > +	ret = walk_page_buffers(handle, page_bufs, 0,
> > +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > 
> > +	err = walk_page_buffers(handle, page_bufs, 0,
> > +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > +	if (ret == 0)
> > +		ret = err;
> >  	err = ext4_journal_stop(handle);
> >  	if (!ret)
> >  		ret = err;
> > -	return ret;
> > 
> > -out_fail:
> > -	redirty_page_for_writepage(wbc, page);
> > +	walk_page_buffers(handle, page_bufs, 0,
> > +				PAGE_CACHE_SIZE, NULL, bput_one);
> > +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > +	goto out;
> > +
> > +out_unlock:
> >  	unlock_page(page);
> > +out:
> >  	return ret;
> >  }
> > 
> >  static int ext4_journalled_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> > -	struct inode *inode = page->mapping->host;
> > -	handle_t *handle = NULL;
> > -	int ret = 0;
> > -	int err;
> > -
> >  	if (ext4_journal_current_handle())
> >  		goto no_write;
> > 
> > -	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -		goto no_write;
> > -	}
> > -
> >  	if (!page_has_buffers(page) || PageChecked(page)) {
> 
> 
> This will never happen with writepage right ? And we don't call 
> ext4_journalled_writepage from page_mkwrite. So is this needed ?
> If not __ext4_journalled_writepage can handle everything in a single
> transaction right  and assume that it is called within a transaction.
  I'm not sure I understand you. PageChecked() can happen from writepage
call path. We set PageChecked() when we do set_page_dirty() as far as I
remember... Basically, we use this flag to decide whether writepage should
do checkpointing or write into the journal.

> >  		/*
> >  		 * It's mmapped pagecache.  Add buffers and journal it.  There
> >  		 * doesn't seem much point in redirtying the page here.
> >  		 */
> >  		ClearPageChecked(page);
> > -		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
> > -					ext4_get_block);
> > -		if (ret != 0) {
> > -			ext4_journal_stop(handle);
> > -			goto out_unlock;
> > -		}
> > -		ret = walk_page_buffers(handle, page_buffers(page), 0,
> > -			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > -
> > -		err = walk_page_buffers(handle, page_buffers(page), 0,
> > -				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > -		if (ret == 0)
> > -			ret = err;
> > -		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > -		unlock_page(page);
> > +		return __ext4_journalled_writepage(page, wbc);
> >  	} else {
> >  		/*
> >  		 * It may be a page full of checkpoint-mode buffers.  We don't
> >  		 * really know unless we go poke around in the buffer_heads.
> >  		 * But block_write_full_page will do the right thing.
> >  		 */
> > -		ret = block_write_full_page(page, ext4_get_block, wbc);
> > +		return block_write_full_page(page, ext4_get_block, wbc);
> >  	}
> > -	err = ext4_journal_stop(handle);
> > -	if (!ret)
> > -		ret = err;
> > -out:
> > -	return ret;
> > -
> >  no_write:
> >  	redirty_page_for_writepage(wbc, page);
> > -out_unlock:
> >  	unlock_page(page);
> > -	goto out;
> > +	return 0;
> >  }

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
