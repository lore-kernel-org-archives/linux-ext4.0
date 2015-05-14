From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/14] e2fsprogs May 2015 patchbomb
Date: Wed, 13 May 2015 17:21:08 -0700
Message-ID: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbbENAVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2015 20:21:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is a rollup of fixes for a bunch of things that Coverity
complained about, fixes for things that have been suggested since
the last patchbomb, and the seven or so patches leftover from last
month's patchbomb.

The first patch are all minor Coverity fixes -- unchecked error
returns, resource leaks, integer overflows, etc.

The second patch changes the new undo io manager so that it writes
out the undo file index block every time it adds a new block to the
undo file, and to fsync the undo file every time it needs to allocate
a new index block.  This should make it more resilient against program
failures and reasonably resilient against system crashes.

The third patch fixes a lot of Coverity complaints about undo file
setup, and it also straightens the functions out so that they all
should be roughly similar.

The fourth patch fixes reporting errors in filefrag.

The fifth patch fixes a buffer overflow in the journal revoke block
recovery code and makes the debugfs journal writer code write correct
(i.e. non-overflowing) values into revoke block headers when the
revoke block is full.

The sixth patch fixes block-mapped files on bigalloc filesystems,
because any attempt to write such a file causes IO errors.

None of those patches have changed since I started trickling them out
a week ago.

Patches 7-13 are new API calls in the library, primarily to support
the new fallocate feature in patch 31.  None of these patches have
changed since July 2014.

Patch 14 implements fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.  No changes since July 2014.

I've tested these e2fsprogs changes against the -next branch as of
5/5, though the patches have been rebased to reflect the minor
changes in this morning's -next.  The patches have been tested against
the 'make check' suite on x86_64, ppc64, armv7l, i386, and aarch64.

Comments and questions are, as always, welcome.

--D
