From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Mon, 26 May 2008 23:30:43 +0530
Message-ID: <20080526180043.GB14718@skywalker>
References: <20080415161430.GC28699@duck.suse.cz> <20080521082109.GA18746@skywalker> <20080526172124.GK32407@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57836 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbYEZSAw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 14:00:52 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4QI0M5B013723
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 04:00:22 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4QI4xan271558
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 04:04:59 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4QI0nNe003175
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 04:00:50 +1000
Content-Disposition: inline
In-Reply-To: <20080526172124.GK32407@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 26, 2008 at 07:21:24PM +0200, Jan Kara wrote:
> On Wed 21-05-08 13:51:09, Aneesh Kumar K.V wrote:

[....snip.....]

> >  {
> > @@ -3837,7 +3850,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> >  	if (ext4_should_writeback_data(inode))
> >  		ret = __ext4_writeback_writepage(page, &wbc);
> >  	else if (ext4_should_order_data(inode))
> > -		ret = __ext4_ordered_writepage(page, &wbc);
> > +		ret = __ext4_ordered_alloc_and_writepage(page, &wbc, 1);
> >  	else
> >  		ret = __ext4_journalled_writepage(page, &wbc);
> >  	/* Page got unlocked in writepage */
> > 
> > 
> > 
> > ie we call __ext4_ordered_alloc_and_writepage with alloc = 1 only in
> > case of page_mkwrite. All the other case we should have all the buffer
> > heads mapped. Otherwise we will try to allocate new blocks which starts
> > a new transaction holding page lock.
>   When do we try to allocate new blocks in writepage now? ext4_page_mkwrite()
> should have done the allocation before writepage() was called so there
> should be no need to allocate anything... But maybe I miss something.

That's what i also meant by the above changes. The block are allocated
only in ext4_page_mkwrite and not during writepage. So calling
ext4_*_writepage during mkwrite confuse quiet a lot. Instead i was
trying to make it explicit by making page_mkwrite call
ext4_ordered_alloc_and_writepage and  by adding BUG() in writepage
callback if it ever get called by an unmapped buffer.


I have got another question now related to page_mkwrite. AFAIU writepage
writeout dirty buffer_heads. It also looks at whether the pages are
dirty or not. In the page_mkwrite callback both are not true. ie we call
set_page_dirty from do_wp_page after calling page_mkwrite. I haven't
verified whether the above is correct or not. Just thinking reading the
code.


> 
> > > -static int ext4_writeback_writepage(struct page *page,
> > > +static int __ext4_writeback_writepage(struct page *page,
> > >  				struct writeback_control *wbc)
> > >  {
> > >  	struct inode *inode = page->mapping->host;
> > > +
> > > +	if (test_opt(inode->i_sb, NOBH))
> > > +		return nobh_writepage(page, ext4_get_block, wbc);
> > > +	else
> > > +		return block_write_full_page(page, ext4_get_block, wbc);
> > > +}
> > > +
> > > +
> > > +static int ext4_writeback_writepage(struct page *page,
> > > +				struct writeback_control *wbc)
> > > +{
> > > +	if (!ext4_journal_current_handle())
> > > +		return __ext4_writeback_writepage(page, wbc);
> > > +
> > > +	redirty_page_for_writepage(wbc, page);
> > > +	unlock_page(page);
> > > +	return 0;
> > > +}
> > > +
> > > +static int __ext4_journalled_writepage(struct page *page,
> > > +				struct writeback_control *wbc)
> > > +{
> > > +	struct address_space *mapping = page->mapping;
> > > +	struct inode *inode = mapping->host;
> > > +	struct buffer_head *page_bufs;
> > >  	handle_t *handle = NULL;
> > >  	int ret = 0;
> > >  	int err;
> > > 
> > > -	if (ext4_journal_current_handle())
> > > -		goto out_fail;
> > > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > > +	if (ret != 0)
> > > +		goto out_unlock;
> > > +
> > > +	page_bufs = page_buffers(page);
> > > +	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> > > +								bget_one);
> > > +	/* As soon as we unlock the page, it can go away, but we have
> > > +	 * references to buffers so we are safe */
> > > +	unlock_page(page);
> > > 
> > >  	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > >  	if (IS_ERR(handle)) {
> > >  		ret = PTR_ERR(handle);
> > > -		goto out_fail;
> > > +		goto out;
> > >  	}
> > > 
> > > -	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> > > -		ret = nobh_writepage(page, ext4_get_block, wbc);
> > > -	else
> > > -		ret = block_write_full_page(page, ext4_get_block, wbc);
> > > +	ret = walk_page_buffers(handle, page_bufs, 0,
> > > +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > > 
> > > +	err = walk_page_buffers(handle, page_bufs, 0,
> > > +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > > +	if (ret == 0)
> > > +		ret = err;
> > >  	err = ext4_journal_stop(handle);
> > >  	if (!ret)
> > >  		ret = err;
> > > -	return ret;
> > > 
> > > -out_fail:
> > > -	redirty_page_for_writepage(wbc, page);
> > > +	walk_page_buffers(handle, page_bufs, 0,
> > > +				PAGE_CACHE_SIZE, NULL, bput_one);
> > > +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > > +	goto out;
> > > +
> > > +out_unlock:
> > >  	unlock_page(page);
> > > +out:
> > >  	return ret;
> > >  }
> > > 
> > >  static int ext4_journalled_writepage(struct page *page,
> > >  				struct writeback_control *wbc)
> > >  {
> > > -	struct inode *inode = page->mapping->host;
> > > -	handle_t *handle = NULL;
> > > -	int ret = 0;
> > > -	int err;
> > > -
> > >  	if (ext4_journal_current_handle())
> > >  		goto no_write;
> > > 
> > > -	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > > -	if (IS_ERR(handle)) {
> > > -		ret = PTR_ERR(handle);
> > > -		goto no_write;
> > > -	}
> > > -
> > >  	if (!page_has_buffers(page) || PageChecked(page)) {
> > 
> > 
> > This will never happen with writepage right ? And we don't call 
> > ext4_journalled_writepage from page_mkwrite. So is this needed ?
> > If not __ext4_journalled_writepage can handle everything in a single
> > transaction right  and assume that it is called within a transaction.
>   I'm not sure I understand you. PageChecked() can happen from writepage
> call path. We set PageChecked() when we do set_page_dirty() as far as I
> remember... Basically, we use this flag to decide whether writepage should
> do checkpointing or write into the journal.


What i meant by the above question was can ext4_journalled_writepage get
called with page_buffers == NULL 

So the check if (!page_has_buffers(page)) can go away right ?

I have posted some changes after this at
http://article.gmane.org/gmane.comp.file-systems.ext4/6768
Message-Id: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>


-aneesh
