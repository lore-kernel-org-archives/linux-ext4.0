From: Gary Hawco <ghawco@cox.net>
Subject: More ext4dev snapshot weirdness
Date: Tue, 01 Jul 2008 00:00:46
Message-ID: <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
References: <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net> <20080701023252.GA28143@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:61933 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYGAHAr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 03:00:47 -0400
In-Reply-To: <20080701023252.GA28143@mit.edu>
References: <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Did some more testing before replying.

Have two linux operating systems:

Both were setup identically, i.e, formatted with flex_bg & meta_bg. Tune2fs
used to enable uninit_bg. Ordered data mode. Grub used to pass boot
parameter of rootflags=commit=15. Fstab mount options of
noatime,nodiratime,journal_async_commit.

Slackware 12.1--this one uses its BSD style startup scripts. No problems
whatsoever with any of the snapshots including the newest from 30 June
2008/2219hrs.

Gentoo --this is the system I am having trouble with.

It will boot the snapshot from 062508/0019hrs fine.  Everything works fine
here including my script that updates the portage/metadata trees, copies
them to another partition setup identically with ext4dev, i.e. flex_bg,
meta_bg & uninit_bg, then creates a tarball.

All of the snapshots after the 062508 timestamp through the 062708/2353hrs.
snapshot would segfault running this script.  (Looking for a digital
camera, that uses flash media that windows or linux will recognize so I can
save and post the jpeg image)

Starting with today's snapshots rebased against 2.6.26-rc8 kernel a new
problem surfaced, and the old segfault issues disappeared.  That is, I
could run my script without any problems.

My Gentoo uses an updated baselayout/OpenRC start configuration.  It has a
/lib/rc folder as opposed to var/lib/init.d, containing several subfolders,
such as /lib/rc/init.d which cache dependencies and make for a very fast
boot and shutdown.

With today's snapshots I get one clean start, then I get errors where the
network interface eth0 does not initialize on startup but can manually be
pulled in by "dhcpcd eth0".  If I delete the contents of /lib/rc/init.d on
the next restart the network interface initializes properly.

If I roll back to the 062508 kernel snapshot, this new problem goes away.

I tried removing journal_async_commit from fstab mount options without any
difference.  I was also passing rootflags=commit=15 during bootup with
grub. I removed that parameter changing back to the default 5 second commit
interval without any improvement.  This new startup style uses parallel
service starts. I changed back to series starting without any improvement.
I even tried switching from ordered data mode to writeback mode without
success.

So if I haven't thoroughly confused you or put you to sleep, to summarize:

Slackware loves all the snapshots.

Gentoo was fine through 062508/00119hrs. No problems. From 062608/0042hrs -
062708/2353 snapshots boot sequence was fine, but segfaulting running my
portage/metadata backup script (lots of small files).

Today's updates rebased against 2.6.26-rc8 are NOT segfaulting running the
backup script, but seem to be corrupting the /lib/rc/init.d/database files
after the first start.

I am willing to bet that Gentoo on the old baselayout/Non open-rc startup
up scripts would have no problems ala Slackware, but it's curious
everything was fine through the 062508/0019GMT snapshot. It seems that once
delalloc was brought back in with ordered data mode problems started to
arise. I tried to roll back the baselayout v2 to the older version 1.12,
but I broke the os and had to quickly reinstall using a recent tarball.
It's the only explanation why Gentoo is having problems, but Slackware is
not. And now that today with the latest rc-8 snapshots the initialization
of devices during startup is getting fubared, I am certain the
Baselayout2/open-rc-2.5 does not like the latest iterations of the
ext4-patch-queue kernel.

Hope this expose sheds some light on things.

Thanks again,
Gary


