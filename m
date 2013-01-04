From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/5] ext4: Always use ext4_bio_write_page() for writeout
Date: Fri, 4 Jan 2013 15:18:49 +0800
Message-ID: <20130104071849.GA31130@gmail.com>
References: <1357148744-4895-1-git-send-email-jack@suse.cz>
 <1357148744-4895-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54051 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3ADHFN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 02:05:13 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so9086324pad.26
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 23:05:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1357148744-4895-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 06:45:40PM +0100, Jan Kara wrote:
> Currently we sometimes used block_write_full_page() and sometimes
> ext4_bio_write_page() for writeback (depending on mount options and call
> path). Let's always use ext4_bio_write_page() to simplify things a bit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h  |    1 -
>  fs/ext4/inode.c |  128 ++++++-------------------------------------------------
>  fs/ext4/super.c |    7 +--
>  3 files changed, 16 insertions(+), 120 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8462eb3..70c7030 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -985,7 +985,6 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
> -#define EXT4_MOUNT_MBLK_IO_SUBMIT	0x4000000 /* multi-block io submits */
>  #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
>  #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
>  #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cb1c1ab..f95b511 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -134,8 +134,6 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
>  static void ext4_invalidatepage(struct page *page, unsigned long offset);
>  static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
>  				   struct buffer_head *bh_result, int create);
> -static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
> -static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
>  static int __ext4_journalled_writepage(struct page *page, unsigned int len);
>  static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
>  static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
> @@ -808,11 +806,10 @@ int ext4_walk_page_buffers(handle_t *handle,
>   * and the commit_write().  So doing the jbd2_journal_start at the start of
>   * prepare_write() is the right place.
>   *
> - * Also, this function can nest inside ext4_writepage() ->
> - * block_write_full_page(). In that case, we *know* that ext4_writepage()
> - * has generated enough buffer credits to do the whole page.  So we won't
> - * block on the journal in that case, which is good, because the caller may
> - * be PF_MEMALLOC.
> + * Also, this function can nest inside ext4_writepage().  In that case, we
> + * *know* that ext4_writepage() has generated enough buffer credits to do the
> + * whole page.  So we won't block on the journal in that case, which is good,
> + * because the caller may be PF_MEMALLOC.
>   *
>   * By accident, ext4 can be reentered when a transaction is open via
>   * quota file writes.  If we were to commit the transaction while thus
> @@ -1463,18 +1460,9 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  			 */
>  			if (unlikely(journal_data && PageChecked(page)))
>  				err = __ext4_journalled_writepage(page, len);
> -			else if (test_opt(inode->i_sb, MBLK_IO_SUBMIT))
> +			else
>  				err = ext4_bio_write_page(&io_submit, page,
>  							  len, mpd->wbc);
> -			else if (buffer_uninit(page_bufs)) {
> -				ext4_set_bh_endio(page_bufs, inode);
> -				err = block_write_full_page_endio(page,
> -					noalloc_get_block_write,
> -					mpd->wbc, ext4_end_io_buffer_write);
> -			} else
> -				err = block_write_full_page(page,
> -					noalloc_get_block_write, mpd->wbc);
> -
>  			if (!err)
>  				mpd->pages_written++;
>  			/*
> @@ -1891,16 +1879,16 @@ int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  }
>  
>  /*
> - * This function is used as a standard get_block_t calback function
> - * when there is no desire to allocate any blocks.  It is used as a
> - * callback function for block_write_begin() and block_write_full_page().
> - * These functions should only try to map a single block at a time.
> + * This function is used as a standard get_block_t calback function when there
> + * is no desire to allocate any blocks.  It is used as a callback function for
> + * block_write_begin().  These functions should only try to map a single block
> + * at a time.
>   *
>   * Since this function doesn't do block allocations even if the caller
>   * requests it by passing in create=1, it is critically important that
>   * any caller checks to make sure that any buffer heads are returned
>   * by this function are either all already mapped or marked for
> - * delayed allocation before calling  block_write_full_page().  Otherwise,
> + * delayed allocation before calling ext4_bio_write_page().  Otherwise,
>   * b_blocknr could be left unitialized, and the page write functions will
>   * be taken by surprise.
>   */
> @@ -2040,6 +2028,7 @@ static int ext4_writepage(struct page *page,
>  	unsigned int len;
>  	struct buffer_head *page_bufs = NULL;
>  	struct inode *inode = page->mapping->host;
> +	struct ext4_io_submit io_submit;
>  
>  	trace_ext4_writepage(page);
>  	size = i_size_read(inode);
> @@ -2089,14 +2078,9 @@ static int ext4_writepage(struct page *page,
>  		 */
>  		return __ext4_journalled_writepage(page, len);
>  
> -	if (buffer_uninit(page_bufs)) {
> -		ext4_set_bh_endio(page_bufs, inode);
> -		ret = block_write_full_page_endio(page, noalloc_get_block_write,
> -					    wbc, ext4_end_io_buffer_write);
> -	} else
> -		ret = block_write_full_page(page, noalloc_get_block_write,
> -					    wbc);
> -
> +	memset(&io_submit, 0, sizeof(io_submit));
> +	ret = ext4_bio_write_page(&io_submit, page, len, wbc);
> +	ext4_io_submit(&io_submit);
>  	return ret;
>  }
>  
> @@ -2858,26 +2842,6 @@ ext4_readpages(struct file *file, struct address_space *mapping,
>  	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
>  }
>  
> -static void ext4_invalidatepage_free_endio(struct page *page, unsigned long offset)
> -{
> -	struct buffer_head *head, *bh;
> -	unsigned int curr_off = 0;
> -
> -	if (!page_has_buffers(page))
> -		return;
> -	head = bh = page_buffers(page);
> -	do {
> -		if (offset <= curr_off && test_clear_buffer_uninit(bh)
> -					&& bh->b_private) {
> -			ext4_free_io_end(bh->b_private);
> -			bh->b_private = NULL;
> -			bh->b_end_io = NULL;
> -		}
> -		curr_off = curr_off + bh->b_size;
> -		bh = bh->b_this_page;
> -	} while (bh != head);
> -}
> -
>  static void ext4_invalidatepage(struct page *page, unsigned long offset)
>  {
>  	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
> @@ -2885,11 +2849,6 @@ static void ext4_invalidatepage(struct page *page, unsigned long offset)
>  	trace_ext4_invalidatepage(page, offset);
>  
>  	/*
> -	 * free any io_end structure allocated for buffers to be discarded
> -	 */
> -	if (ext4_should_dioread_nolock(page->mapping->host))
> -		ext4_invalidatepage_free_endio(page, offset);
> -	/*
>  	 * If it's a full truncate we just forget about the pending dirtying
>  	 */
>  	if (offset == 0)
> @@ -2977,65 +2936,6 @@ out:
>  	ext4_add_complete_io(io_end);
>  }
>  
> -static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
> -{
> -	ext4_io_end_t *io_end = bh->b_private;
> -	struct inode *inode;
> -
> -	if (!test_clear_buffer_uninit(bh) || !io_end)
> -		goto out;
> -
> -	if (!(io_end->inode->i_sb->s_flags & MS_ACTIVE)) {
> -		ext4_msg(io_end->inode->i_sb, KERN_INFO,
> -			 "sb umounted, discard end_io request for inode %lu",
> -			 io_end->inode->i_ino);
> -		ext4_free_io_end(io_end);
> -		goto out;
> -	}
> -
> -	/*
> -	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
> -	 * but being more careful is always safe for the future change.
> -	 */
> -	inode = io_end->inode;
> -	ext4_set_io_unwritten_flag(inode, io_end);
> -	ext4_add_complete_io(io_end);
> -out:
> -	bh->b_private = NULL;
> -	bh->b_end_io = NULL;
> -	clear_buffer_uninit(bh);
> -	end_buffer_async_write(bh, uptodate);
> -}
> -
> -static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode)
> -{
> -	ext4_io_end_t *io_end;
> -	struct page *page = bh->b_page;
> -	loff_t offset = (sector_t)page->index << PAGE_CACHE_SHIFT;
> -	size_t size = bh->b_size;
> -
> -retry:
> -	io_end = ext4_init_io_end(inode, GFP_ATOMIC);
> -	if (!io_end) {
> -		pr_warn_ratelimited("%s: allocation fail\n", __func__);
> -		schedule();
> -		goto retry;
> -	}
> -	io_end->offset = offset;
> -	io_end->size = size;
> -	/*
> -	 * We need to hold a reference to the page to make sure it
> -	 * doesn't get evicted before ext4_end_io_work() has a chance
> -	 * to convert the extent from written to unwritten.
> -	 */
> -	io_end->page = page;
> -	get_page(io_end->page);
> -
> -	bh->b_private = io_end;
> -	bh->b_end_io = ext4_end_io_buffer_write;
> -	return 0;
> -}
> -
>  /*
>   * For ext4 extent files, ext4 will do direct-io write to holes,
>   * preallocated extents, and those write extend the file, no need to
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e09f7d1..afbe974 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1280,8 +1280,8 @@ static const match_table_t tokens = {
>  	{Opt_stripe, "stripe=%u"},
>  	{Opt_delalloc, "delalloc"},
>  	{Opt_nodelalloc, "nodelalloc"},
> -	{Opt_mblk_io_submit, "mblk_io_submit"},
> -	{Opt_nomblk_io_submit, "nomblk_io_submit"},
> +	{Opt_removed, "mblk_io_submit"},
> +	{Opt_removed, "nomblk_io_submit"},
>  	{Opt_block_validity, "block_validity"},
>  	{Opt_noblock_validity, "noblock_validity"},
>  	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
> @@ -1414,8 +1414,6 @@ static const struct mount_opts {
>  	{Opt_bsd_df, EXT4_MOUNT_MINIX_DF, MOPT_CLEAR},
>  	{Opt_grpid, EXT4_MOUNT_GRPID, MOPT_SET},
>  	{Opt_nogrpid, EXT4_MOUNT_GRPID, MOPT_CLEAR},
> -	{Opt_mblk_io_submit, EXT4_MOUNT_MBLK_IO_SUBMIT, MOPT_SET},
> -	{Opt_nomblk_io_submit, EXT4_MOUNT_MBLK_IO_SUBMIT, MOPT_CLEAR},
>  	{Opt_block_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_SET},
>  	{Opt_noblock_validity, EXT4_MOUNT_BLOCK_VALIDITY, MOPT_CLEAR},
>  	{Opt_dioread_nolock, EXT4_MOUNT_DIOREAD_NOLOCK, MOPT_SET},
> @@ -3373,7 +3371,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  #ifdef CONFIG_EXT4_FS_POSIX_ACL
>  	set_opt(sb, POSIX_ACL);
>  #endif
> -	set_opt(sb, MBLK_IO_SUBMIT);
>  	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
>  		set_opt(sb, JOURNAL_DATA);
>  	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
