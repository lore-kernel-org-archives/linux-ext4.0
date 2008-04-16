From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Wed, 16 Apr 2008 12:55:18 -0700
Message-ID: <1208375718.17986.7.camel@badari-desktop>
References: <20080415161430.GC28699@duck.suse.cz>
	 <1208282932.3636.9.camel@localhost.localdomain>
	 <1208302106.3636.47.camel@localhost.localdomain>
	 <1208302397.3636.49.camel@localhost.localdomain>
	 <20080416103531.GC6116@duck.suse.cz>
	 <1208370260.3603.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:33296 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYDPTzT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 15:55:19 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3GJtIAc010298
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:55:18 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3GJtIMT136590
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 13:55:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3GJtHKf030315
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 13:55:18 -0600
In-Reply-To: <1208370260.3603.4.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-04-16 at 11:24 -0700, Mingming Cao wrote:
> On Wed, 2008-04-16 at 12:35 +0200, Jan Kara wrote:
> > On Tue 15-04-08 16:33:17, Mingming Cao wrote:
> > > On Tue, 2008-04-15 at 16:28 -0700, Mingming Cao wrote:
> > > > On Tue, 2008-04-15 at 11:08 -0700, Mingming Cao wrote:
> > > > > On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
> > > > > >   Hi,
> > > > > > 
> > > > > >   I've ported my patch inversing locking ordering of page_lock and
> > > > > > transaction start to ext4 (on top of ext4 patch queue). Everything except
> > > > > > delayed allocation is converted (the patch is below for interested
> > > > > > readers). The question is how to proceed with delayed allocation. Its
> > > > > > current implementation in VFS is designed to work well with the old
> > > > > > ordering (page lock first, then start a transaction). We could bend it to
> > > > > > work with the new locking ordering but I really see no point since ext4 is
> > > > > > the only user. 
> > > > > 
> > > > > I think the plan is port the changes to ext2/3/JFS and support delayed
> > > > > allocation on those filesystems. 
> > > > > 
> > > > > > Also XFS has AFAIK ordering first start transaction, then
> > > > > > lock pages so if we should ever merge delayed alloc implementations the new
> > > > > > ordering would make it easier.
> > > > > >   So what do people think here? Do you agree with reimplementing current
> > > > > > mpage_da_... functions?
> > > > > 
> > > > > It worth a try, but I could not see how to bend delayed allocation to
> > > > > work the new ordering:( With delayed allocation Ext4 gets into
> > > > > writepage() directly with page locked, but we need to start transaction
> > > > > to do block allocation...:(
> > > > 
> > > > Looked again it seems possible to reservse the order with delayed
> > > > allocation. with ext3_da_writepgaes() we could start the journal before
> > > > calling mpage_da_writepages()(which will lock the pages), instead of
> > > > start the journal inside ext4_da_get_block_write(). So that we could get
> > > > the locking order right. Just need to taking care of the estimated
> > > > credits right.
> > > > 
> > > > How about this? (untested, just throw out for comment)
> > > 
> > > Seems sent out an old version, this version compiles
> >   Thanks for the patch. Some comments are below.
> > 
> > > ---
> > >  fs/ext4/inode.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 40 insertions(+), 13 deletions(-)
> > > 
> > > Index: linux-2.6.25-rc9/fs/ext4/inode.c
> > > ===================================================================
> > > --- linux-2.6.25-rc9.orig/fs/ext4/inode.c	2008-04-15 15:40:33.000000000 -0700
> > > +++ linux-2.6.25-rc9/fs/ext4/inode.c	2008-04-15 16:32:10.000000000 -0700
> > > @@ -1437,18 +1437,12 @@ static int ext4_da_get_block_prep(struct
> > >  static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
> > >  				   struct buffer_head *bh_result, int create)
> > >  {
> > > -	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
> > > +	int ret;
> > >  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > >  	loff_t disksize = EXT4_I(inode)->i_disksize;
> > >  	handle_t *handle = NULL;
> > >  
> > > -	if (create) {
> > > -		handle = ext4_journal_start(inode, needed_blocks);
> > > -		if (IS_ERR(handle)) {
> > > -			ret = PTR_ERR(handle);
> > > -			goto out;
> > > -		}
> > > -	}
> > > +	handle = ext4_journal_current_handle();
> >   Maybe we could assert that handle != NULL? When using delayed allocation,
> > a transaction should always be started.
> > 
> Agreed.
> 
> > >  	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> > >  				   bh_result, create, 0);
> > > @@ -1483,17 +1477,51 @@ static int ext4_da_get_block_write(struc
> > >  		ret = 0;
> > >  	}
> > >  
> > > -out:
> > > -	if (handle && !IS_ERR(handle))
> > > -		ext4_journal_stop(handle);
> > > -
> > >  	return ret;
> > >  }
> > >  
> > > +/*
> > > + * For now just follow the DIO way to estimate the max credits
> > > + * needed to write out EXT4_MAX_BUF_BLOCKS pages.
> > > + * todo: need to calculate the max credits need for
> > > + * extent based files, currently the DIO credits is based on
> > > + * indirect-blocks mapping way.
> > > + *
> > > + * Probably should have a generic way to calculate credits
> > > + * for DIO, writepages, and truncate
> > > + */
> > > +#define EXT4_MAX_BUF_BLOCKS	DIO_MAX_BLOCKS
> > > +#define EXT4_MAX_BUF_CREDITS	DIO_CREDITS
> > > +
> > >  static int ext4_da_writepages(struct address_space *mapping,
> > >  				struct writeback_control *wbc)
> > >  {
> > > -	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> > > +	struct inode *inode = mapping->host;
> > > +	handle_t *handle = NULL;
> > > +	int needed_blocks;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * Estimate the worse case needed credits to write out
> > > +	 * EXT4_MAX_BUF_BLOCKS pages
> > > +	 */
> > > +	needed_blocks = EXT4_MAX_BUF_CREDITS;
> > > +
> > > +	/* start the transaction with credits*/
> > > +	handle = ext4_journal_start(inode, needed_blocks);
> > > +	if (IS_ERR(handle)) {
> > > +		ret = PTR_ERR(handle);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* set the max pages could be write-out at a time */
> > > +	wbc->range_end = wbc->range_start +
> > > +			EXT4_MAX_BUF_BLOCKS << PAGE_CACHE_SHIFT - 1;
> >   I think limiting mpage_da_writepages through nr_to_write is better than
> > through range_end. That way you don't count clean pages...
> > 
> 
> You are right. 
> 
> > > +
> > > +	ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> > > +	ext4_journal_stop(handle);
> >   But here we can't just stop. We have to write everything original caller
> > has asked about (at least in WB_SYNC_ALL mode). But the question is where
> > to resume because scanning the whole range again is kind-of excessive and
> > prone do livelock with other process dirtying the file via mmap. Maybe if
> > we slightly modified write_cache_pages() to always store in writeback_index
> > where they finished, we could use this value.
> 
> Thanks for pointing this out.
> How about this? 
> ---
>  fs/ext4/inode.c     |   70 ++++++++++++++++++++++++++++++++++++++++++----------
>  mm/page-writeback.c |    2 -
>  2 files changed, 58 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6.25-rc9/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.25-rc9.orig/fs/ext4/inode.c	2008-04-16 09:59:00.000000000 -0700
> +++ linux-2.6.25-rc9/fs/ext4/inode.c	2008-04-16 11:23:12.000000000 -0700
> @@ -1437,18 +1437,13 @@ static int ext4_da_get_block_prep(struct
>  static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
>  				   struct buffer_head *bh_result, int create)
>  {
> -	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
> +	int ret;
>  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
>  	loff_t disksize = EXT4_I(inode)->i_disksize;
>  	handle_t *handle = NULL;
>  
> -	if (create) {
> -		handle = ext4_journal_start(inode, needed_blocks);
> -		if (IS_ERR(handle)) {
> -			ret = PTR_ERR(handle);
> -			goto out;
> -		}
> -	}
> +	J_ASSERT(handle != NULL || create == 0);
> +	handle = ext4_journal_current_handle();
>  
>  	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
>  				   bh_result, create, 0);
> @@ -1483,17 +1478,66 @@ static int ext4_da_get_block_write(struc
>  		ret = 0;
>  	}
>  
> -out:
> -	if (handle && !IS_ERR(handle))
> -		ext4_journal_stop(handle);
> -
>  	return ret;
>  }
>  
> +/*
> + * For now just follow the DIO way to estimate the max credits
> + * needed to write out EXT4_MAX_WRITEBACK_PAGES.
> + * todo: need to calculate the max credits need for
> + * extent based files, currently the DIO credits is based on
> + * indirect-blocks mapping way.
> + *
> + * Probably should have a generic way to calculate credits
> + * for DIO, writepages, and truncate
> + */
> +#define EXT4_MAX_WRITEBACK_PAGES	DIO_MAX_BLOCKS
> +#define EXT4_MAX_WRITEBACK_CREDITS	DIO_CREDITS
> +
>  static int ext4_da_writepages(struct address_space *mapping,
>  				struct writeback_control *wbc)
>  {
> -	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> +	struct inode *inode = mapping->host;
> +	handle_t *handle = NULL;
> +	int needed_blocks;
> +	int ret = 0;
> +	unsigned range_cyclic;
> +	long to_write;
> +
> +	/*
> +	 * Estimate the worse case needed credits to write out
> +	 * EXT4_MAX_BUF_BLOCKS pages
> +	 */
> +	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
> +
> +	to_write = wbc->nr_to_write;
> +	range_cyclic = wbc->range_cyclic;
> +	wbc->range_cyclic = 1;
> +
> +	while (!ret && to_write) {
> +		/* start a new transaction*/
> +		handle = ext4_journal_start(inode, needed_blocks);
> +		if (IS_ERR(handle)) {
> +			ret = PTR_ERR(handle);
> +			goto out_writepages;
> +		}
> +		/*
> +		 * set the max dirty pages could be write at a time
> +		 * to fit into the reserved transaction credits
> +		 */
> +		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> +			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> +		to_write -= wbc->nr_to_write;
> +
> +		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> +		ext4_journal_stop(handle);
> +		to_write +=wbc->nr_to_write;
> +	}

You need to set wbc->nr_to_write in the loop before calling
mpage_da_write_page() (for the next iteration).

> +
> +out_writepages:
> +	wbc->nr_to_write = to_write;
> +	wbc->range_cyclic = range_cyclic;
> +	return ret;
>  }
>  
>  static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
> Index: linux-2.6.25-rc9/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.25-rc9.orig/mm/page-writeback.c	2008-04-16 11:00:20.000000000 -0700
> +++ linux-2.6.25-rc9/mm/page-writeback.c	2008-04-16 11:07:59.000000000 -0700
> @@ -816,7 +816,7 @@ int write_cache_pages(struct address_spa
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
>  		index = mapping->writeback_index; /* Start from prev offset */
> -		end = -1;
> +		  end = wbc->range_end >> PAGE_CACHE_SHIFT;

Hmm. There are other callers to write_cache_pages() using
"range_cyclic" . Did you check them to make sure, they set range_end
correctly ?

Thanks,
Badari

