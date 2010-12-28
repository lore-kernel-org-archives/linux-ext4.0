From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Uneven load on my raid disks.
Date: Tue, 28 Dec 2010 10:07:49 +0100
Message-ID: <20101228090749.GB1351@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:57111 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752156Ab0L1JHv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Dec 2010 04:07:51 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I have a big filesystem (4x2Tb RAID5 = 6Tb.). 

I have a shitload (*) of files on there.  4 days ago, I decided I
wanted to clean up some disk space, and ordered an rm -rf of some 110
directories with a subset of that shitload of files. If I do one rm
-rf, it will do everything linearly: read one directory from one disk,
read the inodes from another disk, read the required bitmpas from the
next disk, remove the file. Only the write backs of the just-cleared
inodes and the writeback of the bitmaps would be exectued in parallel.

So that's why I started the remove of these 110 directories in
parallel: to keep my 4 disks busy. About 1.5 times the number of disks
that I have would have been optimal, but I thought I wouldn't incur
too much of a penalty by starting all of them together. In any case it
would be done the next morning..... 4 days and counting, almost a Tb
freed...

However, it seems that it is NOT keeping all of my four disks busy: 
according to iostat my "sdb" disk is executing about 10 times more
reads than the other drives, and it is therefore the performance
bottleneck of the whole operation.

This would mean that all of the inodes or all of the bitmaps are on my
"sdb" disk. This sounds reasonable if I forgot to tell mke2fs that
this was a raid. I don't think I forgot... How can I check that this
is the case?

http://www.goplexian.com/2010/09/6-tips-for-improving-hard-drive.html

says: 
dumpe2fs -h /dev/md0 | grep RAID

should show wether my ext4 partition is on a RAID. Well mine is, but
doesn't provide any output. Did I forget those raid-options during
formatting? Can this be tuned after the fact?

dumpe2fs without -h takes a long time. I just stopped all rm processes
and now only dumpe2fs is running. It seems to be causing about 10times
more load on sdb than on the other drives. strace shows that it is in
a loop where it seeks/reads. It is alternating reads of 4k and 280
bytes.


	Roger. 

(*) Guess high, then multiply by ten. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
