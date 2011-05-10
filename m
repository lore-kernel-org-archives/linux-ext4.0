From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 10 May 2011 10:41:56 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1105101037440.1243@sister.anvils>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Jim Meyering <jim@meyering.net>,
	Mingming Cao <cmm@us.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:6989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1EJRl5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 13:41:57 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p4AHfuMK002275
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 10:41:56 -0700
Received: from pwi15 (pwi15.prod.google.com [10.241.219.15])
	by wpaz5.hot.corp.google.com with ESMTP id p4AHfsgM015373
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 10:41:55 -0700
Received: by pwi15 with SMTP id 15so3815439pwi.5
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 10:41:54 -0700 (PDT)
In-Reply-To: <1303762999-20541-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Apr 2011, Curt Wohlgemuth wrote:

> In the bio completion routine, we should not be setting
> PageUptodate at all -- it's set at sys_write() time, and is
> unaffected by success/failure of the write to disk.
> 
> This can cause a page corruption bug when
> 
>     block size < page size
> 
> if we have only written a single block -- we might end up
> setting the entire PageUptodate, which will cause subsequent
> reads to get bad data.
> 
> This commit also takes the opportunity to clean up error
> handling in ext4_end_bio(), and remove some extraneous code:
> 
>    - fixes ext4_end_bio() to set AS_EIO in the
>      page->mapping->flags on error, which was left out by
>      mistake.
>    - remove the clear_buffer_dirty() call on unmapped
>      buffers for each page.
>    - consolidate page/buffer error handling in a single
>      section.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> Reported-by: Jim Meyering <jim@meyering.net>
> Reported-by: Hugh Dickins <hughd@google.com>
> Cc: Mingming Cao <cmm@us.ibm.com>
> ---
> Changlog since v2:
> - Removed clear_buffer_dirty() call
> - Consolidated error handling for pages and buffer heads
> - Loop over BHs in a page even for page size == block size, so
>   we emit the correct error for such a case.
> 
> Changlog since v1:
> - Added commit message text about setting AS_EIO for the
>  page on error.
> - Continue to loop over all BHs in a page and emit unique
>  errors for each of them.
> ---
>  fs/ext4/page-io.c |   39 +++++++++++----------------------------
>  1 files changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index b6dbd05..7bb8f76 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio, int error)
>  	for (i = 0; i < io_end->num_io_pages; i++) {
>  		struct page *page = io_end->pages[i]->p_page;
>  		struct buffer_head *bh, *head;
> -		int partial_write = 0;
> +		loff_t offset;
> +		loff_t io_end_offset;
>  
> -		head = page_buffers(page);
> -		if (error)
> +		if (error) {
>  			SetPageError(page);
> -		BUG_ON(!head);
> -		if (head->b_size != PAGE_CACHE_SIZE) {
> -			loff_t offset;
> -			loff_t io_end_offset = io_end->offset + io_end->size;
> +			set_bit(AS_EIO, &page->mapping->flags);
> +			head = page_buffers(page);
> +			BUG_ON(!head);
> +
> +			io_end_offset = io_end->offset + io_end->size;
>  
>  			offset = (sector_t) page->index << PAGE_CACHE_SHIFT;
>  			bh = head;
>  			do {
>  				if ((offset >= io_end->offset) &&
> -				    (offset+bh->b_size <= io_end_offset)) {
> -					if (error)
> -						buffer_io_error(bh);
> -
> -				}
> -				if (buffer_delay(bh))
> -					partial_write = 1;
> -				else if (!buffer_mapped(bh))
> -					clear_buffer_dirty(bh);
> -				else if (buffer_dirty(bh))
> -					partial_write = 1;
> +				    (offset+bh->b_size <= io_end_offset))
> +					buffer_io_error(bh);
> +
>  				offset += bh->b_size;
>  				bh = bh->b_this_page;
>  			} while (bh != head);
>  		}
>  
> -		/*
> -		 * If this is a partial write which happened to make
> -		 * all buffers uptodate then we can optimize away a
> -		 * bogus readpage() for the next read(). Here we
> -		 * 'discover' whether the page went uptodate as a
> -		 * result of this (potentially partial) write.
> -		 */
> -		if (!partial_write)
> -			SetPageUptodate(page);
> -
>  		put_io_page(io_end->pages[i]);
>  	}
>  	io_end->num_io_pages = 0;
> -- 
> 1.7.3.1

I'm concerned that we've reached -rc7, with Linus planning on 2.6.39
release next week, but Curt's fix above to the mblk_io corruption bug
seems to have fallen through the cracks.

I've been including it in all my testing over the last two weeks: it
works fine - and because of my own tmpfs bug, I even got to see its
error messages :)  Adding in the patch is easy enough for me,
but surely we don't want others to stumble into this bug.

Thanks,
Hugh
