From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add validation to jbd lock inversion patch and
	split and writepage
Date: Mon, 2 Jun 2008 12:40:48 +0200
Message-ID: <20080602104048.GH30613@duck.suse.cz>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093106.GB30613@duck.suse.cz> <20080602095222.GA9225@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36069 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756104AbYFBKkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 06:40:49 -0400
Content-Disposition: inline
In-Reply-To: <20080602095222.GA9225@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-06-08 15:22:22, Aneesh Kumar K.V wrote:
> Hi Jan,
> 
> 
> On Mon, Jun 02, 2008 at 11:31:06AM +0200, Jan Kara wrote:
> >   Hi Aneesh,
> > 
> >   Thanks for the patch but I though we decided to do this a bit differently -
> > see below.
> 
> Please feel free to merge the changes back to the lock inversion
> patches. I sent it as a separate the patches to make it easier for review.
  OK, thanks. I'll look into this.

> > >  
> > > +	if (walk_page_buffers(NULL, page_bufs, 0,
> > > +				len, NULL, ext4_bh_unmapped_or_delay)) {
> > > +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> > > +								__func__);
> > > +		BUG();
> > > +	}
> > > +	/* FIXME!! do we need to call prepare_write for a mapped buffer */
> >   This can go to ext4_journalled_writepage(). What is actually this FIXME
> > about? I'm not sure I get it...
> > 
> I was wondering whether we need to call prepare_write in writepage ?. We
> are not allocating any new blocks in writepage with these changes.
  Ah, I see. I'm only not sure whether we can rely on all buffers in the
page being uptodate... Otherwise I think block_prepare_write() is not
needed.

> > >  	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > >  	if (ret != 0)
> > >  		goto out_unlock;
> > >  
> > > -	page_bufs = page_buffers(page);
> > >  	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> > >  								bget_one);
> > >  	/* As soon as we unlock the page, it can go away, but we have
> > > @@ -1671,14 +1713,13 @@ static int __ext4_journalled_writepage(struct page *page,
> > >  static int ext4_journalled_writepage(struct page *page,
> > >  				struct writeback_control *wbc)
> > >  {
> > > +	BUG_ON(!page_has_buffers(page));
> > > +
> > >  	if (ext4_journal_current_handle())
> > >  		goto no_write;
> > >  
> > > -	if (!page_has_buffers(page) || PageChecked(page)) {
> > > -		/*
> > > -		 * It's mmapped pagecache.  Add buffers and journal it.  There
> > > -		 * doesn't seem much point in redirtying the page here.
> > > -		 */
> > > +	if (PageChecked(page)) {
> > > +		/* dirty pages in data=journal mode */
> > >  		ClearPageChecked(page);
> > >  		return __ext4_journalled_writepage(page, wbc);
> > >  	} else {
> > > @@ -3520,6 +3561,96 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> > >  	return err;
> > >  }
> > >  
> > > +static int __ext4_journalled_allocpage(struct page *page,
> > > +				struct writeback_control *wbc)
> > > +{
> > > +	int ret = 0, err;
> > > +	handle_t *handle = NULL;
> > > +	struct address_space *mapping = page->mapping;
> > > +	struct inode *inode = mapping->host;
> > > +	struct buffer_head *page_bufs;
> > > +
> > > +	/* if alloc we are called after statring a journal */
> > > +	handle = ext4_journal_current_handle();
> > > +	BUG_ON(!handle);
> > > +
> > > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > > +	if (ret != 0)
> > > +		goto out_unlock;
> > > +
> > > +	/* FIXME!! should we do a bget_one */
> > > +	page_bufs = page_buffers(page);
> > > +	ret = walk_page_buffers(handle, page_bufs, 0,
> > > +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > > +
> I also have a FIXME here. I am not sure whether unlocking the page have
> some effect. Can you verify this ?
  Well, you unlock the page only after you're completely done with it as
far as I read the code. So that is correct. You only need to get references
to buffers when you need to access them after you unlock the page.

> > > +	err = walk_page_buffers(handle, page_bufs, 0,
> > > +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > > +	if (ret == 0)
> > > +		ret = err;
> > > +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > > +
> > > +out_unlock:
> > > +	unlock_page(page);
> > > +	return ret;
> > > +}
> > > +

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
