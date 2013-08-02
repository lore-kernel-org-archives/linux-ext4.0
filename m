From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Make ext4_writepages() resilient to i_size changes
Date: Fri, 2 Aug 2013 16:23:24 +0200
Message-ID: <20130802142324.GA20484@quack.suse.cz>
References: <1375310532-17731-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3HBOX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Aug 2013 10:23:26 -0400
Content-Disposition: inline
In-Reply-To: <1375310532-17731-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-08-13 00:42:12, Jan Kara wrote:
> Inode size can arbitrarily change while writeback is in progress. This
> can have various strange effects when we use one value of i_size for one
> decision during writeback and another value of i_size for a different
> decision during writeback. In particular a check for lblk < blocks in
> mpage_map_and_submit_buffers() causes problems when i_size is reduced
> while writeback is running because we can end up not using all blocks
> we've allocated. Thus these blocks are leaked and also delalloc
> accounting gets wrong manifesting as a warning like:
> 
> ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1
> with only 0 reserved data blocks
> 
> The problem can happen only when blocksize < pagesize because the check
> for size is performed only after the first iteration of the mapping
> loop.
> 
> Fix the problem by removing the size check from the mapping loop. We
> have an extent allocated so we have to use it all before checking for
> i_size. We may call add_page_bufs_to_extent() unnecessarily but that
> function won't do anything if passed block number is beyond file size.
> 
> Also to avoid future surprises like this sample inode size when
> starting writeback in ext4_writepages() and then use this sampled size
> throughout the writeback call stack.
  Ted, please disregard this patch. It is buggy. I'll send a better fix
soon.

								Honza

> 
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ba33c67..8bd0240 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1413,6 +1413,8 @@ static void ext4_da_page_release_reservation(struct page *page,
>  struct mpage_da_data {
>  	struct inode *inode;
>  	struct writeback_control *wbc;
> +	loff_t i_size;		/* Inode size can change while we do writeback.
> +				 * Use one fixed value to make things simpler */
>  
>  	pgoff_t first_page;	/* The first page to write */
>  	pgoff_t next_page;	/* Current page to examine */
> @@ -1943,7 +1945,7 @@ static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
>  				    ext4_lblk_t lblk)
>  {
>  	struct inode *inode = mpd->inode;
> -	ext4_lblk_t blocks = (i_size_read(inode) + (1 << inode->i_blkbits) - 1)
> +	ext4_lblk_t blocks = (mpd->i_size + (1 << inode->i_blkbits) - 1)
>  							>> inode->i_blkbits;
>  
>  	do {
> @@ -1968,12 +1970,11 @@ static bool add_page_bufs_to_extent(struct mpage_da_data *mpd,
>  static int mpage_submit_page(struct mpage_da_data *mpd, struct page *page)
>  {
>  	int len;
> -	loff_t size = i_size_read(mpd->inode);
>  	int err;
>  
>  	BUG_ON(page->index != mpd->first_page);
> -	if (page->index == size >> PAGE_CACHE_SHIFT)
> -		len = size & ~PAGE_CACHE_MASK;
> +	if (page->index == mpd->i_size >> PAGE_CACHE_SHIFT)
> +		len = mpd->i_size & ~PAGE_CACHE_MASK;
>  	else
>  		len = PAGE_CACHE_SIZE;
>  	clear_page_dirty_for_io(page);
> @@ -2006,8 +2007,6 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>  	struct inode *inode = mpd->inode;
>  	struct buffer_head *head, *bh;
>  	int bpp_bits = PAGE_CACHE_SHIFT - inode->i_blkbits;
> -	ext4_lblk_t blocks = (i_size_read(inode) + (1 << inode->i_blkbits) - 1)
> -							>> inode->i_blkbits;
>  	pgoff_t start, end;
>  	ext4_lblk_t lblk;
>  	sector_t pblock;
> @@ -2052,8 +2051,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>  					bh->b_blocknr = pblock++;
>  				}
>  				clear_buffer_unwritten(bh);
> -			} while (++lblk < blocks &&
> -				 (bh = bh->b_this_page) != head);
> +			} while (lblk++, (bh = bh->b_this_page) != head);
>  
>  			/*
>  			 * FIXME: This is going to break if dioread_nolock
> @@ -2200,7 +2198,11 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			return err;
>  	} while (map->m_len);
>  
> -	/* Update on-disk size after IO is submitted */
> +	/*
> +	 * Update on-disk size after IO is submitted. Here we cannot use
> +	 * mpd->i_size as we must avoid increasing i_disksize when racing
> +	 * truncate already set it to a small value.
> +	 */
>  	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
>  	if (disksize > i_size_read(inode))
>  		disksize = i_size_read(inode);
> @@ -2453,6 +2455,7 @@ static int ext4_writepages(struct address_space *mapping,
>  
>  	mpd.inode = inode;
>  	mpd.wbc = wbc;
> +	mpd.i_size = i_size_read(inode);
>  	ext4_io_submit_init(&mpd.io_submit, wbc);
>  retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
