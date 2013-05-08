From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 23/29] ext4: Protect extent conversion after DIO with
 i_dio_count
Date: Wed, 8 May 2013 15:08:47 +0800
Message-ID: <20130508070847.GE20599@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-24-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50679 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3EHGvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 02:51:07 -0400
Received: by mail-pd0-f182.google.com with SMTP id 3so1009361pdj.41
        for <linux-ext4@vger.kernel.org>; Tue, 07 May 2013 23:51:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-24-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:28PM +0200, Jan Kara wrote:
> Make sure extent conversion after DIO happens while i_dio_count is still
> elevated so that inode_dio_wait() waits until extent conversion is done.
> This removes the need for explicit waiting for extent conversion in some
> cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/inode.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f8e78ce..f493ec2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2914,11 +2914,18 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  
>  	BUG_ON(iocb->private == NULL);
>  
> +	/*
> +	 * Make all waiters for direct IO properly wait also for extent
> +	 * conversion. This also disallows race between truncate() and
> +	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
> +	 */
> +	if (rw == WRITE)
> +		atomic_inc(&inode->i_dio_count);
> +
>  	/* If we do a overwrite dio, i_mutex locking can be released */
>  	overwrite = *((int *)iocb->private);
>  
>  	if (overwrite) {
> -		atomic_inc(&inode->i_dio_count);
>  		down_read(&EXT4_I(inode)->i_data_sem);
>  		mutex_unlock(&inode->i_mutex);
>  	}
> @@ -3013,9 +3020,10 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	}
>  
>  retake_lock:
> +	if (rw == WRITE)
> +		inode_dio_done(inode);
>  	/* take i_mutex locking again if we do a ovewrite dio */
>  	if (overwrite) {
> -		inode_dio_done(inode);
>  		up_read(&EXT4_I(inode)->i_data_sem);
>  		mutex_lock(&inode->i_mutex);
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
