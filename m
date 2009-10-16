From: Theodore Tso <tytso@mit.edu>
Subject: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Fri, 16 Oct 2009 05:15:58 -0400
Message-ID: <20091016091558.GA10184@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Parag Warudkar <parag.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53745 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbZJPJQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2009 05:16:38 -0400
Content-Disposition: inline
In-Reply-To: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2009 at 12:28:18AM -0400, Parag Warudkar wrote:
> So I have been experimenting with various root file systems on my
> laptop running latest git. This laptop some times has problems waking
> up from sleep and that results in it needing a hard reset and
> subsequently unclean file system.

A number of people have reported this, and there is some discussion
and some suggestions that I've made here:

	http://bugzilla.kernel.org/show_bug.cgi?id=14354

It's been very frustrating because I have not been able to replicate
it myself; I've been very much looking for someone who is (a) willing
to work with me on this, and perhaps willing to risk running fsck
frequently, perhaps after every single unclean shutdown, and (b) who
can reliably reproduce this problem.  On my system, which is a T400
running 9.04 with the latest git kernels, I've not been able to
reproduce it, despite many efforts to try to reproduce it.  (i.e.,
suspend the machine and then pull the battery and power; pulling the
battery and power, "echo c > /proc/sysrq-trigger", etc., while
doing "make -j4" when the system is being uncleanly shutdown)

So if you can come up with a reliable reproduction case, and don't
mind doing some experiments and/or exchanging debugging correspondance
with me, please let me know.  I'd **really** appreciate the help.

Information that would be helpful to me would be:

a) Detailed hardware information (what type of disk/SSD, what type of
laptop, hardware configuration, etc.)

b) Detailed software information (what version of the kernel are you
using including any special patches, what distro and version are you
using, are you using LVM or dm-crypt, what partition or partitions did
you have mounted, was the failing partition a root partition or some
other mounted partition, etc.)

c) Detailed reproduction recipe (what programs were you running before
the crash/failed suspend/resume, etc.)


If you do decide to go hunting this problem, one thing I would
strongly suggest is that either to use "tune2fs -c 1 /dev/XXX" to
force a fsck after every reboot, or if you are using LVM, to use the
e2croncheck script (found as an attachment in the above bugzilla entry
or in the e2fsprogs sources in the contrib directory) to take a
snapshot and then check the snapshot right after you reboot and login
to your system.  The reported file system corruptions seem to involve
the block allocation bitmaps getting corrupted, and so you will
significantly reduce the chances of data loss if you run e2fsck as
soon as possible after the file system corruption happens.  This helps
you not lose data, and it also helps us find the bug, since it helps
pinpoint the earliest possible point where the file system is getting
corrupted.  

(I suspect that some bug reporters had their file system get corrupted
one or more boot sessions earlier, and by the time the corruption was
painfully obvious, they had lost data.  Mercifully, running fsck
frequently is much less painful on a freshly created ext4 filesystem,
and of course if you are using an SSD.)

If you can reliably reproduce the problem, it would be great to get a
bisection, or at least a confirmation that the problem doesn't exist
on 2.6.31, but does exist on 2.6.32-rcX kernels.  At this point I'm
reasonably sure it's a post-2.6.31 regression, but it would be good to
get a hard confirmation of that fact.

For people with a reliable reproduction case, one possible experiment
can be found here:

   http://bugzilla.kernel.org/show_bug.cgi?id=14354#c18

Another thing you might try is to try reverting these commits one at a
time, and see if they make the problem go away: d0646f7, 5534fb5,
7178057.  These are three commits that seem most likely, but there are
only 93 ext4-related commits, so doing a "git bisect start v2.6.31
v2.6.32-rc5 -- fs/ext4 fs/jbd2" should only take at most seven compile
tests --- assuming this is indeed a 2.6.31 regression and the problem
is an ext4-specific code change, as opposed to some other recent
change in the writeback code or some device driver which is
interacting badly with ext4.

If that assumption isn't true and so a git bisect limited to fs/ext4
and fs/jbd2 doesn't find a bad commit which when reverted makes the
problem go away, we could try a full bisection search via "git bisect
start v2.6.31 v2.6.31-rc3", which would take approximately 14 compile
tests, but hopefully that wouldn't be necessary.

I'm going to be at the kernel summit in Tokyo next week, so my e-mail
latency will be a bit longer than normal, which is one of the reason
why I've left a goodly list of potential experiments for people to
try.  If you can come up with a reliable regression, and are willing
to work with me or to try some of the above mentioned tests, I'll
definitely buy you a real (or virtual) beer.

Given that a number of people have reported losing data as a result,
it would **definitely** be a good thing to get this fixed before
2.6.32 is released.

Thanks,

						- Ted
