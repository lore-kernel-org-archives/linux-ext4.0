From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/47] e2fsprogs November 2014 patchbomb
Date: Fri, 07 Nov 2014 13:50:43 -0800
Message-ID: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35067 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaKGVut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:50:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is a revised edition of part 6 of the 2014 e2fsprogs patchset.
I've fixed a number of bugs discovered since the last patchbomb in
September, added a couple more e2fsck peformance improvements, and
revised all the new features for 1.43 per our discussions here.

The first nine patches fix various bugs that either I found in the
library or were reported by users.

Patches 10-14 are enhancements to the library -- zero-out support; a
couple of new API calls to reduce fragmentation when creating files
and to check extent tree depths; and further modifications to the
block allocator to reduce fragmentation.

Patches 15-30 fix various bugs in the utility programs, some of which
were reported by users, some of which were found through more fuzzing.

Patches 31-32 are the same e2fsck metadata readahead patches,
unchanged from last time.

Patches 33-34 rebuild extent trees.  This can be used to convert
block mapped files to extent files (-E bmap2extent), and it can also
detect sparse extent trees that could be reduced in size by either a
full ETB block or a full level.

Patches 35-36 implement 32 to 64bit conversion in resize2fs; a few
bugs have been fixed since last time.

Patches 37-43 are new API calls in the library, primarily to support
the new fallocate feature in patch 41.  This isn't really new; these
patches have been out for review for quite some time.  There are two
new patches to add rudimentary tests for fallocate and punch.

Patches 44-47 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

I've tested these e2fsprogs changes against the -next branch as of
11/05.  The patches have been tested against the 'make check' suite
and some amount of e2fuzz testing on x86_64, i686, ppc64, and aarch64.

Comments and questions are, as always, welcome.

--D
