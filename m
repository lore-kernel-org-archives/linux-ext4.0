From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add validation to jbd lock inversion patch and
	split and writepage
Date: Mon, 2 Jun 2008 11:31:06 +0200
Message-ID: <20080602093106.GB30613@duck.suse.cz>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33340 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbYFBJbJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 05:31:09 -0400
Content-Disposition: inline
In-Reply-To: <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Aneesh,

  Thanks for the patch but I though we decided to do this a bit differently -
see below.

On Fri 30-05-08 19:09:27, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 156 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a96c325..b122425 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1479,6 +1479,11 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
>  	return 0;
>  }
>  
> +static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> +{
> +	return (!buffer_mapped(bh) || buffer_delay(bh));
> +}
> +
>  /*
>   * Note that we don't need to start a transaction unless we're journaling
>   * data because we should have holes filled from ext4_page_mkwrite(). If
> @@ -1531,18 +1536,26 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
>  static int __ext4_ordered_writepage(struct page *page,
>  				struct writeback_control *wbc)
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
> -	if (!page_has_buffers(page)) {
> -		create_empty_buffers(page, inode->i_sb->s_blocksize,
> -				(1 << BH_Dirty)|(1 << BH_Uptodate));
> -	}
  This is OK.

>  	page_bufs = page_buffers(page);
> -	walk_page_buffers(handle, page_bufs, 0,
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
> +
> +	if (walk_page_buffers(NULL, page_bufs, 0,
> +				len, NULL, ext4_bh_unmapped_or_delay)) {
> +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> +								__func__);
> +		BUG();
> +	}
  But I'd move this check to ext4_ordered_writepage().

> +	walk_page_buffers(NULL, page_bufs, 0,
>  			PAGE_CACHE_SIZE, NULL, bget_one);
>  
>  	ret = block_write_full_page(page, ext4_get_block, wbc);
> @@ -1574,8 +1587,8 @@ static int __ext4_ordered_writepage(struct page *page,
>  			ret = err;
>  	}
>  out_put:
> -	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
> -			  bput_one);
> +	walk_page_buffers(handle, page_bufs, 0,
> +				PAGE_CACHE_SIZE, NULL, bput_one);
>  	return ret;
>  }
>  
> @@ -1583,7 +1596,7 @@ static int ext4_ordered_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
>  	J_ASSERT(PageLocked(page));
> -
> +	BUG_ON(!page_has_buffers(page));
>  	/*
>  	 * We give up here if we're reentered, because it might be for a
>  	 * different filesystem.
> @@ -1599,18 +1612,34 @@ static int ext4_ordered_writepage(struct page *page,
>  static int __ext4_writeback_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
> +	unsigned long len;
> +	struct buffer_head *page_bufs;
>  	struct inode *inode = page->mapping->host;
> +	loff_t size = i_size_read(inode);
> +
> +	page_bufs = page_buffers(page);
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
>  
> +	if (walk_page_buffers(NULL, page_bufs, 0,
> +				len, NULL, ext4_bh_unmapped_or_delay)) {
> +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> +								__func__);
> +		BUG();
> +	}
  And similarly move this check to ext4_writeback_writepage().

>  	if (test_opt(inode->i_sb, NOBH))
>  		return nobh_writepage(page, ext4_get_block, wbc);
>  	else
>  		return block_write_full_page(page, ext4_get_block, wbc);
>  }
>  
> -
>  static int ext4_writeback_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
> +	BUG_ON(!page_has_buffers(page));
> +
>  	if (!ext4_journal_current_handle())
>  		return __ext4_writeback_writepage(page, wbc);
>  
> @@ -1622,18 +1651,31 @@ static int ext4_writeback_writepage(struct page *page,
>  static int __ext4_journalled_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
> +	int ret = 0, err;
> +	unsigned long len;
> +	handle_t *handle = NULL;
>  	struct address_space *mapping = page->mapping;
>  	struct inode *inode = mapping->host;
>  	struct buffer_head *page_bufs;
> -	handle_t *handle = NULL;
> -	int ret = 0;
> -	int err;
> +	loff_t size = i_size_read(inode);
> +
> +	page_bufs = page_buffers(page);
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
>  
> +	if (walk_page_buffers(NULL, page_bufs, 0,
> +				len, NULL, ext4_bh_unmapped_or_delay)) {
> +		printk(KERN_CRIT "%s called with unmapped or delay buffer\n",
> +								__func__);
> +		BUG();
> +	}
> +	/* FIXME!! do we need to call prepare_write for a mapped buffer */
  This can go to ext4_journalled_writepage(). What is actually this FIXME
about? I'm not sure I get it...

