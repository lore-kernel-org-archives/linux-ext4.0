From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Tue, 27 May 2008 14:43:12 +0200
Message-ID: <20080527124312.GG5178@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <20080521082109.GA18746@skywalker> <20080526172124.GK32407@duck.suse.cz> <20080526180043.GB14718@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47509 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbYE0MnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2008 08:43:14 -0400
Content-Disposition: inline
In-Reply-To: <20080526180043.GB14718@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-05-08 23:30:43, Aneesh Kumar K.V wrote:
> On Mon, May 26, 2008 at 07:21:24PM +0200, Jan Kara wrote:
> > On Wed 21-05-08 13:51:09, Aneesh Kumar K.V wrote:
> > >  {
> > > @@ -3837,7 +3850,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> > >  	if (ext4_should_writeback_data(inode))
> > >  		ret = __ext4_writeback_writepage(page, &wbc);
> > >  	else if (ext4_should_order_data(inode))
> > > -		ret = __ext4_ordered_writepage(page, &wbc);
> > > +		ret = __ext4_ordered_alloc_and_writepage(page, &wbc, 1);
> > >  	else
> > >  		ret = __ext4_journalled_writepage(page, &wbc);
> > >  	/* Page got unlocked in writepage */
> > > 
> > > 
> > > 
> > > ie we call __ext4_ordered_alloc_and_writepage with alloc = 1 only in
> > > case of page_mkwrite. All the other case we should have all the buffer
> > > heads mapped. Otherwise we will try to allocate new blocks which starts
> > > a new transaction holding page lock.
> >   When do we try to allocate new blocks in writepage now? ext4_page_mkwrite()
> > should have done the allocation before writepage() was called so there
> > should be no need to allocate anything... But maybe I miss something.
> 
> That's what i also meant by the above changes. The block are allocated
  Ah, Ok. Sorry, I misunderstood your previous email.

> only in ext4_page_mkwrite and not during writepage. So calling
> ext4_*_writepage during mkwrite confuse quiet a lot. Instead i was
> trying to make it explicit by making page_mkwrite call
> ext4_ordered_alloc_and_writepage and  by adding BUG() in writepage
> callback if it ever get called by an unmapped buffer.
  I see. I agree with the change in principle, but I'd just add this
check directly into ext4_ordered_writepage() (and similarly to
ext4_writeback_writepage() and ext4_journaled_writepage()) - there it makes
more sence and you don't have to pass the 'alloc' argument you proposed.
  I can do this when we agree on how to resolve problems of delalloc mode
with this patch.

> I have got another question now related to page_mkwrite. AFAIU writepage
> writeout dirty buffer_heads. It also looks at whether the pages are
> dirty or not. In the page_mkwrite callback both are not true. ie we call
> set_page_dirty from do_wp_page after calling page_mkwrite. I haven't
> verified whether the above is correct or not. Just thinking reading the
> code.
  Writepage call itself doesn't look at whether the page is dirty or not -
that flag is already cleared when writepage is called. You are right that
the page is marked dirty only after page_mkwrite is called - the meaning of
page_mkwrite() call is roughly "someone wants to do the first write to this
page via mmap, prepare filesystem for that". But we don't really care
whether the page is dirty or not - we know it carries correct data (it is
uptodate) and so we can write it if we want (and need).

> > > > -static int ext4_writeback_writepage(struct page *page,
> > > > +static int __ext4_writeback_writepage(struct page *page,
> > > >  				struct writeback_control *wbc)
> > > >  {
> > > >  	struct inode *inode = page->mapping->host;
> > > > +
> > > > +	if (test_opt(inode->i_sb, NOBH))
> > > > +		return nobh_writepage(page, ext4_get_block, wbc);
> > > > +	else
> > > > +		return block_write_full_page(page, ext4_get_block, wbc);
> > > > +}
> > > > +
> > > > +
> > > > +static int ext4_writeback_writepage(struct page *page,
> > > > +				struct writeback_control *wbc)
> > > > +{
> > > > +	if (!ext4_journal_current_handle())
> > > > +		return __ext4_writeback_writepage(page, wbc);
> > > > +
> > > > +	redirty_page_for_writepage(wbc, page);
> > > > +	unlock_page(page);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int __ext4_journalled_writepage(struct page *page,
> > > > +				struct writeback_control *wbc)
> > > > +{
> > > > +	struct address_space *mapping = page->mapping;
> > > > +	struct inode *inode = mapping->host;
> > > > +	struct buffer_head *page_bufs;
> > > >  	handle_t *handle = NULL;
> > > >  	int ret = 0;
> > > >  	int err;
> > > > 
> > > > -	if (ext4_journal_current_handle())
> > > > -		goto out_fail;
> > > > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > > > +	if (ret != 0)
> > > > +		goto out_unlock;
> > > > +
> > > > +	page_bufs = page_buffers(page);
> > > > +	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> > > > +								bget_one);
> > > > +	/* As soon as we unlock the page, it can go away, but we have
> > > > +	 * references to buffers so we are safe */
> > > > +	unlock_page(page);
> > > > 
> > > >  	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > > >  	if (IS_ERR(handle)) {
> > > >  		ret = PTR_ERR(handle);
> > > > -		goto out_fail;
> > > > +		goto out;
> > > >  	}
> > > > 
> > > > -	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> > > > -		ret = nobh_writepage(page, ext4_get_block, wbc);
> > > > -	else
> > > > -		ret = block_write_full_page(page, ext4_get_block, wbc);
> > > > +	ret = walk_page_buffers(handle, page_bufs, 0,
> > > > +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > > > 
> > > > +	err = walk_page_buffers(handle, page_bufs, 0,
> > > > +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > > > +	if (ret == 0)
> > > > +		ret = err;
> > > >  	err = ext4_journal_stop(handle);
> > > >  	if (!ret)
> > > >  		ret = err;
> > > > -	return ret;
> > > > 
> > > > -out_fail:
> > > > -	redirty_page_for_writepage(wbc, page);
> > > > +	walk_page_buffers(handle, page_bufs, 0,
> > > > +				PAGE_CACHE_SIZE, NULL, bput_one);
> > > > +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > > > +	goto out;
> > > > +
> > > > +out_unlock:
> > > >  	unlock_page(page);
> > > > +out:
> > > >  	return ret;
> > > >  }
> > > > 
> > > >  static int ext4_journalled_writepage(struct page *page,
> > > >  				struct writeback_control *wbc)
> > > >  {
> > > > -	struct inode *inode = page->mapping->host;
> > > > -	handle_t *handle = NULL;
> > > > -	int ret = 0;
> > > > -	int err;
> > > > -
> > > >  	if (ext4_journal_current_handle())
> > > >  		goto no_write;
> > > > 
> > > > -	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> > > > -	if (IS_ERR(handle)) {
> > > > -		ret = PTR_ERR(handle);
> > > > -		goto no_write;
> > > > -	}
> > > > -
> > > >  	if (!page_has_buffers(page) || PageChecked(page)) {
> > > 
> > > 
> > > This will never happen with writepage right ? And we don't call 
> > > ext4_journalled_writepage from page_mkwrite. So is this needed ?
> > > If not __ext4_journalled_writepage can handle everything in a single
> > > transaction right  and assume that it is called within a transaction.
> >   I'm not sure I understand you. PageChecked() can happen from writepage
> > call path. We set PageChecked() when we do set_page_dirty() as far as I
> > remember... Basically, we use this flag to decide whether writepage should
> > do checkpointing or write into the journal.
> 
> What i meant by the above question was can ext4_journalled_writepage get
> called with page_buffers == NULL 
> 
> So the check if (!page_has_buffers(page)) can go away right ?
  I see. Well, you may be right but I'd rather leave the check there.
In page_mkwrite() we don't necessarily attach buffers to the page (if it
has PageMappedToDisk set) - that should not currently happen in
data=journal mode but in principle in future it could and there's no reason
to really forbid that.

> I have posted some changes after this at
> http://article.gmane.org/gmane.comp.file-systems.ext4/6768
> Message-Id: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
  Thanks for the pointer. I was at a conference last week and so I didn't
catch up with the mailing lists yet. Sorry for the confusion. Your post also
explains some questions I had in my previous emails about how do we proceed
with combination of lock-inversion and delalloc. So you don't have to
answer ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
