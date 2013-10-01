From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v1 00/31] e2fsprogs September 2013 patchbomb
Date: Mon, 30 Sep 2013 18:26:43 -0700
Message-ID: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37560 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3JAB0r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:26:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oh boy.  A larger pile of random e2fsprogs patches than last month! :D

The first seven patches fix miscellaneous errors.  The first patch fixes a bug
in one of the patches that was accepted from last month's patchbomb.  The
second fixes a bug where multiple directory entries could be created for a
single call to ext2fs_link.  The third and fourth patches fix some omissions in
the metadata checksumming error catalog.  The fifth patch fixes a bug wherein
ext2fs_link fails to notice to add checksum space when de-hashing a directory.
The sixth patch fixes a crash in getflags because the ioctl is defined to take
an unsigned long, whereas the program only allocates an int.  The seventh patch
causes the large_file feature to be set if someone uses the fileio APIs to
write out a file size bigger than 2GB.

The next four patches fix a number of off-by-one errors in the hole-punching
code.  Most of them stem from a misunderstanding of the 'start' and 'end
parameters to ext2fs_punch; assuming that the API means "punch out block
$start, block $end, and every block between the two", these patches fix that.
There's also a fix for a problem wherein we miss punching extents because
concurrent deleting-while-iterating has the effect of advancing the extent
pointer.

After that, there are eight patches to fix various 64bit value truncation
problems I observed first by trying to resize2fs a 20T filesystem.  I then
rebuilt with -Wconversion and fixed a few more places where we would rip off
the upper 32 bits of a 64-bit value, or use strtoul instead of strtoull.  I
also updated badblocks to deal with extents.

Then comes a patch to add sparse checking to the build process.

For the next six patches, I turned on bigalloc and found a number of bugs
relating to the fact that block_alloc_stats2() takes a block number but
operates on clusters.  I've fixed up all the allocation errors that I found.
I also decided to make the quota code use ext2fs_punch rather than try to
correct its behavior wrt bigalloc.  There was also a bug wherein the
requirement that 64-bit bitmaps be enabled (via EXT2_FLAG_64BITS) for bigalloc
filesystems.

The next three patches provide the ability to toggle the 64bit feature on any
ext4 filesystem.  Since extents are required to address blocks above 2^32, I
also added in warnings to prevent the user from having 64bit,^extents.

The final two patches add the ability to edit extended attributes and add a
fuse2fs driver for e2fsprogs.  I admit that the xattr editing functions
probably clash with the inline_data patches.  The fuse driver should work with
the latest versions of Linux fuse (2.9.2) and osxfuse (2.6.1).  I've been using
the fuse driver to test e2fsprogs functionality, which is how I came across
most of the bugs fixed above.

There are still bigalloc bugs in resize2fs -- it still thinks it's freeing
blocks, when in reality it's freeing clusters.  Also it's silly to have two
xattr implementations; I will probably just end up moving to Zheng Liu's
implementation ("libext2fs: add functions to operate on extended attribute")
since it's sitting in -pu.  For today I have not, because there were plenty of
other bugs to fix! :)  Long term, if fuse2fs actually goes anywhere, I think
it'd be useful to reintroduce journal replay too.  (Or cheat and use e2fsck -E
journal_only...)

I've tested these e2fsprogs changes against the -next branch as of a few days
ago.  After a longish while I think I've managed to reconstruct my old metadata
checksumming test program from the old days, so I've posted that version here:
https://gist.github.com/djwong/6372995 ... though now it has tests for
hole-punching and resizing. :) If you want to test fuse2fs with icsum.sh, use
this script: https://gist.github.com/djwong/6772237

These days, I use a 2GB ramdisk and a 20T "disk" I constructed out of
dm-snapshot to test in an x64 VM.

Comments and questions are, as always, welcome.

--D
