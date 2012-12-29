From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Sun, 30 Dec 2012 10:23:35 +1100
Message-ID: <20121229232335.GB3120@dastard>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com>
 <20121227062907.GA5001@gmail.com>
 <87mwwzq5t7.fsf@openvz.org>
 <20121227134413.GA20671@thunk.org>
 <20121229002131.GA3120@dastard>
 <87sj6psb2m.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23668 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab2L2XXk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 18:23:40 -0500
Content-Disposition: inline
In-Reply-To: <87sj6psb2m.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ add xfs@oss.sgi.com to cc list. ]

On Sat, Dec 29, 2012 at 09:04:49AM +0400, Dmitry Monakhov wrote:
> On Sat, 29 Dec 2012 11:21:31 +1100, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Dec 27, 2012 at 08:44:13AM -0500, Theodore Ts'o wrote:
> > > On Thu, Dec 27, 2012 at 12:04:36PM +0400, Dmitry Monakhov wrote:
> > > > In fact this is my fault that we still not have autotest for that.
> > > > I'm think of add crash-test to xfstests which should trigger journal
> > > > abort and forced umount. Later test should mount FS which trigger
> > > > journal_replay and orphan_cleanup.
> > > 
> > > We could create some tests in xfstests which force a crash via "echo b
> > > > /proc/sysrq-trigger", but the trick is would require xfstests to
> > > install something in the /etc/rc scripts so xfstests could resume
> > > right after it came back --- and perhaps to echo something to the
> > > console which automated test runners (such as the one I use which I've
> > > published at [1] could capture so they would know that they should
> > > restart the system.
> > > 
> > > [1] git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
> > > 
> > > For now the simplest way to test this is to use the file system image
> > > in tests/f_orphan_extents_inode/image.gz, and make this be an
> > > ext4-specific test.  This is how I tested it when I created my fix (in
> > > parallel with Zheng's patch).  The compressed file system image is
> > > only 564 bytes --- and was made deliberately w/o a journal so it could
> > > be that small --- and the lack of a journal was how I found the
> > > infinite loop problem which was fixed in the 2/2 patch in my patches.
> > > So including this compressed fs image in xfstests is probably the way
> > > I would suggest for now.
> > 
> > Just implement XFS_IOC_GOINGDOWN. That way xfstests will immediately
> > support shutting down the filesystem via the src/godown utility.
> > The default XFS behaviour is to freeze the filesystem, then do a
> > forced shutdown on it, though it can also just trigger shutdowns
> > with and without first flushing the journal.
> Actually I want to emulate device failure this allow us to test
> following scenarios
> 1) unsafe usb dongle unplug(test system survival)

This is the same as immediately returning EIO to any IO that is
started after the event, or in the case of a shutdown filesystem,
stopping any new IO from being submitted with an error.

XFS implements the latter as part of it's shutdown infrastructure.
IOWs, ioctl(XFS_IOC_GOINGDOWN, XFS_FSOP_GOING_FLAGS_NOLOGFLUSH) is
exactly equivalent to pulling the plug out of the device from under
the filesystem - after the call, no new IO submission ever reaches
the disk, and IO in flight is marked as failed on completion...

As it is, just unplugging the device leads to unpredictable test
behaviour as it cannot be guaranteed to reproduce the required
filesytem state that the test requires. Hence test 121 uses
XFS_FSOP_GOING_FLAGS_LOGFLUSH, which means the log is completely
written on disk before the shutdown is initiated. This ensures that
recovery will see the unlinked files and process them appropriately.
A "device unplug" equivalent shutdown would likely cause the unlink
transactions never to make it to disk, and so the test would be
unreliable.

> 2) power failure(
> Our 'improved' loop device (http://wiki.openvz.org/Ploop) has
> /sys/block/ploop0/make-it-fail  knob which explicitly fail blkdevice
> Once failed it return EIO on all requests. I would like add this 
> feature in generic loop device.

That's not the equivalent of a power failure. That's exactly the
same as pulling the plug. If you want robust power fail testing, you
need to use a device that emulates a volatile device cache which
causes IOs that have already been signalled as complete (without
errors) to the filesystem to then fail.

As it is, I'm pretty sure that the md-faulty/dm-flakey/scsi-debug
devices can already do this "return EIO to all new IOs" error
injection. We already use the scsi-debug module in xfstests, so I'd
suggest that it might be the best place to start for this sort of
device failure testing in xfstests....

What I'm trying to say here is that we already have mechanisms in
xfstests for exercising the functionality you are talking about
here. You don't need to re-invent the wheel or rely on an
out-of-tree device driver - just use the existing methods other
filesystems use for executing this sort of testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
