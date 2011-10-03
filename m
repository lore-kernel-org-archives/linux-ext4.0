From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC PATCH V2 6/6] ext4: reimplement fiemap on delayed extent
 tree
Date: Mon, 3 Oct 2011 18:00:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110031753090.4447@dhcp-27-109.brq.redhat.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com> <1317272926-13303-7-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab1JCQA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 12:00:56 -0400
In-Reply-To: <1317272926-13303-7-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 29 Sep 2011, Yongqiang Yang wrote:

> This patch reimplements fiemap on delayed extent tree.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |  186 +++++++----------------------------------------------
>  1 files changed, 23 insertions(+), 163 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bdbb984..c2ae125 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3909,193 +3909,53 @@ static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
>  		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
>  		       void *data)
>  {
> +	struct delayed_extent de;
>  	__u64	logical;
>  	__u64	physical;
>  	__u64	length;
>  	__u32	flags = 0;
> +	ext4_lblk_t next_del;
>  	int		ret = 0;
>  	struct fiemap_extent_info *fieinfo = data;
>  	unsigned char blksize_bits;
>  
> -	blksize_bits = inode->i_sb->s_blocksize_bits;
> -	logical = (__u64)newex->ec_block << blksize_bits;
> +	de.start = newex->ec_block;
> +	down_read(&EXT4_I(inode)->i_data_sem);
> +	next_del = ext4_de_find_extent(inode, &de);
> +	up_read(&EXT4_I(inode)->i_data_sem);
>  
> +	next = min(next_del, next);
>  	if (newex->ec_start == 0) {
>  		/*
>  		 * No extent in extent-tree contains block @newex->ec_start,
>  		 * then the block may stay in 1)a hole or 2)delayed-extent.
> -		 *
> -		 * Holes or delayed-extents are processed as follows.
> -		 * 1. lookup dirty pages with specified range in pagecache.
> -		 *    If no page is got, then there is no delayed-extent and
> -		 *    return with EXT_CONTINUE.
> -		 * 2. find the 1st mapped buffer,
> -		 * 3. check if the mapped buffer is both in the request range
> -		 *    and a delayed buffer. If not, there is no delayed-extent,
> -		 *    then return.
> -		 * 4. a delayed-extent is found, the extent will be collected.
>  		 */
> -		ext4_lblk_t	end = 0;
> -		pgoff_t		last_offset;
> -		pgoff_t		offset;
> -		pgoff_t		index;
> -		pgoff_t		start_index = 0;
> -		struct page	**pages = NULL;
> -		struct buffer_head *bh = NULL;
> -		struct buffer_head *head = NULL;
> -		unsigned int nr_pages = PAGE_SIZE / sizeof(struct page *);
> -
> -		pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -		if (pages == NULL)
> -			return -ENOMEM;
> -
> -		offset = logical >> PAGE_SHIFT;
> -repeat:
> -		last_offset = offset;
> -		head = NULL;
> -		ret = find_get_pages_tag(inode->i_mapping, &offset,
> -					PAGECACHE_TAG_DIRTY, nr_pages, pages);
> -
> -		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> -			/* First time, try to find a mapped buffer. */
> -			if (ret == 0) {
> -out:
> -				for (index = 0; index < ret; index++)
> -					page_cache_release(pages[index]);
> -				/* just a hole. */
> -				kfree(pages);
> -				return EXT_CONTINUE;
> -			}
> -			index = 0;
> -
> -next_page:
> -			/* Try to find the 1st mapped buffer. */
> -			end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
> -				  blksize_bits;
> -			if (!page_has_buffers(pages[index]))
> -				goto out;
> -			head = page_buffers(pages[index]);
> -			if (!head)
> -				goto out;
> -
> -			index++;
> -			bh = head;
> -			do {
> -				if (end >= newex->ec_block +
> -					newex->ec_len)
> -					/* The buffer is out of
> -					 * the request range.
> -					 */
> -					goto out;
> -
> -				if (buffer_mapped(bh) &&
> -				    end >= newex->ec_block) {
> -					start_index = index - 1;
> -					/* get the 1st mapped buffer. */
> -					goto found_mapped_buffer;
> -				}
> -
> -				bh = bh->b_this_page;
> -				end++;
> -			} while (bh != head);
> -
> -			/* No mapped buffer in the range found in this page,
> -			 * We need to look up next page.
> -			 */
> -			if (index >= ret) {
> -				/* There is no page left, but we need to limit
> -				 * newex->ec_len.
> -				 */
> -				newex->ec_len = end - newex->ec_block;
> -				goto out;
> -			}
> -			goto next_page;
> -		} else {
> -			/*Find contiguous delayed buffers. */
> -			if (ret > 0 && pages[0]->index == last_offset)
> -				head = page_buffers(pages[0]);
> -			bh = head;
> -			index = 1;
> -			start_index = 0;
> -		}
> -
> -found_mapped_buffer:
> -		if (bh != NULL && buffer_delay(bh)) {
> -			/* 1st or contiguous delayed buffer found. */
> -			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
> -				/*
> -				 * 1st delayed buffer found, record
> -				 * the start of extent.
> -				 */
> -				flags |= FIEMAP_EXTENT_DELALLOC;
> -				newex->ec_block = end;
> -				logical = (__u64)end << blksize_bits;
> -			}
> -			/* Find contiguous delayed buffers. */
> -			do {
> -				if (!buffer_delay(bh))
> -					goto found_delayed_extent;
> -				bh = bh->b_this_page;
> -				end++;
> -			} while (bh != head);
> -
> -			for (; index < ret; index++) {
> -				if (!page_has_buffers(pages[index])) {
> -					bh = NULL;
> -					break;
> -				}
> -				head = page_buffers(pages[index]);
> -				if (!head) {
> -					bh = NULL;
> -					break;
> -				}
> -
> -				if (pages[index]->index !=
> -				    pages[start_index]->index + index
> -				    - start_index) {
> -					/* Blocks are not contiguous. */
> -					bh = NULL;
> -					break;
> -				}
> -				bh = head;
> -				do {
> -					if (!buffer_delay(bh))
> -						/* Delayed-extent ends. */
> -						goto found_delayed_extent;
> -					bh = bh->b_this_page;
> -					end++;
> -				} while (bh != head);
> -			}
> -		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
> -			/* a hole found. */
> -			goto out;
> -
> -found_delayed_extent:
> -		newex->ec_len = min(end - newex->ec_block,
> -						(ext4_lblk_t)EXT_INIT_MAX_LEN);
> -		if (ret == nr_pages && bh != NULL &&
> -			newex->ec_len < EXT_INIT_MAX_LEN &&
> -			buffer_delay(bh)) {
> -			/* Have not collected an extent and continue. */
> -			for (index = 0; index < ret; index++)
> -				page_cache_release(pages[index]);
> -			goto repeat;
> +		if (de.len == 0)
> +			/* A hole found. */
> +			return EXT_CONTINUE;
> +
> +		if (de.start > newex->ec_block) {
> +			/* A hole found. */
> +			newex->ec_len = min(de.start - newex->ec_block,
> +					    newex->ec_len);
> +			return EXT_CONTINUE;
>  		}
>  
> -		for (index = 0; index < ret; index++)
> -			page_cache_release(pages[index]);
> -		kfree(pages);
> +		flags |= FIEMAP_EXTENT_DELALLOC;
> +		newex->ec_len = de.start + de.len - newex->ec_block;
>  	}
>  
> -	physical = (__u64)newex->ec_start << blksize_bits;
> -	length =   (__u64)newex->ec_len << blksize_bits;
> -
>  	if (ex && ext4_ext_is_uninitialized(ex))
>  		flags |= FIEMAP_EXTENT_UNWRITTEN;
>  
>  	if (next == EXT_MAX_BLOCKS)
>  		flags |= FIEMAP_EXTENT_LAST;
As we know now, it is not enough to check for next allocated extent,
we also have to check that there is not any delayed extents after
this one.

Just now I have noticed this lines at the beginning of the function:

	next_del = ext4_de_find_extent(inode, &de);

	...

	next = min(next_del, next);

which takes care of that, so it seems that it will fix both problems,
setting FIEMAP_EXTENT_LAST for the last extent in the file and taking
care of delayed extents as well.

The patch seems fine.

Thanks!
-Lukas

>  
> +	blksize_bits = inode->i_sb->s_blocksize_bits;
> +	logical = (__u64)newex->ec_block << blksize_bits;
> +	physical = (__u64)newex->ec_start << blksize_bits;
> +	length =   (__u64)newex->ec_len << blksize_bits;
> +
>  	ret = fiemap_fill_next_extent(fieinfo, logical, physical,
>  					length, flags);
>  	if (ret < 0)
> 

-- 
