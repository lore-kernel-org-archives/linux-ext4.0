From: Gary Hawco <ghawco@cox.net>
Subject: Gentoo with ext4-patch-queue snapshots
Date: Tue, 01 Jul 2008 17:50:11
Message-ID: <3.0.6.32.20080701175011.02437350@pop.west.cox.net>
References: <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net> <1214953235.6940.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:46163 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684AbYGBAuM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 20:50:12 -0400
In-Reply-To: <1214953235.6940.37.camel@mingming-laptop>
References: <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
 <3.0.6.32.20080701000046.025249e0@pop.west.cox.net>
 <3.0.6.32.20080701105417.01ce4958@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming,

Can you post that patch somewhere for download? I access my email using
Windows Vista, not in linux, so it would be very laborious to hand copy
this patch and recreate it in linux.

Updated the 2.6.26-rc8 kernel with the latest snapshot from today at
1833hrs GMT. All hell broke loose in Gentoo, The new kernel wouldn't allow
the system to remount read/write on boot.  But it worked fine in Slackware.
Gentoo with the experimental openrc-0.2.5 and baselayout2 apparently does
not like ext4.

And for clarification, the patch you sent me is not yet in the queue?

So to summarize my recent (as of the last seven days of snapshots) saga
with ext4-queue-patch in Gentoo

Through 062508/0019hrs no problems (although I do not believe delalloc was
enabled)
>From 062608/0042 - 062708/2353hrs had segfaulting when copying and tarring
small files. No other detectable issues.
>From 063008/1704 - 063008/2219hrs --no segfaulting but data corruption in
one initiation file causing network interfaces to have to be manually
activated. No data corruption if delalloc disabled
latest snapshot 070108/1833hrs --system unable to be remounted read/write
after fsck check.  Manually booted to livecd with e2fsprogs-1.41WIP
(17-June-2008). Efsck shows no filesystem problems.
Rolling back to 063008/2219 snapshot fixes boot problems. No segfaulting.
No data corruption IF delalloc disabled.

Thanks,
Gary

