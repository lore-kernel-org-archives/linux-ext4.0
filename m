From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.2
Date: Thu, 1 Sep 2016 18:38:00 -0400
Message-ID: <20160901223800.agc2h2tasq4h2kdk@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35592 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbcIBGC4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Sep 2016 02:02:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.2 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.2

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.2.tar.gz

The release notes for 1.43.2 can be found below.

                                                  - Ted

E2fsprogs 1.43.2 (September 1, 2016)
====================================

Fix resize2fs so it will not crash if there is an extended attribute
block but it doesn't need to migate any blocks during an off-line
resize

Fix a crash when mke2fs or debugfs tries to copy in a directory
hierarchy containing an empty directory

Mke2fs will now use a larger journal by default for filesystems
greater than 128 GB.  (1GB instead of 128 MB.)

Fix an alignment bug in e2fsck which caused sparc64 architectures to
crash when replaying the journal on file systems with a 64-bit block
number.

Clarify the message printed by tune2fs message when the user needs to
run e2fsck so it's clear that the -f flag to e2fsck is needed to
force a full e2fsck scan.  (Addresses Debian Bug: #828022)

Fix a bug in e2fsck caused by a power failure during e2fsck's journal
replay could leave the file system in a state where if the file system
is mounted without doing a full e2fsck scan, the file system could get
corrupted

Fix the logic in e2fsck which decides when to repair legacy negative
timestamp encodings.

Add a command to debugfs to copy the inode structure from one inode to
another.

Fix a typo in debugfs's stat command when printing out the dtime field
on file systems with an extended timestamp.

Fix big endian bugs in the e2undo program.  (Addresses Red Hat Bug
#1344636)

Debugfs's logdump can now properly handle journals larger than 2GB.

Avoid installing the man page for fuse2fs if it has not been built.

Update the Catalan, Chinese, Danish, Dutch, French, German, Polish,
Swedish, Ukrainian translations and added new translations for
Hugarian and Serbian.


Programming notes
-----------------

Fix portability problems in fuse2fs.  Previously it wouldn't build on
systems with older glibc versions where clock_gettime() is only
available in the librt library, and if libintl is not bundled into the
C library.

Remove complicated logic which caused a static code analyzer to flag a
false positive.  (A static code analyzer also found a valid bug in
deciding when to repair a legacy negative timestamp encoding, so
eliminating false positives is important.)

Fixed a bug where the ext2fs library cloud provoke when a
extfs2_zero_blocks() is used (via fallocation, initializing a file
system, uninitialized uninitialized inode table blocks) after a
different file system which also used ext2fs_zero_blocks().

Enable the unix_io manager in the ext2fs library so it can accept the
use of a file descriptor.  This is helpful in cases where the file
descriptor comes from temporary file created using O_TMPFILE, or
passed in from a unix domain socket.

Fix a Windows64 portability bug.
