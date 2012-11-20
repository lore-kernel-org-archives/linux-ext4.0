From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 9/9] blkdev: Fix up AIO+DIO+O_SYNC to do the sync part
 correctly
Date: Tue, 20 Nov 2012 11:15:59 +0100
Message-ID: <20121120101559.GC1408@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120075115.25270.62451.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com,
	jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk,
	jack@suse.cz, linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2KTKQC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 05:16:02 -0500
Content-Disposition: inline
In-Reply-To: <20121120075115.25270.62451.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 19-11-12 23:51:15, Darrick J. Wong wrote:
> When performing O_SYNC+AIO+DIO writes to block devices, use the DIO_SYNC_WRITES
> flag so that flushes are issued /after/ the write completes, not before.
> 
> Note, however, that for block devices, the DIO setup code ensures that a flush
> wq is attached to the superblock of the bdevfs filesystem, not the filesystem
> that the device node happens to reside in.  This means that unlike regular
> files, iocb->ki_filp->f_mapping->host->i_sb != inode->i_sb.  Therefore, adjust
> Jeff's earlier patch to keep the pointer use consistent and avoid a NULL deref.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/block_dev.c |    5 +++--
>  fs/direct-io.c |    3 ++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 1a1e5e3..05ff33a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -235,7 +235,8 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
>  	struct inode *inode = file->f_mapping->host;
>  
>  	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
> -				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
> +				    nr_segs, blkdev_get_blocks, NULL, NULL,
> +				    DIO_SYNC_WRITES);
>  }
>  
>  int __sync_blockdev(struct block_device *bdev, int wait)
> @@ -1631,7 +1632,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	percpu_down_read(&bdev->bd_block_size_semaphore);
>  
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> -	if (ret > 0 || ret == -EIOCBQUEUED) {
> +	if (ret > 0) {
>  		ssize_t err;
>  
>  		err = generic_write_sync(file, pos, ret);
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index b7391d4..c626c43 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -258,7 +258,8 @@ void generic_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes,
>  		work->ret = ret;
>  		work->offset = offset;
>  		work->len = bytes;
> -		queue_work(inode->i_sb->s_dio_flush_wq, &work->work);
> +		queue_work(iocb->ki_filp->f_mapping->host->i_sb->s_dio_flush_wq,
> +			   &work->work);
  This should be folded into the original patch introducing the
s_dio_flush_wq. And please add a comment before this line saying that block
devices need a dereference exactly like this... Otherwise the patch looks
good so you can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
