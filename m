From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
	callback
Date: Wed, 26 Aug 2009 15:52:53 +0200
Message-ID: <20090826135253.GB14534@duck.novell.com>
References: <1250092470.18329.27.camel@mingming-laptop> <20090819141557.GA4705@atrey.karlin.mff.cuni.cz> <1250717176.3924.116.camel@mingming-laptop> <20090820115212.GA16486@duck.novell.com> <1251149893.4280.69.camel@mingming-laptop> <20090825140113.GG405@duck.novell.com> <1251229270.3930.17.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbZHZNww (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:52:52 -0400
Content-Disposition: inline
In-Reply-To: <1251229270.3930.17.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > > We do update i_size in generic_file_direct_write(), there I think proper
> > > locking (i_mutex lock) is hold.
> > > 
> > > For i_disksize update, with this patch, we call ext4_update_i_disksize()
> > > from ext4_convert_unwritten_extents(), at the end of IO is completed.
> > > ext4_update_i_disksize() grab the i_data_sem to prevent race with
> > > truncate.
> > > 
> > > Now I think we are fine with race with truncate... no?
> >   I don't think we are fine - i_disksize gets updated without i_data_sem
> > being held in ext4_setattr() so you can race with it. I'm not sure how
> > exactly locking rules for ext4 look like wrt. i_disksize update but either
> > your code or ext4_setattr() need to be changed.
> 
> then ext4_setattr() race with other places using
> ext4_update_i_disksize() (e.g. fallocate) already. we need to fix
> ext4_setattr and probably other places where i_disksize is updated
> without holding i_data_sem.
  OK.

> >   Actually, probably you should hold i_mutex until the io is finished -
> > otherwise a truncate against the file can be started before the io is
> > finished and actually nothing prevents it from finishing before your end_io
> > callback gets processed. Then the extent conversion will get confused I
> > expect because it won't find extents it should convert.
> > 
> DIO already did that:) i_mutex is hold during the whole direct IO,
> before return back to user, in the non AIO case.
  Yes, the non-AIO case is fine. But the AIO case is problematic - and it's
not just about i_disksize update. Also the conversion from unwritten to
written extents could have problems with the file being truncated or
otherwise modified in the mean time.

> > > > > > It needn't be cached in the memory anymore!
> > > > > 
> > > > > Right, we probably need to increase the reference to the inode before
> > > > > submit the IO, so the inode would not be push out of cache before IO
> > > > > completed.
> > > >   Yes, that's possible but then you have to be prepared to handle deletes
> > > > of an inode from your worker thread because it can drop the last reference
> > > > to an already deleted inode.
> > > > 
> > > > > >   Also fsync() has to flush all the updates for the inode it has in the
> > > > > > workqueue... Ditto for ext4_sync_fs().
> > > > > > 
> > > > > 
> > > > > I think we discussed about this before, and it seems there is no clear
> > > > > defination the DIO forces metadata update sync to disk before returns
> > > > > back to user apps... If we do force this in ext4 &DIO, doing fsync() on
> > > > > every DIO call is expensive.
> > > >   No, I meant something else:
> > > > fd = open("file", O_DIRECT | O_RDWR);
> > > > write(fd, buf, size);
> > > > fsync(fd)
> > > > 
> > > >   After fsync(fd) we *must* have everything on disk and reachable even if
> > > > we crashed just after fsync(). So conversion of extents from uninitialized
> > > > to initialized must happen during fsync() and it does not so far because we
> > > > have no connection from an inode to the work queued to the worker thread.
> > > > 
> > > 
> > > Are you worried about AIO DIO case?
> > > 
> > > Because for non AIO case, when DIO returns back to user, the data IO has
> > > already completed, and the conversion of extents from uninitialized to
> > > initialized has already being kicked by flush_workqueue(). Since the
> > > conversion is being journaled, the aftweward fsync() should able to
> > > commit all transactions, thus force the conversion to be complete on
> > > disk after fsync.
> >   Yes, you are right, this case is fine.
> > 
> > > For the AIO DIO case, yeah I agree there might be a issue....  Hmm.. if
> > > we do fsync() after AIO DIO, currently I couldn't see any way fsync()
> > > could ensure all the pending data IOs from AIO DIO path would reach to
> > > disk...
> > > 
> > > if there is a way fsycn() could wait for all pending data IOs  from AIO
> > > DIO to complete, then end_io callback would able to trigger the
> > > conversion, and fsycn() would able to flush the metedata update hit to
> > > disk.
> >   Well, thinking about this again, fsync() does not have to wait for
> > pending AIO - we never guaranteed anything about what fsync() does to such
> > requests. But once you complete the AIO (and thus userspace can know that
> > it is done), you have to make sure that fsync() flushes all the work
> > queued in the workqueue connected with this AIO.
> > 
> 
> I just realize, why don't we flush the work in the workqueue with this
> AIO at the IO completion time (but not ext4_direct_IO time)? Since the
> work just does conversion but not the full journal commit. That would
> work if there is fsync() after the AIO is completed.
  The problem is that IO completion for AIO happens in interrupt and you
cannot sleep there. If you could, you would not need any workqueue...

> > > > So I'd
> > > > find simpler to do the conversion from ext4_direct_IO and just make sure the
> > > > transaction is not committed before the IO is done (essentially what we
> > > > currently do with ordered buffers).
> > > > 
> > > 
> > > True, that might workable....I am concerned this won't work for no
> > > journal mode, though this mode is not commonly used now.:)
> >   Well, if you are running without a journal, you can see stale data after
> > a crash - there's no way around it. So just not waiting for anything works
> > well.
> > 
> 
> But in the direct IO case, with the end_io call back, we won't update
> i_disksize until IO is completed, you should not see stale data after a
> crash, even without journal, am I miss anything?
  Yes, that is probably right (unless disk reorders writes). But my point
was that once you run without a journal, we don't care whether we expose
stale data or not.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
