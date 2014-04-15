From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4: factor out common code in ext4_file_write()
Date: Tue, 15 Apr 2014 19:07:10 +0200
Message-ID: <20140415170710.GG10144@quack.suse.cz>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
 <1397322161-32148-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaDORHN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 13:07:13 -0400
Content-Disposition: inline
In-Reply-To: <1397322161-32148-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-04-14 13:02:40, Ted Tso wrote:
> This shouldn't change any logic flow; just delete duplicated code.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 37 +++++++++++++------------------------
>  1 file changed, 13 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 5e428d58..7c8f483 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -98,6 +98,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct blk_plug plug;
> +	int o_direct = file->f_flags & O_DIRECT;
>  	int overwrite = 0;
>  	size_t length = iov_length(iov, nr_segs);
>  	ssize_t ret;
> @@ -122,7 +123,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		}
>  	}
>  
> -	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT)) {
> +	if (o_direct) {
>  		struct mutex *aio_mutex = NULL;
>  
>  		/* Unaligned direct AIO must be serialized; see comment above */
> @@ -169,33 +170,21 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  			if (err == len && (map.m_flags & EXT4_MAP_MAPPED))
>  				overwrite = 1;
>  		}
> -
> -		ret = __generic_file_aio_write(iocb, iov, nr_segs,
> -					       &iocb->ki_pos);
> -		mutex_unlock(&inode->i_mutex);
> -
> -		if (ret > 0) {
> -			ssize_t err;
> -
> -			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -			if (err < 0)
> -				ret = err;
> -		}
> -		blk_finish_plug(&plug);
> -	} else {
> +	} else
>  		mutex_lock(&inode->i_mutex);
> -		ret = __generic_file_aio_write(iocb, iov, nr_segs,
> -					       &iocb->ki_pos);
> -		mutex_unlock(&inode->i_mutex);
>  
> -		if (ret > 0) {
> -			ssize_t err;
> +	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
> +	mutex_unlock(&inode->i_mutex);
>  
> -			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -			if (err < 0)
> -				ret = err;
> -		}
> +	if (ret > 0) {
> +		ssize_t err;
> +
> +		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> +		if (err < 0)
> +			ret = err;
>  	}
> +	if (o_direct)
> +		blk_finish_plug(&plug);
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
