From: Christian Ohm <chr.ohm@gmx.net>
Subject: How to recover a damaged ext4 file system?
Date: Mon, 5 Jan 2009 14:53:47 +0100
Message-ID: <20090105135347.GA3337@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45102 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753905AbZAENxw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 08:53:52 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

Since ext4 had its development status removed in 2.6.28, and there seemed to be
no reports of serious problems, I decided to try it on a partition of
semi-important files. Well, after a hard system hang because of the (open
source Radeon) graphics driver, the file system is quite corrupted, and cannot
be mounted any more (that never happened with ext3). mount gives the following
error:

mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

dmesg message:

EXT4-fs: ext4_check_descriptors: Block bitmap for group 0 not in group (block 727012683)!
EXT4-fs: group descriptors corrupted!

I have uploaded the output of fsck .ext4 -n at
http://www.filefactory.com/file/aff6f3g/n/fsck_ext4_bz2 which is over 6MB of
stuff like

---
e2fsck 1.41.3 (12-Oct-2008)
fsck.ext4: Group descriptors look bad... trying backup blocks...
Block bitmap for group 0 is not in group.  (block 727012683)
Relocate? no

Inode bitmap for group 0 is not in group.  (block 3406175899)
Relocate? no

Inode table for group 0 is not in group.  (block 1236188664)
WARNING: SEVERE DATA LOSS POSSIBLE.
Relocate? no

Group descriptor 0 checksum is invalid.  Fix? no

Block bitmap for group 1 is not in group.  (block 2704710215)
Relocate? no

Inode bitmap for group 1 is not in group.  (block 2166870417)
Relocate? no

Inode table for group 1 is not in group.  (block 600148394)
WARNING: SEVERE DATA LOSS POSSIBLE.
Relocate? no

Group descriptor 1 checksum is invalid.  Fix? no
---

and later

---
Group descriptor 7452 checksum is invalid.  Fix? no

Error reading block 1236188664 (Invalid argument).  Ignore error? no

data-1000 contains a file system with errors, check forced.
Error reading block 1236188664 (Invalid argument).  Ignore error? no

fsck.ext4: Invalid argument while reading bad blocks inode
This doesn't bode well, but we'll try to go on...
Pass 1: Checking inodes, blocks, and sizes
Illegal block number passed to ext2fs_test_block_bitmap #1236188664 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #1236188664 for in-use block map
---


Now as I said, the files are semi-important, meaning I could recover those I
still want with some time, but repairing the file system would be preferable.
Unfortunately I don't have enough space on another harddrive to just copy the
partition and experiment on that, so I haven't tried letting fsck repair the fs
yet, and since it says SEVERE DATA LOSS POSSIBLE I wouldn't like to try that
without copying first.

So my two main questions would be:

1. How can I recover the data on the file system? As I said, I don't need all
the files, but it would save some time. I created it with the mkfs.ext4 from
Debian unstable (1.41.3) with only largefile as extra option, and the default
mount options with kernel 2.6.28. The fs wasn't used for long, and I mostly
copied/created files, without deleting much.

2. Is this corruption a fault of ext4? I guess this is difficult to answer, but
I had ext3 survive any lockups without much problems. So far ext4 seems not
quite that robust, but perhaps another file system would have blown up as well
in this situation. Is there any information I can give you to help make ext4
more robust?

Best regards,
Christian Ohm

PS: I think my first post with the fsck output attached got rejected due to its
size, though I didn't receive a message about that.
