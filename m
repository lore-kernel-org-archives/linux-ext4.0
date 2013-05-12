From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: EXT4 regression caused 4eec7
Date: Sun, 12 May 2013 13:01:11 +0400
Message-ID: <87a9o01siw.fsf@openvz.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org> <87y5bm53z3.fsf@openvz.org> <87txm96fkd.fsf@openvz.org> <87mws1eq6y.fsf@openvz.org> <20130511230559.GD26298@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: EUNBONG SONG <eunb.song@samsung.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:64032 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3ELJBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 May 2013 05:01:17 -0400
In-Reply-To: <20130511230559.GD26298@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Sat, 11 May 2013 19:05:59 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, May 11, 2013 at 03:00:53PM +0400, Dmitry Monakhov wrote:
> > I've bisected ext4 related issue. It is appeared that it is pure ext4
> > specific. Regression caused by  following commit
> > commit 4eec708d263f0ee10861d69251708a225b64cac7
> > Author: Jan Kara <jack@suse.cz>
> > Date:   Thu Apr 11 23:56:53 2013 -0400
> >     ext4: use io_end for multiple bios
> 
> Hmm... the next question is why did I see this in my testing.  Did you
> find this on ia64, or x86?
No simple x86_64. 
> Also what about the slab corruption which
> you saw when running XFS; was that unrelated?
My theory about mysterious corruption in mm layer which broke everything
was wrong. We have to absolutely independent regressions in  different
filesystems:
* Slub corruption on XFS
  - testcase: xfstests/generic/007
  - bad commit: 666d64 
  - LINK: https://lkml.org/lkml/2013/5/11/154

* Slub corruption on EXT4
  - testcase: xfstests/generic/299
  - bad commit: 4eec70
  - link: https://lkml.org/lkml/2013/5/11/37
  - fix: https://lkml.org/lkml/2013/5/11/142

