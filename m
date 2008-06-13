From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4: Add ordered mode support for delalloc
Date: Fri, 13 Jun 2008 16:01:22 -0700
Message-ID: <1213398082.27507.27.camel@BVR-FS.beaverton.ibm.com>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56325 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYFMXBI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 19:01:08 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5DN109K001432
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 19:01:00 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5DN0x9Z227464
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 19:00:59 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5DN0w93028578
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 19:00:58 -0400
In-Reply-To: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, some comments below...
On Thu, 2008-06-12 at 20:55 +0530, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c  |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/jbd2/commit.c |   41 ++++++++++++--
>  2 files changed, 198 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 63355ab..7d87641 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1606,13 +1606,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
>  	return !buffer_mapped(bh) || buffer_delay(bh);
>  }
> 
> -/* FIXME!! only support data=writeback mode */
>  /*
>   * get called vi ext4_da_writepages after taking page lock
>   * We may end up doing block allocation here in case
>   * mpage_da_map_blocks failed to allocate blocks.
>   */
> -static int ext4_da_writepage(struct page *page,
> +static int ext4_da_writeback_writepage(struct page *page,
>  				struct writeback_control *wbc)
>  {
>  	int ret = 0;
> @@ -1660,6 +1659,61 @@ static int ext4_da_writepage(struct page *page,
>  	return ret;
>  }
> 
> +/*
> + * get called vi ext4_da_writepages after taking page lock
> + * We may end up doing block allocation here in case
> + * mpage_da_map_blocks failed to allocate blocks.
> + *
> + * We also get called via journal_submit_inode_data_buffers
> + */
> +static int ext4_da_ordered_writepage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	int ret = 0;
> +	loff_t size;
> +	unsigned long len;
> +	handle_t *handle = NULL;
> +	struct buffer_head *page_bufs;
> +	struct inode *inode = page->mapping->host;
> +
> +	handle = ext4_journal_current_handle();
> +	if (!handle) {
> +		/*
> +		 * This can happen when we aren't called via
> +		 * ext4_da_writepages() but directly (shrink_page_list).
> +		 * We cannot easily start a transaction here so we just skip
> +		 * writing the page in case we would have to do so.
> +		 */
> +		size = i_size_read(inode);
> +
> +		page_bufs = page_buffers(page);
> +		if (page->index == size >> PAGE_CACHE_SHIFT)
> +			len = size & ~PAGE_CACHE_MASK;
> +		else
> +			len = PAGE_CACHE_SIZE;
> +
> +		if (walk_page_buffers(NULL, page_bufs, 0,
> +				len, NULL, ext4_bh_unmapped_or_delay)) {
> +			/*
> +			 * We can't do block allocation under
> +			 * page lock without a handle . So redirty
> +			 * the page and return.
> +			 * We may reach here when we do a journal commit
> +			 * via journal_submit_inode_data_buffers.
> +			 * If we don't have mapping block we just ignore
> +			 * them
> +			 *
> +			 */
> +			redirty_page_for_writepage(wbc, page);
> +			unlock_page(page);
> +			return 0;
> +		}
> +	}
> +
It seems we missed to file the inode to the journal list before calling
block_write_full_page(), since it's possible block_write_full_page()
could do block allocation.

something like this?

+ if (ext4_should_order_data(inode))
+		ret = ext4_jbd2_file_inode(handle, inode);
+		if (ret) {
+			ext4_journal_stop(handle);
+			return ret;	
+		}

> +	ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> +


> +	return ret;
> +}
> 

It seems this code is duplicated from
ext4_da_writeback_writepage()(except for the file inode to keep the
ordering), is there any reason not to making it one function for both
ordered mode and writeback mode?
>  /*
>   * For now just follow the DIO way to estimate the max credits
> @@ -1745,19 +1799,99 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	return ret;
>  }
> 
> +static int ext4_da_ordered_writepages(struct address_space *mapping,
> +				struct writeback_control *wbc)
> +{
> +	struct inode *inode = mapping->host;
> +	handle_t *handle = NULL;
> +	int needed_blocks;
> +	int ret = 0;
> +	long to_write;
> +	loff_t range_start = 0;
> +
> +
> +	/*
> +	 * No pages to write? This is mainly a kludge to avoid starting
> +	 * a transaction for special inodes like journal inode on last iput()
> +	 * because that could violate lock ordering on umount
> +	 */
> +	if (!mapping->nrpages)
> +		return 0;
> +
> +	/*
> +	 *  Estimate the worse case needed credits to write out
> +	 * EXT4_MAX_BUF_BLOCKS pages
> +	 */
> +	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
> +
> +	to_write = wbc->nr_to_write;
> +	if (!wbc->range_cyclic) {
> +		/*
> +		 * If range_cyclic is not set force range_cont
> +		 * and save the old writeback_index
> +		 */
> +		wbc->range_cont = 1;
> +		range_start =  wbc->range_start;
> +	}
> +
> +	while (!ret && to_write) {
> +		/* start a new transaction*/
> +		handle = ext4_journal_start(inode, needed_blocks);
> +		if (IS_ERR(handle)) {
> +			ret = PTR_ERR(handle);
> +			goto out_writepages;
> +		}
> +
> +		ret = ext4_jbd2_file_inode(handle, inode);
> +		if (ret) {
> +			ext4_journal_stop(handle);
> +			goto out_writepages;
> +		}
> +		/*
> +		 * set the max dirty pages could be write at a time
> +		 * to fit into the reserved transaction credits
> +		 */
> +		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> +			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> +
> +		to_write -= wbc->nr_to_write;
> +		ret = mpage_da_writepages(mapping, wbc,
> +						ext4_da_get_block_write);
> +		ext4_journal_stop(handle);
> +		if (wbc->nr_to_write) {
> +			/*
> +			 * There is no more writeout needed
> +			 * or we requested for a noblocking writeout
> +			 * and we found the device congested
> +			 */
> +			to_write += wbc->nr_to_write;
> +			break;
> +		}
> +		wbc->nr_to_write = to_write;
> +	}
> +
> +out_writepages:
> +	wbc->nr_to_write = to_write;
> +	if (range_start)
> +		wbc->range_start = range_start;
> +	return ret;
> +}
> +

