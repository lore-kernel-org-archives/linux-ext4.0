From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: serialize truncate with owerwrite DIO workers
Date: Wed, 5 Sep 2012 17:49:20 +0200
Message-ID: <20120905154920.GF18051@quack.suse.cz>
References: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
 <1346780214-29845-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2IEPtW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Sep 2012 11:49:22 -0400
Content-Disposition: inline
In-Reply-To: <1346780214-29845-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 04-09-12 21:36:54, Dmitry Monakhov wrote:
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
  Thanks for the patch. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5a75908..9725acb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3035,6 +3035,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  		overwrite = *((int *)iocb->private);
>  
>  		if (overwrite) {
> +			atomic_inc(&inode->i_dio_count);
>  			down_read(&EXT4_I(inode)->i_data_sem);
>  			mutex_unlock(&inode->i_mutex);
>  		}
> @@ -3134,6 +3135,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  		if (overwrite) {
>  			up_read(&EXT4_I(inode)->i_data_sem);
>  			mutex_lock(&inode->i_mutex);
> +			inode_dio_done(inode);
>  		}
>  
>  		return ret;
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
