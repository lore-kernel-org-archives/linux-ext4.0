From: Ted Ts'o <tytso@mit.edu>
Subject: [tytso@mit.edu: Re: [PATCH 2/5] vfs: use writeback lists to provide
 lazytime one day timeout]
Date: Fri, 28 Nov 2014 13:38:03 -0500
Message-ID: <20141128183803.GB24586@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:56103 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaK1SiF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Nov 2014 13:38:05 -0500
Received: by mail-ie0-f202.google.com with SMTP id rl12so720138iec.5
        for <linux-ext4@vger.kernel.org>; Fri, 28 Nov 2014 10:38:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, sorry, responding from a different computer from what I normally
use due to Thanksgiving.

					- Ted

----- Forwarded message from Ted Ts'o <tytso@mit.edu> -----

Date: Fri, 28 Nov 2014 13:26:23 -0500
From: Ted Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] vfs: use writeback lists to provide lazytime one day timeout
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Nov 28, 2014 at 06:20:46PM +0100, Jan Kara wrote:
> On Fri 28-11-14 01:00:08, Ted Tso wrote:
> > Queue inodes with dirty timestamps for writeback 24 hours after they
> > were initially dirtied.
>   Oh I see, this patch should probably replace the other 2/5 patch.

Yes, I kept the patches separate so I could understand how much work
it would be to do things the other way and I forgot to rm -rf the
directory before I reran "git format-patch".  Sorry for the confusion.

> >  static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
> >  {
> >  	int moved;
> > +	unsigned long one_day_later = jiffies + (HZ * 86400);
> > +
> >  	assert_spin_locked(&wb->list_lock);
> >  	list_splice_init(&wb->b_more_io, &wb->b_io);
> > -	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, work);
> > +	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io,
> > +				    work->older_than_this);
> > +	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
> > +				     &one_day_later);
>   I'd change this to:
> 	if (work->sync_mode == WB_SYNC_ALL) {
> 		moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
> 					     work->older_than_this);
> 	} else {
> 		moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
> 					     &one_day_later);
> 	}

That actually doesn't work because fs/sync.c uses WB_SYNC_NONE and
then waits for all of the inodes in a separate pass.  But I can key
off of WB_REASON_SYNC, as I mentioned.

> > +		/*
> > +		 * If the inode is marked dirty time but is not dirty,
> > +		 * then at last for ext3 and ext4 we need to call
> > +		 * mark_inode_dirty_sync in order to get the inode
> > +		 * timestamp transferred to the on disk inode, since
> > +		 * write_inode is a no-op for those file systems.
> > +		 */
> > +		if ((inode->i_state & I_DIRTY_TIME) &&
> > +		    ((inode->i_state & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) == 0))
> > +			mark_inode_dirty_sync(inode);
> > +
>   This isn't necessary - you already handle this in
> __writeback_single_inode(). Or am I missing something?

Yes, good point, this can get dropped.

					- Ted

----- End forwarded message -----
