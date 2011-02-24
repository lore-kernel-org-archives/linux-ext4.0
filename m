From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v1] ext4:Make FIEMAP and delayed allocation play well together.
Date: Thu, 24 Feb 2011 14:14:09 -0700
Message-ID: <7CF68C64-B56F-4C1C-881B-BB92AD745C3E@dilger.ca>
References: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:2337 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab1BXVOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 16:14:11 -0500
In-Reply-To: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-24, at 9:15 AM, Yongqiang Yang wrote:
> static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
> 		       void *data)
> {
> +	struct page *pages[NR_PAGES_PER_TIME];

I agree with Eric that this cannot live on the stack (or alternately that we need better stack handling in the kernel :-).  Fortunately, the kmalloc() of this data only needs to happen in rare cases, so it shouldn't impact performance very much.  It might be possible to cache this buffer in newex, to limit the allocation to once per file, instead of once per hole, but I'm not sure it is worthwhile.

The benefit of kmalloc() is that it could be a full page or two, and allow far fewer calls into pagevec_lookup_tag(), which I suspect is more of a performance win than the cost of calling kmalloc().

> +	__u64  logical;
> +	__u64  physical;
> +	__u64  length;
> +
> +	loff_t  size = i_size_read(inode);
> +	pgoff_t index = 0;
> +	ext4_lblk_t end = 0;
> +
> +	__u32  flags = 0;
> +	int	   ret = 0;

(style) please align variable declarations in some consistent manner

> 	struct fiemap_extent_info *fieinfo = data;
> +
> 	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;

Many of these are specific to the "if (newex->ec_start == 0)" context, so should be allocated there to make this more clear.

(style) there shouldn't be blank lines between the variable declarations.  There are also many other CodingStyle violations that should be cleaned up.

> 	if (newex->ec_start == 0) {
> +		/*
> +		 * No extent in extent-tree contains block @newex->ec_start,
> +		 * then the block may stay in 1)a hole or 2)delayed-extent.
> +		 * 
> + 		 * Holes or delayed-extents are processed as follows.
> +		 * 1. lookup dirty pages with specified range in pagecache.
> +		 *    If no page is got, then there is no delayed-extent and 
> +		 *    return with EXT_CONTINUE. 
> +		 * 2. find the 1st mapped buffer,  	 
> +		 * 3. check if the mapped buffer is both in the request range 
> +		 *    and a delayed buffer. If not, there is no delayed-extent, 
> +		 *    then return.
> +		 * 4. a delayed-extent is found, the extent will be collected.
> +		 */

Good comment.

> +		pgoff_t last_offset;
> 		pgoff_t offset;
> 		struct buffer_head *bh = NULL;
> +		struct buffer_head *head = NULL;
> +		unsigned int nr_pages = NR_PAGES_PER_TIME;
> 
> 		offset = logical >> PAGE_SHIFT;
> 
> +repeat:
> +		index = 0;	
> +		last_offset = offset;
> +		head = NULL;	
> +		ret = find_get_pages_tag(inode->i_mapping, &offset,
> +					PAGECACHE_TAG_DIRTY, nr_pages, pages);
> +
> +		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> +			/* First time, try to find a mapped buffer. */
> +			if (ret == 0)
> +				/* just a hole. */
> +				return EXT_CONTINUE;

This could contain the "out:" label, and the page_cache_release() loop would be skipped because ret == 0.  That would avoid the need to use the pages[] and index values outside of the scope of the "if (ec_start == 0)" clause, like:

			if (ret == 0) {
			out:
				/* just a hole. */
				for (index = 0; index < ret; index++)
					page_cache_release(pages[index]);
				return EXT_CONTINUE;
			}

> +			/* Try to find the 1st mapped buffer. */
> +			end = ((__u64)pages[0]->index << PAGE_SHIFT) >> blksize_bits; 
> +			for (index = 0; index < ret; index ++) {
> +				if (!page_has_buffers(pages[index]))
> +					goto out;
> +				head = page_buffers(pages[index]);
> +				if (!head)
> +					goto out;
> +			
> +				bh = head;
> +				do {
> +					if (buffer_mapped(bh)) {
> +						/* get the 1st mapped buffer. */
> +						if (end > newex->ec_block + newex->ec_len)
> +							/* The buffer is out of the request range. */ 
> +							goto out;
> +						goto found_mapped_buffer;
> +					}
> +					bh = bh->b_this_page;
> +					end ++;
> +				} while (bh != head);
> +			}			
> +			
> +			if (index == ret)
> +				/* No mapped buffer found? */
> +				BUG();

Hmm, this should be BUG_ON(index == ret), but even so I'm not so fond of BUG() as a form of error handling.  I'd rather just return at this point without an extent.

> 		} else {
> +			/*Find contiguous delayed buffers. */
> +			if (ret > 0 && pages[0]->index == last_offset)
> +				head = page_buffers(pages[0]);
> +			bh = head;
> +		} 
> +
> +found_mapped_buffer:		
> +		if (bh && buffer_delay(bh)) {
> +			/* 1st or contiguous delayed buffer found. */
> +			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> +				/* 1st delayed buffer found, record the start of extent. */
> +				flags |= FIEMAP_EXTENT_DELALLOC;
> +				newex->ec_block = end;
> +				logical =  (__u64)end << blksize_bits;
> +			}
> +			/* Find contiguous delayed buffers. */
> +			do {
> +				if (!buffer_delay(bh))
> +					goto found_delayed_extent;
> +				bh = bh->b_this_page;
> +				end ++;
> +			} while (bh != head);
> +
> +			for (index ++; index < ret; index ++) {
> +				if (!page_has_buffers(pages[index])) {
> +					bh = NULL;
> +					break;
> +				}
> +				head = page_buffers(pages[index]);
> +				if (!head) {
> +					bh = NULL;
> +					break;
> +				}
> +				if (pages[index]->index != pages[0]->index + index) {
> +					/* Blocks are not contiguous. */
> +					bh = NULL;
> +					break;
> +				}
> +				bh = head;
> +				do {
> +					if (!buffer_delay(bh))
> +						/* Delayed-extent ends. */
> +						goto found_delayed_extent;
> +					bh = bh->b_this_page;
> +					end ++;
> +				} while (bh != head); 
> +			}
> +		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
> +			/* a hole found. */
> +			goto out;
> +
> +found_delayed_extent:
> +		newex->ec_len = min(end - newex->ec_block,
> +						(ext4_lblk_t)EXT_INIT_MAX_LEN);
> +		if (ret == nr_pages && newex->ec_len < EXT_INIT_MAX_LEN 
> +			&& bh && buffer_delay(bh)) {
> +			/* Have not collected an extent and continue. */
> +			for (index =0; index < ret; index ++) 
> +				page_cache_release(pages[index]);
> +			goto repeat;
> 		}
> +
> +		for (index =0; index < ret; index ++) 
> +			page_cache_release(pages[index]);
> 	}
> 
> 	physical = (__u64)newex->ec_start << blksize_bits;
> @@ -3822,32 +3935,24 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> 	if (ex && ext4_ext_is_uninitialized(ex))
> 		flags |= FIEMAP_EXTENT_UNWRITTEN;
> 
> 
> +	if (logical + length >= size) {
> 		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
> +			flags |= FIEMAP_EXTENT_LAST;
> +		if (flags & FIEMAP_EXTENT_DELALLOC)
> 			length = (size - logical + bs - 1) & ~(bs-1);

This should probably set "physical = 0" just so that we don't return random garbage in that field.

> 	}
> 
> -	error = fiemap_fill_next_extent(fieinfo, logical, physical,
> +	ret = fiemap_fill_next_extent(fieinfo, logical, physical,
> 					length, flags);
> -	if (error < 0)
> -		return error;
> -	if (error == 1)
> +	if (ret < 0)
> +		return ret;
> +	if (ret == 1)
> 		return EXT_BREAK;
> 
> +out:
> +	for (index =0; index < ret; index ++) 
> +		page_cache_release(pages[index]);
> +
> 	return EXT_CONTINUE;
> }
> 
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





