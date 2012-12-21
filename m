From: Jan Kara <jack@suse.cz>
Subject: Re: Uninitialized extent races
Date: Fri, 21 Dec 2012 23:49:47 +0100
Message-ID: <20121221224947.GA23652@quack.suse.cz>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
 <20121221161929.GF17357@quack.suse.cz>
 <20121221180243.GB31731@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2LUWtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 17:49:50 -0500
Content-Disposition: inline
In-Reply-To: <20121221180243.GB31731@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 21-12-12 13:02:43, Ted Tso wrote:
> On Fri, Dec 21, 2012 at 05:19:29PM +0100, Jan Kara wrote:
> >   No, I'm speaking about merging currently uninitialized extents. I.e.
> > suppose someone does the following on a filesystem with dioread_nolock so
> > that writeback happens via unwritten extents:
> >   fd = open("file", O_RDWR);
> >   pwrite(fd, buf, 4096, 0);
> > 					flusher thread starts writing
> > 					we create uninitialized extent for
> > 					  range 0-4096
> >   fallocate(fd, 0, 4096, 4096);
> >     - we merge extents and now have just 1 uninitialized extent for range
> >       0-8192
> > 					ext4_convert_unwritten_extents() now
> > 					  has to split the extent to finish
> > 					  the IO.
> 
> Ah, I see.  Disabling the the merging that might take place as a
> result of the fallocate.  Yes, I agree that's a completely sane thing
> to do.
  OK, I'll write some patches.

> The alternate approach would be to add a flag in the extent status
> tree indicating that an unwritten conversion is pending, but that
> would add more complexity.
> 
> Hmmm.... do we need that complexity anyway?  What happens if we have a
> race between a punch (or truncate) and the flusher thread, so there is
> pending write.  There are two things that would be of concern.  (1)
> Will convert_unwritten_extents do the right thing if the extent in
> question has disappeared, and (2) what if the block gets reused for
> some other inode in the interim?
> 
> I _think_ we're OK in the case of (2), since we're not using FUA writes
> for anything other than the commit block, so there shouldn't be any way
> that a write for the new inode could complete before the pending write
> finishes up.  And (1) should be OK, although it may end up triggering a
> WARN_ON and a scarry ext4_msg() in ext4_convert_unwritten_extents().
> But it made me stop and think....
  It's actually simpler than that. We wait for any pending DIO using
inode_dio_wait() and i_mutex protects from new writes to be submitted. So
that takes care of one possibility. truncate_inode_pages() waits for
PageWriteback bit so that handles waiting for IO itself. After I change
ext4 to convert extents before clearing PageWriteback, this will take care
also of extent conversion. Now a call to ext4_flush_unwritten_io() in
ext4_ext_truncate() resolves the problems. It's called after invalidating
page cache so we know all the pending IO for the truncated / punched area
is finished, just a conversion may be still pending.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
