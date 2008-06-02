From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Add validation to jbd lock inversion patch and
	split and writepage
Date: Mon, 2 Jun 2008 15:22:22 +0530
Message-ID: <20080602095222.GA9225@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602093106.GB30613@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58268 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYFBJwr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 05:52:47 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m529pl3u011933
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 19:51:47 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m529qEC94743272
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 19:52:14 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m529qVxl028086
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 19:52:31 +1000
Content-Disposition: inline
In-Reply-To: <20080602093106.GB30613@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,


On Mon, Jun 02, 2008 at 11:31:06AM +0200, Jan Kara wrote:
>   Hi Aneesh,
> 
>   Thanks for the patch but I though we decided to do this a bit differently -
> see below.

Please feel free to merge the changes back to the lock inversion
patches. I sent it as a separate the patches to make it easier for review.

> 
> On Fri 30-05-08 19:09:27, Aneesh Kumar K.V wrote:
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 156 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index a96c325..b122425 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1479,6 +1479,11 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> >  	return 0;
> >  }
> >  
> > +static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> > +{
> > +	return (!buffer_mapped(bh) || buffer_delay(bh));
> > +}
> > +
> >  /*
> >   * Note that we don't need to start a transaction unless we're journaling
> >   * data because we should have holes filled from ext4_page_mkwrite(). If
> > @@ -1531,18 +1536,26 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
> >  static int __ext4_ordered_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> > -	struct inode *inode = page->mapping->host;
> > -	struct buffer_head *page_bufs;
> > +	int ret = 0, err;
> > +	unsigned long len;
> >  	handle_t *handle = NULL;
> > -	int ret = 0;
> > -	int err;
> > +	struct buffer_head *page_bufs;
> > +	struct inode *inode = page->mapping->host;
> > +	loff_t size = i_size_read(inode);
> >  
> > -	if (!page_has_buffers(page)) {
> > -		create_empty_buffers(page, inode->i_sb->s_blocksize,
> > -				(1 << BH_Dirty)|(1 << BH_Uptodate));
> > -	}
>   This is OK.
> 
> >  	page_bufs = page_buffers(page);
> > -	walk_page_buffers(handle, page_bufs, 0,
> > +	if (page->index == size >> PAGE_CACHE_SHIFT)
> > +		len = size & ~PAGE_CACHE_MASK;
> > +	else
> > +		len = PAGE_CACHE_SIZE;
> > +
> > +	if (walk_page_buffers(NULL, page_bufs, 0,
> > +				len, NULL, ext4_bh_unmapped_or_delay)) {
> > +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> > +								__func__);
> > +		BUG();
> > +	}
>   But I'd move this check to ext4_ordered_writepage().
> 

Please feel free to do so. The only reason for me to do it as a separate
function is to clarify that with the changes writepage doesn't do any
block allocation at all. And calling writepage via page_mkwrite goes
against that. So i renamed the page_mkwrite call out to *_allocpage
and made sure writepage doesn't do any block allocation.



> > +	walk_page_buffers(NULL, page_bufs, 0,
> >  			PAGE_CACHE_SIZE, NULL, bget_one);
> >  

[.... snip ..... ]

> >  
> > +	if (walk_page_buffers(NULL, page_bufs, 0,
> > +				len, NULL, ext4_bh_unmapped_or_delay)) {
> > +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> > +								__func__);
> > +		BUG();
> > +	}
> > +	/* FIXME!! do we need to call prepare_write for a mapped buffer */
>   This can go to ext4_journalled_writepage(). What is actually this FIXME
> about? I'm not sure I get it...
> 


I was wondering whether we need to call prepare_write in writepage ?. We
are not allocating any new blocks in writepage with these changes.


> >  	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> >  	if (ret != 0)
> >  		goto out_unlock;
> >  
> > -	page_bufs = page_buffers(page);
> >  	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> >  								bget_one);
> >  	/* As soon as we unlock the page, it can go away, but we have
> > @@ -1671,14 +1713,13 @@ static int __ext4_journalled_writepage(struct page *page,
> >  static int ext4_journalled_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> > +	BUG_ON(!page_has_buffers(page));
> > +
> >  	if (ext4_journal_current_handle())
> >  		goto no_write;
> >  
> > -	if (!page_has_buffers(page) || PageChecked(page)) {
> > -		/*
> > -		 * It's mmapped pagecache.  Add buffers and journal it.  There
> > -		 * doesn't seem much point in redirtying the page here.
> > -		 */
> > +	if (PageChecked(page)) {
> > +		/* dirty pages in data=journal mode */
> >  		ClearPageChecked(page);
> >  		return __ext4_journalled_writepage(page, wbc);
> >  	} else {
> > @@ -3520,6 +3561,96 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> >  	return err;
> >  }
> >  
> > +static int __ext4_journalled_allocpage(struct page *page,
> > +				struct writeback_control *wbc)
> > +{
> > +	int ret = 0, err;
> > +	handle_t *handle = NULL;
> > +	struct address_space *mapping = page->mapping;
> > +	struct inode *inode = mapping->host;
> > +	struct buffer_head *page_bufs;
> > +
> > +	/* if alloc we are called after statring a journal */
> > +	handle = ext4_journal_current_handle();
> > +	BUG_ON(!handle);
> > +
> > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > +	if (ret != 0)
> > +		goto out_unlock;
> > +
> > +	/* FIXME!! should we do a bget_one */
> > +	page_bufs = page_buffers(page);
> > +	ret = walk_page_buffers(handle, page_bufs, 0,
> > +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> > +


I also have a FIXME here. I am not sure whether unlocking the page have
some effect. Can you verify this ?



> > +	err = walk_page_buffers(handle, page_bufs, 0,
> > +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> > +	if (ret == 0)
> > +		ret = err;
> > +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> > +
> > +out_unlock:
> > +	unlock_page(page);
> > +	return ret;
> > +}
> > +


-aneesh
