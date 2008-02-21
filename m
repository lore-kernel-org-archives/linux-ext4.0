From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Thu, 21 Feb 2008 13:07:17 -0800
Message-ID: <1203628037.3638.21.camel@localhost.localdomain>
References: <20080221191747.GA8292@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47107 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbYBUVHi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 16:07:38 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1LL7Z03000301
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 16:07:36 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1LL7ZHG182048
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 16:07:35 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1LL7ZEF009668
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 16:07:35 -0500
In-Reply-To: <20080221191747.GA8292@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,

It's a good start, a few comments below..

On Fri, 2008-02-22 at 00:47 +0530, Aneesh Kumar K.V wrote:
> From 6a73edd4dbb32344e6a83ebdc07edd0e96d376bd Mon Sep 17 00:00:00 2001
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: Thu, 21 Feb 2008 23:57:38 +0530
> Subject: [PATCH] ext4: Convert uninitialized extent to initialized extent in case of file system full
> 
> A write to prealloc area cause the split of unititalized extent into a initialized
> and uninitialized extent. If we don't have space to add new extent information instead
> of returning error convert the existing uninitialized extent to initialized one. We
> need to zero out the blocks corresponding to the extent to prevent wrong data reaching
> userspace.
> 

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 133 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b179b03..d37c14e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2137,6 +2137,103 @@ void ext4_ext_release(struct super_block *sb)
>  #endif
>  }
> 
> +static int ext4_ext_zero_out(handle_t *handle, struct inode *inode,
> +				ext4_lblk_t iblock, struct ext4_extent *ex)
> +{
> +	ext4_lblk_t ee_block;
> +	unsigned int ee_len, blkcount, blocksize;
> +	loff_t pos;
> +	pgoff_t index, skip_index;
> +	unsigned long offset;
> +	struct page *page;
> +	struct address_space *mapping = inode->i_mapping;
> +	struct buffer_head *head, *bh;
> +	int err = 0;
> +
> +	ee_block = le32_to_cpu(ex->ee_block);
> +	ee_len = blkcount = ext4_ext_get_actual_len(ex);
> +	blocksize = inode->i_sb->s_blocksize;
> +
> +	/*
> +	 * find the skip index. We can't call __grab_cache_page for this
> +	 * because we are in the writeout of this page and we already have
> +	 * taken the lock on this page
> +	 */
> +	pos = iblock <<  inode->i_blkbits;
> +	skip_index = pos >> PAGE_CACHE_SHIFT;
> +

We should not need to look up the page cache to do the zero out. The
approach I had thought is just zero it out on disk.

> +	while (blkcount) {
> +		pos = (ee_block  + ee_len - blkcount) << inode->i_blkbits;
> +		index = pos >> PAGE_CACHE_SHIFT;
> +		offset = (pos & (PAGE_CACHE_SIZE - 1));
> +		if (index == skip_index) {
> +			/* Page will already be locked in the writepage */
> +			read_lock_irq(&mapping->tree_lock);
> +			page = radix_tree_lookup(&mapping->page_tree, index);
> +			read_unlock_irq(&mapping->tree_lock);
> +			if (page)
> +				page_cache_get(page);
> +			else
> +				return -ENOMEM;
> +		} else {
> +			page = __grab_cache_page(mapping, index);
> +			if (!page)
> +				return -ENOMEM;
> +		}
> +

I the page is already locked before calling get_block() via writepage(),
isn't it? and the journal transaction already started...


> +		if (!page_has_buffers(page))
> +			create_empty_buffers(page, blocksize, 0);
> +
> +		head = page_buffers(page);
> +		/* Look for the buffer_head which map the block */
> +		bh = head;
> +		while (offset > 0) {
> +			bh = bh->b_this_page;
> +			offset -= blocksize;
> +		}
> +		offset = (pos & (PAGE_CACHE_SIZE - 1));
> +
> +		/* Now write all the buffer_heads in the page */
> +		do {
> +			set_buffer_uptodate(bh);
> +			if (ext4_should_journal_data(inode)) {
> +				err = ext4_journal_get_write_access(handle, bh);
> +				/* do we have that many credits ??*/
> +				if (err)
> +					goto err_out;
> +			}
> +			zero_user(page, offset, blocksize);

Ah oh, you are trying to zero out the pages in the page cache, that's
seems wrong to me. By the time get_block() is called from writepages(),
the pages should have meaningful content that needs to flush to disk,
zero the pages out will lost the data.

> +			offset += blocksize;
> +			if (ext4_should_journal_data(inode)) {
> +				err = ext4_journal_dirty_metadata(handle, bh);
> +				if (err)
> +					goto err_out;
> +			} else {
> +				if (ext4_should_order_data(inode)) {
> +					err = ext4_journal_dirty_data(handle,
> +									bh);
> +					if (err)
> +						goto err_out;
> +				}
> +				mark_buffer_dirty(bh);
> +			}
> +
> +			bh = bh->b_this_page;
> +			blkcount--;
> +		} while ((bh != head) && (blkcount > 0));
> +		/* only unlock if we have locked */
> +		if (index != skip_index)
> +			unlock_page(page);
> +		page_cache_release(page);
> +	}
> +
> +	return 0;
> +err_out:
> +	unlock_page(page);
> +	page_cache_release(page);
> +	return err;
> +}
> +

