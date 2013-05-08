From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 27/29] ext4: Remove wait for unwritten extents in
 ext4_ind_direct_IO()
Date: Wed, 8 May 2013 15:55:53 +0800
Message-ID: <20130508075553.GA6045@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-28-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64162 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3EHHiM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 03:38:12 -0400
Received: by mail-pd0-f175.google.com with SMTP id y14so1042659pdi.34
        for <linux-ext4@vger.kernel.org>; Wed, 08 May 2013 00:38:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-28-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:32PM +0200, Jan Kara wrote:
> We don't have to wait for unwritten extent conversion in
> ext4_ind_direct_IO() as all writes that happened before DIO are flushed
> by the generic code and extent conversion has happened before we cleared
> PageWriteback bit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/indirect.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 197b202..d1c6be4 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -809,11 +809,6 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
> -			mutex_lock(&inode->i_mutex);
> -			ext4_flush_unwritten_io(inode);
> -			mutex_unlock(&inode->i_mutex);
> -		}
>  		/*
>  		 * Nolock dioread optimization may be dynamically disabled
>  		 * via ext4_inode_block_unlocked_dio(). Check inode's state
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
