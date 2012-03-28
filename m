From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.2
Date: Tue, 27 Mar 2012 18:14:47 -0700
Message-ID: <E1SChTL-0003xz-90@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36669 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2C1BOt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 21:14:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.2 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.2

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.2.tar.gz

Here are the release notes.

						- Ted

E2fsprogs 1.42.2 (March 27, 2012)
=================================

The resize2fs program uses much less CPU and is much faster for very
large file systems.  (Addresses Debian Bug: #663237)

The seti and freei commands in debugfs can now take an optional length
argument to set and clear a contiguous range of inodes.

E2fsck will now make explicit checks for the EOFBLOCKS_FL, since we
plan to remove support for it from the kernel file system driver.  It
really wasn't very useful and was causing more problems than it
solves.  Since e2fsck will complain if inodes that should have
EOFBLOCKS_FL do not have the flag set, we are going to remove this
check from e2fsprogs first, and then only remove the flag from the
kernel much later.

The mke2fs program can now use direct I/O via "mke2fs -D".  This will
slow down the mke2fs, but it makes it more polite on a loaded server
by limiting the amount of memory that gets dirtied by mke2fs when it
is using buffered I/O.

E2fsck was needlessly closing and re-opening the file system as a side
effect of adding Multiple Mount Protection (MMP).  This isn't
necessary for non-MMP file systems, so drop it.

Print errors returned by ext2fs_open2() and ext2fs_check_desc() so we
can more easily diagnose memory allocation failures caused by
insufficient memory.  E2fsck will now abort if there are memory
allocation failures when the file system is initially opened and
during the block group descriptor checks.  (Addresses Google Bug:
#6208183)

If there are incorrect block group checks, e2fsck will now report the
incorrect and corrected checksum values.

The e2fsck progam can now write log files containing the details of
the problems that were found and fixed directly, via configuration
parameters in /etc/e2fsck.conf.

Added the ability to limit the number of messages reported by e2fsck
for a given problem type.  This avoids a potential bottleneck if there
is a serial console which can cause a boot sequence to take a long
time if e2fsck needs to report many, many file system errors.

The dumpe2fs, debugfs, and tune2fs now use rbtree bitmaps, which cause
them to use much less memory for large file systems.

The dumpe2fs program will now print the expected block group checksum
if it is incorrect.  This helps to diagnose problems caused by
incorrect block group checksums.

E2fsck now checks for extents with a zero length, since the kernel
will oops if it comes accross such a corrupted data structure.  (See
https://bugzilla.kernel.org/show_bug.cgi?id=42859)

E2fsck has a number of bugs relating to discard that have been fixed.
(1) Fixed a bug which could cause e2fsck to discard portions of the
inode table which were actually in use.  (2) E2fsck will now avoid
using discard if the block device doesn't zero data on discard, since
otherwise this could cause problems if the file system gets corrupted
in the future.  (3) E2fsck will now avoid using discard when it is run
in read-only mode.  (4) Fixed a bug which caused e2fsck to not issue
discards in the last block group.

E2fsck's CPU utilization in pass 5 has been optimized, which will
speed up e2fsck slightly.

E2image will now skip copying uninitialized bitmap and inode table
blocks.

Fixed mke2fs -S so it does not corrupt the first block group's
information.

E2fsck will now check the new sysfs interface to determine if we are
using the battery or AC mains.  (Addresses SourceForge Bug: #3439277)

Updated/fixed various man pages.  (Addresses Debian Bug: #665427)

Fixed various Debian Packaging issues.  (Addresses Debian Bug: #665885)

Programmer's Notes
------------------

Fixed various portability issues for non-Linux systems, particularly
MacOS X, as well as Linux systems running with the just-released glibc
2.15.

Fix file descriptor leak in ext2fs_close() if the file system with
uninit_bg is opened read/only with a backup superblock.  (Addresses
SourceForge Bug: #3444351)

Fixed an invalid return in a non-void function in the quota code.
(Addresses SourceForge Bug: #3468423)

Fixed the debian rules file so that the calls to dpkg-buildflags works
when the shell is dash.

The debian package build now uses V=1 so that there is more
information about potential build failures in debian buildd logs.

If the uninit flags get cleared by functions such as
ext2fs_new_inode() or ext2fs_new_block2(), we now make sure the
superblock is marked dirty and the block group descriptor checksum is
updated if necessary.

The debian rules file will now try to load debian/rules.custom of it
exists.  This flie can skip various builds for speed reasons if there
is no need for the e2fsck-static or udeb packages.  Available
customizations in the rules file includes SKIP_STATIC=yes,
SKIP_BF=yes, and SKIP_DIETLIBC=yes.

In addition, if the file misc/mke2fs.conf.custom.in exists in the
source tree, it will be used instead of the standard misc.conf file in
the upstream sources.  This makes it easier for Debian-derived systems
to distribute a custom mke2fs.conf file without having to worry about
merge issues if future versions of e2fsprogs makes changes in the
upstream default version of mke2fs.conf.


