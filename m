From: Nick Dokos <nicholas.dokos@hp.com>
Subject: e2fsprogs 1.41.7 (pu branch) basic sanity checks
Date: Mon, 06 Jul 2009 15:42:57 -0400
Message-ID: <8653.1246909377@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25724 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZGFTmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 15:42:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran mkfs/e2fsck/mount/df on a 32-TB filesystem (built on LVM) with
the bits from the pu branch: no problems so far (other than
reporting problems - e.g. memory usage by e2fsck).

Here is the output:

$ sudo time mke2fs -q -t ext4 -O ^resize_inode -E stride=32,stripe-width=512 /dev/mapper/bigvg-bigvol
63.48user 707.05system 12:55.70elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
720inputs+1026586096outputs (3major+317165minor)pagefaults 0swaps

$ sudo time e2fsck -t -t -F -n -f /dev/mapper/bigvg-bigvol
e2fsck 1.41.7 (29-June-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 292k/18014398507629424k (84k/209k), time:  6.42/ 4.52/ 1.89
Pass 1: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 292k/18014398508200200k (84k/209k), time:  0.90/ 0.43/ 0.47
Pass 2: I/O read: 1MB, write: 0MB, rate: 1.11MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 292k/18014398508450540k (84k/209k), time: 11.93/ 8.75/ 3.16
Pass 3: Memory used: 292k/18014398508200200k (84k/209k), time:  0.28/ 0.12/ 0.16
Pass 3: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 292k/1520628k (84k/209k), time: 70.28/70.14/ 0.12
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 292k/1270288k (84k/209k), time: 1228.84/1222.10/ 1.02
Pass 5: I/O read: 62MB, write: 0MB, rate: 0.05MB/s
/dev/mapper/bigvg-bigvol: 11/2050768896 files (0.0% non-contiguous), 128808243/8203075584 blocks
Memory used: 292k/1270288k (84k/209k), time: 1311.06/1300.99/ 4.32
I/O read: 77MB, write: 0MB, rate: 0.06MB/s
1300.99user 4.49system 21:51.24elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
166848inputs+0outputs (4major+1668023minor)pagefaults 0swaps


# mount /dev/mapper/bigvg-bigvol /ext4.1
# cd /ext4.1
# df .
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/bigvg-bigvol
                     32297200456    131092 30656454248   1% /ext4.1

Nick
