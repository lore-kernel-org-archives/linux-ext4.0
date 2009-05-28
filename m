From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: Check for only delay or unwritten
	buffer_heads
Date: Thu, 28 May 2009 10:27:11 +0200
Message-ID: <20090528082711.GB29199@duck.suse.cz>
References: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50274 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbZE1I1K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 04:27:10 -0400
Content-Disposition: inline
In-Reply-To: <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-05-09 21:28:07, Aneesh Kumar K.V wrote:
> Even with changes to make pages writeprotech on truncate/i_size update we
> can still see buffer_heads which are not mapped in the writepage
> callback. Consider the below case.
> 
> 1) truncate(f, 1024)
> 2) mmap(f, 0, 4096)
> 3) a[0] = 'a'
> 4) truncate(f, 4096)
> 5) writepage(...)
> 
> Now if we get a writepage callback immediately after (4) and before an
> attempt to write at any other offset via mmap address (which implies we
> are yet to get a pagefault and do a get_block) what we would have is the
> page which is dirty have first block allocated and the other three
> buffer_heads unmapped.
> 
> In the above case the writepage should go ahead and try to write
> the first blocks and clear the page_dirty flag. Because the further
> attempt to write to the page will again create a fault and result in
> allocating blocks and marking page dirty. Also if we don't write
> any other offset via mmap address we would still have written the first
> block to the disk and rest of the space will be considered as a hole.
  OK, but this requires my patches to not cause data loss, doesn't it?
Nothing prevents user from writing data into the full page just after
truncate(f, 4096) before the writepage is called.  And without my patches,
fault will not happen for such user write.
  Just that we should have this dependency in mind. Otherwise the patch
looks fine to me.

									Honza

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   21 +++++++--------------
>  1 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f0f0065..1efb296 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2239,15 +2239,9 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
>  	return;
>  }
>  
> -static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> +static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
>  {
> -	/*
> -	 * unmapped buffer is possible for holes.
> -	 * delay buffer is possible with delayed allocation.
> -	 * We also need to consider unwritten buffer as unmapped.
> -	 */
> -	return (!buffer_mapped(bh) || buffer_delay(bh) ||
> -				buffer_unwritten(bh)) && buffer_dirty(bh);
> +	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
>  }
>  
>  /*
> @@ -2334,7 +2328,7 @@ static int __mpage_da_writepage(struct page *page,
>  			 * Otherwise we won't make progress
>  			 * with the page in ext4_da_writepage
>  			 */
> -			if (ext4_bh_unmapped_or_delay(NULL, bh)) {
> +			if (ext4_bh_delay_or_unwritten(NULL, bh)) {
>  				mpage_add_bh_to_extent(mpd, logical,
>  						       bh->b_size,
>  						       bh->b_state);
> @@ -2451,7 +2445,6 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
>  	 * so call get_block_wrap with create = 0
>  	 */
>  	ret = ext4_get_blocks(NULL, inode, iblock, max_blocks, bh_result, 0);
> -	BUG_ON(create && ret == 0);
>  	if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
>  		ret = 0;
> @@ -2487,7 +2480,7 @@ static int ext4_da_writepage(struct page *page,
>  	if (page_has_buffers(page)) {
>  		page_bufs = page_buffers(page);
>  		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> -					ext4_bh_unmapped_or_delay)) {
> +					ext4_bh_delay_or_unwritten)) {
>  			/*
>  			 * We don't want to do  block allocation
>  			 * So redirty the page and return
> @@ -2520,7 +2513,7 @@ static int ext4_da_writepage(struct page *page,
>  			page_bufs = page_buffers(page);
>  			/* check whether all are mapped and non delay */
>  			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> -						ext4_bh_unmapped_or_delay)) {
> +						ext4_bh_delay_or_unwritten)) {
>  				redirty_page_for_writepage(wbc, page);
>  				unlock_page(page);
>  				return 0;
> @@ -3196,7 +3189,7 @@ static int ext4_normal_writepage(struct page *page,
>  		 * happily proceed with mapping them and writing the page.
>  		 */
>  		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> -					ext4_bh_unmapped_or_delay));
> +					ext4_bh_delay_or_unwritten));
>  	}
>  
>  	if (!ext4_journal_current_handle())
> @@ -3291,7 +3284,7 @@ static int ext4_journalled_writepage(struct page *page,
>  		 * happily proceed with mapping them and writing the page.
>  		 */
>  		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> -					ext4_bh_unmapped_or_delay));
> +					ext4_bh_delay_or_unwritten));
>  	}
>  
>  	if (ext4_journal_current_handle())
> -- 
> 1.6.3.1.145.gb74d77
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
