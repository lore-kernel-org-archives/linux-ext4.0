From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/32] e2fsprogs patchbomb 2/14
Date: Sat, 01 Mar 2014 23:16:39 -0800
Message-ID: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44148 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaCBHQo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:16:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Well it's been a while, but this time there aren't as many patches. :)

The first two patches provide some minor tweaks to the extended
attribute editing code that had been sitting (unreleased :/) in my
tree when Ted pulled in v4 of the extended attribute patches.  Most
notable is a fix for the delete method being unable to remove the last
xattr attached to an inode.

Patches 3-6 implement various minor bug fixes and cleanups, some of
which are based on complaints from clang and cppcheck.

Patches 7-8 fix some warts I've noticed while running e2fsck with
regards to inline data and printing runs of duplicate blocks.

Patches 9-10 make some alterations to metadata checksumming support;
by default, e2fsck will now check the inode before verifying the
checksum.  There's a command line option to restore the "just scrape
it off the system" behavior for heavily damaged filesystems.  There's
also a command line option to dumpe2fs to ignore checksum failures.

Patch 11 enables block_validity for new filesystems.  See patch 30 for
a performance microbenchmark.

Patches 12-13 enhance ext2fs_bmap2() to allow the creation of
uninitialized extents.  The functionality is already there; really it
just adds a flag to indicate uninitialized.  There's also a patch to
the fileio routines to handle uninitialized extents.  These patches
are unchanged from December.

Patches 14-16 add to resize2fs the ability to convert a filesystem to
and from 64bit mode.  These patches are unchanged from December.

Patches 17-20 implement readahead for e2fsck.  The first patch tries
to reduce system call overhead by using pread/pwrite if available.
The next two patches plumb in the IO manager and library changes
necessary to read metadata blocks into the page cache (on Linux).  The
final patch teaches e2fsck to use the library readahead functions in a
separate thread.

Crude testing has been done via:
# echo 3 > /proc/sys/vm/drop_caches
# e2fsck -Fnfvtt /dev/XXX

So far in my crude testing on a cold system, I've seen about a ~20%
speedup on a SSD, a ~40% speedup on a 3x RAID1 SATA array, and about
a 10% speedup on a single-spindle SATA disk.  On a single-queue USB
HDD, performance doesn't change much.  It looks as though low end
storage like USB HDDs will not benefit, which doesn't surprise me.
There's around a 2% regression for USB HDDs, though it doesn't seem
statistically significant.  The SSD numbers are harder to quantify
since they're already fast.  Somewhat unexpectedly, the readahead code
speeds up e2fsck even when the page cache has already been warmed up.

This third version of the readahead patches try to prevent page cache
thrashing by limiting the amount of (user-configurable) readahead to a
default of half of physical memory.  It also tries to release some of
the memory pages if it can conclude that it's totally done with a
block, and it can now detect very slow readahead and disable it.

Patches 21-25 implement fallocate for e2fsprogs, and modifies Ted's
mk_hugefiles functionality to use it.  The general fallocate API call
is (regrettably) much more complex than Ted's, since it must grapple
with the possibility that the file already has mapped blocks.  There
were also a lot of bigalloc related subtleties.

Patches 26-29 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

Patches 30-32 provide the metadata checksumming test script.  Its
primary advantage over 'make check' is that it allows one to specify a 
variety of different mkfs and mount options.  It's also growing more
tests as a result of fuse2fs exercise.

I've tested these e2fsprogs changes against the -next branch as of
3/1.  These days, I use an 8GB ramdisk and a 20T "disk" I constructed
out of dm-snapshot to test in an x64 VM.  The make check tests should
pass, and most of the xfstests should pass when run against fuse2fs.

Comments and questions are, as always, welcome.

--D
