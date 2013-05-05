From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 14/29] ext4: Stop messing with nr_to_write in
 ext4_da_writepages()
Date: Sun, 5 May 2013 20:40:45 +0800
Message-ID: <20130505124045.GA12064@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-15-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:53476 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3EEMXM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 08:23:12 -0400
Received: by mail-da0-f47.google.com with SMTP id k13so1425219dae.34
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 05:23:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-15-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:19PM +0200, Jan Kara wrote:
> Writeback code got better in how it submits IO and now the number of
> pages requested to be written is usually higher than original 1024. The
> number is now dynamically computed based on observed throughput and is
> set to be about 0.5 s worth of writeback. E.g. on ordinary SATA drive
> this ends up somewhere around 10000 as my testing shows. So remove the
> unnecessary smarts from ext4_da_writepages().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This patch needs to be rebase against latest dev branch of ext4 tree.
Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/inode.c |   96 -------------------------------------------------------
>  1 files changed, 0 insertions(+), 96 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ba07412..f4dc4a1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -423,66 +423,6 @@ static int __check_block_validity(struct inode *inode, const char *func,
>  	__check_block_validity((inode), __func__, __LINE__, (map))
>  
>  /*
> - * Return the number of contiguous dirty pages in a given inode
> - * starting at page frame idx.
> - */
> -static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
> -				    unsigned int max_pages)
> -{
> -	struct address_space *mapping = inode->i_mapping;
> -	pgoff_t	index;
> -	struct pagevec pvec;
> -	pgoff_t num = 0;
> -	int i, nr_pages, done = 0;
> -
> -	if (max_pages == 0)
> -		return 0;
> -	pagevec_init(&pvec, 0);
> -	while (!done) {
> -		index = idx;
> -		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
> -					      PAGECACHE_TAG_DIRTY,
> -					      (pgoff_t)PAGEVEC_SIZE);
> -		if (nr_pages == 0)
> -			break;
> -		for (i = 0; i < nr_pages; i++) {
> -			struct page *page = pvec.pages[i];
> -			struct buffer_head *bh, *head;
> -
> -			lock_page(page);
> -			if (unlikely(page->mapping != mapping) ||
> -			    !PageDirty(page) ||
> -			    PageWriteback(page) ||
> -			    page->index != idx) {
> -				done = 1;
> -				unlock_page(page);
> -				break;
> -			}
> -			if (page_has_buffers(page)) {
> -				bh = head = page_buffers(page);
> -				do {
> -					if (!buffer_delay(bh) &&
> -					    !buffer_unwritten(bh))
> -						done = 1;
> -					bh = bh->b_this_page;
> -				} while (!done && (bh != head));
> -			}
> -			unlock_page(page);
> -			if (done)
> -				break;
> -			idx++;
> -			num++;
> -			if (num >= max_pages) {
> -				done = 1;
> -				break;
> -			}
> -		}
> -		pagevec_release(&pvec);
> -	}
> -	return num;
> -}
> -
> -/*
>   * The ext4_map_blocks() function tries to look up the requested blocks,
>   * and returns if the blocks are already mapped.
>   *
> @@ -2334,10 +2274,8 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	struct mpage_da_data mpd;
>  	struct inode *inode = mapping->host;
>  	int pages_written = 0;
> -	unsigned int max_pages;
>  	int range_cyclic, cycled = 1, io_done = 0;
>  	int needed_blocks, ret = 0;
> -	long desired_nr_to_write, nr_to_writebump = 0;
>  	loff_t range_start = wbc->range_start;
>  	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
>  	pgoff_t done_index = 0;
> @@ -2384,39 +2322,6 @@ static int ext4_da_writepages(struct address_space *mapping,
>  		end = wbc->range_end >> PAGE_CACHE_SHIFT;
>  	}
>  
> -	/*
> -	 * This works around two forms of stupidity.  The first is in
> -	 * the writeback code, which caps the maximum number of pages
> -	 * written to be 1024 pages.  This is wrong on multiple
> -	 * levels; different architectues have a different page size,
> -	 * which changes the maximum amount of data which gets
> -	 * written.  Secondly, 4 megabytes is way too small.  XFS
> -	 * forces this value to be 16 megabytes by multiplying
> -	 * nr_to_write parameter by four, and then relies on its
> -	 * allocator to allocate larger extents to make them
> -	 * contiguous.  Unfortunately this brings us to the second
> -	 * stupidity, which is that ext4's mballoc code only allocates
> -	 * at most 2048 blocks.  So we force contiguous writes up to
> -	 * the number of dirty blocks in the inode, or
> -	 * sbi->max_writeback_mb_bump whichever is smaller.
> -	 */
> -	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
> -	if (!range_cyclic && range_whole) {
> -		if (wbc->nr_to_write == LONG_MAX)
> -			desired_nr_to_write = wbc->nr_to_write;
> -		else
> -			desired_nr_to_write = wbc->nr_to_write * 8;
> -	} else
> -		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
> -							   max_pages);
> -	if (desired_nr_to_write > max_pages)
> -		desired_nr_to_write = max_pages;
> -
> -	if (wbc->nr_to_write < desired_nr_to_write) {
> -		nr_to_writebump = desired_nr_to_write - wbc->nr_to_write;
> -		wbc->nr_to_write = desired_nr_to_write;
> -	}
> -
>  retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
>  		tag_pages_for_writeback(mapping, index, end);
> @@ -2509,7 +2414,6 @@ retry:
>  		mapping->writeback_index = done_index;
>  
>  out_writepages:
> -	wbc->nr_to_write -= nr_to_writebump;
>  	wbc->range_start = range_start;
>  	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
>  	return ret;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
