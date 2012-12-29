From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Sat, 29 Dec 2012 09:04:49 +0400
Message-ID: <87sj6psb2m.fsf@openvz.org>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com> <20121227062907.GA5001@gmail.com> <87mwwzq5t7.fsf@openvz.org> <20121227134413.GA20671@thunk.org> <20121229002131.GA3120@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:56746 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2L2FE5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Dec 2012 00:04:57 -0500
Received: by mail-la0-f43.google.com with SMTP id eg20so1751543lab.30
        for <linux-ext4@vger.kernel.org>; Fri, 28 Dec 2012 21:04:54 -0800 (PST)
In-Reply-To: <20121229002131.GA3120@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 29 Dec 2012 11:21:31 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 27, 2012 at 08:44:13AM -0500, Theodore Ts'o wrote:
> > On Thu, Dec 27, 2012 at 12:04:36PM +0400, Dmitry Monakhov wrote:
> > > In fact this is my fault that we still not have autotest for that.
> > > I'm think of add crash-test to xfstests which should trigger journal
> > > abort and forced umount. Later test should mount FS which trigger
> > > journal_replay and orphan_cleanup.
> > 
> > We could create some tests in xfstests which force a crash via "echo b
> > > /proc/sysrq-trigger", but the trick is would require xfstests to
> > install something in the /etc/rc scripts so xfstests could resume
> > right after it came back --- and perhaps to echo something to the
> > console which automated test runners (such as the one I use which I've
> > published at [1] could capture so they would know that they should
> > restart the system.
> > 
> > [1] git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
> > 
> > For now the simplest way to test this is to use the file system image
> > in tests/f_orphan_extents_inode/image.gz, and make this be an
> > ext4-specific test.  This is how I tested it when I created my fix (in
> > parallel with Zheng's patch).  The compressed file system image is
> > only 564 bytes --- and was made deliberately w/o a journal so it could
> > be that small --- and the lack of a journal was how I found the
> > infinite loop problem which was fixed in the 2/2 patch in my patches.
> > So including this compressed fs image in xfstests is probably the way
> > I would suggest for now.
> 
> Just implement XFS_IOC_GOINGDOWN. That way xfstests will immediately
> support shutting down the filesystem via the src/godown utility.
> The default XFS behaviour is to freeze the filesystem, then do a
> forced shutdown on it, though it can also just trigger shutdowns
> with and without first flushing the journal.
Actually I want to emulate device failure this allow us to test
following scenarios
1) unsafe usb dongle unplug(test system survival)
2) power failure(
Our 'improved' loop device (http://wiki.openvz.org/Ploop) has
/sys/block/ploop0/make-it-fail  knob which explicitly fail blkdevice
Once failed it return EIO on all requests. I would like add this 
feature in generic loop device.
> 
> i.e.  it sounds like test 121 is pretty much what you are describing
> here...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
