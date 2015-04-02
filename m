From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/35] e2fsprogs April 2015 patchbomb
Date: Wed, 01 Apr 2015 19:34:00 -0700
Message-ID: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbDBCeE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

April Fools!

It's been a couple of months; here's a revised patchbomb for 1.43.
There are a few fixes for minor bugs and bitrot I've encountered since
the last patchbomb, but aside from resolving merge conflicts, I
haven't changed a thing.

Patch 1 makes e2fuzz try harder to screw things up, by remounting the
supposedly fixed filesystem and continuing to modify it.  This helps
us to find discrepancies between what the kernel complains about and
what e2fsck knows to fix.

Patch 2 fixes a bug wherein a inlinedata symbolic link longer than 80
characters but missing the extended attribute portion was not
correctly truncated; the kernel apparently expects a symlink with the
inlinedata flag set to have the xattr part even if the target fits
inside i_block[].

Patch 7 fixes a bug where the kernel refuses to allocate clusters to
non-extent files on bigalloc filesystems by converting all non-extent
files to use extents.

Patch 9 teaches e2fsck to complain loudly when someone attempts to
read an obviously invalid block number.  There are a few places where
this is acceptable (trying to resolve inodes to pathnames for
reporting purposes, and fixing crosslinked file messes) but otherwise
we really shouldn't be playing with garbage data.

All other patches (3-6, 8, and 10-35) have not changed since last time:

Patches 3-4 are the e2fsck metadata readahead patches, unchanged
from September 2014.

Patch 5 changes e2fsck to use a bitmap instead of a u32 list when
building the list of directories to rehash.  This enables some code
cleanup and makes it so we can free the dirinfo structure earlier.
No changes from December 2014.

Patches 6-8 rebuild extent trees.  This can be used to convert block
mapped files to extent files (-E bmap2extent), and it can also detect
sparse extent trees that could be reduced in size by either a full ETB
block or a full level.  The code is now smart enough to put off
detecting and rebuilding the extent trees of directories that are
going to be rehashed in part 3A until after the rehash because the
rehash process can shrink a directory enough to trigger the rebuilder
during the next e2fsck run.  No changes from December 2014 aside from
the new patch 7, discussed above.

Patches 10-13 prepare the undo IO manager and e2undo for heavier use
by adding discard, zeroout, and readahead call pass through support;
allow user programs to provide an undo IO file block size that differs
from the filesystem; and speeds up block writeout considerably by
tracking which blocks we've already written in a bitmap (instead of
repeatedly bashing on the tdb keystore).  No change from December
2014 for any of the e2undo patches.

Patch 14 replaces e2undo's tdb file with a dumb flat file format,
which greatly improves the insane performance losses when using undo
files while fixing a lot of endianness bugs, database size
limitations, and the totally broken detection of undo files that
should not be applied to the filesystem.

Patch 15 implements atexit() handlers so that the undo IO manager has
a chance to finish writing the undo file if the program exits without
explicitly cleaning up the IO managers.

Patches 16-22 enable the creation of e2undo files for all modern
e2fsprogs utilities and adds simple test cases for e2undo and supply
test cases for the new undo features.

Patches 23-27 fix some bugs in the copy-in support for mke2fs and
change the file copy-in algorithm to use SEEK_DATA and SEEK_HOLE to
skip pointless reads on sparse files.  Rudimentary feature testing is
provided, and I added a contrib/ script to generate the minimum-sized
ext4 image of a particular directory.  No change since December 2014.

Patches 28-34 are new API calls in the library, primarily to support
the new fallocate feature in patch 31.  None of these patches have
changed since July 2014.

Patch 35 implements fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.  No changes since July 2014.

I've tested these e2fsprogs changes against the -next branch as of
3/28, though the patches have been rebased to reflect the minor
changes in this morning's -next.  The patches have been tested against
the 'make check' suite and a week's worth of e2fuzz testing on x86_64,
ppc64, armv7l, i386, and aarch64.  Github, for crazy testers:
https://github.com/djwong/e2fsprogs/commits/next

Comments and questions are, as always, welcome.

--D
