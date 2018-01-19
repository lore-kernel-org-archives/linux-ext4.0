From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Failure with generic/388 test
Date: Fri, 19 Jan 2018 12:40:41 -0500
Message-ID: <20180119174041.GB31450@thunk.org>
References: <20180118173946.aug2x2iclhemeij6@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38660 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755899AbeASRkp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Jan 2018 12:40:45 -0500
Content-Disposition: inline
In-Reply-To: <20180118173946.aug2x2iclhemeij6@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 18, 2018 at 06:39:46PM +0100, Jan Kara wrote:
> 
> I've been seeing failures with generic/388 test (with 4.12-based distro
> kernel). Now after debugging it for some time it seems it is a problem in
> EXT4_GOING_FLAGS_NOLOGFLUSH implementation. What seems to be happening is
> that e.g. directory is being created, we set EXT4_FLAGS_SHUTDOWN in the
> middle and so the creation fails. We do iput() which should delete the
> unused inode but since the filesystem is marked as EXT4_FLAGS_SHUTDOWN,
> those changes don't hit the disk. *But* the transaction which has allocated
> the inode still manages to commit before we abort the journal (as there is
> a window provided by msleep() in EXT4_GOING_FLAGS_NOLOGFLUSH
> implementation). So after journal recovery, we have unattached inode and
> e2fsck complains.

Thanks for looking at the problem!  It's been on my todo list to try
to find and fix.

Right, I see the problem, and issue is that we shouldn't be trying to
abort the handle after we set EXT4_FLAGS_SHUTDOWN.  That flag should
prevent new handles from being started, but we should allow already
running handles to complete, so that we correctly handle the
EXT4_GOING_FLAGS_LOGFLUSH case.

> So why is journal abort happening after EXT4_FLAGS_SHUTDOWN being set and
> why is that window even prolonged by msleep? That would deserve a comment
> if nothing else BTW...

I should drop the msleep().  That was there because when we first
started, there was a bug which has since been fixed by 8e39c6c3d5cc:
"ext4: fix a race in the ext4 shutdown path" (in the ext4 git tree;
due for the next merge window).

The msleep() sleep bug significantly reduced the crash caused by the
race.  This was non-ideal, but it was better than the alternative,
which was when the iSCSI server went down, it would hang the system
badly enough that node's cluster daemon (think Kubernetes daemon)
would go non-responsive for long enough that a watchdog would hammer
down the entire system.  We knew we had a race, but the msleep reduced
the incidence to the point where it rarely happened in production
workloads, and it was better than the alternative (which was
guaranteed server death).

Anyway, that bug has since been fixed and with this other problem
which you've pointed out hopefully we will have fixed all/most of our
shutdown issues.

Cheers,

						- Ted
