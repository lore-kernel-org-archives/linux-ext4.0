From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/9] ext4: completed_io locking cleanup V2
Date: Thu, 20 Sep 2012 22:56:21 +0400
Message-ID: <877groed62.fsf@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org> <1347548474-31897-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41094 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2ITS4Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2012 14:56:25 -0400
Received: by lbbgj3 with SMTP id gj3so2838695lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 11:56:23 -0700 (PDT)
In-Reply-To: <1347548474-31897-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Sep 2012 19:01:07 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Current unwritten extent conversion state-machine is very fuzzy.
> - By unknown reason it want perform conversion under i_mutex. What for?
>   The only reason it used here is just protect io->flags modification,
>   but only flush_completed_IO and work modified this flags and
>   we can serialize them via i_completed_io_lock.
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
> 
> (2) xxx_end_io schedule end_io context completion simply by pushing it
>     to the inode's list.
>     NOTE1: because of (1) work should be queued only if
>     ->i_completed_io_list was empty at the moment, otherwise it
>     work is scheduled already.
> 
> (3) No one is able to free inode's blocks while pented io_completion
>     exist othervise may result in blocks beyond EOF.
> 
> - remove useless EXT4_IO_END_QUEUED and EXT4_IO_END_FSYNC flags
> - Improve SMP scalability by removing useless i_mutex which does not
>   protect io->flags anymore.
> - Reduce lock contention on i_completed_io_lock by optimizing list walk.
> - Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()
> - Add BUG_ON to ext_ext_remove_space() in order to assert (3)
> 
> Changes since V1:
>  Add bugon assertion according to Jan's comment
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h     |    5 +--
>  fs/ext4/extents.c  |    1 +
>  fs/ext4/fsync.c    |   47 +++++++++++---------------------
>  fs/ext4/indirect.c |    6 +---
>  fs/ext4/inode.c    |   25 +---------------
>  fs/ext4/page-io.c  |   76 ++++++++++++++-------------------------------------
>  6 files changed, 44 insertions(+), 116 deletions(-)
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
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e993879..44e33b0 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2618,6 +2618,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
>  	handle_t *handle;
>  	int i = 0, err;
>  
> +	BUG_ON(atomic_read(&EXT4_I(inode)->i_aiodio_unwritten));
Yeah. I've just triggered this bugon. Even it it is false trigger
because it is safe to have i_aiodio_unwritten some where inside
file while file grow it in progress, but in order to be on the
safe side lets move inode_dio_wait inside ext4_truncate()
so it allow us to have 100% bulletproof assertion 
inside ext4_ext_remove_space:
BUG_ON(atomic_read(&EXT4_I(inode)->i_aiodio_unwritten))
BUG_ON(atomic_read(&(inode)->i_dio_count))

This should not affect performance since we already wait for dio tasks
during ext4_setattr, but now we will also will wait on failed_write
which happen only on error path.

 
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts:
acl,user_xattr
------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:2621!
invalid opcode: 0000 [#1] SMP 
Modules linked in: brd ext4 jbd2 cpufreq_ondemand acpi_cpufreq
freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel
microcode sg xhci_hcd ext3 jbd mbcache sd_mod crc_t10dif aesni_intel
ablk_helper cryptd aes_x86_64 aes_generic ahci libahci pata_acpi
ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 2 
Pid: 11079, comm: fio Not tainted 3.6.0-rc1+ #62
/DQ67SW
RIP: 0010:[<ffffffffa0405799>]  [<ffffffffa0405799>]
ext4_ext_remove_space+0x79/0xa80 [ext4]
RSP: 0018:ffff8801bcc87888  EFLAGS: 00010202
RAX: 0000000000000003 RBX: ffff88022b7d62c8 RCX: 000000000000000c
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa0481d90
RBP: ffff8801bcc87938 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffffa04546d8 R11: 0000000000000001 R12: ffff8801ff109000
R13: 00000000fffffffe R14: 000000000026c8d0 R15: 0000000000000001
FS:  00007f4c3dd6a700(0000) GS:ffff88023d800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4c34f4f172 CR3: 0000000204d80000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fio (pid: 11079, threadinfo ffff8801bcc86000, task
ffff88018f9e5700)
Stack:
 ffff88022b7d62c8 0000000000000000 ffff8801f1595cf8 ffff8801d8ff7000
 ffff8801bcc87938 ffffffffa03cd363 ffffffffa0408a15 0000000000000000
 ffff8801bcc878f8 0000000000000246 ffff88022b7d6238 ffffffffa0408a3d
Call Trace:
 [<ffffffffa03cd363>] ? ext4_mark_inode_dirty+0x293/0x2e0 [ext4]
 [<ffffffffa0408a15>] ? ext4_ext_truncate+0x115/0x2a0 [ext4]
 [<ffffffffa0408a3d>] ? ext4_ext_truncate+0x13d/0x2a0 [ext4]
 [<ffffffffa0408a15>] ? ext4_ext_truncate+0x115/0x2a0 [ext4]
 [<ffffffffa0408a5e>] ext4_ext_truncate+0x15e/0x2a0 [ext4]
 [<ffffffffa03c9e9a>] ext4_truncate+0x14a/0x240 [ext4]
 [<ffffffffa04224b1>] ext4_ind_direct_IO+0x481/0x740 [ext4]
 [<ffffffffa03cc970>] ? noalloc_get_block_write+0x90/0x90 [ext4]
 [<ffffffff81028965>] ? native_sched_clock+0x65/0xb0
 [<ffffffffa03c822e>] ext4_ext_direct_IO+0x26e/0x290 [ext4]
 [<ffffffffa03c83cc>] ext4_direct_IO+0x17c/0x2a0 [ext4]
 [<ffffffff81184354>] generic_file_direct_write+0x174/0x240
 [<ffffffff811849d0>] __generic_file_aio_write+0x5b0/0x820
 [<ffffffff81028965>] ? native_sched_clock+0x65/0xb0
 [<ffffffffa03c1491>] ext4_file_dio_write+0x3b1/0x550 [ext4]
 [<ffffffffa03c1778>] ext4_file_write+0x148/0x190 [ext4]
 [<ffffffffa03c1630>] ? ext4_file_dio_write+0x550/0x550 [ext4]
 [<ffffffff8127532e>] aio_rw_vect_retry+0xce/0x200
 [<ffffffff81275260>] ? aio_advance_iovec+0x130/0x130
 [<ffffffff81276246>] aio_run_iocb+0xd6/0x2a0
 [<ffffffff8173ce1d>] io_submit_one+0x38a/0x3ff
 [<ffffffff81277e1e>] do_io_submit+0x2be/0x3d0
 [<ffffffff81277f40>] sys_io_submit+0x10/0x20
 [<ffffffff8175e4e9>] system_call_fastpath+0x16/0x1b
Code: c7 c7 90 1d 48 a0 85 c0 41 0f 95 c7 31 d2 44 89 fe e8 fc a5 d5 e0
49 63 c7 48 83 c0 02 48 83 04 c5 d0 09 47 a0 01 45 85 ff 74 02 <0f> 0b
0f b7 75 bc 48 8b 7b 28 83 c6 01 e8 65 11 ff ff 48 89 c7 
RIP  [<ffffffffa0405799>] ext4_ext_remove_space+0x79/0xa80 [ext4]
 RSP <ffff8801bcc87888>
---[ end trace 19c3447cad5485fa ]---




>  
>  	/* probably first extent we're gonna free will be last in block */
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
