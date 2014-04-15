From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] ext4: add locking for O_APPEND writes
Date: Tue, 15 Apr 2014 19:05:40 +0200
Message-ID: <20140415170540.GC10144@quack.suse.cz>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
 <1397322161-32148-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaDORFn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 13:05:43 -0400
Content-Disposition: inline
In-Reply-To: <1397322161-32148-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-04-14 13:02:41, Ted Tso wrote:
> Al Viro pointed out that we need to make sure we only allow one
> O_APPEND write to proceed at a time so that the the s_bitmap_maxbytes
> check can be properly checked.
  But this introduces lock inversion between aio_mutex and i_mutex, doesn't
it?

								Honza

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/file.c | 46 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 7c8f483..c3824dd 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -98,24 +98,32 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct blk_plug plug;
> +	struct mutex *aio_mutex = NULL;
>  	int o_direct = file->f_flags & O_DIRECT;
> -	int overwrite = 0;
> +	int overwrite = 0, i_mutex_grabbed = 0;
>  	size_t length = iov_length(iov, nr_segs);
>  	ssize_t ret;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  
> +	if (file->f_flags & O_APPEND) {
> +		mutex_lock(&inode->i_mutex);
> +		i_mutex_grabbed = 1;
> +		iocb->ki_pos = pos = i_size_read(inode);
> +	}
> +
>  	/*
>  	 * If we have encountered a bitmap-format file, the size limit
>  	 * is smaller than s_maxbytes, which is for extent-mapped files.
>  	 */
> -
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
>  		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  
>  		if ((pos > sbi->s_bitmap_maxbytes ||
> -		    (pos == sbi->s_bitmap_maxbytes && length > 0)))
> -			return -EFBIG;
> +		     (pos == sbi->s_bitmap_maxbytes && length > 0))) {
> +			ret = -EFBIG;
> +			goto errout;
> +		}
>  
>  		if (pos + length > sbi->s_bitmap_maxbytes) {
>  			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
> @@ -123,19 +131,20 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		}
>  	}
>  
> -	if (o_direct) {
> -		struct mutex *aio_mutex = NULL;
> -
> -		/* Unaligned direct AIO must be serialized; see comment above */
> -		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> -		    !is_sync_kiocb(iocb) &&
> -		    ext4_unaligned_aio(inode, iov, nr_segs, pos)) {
> -			aio_mutex = ext4_aio_mutex(inode);
> -			mutex_lock(aio_mutex);
> -			ext4_unwritten_wait(inode);
> -		}
> +	/* Unaligned direct AIO must be serialized; see comment above */
> +	if (o_direct && ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> +	    !is_sync_kiocb(iocb) &&
> +	    ext4_unaligned_aio(inode, iov, nr_segs, pos)) {
> +		aio_mutex = ext4_aio_mutex(inode);
> +		mutex_lock(aio_mutex);
> +		ext4_unwritten_wait(inode);
> +	}
>  
> +	if (!i_mutex_grabbed)
>  		mutex_lock(&inode->i_mutex);
> +	i_mutex_grabbed = 1;
> +
> +	if (o_direct) {
>  		if (aio_mutex)
>  			mutex_unlock(aio_mutex);
>  		blk_start_plug(&plug);
> @@ -170,11 +179,11 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  			if (err == len && (map.m_flags & EXT4_MAP_MAPPED))
>  				overwrite = 1;
>  		}
> -	} else
> -		mutex_lock(&inode->i_mutex);
> +	}
>  
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	mutex_unlock(&inode->i_mutex);
> +	i_mutex_grabbed = 0;
>  
>  	if (ret > 0) {
>  		ssize_t err;
> @@ -186,6 +195,9 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	if (o_direct)
>  		blk_finish_plug(&plug);
>  
> +errout:
> +	if (i_mutex_grabbed)
> +		mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
>  
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
