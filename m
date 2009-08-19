From: Marcin Miroslaw <spam_trap@kolekcja.mejor.pl>
Subject: fsck.ext4 -D corrupts fs?
Date: Wed, 19 Aug 2009 22:13:14 +0200
Message-ID: <h6hmcr$hqi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39138 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbZHSWFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 18:05:46 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MdsZg-0004oE-6R
	for linux-ext4@vger.kernel.org; Wed, 19 Aug 2009 23:20:04 +0200
Received: from cust-194-54-191-238.flashnet.pl ([194.54.191.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 23:20:04 +0200
Received: from spam_trap by cust-194-54-191-238.flashnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 23:20:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
I've noticed fs curruption after using fsck.ext4 -D
## uname -a
Linux dom 2.6.30-gentoo-r5 #1 SMP Wed Aug 19 20:38:18 CEST 2009 x86_64
Intel(R) Core(TM)2 CPU 4300 @ 1.80GHz GenuineIntel GNU/Linux


# mkfs.ext4 -q -L tmp2 -i 2048 -m 2 /dev/sdb11
# mount /dev/sdb11 /mnt/gentoo/
# rsync -aX / /mnt/gentoo/
# umount /mnt/gentoo
# LANGUAGE="en_US" fsck.ext4 -f /dev/sdb11
e2fsck 1.41.8 (11-July-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
tmp2: 216739/3909120 files (0.2% non-contiguous), 1335716/1953897 blocks

Everything is OK until next:
# LANGUAGE="en_US" fsck.ext4 -f -D /dev/sdb11
e2fsck 1.41.8 (11-July-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Failed to optimize directory /usr/share/man/man3 (96019): Extent not found
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (4, counted=3).
Fix<y>? yes

Free blocks count wrong for group #2 (5, counted=3).
Fix<y>? yes

Free blocks count wrong for group #4 (4, counted=3).
Fix<y>? yes

Free blocks count wrong for group #9 (6, counted=5).
Fix<y>? yes

Free blocks count wrong for group #11 (15, counted=13).
Fix<y>? yes

Free blocks count wrong (618219, counted=618212).
Fix<y>? yes


tmp2: ***** FILE SYSTEM WAS MODIFIED *****
tmp2: 216739/3909120 files (0.2% non-contiguous), 1335685/1953897 blocks

Fsck can't fix fs now (even run many times):

# LANGUAGE="en_US" fsck.ext4 -fy  /dev/sdb11
e2fsck 1.41.8 (11-July-2009)
Pass 1: Checking inodes, blocks, and sizes
HTREE directory inode 43092 has an invalid root node.
Clear HTree index? yes

HTREE directory inode 89999 has an invalid root node.
Clear HTree index? yes

Inode 96019, i_size is 208896, should be 225280.  Fix? yes

Inode 96019, i_blocks is 496, should be 416.  Fix? yes

HTREE directory inode 260626 has an invalid root node.
Clear HTree index? yes

HTREE directory inode 260630 has an invalid root node.
Clear HTree index? yes

HTREE directory inode 293397 has an invalid root node.
Clear HTree index? yes

Pass 2: Checking directory structure
Problem in HTREE directory inode 96019: node (51) not referenced
Problem in HTREE directory inode 96019: node (52) not referenced
Problem in HTREE directory inode 96019: node (53) not referenced
Problem in HTREE directory inode 96019: node (54) not referenced
Invalid HTREE directory inode 96019 (/usr/share/man/man3).  Clear HTree
index? yes

Pass 3: Checking directory connectivity
'..' in .../python2.6/test (43092) is <The NULL inode> (0), should be
.../python2.6 (260836).
Fix? yes


Couldn't fix parent of inode 43092: Couldn't find parent directory entry

'..' in /usr/share/idl/xulrunner-1.9.1.2/unstable (89999) is <The NULL
inode> (0), should be /usr/share/idl/xulrunner-1.9.1.2 (89997).
Fix? yes


Couldn't fix parent of inode 89999: Couldn't find parent directory entry

'..' in /usr/bin (260626) is <The NULL inode> (0), should be /usr (260610).
Fix? yes

Couldn't fix parent of inode 260626: Couldn't find parent directory entry

'..' in /usr/lib64 (260630) is <The NULL inode> (0), should be /usr
(260610).
Fix? yes


Couldn't fix parent of inode 260630: Couldn't find parent directory entry

'..' in .../mozilla-thunderbird/idl (293397) is <The NULL inode> (0),
should be .../mozilla-thunderbird (260823).
Fix? yes

Couldn't fix parent of inode 293397: Couldn't find parent directory entry

Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Inode 43092 ref count is 3, should be 2.  Fix? yes

Inode 89997 ref count is 4, should be 3.  Fix? yes

Inode 89999 ref count is 2, should be 1.  Fix? yes

Inode 260610 ref count is 14, should be 12.  Fix? yes

Inode 260626 ref count is 2, should be 1.  Fix? yes

Inode 260630 ref count is 73, should be 72.  Fix? yes

Inode 260823 ref count is 16, should be 15.  Fix? yes

Inode 260836 ref count is 23, should be 22.  Fix? yes

Inode 293397 ref count is 2, should be 1.  Fix? yes

Pass 5: Checking group summary information
Block bitmap differences:  -15480 -15484 -43618 -70438 -158694 -180514
-180585
Fix? yes

Free blocks count wrong for group #0 (3, counted=5).
Fix? yes

Free blocks count wrong for group #2 (3, counted=4).
Fix? yes

Free blocks count wrong for group #4 (3, counted=4).
Fix? yes

Free blocks count wrong for group #9 (5, counted=6).
Fix? yes

Free blocks count wrong for group #11 (13, counted=15).
Fix? yes

Free blocks count wrong (618212, counted=618219).
Fix? yes


tmp2: ***** FILE SYSTEM WAS MODIFIED *****

tmp2: ********** WARNING: Filesystem still has errors **********

tmp2: 216739/3909120 files (0.2% non-contiguous), 1335678/1953897 blocks


May i do something more to help You fix this problem?
With regards
Marcin Miroslaw

