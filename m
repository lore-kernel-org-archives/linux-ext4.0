From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] ext4: inline generic_file_aio_write() into
 ext4_file_write()
Date: Tue, 15 Apr 2014 19:06:11 +0200
Message-ID: <20140415170611.GD10144@quack.suse.cz>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
 <1397322161-32148-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaDORGN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 13:06:13 -0400
Content-Disposition: inline
In-Reply-To: <1397322161-32148-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-04-14 13:02:37, Ted Tso wrote:
> Copy generic_file_aio_write() into ext4_file_write().  This is part of
> a patch series which allows us to simplify ext4_file_write() and
> ext4_file_dio_write(), by calling __generic_file_aio_write() directly.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/file.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 25a20b6..8b22556 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -113,8 +113,6 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
>  		ext4_unwritten_wait(inode);
>  	}
>  
> -	BUG_ON(iocb->ki_pos != pos);
> -
>  	mutex_lock(&inode->i_mutex);
>  	blk_start_plug(&plug);
>  
> @@ -168,9 +166,12 @@ static ssize_t
>  ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		unsigned long nr_segs, loff_t pos)
>  {
> +	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	ssize_t ret;
>  
> +	BUG_ON(iocb->ki_pos != pos);
> +
>  	/*
>  	 * If we have encountered a bitmap-format file, the size limit
>  	 * is smaller than s_maxbytes, which is for extent-mapped files.
> @@ -192,8 +193,20 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  
>  	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
>  		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
> -	else
> -		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> +	else {
> +		mutex_lock(&inode->i_mutex);
> +		ret = __generic_file_aio_write(iocb, iov, nr_segs,
> +					       &iocb->ki_pos);
> +		mutex_unlock(&inode->i_mutex);
> +
> +		if (ret > 0) {
> +			ssize_t err;
> +
> +			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> +			if (err < 0)
> +				ret = err;
> +		}
> +	}
>  
>  	return ret;
>  }
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
