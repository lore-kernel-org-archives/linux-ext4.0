From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] ext4:Make FIEMAP and delayed allocation play well together.
Date: Fri, 25 Feb 2011 03:13:44 -0700
Message-ID: <9CFD5FC9-82EC-426F-B0EA-742AFB05711E@dilger.ca>
References: <1298626825-3131-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:26517 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab1BYKNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 05:13:45 -0500
In-Reply-To: <1298626825-3131-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-25, at 2:40 AM, Yongqiang Yang wrote:
> @@ -3782,38 +3783,124 @@ static int ext4_ext_fiemap_cb(struct inode *inode, 
> 	if (newex->ec_start == 0) {
> +		struct page	*page = NULL;
> +repeat:
> +		last_offset = offset;
> +		head = NULL;
> +		ret = find_get_pages_tag(inode->i_mapping, &offset,
> +					PAGECACHE_TAG_DIRTY, 1, &page);

Hmm, now I wonder about the expense of mapping many thousands of delalloc
pages, one at a time, in order to map this extent.

Could you please do a test, with as large a file as possible before it is written to disk (say 4GB == 1M pages), to see whether single-page find_get_pages_tag() is faster than kmalloc() of a PAGE_SIZE buffer and (PAGE_SIZE/sizeof(struct page *)) page pointers?

This would probably work best if the VM is tuned not to flush out dirty pages.

Otherwise, there are only minor style issues to fix up.  Thanks for your work so far.

> +		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> +			/* First time, try to find a mapped buffer. */
> +			if (ret == 0) {
> +out:
> +				if (ret > 0)
> +					page_cache_release(page);
> +				/* just a hole. */
> +				return EXT_CONTINUE;
> +			}
> 
> -		if (!bh)
> -			return EXT_CONTINUE;
> +			/* Try to find the 1st mapped buffer. */
> +			end = ((__u64)page->index << PAGE_SHIFT)
> +					>> blksize_bits;

(style) operators go at the end of the previous line.

> +			if (!page_has_buffers(page))
> +				goto out;
> +			head = page_buffers(page);
> +			if (!head)
> +				goto out;
> 
> -		if (buffer_delay(bh)) {
> -			flags |= FIEMAP_EXTENT_DELALLOC;
> -			page_cache_release(page);
> +			bh = head;
> +			do {
> +				if (buffer_mapped(bh)) {
> +					/* get the 1st mapped buffer. */
> +					if (end > newex->ec_block +
> +						newex->ec_len)

(style) continued lines should align by the parenthesis '(' on the previous line, not on a full tab.

> +						/* The buffer is out of
> +						 * the request range.
> +						 */
> +						goto out;
> +					goto found_mapped_buffer;
> +				}
> +				bh = bh->b_this_page;
> +				end++;
> +			} while (bh != head);
> +			/* No mapped buffer found. */
> +			goto out;
> 		} else {
> +			/*Find contiguous delayed buffers. */
> +			if (ret > 0 && page->index == last_offset)
> +				head = page_buffers(page);
> +			bh = head;
> +		}
> +
> +found_mapped_buffer:
> +		if (bh != NULL && buffer_delay(bh)) {
> +			/* 1st or contiguous delayed buffer found. */
> +			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> +				/*
> +				 * 1st delayed buffer found, record
> +				 * the start of extent.
> +				 */
> +				flags |= FIEMAP_EXTENT_DELALLOC;
> +				newex->ec_block = end;
> +				logical =  (__u64)end << blksize_bits;

(style) remove double space before '('

> +			}
> +			/* Find contiguous delayed buffers. */
> +			do {
> +				if (!buffer_delay(bh))
> +					goto found_delayed_extent;
> +				bh = bh->b_this_page;
> +				end++;
> +			} while (bh != head);
> +		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
> +			/* a hole found. */
> +			goto out;
> +
> +found_delayed_extent:
> +		newex->ec_len = min(end - newex->ec_block,
> +						(ext4_lblk_t)EXT_INIT_MAX_LEN);

(style) align continued line after '(' on previous line

> +		if (ret == 1 && bh != NULL
> +			&& newex->ec_len < EXT_INIT_MAX_LEN
> +			&& buffer_delay(bh)) {

(style) operators go at the end of the previous line, like:

+		if (ret == 1 && bh != NULL &&
+                   newex->ec_len < EXT_INIT_MAX_LEN && buffer_delay(bh)) {

> +			/* Have not collected an extent and continue. */
> 			page_cache_release(page);
> -			return EXT_CONTINUE;
> +			goto repeat;
> 		}
> +		page_cache_release(page);
> 	}
> 
> 	physical = (__u64)newex->ec_start << blksize_bits;
> @@ -3822,32 +3909,16 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
> 	if (ex && ext4_ext_is_uninitialized(ex))
> 		flags |= FIEMAP_EXTENT_UNWRITTEN;
> 
> -	/*
> -	 * If this extent reaches EXT_MAX_BLOCK, it must be last.
> -	 *
> -	 * Or if ext4_ext_next_allocated_block is EXT_MAX_BLOCK,
> -	 * this also indicates no more allocated blocks.
> -	 *
> -	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
> -	 */
> -	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
> -	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
> -		loff_t size = i_size_read(inode);
> -		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
> -
> +	size = i_size_read(inode);
> +	if (logical + length >= size)
> 		flags |= FIEMAP_EXTENT_LAST;
> -		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
> -		    logical+length > size)
> -			length = (size - logical + bs - 1) & ~(bs-1);
> -	}
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
> -
> 	return EXT_CONTINUE;
> }
> 
> -- 
> 1.7.4
> 


Cheers, Andreas





