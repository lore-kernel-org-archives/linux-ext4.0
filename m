From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: drop aio_mutex after grabbing i_mutex in
 ext4_file_write()
Date: Tue, 15 Apr 2014 19:06:48 +0200
Message-ID: <20140415170648.GF10144@quack.suse.cz>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
 <1397322161-32148-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaDORGv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 13:06:51 -0400
Content-Disposition: inline
In-Reply-To: <1397322161-32148-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-04-14 13:02:39, Ted Tso wrote:
> Once we have grabbed i_mutex, this will prevent any other writes from
> proceeding, so we don't need to worry about any writes to unwritten
> regions from taking place.  So drop the aio_mutex so that if there are
> any other parallel writes happen to some other inode that happens to
> hash to the same hash table entry, we won't end up blocking that work.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/file.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 3ec0c09..5e428d58 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -98,7 +98,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct blk_plug plug;
> -	int unaligned_aio = 0;
>  	int overwrite = 0;
>  	size_t length = iov_length(iov, nr_segs);
>  	ssize_t ret;
> @@ -124,24 +123,26 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	}
>  
>  	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT)) {
> -		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> -		    !is_sync_kiocb(iocb))
> -			unaligned_aio = ext4_unaligned_aio(inode, iov,
> -							   nr_segs, pos);
> +		struct mutex *aio_mutex = NULL;
>  
>  		/* Unaligned direct AIO must be serialized; see comment above */
> -		if (unaligned_aio) {
> -			mutex_lock(ext4_aio_mutex(inode));
> +		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> +		    !is_sync_kiocb(iocb) &&
> +		    ext4_unaligned_aio(inode, iov, nr_segs, pos)) {
> +			aio_mutex = ext4_aio_mutex(inode);
> +			mutex_lock(aio_mutex);
>  			ext4_unwritten_wait(inode);
>  		}
>  
>  		mutex_lock(&inode->i_mutex);
> +		if (aio_mutex)
> +			mutex_unlock(aio_mutex);
>  		blk_start_plug(&plug);
>  
>  		iocb->private = &overwrite;
>  
>  		/* check whether we do a DIO overwrite or not */
> -		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
> +		if (ext4_should_dioread_nolock(inode) && !aio_mutex &&
>  		    !file->f_mapping->nrpages && pos + length <= i_size_read(inode)) {
>  			struct ext4_map_blocks map;
>  			unsigned int blkbits = inode->i_blkbits;
> @@ -181,9 +182,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  				ret = err;
>  		}
>  		blk_finish_plug(&plug);
> -
> -		if (unaligned_aio)
> -			mutex_unlock(ext4_aio_mutex(inode));
>  	} else {
>  		mutex_lock(&inode->i_mutex);
>  		ret = __generic_file_aio_write(iocb, iov, nr_segs,
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
