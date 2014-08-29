From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.12
Date: Fri, 29 Aug 2014 11:54:17 -0400
Message-ID: <20140829155417.GA15052@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55906 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaH2PyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2014 11:54:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.12 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and code.google.com, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.12

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.12.tar.gz

The release notes are attached below.

                                                - Ted

E2fsprogs 1.42.12 (August 29, 2014)
===================================

Fix various e2fsck bugs when trying to repair bigalloc file systems.

E2fsck can now repair a file system with an overly large
s_first_meta_bg field, which had previously caused all e2fsprogs
programs to crash when trying to open such a file system.

Fix e2fsck so that it can correctly fix a number of rare file system
corruptions that were discovered when using a file system fuzzer.

Fix e2fsck so it does not try to write back block group descriptors if
they have not been modified.

Mke2fs program will now place metadata blocks in the last flex_bg so
they are contiguous.  This reduces free space fragmentation in a
freshly created file system, as well as allowing mke2fs commands which
request extremely large flex_bg size to succeed.

Mke2fs now creates hugefiles more efficiently (with fewer extent tree
blocks).

Fix a 32/64-bit overflow bug that could cause resize2fs to loop
forever. (Addresses-Launchpad-Bug: #1321958)

The resize2fs program will now use much less memory when resizing very
large file systems.

Fix a bug which could cause resize2fs to get confused and produce a
corrupted file system when shrinking a file system that had been
previously expanded and converted to use the meta_bg file system
format, but which no longer needs to use the meta_bg file system
format any longer.  This typically happened with large (> 16TB) file
systems.  (Addresses Debian Bug: #756922)

The e4defrag program will now defrag backwards-allocated files.

Fix tune2fs updating UUID's when manipulating file systems with
external journals (both the file system and journal UUID).

Fix tune2fs so it can remove an external journal for file systems with
a 1k block size.

Add a new debugfs command, "inode_dump", which prints the inode in hex
and ASCII format.

The debugfs's "set_inode_field" will now automatically allocate blocks
for indirect blocks and extent tree blocks.

Fix debugfs's "set_inode_field" so can properly handle
"block[IND|DIND|TIND]".

The debugfs "rdump" command will now take multiple source arguments.

Fixed a double close(2) bug in "rdump" and "rdump -p".

Fix debugfs's argument parsing for the freefrag command.

Fix filefrag to properly handle using the FIBMAP ioctl (with -B).
(Addresses Launchpad Bug: #1356496)

Clarified messages that were confusing users in debugfs, e2fsck,
mke2fs, and resize2fs (Addresses Debian Bugs: #758029, #757543,
#757544)

Dumpe2fs will now complain if extra arguments are given to it.
(Addresses Debian Bug: #758074)

Updated/fixed various man pages.  (Addresses-Debian-Bug: #726760)

Update Czech, Dutch, French, Polish, Spanish, Sweedish, Ukrainian, and
Vietnamese translations.

Programmer's Notes
------------------

The Unix I/O layer will now use pread[64]/pwrite[64] to reduce the
number of system calls issued.

Fixed profiled build.

The libext2fs library will now more efficiently split an extent tree
index block when appending to an end of a file.

Fixed free block accounting for 64-bit file systems.

Add a new function ext2s_inode_size_set() which takes care of all of
the required feature flag modifications.

The regression tests no longer require the presence of the md5sum
program.

Fix build failure on MIPS platforms on Debian (Addresses Debian Bug:
#754605)

Fix various Coverity warnings (#1225003, #1229243, #1252003)

