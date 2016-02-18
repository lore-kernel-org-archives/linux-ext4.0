From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Thu, 18 Feb 2016 22:30:06 +0100
Message-ID: <20160218213006.GG4338@quack.suse.cz>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146AbcBRV3o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2016 16:29:44 -0500
Content-Disposition: inline
In-Reply-To: <20160218060148.GA10571@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-02-16 22:01:48, Christoph Hellwig wrote:
> Might help to tell that this is on top of a direct-io.c patch from the
> XFS tree.
> 
> I don't think clearing any flags is the right thing - now that we
> always call ->end_io the code dealing with it in ext4_ext_direct_IO
> can simply be moved to the ->end_io handler.
> 
> Something like the untested patch below:

Yeah, this looks good to me.

								Honza
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9db04dd..b741c79 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3166,23 +3166,25 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  {
>          ext4_io_end_t *io_end = iocb->private;
>  
> -	if (size <= 0)
> -		return 0;
> -
>  	/* if not async direct IO just return */
>  	if (!io_end)
>  		return 0;
>  
> +	if (size <= 0) {
> +		WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> +		goto out;
> +	}
> +
>  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
>  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
>   		  iocb->private, io_end->inode->i_ino, iocb, offset,
>  		  size);
>  
> -	iocb->private = NULL;
>  	io_end->offset = offset;
>  	io_end->size = size;
> +out:
>  	ext4_put_io_end(io_end);
> -
> +	iocb->private = NULL;
>  	return 0;
>  }
>  
> @@ -3306,16 +3308,6 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
>  	if (io_end) {
>  		ext4_inode_aio_set(inode, NULL);
>  		ext4_put_io_end(io_end);
> -		/*
> -		 * When no IO was submitted ext4_end_io_dio() was not
> -		 * called so we have to put iocb's reference.
> -		 */
> -		if (ret <= 0 && ret != -EIOCBQUEUED && iocb->private) {
> -			WARN_ON(iocb->private != io_end);
> -			WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> -			ext4_put_io_end(io_end);
> -			iocb->private = NULL;
> -		}
>  	}
>  	if (ret > 0 && !overwrite && ext4_test_inode_state(inode,
>  						EXT4_STATE_DIO_UNWRITTEN)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
