From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 12:05:33 -0500
Message-ID: <4C7BE4DD.1060208@redhat.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	bill.fink@nasa.gov
To: Bill Fink <billfink@mindspring.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab0H3RFp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 13:05:45 -0400
In-Reply-To: <20100829231126.8d8b2086.billfink@mindspring.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bill Fink wrote:
> A 50% ext4 disk write performance regression was introduced
> in 2.6.32 and still exists in 2.6.35, although somewhat improved
> from 2.6.32.  Read performance was not affected).
> 
> 2.6.31 disk write performance (RAID5 with 8 disks):
> 
> i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
> 32768+0 records in
> 32768+0 records out
> 34359738368 bytes (34 GB) copied, 49.7106 s, 691 MB/s
> 
> 2.6.32 disk write performance (RAID5 with 8 disks):
> 
> i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
> 32768+0 records in
> 32768+0 records out
> 34359738368 bytes (34 GB) copied, 100.395 s, 342 MB/s
> 
> 2.6.35 disk write performance (RAID5 with 8 disks):
> 
> i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
> 32768+0 records in
> 32768+0 records out
> 34359738368 bytes (34 GB) copied, 75.7265 s, 454 MB/s
> 
> A git bisect targetted commit 55138e0bc29c0751e2152df9ad35deea542f29b3
> (ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks).
> Specifically the performance issue is caused by the use of the function
> ext4_num_dirty_pages.
> 
> The included patch avoids calling ext4_num_dirty_pages
> (and removes its definition) by unconditionally setting
> desired_nr_to_write to wbc->nr_to_write * 8.
> 
> With the patch, the disk write performance is back to
> approximately 2.6.31 performance levels.

Firstly, thanks very much for tracking that down.  I've had various &
sundry reports of slowdowns but I'd never really gotten to the bottom
of it with a simple testcase somehow.

When I get some time (soon I hope) I'll look into the ramifications
of this change (i.e. what if wbc->nr_to_write * 8 is more than the dirty
pages, do things work out ok?) but it seems pretty reasonable.

Since the commit was Ted's originally, perhaps he has some more
immediate comments.

Thanks a ton!

-Eric

> 2.6.35+patch disk write performance (RAID5 with 8 disks):
> 
> i7test7% dd if=/dev/zero of=/i7raid/bill/testfile1 bs=1M count=32768
> 32768+0 records in
> 32768+0 records out
> 34359738368 bytes (34 GB) copied, 50.7234 s, 677 MB/s
> 
> Since I'm no expert in this area, I'm submitting this
> RFC patch against 2.6.35.  I'm not sure what all the
> ramifications of my suggested change would be.  However,
> to my admittedly novice eyes, it doesn't seem to be an
> unreasonable change.  Also, subjectively from building
> kernels on a RAID5 ext4 filesystem using the patched
> 2.6.35 kernel (via make -j 8), I didn't notice any issues,
> and it actually seemed more responsive than when using
> the unpatched 2.6.35 kernel.
> 
> 					-Bill
> 
> P.S.  I am not subscribed to the linux-ext4 e-mail list,
>       plus this is my very first attempted linux kernel
>       patch submission.
> 
> 
> 
> Partially revert 55138e0bc29c0751e2152df9ad35deea542f29b3
> (ext4: Adjust ext4_da_writepages() to write out larger contiguous chunks)
> to fix a 50% ext4 disk write performance regression introduced
> between 2.6.31 and 2.6.32.
> 
> Signed-off-by: Bill Fink <bill.fink@nasa.gov>
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 42272d6..f6e639b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1143,64 +1143,6 @@ static int check_block_validity(struct inode *inode, const char *func,
>  }
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
> -			if (num >= max_pages)
> -				break;
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
> @@ -2972,15 +2914,10 @@ static int ext4_da_writepages(struct address_space *mapping,
>  	 * contiguous.  Unfortunately this brings us to the second
>  	 * stupidity, which is that ext4's mballoc code only allocates
>  	 * at most 2048 blocks.  So we force contiguous writes up to
> -	 * the number of dirty blocks in the inode, or
> -	 * sbi->max_writeback_mb_bump whichever is smaller.
> +	 * sbi->max_writeback_mb_bump
>  	 */
>  	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
> -	if (!range_cyclic && range_whole)
> -		desired_nr_to_write = wbc->nr_to_write * 8;
> -	else
> -		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
> -							   max_pages);
> +	desired_nr_to_write = wbc->nr_to_write * 8;
>  	if (desired_nr_to_write > max_pages)
>  		desired_nr_to_write = max_pages;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

