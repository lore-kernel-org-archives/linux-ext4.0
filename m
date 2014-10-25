From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/39] e2fsprogs October 2014 patchbomb, part 6.1
Date: Sat, 25 Oct 2014 13:56:23 -0700
Message-ID: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43548 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaJYU4s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:56:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is a revised edition of part 6 of the 2014 e2fsprogs patchset.
I've fixed a number of bugs discovered since the last patchbomb in
September, added a couple more e2fsck peformance improvements, and
revised all the new features for 1.43 per our discussions here.

The first two patches fix some minor compiler warnings and make e2fuzz
a bit more aggressive in what it fuzzes.  Patches 3-6 fix three
complaints by Sami Liedes, and another silly bug I found in the
plausible.c's libmagic integration.

Patches 7-8 fix a couple of problems with metadata checksum support in
tune2fs -- the first greatly reduces the amount of work done to add
checksums to the extent tree, and the second makes it so that one
cannot change the metadata_csum feature bit when the filesystem is
mounted.

Patches 9-13 fix some bugs I found in resize2fs: various bookkeeping
errors with sparse_super2 support; a bug where internal extent tree
blocks would not have their checksums rewritten during an inode number
migration; the "insane RAID stride" bug that TR Reardon sent in; and a
patch to fix up the flags and unused inode count of the former last
block group when growing a filesystem.  (More on this in patch 18.)

Patch 14 teaches mke2fs not to zero inode table blocks that have been
discarded on a discard-zeroes-data device.

Patches 15-16 clean up the dumpe2fs output.

Patches 17-21 deal with e2fsck.  The first one fixes a Valgrind
complaint sent in by Sami Liedes.  The two patches after that (18-19)
teach e2fsck how to update a block group's INODE_UNINIT and
BLOCK_UNINIT flags for all groups that have no inodes/blocks
allocated, respectively; and it recalculates the unused inode count so
that future invocations of e2fsck can save time by not processing runs
of unused inodes.  This can improve e2fsck runtimes by up to 10% on
aged filesystems that have experienced massive inode die-offs in the
past.

The last two patches of this chunk are the e2fsck metadata readahead
patches, unchanged from September.

Patch 22 teaches ext2fs_new_block2() to call the alloc_block hook to
fix a bug in e2fsck where new blocks would be allocated from an
unverified block bitmap.  This is also left over from September.

Patches 23-24 hook up ext2fs_zero_blocks2 to the BLKZEROOUT blockdev
ioctl or the FALLOC_FL_PUNCH_HOLE feature of fallocate() to zero out
data blocks if possible.  This will be useful for zeroing inode
tables, clearing the journal, and the future ext2fs_fallocate API.
There's also a cleanup patch that ensure that the zero_blocks2 static
buffer gets cleaned up when the FS exits and converts each area that
was writing zero blocks to use the zero_blocks2 call instead.  These
two patches have been altered considerably to work around page cache
bugs related to BLK* ioctls, and to fix Ted's criticisms.

Patches 25-26 enhance ext2fs_bmap2() to allow the creation of
uninitialized extents.  The functionality is already there; this
simply adds a flag for clients to create uninitialized mappings.
There's also a patch to the fileio routines to handle uninitialized
extents.  These patches are unchanged from December 2013, aside from
having grown some more test cases.

Patches 27-28 add to resize2fs the ability to convert a filesystem to
and from 64bit mode.  These patches are unchanged from December 2013,
aside from having grown some more test cases.

Patches 29-33 implement fallocate for e2fsprogs, and modifies Ted's
mk_hugefiles functionality to use it.  The general fallocate API call
is (regrettably) much more complex than what hugefiles did, since it
must grapple with the possibility that the file already has mapped
blocks.  There were also a lot of bigalloc related subtleties; at some
point it might behoove someone to write a extent tree compressor.
The API call has been plumbed into debugfs, with accompanying tests of
both the fallocate and punch calls.

Patches 34-35 implement an interface in debugfs to fallocate and punch
so that we can provide some basic regression testing.

Patches 36-39 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

I've tested these e2fsprogs changes against the -next branch as of
10/10.  The patches have been tested against the 'make check' suite
and some amount of e2fuzz testing on x86_64, i686, ppc64, and aarch64.

Comments and questions are, as always, welcome.

--D
