From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/34] e2fsprogs Summer 2014 patchbomb, part 6
Date: Sat, 13 Sep 2014 15:11:12 -0700
Message-ID: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32095 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaIMWLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is part 6 of the Summer 2014 e2fsprogs patchset.  Hooray, the end
is in sight!  There are a few bugfixes at the start, but these are
mostly new features for 1.43.

The first six patches fix bugs.  Patch 1 implements detection and
correction of overlapping extents; patch 2 fixes collapsing directory
holes on bigalloc FSes; and patch 3 zaps s_jnl_blocks some more.
Patch 4 fixes ext2fs_new_block2() to call the get_alloc_block hook;
this is the successor to an earlier patch that open-coded the hook
call.  Patch 5 fixes needs_recovery flag handling when modifying the
journal with debugfs, and patch 6 fixes the build system on OSX.

Patches 7-9 implement v2 of the e2fsck readahead functionality,
which promises to reduce fsck runtime by 10-30%.  You might want to
read the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
("e2fsck readahead speedup performance report") for all the juicy
details!  The only change since last time was to plumb cache_readahead
calls into test_io.c, per tytso request.

Patches 10 teaches dumpe2fs to emit group descriptor data in a machine
readable format for ease of automated testing.  Patch 11 reorganizes
the human-readable group descriptor dumpe2fs per this week's
discussion.

Patch 12-14 enhance tune2fs, debugfs, dumpe2fs, e2image, and e2fsck to
tell the user what kind of data might be living at the path spec
they're passing into those tools if an ext4 superblock cannot be
found.

Patches 15-16 hooks up ext2fs_zero_blocks2 to the BLKZEROOUT blockdev
ioctl or the FALLOC_FL_ZERO_RANGE feature of fallocate() to zero out
data blocks if possible.  This will be useful for zeroing inode
tables, clearing the journal, and the future ext2fs_fallocate API.
There's also a cleanup patch that ensure that the zero_blocks2 static
buffer gets cleaned up when the FS exits and converts each area that
was writing zero blocks to use the zero_blocks2 call instead.

Patches 17-18 enhance ext2fs_bmap2() to allow the creation of
uninitialized extents.  The functionality is already there; this
simply adds a flag for clients to create uninitialized mappings.
There's also a patch to the fileio routines to handle uninitialized
extents.  These patches are unchanged from December, aside from having
grown some more test cases.

Patches 19-21 add to resize2fs the ability to convert a filesystem to
and from 64bit mode.  These patches are unchanged from December, aside
from having grown some more test cases.

Patches 22-28 implement fallocate for e2fsprogs, and modifies Ted's
mk_hugefiles functionality to use it.  The general fallocate API call
is (regrettably) much more complex than what hugefiles did, since it
must grapple with the possibility that the file already has mapped
blocks.  There were also a lot of bigalloc related subtleties; at some
point it might behoove someone to write a extent tree compressor.
The API call has been plumbed into debugfs, with accompanying tests of
both the fallocate and punch calls.

Patches 29-32 implement fuse2fs, a FUSE server based on libext2fs.
Primarily I've been using it to shake out bugs in the library via
xfstests and the metadata checksumming test program.  It can also be
used to mount ext4 on any OS supporting FUSE, and it can also mount
64k-block filesystems on x86, though I'd be wary of using rw mode.
fuse2fs depends on these new APIs: xattr editing, uninit extent
handling, and the new fallocate call.

Patches 33-34 provide the metadata checksumming test script.  Its
primary advantage over 'make check' is that it allows one to specify a 
variety of different mkfs and mount options.  It's also growing more
tests as a result of fuse2fs exercise.

I've tested these e2fsprogs changes against the -next branch as of
9/11.  The patches have been tested against the 'make check' suite and
some amount of e2fuzz testing on x86_64, i686, ppc64, and aarch64.

Comments and questions are, as always, welcome.

--D
