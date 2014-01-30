From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [INSANE RFC PATCH 0/2] e2fsck metadata prefetch
Date: Thu, 30 Jan 2014 15:50:45 -0800
Message-ID: <20140130235044.31064.38113.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23884 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaA3Xuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jan 2014 18:50:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a patchset that tries to reduce e2fsck run times by pre-loading
ext4 metadata concurrent with e2fsck execution.  The first patch
implements a mmap-based IO manager that mmaps the underlying device
and uses a simple memcpy to read and write data.  The second patch
extends libext2fs and e2fsck to have a prefetch utility.  If the mmap
IO manager is active, the prefetcher spawns a bunch of threads
(_NPROCESSORS_ONLN by default) which scan semi-sequentially across the
disk trying to fault in pages before the main e2fsck thread needs the
data.

(If the unix IO manager is active, it settles for forking and using
the regular read calls to pull the metadata into the page cache.  My
efforts have concentrated almost entirely on the threaded mmap
prefetch.)

Each prefetch thread T, of N threads total, reads the directory
blocks, extent tree blocks, and inodes of the group (T + (N * i));
it's hoped that this will keep the IO queues saturated with requests
for fairly close-by data.  Obviously, the success of this scheme also
depends on having enough free memory that things stick around in
memory long enough for e2fsck to visit.  MADV_WILLNEED might help; I
haven't tried this yet.

Crude testing has been done via:
# echo 3 > /proc/sys/vm/drop_caches
# PREFETCH=1 TEST_MMAP_IO=1 /usr/bin/time ./e2fsck/e2fsck -Fnfvtt /dev/XXX

So far in my crude testing on a cold system, I've seen about a 15-20%
speedup on a SSD, a 10-15% speedup on a 3x RAID1 SATA array, and maybe
a 5% speedup on a single-spindle SATA disk.  On a single-queue USB
HDD, performance regresses some 200% as the disk thrashes itself
towards an early grave.  It looks as though in general, single-spindle
HDDs will suffer this effect, which doesn't surprise me.  I've not had
time to investigate if having a single prefetch thread yields any
advantage.

On a warm system the speedups are much more modest -- 5% or less in
all cases (except the USB HDD, which still sucks).

There's also the minor problem that e2fsck will crash in malloc as
soon as it tries to make any changes to the disk.  So far this means
that we're limited to quick preening, but I'll work on fixing this.

I've tested these e2fsprogs changes against the -next branch as of
1/16.  These days, I use an 8GB ramdisk and a 20T "disk" I constructed
out of dm-snapshot to test in an x64 VM.  The make check tests should
pass.

Comments and questions are, as always, welcome.

--D
