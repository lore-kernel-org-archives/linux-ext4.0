From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 04/11] ext4: completed_io locking cleanup V4
Date: Wed, 03 Oct 2012 15:21:25 +0400
Message-ID: <87txubsswa.fsf@openvz.org>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org> <1348847051-6746-5-git-send-email-dmonakhov@openvz.org> <20121001183833.GF32092@quack.suse.cz> <87vcetbay1.fsf@openvz.org> <20121002103141.GA22777@quack.suse.cz> <87r4phb0q5.fsf@openvz.org> <20121002111106.GB22777@quack.suse.cz> <87obklavuo.fsf@openvz.org> <20121002133019.GC22777@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
	lczerner@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32815 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JCLV3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2012 07:21:29 -0400
Received: by lbon3 with SMTP id n3so6087378lbo.19
        for <linux-ext4@vger.kernel.org>; Wed, 03 Oct 2012 04:21:27 -0700 (PDT)
In-Reply-To: <20121002133019.GC22777@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2 Oct 2012 15:30:19 +0200, Jan Kara <jack@suse.cz> wrote:
> On Tue 02-10-12 16:42:39, Dmitry Monakhov wrote:
> > On Tue, 2 Oct 2012 13:11:06 +0200, Jan Kara <jack@suse.cz> wrote:
> > > On Tue 02-10-12 14:57:22, Dmitry Monakhov wrote:
> > > > On Tue, 2 Oct 2012 12:31:41 +0200, Jan Kara <jack@suse.cz> wrote:
> > > > > On Tue 02-10-12 11:16:38, Dmitry Monakhov wrote:
> > > > > > > > +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > > > > > > +	while (!list_empty(&complete)) {
> > > > > > > > +		io = list_entry(complete.next, ext4_io_end_t, list);
> > > > > > > > +		io->flag &= ~EXT4_IO_END_UNWRITTEN;
> > > > > > > > +		/* end_io context can not be destroyed now because it still
> > > > > > > > +		 * used by queued worker. Worker thread will destroy it later */
> > > > > > > > +		if (io->flag & EXT4_IO_END_QUEUED)
> > > > > > > > +			list_del_init(&io->list);
> > > > > > > > +		else
> > > > > > > > +			list_move(&io->list, &to_free);
> > > > > > > > +	}
> > > > > > > > +	/* If we are called from worker context, it is time to clear queued
> > > > > > > > +	 * flag, and destroy it's end_io if it was converted already */
> > > > > > > > +	if (work_io) {
> > > > > > > > +		work_io->flag &= ~EXT4_IO_END_QUEUED;
> > > > > > > > +		if (!(work_io->flag & EXT4_IO_END_UNWRITTEN))
> > > > > > > > +			list_add_tail(&work_io->list, &to_free);
> > > > > > > >  	}
> > > > > > > > -	list_del_init(&io->list);
> > > > > > > >  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > > > > > > > -	(void) ext4_end_io_nolock(io);
> > > > > > > > -	mutex_unlock(&inode->i_mutex);
> > > > > > > > -free:
> > > > > > > > -	ext4_free_io_end(io);
> > > > > > > > +
> > > > > > > > +	while (!list_empty(&to_free)) {
> > > > > > > > +		io = list_entry(to_free.next, ext4_io_end_t, list);
> > > > > > > > +		list_del_init(&io->list);
> > > > > > > > +		ext4_free_io_end(io);
> > > > > > > > +	}
> > > > > > > > +	return ret;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * work on completed aio dio IO, to convert unwritten extents to extents
> > > > > > > > + */
> > > > > > > > +static void ext4_end_io_work(struct work_struct *work)
> > > > > > > > +{
> > > > > > > > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > > > > > > > +	ext4_do_flush_completed_IO(io->inode, io);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +int ext4_flush_completed_IO(struct inode *inode)
> > > > > > > > +{
> > > > > > > > +	return ext4_do_flush_completed_IO(inode, NULL);
> > > > > > > >  }
> > > > > > >   Also it seems that when ext4_flush_completed_IO() is called, workqueue
> > > > > > > can have several IO structures queued in its local lists thus we miss them
> > > > > > > here and don't properly wait for all conversions?
> > > > > > No it is not. Because list drained atomically, and 
> > > > > > add_complete_io will queue work only if list is empty.
> > > > > > 
> > > > > > Race between conversion and dequeue-process is not possible because
> > > > > > we hold lock during entire walk of complete_list, so from external
> > > > > > point of view we mark list as conversed(clear unwritten flag)
> > > > > > happens atomically. I've drawn all possible situations and race not
> > > > > > happen. If you know any please let me know.
> > > > >   I guess I'm missing something obvious. So let's go step by step:
> > > > > 1) ext4_flush_completed_IO() must make sure there is no outstanding
> > > > >    conversion for the inode.
> > > > > 2) Now assume we have non-empty i_completed_io_list - thus work is queued.
> > > > > 3) The following situation seems to be possible:
> > > > > 
> > > > > CPU1					CPU2
> > > > > (worker thread)				(truncate)
> > > > > ext4_end_io_work()
> > > > >   ext4_do_flush_completed_IO()
> > > > >     spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > > >     dump_completed_IO(inode);
> > > > >     list_replace_init(&ei->i_completed_io_list, &unwritten);
> > > > >     spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > > > > 
> > > > > 					ext4_flush_completed_IO()
> > > > > 					  ext4_do_flush_completed_IO()
> > > > > 					    - sees empty i_completed_io_list
> > > > > 					     => exits
> > > > > 
> > > > >   But we still have some conversions pending in 'unwritten' list. What am
> > > > > I missing?
> > > > Indeed, I've simply missed that case. The case which result silently
> > > > broke integrity sync ;(
> > > > Thank you for spotting this. I'll be back with updated version.
> > >   Umm, actually, I was thinking about it and ext4_flush_completed_IO()
> > > seems to be unnecessary in fsync these days. We don't call aio_complete()
> > > until we perform the conversion so what fsync does to such IO is undefined.
> > > Such optimization is a separate matter though.
> > Yes aio is ok, but integrity fsync after buffered write to unwritten
> > extent is broken.
> > 
> > fsync()                             blkdev_completion          kwork
> > ->filemap_write_and_wait_range
> >                                     ->ext4_end_bio
> >                                      ->end_page_writeback
> >  <-- filemap_write_and_wait_range return  
> >                                       ->ext4_add_complete_io
> > 
> >                                                               ->ext4_do_flush_completed_IO
> >                                                                  ->list_replace_init
> > ->ext4_flush_completed_IO
> >   sees empty i_comleted_io_list but pended
> >   conversion still exist
> >                                                                 ->ext4_end_io
> > 
>   Correct. Thanks for pointing that out.
In my deference I should say that integrity fsync was broken before my patch in
case of buffered writes because end_page_writeback called before
end_io added to ei->i_comlete_io_list
 fsync()                                    blkdev_completion
 ->filemap_write_and_wait_range
                                            ->ext4_end_bio
                                             ->end_page_writeback
  <-- filemap_write_and_wait_range return  
 ->ext4_flush_completed_IO
   sees empty i_comleted_io_list but pended
   conversion still exist
                                               ->ext4_add_complete_io

