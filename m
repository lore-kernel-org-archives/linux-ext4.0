From: Jan Kara <jack@suse.cz>
Subject: Re: [patch|rfc] ext4: fix race between unwritten extent conversion
 and truncate
Date: Thu, 26 Jan 2012 18:02:09 +0100
Message-ID: <20120126170209.GE17113@quack.suse.cz>
References: <x491uqno6qv.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab2AZRCL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 12:02:11 -0500
Content-Disposition: inline
In-Reply-To: <x491uqno6qv.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Wed 25-01-12 15:40:56, Jeff Moyer wrote:
> The following comment in ext4_end_io_dio caught my attention:
> 
> 	/* XXX: probably should move into the real I/O completion handler */
>         inode_dio_done(inode);
> 
> The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
> ext4 code path above will end up dropping the mutex before it is
> reacquired by the worker thread that does the extent conversion, it
> seems to me that the truncate can happen out of order.  Does it matter?
> I really don't know, but I'm hoping someone here might.  ;-)  Anyway,
> here's a patch I cooked up to address the issue.  I'm not sure what the
> result of a race would even be, so I haven't really been able to test
> that it works as intended.
> 
> So, comments?
  Yeah, the race looks real. We won't probably crash but we will certainly
curse into the logs which isn't nice ;). Thanks for spotting this.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 513004f..fc2a373 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2286,7 +2286,7 @@ extern void ext4_exit_pageio(void);
>  extern void ext4_ioend_wait(struct inode *);
>  extern void ext4_free_io_end(ext4_io_end_t *io);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> -extern int ext4_end_io_nolock(ext4_io_end_t *io);
> +extern int ext4_end_io_nolock(ext4_io_end_t *io, bool direct);
>  extern void ext4_io_submit(struct ext4_io_submit *io);
>  extern int ext4_bio_write_page(struct ext4_io_submit *io,
>  			       struct page *page,
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 00a2cb7..f9aec9a 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -104,7 +104,7 @@ int ext4_flush_completed_IO(struct inode *inode)
>  		 * queue work.
>  		 */
>  		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -		ret = ext4_end_io_nolock(io);
> +		ret = ext4_end_io_nolock(io, false);
  This is wrong. i_completed_io_list contains work items for both direct
and buffered IO. Just in ext4_flush_completed_IO() we process the list
synchronously while ext4_end_io_work() processes the list in the
background. So what you have to do is store in ext4_io_end_t whether the IO
was direct or not and then use that in ext4_end_io_nolock() function.

>  		if (ret < 0)
>  			ret2 = ret;
>  		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..4e76c30 100644
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
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 4758518..47c4a03 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -87,7 +87,7 @@ void ext4_free_io_end(ext4_io_end_t *io)
>   * Called with inode->i_mutex; we depend on this when we manipulate
>   * io->flag, since we could otherwise race with ext4_flush_completed_IO()
>   */
> -int ext4_end_io_nolock(ext4_io_end_t *io)
> +int ext4_end_io_nolock(ext4_io_end_t *io, bool direct)
>  {
>  	struct inode *inode = io->inode;
>  	loff_t offset = io->offset;
> @@ -110,6 +110,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  	if (io->iocb)
>  		aio_complete(io->iocb, io->result, 0);
>  
> +	if (direct)
> +		inode_dio_done(inode);
>  	/* Wake up anyone waiting on unwritten extent conversion */
>  	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
>  		wake_up_all(ext4_ioend_wq(io->inode));
> @@ -152,7 +154,7 @@ static void ext4_end_io_work(struct work_struct *work)
>  	}
>  	list_del_init(&io->list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -	(void) ext4_end_io_nolock(io);
> +	(void) ext4_end_io_nolock(io, true);
>  	mutex_unlock(&inode->i_mutex);
>  free:
>  	ext4_free_io_end(io);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
