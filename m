From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 00/74] e2fsprogs patchbomb 12/2013
Date: Tue, 10 Dec 2013 17:18:14 -0800
Message-ID: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3LKBSV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:18:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yikes.  This patch series has sprawled quite a lot since October.

The first 15 patches are miscellaneous fixes.  Half of these are the
same patches from October, but there are a few new ones to tweak
wording, cap the number of logical blocks in a file to limits that the
library can handle, and a patch to disable changing the UUID on a
mounted checksumming filesystem because tune2fs and the kernel can
race to write out new (non-identical) GDT checksums, leading to fs
corruption.  There's also a patch to prevent mapping blocks into files
at too high addresses, a fix to make big symlinks safe for extents and
64bit block numbers, fixes for resize2fs moving inodes on checksumming
filesystems, and a bunch of other 64-bit safety fixes.

Patches 16-30 fix some problems that the Coverity scanner found.  Most
of these are resource handling errors -- file descriptors that don't
get freed, memory that doesn't get freed in error paths (or is
incorrectly freed), etc.  It's true that in many cases the resource
leaks happen on the way towards exit()/abort(), but this isn't always
true, and a little defensive programming never hurt anyone.

Patches 31-35 fix some library problems that running xfstests atop
fuse2fs exposed.  There are still problems with the fileio calls
returning stale data, and an extent tree corruption bug hiding
somewhere in libext2fs, but I decided to work on that after pushing
out this patch set.

Patches 36-37 fix some problems I encountered when creating 1k-block
bigalloc filesystems.  The kernel still complains of block group
corruption, but I will address those separately.

Patches 38-41 address the BLOCK_UNINIT discussion that I've been
having with Akira Fujita and Ted.  It shifts responsibility for
calculating the block bitmap for a BLOCK_UNINIT group out of the block
allocation routines into the bitmap loading routines.  With this in
place, the testb command in debugfs (and therefore the
ext2fs_test_block_bitmap() function) return correct results.

Patches 42-48 fix some more bigalloc bugs.  These are the same patches
from October, plus an additional fix to e2fsck and some resize2fs
cluster handling fixes.

Patch 49 enables block_validity for new filesystems.  See patch 77 for
a performance microbenchmark.

Patches 50-51 enhance ext2fs_bmap2() to allow the creation of
uninitialized extents.  The functionality is already there; really it
just adds a flag to indicate uninitialized.  There's also a patch to
the fileio routines to handle uninitialized extents.  fuse2fs will use
this for fallocate.

Patches 52-54 add to resize2fs the ability to convert a filesystem to
and from 64bit mode.  These patches are mostly unchanged from October.

Patches 55-60 implement a new API to iterate and edit extended
attributes.  The inline_data and fuse2fs patchsets both use this
feature.  For those who have been watching the inline_data patchset, I
rolled the minor bugfix patches into the first patch.

Patch 61 extends ext2fs_open() to support 64bit superblock numbers.
Ted wondered (back in October) if anyone else wanted to add anything
to that call.  I can't think of anything, and nobody else has spoken
up.

Patches 62-65 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the 64-bit openfs call.

Patches 66-74 provide the metadata checksumming test script.  Its
primary advantage over 'make check' is that it allows one to specify a 
variety of different mkfs and mount options.  It's also growing more
tests as a result of fuse2fs exercise.

I've tested these e2fsprogs changes against the -next branch as of
12/9.  These days, I use an 8GB ramdisk and a 20T "disk" I constructed
out of dm-snapshot to test in an x64 VM.  The make check tests should
pass.

Comments and questions are, as always, welcome.

--D
