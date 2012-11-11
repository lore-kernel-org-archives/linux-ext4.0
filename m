From: "George Spelvin" <linux@horizon.com>
Subject: How full should the inode table be?
Date: 11 Nov 2012 04:55:12 -0500
Message-ID: <20121111095512.6396.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:17145 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967Ab2KKJzO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 04:55:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have an ext4 file system which was formatted with the default number
of bytes per inode, leading to a lot of wasted inodes:

Filesystem      1K-blocks       Used  Available Use% Mounted on
/dev/md0       9728762072 6902736072 2337647668  75% /data
Filesystem        Inodes   IUsed     IFree IUse% Mounted on
/dev/md0       152619008 2012348 150606660    2% /data

Now, it turns out that I have to rebuild it with 64-bit block numbers
in order to grow it past 16 TB (wow, was *that* a nasty surprise),
and I intend to use a somewhat saner bytes/inode ratio.

(Ignoring the slight space gain, fewer inodes means faster e2fsck.)

Now, the current data, which is a decent model for future data, is
running 3512514 bytes/inode.

I could just use that, so the FS will run out of data blocks at about
the same time as it runs out of inodes, but I wonder: does the FS benefit
from more slack in inode allocation?

Given that accessing all the inodes in a directory is much more common
than scanning all the data in a directory, perhaps reducing fragmentation
in the inode table has a significant performance benefit.

I.e. perhaps an 80% full inode table causes more problems than an 80%
full disk, and I should try to leave more free space.

Allocating 2x the inodes I think I'll need doesn't cost very much,
after all.  256 additional bytes of inode per 3512514 bytes is only 0.007%
overhead, after all.


STFWing a bit, I see lots of people applying fidge factors of from 1.2
to 4 to the measured bytes/inode to get the -i argument.  But I don't
see any real justification for the numbers.
Any advice?

Many thanks!
