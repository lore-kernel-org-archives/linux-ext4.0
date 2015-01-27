From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/54] e2fsprogs January 2015 patchbomb
Date: Mon, 26 Jan 2015 23:35:34 -0800
Message-ID: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32675 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA0Hfj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:35:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here's the monthly patchbomb for 1.43.  As usual, I've fixed a number
of bugs discovered since the last patchbomb in December, enhanced the
e2fsck peformance improvements, continued improving the rewrite of
e2undo, fixed up the mke2fs -d functionality to allow for the creation
of minified readonly images, and revised all the new features for 1.43
per our discussions here.

The first nineteen patches fix documentation problems and various
fuzzer bugs in the library, resize2fs, tune2fs, and e2fsck.

Patch 20 implements a "yes to all" response to e2fsck's prompts.  The
user will be notified of the existence of yes-to-all if the 'y'
response is given more than eight times consecutively.

Patches 21-22 are enhancements to the library -- partial zero-out
support (I've decided not to support block device zero-out until I get
that mess cleaned up); and block allocator hook fixes for e2fsck so it
doesn't accidentally crosslink blocks.  These are unchanged from
previous months.

Patch 23 provides a new 'readonly' rocompat feature.  This new feature
flag can be used to create ext4 images for containers where neither
the kernel nor the userspace tools (except tune2fs) can write
anything to the filesystem.

Patches 24-25 are the e2fsck metadata readahead patches, unchanged
from previous months.

Patch 26 changes e2fsck to use a bitmap instead of a u32 list when
building the list of directories to rehash.  This enables some code
cleanup and makes it so we can free the dirinfo structure earlier.
No changes from December.

Patches 27-28 rebuild extent trees.  This can be used to convert block
mapped files to extent files (-E bmap2extent), and it can also detect
sparse extent trees that could be reduced in size by either a full ETB
block or a full level.  The code is now smart enough to put off
detecting and rebuilding the extent trees of directories that are
going to be rehashed in part 3A until after the rehash because the
rehash process can shrink a directory enough to trigger the rebuilder
during the next e2fsck run.  No changes from December.

Patches 29-32 prepare the undo IO manager and e2undo for heavier use
by adding discard, zeroout, and readahead call pass through support;
allow user programs to provide an undo IO file block size that differs
from the filesystem; and speeds up block writeout considerably by
tracking which blocks we've already written in a bitmap (instead of
repeatedly bashing on the tdb keystore).

Patch 33 replaces e2undo's tdb file with a dumb flat file format,
which greatly improves the insane performance losses when using undo
files while fixing a lot of endianness bugs, database size
limitations, and the totally broken detection of undo files that
should not be applied to the filesystem.

Patch 34 implements atexit() handlers so that the undo IO manager has
a chance to finish writing the undo file if the program exits without
explicitly cleaning up the IO managers.

Patches 35-41 enable the creation of e2undo files for all modern
e2fsprogs utilities and adds simple test cases for e2undo and supply
test cases for the new undo features.

Patches 42-46 fix some bugs in the copy-in support for mke2fs and
change the file copy-in algorithm to use SEEK_DATA and SEEK_HOLE to
skip pointless reads on sparse files.  Rudimentary feature testing is
provided, and I added a contrib/ script to generate the minimum-sized
ext4 image of a particular directory.

Patches 47-53 are new API calls in the library, primarily to support
the new fallocate feature in patch 27.  This isn't really new; these
patches have been out for review for quite some time.  There are two
new patches to add rudimentary tests for fallocate and punch.  No
changes from previous months.

Patch 54 implements fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.  No changes from previous
months.

I've tested these e2fsprogs changes against the -next branch as of
12/15, though the patches have been rebased to reflect the minor
changes in this morning's -next.  The patches have been tested against
the 'make check' suite and a week's worth of e2fuzz testing on x86_64,
ppc64, armv7l, i386, and aarch64.  Github, for crazy testers:
https://github.com/djwong/e2fsprogs/commits/next

Comments and questions are, as always, welcome.

--D
