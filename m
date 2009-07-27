From: Nick Dokos <nicholas.dokos@hp.com>
Subject: e2fsck results on a 96TB fs.
Date: Mon, 27 Jul 2009 12:12:07 -0400
Message-ID: <8735.1248711127@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:60380 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZG0QMP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jul 2009 12:12:15 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KNG0061X7O1WKHT@vms173019.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Mon, 27 Jul 2009 11:12:02 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is with 2.6.31-rc4 (and some necessary DM fixes - I got those
from agk's tree last Friday - they *may* be in mainline
by now). e2fsprogs was current as of late last week.

The machine is an HP DL585g5 w/16 cpus (4 slots, quad-core AMD) 128 GiB
of memory and 28*12 300GB disks (12 RAID arrays, each w/28 disks). The
RAID arrays export 48 2TB volumes, striped at 128KiB, which are then
built into a single device through LVM.

The filesystem was created with

mke2fs -t ext4 -O ^resize_inode -E stride=32,stripe-width=1536 /dev/mapper/bigvg-bigvol

It took about 10 mins, I think. I'll try to remember to time it
more carefully next time.

There were no problems creating or checking the filesystem. In between
I ran some streaming write tests, which created 12 1-TiB files, so the
filesystem was 14% full at the time of the check:

,----
| Filesystem           1K-blocks      Used Available Use% Mounted on
| /dev/mapper/bigvg-bigvol
|                      97357136472 12885034268 79550256856  14% /mnt
`----

The check took about 15 minutes (I ran the fsck under screen, which
produces the bash time stamps):

,----
| sudo time e2fsck  -t -t -F -n -f /dev/mapper/bigvg-bigvol
| e2fsck 1.41.8 (20-Jul-2009)
| Pass 1: Checking inodes, blocks, and sizes
| -- 0:bash -- time-stamp -- Jul/27/09  1:27:50 --
| Pass 1: Memory used: 292k/1630432k (86k/207k), time: 117.71/111.20/ 4.97
| Pass 1: I/O read: 2MB, write: 0MB, rate: 0.02MB/s
| Pass 2: Checking directory structure
| Pass 2: Memory used: 292k/18014398508112056k (86k/207k), time:  1.86/ 0.87/ 0.99
| Pass 2: I/O read: 1MB, write: 0MB, rate: 0.54MB/s
| Pass 3: Checking directory connectivity
| Peak memory: Memory used: 292k/18014398508635716k (86k/207k), time: 129.61/119.81/ 8.25
| Pass 3: Memory used: 292k/18014398508112056k (86k/207k), time:  0.60/ 0.25/ 0.34
| Pass 3: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
| Pass 4: Checking reference counts
| -- 0:bash -- time-stamp -- Jul/27/09  1:29:50 --
| Pass 4: Memory used: 292k/18014398509394812k (85k/208k), time: 149.35/149.02/ 0.31
| Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
| Pass 5: Checking group summary information
| -- 0:bash -- time-stamp -- Jul/27/09  1:32:20 --
| -- 0:bash -- time-stamp -- Jul/27/09  1:39:48 --
| Pass 5: Memory used: 292k/18014398508871152k (86k/207k), time: 564.86/355.92/ 5.54
| Pass 5: I/O read: 568MB, write: 0MB, rate: 1.01MB/s
| /dev/mapper/bigvg-bigvol: 23/4289791968 files (0.0% non-contiguous), 3491201201/24609226752 blocks
| Memory used: 292k/18014398508871152k (86k/207k), time: 843.88/624.75/14.15
| I/O read: 615MB, write: 0MB, rate: 0.73MB/s
| 624.75user 15.19system 14:04.92elapsed 75%CPU (0avgtext+0avgdata 0maxresident)k
| 4918216inputs+0outputs (4major+4403047minor)pagefaults 0swaps
| # -- 0:bash -- time-stamp -- Jul/27/09  1:41:41 --
`----

The 12 1-TiB files have about 8600 extents each according to filefrag:

,----
| # filefrag /mnt/str*
| /mnt/stream-write-128k-4.1.0: 8438 extents found
| /mnt/stream-write-128k-8.2.0: 8662 extents found
| /mnt/stream-write-1m-4.7.0: 8698 extents found
| /mnt/stream-write-1m-8.8.0: 8658 extents found
| /mnt/stream-write-256k-4.3.0: 8639 extents found
| /mnt/stream-write-256k-8.4.0: 8600 extents found
| /mnt/stream-write-2m-4.9.0: 8579 extents found
| /mnt/stream-write-2m-8.10.0: 8535 extents found
| /mnt/stream-write-4m-4.11.0: 8563 extents found
| /mnt/stream-write-4m-8.12.0: 8422 extents found
| /mnt/stream-write-512k-4.5.0: 8679 extents found
| /mnt/stream-write-512k-8.6.0: 8714 extents found
`----

It's going to take a little while, but I'm planning to fill up the fs
and run fsck again.

Thanks,
Nick



