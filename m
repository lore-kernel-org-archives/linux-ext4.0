From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/31] e2fsprogs December 2014 patchbomb
Date: Sat, 20 Dec 2014 13:16:40 -0800
Message-ID: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaLTVQs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:16:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Hopefully, we're getting to the end of the patchbomb for 1.43.  As
usual, I've fixed a number of bugs discovered since the last patchbomb
in November, enhanced the e2fsck peformance improvements, rewrote a
pretty big chunk of e2undo, and revised all the new features for 1.43
per our discussions here.

The first patch fixes compiler warnings when building with clang and a
minor resource leak in resize2fs.  The second patch documents the
commands I've added to debugfs.

Patches 3-4 are enhancements to the library -- partial zero-out
support (I've decided not to support block device zero-out until I get
that mess cleaned up); and block allocator hook fixes for e2fsck so it
doesn't accidentally crosslink blocks.

Patches 5-6 fix a few minor bugs in tune2fs and e2fsck.

Patches 7-8 are the e2fsck metadata readahead patches, unchanged from
last time.

Patch 9 changes e2fsck to use a bitmap instead of a u32 list when
building the list of directories to rehash.  This enables some code
cleanup and makes it so we can free the dirinfo structure earlier.

Patches 10-11 rebuild extent trees.  This can be used to convert block
mapped files to extent files (-E bmap2extent), and it can also detect
sparse extent trees that could be reduced in size by either a full ETB
block or a full level.  The code is now smart enough to put off
detecting and rebuilding the extent trees of directories that are
going to be rehashed in part 3A until after the rehash because the
rehash process can shrink a directory enough to trigger the rebuilder
during the next e2fsck run.

Patches 12-15 prepare the undo IO manager and e2undo for heavier use
by adding discard, zeroout, and readahead call pass through support;
allow user programs to provide an undo IO file block size that differs
from the filesystem; and speeds up block writeout considerably by
tracking which blocks we've already written in a bitmap (instead of
repeatedly bashing on the tdb keystore).

Patch 16 replace e2undo's tdb file with a dumb flat file format,
which greatly improves the insane performance losses when using undo
files while fixing a lot of endianness bugs, database size
limitations, and the totally broken detection of undo files that
should not be applied to the filesystem.

Patches 17-21 enable the creation of e2undo files for all modern
e2fsprogs utilities and adds simple test cases for e2undo.

Patches 22-23 supply test cases for the new e2undo file format code
and the code adding e2undo support across all the e2fsprogs.

Patches 24-30 are new API calls in the library, primarily to support
the new fallocate feature in patch 27.  This isn't really new; these
patches have been out for review for quite some time.  There are two
new patches to add rudimentary tests for fallocate and punch.

Patch 31 implements fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

I've tested these e2fsprogs changes against the -next branch as of
12/15.  The patches have been tested against the 'make check' suite
and some amount of e2fuzz testing on x86_64, ppc64, and aarch64.
Github, for crazy testers: https://github.com/djwong/e2fsprogs/tree/next

Comments and questions are, as always, welcome.

--D
