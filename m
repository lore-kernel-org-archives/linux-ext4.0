From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6 -v2] Optimize e2fsck for large file systems
Date: Mon, 26 Nov 2012 11:39:34 -0500
Message-ID: <1353947981-15219-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34884 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab2KZQjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 11:39:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As requested on the ext4 conference call, here is an updated release of
the e2fsck optimization patch series.


This patch series optimizes e2fsck for large file systems (where large
is 4TB or more).  Previously checking a 4TB file system when it was
mostly full could take upwards of 3 minutes of wall clock time, and
e2fsck would be mostly CPU bound.  With this patch series, the same 4TB
file system can now be checked in less than 50 seconds and approximately
20 seconds of userspace CPU time.   (Previously, it was consuming over
8 times as much CPU time.)

The speed ups come in three places:

1)  Reducing the CPU time while reading the block bitmap in from disk.
    This was done by speeding up rb_set_bmap_range, and it significantly
    improves e2fsck's pass 5 operation.

2)  Reducing the CPU time in e2fsck pass1 while constructing the
    block_found_map (which is the in-core block allocation bitmap as
    found by interating over all of the inodes).

3)  Further speed up e2fsck's pass 5 by comparing the block allocation
    bitmap one bitmap block at a time, instead of a bit-at-a-time.

Before....

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 916k/31500k (719k/198k), time: 96.48/81.26/ 0.10
Pass 1: I/O read: 8MB, write: 0MB, rate: 0.08MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 916k/62064k (704k/212k), time:  0.46/ 0.01/ 0.03
Pass 2: I/O read: 4MB, write: 0MB, rate: 8.72MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 916k/62064k (705k/212k), time: 97.56/81.88/ 0.13
Pass 3A: Memory used: 916k/62064k (736k/181k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 916k/62064k (693k/223k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 1257.86MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 916k/936k (602k/315k), time:  6.59/ 6.55/ 0.02
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 1048k/936k (569k/480k), time: 93.39/80.92/ 0.69
Pass 5: I/O read: 117MB, write: 0MB, rate: 1.25MB/s
Memory used: 1048k/936k (569k/480k), time: 197.58/169.36/ 0.84
I/O read: 129MB, write: 0MB, rate: 0.65MB/s
169.36user 0.90system 3:17.66elapsed 86%CPU (0avgtext+0avgdata 254192maxresident)k
0inputs+0outputs (12major+16066minor)pagefaults 0swaps

.... and after....

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 916k/31500k (719k/198k), time: 17.83/ 2.79/ 0.05
Pass 1: I/O read: 8MB, write: 0MB, rate: 0.45MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 916k/62064k (704k/212k), time:  0.45/ 0.01/ 0.01
Pass 2: I/O read: 4MB, write: 0MB, rate: 8.82MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 916k/62064k (704k/212k), time: 18.89/ 3.39/ 0.07
Pass 3A: Memory used: 916k/62064k (735k/181k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 916k/62064k (693k/224k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 1265.82MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 916k/936k (601k/315k), time:  5.69/ 5.67/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 1048k/936k (569k/480k), time: 22.76/10.49/ 0.53
Pass 5: I/O read: 117MB, write: 0MB, rate: 5.14MB/s
Memory used: 1048k/936k (569k/480k), time: 47.38/19.57/ 0.60
I/O read: 129MB, write: 0MB, rate: 2.72MB/s

For slower CPU's (i.e., bookshelf NAS servers with underpowered, wimpy
ARM processors) or for larger RAID arrays, the speed ups would of course
be even better.


Theodore Ts'o (6):
  libext2fs: optimize rb_set_bmap_range()
  e2fsck: optimize pass1 for CPU time
  libext2fs: add ext2fs_bitcount() function
  libext2fs: optimize rb_get_bmap_range()
  libext2fs: optimize rb_get_bmap_range() for mostly allocated bmaps
  e2fsck: optimize pass 5 for CPU utilization

 e2fsck/pass1.c              | 18 ++++++++-
 e2fsck/pass5.c              | 55 ++++++++++++++++++++++++-
 lib/ext2fs/bitops.c         | 35 ++++++++++++++++
 lib/ext2fs/bitops.h         |  1 +
 lib/ext2fs/blkmap64_rb.c    | 76 +++++++++++++++++++++++++----------
 lib/ext2fs/tst_bitmaps.c    |  1 +
 lib/ext2fs/tst_bitmaps_cmds | 42 ++++++++++++++++++++
 lib/ext2fs/tst_bitmaps_exp  | 97 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 301 insertions(+), 24 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

