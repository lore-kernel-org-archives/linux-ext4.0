From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 v3] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Wed, 03 Aug 2011 23:21:21 -0700
Message-ID: <4E3A3A61.3060305@linux.vnet.ibm.com>
References: <4E396744.2030003@linux.vnet.ibm.com> <20110804005001.GI3150@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59423 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1HDGWo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2011 02:22:44 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p745wZ68023015
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 01:58:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p746LPPh1396764
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 02:21:25 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p746LPDR022032
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 02:21:25 -0400
In-Reply-To: <20110804005001.GI3150@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2011 05:50 PM, Ted Ts'o wrote:
> On Wed, Aug 03, 2011 at 08:20:36AM -0700, Allison Henderson wrote:
>> @@ -4227,6 +4227,28 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>>   		}
>>   	}
>>
>> +	/*
>> +	 * Now we need to unmap the un page aligned buffers.
>> +	 * If the file is smaller than a page, just
>> +	 * unmap the middle
>> +	 */
>
> This should be "non-page-aligned buffers".  And it's not "if the file
> is smaller than a page", but rather "if the file space being truncated
> is smaller than a page".  (The comment above this patch hunk is
> similarly wrong).
>
>> +	if (first_page>  last_page)
>> +		ext4_unmap_page_range(handle, mapping, offset, length);
>> +	else {
>> +		/* unmap page buffers before the first aligned page */
>> +		page_len = first_page_offset - offset;
>> +		if (page_len>  0)
>> +			ext4_unmap_page_range(handle, mapping,
>> +				offset, page_len);
>> +
>> +		/* unmap the page buffers after the last aligned page */
>> +		page_len = offset + length - last_page_offset;
>> +		if (page_len>  0) {
>> +			ext4_unmap_page_range(handle, mapping,
>> +				last_page_offset, page_len);
>> +		}
>> +	}
>> +
>
> We unconditionally call ext4_unmap_page_range() at least once, and
> possibly twice.  The ext4_unmap_page_range() function is always going
> to be calling find_or_create_page(), which requires locking pages,
> taking RCU locks, etc..  None of this code should be needed if:
>
>     inode->i_sb->s_blocksize == PAGE_CACHE_SIZE
> or
>     (offset % PAGE_CACHE_SIZE == 0)&&  (length % PAGE_CACHE_SIZE == 0)
>
>> +/*
>> + * ext4_unmap_page_range() unmaps a page range of length 'length'
>> + * starting from file offset 'from'.  The range to be unmaped must
>> + * be contained with in one page.  If the specified range exceeds
>> + * the end of the page it will be shortened to end of the page
>> + * that cooresponds to 'from'.  Only block aligned buffers will
>> + * be unmapped and unblock aligned buffers are skipped
>> + */
>> +int ext4_unmap_page_range(handle_t *handle,
>> +		struct address_space *mapping, loff_t from, loff_t length)
>
> This function is only used by extents.c; maybe it should be placed in
> extents.c and declared static, instead of being placed in inode.c?
>
>> +{
>> +	ext4_fsblk_t index = from>>  PAGE_CACHE_SHIFT;
>> +	unsigned int offset = from&  (PAGE_CACHE_SIZE-1);
>> +	unsigned int blocksize, max, pos;
>> +	unsigned int end_of_block, range_to_unmap;
>> +	ext4_lblk_t iblock;
>> +	struct inode *inode = mapping->host;
>> +	struct buffer_head *bh;
>> +	struct page *page;
>> +	int err = 0;
>> +
>> +	page = find_or_create_page(mapping, from>>  PAGE_CACHE_SHIFT,
>> +				   mapping_gfp_mask(mapping)&  ~__GFP_FS);
>> +	if (!page)
>> +		return -EINVAL;
>> +
>> +	blocksize = inode->i_sb->s_blocksize;
>> +	max = PAGE_CACHE_SIZE - offset;
>> +
>> +	/*
>> +	 * correct length if it does not fall between
>> +	 * 'from' and the end of the page
>> +	 */
>> +	if (length>  max || length<  0)
>> +		length = max;
>> +
>> +	iblock = index<<  (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
>> +
>> +	if (!page_has_buffers(page))
>> +		create_empty_buffers(page, blocksize, 0);
>
> If the page doesn't have any buffers, we could just return 0; there's
> no point calling create_empty_buffers() and then looping over them
> all.
>
>> +
>> +	/* Find the buffer that contains "offset" */
>> +	bh = page_buffers(page);
>> +	pos = blocksize;
>> +	while (offset>= pos) {
>> +		bh = bh->b_this_page;
>> +		iblock++;
>> +		pos += blocksize;
>> +	}
>> +
>> +	pos = offset;
>> +	while (pos<  offset + length) {
>> +		err = 0;
>> +
>> +		/* The length of space left to zero */
>> +		range_to_unmap = offset + length - pos;
>> +
>> +		/* The length of space until the end of the block */
>> +		end_of_block = blocksize - (pos&  (blocksize-1));
>> +
>> +		/* Do not unmap past end of block */
>> +		if (range_to_unmap>  end_of_block)
>> +			range_to_unmap = end_of_block;
>> +
>> +		if (buffer_freed(bh)) {
>> +			BUFFER_TRACE(bh, "freed: skip");
>> +			goto next;
>> +		}
>> +
>> +		if (!buffer_mapped(bh)) {
>> +			BUFFER_TRACE(bh, "unmapped");
>> +			ext4_get_block(inode, iblock, bh, 0);
>> +			/* unmapped? It's a hole - nothing to do */
>> +			if (!buffer_mapped(bh)) {
>> +				BUFFER_TRACE(bh, "still unmapped");
>> +				goto next;
>> +			}
>> +		}
>
> If the buffer is unmapped, why not just goto next right away?  Why
> bother calling ext4_get_block() and mapping it, when all we're going
> to do is declare the buffer as unmapped anyway.
>
>> +
>> +		/* If the range is not block aligned, skip */
>> +		if (range_to_unmap != blocksize)
>> +			goto next;
>> +
>> +		if (ext4_should_journal_data(inode)) {
>> +			BUFFER_TRACE(bh, "get write access");
>> +			err = ext4_journal_get_write_access(handle, bh);
>> +			if (err)
>> +				goto unlock;
>> +		}
>> +
>> +		clear_buffer_dirty(bh);
>> +		bh->b_bdev = NULL;
>> +		clear_buffer_mapped(bh);
>> +		clear_buffer_req(bh);
>> +		clear_buffer_new(bh);
>> +		clear_buffer_delay(bh);
>> +		clear_buffer_unwritten(bh);
>> +		clear_buffer_uptodate(bh);
>> +		ClearPageUptodate(page);
>> +
>> +		BUFFER_TRACE(bh, "buffer unmapped");
>> +
>> +		if (ext4_should_journal_data(inode)) {
>> +			err = ext4_handle_dirty_metadata(handle, inode, bh);
>> +		} else {
>> +			if (ext4_should_order_data(inode)&&
>> +			    EXT4_I(inode)->jinode)
>> +				err = ext4_jbd2_file_inode(handle, inode);
>> +		}
>
> Why are we calling ext4_handle_dirty_metadata() or
> ext4_jbd2_file_inode() here?  It's not necessary, since we're not
> actually dirtying any buffers here.  We're just marking buffer heads
> as unmarked.
>
>> +
>> +next:
>> +		bh = bh->b_this_page;
>> +		iblock++;
>> +		pos += range_to_unmap;
>> +	}
>> +unlock:
>> +	unlock_page(page);
>> +	page_cache_release(page);
>> +	return err;
>> +}
>> +
>> +
>>   int ext4_can_truncate(struct inode *inode)
>>   {
>>   	if (S_ISREG(inode->i_mode))
>> --
>> 1.7.1
> --

Hi Ted,

Thx for the review, a lot of this I modeled after the 
ext4_zero_block_page_range code. I will add in your suggestions and pick 
out the parts we dont need anymore.  Thx!

Allison Henderson