In fact '4eec70' are vexing because I have reviewed and tested this patch before
it was marked as Review-by, but missed the bug. This is because xfstests
was executed manually logs was full of warnings but tainted flag was not
checked at the end. To prevent this thing in future I'll always use my
local autotest(http://autotest.github.io/) farm next time.

BTW here is my config with various debug options enabled.

--=-=-=
Content-Type: application/x-xz
Content-Disposition: attachment; filename=config.xz
Content-Transfer-Encoding: base64

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
cjQfYrHEZ/sCAAAAAARZWg==
--=-=-=


> 
> Since at this point it's safer to rollback the change and we can
> investigate more deeply how to fix it correctly for the next
> development cycle, this is the patch which I'm testing.
> 
> 	    	   	       	     - Ted
> 
> From dfd5057908a66b414d5d5fa2fc7ff7945e5a277c Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sat, 11 May 2013 18:59:39 -0400
> Subject: [PATCH] Revert "ext4: use io_end for multiple bios"
> 
> This reverts commit 4eec708d263f0ee10861d69251708a225b64cac7.
> 
> Multiple users have reported crashes which is apparently caused by
> this commit.  Thanks to Dmitry Monakhov for bisecting it.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |   8 +---
>  fs/ext4/inode.c   |  85 +++++++++++++++++---------------------
>  fs/ext4/page-io.c | 121 ++++++++++++++++++++----------------------------------
>  3 files changed, 85 insertions(+), 129 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0aabb34..5aae3d1 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -209,7 +209,6 @@ typedef struct ext4_io_end {
>  	ssize_t			size;		/* size of the extent */
>  	struct kiocb		*iocb;		/* iocb struct for AIO */
>  	int			result;		/* error value for AIO */
> -	atomic_t		count;		/* reference counter */
>  } ext4_io_end_t;
>  
>  struct ext4_io_submit {
> @@ -2651,14 +2650,11 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  
>  /* page-io.c */
>  extern int __init ext4_init_pageio(void);
> +extern void ext4_add_complete_io(ext4_io_end_t *io_end);
>  extern void ext4_exit_pageio(void);
>  extern void ext4_ioend_shutdown(struct inode *);
> +extern void ext4_free_io_end(ext4_io_end_t *io);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> -extern ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end);
> -extern int ext4_put_io_end(ext4_io_end_t *io_end);
> -extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
> -extern void ext4_io_submit_init(struct ext4_io_submit *io,
> -				struct writeback_control *wbc);
>  extern void ext4_end_io_work(struct work_struct *work);
>  extern void ext4_io_submit(struct ext4_io_submit *io);
>  extern int ext4_bio_write_page(struct ext4_io_submit *io,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 793d44b..d666569 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1487,10 +1487,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  	struct ext4_io_submit io_submit;
>  
>  	BUG_ON(mpd->next_page <= mpd->first_page);
> -	ext4_io_submit_init(&io_submit, mpd->wbc);
> -	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
> -	if (!io_submit.io_end)
> -		return -ENOMEM;
> +	memset(&io_submit, 0, sizeof(io_submit));
>  	/*
>  	 * We need to start from the first_page to the next_page - 1
>  	 * to make sure we also write the mapped dirty buffer_heads.
> @@ -1578,8 +1575,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  		pagevec_release(&pvec);
>  	}
>  	ext4_io_submit(&io_submit);
> -	/* Drop io_end reference we got from init */
> -	ext4_put_io_end_defer(io_submit.io_end);
>  	return ret;
>  }
>  
> @@ -2238,16 +2233,9 @@ static int ext4_writepage(struct page *page,
>  		 */
>  		return __ext4_journalled_writepage(page, len);
>  
> -	ext4_io_submit_init(&io_submit, wbc);
> -	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
> -	if (!io_submit.io_end) {
> -		redirty_page_for_writepage(wbc, page);
> -		return -ENOMEM;
> -	}
> +	memset(&io_submit, 0, sizeof(io_submit));
>  	ret = ext4_bio_write_page(&io_submit, page, len, wbc);
>  	ext4_io_submit(&io_submit);
> -	/* Drop io_end reference we got from init */
> -	ext4_put_io_end_defer(io_submit.io_end);
>  	return ret;
>  }
>  
> @@ -3078,13 +3066,9 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  	struct inode *inode = file_inode(iocb->ki_filp);
>          ext4_io_end_t *io_end = iocb->private;
>  
> -	/* if not async direct IO just return */
> -	if (!io_end) {
> -		inode_dio_done(inode);
> -		if (is_async)
> -			aio_complete(iocb, ret, 0);
> -		return;
> -	}
> +	/* if not async direct IO or dio with 0 bytes write, just return */
> +	if (!io_end || !size)
> +		goto out;
>  
>  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
>  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
> @@ -3092,13 +3076,25 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  		  size);
>  
>  	iocb->private = NULL;
> +
> +	/* if not aio dio with unwritten extents, just free io and return */
> +	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		ext4_free_io_end(io_end);
> +out:
> +		inode_dio_done(inode);
> +		if (is_async)
> +			aio_complete(iocb, ret, 0);
> +		return;
> +	}
> +
>  	io_end->offset = offset;
>  	io_end->size = size;
>  	if (is_async) {
>  		io_end->iocb = iocb;
>  		io_end->result = ret;
>  	}
> -	ext4_put_io_end_defer(io_end);
> +
> +	ext4_add_complete_io(io_end);
>  }
>  
>  /*
> @@ -3132,7 +3128,6 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	get_block_t *get_block_func = NULL;
>  	int dio_flags = 0;
>  	loff_t final_size = offset + count;
> -	ext4_io_end_t *io_end = NULL;
>  
>  	/* Use the old path for reads and writes beyond i_size. */
>  	if (rw != WRITE || final_size > inode->i_size)
> @@ -3171,16 +3166,13 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	iocb->private = NULL;
>  	ext4_inode_aio_set(inode, NULL);
>  	if (!is_sync_kiocb(iocb)) {
> -		io_end = ext4_init_io_end(inode, GFP_NOFS);
> +		ext4_io_end_t *io_end = ext4_init_io_end(inode, GFP_NOFS);
>  		if (!io_end) {
>  			ret = -ENOMEM;
>  			goto retake_lock;
>  		}
>  		io_end->flag |= EXT4_IO_END_DIRECT;
> -		/*
> -		 * Grab reference for DIO. Will be dropped in ext4_end_io_dio()
> -		 */
> -		iocb->private = ext4_get_io_end(io_end);
> +		iocb->private = io_end;
>  		/*
>  		 * we save the io structure for current async direct
>  		 * IO, so that later ext4_map_blocks() could flag the
> @@ -3204,27 +3196,26 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  				   NULL,
>  				   dio_flags);
>  
> +	if (iocb->private)
> +		ext4_inode_aio_set(inode, NULL);
>  	/*
> -	 * Put our reference to io_end. This can free the io_end structure e.g.
> -	 * in sync IO case or in case of error. It can even perform extent
> -	 * conversion if all bios we submitted finished before we got here.
> -	 * Note that in that case iocb->private can be already set to NULL
> -	 * here.
> +	 * The io_end structure takes a reference to the inode, that
> +	 * structure needs to be destroyed and the reference to the
> +	 * inode need to be dropped, when IO is complete, even with 0
> +	 * byte write, or failed.
> +	 *
> +	 * In the successful AIO DIO case, the io_end structure will
> +	 * be destroyed and the reference to the inode will be dropped
> +	 * after the end_io call back function is called.
> +	 *
> +	 * In the case there is 0 byte write, or error case, since VFS
> +	 * direct IO won't invoke the end_io call back function, we
> +	 * need to free the end_io structure here.
>  	 */
> -	if (io_end) {
> -		ext4_inode_aio_set(inode, NULL);
> -		ext4_put_io_end(io_end);
> -		/*
> -		 * In case of error or no write ext4_end_io_dio() was not
> -		 * called so we have to put iocb's reference.
> -		 */
> -		if (ret <= 0 && ret != -EIOCBQUEUED) {
> -			WARN_ON(iocb->private != io_end);
> -			ext4_put_io_end(io_end);
> -			iocb->private = NULL;
> -		}
> -	}
> -	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
> +	if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
> +		ext4_free_io_end(iocb->private);
> +		iocb->private = NULL;
> +	} else if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
>  						EXT4_STATE_DIO_UNWRITTEN)) {
>  		int err;
>  		/*
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 5929cd0..6626aba 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -61,28 +61,15 @@ void ext4_ioend_shutdown(struct inode *inode)
>  		cancel_work_sync(&EXT4_I(inode)->i_unwritten_work);
>  }
>  
> -static void ext4_release_io_end(ext4_io_end_t *io_end)
> +void ext4_free_io_end(ext4_io_end_t *io)
>  {
> -	BUG_ON(!list_empty(&io_end->list));
> -	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> -
> -	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
> -		wake_up_all(ext4_ioend_wq(io_end->inode));
> -	if (io_end->flag & EXT4_IO_END_DIRECT)
> -		inode_dio_done(io_end->inode);
> -	if (io_end->iocb)
> -		aio_complete(io_end->iocb, io_end->result, 0);
> -	kmem_cache_free(io_end_cachep, io_end);
> -}
> -
> -static void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
> -{
> -	struct inode *inode = io_end->inode;
> +	BUG_ON(!io);
> +	BUG_ON(!list_empty(&io->list));
> +	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
>  
> -	io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
> -	/* Wake up anyone waiting on unwritten extent conversion */
> -	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> -		wake_up_all(ext4_ioend_wq(inode));
> +	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count))
> +		wake_up_all(ext4_ioend_wq(io->inode));
> +	kmem_cache_free(io_end_cachep, io);
>  }
>  
>  /* check a range of space and convert unwritten extents to written. */
> @@ -105,8 +92,13 @@ static int ext4_end_io(ext4_io_end_t *io)
>  			 "(inode %lu, offset %llu, size %zd, error %d)",
>  			 inode->i_ino, offset, size, ret);
>  	}
> -	ext4_clear_io_unwritten_flag(io);
> -	ext4_release_io_end(io);
> +	/* Wake up anyone waiting on unwritten extent conversion */
> +	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> +		wake_up_all(ext4_ioend_wq(inode));
> +	if (io->flag & EXT4_IO_END_DIRECT)
> +		inode_dio_done(inode);
> +	if (io->iocb)
> +		aio_complete(io->iocb, io->result, 0);
>  	return ret;
>  }
>  
> @@ -137,7 +129,7 @@ static void dump_completed_IO(struct inode *inode)
>  }
>  
>  /* Add the io_end to per-inode completed end_io list. */
> -static void ext4_add_complete_io(ext4_io_end_t *io_end)
> +void ext4_add_complete_io(ext4_io_end_t *io_end)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
>  	struct workqueue_struct *wq;
> @@ -174,6 +166,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode)
>  		err = ext4_end_io(io);
>  		if (unlikely(!ret && err))
>  			ret = err;
> +		io->flag &= ~EXT4_IO_END_UNWRITTEN;
> +		ext4_free_io_end(io);
>  	}
>  	return ret;
>  }
> @@ -205,43 +199,10 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
>  		atomic_inc(&EXT4_I(inode)->i_ioend_count);
>  		io->inode = inode;
>  		INIT_LIST_HEAD(&io->list);
> -		atomic_set(&io->count, 1);
>  	}
>  	return io;
>  }
>  
> -void ext4_put_io_end_defer(ext4_io_end_t *io_end)
> -{
> -	if (atomic_dec_and_test(&io_end->count)) {
> -		if (!(io_end->flag & EXT4_IO_END_UNWRITTEN) || !io_end->size) {
> -			ext4_release_io_end(io_end);
> -			return;
> -		}
> -		ext4_add_complete_io(io_end);
> -	}
> -}
> -
> -int ext4_put_io_end(ext4_io_end_t *io_end)
> -{
> -	int err = 0;
> -
> -	if (atomic_dec_and_test(&io_end->count)) {
> -		if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
> -			err = ext4_convert_unwritten_extents(io_end->inode,
> -						io_end->offset, io_end->size);
> -			ext4_clear_io_unwritten_flag(io_end);
> -		}
> -		ext4_release_io_end(io_end);
> -	}
> -	return err;
> -}
> -
> -ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
> -{
> -	atomic_inc(&io_end->count);
> -	return io_end;
> -}
> -
>  /*
>   * Print an buffer I/O error compatible with the fs/buffer.c.  This
>   * provides compatibility with dmesg scrapers that look for a specific
> @@ -324,7 +285,12 @@ static void ext4_end_bio(struct bio *bio, int error)
>  			     bi_sector >> (inode->i_blkbits - 9));
>  	}
>  
> -	ext4_put_io_end_defer(io_end);
> +	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		ext4_free_io_end(io_end);
> +		return;
> +	}
> +
> +	ext4_add_complete_io(io_end);
>  }
>  
>  void ext4_io_submit(struct ext4_io_submit *io)
> @@ -338,37 +304,40 @@ void ext4_io_submit(struct ext4_io_submit *io)
>  		bio_put(io->io_bio);
>  	}
>  	io->io_bio = NULL;
> -}
> -
> -void ext4_io_submit_init(struct ext4_io_submit *io,
> -			 struct writeback_control *wbc)
> -{
> -	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
> -	io->io_bio = NULL;
> +	io->io_op = 0;
>  	io->io_end = NULL;
>  }
>  
> -static int io_submit_init_bio(struct ext4_io_submit *io,
> -			      struct buffer_head *bh)
> +static int io_submit_init(struct ext4_io_submit *io,
> +			  struct inode *inode,
> +			  struct writeback_control *wbc,
> +			  struct buffer_head *bh)
>  {
> +	ext4_io_end_t *io_end;
> +	struct page *page = bh->b_page;
>  	int nvecs = bio_get_nr_vecs(bh->b_bdev);
>  	struct bio *bio;
>  
> +	io_end = ext4_init_io_end(inode, GFP_NOFS);
> +	if (!io_end)
> +		return -ENOMEM;
>  	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
>  	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  	bio->bi_bdev = bh->b_bdev;
> +	bio->bi_private = io->io_end = io_end;
>  	bio->bi_end_io = ext4_end_bio;
> -	bio->bi_private = ext4_get_io_end(io->io_end);
> -	if (!io->io_end->size)
> -		io->io_end->offset = (bh->b_page->index << PAGE_CACHE_SHIFT)
> -				     + bh_offset(bh);
> +
> +	io_end->offset = (page->index << PAGE_CACHE_SHIFT) + bh_offset(bh);
> +
>  	io->io_bio = bio;
> +	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
>  	io->io_next_block = bh->b_blocknr;
>  	return 0;
>  }
>  
>  static int io_submit_add_bh(struct ext4_io_submit *io,
>  			    struct inode *inode,
> +			    struct writeback_control *wbc,
>  			    struct buffer_head *bh)
>  {
>  	ext4_io_end_t *io_end;
> @@ -379,18 +348,18 @@ submit_and_retry:
>  		ext4_io_submit(io);
>  	}
>  	if (io->io_bio == NULL) {
> -		ret = io_submit_init_bio(io, bh);
> +		ret = io_submit_init(io, inode, wbc, bh);
>  		if (ret)
>  			return ret;
>  	}
> -	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
> -	if (ret != bh->b_size)
> -		goto submit_and_retry;
>  	io_end = io->io_end;
>  	if (test_clear_buffer_uninit(bh))
>  		ext4_set_io_unwritten_flag(inode, io_end);
> -	io_end->size += bh->b_size;
> +	io->io_end->size += bh->b_size;
>  	io->io_next_block++;
> +	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
> +	if (ret != bh->b_size)
> +		goto submit_and_retry;
>  	return 0;
>  }
>  
> @@ -462,7 +431,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>  	do {
>  		if (!buffer_async_write(bh))
>  			continue;
> -		ret = io_submit_add_bh(io, inode, bh);
> +		ret = io_submit_add_bh(io, inode, wbc, bh);
>  		if (ret) {
>  			/*
>  			 * We only get here on ENOMEM.  Not much else
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
