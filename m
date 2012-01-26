From: Jan Kara <jack@suse.cz>
Subject: Re: [patch|rfc] ext4: fix race between unwritten extent conversion
 and truncate
Date: Thu, 26 Jan 2012 21:10:56 +0100
Message-ID: <20120126201056.GA27283@quack.suse.cz>
References: <x491uqno6qv.fsf@segfault.boston.devel.redhat.com>
 <20120126170209.GE17113@quack.suse.cz>
 <x49liouz6ft.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab2AZUK6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 15:10:58 -0500
Content-Disposition: inline
In-Reply-To: <x49liouz6ft.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-01-12 13:04:22, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> --- a/fs/ext4/fsync.c
> >> +++ b/fs/ext4/fsync.c
> >> @@ -104,7 +104,7 @@ int ext4_flush_completed_IO(struct inode *inode)
> >>  		 * queue work.
> >>  		 */
> >>  		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> >> -		ret = ext4_end_io_nolock(io);
> >> +		ret = ext4_end_io_nolock(io, false);
> >   This is wrong. i_completed_io_list contains work items for both direct
> > and buffered IO. Just in ext4_flush_completed_IO() we process the list
> > synchronously while ext4_end_io_work() processes the list in the
> > background. So what you have to do is store in ext4_io_end_t whether the IO
> > was direct or not and then use that in ext4_end_io_nolock() function.
> 
> OK, thanks for the review.  Is the following what you had in mind?  If
> so, I'll repost with a proper header.
  Exactly. Thanks!

								Honza
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
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
