From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/10] ext4: completed_io locking cleanup V3
Date: Wed, 26 Sep 2012 15:42:12 +0200
Message-ID: <20120926134212.GE10145@quack.suse.cz>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
 <1348487060-19598-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2IZNmZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 09:42:25 -0400
Content-Disposition: inline
In-Reply-To: <1348487060-19598-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-09-12 15:44:14, Dmitry Monakhov wrote:
> Current unwritten extent conversion state-machine is very fuzzy.
> - By unknown reason it want perform conversion under i_mutex. What for?
>   It was initially added by Theodore. Please comment your initial assumption.
>   My diagnosis:
>   We already protect extent tree with i_data_sem, truncate should
>   wait for DIO in flight, so the only data we have to protect io->flags
>   modification,  but only flush_completed_IO and work are modified this
>   flags and we can serialize them via i_completed_io_lock.
> 
>   Currently all this games with mutex_trylock result in following deadlock
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
> Or use 286's xfstests https://github.com/dmonakhov/xfstests/blob/devel/286
> 
> This patch makes state machine simple and clean:
> (1) ext4_end_io_work is responsible for handling all pending
>     end_io from ei->i_completed_io_list(per inode list)
>     NOTE1: i_completed_io_lock is acquired only once
>     NOTE2: i_mutex is not required because it does not protect
>            any data guarded by i_mutex any more
> 
> (2) xxx_end_io schedule end_io context completion simply by pushing it
>     to the inode's list.
>     NOTE1: because of (1) work should be queued only if
>     ->i_completed_io_list was empty at the moment, otherwise it
>     work is scheduled already.
> 
> (3) No one is able to free inode's blocks while pented io_completion
>     exist othervise may result in blocks beyond EOF, this
>     stated by the fact that all truncate routines wait for
>     all pended unwritten requets in flight
> 
> (4) Replace flush_completed_io() with ext4_unwritten_wait(). This
>     allow greatly simplify state machine because end_io conext
>     will be destroyed only in one place (end_io_work)
> 
> 
> - remove EXT4_IO_END_QUEUED and EXT4_IO_END_FSYNC flags because
>   end_io is now destroyed from known context
> - Improve SMP scalability by removing useless i_mutex which does not
>   protect io->flags anymore.
> - Reduce lock contention on i_completed_io_lock by optimizing list walk.
> - Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()
> 
> Changes since V2:
>   Fix use-after-free caused by race truncate vs end_io_work
  Nice work! Some comments below:

...
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 9970022..fa69bba 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -57,6 +57,29 @@ void ext4_ioend_wait(struct inode *inode)
>  	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
>  }
>  
> +void ext4_unwritten_wait(struct inode *inode)
> +{
> +	wait_queue_head_t *wq = ext4_ioend_wq(inode);
> +
> +	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_unwritten) == 0));
> +}
  I would add WARN_ON_ONCE(!mutex_locked(inode->i_mutex)) here because
without i_mutex this could be easily livelocked... Also I'm somewhat uneasy
that we wait for worker to do the work but it can be rather busy with
completing work for other inodes. So won't this slow down e.g. fsync() or
truncate() when there is heavy writing to other inodes? I guess some
numbers would be appropriate here...

> @@ -83,12 +106,7 @@ void ext4_free_io_end(ext4_io_end_t *io)
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
  ext4_end_io_nolock() is a misnomer now. So just make it ext4_end_io() and
make it static.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
