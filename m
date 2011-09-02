From: Christian Kujau <lists@nerdbynature.de>
Subject: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed orphan
 inode list
Date: Fri, 2 Sep 2011 14:00:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:44071 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1IBVAy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Sep 2011 17:00:54 -0400
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 576B23DAD0
	for <linux-ext4@vger.kernel.org>; Fri,  2 Sep 2011 23:00:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 3FC423DA41
	for <linux-ext4@vger.kernel.org>; Fri,  2 Sep 2011 23:00:51 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

for some time now, the following message keeps pooping up in my logs:

 > EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed orphan 
 > inode list.  Please umount/remount instead

I don't know when it started. Maybe 2 months ago, I'd guess. The ext4 fs 
is on top of a dm-crypt device, attached via firewire to a 1TB external 
disk enclosure. The system (powerpc 32) is loosely following vanilla 
kernels, currently running 3.1.0-rc4.

The filesystem is normally mounted r/o but remounted r/w every day to 
receive backups, then remounted r/o again. Running e2fsck-1.41.12 with -n 
on the r/o-mounted devices gives the output below.

I've unmounted the disk some weeks ago, ran e2fsck for real and it fixed 
the errors. But now more errors seem to have occured.

Anyone got an idea why this keeps happening? Bad memory? Bad cables? Disk? 
No other hardware related errors are in the logs and the box is otherwise 
quite stable.

Thanks,
Christian.

-------------------------------------------------
# fsck.ext4 -vnf /dev/mapper/wdc0 
e2fsck 1.41.12 (17-May-2010)
Warning!  /dev/mapper/wdc0 is mounted.
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix? no

Inode 16385 was part of the orphaned inode list.  IGNORED.
Deleted inode 16439 has zero dtime.  Fix? no

Inode 2260993 was part of the orphaned inode list.  IGNORED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(9298--9299) -8921121
Fix? no

Inode bitmap differences:  -16385 -16439 -2260993
Fix? no

Directories count wrong for group #2 (72, counted=70).
Fix? no

Directories count wrong for group #276 (76, counted=75).
Fix? no

/dev/mapper/wdc0: ********** WARNING: Filesystem still has errors **********


  562145 inodes used (0.92%)
    3952 non-contiguous files (0.7%)
    2544 non-contiguous directories (0.5%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 555449/932
215226375 blocks used (88.14%)
       0 bad blocks
       5 large files

  353453 regular files
  202351 directories
       0 character device files
       0 block device files
       7 fifos
 2491335 links
    6235 symbolic links (5657 fast symbolic links)
      87 sockets
--------
 3053468 files

-- 
BOFH excuse #19:

floating point processor overflow
