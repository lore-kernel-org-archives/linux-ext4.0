From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/49] e2fsprogs patchbomb 3/14
Date: Mon, 10 Mar 2014 23:53:56 -0700
Message-ID: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31949 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCKGyC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I wasn't expecting to re-spam the list quite so soon, but since
inline_data and create_inode went in last week, most changes are in
patches 1-5, 8-16, and 23-26.  Since the giant mailing in December,
most changes have been in patches 22-27 and 34-42.  The first 27
patches are bugfixes for existing functionality; everything after is
new stuff.  (Well, much of it's been out for review for a while...)

The first five patches fix numerous problems in create_inode.c
relating to incorrect error handling, style problems, whitespace
problems.  They also clean up the mixing of debugfs/mke2fs' global
variables, and do a proper job managing populate_fs' internal state --
this should not be handled by callers to populate_fs.

Patches 6-7 provide some minor tweaks to the extended
attribute editing code that had been sitting (unreleased :/) in my
tree when Ted pulled in v4 of the extended attribute patches.  Most
notable is a fix for the delete method being unable to remove the last
xattr attached to an inode.

Patches 8-14 fix some bugs with the inline_data implementation.
Various minor details seem to have been missed, such as not rehashing
inline directories, calculating the available size for inline data,
calculating i_blocks correctly, fine details of interactions between
the xattr editing code and the inline data code, mistakes with how the
inline directory dirent iterator deals with restoring the caller's
context, and a bug in resize2fs.

Patches 15-16 introduce cppcheck checking to the build process when C=1
is specified, and fix a few errors that it picked up.

Patches 17-20 implement various minor bug fixes and cleanups, some of
which are based on complaints from valgrind, clang, and cppcheck.

Patches 21 reduces the giant flood of numbers when e2fsck prints runs of
duplicate blocks.

Patches 22-27 make some alterations to metadata checksumming support;
by default, e2fsck will now check the inode before verifying the
checksum.  There's a command line option to restore the "just scrape
it off the system" behavior for heavily damaged filesystems.  There
are a couple of patches to fix erroneous behavior and crashes when
e2fsck has to rebuild the root directory.  The final patch in this
clump adds a command line option to dumpe2fs to ignore checksum
failures.

Patch 28 enables block_validity for new filesystems.  As noted here
previously, the overhead of enabling this option seems to be at most a
1% performance hit when performing a lot of small allocations, and
negligible otherwise.  On the plus side, the filesystem is smarter
about noticing erroneous allocations out of metadata areas (i.e. block
bitmap corruption) and shutting itself down to prevent damage.

Patches 29-30 enhance ext2fs_bmap2() to allow the creation of
uninitialized extents.  The functionality is already there; really it
just adds a flag to indicate uninitialized.  There's also a patch to
the fileio routines to handle uninitialized extents.  These patches
are unchanged from December.

Patches 31-33 add to resize2fs the ability to convert a filesystem to
and from 64bit mode.  These patches are unchanged from December.

Patches 34-37 implement readahead for e2fsck.  The first patch tries
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

Patches 38-42 implement fallocate for e2fsprogs, and modifies Ted's
mk_hugefiles functionality to use it.  The general fallocate API call
is (regrettably) much more complex than Ted's, since it must grapple
with the possibility that the file already has mapped blocks.  There
were also a lot of bigalloc related subtleties.

Patches 43-46 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

Patches 47-49 provide the metadata checksumming test script.  Its
primary advantage over 'make check' is that it allows one to specify a 
variety of different mkfs and mount options.  It's also growing more
tests as a result of fuse2fs exercise.

I've tested these e2fsprogs changes against the -next branch as of
3/6.  These days, I use several VMs, each with 8GB ramdisks to test
with; the test process is checkpatch > make C=1 > make check >
metadata checksum tests > fuse + xfstests.

Comments and questions are, as always, welcome.

--D
