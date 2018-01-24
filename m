From: Jan Kara <jack@suse.cz>
Subject: Re: Failure with generic/388 test
Date: Wed, 24 Jan 2018 18:30:52 +0100
Message-ID: <20180124173052.tys3sqrxaleeyfg6@quack2.suse.cz>
References: <20180118173946.aug2x2iclhemeij6@quack2.suse.cz>
 <20180119174041.GB31450@thunk.org>
 <20180124111132.tjwlc3eou23xm4sg@quack2.suse.cz>
 <20180124170036.GD30326@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964790AbeAXRay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Jan 2018 12:30:54 -0500
Content-Disposition: inline
In-Reply-To: <20180124170036.GD30326@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 24-01-18 12:00:36, Theodore Ts'o wrote:
> On Wed, Jan 24, 2018 at 12:11:32PM +0100, Jan Kara wrote:
> > > The msleep() sleep bug significantly reduced the crash caused by the
> > > race.  This was non-ideal, but it was better than the alternative,
> > > which was when the iSCSI server went down, it would hang the system
> > > badly enough that node's cluster daemon (think Kubernetes daemon)
> > > would go non-responsive for long enough that a watchdog would hammer
> > > down the entire system.  We knew we had a race, but the msleep reduced
> > > the incidence to the point where it rarely happened in production
> > > workloads, and it was better than the alternative (which was
> > > guaranteed server death).
> > 
> > Ouch, someone is running EXT4_IOC_SHUTDOWN in production? I always thought
> > it is just a testing thing...
> 
> Yes, it's being used in no-journal mode on thousands and thousands
> data center servers at work.  By the time we use it though, the iSCSI
> device is presumped dead (we use local loopback per my comments on a
> LSF/MM thread, and in most common case the entire container is getting
> OOM-killed), and we don't care about the data stored on the volume.
> So that's why the various test failures that result in a corrupted
> file system hasn't worried us a whole lot; we're running in no journal
> mode, so fs corruption was always expected --- and in this case, we
> don't actually care about the fs contents, post-shutdown, at all.

Ah, ok :). Thanks for info.

> > > Anyway, that bug has since been fixed and with this other problem
> > > which you've pointed out hopefully we will have fixed all/most of our
> > > shutdown issues.
> > 
> > Well, just removing msleep() does not completely fix the race, just makes
> > it unlikely. I believe in EXT4_GOING_FLAGS_NOLOGFLUSH case we should first
> > do jbd2_journal_abort() and only after that set EXT4_FLAGS_SHUTDOWN. That
> > will fix the race completely. Are you aware of anything that depends on the
> > "flag first, journal later" ordering in the shutdown path?
> 
> I'm going to change things so that the flag will prevent any *new*
> handles from starting, but allow existing handles to complete.  That
> should fix up the problems for LOGFLUSH case as well.

At this point I'm not sure how you want to make that work - once
ext4_forced_shutdown() starts returning errors, we may fail various
operations and as a result cleanup of some operation where this happens in
the middle is incomplete. E.g. if you allocate inode, then flip the
shutdown bit, then we fail to link inode into its parent directory, but
iput() on error cleanup path will also fail to free this inode as various
ext4_forced_shutdown() checks along that path will stop that... So
transaction will complete but proper cleanup will not be logged in it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
