From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: queue conversion after adding to inode's completed
 IO list
Date: Thu, 07 Oct 2010 12:23:56 -0500
Message-ID: <4CAE022C.7050504@redhat.com>
References: <4C5C67FD.5070208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0JGRYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Oct 2010 13:24:01 -0400
In-Reply-To: <4C5C67FD.5070208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/06/2010 02:52 PM, Eric Sandeen wrote:
> By queuing the io end on the unwritten workqueue before adding it
> to our inode's list of completed IOs, I think we run the risk
> of the work getting completed, and the IO freed, before we try
> to add it to the inode's i_completed_io_list.
> 
> It should be safe to add it to the inode's list of completed
> IOs, and -then- queue it for completion, I think.

Ping? would be good to fix this race, this has jiaying's ack too.

> Thanks to Dave Chinner for pointing out the race.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (At least I think this is right; I haven't actually demonstrated a race...)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0afc8c1..7f56c48 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3804,14 +3804,14 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  	io_end->flag = EXT4_IO_UNWRITTEN;
>  	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>  
> -	/* queue the work to convert unwritten extents to written */
> -	queue_work(wq, &io_end->work);
> -
>  	/* Add the io_end to per-inode completed aio dio list*/
>  	ei = EXT4_I(io_end->inode);
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	list_add_tail(&io_end->list, &ei->i_completed_io_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +
> +	/* queue the work to convert unwritten extents to written */
> +	queue_work(wq, &io_end->work);
>  	iocb->private = NULL;
>  out:
>  	if (is_async)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