I was thinking just simply create a new bh, zero out the bh, then map
the bh with the block number to zero out, lastly submit a IO via
ll_rw_block. It maybe more efficient to do this via bio(perhaps cooking
a bio with zeroed out pages and submit_bio) but I have not look very
closely to it. Just throw out my thoughts.

Mingming
>  /* 
>   * This function is called by ext4_ext_get_blocks() if someone tries to write
>   * to an uninitialized extent. It may result in splitting the uninitialized
> @@ -2153,7 +2250,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  						ext4_lblk_t iblock,
>  						unsigned long max_blocks)
>  {
> -	struct ext4_extent *ex, newex;
> +	struct ext4_extent *ex, newex, zeroout_ex;
>  	struct ext4_extent *ex1 = NULL;
>  	struct ext4_extent *ex2 = NULL;
>  	struct ext4_extent *ex3 = NULL;
> @@ -2172,6 +2269,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	allocated = ee_len - (iblock - ee_block);
>  	newblock = iblock - ee_block + ext_pblock(ex);
>  	ex2 = ex;
> +	zeroout_ex.ee_block = ex->ee_block;
> +	zeroout_ex.ee_len   = cpu_to_le16(ee_len);
> +	ext4_ext_store_pblock(&zeroout_ex, ext_pblock(ex));
> 
>  	err = ext4_ext_get_access(handle, inode, path + depth);
>  	if (err)
> @@ -2200,13 +2300,32 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
>  		ext4_ext_mark_uninitialized(ex3);
>  		err = ext4_ext_insert_extent(handle, inode, path, ex3);
> -		if (err)
> +		if (err == -ENOSPC) {
> +			err =  ext4_ext_zero_out(handle, inode,
> +							iblock, &zeroout_ex);
> +			if (err)
> +				goto out;
> +			/* update the extent length and mark as initialized */
> +			ex->ee_block = zeroout_ex.ee_block;
> +			ex->ee_len   = zeroout_ex.ee_len;
> +			ext4_ext_store_pblock(ex, ext_pblock(&zeroout_ex));
> +			ext4_ext_dirty(handle, inode, path + depth);
> +			return le16_to_cpu(ex->ee_len);
> +
> +		} else if (err)
>  			goto out;
> +
>  		/*
>  		 * The depth, and hence eh & ex might change
>  		 * as part of the insert above.
>  		 */
>  		newdepth = ext_depth(inode);
> +		/*
> +		 * update the extent length after successfull insert of the
> +		 * split extent
> +		 */
> +		zeroout_ex.ee_len = cpu_to_le16(ee_len -
> +						ext4_ext_get_actual_len(ex3));
>  		if (newdepth != depth) {
>  			depth = newdepth;
>  			ext4_ext_drop_refs(path);
> @@ -2281,6 +2400,18 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	goto out;
>  insert:
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> +	if (err == -ENOSPC) {
> +		err =  ext4_ext_zero_out(handle, inode, iblock, &zeroout_ex);
> +		if (err)
> +			goto out;
> +		/* update the extent length and mark as initialized */
> +		ex->ee_block = zeroout_ex.ee_block;
> +		ex->ee_len   = zeroout_ex.ee_len;
> +		ext4_ext_store_pblock(ex, ext_pblock(&zeroout_ex));
> +		ext4_ext_dirty(handle, inode, path + depth);
> +		return le16_to_cpu(ex->ee_len);
> +	}
> +
>  out:
>  	return err ? err : allocated;
>  }
