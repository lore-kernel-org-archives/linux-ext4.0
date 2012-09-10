From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] ext4: completed_io locking cleanup
Date: Mon, 10 Sep 2012 11:23:12 +0200
Message-ID: <20120910092312.GD22903@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2IJJXQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 05:23:16 -0400
Content-Disposition: inline
In-Reply-To: <1347211634-11509-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 09-09-12 21:27:09, Dmitry Monakhov wrote:
> Current unwritten extent conversion state-machine is very fuzzy.
> - By unknown reason it want perform conversion under i_mutex. What for?
>   All this games with mutex_trylock result in following deadlock
>    truncate:                          kworker:
>     ext4_setattr                       ext4_end_io_work
>     mutex_lock(i_mutex)
>     inode_dio_wait(inode)  ->BLOCK
>                              DEADLOCK<- mutex_trylock()
>                                         inode_dio_done()
>   #TEST_CASE1_BEGIN
>   MNT=/mnt_scrach
>   unlink $MNT/file
>   fallocate -l $((1024*1024*1024)) $MNT/file
>   aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file
>   sleep 2
>   truncate -s 0 $MNT/file
>   #TEST_CASE1_END
> 
> This patch makes state machine simple and clean:
> 
> (1) ext4_flush_completed_IO is responsible for handling all pending
>     end_io from ei->i_completed_io_list(per inode list)
>     NOTE1: i_completed_io_lock is acquired only once
>     NOTE2: i_mutex is not required because it does not protect
>            any data guarded by i_mutex
  Removing of i_mutex might be OK but you really need to add more
justification (both into the changelog and end_io code) than just "it does
not protect any data guarded by i_mutex". So far i_mutex is supposed to
protect all modifications of extent tree, now that won't be true anymore.
We have i_data_sem protecting extent tree as well but that is acquired for
single extent operation only so it cannot be used for guarding "global
properties of the extent tree" - e.g. if end_io code would race with
truncate it could happen that end_io would create some extents beyond EOF.
Now maybe that cannot happen because of other synchronization mechanisms
(e.g. inode_dio_wait(), or waiting for PageWriteback while invalidating
page cache - although extra care needs to be taken when extents straddle
i_size and there can be IO running on the part of the extent before
i_size). So I don't immediaetly see a problem but please add more
justification to convince me (and future readers of the code) here...

								Honza

