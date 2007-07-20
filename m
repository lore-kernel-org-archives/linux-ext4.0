From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck bogus error report on orphan-list
Date: Fri, 20 Jul 2007 00:10:52 -0400
Message-ID: <20070720041052.GD26752@thunk.org>
References: <873azkl7x4.wl%ryoichi@me.sony.co.jp> <20070719165510.GB14815@thunk.org> <87fy3krnet.wl%ryoichi@me.sony.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	tim.bird@am.sony.com
To: Ryoichi KATO <Ryoichi.Kato@jp.sony.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51612 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbXGTEK6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 00:10:58 -0400
Content-Disposition: inline
In-Reply-To: <87fy3krnet.wl%ryoichi@me.sony.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2007 at 08:20:26AM +0900, Ryoichi KATO wrote:
> > >    1. Delete a file in an ext3 filesystem in early 1970
> > 
> > Dare I ask *why* the system clock was set in the 1970's?  Umm... don't
> > do that.
> 
> As Tim pointed out, embedded devices offten omit RTC battery.

Yes, I added the busted_fs_clock specifically to handle this.

> > There is code that detects when the time is set back in the 1970's
> > (normally due to a bad clock battery) and thus disables this
> > particular check.  So it only triggers when the clock was previously
> > bad, and is now good.
> 
> Actually, it's a *real* problem happend for my car navigation product.
> Until GPS signal is available, it's clock was 1970.
> And for servers and PCs, it's possible that RTC backup battery run out,
> then clock get set correctly afterward by, say, NTP.

Sure, but we have checks to detect if the last superblock write *or*
last mount time is before 1970, and if so, we declare the filesystem
has having a busted/insane system clock, and and we disable the
dtime/orphaned inode checks.  This in practice is plenty since it
means that the mount-time is in the 1970's, and then when NTP sets the
time, we're fine, since that's generally after the e2fsck and the
mount of the filesystem.  

So for it to trigger it requires a very strange set of modulations of
the time.  You need to have time be correct at the time of the mount
(so s_mtime is sane, implying that the RTC backup battery is not
dead), and *then* reset to the 1970's, delete some files, then be
correct when the filesystem is unmounted (so s_wtime is sane).  That's
pretty hard to accomplishl; and I would submit, even on embedded
systems.  The system clock must be crazily warping back and forth
between correct time and 1970's/insane time in order for this to be an
issue.  

This has been true since e2fsprogs 1.38, released June 30, 2005;
before that point we only checked s_wtime for sanity, and we did have
a few cases slip through, but ever since I added the s_wtime check, I
haven't had anyone report a problem until now.  (Although if people
don't e-mail me, and just do conference presentations, I'd have no way
of finding out unless I was lucky enough to attend the conference.  :-)

>  * It is very difficult to relate RTC to the problem.
>    No clue without digging into e2fsck source code.

Yes.  As I said, it might be a good idea to add an
unreliable_system_time config parameter to e2fsck in the future to
catch this case.  That would also document the issue to avoid future
people from running into this.

>  * -p (preen) option of e2fsck doen't fix it automatically.
>    Though I'm not sure but, maybe it's safe to correct the
>    problem automatically?

Yes, but this was deliberate; if there was a bug in the kernel's
orphan handling code, I really wanted to know about it, and if it was
just -p, most folk would never know.  (Although if there were orphan
list handling bugs, it could cause some truncates would not be
reliably replayed, so it might cause even **harder** to diagnose bugs.
Life is always full of tradeoffs.)

							- Ted