It seems this code is duplicated from
ext4_da_writeback_writepages()also.  The only part different is in
ordered mode, we need to  file the inode to the journal list to keep the
ordering. I think we could use existing da_writepages() function for
both ordered mode and writeback mode as well.

>  static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  				loff_t pos, unsigned len, unsigned flags,
>  				struct page **pagep, void **fsdata)
>  {
> -	int ret;
> +	int ret, retries = 0;
>  	struct page *page;
>  	pgoff_t index;
>  	unsigned from, to;
> +	struct inode *inode = mapping->host;
> 
>  	index = pos >> PAGE_CACHE_SHIFT;
>  	from = pos & (PAGE_CACHE_SIZE - 1);
>  	to = from + len;
> 
> +retry:
>  	page = __grab_cache_page(mapping, index);
>  	if (!page)
>  		return -ENOMEM;
> @@ -1770,6 +1904,9 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>  		page_cache_release(page);
>  	}
> 
> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
> +
>  	return ret;
>  }
> 

In case of ENOSPC, instead of go back and try to do reservation (which
may overestimate the total number of metablocks to reserve) again, I
think we should not doing delayed allocation, instead call the real
get_block() function to try the real block allocation.

Just to clarify, this is not part of the ordered mode support, I think
we should make a separate patch for this kind of improvement.

