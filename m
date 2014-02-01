From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH v2 0/3] e2fsck metadata prefetch
Date: Sat, 01 Feb 2014 02:37:21 -0800
Message-ID: <20140201103721.9011.5971.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaBAKh0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Feb 2014 05:37:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the second go at a patchset that tries to reduce e2fsck run
times by pre-loading ext4 metadata concurrent with e2fsck execution.
The first patch is Andreas Dilger's patch to add a readahead method to
the IO manager interface.  The second patch extends libext2fs with a
function call to invoke readahead on a list of blocks, and a second
call that invokes readahead on the bitmaps and inode tables of a bunch
of groups.  The third patch enhances e2fsck to start threads that call
the readahead functions.

Crude testing has been done via:
# echo 3 > /proc/sys/vm/drop_caches
# READAHEAD=1 /usr/bin/time ./e2fsck/e2fsck -Fnfvtt /dev/XXX

So far in my crude testing on a cold system, I've seen about a ~20%
speedup on a SSD, a ~40% speedup on a 3x RAID1 SATA array, and maybe
a 5% speedup on a single-spindle SATA disk.  On a single-queue USB
HDD, performance doesn't change much.  It looks as though in general,
single-spindle HDDs will not benefit, which doesn't surprise me.  The
SSD numbers are harder to quantify since they're already fast.

This second version of the patch uses posix_fadvise to hint to the
kernel that it really wants to have the blocks loaded in the page
cache ready to go.  This is much easier to manage, because all we need
to do is throw a list of blocks at it and let it go... and if we're
careful not to change any FS state, we can easily offload the
readahead work to a thread without weird crashes.

Note that this draft code does little to prevent page cache thrashing.
It doesn't hold back from issuing a large flood of IO.  It's not clear
if it's better to try to constrain how far the prefetcher gets ahead
of the checker code, or better to let the kernel sort it out.

I've tested these e2fsprogs changes against the -next branch as of
1/31.  These days, I use an 8GB ramdisk and whatever hardware I have
lying around.  The make check tests should pass.

Comments and questions are, as always, welcome.

--D