> 
> (2) xxx_end_io schedule end_io context completion simply by pushing it
>     to the inode's list.
>     NOTE1: because of (1) work should be queued only if
>     ->i_completed_io_list was empty at the moment, otherwise it
>     work is scheduled already.
> 
> - remove useless END_IO_XXX flags
> - Improve smp scalability by removing useless i_mutex which does not
>   protect anything
> - Reduce lock contention on i_completed_io_lock
> - Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h     |    5 +--
>  fs/ext4/fsync.c    |   47 +++++++++++---------------------
>  fs/ext4/indirect.c |    6 +---
>  fs/ext4/inode.c    |   25 +---------------
>  fs/ext4/page-io.c  |   76 ++++++++++++++-------------------------------------
>  5 files changed, 43 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b3f3c55..be976ca 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -184,9 +184,7 @@ struct mpage_da_data {
>   */
>  #define	EXT4_IO_END_UNWRITTEN	0x0001
>  #define EXT4_IO_END_ERROR	0x0002
> -#define EXT4_IO_END_QUEUED	0x0004
> -#define EXT4_IO_END_DIRECT	0x0008
> -#define EXT4_IO_END_IN_FSYNC	0x0010
> +#define EXT4_IO_END_DIRECT	0x0004
>  
>  struct ext4_io_page {
>  	struct page	*p_page;
> @@ -2405,6 +2403,7 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  
>  /* page-io.c */
>  extern int __init ext4_init_pageio(void);
> +extern void ext4_add_complete_io(ext4_io_end_t *io_end);
>  extern void ext4_exit_pageio(void);
>  extern void ext4_ioend_wait(struct inode *);
>  extern void ext4_free_io_end(ext4_io_end_t *io);
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 323eb15..24f3719 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -73,46 +73,31 @@ static void dump_completed_IO(struct inode * inode)
>   * might needs to do the conversion. This function walks through
>   * the list and convert the related unwritten extents for completed IO
>   * to written.
> - * The function return the number of pending IOs on success.
> + * The function return first error;
>   */
>  int ext4_flush_completed_IO(struct inode *inode)
>  {
> +	struct ext4_inode_info	*ei = EXT4_I(inode);
> +	unsigned long		flags;
> +	struct list_head complete_list;
> +	int err, ret = 0;
>  	ext4_io_end_t *io;
> -	struct ext4_inode_info *ei = EXT4_I(inode);
> -	unsigned long flags;
> -	int ret = 0;
> -	int ret2 = 0;
>  
>  	dump_completed_IO(inode);
> +
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> -	while (!list_empty(&ei->i_completed_io_list)){
> -		io = list_entry(ei->i_completed_io_list.next,
> -				ext4_io_end_t, list);
> +	list_replace_init(&ei->i_completed_io_list, &complete_list);
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +
> +	while(!list_empty(&complete_list)) {
> +		io = list_entry(complete_list.next, ext4_io_end_t, list);
>  		list_del_init(&io->list);
> -		io->flag |= EXT4_IO_END_IN_FSYNC;
> -		/*
> -		 * Calling ext4_end_io_nolock() to convert completed
> -		 * IO to written.
> -		 *
> -		 * When ext4_sync_file() is called, run_queue() may already
> -		 * about to flush the work corresponding to this io structure.
> -		 * It will be upset if it founds the io structure related
> -		 * to the work-to-be schedule is freed.
> -		 *
> -		 * Thus we need to keep the io structure still valid here after
> -		 * conversion finished. The io structure has a flag to
> -		 * avoid double converting from both fsync and background work
> -		 * queue work.
> -		 */
> -		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -		ret = ext4_end_io_nolock(io);
> -		if (ret < 0)
> -			ret2 = ret;
> -		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> -		io->flag &= ~EXT4_IO_END_IN_FSYNC;
> +	        err = ext4_end_io_nolock(io);
> +		ext4_free_io_end(io);
> +		if (unlikely(err && !ret))
> +			ret = err;
>  	}
> -	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -	return (ret2 < 0) ? ret2 : 0;
> +	return ret;
>  }
>  
>  /*
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 830e1b2..61f13e5 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -807,11 +807,9 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
> -			mutex_lock(&inode->i_mutex);
> +		if (unlikely(!list_empty(&ei->i_completed_io_list)))
>  			ext4_flush_completed_IO(inode);
> -			mutex_unlock(&inode->i_mutex);
> -		}
> +
>  		ret = __blockdev_direct_IO(rw, iocb, inode,
>  				 inode->i_sb->s_bdev, iov,
>  				 offset, nr_segs,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 202ae3f..762b955 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2885,9 +2885,6 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>          ext4_io_end_t *io_end = iocb->private;
> -	struct workqueue_struct *wq;
> -	unsigned long flags;
> -	struct ext4_inode_info *ei;
>  
>  	/* if not async direct IO or dio with 0 bytes write, just return */
>  	if (!io_end || !size)
> @@ -2916,24 +2913,14 @@ out:
>  		io_end->iocb = iocb;
>  		io_end->result = ret;
>  	}
> -	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> -
> -	/* Add the io_end to per-inode completed aio dio list*/
> -	ei = EXT4_I(io_end->inode);
> -	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> -	list_add_tail(&io_end->list, &ei->i_completed_io_list);
> -	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  
> -	/* queue the work to convert unwritten extents to written */
> -	queue_work(wq, &io_end->work);
> +	ext4_add_complete_io(io_end);
>  }
>  
>  static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
>  {
>  	ext4_io_end_t *io_end = bh->b_private;
> -	struct workqueue_struct *wq;
>  	struct inode *inode;
> -	unsigned long flags;
>  
>  	if (!test_clear_buffer_uninit(bh) || !io_end)
>  		goto out;
> @@ -2952,15 +2939,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
>  	 */
>  	inode = io_end->inode;
>  	ext4_set_io_unwritten_flag(inode, io_end);
> -
> -	/* Add the io_end to per-inode completed io list*/
> -	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> -	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
> -	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
> -
> -	wq = EXT4_SB(inode->i_sb)->dio_unwritten_wq;
> -	/* queue the work to convert unwritten extents to written */
> -	queue_work(wq, &io_end->work);
> +	ext4_add_complete_io(io_end);
>  out:
>  	bh->b_private = NULL;
>  	bh->b_end_io = NULL;
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index dcdeef1..c369419 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -57,6 +57,22 @@ void ext4_ioend_wait(struct inode *inode)
>  	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
>  }
>  
> +/* Add the io_end to per-inode completed aio dio list. */
> +void ext4_add_complete_io(ext4_io_end_t *io_end)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
> +	struct workqueue_struct *wq;
> +	unsigned long flags;
> +
> +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> +
> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> +	if (list_empty(&ei->i_completed_io_list))
> +		queue_work(wq, &io_end->work);
> +	list_add_tail(&io_end->list, &ei->i_completed_io_list);
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +}
> +
>  static void put_io_page(struct ext4_io_page *io_page)
>  {
>  	if (atomic_dec_and_test(&io_page->p_count)) {
> @@ -81,12 +97,7 @@ void ext4_free_io_end(ext4_io_end_t *io)
>  	kmem_cache_free(io_end_cachep, io);
>  }
>  
> -/*
> - * check a range of space and convert unwritten extents to written.
> - *
> - * Called with inode->i_mutex; we depend on this when we manipulate
> - * io->flag, since we could otherwise race with ext4_flush_completed_IO()
> - */
> +/* check a range of space and convert unwritten extents to written. */
>  int ext4_end_io_nolock(ext4_io_end_t *io)
>  {
>  	struct inode *inode = io->inode;
> @@ -94,6 +105,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  	ssize_t size = io->size;
>  	int ret = 0;
>  
> +	BUG_ON(!list_empty(&io->list));
> +
>  	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
>  		   "list->prev 0x%p\n",
>  		   io, inode->i_ino, io->list.next, io->list.prev);
> @@ -124,45 +137,7 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
>  static void ext4_end_io_work(struct work_struct *work)
>  {
>  	ext4_io_end_t		*io = container_of(work, ext4_io_end_t, work);
> -	struct inode		*inode = io->inode;
> -	struct ext4_inode_info	*ei = EXT4_I(inode);
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> -	if (io->flag & EXT4_IO_END_IN_FSYNC)
> -		goto requeue;
> -	if (list_empty(&io->list)) {
> -		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -		goto free;
> -	}
> -
> -	if (!mutex_trylock(&inode->i_mutex)) {
> -		bool was_queued;
> -requeue:
> -		was_queued = !!(io->flag & EXT4_IO_END_QUEUED);
> -		io->flag |= EXT4_IO_END_QUEUED;
> -		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -		/*
> -		 * Requeue the work instead of waiting so that the work
> -		 * items queued after this can be processed.
> -		 */
> -		queue_work(EXT4_SB(inode->i_sb)->dio_unwritten_wq, &io->work);
> -		/*
> -		 * To prevent the ext4-dio-unwritten thread from keeping
> -		 * requeueing end_io requests and occupying cpu for too long,
> -		 * yield the cpu if it sees an end_io request that has already
> -		 * been requeued.
> -		 */
> -		if (was_queued)
> -			yield();
> -		return;
> -	}
> -	list_del_init(&io->list);
> -	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> -	(void) ext4_end_io_nolock(io);
> -	mutex_unlock(&inode->i_mutex);
> -free:
> -	ext4_free_io_end(io);
> +	(void) ext4_flush_completed_IO(io->inode);
>  }
>  
>  ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
> @@ -195,9 +170,7 @@ static void buffer_io_error(struct buffer_head *bh)
>  static void ext4_end_bio(struct bio *bio, int error)
>  {
>  	ext4_io_end_t *io_end = bio->bi_private;
> -	struct workqueue_struct *wq;
>  	struct inode *inode;
> -	unsigned long flags;
>  	int i;
>  	sector_t bi_sector = bio->bi_sector;
>  
> @@ -255,14 +228,7 @@ static void ext4_end_bio(struct bio *bio, int error)
>  		return;
>  	}
>  
> -	/* Add the io_end to per-inode completed io list*/
> -	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> -	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
> -	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
> -
> -	wq = EXT4_SB(inode->i_sb)->dio_unwritten_wq;
> -	/* queue the work to convert unwritten extents to written */
> -	queue_work(wq, &io_end->work);
> +	ext4_add_complete_io(io_end);
>  }
>  
>  void ext4_io_submit(struct ext4_io_submit *io)
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
