From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.6
Date: Sun, 23 Sep 2012 23:38:25 -0400
Message-ID: <nsxipb46qfi.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52111 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2IYSdb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 14:33:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've released e2fsprogs 1.42.6 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, sourceforge, and
code.google.com, and available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.6

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.6.tar.gz

The major improvement in e2fsprogs 1.42.6 is enabling online resizing
for file systems larger than 16TB or which have the 64bit feature
enable.  This requires kernel patches that will be in 3.7.

In addition, I've released the first 1.43 WIP snapshot.   It has all of
the fixes of 1.42.6, plus support for metadata checksums.

                                               - Ted

E2fsprogs 1.43-WIP (September 22, 2012)
=======================================

Add support for the ext4 metadata checksum feature.

Check to make sure file system features which can not be supported by
HURD are not enabled if the file system is created to be
HURD-compatible.


Programmer's Notes
------------------

Reduce the use of libc functions in libext2fs that may not be present
in the boot loader environment, at least for those functions that are
needed by boot loadsers such as yaboot.

Support for the MMP feature can now be disabled at compile time.


E2fsprogs 1.42.6 (September 21, 2012)
=====================================

When mke2fs creates file systems with lazy itable initialization, the
progress updates for writing the inode table happens so quickly that
on a serial console, the time to write the progress updates can be the
bottleneck.  So mke2fs will now only update its progress indicators
once a second.

Resize2fs will skip initializing the inode tables if the kernel
supports lazy_itable_init, which speeds up growing off-line growth of
uninit_bg file systems significantly.  Resize2fs will now also
correctly set the itable_unused field in the block group descriptor to
speed up the first e2fsck after the file system is grown.

Resize2fs has been fixed so that on-line resizing of meta_bg file
systems work correctly.  This is needed to grow file system which are
larger than 16T.

Resize2fs will now correctly handle resizing file systems to 16TB on
32-bit file systems when "16TB" is specified on the command line.

Fix mke2fs so that it will be careful to set the reserved blocks ratio
larger than 50%; this can happen when creating small file systems and
when the last block group is dropped because there are not enough
blocks to support the metadata blocks in the last block group.

Fixed spelling mistake in debugfs's help message.

Fixed a potential seg fault in e2fsck when there is an I/O error while
reading the superblock.

Fixed various Debian Packaging Issues (Addresses Debian Bug #677497)

Updated/fixed various man pages.  (Addresses Sourceforge Bug:
#3559210)

Programmer's Notes
------------------

The configure option --enable-relative-symlink was broken so that it
needed to be --enable-symlink-relative-symlinks.  We will support both
for at least two years, but then the worng configure option will be
removed.

Fixed a regression introduced in 1.42.5 so the link order for
e2fsprogs' libraries will be correct for both static and shared
linking.  (Addresses Sourceforge Bug: #3554345)

Add support for e2fsprogs to be compiled using clang/LLVM.

Fix portability problems on non-Linux systems: avoid compile failures
on systems that don't have malloc.h

Fix f_mmp regression test suite so that debugfs gets killed if the
test is interrupted.




