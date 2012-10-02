From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 04/11] ext4: completed_io locking cleanup V4
Date: Tue, 02 Oct 2012 11:16:38 +0400
Message-ID: <87vcetbay1.fsf@openvz.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org> <1348847051-6746-5-git-send-email-dmonakhov@openvz.org> <20121001183833.GF32092@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43733 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2JBHQm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2012 03:16:42 -0400
Received: by lagh6 with SMTP id h6so2242934lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 02 Oct 2012 00:16:40 -0700 (PDT)
In-Reply-To: <20121001183833.GF32092@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 1 Oct 2012 20:38:33 +0200, Jan Kara <jack@suse.cz> wrote:
> On Fri 28-09-12 19:44:04, Dmitry Monakhov wrote:
>   Couple of language fixes:
> > Current unwritten extent conversion state-machine is very fuzzy.
> > - By unknown reason it want perform conversion under i_mutex. What for?
>     ^^ For               ^^^^^^^^ I'd just make it "performs"
> >   My diagnosis:
> >   We already protect extent tree with i_data_sem, truncate and punch_hole
> >   should wait for DIO, so the only data we have to protect is end_io->flags
> >   modification, but only flush_completed_IO and end_io_work modified this
>                                                                        ^^ these
> >   flags and we can serialize them via i_completed_io_lock.
> > 
> >   Currently all this games with mutex_trylock result in following deadlock
>                   ^^^ these                              ^ the
> >    truncate:                          kworker:
> >     ext4_setattr                       ext4_end_io_work
> >     mutex_lock(i_mutex)
> >     inode_dio_wait(inode)  ->BLOCK
> >                              DEADLOCK<- mutex_trylock()
> >                                         inode_dio_done()
> >   #TEST_CASE1_BEGIN
> >   MNT=/mnt_scrach
> >   unlink $MNT/file
> >   fallocate -l $((1024*1024*1024)) $MNT/file
> >   aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file
> >   sleep 2
> >   truncate -s 0 $MNT/file
> >   #TEST_CASE1_END
> > 
> > Or use 286's xfstests https://github.com/dmonakhov/xfstests/blob/devel/286
> > 
> > This patch makes state machine simple and clean:
> > 
> > (1) xxx_end_io schedule final extent conversion simply by calling
> >     ext4_add_complete_io(), which append it to ei->i_completed_io_list
> >     NOTE1: because of (2A) work should be queued only if
> >     ->i_completed_io_list was empty, otherwise it work is scheduled already.
>                                                  ^^ remove this
> > 
> > (2) ext4_flush_completed_IO is responsible for handling all pending
> >     end_io from ei->i_completed_io_list
> >     Flushing sequange consist of following stages:
>                ^^ sequence ^ consists
> >     A) LOCKED: Atomically drain completed_io_list to local_list
> >     B) Perform extents conversion
> >     C) LOCKED: move conveted io's to to_free list for final deletion
>                       ^^ converted
> >        	     This logic depends on context which we was called from.
>                                                             ^^ were
> >     D) Final end_io context destruction
> >     NOTE1: i_mutex is no longer required because end_io->flags modification
> >     protected by ei->ext4_complete_io_lock
>       ^^ is protected
> > 
> > Full list of changes:
> > - Move all completion end_io related routines to page-io.c in order to improve
> >   logic locality
> > - Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()
> > - remove EXT4_IO_END_FSYNC
> > - Improve SMP scalability by removing useless i_mutex which does not
> >   protect io->flags anymore.
> > - Reduce lock contention on i_completed_io_lock by optimizing list walk.
> > - Rename ext4_end_io_nolock to end4_end_io and make it static
> > - Check flush completion status to ext4_ext_punch_hole(). Because it is
> >   not good idea to punch blocks from corrupted inode.
> > 
> > Changes since V3 (in request to Jan's comments):
> >   Fall back to active flush_completed_IO() approach in order to prevent
> >   performance issues with nolocked DIO reads.
> > Changes since V2:
> >   Fix use-after-free caused by race truncate vs end_io_work
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/ext4.h     |    3 +-
> >  fs/ext4/extents.c  |    4 +-
> >  fs/ext4/fsync.c    |   81 -------------------------
> >  fs/ext4/indirect.c |    6 +-
> >  fs/ext4/inode.c    |   25 +-------
> >  fs/ext4/page-io.c  |  171 ++++++++++++++++++++++++++++++++++------------------
> >  6 files changed, 121 insertions(+), 169 deletions(-)
> > 
> ...
> > +static int ext4_do_flush_completed_IO(struct inode *inode,
> > +				      ext4_io_end_t *work_io)
> > +{
> > +	ext4_io_end_t *io;
> > +	struct list_head unwritten, complete, to_free;
> > +	unsigned long flags;
> > +	struct ext4_inode_info *ei = EXT4_I(inode);
> > +	int err, ret = 0;
> > +
> > +	INIT_LIST_HEAD(&complete);
> > +	INIT_LIST_HEAD(&to_free);
> > +
> > +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > +	dump_completed_IO(inode);
> > +	list_replace_init(&ei->i_completed_io_list, &unwritten);
> > +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > +
> > +	while (!list_empty(&unwritten)) {
> > +		io = list_entry(unwritten.next, ext4_io_end_t, list);
> > +		BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
> > +		list_del_init(&io->list);
> > +
> > +		err = ext4_end_io(io);
> > +		if (unlikely(!ret && err))
> > +			ret = err;
> > +
> > +		list_add_tail(&io->list, &complete);
> > +	}
> > +	/* It is important to update all flags for all end_io in one shot w/o
> > +	 * dropping the lock.*/
>   Why? It would seem that once io structures are moved from
> i_completed_io_list, they are unreachable by anyone else?
> 
> > +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > +	while (!list_empty(&complete)) {
> > +		io = list_entry(complete.next, ext4_io_end_t, list);
> > +		io->flag &= ~EXT4_IO_END_UNWRITTEN;
> > +		/* end_io context can not be destroyed now because it still
> > +		 * used by queued worker. Worker thread will destroy it later */
> > +		if (io->flag & EXT4_IO_END_QUEUED)
> > +			list_del_init(&io->list);
> > +		else
> > +			list_move(&io->list, &to_free);
> > +	}
> > +	/* If we are called from worker context, it is time to clear queued
> > +	 * flag, and destroy it's end_io if it was converted already */
> > +	if (work_io) {
> > +		work_io->flag &= ~EXT4_IO_END_QUEUED;
> > +		if (!(work_io->flag & EXT4_IO_END_UNWRITTEN))
> > +			list_add_tail(&work_io->list, &to_free);
> >  	}
> > -	list_del_init(&io->list);
> >  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > -	(void) ext4_end_io_nolock(io);
> > -	mutex_unlock(&inode->i_mutex);
> > -free:
> > -	ext4_free_io_end(io);
> > +
> > +	while (!list_empty(&to_free)) {
> > +		io = list_entry(to_free.next, ext4_io_end_t, list);
> > +		list_del_init(&io->list);
> > +		ext4_free_io_end(io);
> > +	}
> > +	return ret;
> > +}
> > +
> > +/*
> > + * work on completed aio dio IO, to convert unwritten extents to extents
> > + */
> > +static void ext4_end_io_work(struct work_struct *work)
> > +{
> > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > +	ext4_do_flush_completed_IO(io->inode, io);
> > +}
> > +
> > +int ext4_flush_completed_IO(struct inode *inode)
> > +{
> > +	return ext4_do_flush_completed_IO(inode, NULL);
> >  }
>   Also it seems that when ext4_flush_completed_IO() is called, workqueue
> can have several IO structures queued in its local lists thus we miss them
> here and don't properly wait for all conversions?
No it is not. Because list drained atomically, and 
add_complete_io will queue work only if list is empty.

Race between conversion and dequeue-process is not possible because
we hold lock during entire walk of complete_list, so from external
point of view we mark list as conversed(clear unwritten flag)
happens atomically. I've drawn all possible situations and race not
happen. If you know any please let me know.

> 
> 								Honza
