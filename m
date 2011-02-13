From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH,RFC 2/7] ext4: simple cleanups to write_cache_pages_da()
Date: Sat, 12 Feb 2011 20:31:03 -0500
Message-ID: <20110213013103.GE19533@dhcp231-156.rdu.redhat.com>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu> <1297556157-21559-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab1BMBf4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 20:35:56 -0500
Content-Disposition: inline
In-Reply-To: <1297556157-21559-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 12, 2011 at 07:15:52PM -0500, Theodore Ts'o wrote:
> Eliminate duplicate code, unneeded variables, etc., to make it easier
> to understand the code.  No behavioral changes were made in this patch.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |  115 +++++++++++++++++++++++--------------------------------
>  1 files changed, 48 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 627729f..e230f4f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2723,17 +2723,14 @@ static int write_cache_pages_da(struct address_space *mapping,
>  				struct mpage_da_data *mpd,
>  				pgoff_t *done_index)
>  {
> -	struct inode *inode = mpd->inode;
> -	struct buffer_head *bh, *head;
> -	sector_t logical;
> -	int ret = 0;
> -	int done = 0;
> -	struct pagevec pvec;
> -	unsigned nr_pages;
> -	pgoff_t index;
> -	pgoff_t end;		/* Inclusive */
> -	long nr_to_write = wbc->nr_to_write;
> -	int tag;
> +	struct buffer_head	*bh, *head;
> +	struct inode		*inode = mpd->inode;
> +	struct pagevec		pvec;
> +	unsigned int		nr_pages;
> +	sector_t		logical;
> +	pgoff_t			index, end;
> +	long			nr_to_write = wbc->nr_to_write;
> +	int			i, tag, ret = 0;
>  
>  	pagevec_init(&pvec, 0);
>  	index = wbc->range_start >> PAGE_CACHE_SHIFT;
> @@ -2745,13 +2742,11 @@ static int write_cache_pages_da(struct address_space *mapping,
>  		tag = PAGECACHE_TAG_DIRTY;
>  
>  	*done_index = index;
> -	while (!done && (index <= end)) {
> -		int i;
> -
> +	while (index <= end) {
>  		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
>  			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
>  		if (nr_pages == 0)
> -			break;
> +			return 0;
>  
>  		for (i = 0; i < nr_pages; i++) {
>  			struct page *page = pvec.pages[i];
> @@ -2763,47 +2758,37 @@ static int write_cache_pages_da(struct address_space *mapping,
>  			 * mapping. However, page->index will not change
>  			 * because we have a reference on the page.
>  			 */
> -			if (page->index > end) {
> -				done = 1;
> -				break;
> -			}
> +			if (page->index > end)
> +				goto out;
>  
>  			*done_index = page->index + 1;
>  
>  			lock_page(page);
>  
>  			/*
> -			 * Page truncated or invalidated. We can freely skip it
> -			 * then, even for data integrity operations: the page
> -			 * has disappeared concurrently, so there could be no
> -			 * real expectation of this data interity operation
> -			 * even if there is now a new, dirty page at the same
> -			 * pagecache address.
> +			 * If the page is no longer dirty, or its
> +			 * mapping no longer corresponds to inode we
> +			 * are writing (which means it has been
> +			 * truncated or invalidated), or the page is
> +			 * already under writeback and we are not
> +			 * doing a data integrity writeback, skip the page
>  			 */
> -			if (unlikely(page->mapping != mapping)) {
> -continue_unlock:
> +			if (!PageDirty(page) ||
> +			    (PageWriteback(page) &&
> +			     (wbc->sync_mode == WB_SYNC_NONE)) ||
> +			    unlikely(page->mapping != mapping)) {
> +			continue_unlock:

Formatting is wrong here.  Everything else looks fine.  Thanks,

Josef