> @@ -2224,10 +2361,10 @@ static int ext4_journalled_set_page_dirty(struct page *page)
>  	.releasepage	= ext4_releasepage,
>  };
> 
> -static const struct address_space_operations ext4_da_aops = {
> +static const struct address_space_operations ext4_da_writeback_aops = {
>  	.readpage	= ext4_readpage,
>  	.readpages	= ext4_readpages,
> -	.writepage	= ext4_da_writepage,
> +	.writepage	= ext4_da_writeback_writepage,
>  	.writepages	= ext4_da_writepages,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= ext4_da_write_begin,
> @@ -2239,13 +2376,31 @@ static int ext4_journalled_set_page_dirty(struct page *page)
>  	.migratepage	= buffer_migrate_page,
>  };
> 
> +static const struct address_space_operations ext4_da_ordered_aops = {
> +	.readpage	= ext4_readpage,
> +	.readpages	= ext4_readpages,
> +	.writepage	= ext4_da_ordered_writepage,
> +	.writepages	= ext4_da_ordered_writepages,
> +	.sync_page	= block_sync_page,
> +	.write_begin	= ext4_da_write_begin,
> +	.write_end	= generic_write_end,
> +	.bmap		= ext4_bmap,
> +	.invalidatepage	= ext4_da_invalidatepage,
> +	.releasepage	= ext4_releasepage,
> +	.direct_IO	= ext4_direct_IO,
> +	.migratepage	= buffer_migrate_page,
> +};
> +

With the new ordered mode, we could share the same address space
operations for delayed allocation over writeback and ordered mode.


>  void ext4_set_aops(struct inode *inode)
>  {
> -	if (ext4_should_order_data(inode))
> +	if (ext4_should_order_data(inode) &&
> +		test_opt(inode->i_sb, DELALLOC))
> +		inode->i_mapping->a_ops = &ext4_da_ordered_aops;
> +	else if (ext4_should_order_data(inode))
>  		inode->i_mapping->a_ops = &ext4_ordered_aops;
>  	else if (ext4_should_writeback_data(inode) &&
>  		 test_opt(inode->i_sb, DELALLOC))
> -		inode->i_mapping->a_ops = &ext4_da_aops;
> +		inode->i_mapping->a_ops = &ext4_da_writeback_aops;
>  	else if (ext4_should_writeback_data(inode))
>  		inode->i_mapping->a_ops = &ext4_writeback_aops;
>  	else
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 483183d..32ca3c3 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -22,6 +22,8 @@
>  #include <linux/pagemap.h>
>  #include <linux/jiffies.h>
>  #include <linux/crc32.h>
> +#include <linux/writeback.h>
> +#include <linux/backing-dev.h>
> 
>  /*
>   * Default IO end handler for temporary BJ_IO buffer_heads.
> @@ -185,6 +187,30 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
>  }
> 
>  /*
> + * write the filemap data using writepage() address_space_operations.
> + * We don't do block allocation here even for delalloc. We don't
> + * use writepages() because with dealyed allocation we may be doing
> + * block allocation in writepages().
> + */
> +static int journal_submit_inode_data_buffers(struct address_space *mapping)
> +{
> +	int ret;
> +	struct writeback_control wbc = {
> +		.sync_mode =  WB_SYNC_ALL,
> +		.nr_to_write = mapping->nrpages * 2,
> +		.range_start = 0,
> +		.range_end = i_size_read(mapping->host),
> +		.for_writepages = 1,
> +	};
> +
> +	if (!mapping_cap_writeback_dirty(mapping))
> +		return 0;
> +
> +	ret = generic_writepages(mapping, &wbc);
> +	return ret;
> +}
> +
> +/*
>   * Submit all the data buffers of inode associated with the transaction to
>   * disk.
>   *
> @@ -192,7 +218,7 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
>   * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
>   * operate on from being released while we write out pages.
>   */
> -static int journal_submit_inode_data_buffers(journal_t *journal,
> +static int journal_submit_data_buffers(journal_t *journal,
>  		transaction_t *commit_transaction)
>  {
>  	struct jbd2_inode *jinode;
> @@ -204,8 +230,13 @@ static int journal_submit_inode_data_buffers(journal_t *journal,
>  		mapping = jinode->i_vfs_inode->i_mapping;
>  		jinode->i_flags |= JI_COMMIT_RUNNING;
>  		spin_unlock(&journal->j_list_lock);
> -		err = filemap_fdatawrite_range(mapping, 0,
> -					i_size_read(jinode->i_vfs_inode));
> +		/*
> +		 * submit the inode data buffers. We use writepage
> +		 * instead of writepages. Because writepages can do
> +		 * block allocation  with delalloc. We need to write
> +		 * only allocated blocks here.
> +		 */

Hmm, when writepage()->ext4_da_orderd_writepage() is called from here,
the handle is expecting to be NULL? Otherwise block_write_full_page()
could do block allocation, that's against the locking ordering...:(

> +		err = journal_submit_inode_data_buffers(mapping);
>  		if (!ret)
>  			ret = err;
>  		spin_lock(&journal->j_list_lock);
> @@ -228,7 +259,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
>  	struct jbd2_inode *jinode, *next_i;
>  	int err, ret = 0;
> 
> -	/* For locking, see the comment in journal_submit_inode_data_buffers() */
> +	/* For locking, see the comment in journal_submit_data_buffers() */
>  	spin_lock(&journal->j_list_lock);
>  	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
>  		jinode->i_flags |= JI_COMMIT_RUNNING;
> @@ -431,7 +462,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 * Now start flushing things to disk, in the order they appear
>  	 * on the transaction lists.  Data blocks go first.
>  	 */
> -	err = journal_submit_inode_data_buffers(journal, commit_transaction);
> +	err = journal_submit_data_buffers(journal, commit_transaction);
>  	if (err)
>  		jbd2_journal_abort(journal, err);
> 

Regards,
Mingming

