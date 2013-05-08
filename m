From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 28/29] ext4: Don't wait for extent conversion in
 ext4_ext_punch_hole()
Date: Wed, 8 May 2013 15:56:34 +0800
Message-ID: <20130508075634.GB6045@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-29-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:46570 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3EHHiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 03:38:52 -0400
Received: by mail-da0-f53.google.com with SMTP id o9so815012dan.26
        for <linux-ext4@vger.kernel.org>; Wed, 08 May 2013 00:38:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-29-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:33PM +0200, Jan Kara wrote:
> We don't have to wait for extent conversion in ext4_ext_punch_hole() as
> buffered IO for the punched range has been flushed and waited upon (thus
> all extent conversions for that range have completed). Also we wait for
> all DIO to finish using inode_dio_wait() so there cannot be any extent
> conversions pending due to direct IO.
> 
> Also remove ext4_flush_unwritten_io() since it's unused now.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Need to be rebased.  Otherwise the patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h    |    1 -
>  fs/ext4/extents.c |    3 ---
>  fs/ext4/page-io.c |   16 ----------------
>  3 files changed, 0 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2b0dd9a..859f235 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1986,7 +1986,6 @@ static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
>  
>  /* fsync.c */
>  extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
> -extern int ext4_flush_unwritten_io(struct inode *);
>  
>  /* hash.c */
>  extern int ext4fs_dirhash(const char *name, int len, struct
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ca4ff71..96c4855 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4697,9 +4697,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  
>  	/* Wait all existing dio workers, newcomers will block on i_mutex */
>  	ext4_inode_block_unlocked_dio(inode);
> -	err = ext4_flush_unwritten_io(inode);
> -	if (err)
> -		goto out_dio;
>  	inode_dio_wait(inode);
>  
>  	credits = ext4_writepage_trans_blocks(inode);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 2f0b943..1156b9f 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -268,22 +268,6 @@ void ext4_end_io_unrsv_work(struct work_struct *work)
>  	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_unrsv_conversion_list);
>  }
>  
> -int ext4_flush_unwritten_io(struct inode *inode)
> -{
> -	int ret, err;
> -
> -	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
> -		     !(inode->i_state & I_FREEING));
> -	ret = ext4_do_flush_completed_IO(inode,
> -					 &EXT4_I(inode)->i_rsv_conversion_list);
> -	err = ext4_do_flush_completed_IO(inode,
> -					 &EXT4_I(inode)->i_unrsv_conversion_list);
> -	if (!ret)
> -		ret = err;
> -	ext4_unwritten_wait(inode);
> -	return ret;
> -}
> -
>  ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
>  {
>  	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
