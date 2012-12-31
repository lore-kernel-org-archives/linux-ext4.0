From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 8/9 v1] ext4: refine unwritten extent conversion
Date: Mon, 31 Dec 2012 22:58:15 +0100
Message-ID: <20121231215815.GM7564@quack.suse.cz>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-9-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2LaV6S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 16:58:18 -0500
Content-Disposition: inline
In-Reply-To: <1356335742-11793-9-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-12-12 15:55:41, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently all unwritten extent conversion work is pushed into a workqueue to be
> done because DIO end_io is in a irq context and this conversion needs to take
> i_data_sem locking.  But we couldn't take a semaphore in a irq context.  After
> tracking all extent status, we can first convert this unwritten extent in extent
> status tree, and call aio_complete() and inode_dio_done() to notify upper level
> that this dio has done.  We don't need to be worried about exposing a stale data
> because we first try to lookup in extent status tree.  So it makes us to see the
> latest extent status.  Meanwhile we queue a work to convert this unwritten
> extent in extent tree.  After this improvement, reader also needn't wait this
> conversion to be done when dioread_nolock is enabled.
> 
> CC: Jan Kara <jack@suse.cz>
> CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> CC: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
  OK, so after reading other patches this should work fine. Just I think we
should somehow mark in the extent status tree that the extent tree is
inconsistent with what's on disk - something like extent dirty bit. It will
be set for UNWRITTEN extents where conversion is pending logically it would
also make sence to have it set for DELAYED extents. Then if we need to
reclaim some extents due to memory pressure we know we have to keep dirty
extents because those cache irreplacible information. What do you think?

								Honza
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8462eb3..b76dc49 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -195,7 +195,6 @@ struct mpage_da_data {
>  #define	EXT4_IO_END_UNWRITTEN	0x0001
>  #define EXT4_IO_END_ERROR	0x0002
>  #define EXT4_IO_END_QUEUED	0x0004
> -#define EXT4_IO_END_DIRECT	0x0008
>  
>  struct ext4_io_page {
>  	struct page	*p_page;
> @@ -2538,6 +2537,7 @@ extern void ext4_ioend_wait(struct inode *);
>  extern void ext4_free_io_end(ext4_io_end_t *io);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>  extern void ext4_io_submit(struct ext4_io_submit *io);
> +extern void ext4_end_io_bh(ext4_io_end_t *io_end, int is_dio);
>  extern int ext4_bio_write_page(struct ext4_io_submit *io,
>  			       struct page *page,
>  			       int len,
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 20862f9..c6d7f7f 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -807,11 +807,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
> -			mutex_lock(&inode->i_mutex);
> -			ext4_flush_unwritten_io(inode);
> -			mutex_unlock(&inode->i_mutex);
> -		}
>  		/*
>  		 * Nolock dioread optimization may be dynamically disabled
>  		 * via ext4_inode_block_unlocked_dio(). Check inode's state
> @@ -831,8 +826,10 @@ retry:
>  		inode_dio_done(inode);
>  	} else {
>  locked:
> -		ret = blockdev_direct_IO(rw, iocb, inode, iov,
> -				 offset, nr_segs, ext4_get_block);
> +		ret = __blockdev_direct_IO(rw, iocb, inode,
> +				 inode->i_sb->s_bdev, iov,
> +				 offset, nr_segs,
> +				 ext4_get_block, NULL, NULL, DIO_LOCKING);
>  
>  		if (unlikely((rw & WRITE) && ret < 0)) {
>  			loff_t isize = i_size_read(inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6610dc7..4549103 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3024,9 +3024,8 @@ static int ext4_get_block_write_nolock(struct inode *inode, sector_t iblock,
>  			       EXT4_GET_BLOCKS_NO_LOCK);
>  }
>  
> -static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> -			    ssize_t size, void *private, int ret,
> -			    bool is_async)
> +static void ext4_end_dio(struct kiocb *iocb, loff_t offset, ssize_t size,
> +			 void *private, int ret, bool is_async)
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>          ext4_io_end_t *io_end = iocb->private;
> @@ -3058,8 +3057,7 @@ out:
>  		io_end->iocb = iocb;
>  		io_end->result = ret;
>  	}
> -
> -	ext4_add_complete_io(io_end);
> +	ext4_end_io_bh(io_end, 1);
>  }
>  
>  static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
> @@ -3195,7 +3193,6 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  			ret = -ENOMEM;
>  			goto retake_lock;
>  		}
> -		io_end->flag |= EXT4_IO_END_DIRECT;
>  		iocb->private = io_end;
>  		/*
>  		 * we save the io structure for current async direct
> @@ -3216,7 +3213,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  				   inode->i_sb->s_bdev, iov,
>  				   offset, nr_segs,
>  				   get_block_func,
> -				   ext4_end_io_dio,
> +				   ext4_end_dio,
>  				   NULL,
>  				   dio_flags);
>  
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0016fbc..6b2d88d 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -103,17 +103,35 @@ static int ext4_end_io(ext4_io_end_t *io)
>  			 "(inode %lu, offset %llu, size %zd, error %d)",
>  			 inode->i_ino, offset, size, ret);
>  	}
> -	if (io->iocb)
> -		aio_complete(io->iocb, io->result, 0);
>  
> -	if (io->flag & EXT4_IO_END_DIRECT)
> -		inode_dio_done(inode);
>  	/* Wake up anyone waiting on unwritten extent conversion */
>  	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
>  		wake_up_all(ext4_ioend_wq(inode));
> +
>  	return ret;
>  }
>  
> +void ext4_end_io_bh(ext4_io_end_t *io_end, int is_dio)
> +{
> +	struct inode *inode;
> +
> +	inode = io_end->inode;
> +	(void)ext4_es_convert_unwritten_extents(inode, io_end->offset,
> +						io_end->size);
> +	ext4_add_complete_io(io_end);
> +
> +	/*
> +	 * Here we can safely notify upper level that aio has done because
> +	 * unwritten extent in extent status tree has been converted.  Thus,
> +	 * others won't get a stale data because we always lookup extent status
> +	 * tree firstly in get_block_t.
> +	 */
> +	if (io_end->iocb)
> +		aio_complete(io_end->iocb, io_end->result, 0);
> +	if (is_dio)
> +		inode_dio_done(inode);
> +}
> +
>  static void dump_completed_IO(struct inode *inode)
>  {
>  #ifdef	EXT4FS_DEBUG
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