>  	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
>  	if (ret != 0)
>  		goto out_unlock;
>  
> -	page_bufs = page_buffers(page);
>  	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
>  								bget_one);
>  	/* As soon as we unlock the page, it can go away, but we have
> @@ -1671,14 +1713,13 @@ static int __ext4_journalled_writepage(struct page *page,
>  static int ext4_journalled_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
> +	BUG_ON(!page_has_buffers(page));
> +
>  	if (ext4_journal_current_handle())
>  		goto no_write;
>  
> -	if (!page_has_buffers(page) || PageChecked(page)) {
> -		/*
> -		 * It's mmapped pagecache.  Add buffers and journal it.  There
> -		 * doesn't seem much point in redirtying the page here.
> -		 */
> +	if (PageChecked(page)) {
> +		/* dirty pages in data=journal mode */
>  		ClearPageChecked(page);
>  		return __ext4_journalled_writepage(page, wbc);
>  	} else {
> @@ -3520,6 +3561,96 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  	return err;
>  }
>  
> +static int __ext4_journalled_allocpage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	int ret = 0, err;
> +	handle_t *handle = NULL;
> +	struct address_space *mapping = page->mapping;
> +	struct inode *inode = mapping->host;
> +	struct buffer_head *page_bufs;
> +
> +	/* if alloc we are called after statring a journal */
> +	handle = ext4_journal_current_handle();
> +	BUG_ON(!handle);
> +
> +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> +	if (ret != 0)
> +		goto out_unlock;
> +
> +	/* FIXME!! should we do a bget_one */
> +	page_bufs = page_buffers(page);
> +	ret = walk_page_buffers(handle, page_bufs, 0,
> +			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
> +
> +	err = walk_page_buffers(handle, page_bufs, 0,
> +				PAGE_CACHE_SIZE, NULL, write_end_fn);
> +	if (ret == 0)
> +		ret = err;
> +	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
> +
> +out_unlock:
> +	unlock_page(page);
> +	return ret;
> +}
> +
> +static int __ext4_ordered_allocpage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	int ret = 0;
> +	handle_t *handle = NULL;
> +	struct buffer_head *page_bufs;
> +	struct inode *inode = page->mapping->host;
> +
> +	/* if alloc we are called after statring a journal */
> +	handle = ext4_journal_current_handle();
> +	BUG_ON(!handle);
> +	if (!page_has_buffers(page)) {
> +		create_empty_buffers(page, inode->i_sb->s_blocksize,
> +				(1 << BH_Dirty)|(1 << BH_Uptodate));
> +	}
> +	page_bufs = page_buffers(page);
> +	walk_page_buffers(handle, page_bufs, 0,
> +			PAGE_CACHE_SIZE, NULL, bget_one);
> +
> +	ret = block_write_full_page(page, ext4_get_block, wbc);
> +
> +	/*
> +	 * The page can become unlocked at any point now, and
> +	 * truncate can then come in and change things.  So we
> +	 * can't touch *page from now on.  But *page_bufs is
> +	 * safe due to elevated refcount.
> +	 */
> +
> +	/*
> +	 * And attach them to the current transaction.  But only if
> +	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
> +	 * and generally junk.
> +	 */
> +	if (ret == 0) {
> +		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
> +					NULL, jbd2_journal_dirty_data_fn);
> +	}
> +	walk_page_buffers(handle, page_bufs, 0,
> +				PAGE_CACHE_SIZE, NULL, bput_one);
> +	return ret;
> +}
> +
> +static int __ext4_writeback_allocpage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	handle_t *handle = NULL;
> +	struct inode *inode = page->mapping->host;
> +	/* if alloc we are called after statring a journal */
> +	handle = ext4_journal_current_handle();
> +	BUG_ON(!handle);
> +
> +	if (test_opt(inode->i_sb, NOBH))
> +		return nobh_writepage(page, ext4_get_block, wbc);
> +	else
> +		return block_write_full_page(page, ext4_get_block, wbc);
> +}
> +
  And then you don't need these __ext4_..._allocpage() calls because that
is what's left in __ext4_..._writepage(), isn't it? It seems also logically
more consistent - you do checks in ext4_..._writepage() and then you do the
real work in __ext4_..._writepage().
  For data=journaled mode, it may be better to really have
ext4_journaled_allocpage() because we don't have to do nasty locking
tricks. But for writeback and ordered mode I really see no need for these
special functions. So at least for these two, I'd change the code as I
suggest.

>  static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
>  {
>  	if (!buffer_mapped(bh)) {
> @@ -3596,11 +3727,11 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  	wbc.range_start = page_offset(page);
>  	wbc.range_end = page_offset(page) + len;
>  	if (ext4_should_writeback_data(inode))
> -		ret = __ext4_writeback_writepage(page, &wbc);
> +		ret = __ext4_writeback_allocpage(page, &wbc);
>  	else if (ext4_should_order_data(inode))
> -		ret = __ext4_ordered_writepage(page, &wbc);
> +		ret = __ext4_ordered_allocpage(page, &wbc);
>  	else
> -		ret = __ext4_journalled_writepage(page, &wbc);
> +		ret = __ext4_journalled_allocpage(page, &wbc);
>  	/* Page got unlocked in writepage */
>  	err = ext4_journal_stop(handle);
>  	if (!ret)
> -- 
> 1.5.5.1.357.g1af8b.dirty

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
