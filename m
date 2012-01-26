From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext4: fix race between unwritten extent conversion and
 truncate
Date: Thu, 26 Jan 2012 22:15:26 +0100
Message-ID: <20120126211526.GA28368@quack.suse.cz>
References: <x49aa5ayycg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2AZVP2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 16:15:28 -0500
Content-Disposition: inline
In-Reply-To: <x49aa5ayycg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-01-12 15:59:11, Jeff Moyer wrote:
> Hi,
> 
> The following comment in ext4_end_io_dio caught my attention:
> 
> 	/* XXX: probably should move into the real I/O completion handler */
>         inode_dio_done(inode);
> 
> The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
> ext4 code path above will end up dropping the mutex before it is
> reacquired by the worker thread that does the extent conversion, it
> seems to me that the truncate can happen out of order.  Jan Kara
> mentioned that this might result in extra journal I/O, which isn't nice,
  Funny misunderstanding ;) I meant we will complain to system log with error
messages / WARN_ON.

> but that's probably the full extent of the "damage."
> 
> The fix is pretty straight-forward: don't call inode_dio_done until the
> extent conversion is complete.
  Otherwise the patch looks good so:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> CC: Jan Kara <jack@suse.cz>
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 513004f..2d55d7c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -184,6 +184,7 @@ struct mpage_da_data {
>  #define	EXT4_IO_END_UNWRITTEN	0x0001
>  #define EXT4_IO_END_ERROR	0x0002
>  #define EXT4_IO_END_QUEUED	0x0004
> +#define EXT4_IO_END_DIRECT	0x0008
>  
>  struct ext4_io_page {
>  	struct page	*p_page;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..f6dc02b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2795,9 +2795,6 @@ out:
>  
>  	/* queue the work to convert unwritten extents to written */
>  	queue_work(wq, &io_end->work);
> -
> -	/* XXX: probably should move into the real I/O completion handler */
> -	inode_dio_done(inode);
>  }
>  
>  static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
> @@ -2921,9 +2918,12 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  		iocb->private = NULL;
>  		EXT4_I(inode)->cur_aio_dio = NULL;
>  		if (!is_sync_kiocb(iocb)) {
> -			iocb->private = ext4_init_io_end(inode, GFP_NOFS);
> -			if (!iocb->private)
> +			ext4_io_end_t *io_end =
> +				ext4_init_io_end(inode, GFP_NOFS);
> +			if (!io_end)
>  				return -ENOMEM;
> +			io_end->flag |= EXT4_IO_END_DIRECT;
> +			iocb->private = io_end;
>  			/*
>  			 * we save the io structure for current async
>  			 * direct IO, so that later ext4_map_blocks()
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 4758518..9e1b8eb 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -110,6 +110,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  	if (io->iocb)
>  		aio_complete(io->iocb, io->result, 0);
>  
> +	if (io->flag & EXT4_IO_END_DIRECT)
> +		inode_dio_done(inode);
>  	/* Wake up anyone waiting on unwritten extent conversion */
>  	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
>  		wake_up_all(ext4_ioend_wq(io->inode));
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
