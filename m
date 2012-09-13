From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 7/7] ext4: serialize truncate with owerwrite DIO workers
 V2
Date: Thu, 13 Sep 2012 18:37:22 +0800
Message-ID: <20120913103722.GA11330@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-8-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39836 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2IMK06 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 06:26:58 -0400
Received: by dady13 with SMTP id y13so1615522dad.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 03:26:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347211634-11509-8-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 09, 2012 at 09:27:14PM +0400, Dmitry Monakhov wrote:
> Jan Kara have spotted interesting issue:
> There are  potential data corruption issue with  direct IO overwrites
> racing with truncate:
>  Like:
>   dio write                      truncate_task
>   ->ext4_ext_direct_IO
>    ->overwrite == 1
>     ->down_read(&EXT4_I(inode)->i_data_sem);
>     ->mutex_unlock(&inode->i_mutex);
>                                ->ext4_setattr()
>                                 ->inode_dio_wait()
>                                 ->truncate_setsize()
>                                 ->ext4_truncate()
>                                  ->down_write(&EXT4_I(inode)->i_data_sem);
>     ->__blockdev_direct_IO
>      ->ext4_get_block
>      ->submit_io()
>     ->up_read(&EXT4_I(inode)->i_data_sem);
>                                  # truncate data blocks, allocate them to
>                                  # other inode - bad stuff happens because
>                                  # dio is still in flight.
> 
> In order to serialize with truncate dio worker should grab extra i_dio_count
> reference before drop i_mutex.
> 
> Changes agains V1:
> - wake up dio waiters before i_mutex.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Hi Dmitry,

Indeed there is a data corruption.  This patch looks good to me.  You
can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
Zheng

> ---
>  fs/ext4/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a850026..c5c4f9d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3014,6 +3014,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  		overwrite = *((int *)iocb->private);
>  
>  		if (overwrite) {
> +			atomic_inc(&inode->i_dio_count);
>  			down_read(&EXT4_I(inode)->i_data_sem);
>  			mutex_unlock(&inode->i_mutex);
>  		}
> @@ -3111,6 +3112,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  	retake_lock:
>  		/* take i_mutex locking again if we do a ovewrite dio */
>  		if (overwrite) {
> +			inode_dio_done(inode);
>  			up_read(&EXT4_I(inode)->i_data_sem);
>  			mutex_lock(&inode->i_mutex);
>  		}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
