From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/11] ext4: completed_io locking cleanup V4
Date: Tue, 2 Oct 2012 12:31:41 +0200
Message-ID: <20121002103141.GA22777@quack.suse.cz>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
 <1348847051-6746-5-git-send-email-dmonakhov@openvz.org>
 <20121001183833.GF32092@quack.suse.cz>
 <87vcetbay1.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2JBKbn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 06:31:43 -0400
Content-Disposition: inline
In-Reply-To: <87vcetbay1.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-10-12 11:16:38, Dmitry Monakhov wrote:
...
> > > +static int ext4_do_flush_completed_IO(struct inode *inode,
> > > +	while (!list_empty(&unwritten)) {
> > > +		io = list_entry(unwritten.next, ext4_io_end_t, list);
> > > +		BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
> > > +		list_del_init(&io->list);
> > > +
> > > +		err = ext4_end_io(io);
> > > +		if (unlikely(!ret && err))
> > > +			ret = err;
> > > +
> > > +		list_add_tail(&io->list, &complete);
> > > +	}
> > > +	/* It is important to update all flags for all end_io in one shot w/o
> > > +	 * dropping the lock.*/
> >   Why? It would seem that once io structures are moved from
> > i_completed_io_list, they are unreachable by anyone else?
  You seem to have missed this comment?


> > > +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > +	while (!list_empty(&complete)) {
> > > +		io = list_entry(complete.next, ext4_io_end_t, list);
> > > +		io->flag &= ~EXT4_IO_END_UNWRITTEN;
> > > +		/* end_io context can not be destroyed now because it still
> > > +		 * used by queued worker. Worker thread will destroy it later */
> > > +		if (io->flag & EXT4_IO_END_QUEUED)
> > > +			list_del_init(&io->list);
> > > +		else
> > > +			list_move(&io->list, &to_free);
> > > +	}
> > > +	/* If we are called from worker context, it is time to clear queued
> > > +	 * flag, and destroy it's end_io if it was converted already */
> > > +	if (work_io) {
> > > +		work_io->flag &= ~EXT4_IO_END_QUEUED;
> > > +		if (!(work_io->flag & EXT4_IO_END_UNWRITTEN))
> > > +			list_add_tail(&work_io->list, &to_free);
> > >  	}
> > > -	list_del_init(&io->list);
> > >  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > > -	(void) ext4_end_io_nolock(io);
> > > -	mutex_unlock(&inode->i_mutex);
> > > -free:
> > > -	ext4_free_io_end(io);
> > > +
> > > +	while (!list_empty(&to_free)) {
> > > +		io = list_entry(to_free.next, ext4_io_end_t, list);
> > > +		list_del_init(&io->list);
> > > +		ext4_free_io_end(io);
> > > +	}
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > > + * work on completed aio dio IO, to convert unwritten extents to extents
> > > + */
> > > +static void ext4_end_io_work(struct work_struct *work)
> > > +{
> > > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > > +	ext4_do_flush_completed_IO(io->inode, io);
> > > +}
> > > +
> > > +int ext4_flush_completed_IO(struct inode *inode)
> > > +{
> > > +	return ext4_do_flush_completed_IO(inode, NULL);
> > >  }
> >   Also it seems that when ext4_flush_completed_IO() is called, workqueue
> > can have several IO structures queued in its local lists thus we miss them
> > here and don't properly wait for all conversions?
> No it is not. Because list drained atomically, and 
> add_complete_io will queue work only if list is empty.
> 
> Race between conversion and dequeue-process is not possible because
> we hold lock during entire walk of complete_list, so from external
> point of view we mark list as conversed(clear unwritten flag)
> happens atomically. I've drawn all possible situations and race not
> happen. If you know any please let me know.
  I guess I'm missing something obvious. So let's go step by step:
1) ext4_flush_completed_IO() must make sure there is no outstanding
   conversion for the inode.
2) Now assume we have non-empty i_completed_io_list - thus work is queued.
3) The following situation seems to be possible:

CPU1					CPU2
(worker thread)				(truncate)
ext4_end_io_work()
  ext4_do_flush_completed_IO()
    spin_lock_irqsave(&ei->i_completed_io_lock, flags);
    dump_completed_IO(inode);
    list_replace_init(&ei->i_completed_io_list, &unwritten);
    spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);

					ext4_flush_completed_IO()
					  ext4_do_flush_completed_IO()
					    - sees empty i_completed_io_list
					     => exits

  But we still have some conversions pending in 'unwritten' list. What am
I missing?

								Honza
