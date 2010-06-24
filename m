From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] direct-io: move aio_complete into ->end_io
Date: Thu, 24 Jun 2010 23:59:22 +0200
Message-ID: <20100624215922.GE3345@quack.suse.cz>
References: <20100622122144.302857146@bombadil.infradead.org>
 <20100622123113.011371666@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab0FXV7t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jun 2010 17:59:49 -0400
Content-Disposition: inline
In-Reply-To: <20100622123113.011371666@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-06-10 08:21:45, Christoph Hellwig wrote:
> Filesystems with unwritten extent support must not complete an AIO request
> until the transaction to convert the extent has been commited.  That means
> the aio_complete calls needs to be moved into the ->end_io callback so
> that the filesystem can control when to call it exactly.
> 
> This makes a bit of a mess out of dio_complete and the ->end_io callback
> prototype even more complicated.  In addition ->end_io is now called with
> i_alloc_sem held for DIO_LOCKING filesystems.  The only filesystem that
> has both and ->end_io callback and sets DIO_LOCKING is ext4, which doesn't
> appear to do anything that could deadlock with i_alloc_sem in ->end_io.
  Umm, I don't get this. Looking at the ->end_io callback it has been
always called with i_alloc_sem held. It's only aio_complete() which will
be called with i_alloc_sem held after your changes. Or am I missing
something?
  Moreover the async testing you do does not seem to be completely right.
