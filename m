From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.13
Date: Mon, 18 May 2015 15:19:44 -0400
Message-ID: <20150518191944.GA27221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43264 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbbERTTs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2015 15:19:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.42.13 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, sourceforge, and
code.google.com, and available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.13.tar.gz


This is basically just a roll-up of the last six months of bug fixes
that I've accumulated in the maint branch post 1.42.12.

Perhaps more of interest I've also released e2fsprogs
1.43-WIP-2015-05-18, which is hopefully closer to feature complete.
As we discussed on our weekly call last week, one major change which
I've made is that mke2fs now will enable the metadata_csum and 64bit
features by default.  This has been uploaded to debian experimental,
but the plan is that the next WIP release will go into debian unstable
and then into debian testing.

						- Ted

E2fsprogs 1.42.13 (May 17, 2015)
================================

Fixed a potential buffer overflow while closing a file system in
libext2fs.  (CVE-2015-1572, Addresses Debian Bug: #778948)

Fixed a bug which could cause e2fsck to corrupt Hurd file systems.
(Addresses Debian Bug: #760275)

Fixed a deadlock which occurs when using systemd and e2fsck.conf's
logging feature.  (Addresses Debian Bug: #775234)

Fixed a bug which could cause programs using libext2's inode table
scanning functions from crashing on certain corrupted file systems.
(Addresses Debian Bug: #773795)

Fixed dumpe2fs so it won't crash if the user doesn't specify a block
device (file system).  (Addresses Debian Bug: #764293)

Fixed e2fsck so if it notices unexpected HTREE blocks in pass 2, it
will report the correct directory inode containing the inconsistency.

If e2fsck fails to grow the dir_info structure due realloc(3) not
having enough memory, it will now fail with explanatory message
instead of staggering on failing with a confusing internal error
messages.

The tune2fs program will zero out the superblock journal backup
information when removing a journal from a file system.

The mke2fs program now enables the large_file feature by default.

Fixed a bug which could cause badblocks to crash if there are millions
and millions of bad blocks.

Fixed some use-after-free bug in resize2fs and e2fsck.

Fixed a memory leak in tune2fs.

Fixed some bigendian bugs that had crept into both indirect and extent
handling inside libext2fs.

Updated/fixed various man pages.

Update Esperanto, German, and Spanish translations.  Added Danish
translation.

Programmer's Notes
------------------

Fixed coverity, sparce gcc -Wall, and clang warnings/nits.

Clean up some build system problems (build failures with various
configure options, fix Posix portability issues, etc.)

The functions ext2fs_inode_alloc_stats[2]() and
ext2fs_block_alloc_stats[2]() now check the inode and block numbers
passed to them, to avoid crashes caused by buggy callers.

The libext2fs directory iterator will now check for an invalid
directory entry length instead of possibly walking off the end of the
directory buffer.

--------------------------------------------------

E2fsprogs 1.43-WIP (May 18, 2015) -- cd27af3ecb83
=================================================

Add support for the ext4 metadata checksum, inline data, encryption,
and read-only features.

Mke2fs will now create file systems with the metadata_csum and 64bit
features enabled by default.

Support for the very old, experimental, and never-added-to-mainline
compression feature has been removed.

Debugfs can now modify extended attributes and journal transactions.

The resize2fs command can now convert file systems between 64-bit and
32-bit mode.

We now use a new e2undo file format which is much more efficient and
faster than the old tdb-based scheme.  Since it so much faster,
e2fsck, tune2fs, debugfs, and resize2fs now also can support using
creating an undo file.

The mke2fs command can now set the error behavior when initializing
the file system (so the administrator doesn't have to issue a separate
tune2fs -e command).

E2fsck is now much more paranoid about not freeing or corrupting
critical metadata blocks, such as inode table blocks, even if
corrupted indirect blocks or extent trees point at these blocks.

E2fsck now prints block ranges in pass1b instead of listing all of the
blocks exhaustively.

E2fsck will try to expand the root directory if the lost+found can't
be linked to the root directory.  Also, offer to use the root
directory if lost+found can't be created.

E2fsck is now more paranoid handling corrupted extent trees as well as
corrupted journals.

E2fsck can now rebuild extent trees, either (a) to optimize them, (b)
to recover from a corrupted extent tree, or (c) to convert
block-mapped inodes to use extents.

E2fsck now has a readahead mechanism which can significantly speed its
performance, especially on RAID arrays.

E2fsck now has a "yes to all" option which the user can give if she is
tired of answering 'y' to a very large number of questions.

E2fsck will now ignore the badblocks inode if the contents of the
badblocks inode indicate that the portion inode table containing the
badblocks inode is bad.  (We must go deeper...)

E2fsck can now correctly fix directory with holes on bigalloc file
systems.

Fixed a bug in e2fsck to avoid overrunning a buffer containing jbd2
revoke records if the journal is corrupted.

Fixed a bug in e2fsck which could cause it loop forever if a special
inode has too many invalid block mappings.

Fixed a bug in e2fsck which could cause pass1b/c/d processing to get
confused if an attempt to allocate a block can't find any free space
in the file system.

E2fsck will no longer try to force rewrite blocks located beyond the
file system.

Fixed a bug in resize2fs which could lead to resize2fs crashing or a
corrupted file system if the file system is almost completely full
when trying grow a file system and we need to allocate blocks to grow
the block group descriptors.

Fixed a bug in resize2fs which could cause it to get fooled trying to
determinthe the RAID array's stride when flex_bg is enabled.

The dumpe2fs output has been improved so it is cleaner and always fits
within 80 columns.  Also added a more easily machine-parsable output
of dumpe2fs.

The mke2fs program can now pre-populate a file system from a directory
hierarchy using the -d option.

The mke2fs program now skips zeroing inode table blocks if they were
already zeroed using the discard feature.

Check to make sure file system features which can not be supported by
HURD are not enabled if the file system is created to be
HURD-compatible.

Added a new e2fuzz command that will fuzz an ext4 image for testing
purposes.

The debugfs logdump command can now deal with 64-bit revoke tables
correctly.  Also, "logdump -O" will print the old log contents (before
the journal was replayed).

The debugfs bmap command can now be used to set or allocate a physical
block.

Fixed a bug so "filefrag -B -e -v" does not return a separate entry
for each block.

The file I/O functions now correctly handle inodes containing
uninitialized blocks.

Fix a bug in tune2fs so that removing uninit_bg feature on a bigalloc
file system won't result in corrupted block bitmaps.

Programmer's Notes
------------------

Fixed coverity, sparce gcc -Wall, and clang warnings/nits.

Added Android build files so that e2fsprogs can be built in the
Android source tree.

Reduce the use of libc functions in libext2fs that may not be present
in the boot loader environment, at least for those functions that are
needed by boot loadsers such as yaboot.

Developers can now overide the debugging and optimization flags by
redefining the CFLAGS makefile macro.

The mke2fs command will now ask the user for confirmation if block
device or image file contains an existing file system image, and
stdout and stdin are connected to a tty.

The libext2fs library now picks a more intelligent goal block when
doing block allocations.

The libext2fs library will now automatically set the BLOCK_UNINT flag
if all of the blocks in a block group are free, to speed up future
e2fsck and dumpe2fs operations on the file system.

Add two new functions ext2fs_new_range() and ext2fs_alloc_range() to
libext2fs.

The ext2fs_zero_blocks() command will use FALLOC_FL_ZERO_RANGE for
file-based images.

The ext2fs_bmap() function supports new flags BMAP_UNINIT and
BMAP_ZERO.

The ext2fs_new_block2() function will now call the alloc_block hook
before checking fs->block_map.

Support for the MMP feature can now be disabled at compile time.

Added support to manipulate extended attributes to libext2fs.

Added a lot of new regression tests.

Added endian annotations so it's possible to scan e2fsprogs for endian
problems using a static code analyzer.

Fixed memory leaks in libext2fs.

The e2fsck jbd2 handling code has been resynced with the 3.16 kernel.
There is now a script in the contrib directory which automates most of
the resync process.

The build system will now run cppcheck (a static code analysis tool)
via "make C=1"

