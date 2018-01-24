From: Jan Kara <jack@suse.cz>
Subject: Re: Failure with generic/388 test
Date: Wed, 24 Jan 2018 12:11:32 +0100
Message-ID: <20180124111132.tjwlc3eou23xm4sg@quack2.suse.cz>
References: <20180118173946.aug2x2iclhemeij6@quack2.suse.cz>
 <20180119174041.GB31450@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50095 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932891AbeAXLLe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Jan 2018 06:11:34 -0500
Content-Disposition: inline
In-Reply-To: <20180119174041.GB31450@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 19-01-18 12:40:41, Theodore Ts'o wrote:
> On Thu, Jan 18, 2018 at 06:39:46PM +0100, Jan Kara wrote:
> > 
> > I've been seeing failures with generic/388 test (with 4.12-based distro
> > kernel). Now after debugging it for some time it seems it is a problem in
> > EXT4_GOING_FLAGS_NOLOGFLUSH implementation. What seems to be happening is
> > that e.g. directory is being created, we set EXT4_FLAGS_SHUTDOWN in the
> > middle and so the creation fails. We do iput() which should delete the
> > unused inode but since the filesystem is marked as EXT4_FLAGS_SHUTDOWN,
> > those changes don't hit the disk. *But* the transaction which has allocated
> > the inode still manages to commit before we abort the journal (as there is
> > a window provided by msleep() in EXT4_GOING_FLAGS_NOLOGFLUSH
> > implementation). So after journal recovery, we have unattached inode and
> > e2fsck complains.
> 
> Thanks for looking at the problem!  It's been on my todo list to try
> to find and fix.
> 
> Right, I see the problem, and issue is that we shouldn't be trying to
> abort the handle after we set EXT4_FLAGS_SHUTDOWN.  That flag should
> prevent new handles from being started, but we should allow already
> running handles to complete, so that we correctly handle the
> EXT4_GOING_FLAGS_LOGFLUSH case.
> 
> > So why is journal abort happening after EXT4_FLAGS_SHUTDOWN being set and
> > why is that window even prolonged by msleep? That would deserve a comment
> > if nothing else BTW...
> 
> I should drop the msleep().  That was there because when we first
> started, there was a bug which has since been fixed by 8e39c6c3d5cc:
> "ext4: fix a race in the ext4 shutdown path" (in the ext4 git tree;
> due for the next merge window).
> 
> The msleep() sleep bug significantly reduced the crash caused by the
> race.  This was non-ideal, but it was better than the alternative,
> which was when the iSCSI server went down, it would hang the system
> badly enough that node's cluster daemon (think Kubernetes daemon)
> would go non-responsive for long enough that a watchdog would hammer
> down the entire system.  We knew we had a race, but the msleep reduced
> the incidence to the point where it rarely happened in production
> workloads, and it was better than the alternative (which was
> guaranteed server death).

Ouch, someone is running EXT4_IOC_SHUTDOWN in production? I always thought
it is just a testing thing...

> Anyway, that bug has since been fixed and with this other problem
> which you've pointed out hopefully we will have fixed all/most of our
> shutdown issues.

Well, just removing msleep() does not completely fix the race, just makes
it unlikely. I believe in EXT4_GOING_FLAGS_NOLOGFLUSH case we should first
do jbd2_journal_abort() and only after that set EXT4_FLAGS_SHUTDOWN. That
will fix the race completely. Are you aware of anything that depends on the
"flag first, journal later" ordering in the shutdown path?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
