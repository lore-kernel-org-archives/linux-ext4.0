From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 02/29] ext4: Use io_end for multiple bios
Date: Thu, 11 Apr 2013 22:04:35 +0800
Message-ID: <20130411140435.GC3448@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59725 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3DKNrm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 09:47:42 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so917345pab.1
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2013 06:47:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:07PM +0200, Jan Kara wrote:
> Change writeback path to create just one io_end structure for the extent
> to which we submit IO and share it among bios writing that extent. This
> prevents needless splitting and joining of unwritten extents when they
> cannot be submitted as a single bio.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h    |    8 +++-
>  fs/ext4/inode.c   |   85 ++++++++++++++++++++-----------------
>  fs/ext4/page-io.c |  121 +++++++++++++++++++++++++++++++++--------------------
>  3 files changed, 128 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3c70547..edf9b9e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -207,6 +207,7 @@ typedef struct ext4_io_end {
>  	ssize_t			size;		/* size of the extent */
>  	struct kiocb		*iocb;		/* iocb struct for AIO */
>  	int			result;		/* error value for AIO */
> +	atomic_t		count;		/* reference counter */
>  } ext4_io_end_t;
>  
>  struct ext4_io_submit {
> @@ -2601,11 +2602,14 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  
>  /* page-io.c */
>  extern int __init ext4_init_pageio(void);
> -extern void ext4_add_complete_io(ext4_io_end_t *io_end);
>  extern void ext4_exit_pageio(void);
>  extern void ext4_ioend_wait(struct inode *);
> -extern void ext4_free_io_end(ext4_io_end_t *io);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> +extern ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end);
> +extern int ext4_put_io_end(ext4_io_end_t *io_end);
> +extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
> +extern void ext4_io_submit_init(struct ext4_io_submit *io,
> +				struct writeback_control *wbc);
>  extern void ext4_end_io_work(struct work_struct *work);
>  extern void ext4_io_submit(struct ext4_io_submit *io);
>  extern int ext4_bio_write_page(struct ext4_io_submit *io,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6b8ec2a..ba07412 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1409,7 +1409,10 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  	struct ext4_io_submit io_submit;
>  
>  	BUG_ON(mpd->next_page <= mpd->first_page);
> -	memset(&io_submit, 0, sizeof(io_submit));
> +	ext4_io_submit_init(&io_submit, mpd->wbc);
> +	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
> +	if (!io_submit.io_end)
> +		return -ENOMEM;
>  	/*
>  	 * We need to start from the first_page to the next_page - 1
>  	 * to make sure we also write the mapped dirty buffer_heads.
> @@ -1497,6 +1500,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  		pagevec_release(&pvec);
>  	}
>  	ext4_io_submit(&io_submit);
> +	/* Drop io_end reference we got from init */
> +	ext4_put_io_end_defer(io_submit.io_end);
>  	return ret;
>  }
>  
> @@ -2116,9 +2121,16 @@ static int ext4_writepage(struct page *page,
>  		 */
>  		return __ext4_journalled_writepage(page, len);
>  
> -	memset(&io_submit, 0, sizeof(io_submit));
> +	ext4_io_submit_init(&io_submit, wbc);
> +	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
> +	if (!io_submit.io_end) {
> +		redirty_page_for_writepage(wbc, page);
> +		return -ENOMEM;
> +	}
>  	ret = ext4_bio_write_page(&io_submit, page, len, wbc);
>  	ext4_io_submit(&io_submit);
> +	/* Drop io_end reference we got from init */
> +	ext4_put_io_end_defer(io_submit.io_end);
>  	return ret;
>  }
>  
> @@ -2957,9 +2969,13 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  	struct inode *inode = file_inode(iocb->ki_filp);
>          ext4_io_end_t *io_end = iocb->private;
>  
> -	/* if not async direct IO or dio with 0 bytes write, just return */
> -	if (!io_end || !size)
> -		goto out;
> +	/* if not async direct IO just return */
> +	if (!io_end) {
> +		inode_dio_done(inode);
> +		if (is_async)
> +			aio_complete(iocb, ret, 0);
> +		return;
> +	}
>  
>  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
>  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
> @@ -2967,25 +2983,13 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  		  size);
>  
>  	iocb->private = NULL;
> -
> -	/* if not aio dio with unwritten extents, just free io and return */
> -	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> -		ext4_free_io_end(io_end);
> -out:
> -		inode_dio_done(inode);
> -		if (is_async)
> -			aio_complete(iocb, ret, 0);
> -		return;
> -	}
> -
>  	io_end->offset = offset;
>  	io_end->size = size;
>  	if (is_async) {
>  		io_end->iocb = iocb;
>  		io_end->result = ret;
>  	}
> -
> -	ext4_add_complete_io(io_end);
> +	ext4_put_io_end_defer(io_end);
>  }
>  
>  /*
> @@ -3019,6 +3023,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	get_block_t *get_block_func = NULL;
>  	int dio_flags = 0;
>  	loff_t final_size = offset + count;
> +	ext4_io_end_t *io_end = NULL;
>  
>  	/* Use the old path for reads and writes beyond i_size. */
>  	if (rw != WRITE || final_size > inode->i_size)
> @@ -3057,13 +3062,16 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	iocb->private = NULL;
>  	ext4_inode_aio_set(inode, NULL);
>  	if (!is_sync_kiocb(iocb)) {
> -		ext4_io_end_t *io_end = ext4_init_io_end(inode, GFP_NOFS);
> +		io_end = ext4_init_io_end(inode, GFP_NOFS);
>  		if (!io_end) {
>  			ret = -ENOMEM;
>  			goto retake_lock;
>  		}
>  		io_end->flag |= EXT4_IO_END_DIRECT;
> -		iocb->private = io_end;
> +		/*
> +		 * Grab reference for DIO. Will be dropped in ext4_end_io_dio()
> +		 */
> +		iocb->private = ext4_get_io_end(io_end);
>  		/*
>  		 * we save the io structure for current async direct
>  		 * IO, so that later ext4_map_blocks() could flag the
> @@ -3087,26 +3095,27 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  				   NULL,
>  				   dio_flags);
>  
> -	if (iocb->private)
> -		ext4_inode_aio_set(inode, NULL);
>  	/*
> -	 * The io_end structure takes a reference to the inode, that
> -	 * structure needs to be destroyed and the reference to the
> -	 * inode need to be dropped, when IO is complete, even with 0
> -	 * byte write, or failed.
> -	 *
> -	 * In the successful AIO DIO case, the io_end structure will
> -	 * be destroyed and the reference to the inode will be dropped
> -	 * after the end_io call back function is called.
> -	 *
> -	 * In the case there is 0 byte write, or error case, since VFS
> -	 * direct IO won't invoke the end_io call back function, we
> -	 * need to free the end_io structure here.
> +	 * Put our reference to io_end. This can free the io_end structure e.g.
> +	 * in sync IO case or in case of error. It can even perform extent
> +	 * conversion if all bios we submitted finished before we got here.
> +	 * Note that in that case iocb->private can be already set to NULL
> +	 * here.
>  	 */
> -	if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
> -		ext4_free_io_end(iocb->private);
> -		iocb->private = NULL;
> -	} else if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
> +	if (io_end) {
> +		ext4_inode_aio_set(inode, NULL);
> +		ext4_put_io_end(io_end);
> +		/*
> +		 * In case of error or no write ext4_end_io_dio() was not
> +		 * called so we have to put iocb's reference.
> +		 */
> +		if (ret <= 0 && ret != -EIOCBQUEUED) {
> +			WARN_ON(iocb->private != io_end);
> +			ext4_put_io_end(io_end);
> +			iocb->private = NULL;
> +		}
> +	}
> +	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
>  						EXT4_STATE_DIO_UNWRITTEN)) {
>  		int err;
>  		/*
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 73bc011..da8bddf 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -51,17 +51,28 @@ void ext4_ioend_wait(struct inode *inode)
>  	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
>  }
>  
> -void ext4_free_io_end(ext4_io_end_t *io)
> +static void ext4_release_io_end(ext4_io_end_t *io_end)
>  {
> -	int i;
> +	BUG_ON(!list_empty(&io_end->list));
> +	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> +
> +	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
> +		wake_up_all(ext4_ioend_wq(io_end->inode));
> +	if (io_end->flag & EXT4_IO_END_DIRECT)
> +		inode_dio_done(io_end->inode);
> +	if (io_end->iocb)
> +		aio_complete(io_end->iocb, io_end->result, 0);
> +	kmem_cache_free(io_end_cachep, io_end);
> +}
>  
> -	BUG_ON(!io);
> -	BUG_ON(!list_empty(&io->list));
> -	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
> +static void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
> +{
> +	struct inode *inode = io_end->inode;
>  
> -	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count))
> -		wake_up_all(ext4_ioend_wq(io->inode));
> -	kmem_cache_free(io_end_cachep, io);
> +	io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
> +	/* Wake up anyone waiting on unwritten extent conversion */
> +	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> +		wake_up_all(ext4_ioend_wq(inode));
>  }
>  
>  /* check a range of space and convert unwritten extents to written. */
> @@ -84,13 +95,8 @@ static int ext4_end_io(ext4_io_end_t *io)
>  			 "(inode %lu, offset %llu, size %zd, error %d)",
>  			 inode->i_ino, offset, size, ret);
>  	}
> -	/* Wake up anyone waiting on unwritten extent conversion */
> -	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> -		wake_up_all(ext4_ioend_wq(inode));
> -	if (io->flag & EXT4_IO_END_DIRECT)
> -		inode_dio_done(inode);
> -	if (io->iocb)
> -		aio_complete(io->iocb, io->result, 0);
> +	ext4_clear_io_unwritten_flag(io);
> +	ext4_release_io_end(io);
>  	return ret;
>  }
>  
> @@ -121,7 +127,7 @@ static void dump_completed_IO(struct inode *inode)
>  }
>  
>  /* Add the io_end to per-inode completed end_io list. */
> -void ext4_add_complete_io(ext4_io_end_t *io_end)
> +static void ext4_add_complete_io(ext4_io_end_t *io_end)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
>  	struct workqueue_struct *wq;
> @@ -158,8 +164,6 @@ static int ext4_do_flush_completed_IO(struct inode *inode)
>  		err = ext4_end_io(io);
>  		if (unlikely(!ret && err))
>  			ret = err;
> -		io->flag &= ~EXT4_IO_END_UNWRITTEN;
> -		ext4_free_io_end(io);
>  	}
>  	return ret;
>  }
> @@ -191,10 +195,43 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
>  		atomic_inc(&EXT4_I(inode)->i_ioend_count);
>  		io->inode = inode;
>  		INIT_LIST_HEAD(&io->list);
> +		atomic_set(&io->count, 1);
>  	}
>  	return io;
>  }
>  
> +void ext4_put_io_end_defer(ext4_io_end_t *io_end)
> +{
> +	if (atomic_dec_and_test(&io_end->count)) {
> +		if (!(io_end->flag & EXT4_IO_END_UNWRITTEN) || !io_end->size) {
> +			ext4_release_io_end(io_end);
> +			return;
> +		}
> +		ext4_add_complete_io(io_end);
> +	}
> +}
> +
> +int ext4_put_io_end(ext4_io_end_t *io_end)
> +{
> +	int err = 0;
> +
> +	if (atomic_dec_and_test(&io_end->count)) {
> +		if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
> +			err = ext4_convert_unwritten_extents(io_end->inode,
> +						io_end->offset, io_end->size);
> +			ext4_clear_io_unwritten_flag(io_end);
> +		}
> +		ext4_release_io_end(io_end);
> +	}
> +	return err;
> +}
> +
> +ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
> +{
> +	atomic_inc(&io_end->count);
> +	return io_end;
> +}
> +
>  /*
>   * Print an buffer I/O error compatible with the fs/buffer.c.  This
>   * provides compatibility with dmesg scrapers that look for a specific
> @@ -277,12 +314,7 @@ static void ext4_end_bio(struct bio *bio, int error)
>  			     bi_sector >> (inode->i_blkbits - 9));
>  	}
>  
> -	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> -		ext4_free_io_end(io_end);
> -		return;
> -	}
> -
> -	ext4_add_complete_io(io_end);
> +	ext4_put_io_end_defer(io_end);
>  }
>  
>  void ext4_io_submit(struct ext4_io_submit *io)
> @@ -296,40 +328,37 @@ void ext4_io_submit(struct ext4_io_submit *io)
>  		bio_put(io->io_bio);
>  	}
>  	io->io_bio = NULL;
> -	io->io_op = 0;
> +}
> +
> +void ext4_io_submit_init(struct ext4_io_submit *io,
> +			 struct writeback_control *wbc)
> +{
> +	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
> +	io->io_bio = NULL;
>  	io->io_end = NULL;
>  }
>  
> -static int io_submit_init(struct ext4_io_submit *io,
> -			  struct inode *inode,
> -			  struct writeback_control *wbc,
> -			  struct buffer_head *bh)
> +static int io_submit_init_bio(struct ext4_io_submit *io,
> +			      struct buffer_head *bh)
>  {
> -	ext4_io_end_t *io_end;
> -	struct page *page = bh->b_page;
>  	int nvecs = bio_get_nr_vecs(bh->b_bdev);
>  	struct bio *bio;
>  
> -	io_end = ext4_init_io_end(inode, GFP_NOFS);
> -	if (!io_end)
> -		return -ENOMEM;
>  	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
>  	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  	bio->bi_bdev = bh->b_bdev;
> -	bio->bi_private = io->io_end = io_end;
>  	bio->bi_end_io = ext4_end_bio;
> -
> -	io_end->offset = (page->index << PAGE_CACHE_SHIFT) + bh_offset(bh);
> -
> +	bio->bi_private = ext4_get_io_end(io->io_end);
> +	if (!io->io_end->size)
> +		io->io_end->offset = (bh->b_page->index << PAGE_CACHE_SHIFT)
> +				     + bh_offset(bh);
>  	io->io_bio = bio;
> -	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
>  	io->io_next_block = bh->b_blocknr;
>  	return 0;
>  }
>  
>  static int io_submit_add_bh(struct ext4_io_submit *io,
>  			    struct inode *inode,
> -			    struct writeback_control *wbc,
>  			    struct buffer_head *bh)
>  {
>  	ext4_io_end_t *io_end;
> @@ -340,18 +369,18 @@ submit_and_retry:
>  		ext4_io_submit(io);
>  	}
>  	if (io->io_bio == NULL) {
> -		ret = io_submit_init(io, inode, wbc, bh);
> +		ret = io_submit_init_bio(io, bh);
>  		if (ret)
>  			return ret;
>  	}
> +	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
> +	if (ret != bh->b_size)
> +		goto submit_and_retry;
>  	io_end = io->io_end;
>  	if (buffer_uninit(bh))
>  		ext4_set_io_unwritten_flag(inode, io_end);
> -	io->io_end->size += bh->b_size;
> +	io_end->size += bh->b_size;
>  	io->io_next_block++;
> -	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
> -	if (ret != bh->b_size)
> -		goto submit_and_retry;
>  	return 0;
>  }
>  
> @@ -423,7 +452,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  	do {
>  		if (!buffer_async_write(bh))
>  			continue;
> -		ret = io_submit_add_bh(io, inode, wbc, bh);
> +		ret = io_submit_add_bh(io, inode, bh);
>  		if (ret) {
>  			/*
>  			 * We only get here on ENOMEM.  Not much else
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