dio->is_async is a flag that controls whether dio code waits for IO to be
completed or not. In particular it is not set for AIO that spans beyond
current i_size so it does not seem to be exactly what you need (at least
for ext4 it isn't). I think that is_sync_kiocb() is a test that should be
used to recognize AIO - and that has an advantage that you don't have to
pass the is_async flag around.

								Honza
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/direct-io.c
> ===================================================================
> --- linux-2.6.orig/fs/direct-io.c	2010-06-22 09:48:37.239004298 +0200
> +++ linux-2.6/fs/direct-io.c	2010-06-22 11:54:42.281003878 +0200
> @@ -218,7 +218,7 @@ static struct page *dio_get_page(struct
>   * filesystems can use it to hold additional state between get_block calls and
>   * dio_complete.
>   */
> -static int dio_complete(struct dio *dio, loff_t offset, int ret)
> +static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
>  {
>  	ssize_t transferred = 0;
>  
> @@ -239,14 +239,6 @@ static int dio_complete(struct dio *dio,
>  			transferred = dio->i_size - offset;
>  	}
>  
> -	if (dio->end_io && dio->result)
> -		dio->end_io(dio->iocb, offset, transferred,
> -			    dio->map_bh.b_private);
> -
> -	if (dio->flags & DIO_LOCKING)
> -		/* lockdep: non-owner release */
> -		up_read_non_owner(&dio->inode->i_alloc_sem);
> -
>  	if (ret == 0)
>  		ret = dio->page_errors;
>  	if (ret == 0)
> @@ -254,6 +246,17 @@ static int dio_complete(struct dio *dio,
>  	if (ret == 0)
>  		ret = transferred;
>  
> +	if (dio->end_io && dio->result) {
> +		dio->end_io(dio->iocb, offset, transferred,
> +			    dio->map_bh.b_private, ret, is_async);
> +	} else if (is_async) {
> +		aio_complete(dio->iocb, ret, 0);
> +	}
> +
> +	if (dio->flags & DIO_LOCKING)
> +		/* lockdep: non-owner release */
> +		up_read_non_owner(&dio->inode->i_alloc_sem);
> +
>  	return ret;
>  }
>  
> @@ -277,8 +280,7 @@ static void dio_bio_end_aio(struct bio *
>  	spin_unlock_irqrestore(&dio->bio_lock, flags);
>  
>  	if (remaining == 0) {
> -		int ret = dio_complete(dio, dio->iocb->ki_pos, 0);
> -		aio_complete(dio->iocb, ret, 0);
> +		dio_complete(dio, dio->iocb->ki_pos, 0, true);
>  		kfree(dio);
>  	}
>  }
> @@ -1126,7 +1128,7 @@ direct_io_worker(int rw, struct kiocb *i
>  	spin_unlock_irqrestore(&dio->bio_lock, flags);
>  
>  	if (ret2 == 0) {
> -		ret = dio_complete(dio, offset, ret);
> +		ret = dio_complete(dio, offset, ret, false);
>  		kfree(dio);
>  	} else
>  		BUG_ON(ret != -EIOCBQUEUED);
> Index: linux-2.6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/inode.c	2010-06-22 09:48:37.249004508 +0200
> +++ linux-2.6/fs/ext4/inode.c	2010-06-22 12:18:45.883255381 +0200
> @@ -3775,7 +3775,8 @@ static ext4_io_end_t *ext4_init_io_end (
>  }
>  
>  static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> -			    ssize_t size, void *private)
> +			    ssize_t size, void *private, int ret,
> +			    bool is_async)
>  {
>          ext4_io_end_t *io_end = iocb->private;
>  	struct workqueue_struct *wq;
> @@ -3784,7 +3785,7 @@ static void ext4_end_io_dio(struct kiocb
>  
>  	/* if not async direct IO or dio with 0 bytes write, just return */
>  	if (!io_end || !size)
> -		return;
> +		goto out;
>  
>  	ext_debug("ext4_end_io_dio(): io_end 0x%p"
>  		  "for inode %lu, iocb 0x%p, offset %llu, size %llu\n",
> @@ -3795,7 +3796,7 @@ static void ext4_end_io_dio(struct kiocb
>  	if (io_end->flag != EXT4_IO_UNWRITTEN){
>  		ext4_free_io_end(io_end);
>  		iocb->private = NULL;
> -		return;
> +		goto out;
>  	}
>  
>  	io_end->offset = offset;
> @@ -3812,6 +3813,9 @@ static void ext4_end_io_dio(struct kiocb
>  	list_add_tail(&io_end->list, &ei->i_completed_io_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  	iocb->private = NULL;
> +out:
> +	if (is_async)
> +		aio_complete(iocb, ret, 0);
>  }
>  
>  static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
> Index: linux-2.6/fs/ocfs2/aops.c
> ===================================================================
> --- linux-2.6.orig/fs/ocfs2/aops.c	2010-06-22 09:48:37.259012749 +0200
> +++ linux-2.6/fs/ocfs2/aops.c	2010-06-22 12:19:03.931005757 +0200
> @@ -609,7 +609,9 @@ bail:
>  static void ocfs2_dio_end_io(struct kiocb *iocb,
>  			     loff_t offset,
>  			     ssize_t bytes,
> -			     void *private)
> +			     void *private,
> +			     int ret,
> +			     bool is_async)
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>  	int level;
> @@ -623,6 +625,9 @@ static void ocfs2_dio_end_io(struct kioc
>  	if (!level)
>  		up_read(&inode->i_alloc_sem);
>  	ocfs2_rw_unlock(inode, level);
> +
> +	if (is_async)
> +		aio_complete(iocb, ret, 0);
>  }
>  
>  /*
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 09:48:37.268012190 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2010-06-22 14:05:02.522005722 +0200
> @@ -1599,7 +1599,9 @@ xfs_end_io_direct(
>  	struct kiocb	*iocb,
>  	loff_t		offset,
>  	ssize_t		size,
> -	void		*private)
> +	void		*private,
> +	int		ret,
> +	bool		is_async)
>  {
>  	xfs_ioend_t	*ioend = iocb->private;
>  
> @@ -1645,6 +1647,9 @@ xfs_end_io_direct(
>  	 * against double-freeing.
>  	 */
>  	iocb->private = NULL;
> +
> +	if (is_async)
> +		aio_complete(iocb, ret, 0);
>  }
>  
>  STATIC ssize_t
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.h	2010-06-22 09:48:37.278274238 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.h	2010-06-22 09:49:12.388034051 +0200
> @@ -37,6 +37,8 @@ typedef struct xfs_ioend {
>  	size_t			io_size;	/* size of the extent */
>  	xfs_off_t		io_offset;	/* offset in the file */
>  	struct work_struct	io_work;	/* xfsdatad work queue */
> +	struct kiocb		*io_iocb;
> +	int			io_result;
>  } xfs_ioend_t;
>  
>  extern const struct address_space_operations xfs_address_space_operations;
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2010-06-22 09:49:07.188253984 +0200
> +++ linux-2.6/include/linux/fs.h	2010-06-22 10:34:10.128005975 +0200
> @@ -415,7 +415,8 @@ struct buffer_head;
>  typedef int (get_block_t)(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create);
>  typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
> -			ssize_t bytes, void *private);
> +			ssize_t bytes, void *private, int ret,
> +			bool is_async);
>  
>  /*
>   * Attribute flags.  These should be or-ed together to figure out what
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
