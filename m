From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.4
Date: Tue, 12 Jun 2012 18:15:23 -0400
Message-ID: <E1SeZMx-0008HF-0j@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49471 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab2FLWPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2012 18:15:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.4 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.4

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.4.tar.gz

The release notes are attached below

                                                - Ted

E2fsprogs 1.42.4 (June 12, 2012)
================================

Fixed more 64-bit block number bugs (which could end up corrupting
file systems!) in e2fsck, debugfs, and libext2fs.

Fixed e2fsck's handling of the journal's s_errno field.  E2fsck was
not properly propagating the journal's s_errno field to the superblock
field; it was not checking this field if the journal had already been
replayed, and if the journal *was* being replayed, the "error bit"
wasn't getting flushed out to disk.

Fixed a false positive complaint by e2fsck if all of the extents in
the last extent tree block are uninitalized and located after the end
of the file as defined by i_size.

The dumpe2fs will now display the journal's s_errno field if it is
non-zero, and it will also display the journal's 64-bit feature flag
if present.

Fix e2fsck so that it always opens the device file in exclusive mode
when it might need to modify the file system, and never if the -n
option is specified.  (Previously, there were a few corner cases where
it might get things wrong in either direction.)

E2fsck now correctly truncates or deallocates extent-mapped inodes on
the orphan list.  The root cause was a bug in libext2fs's block
iterator which could end up skipping an extent when the last block in
an extent is removed, causing the current extent to be removed from
the extent tree.

E2fsck now correctly sets the global free block and inode counts when
truncating or removing inodes on the orphan list in preen mode.
Previously, it would leave these values would be set incorrectly,
which is largely a cosmetic issue since the kernel no longer pays
attention to those fields, but it can cause spurious complaints in
subsequent e2fsck runs.

Fix i_blocks accounting when the libext2fs library needs to add or
remove an extent tree block  on bigalloc file systems.

The lsattr and chattr programs now support the No_COW flag for the
benefit of btrfs.

Debugfs now interprets date strings of the form @ddd as ddd seconds
after the beginning of the epoch.  This is handy when setting an inode
number into the d_time field when debugging orphan list handling.

Fix a precedence bug with built-in quota support which might result in
e2fsck paying attention to the quota inode field even if the built-in
quota feature flag is not set.  Fortunately, in practice that
superblock field should be zero for non-built-in quota file systems,
so it's unlikely this bug would have caused problems.

Updated/fixed various man pages.  (Addresses Debian Bugs: #674453,
#674694)

Programmer's Notes
------------------

The regression test suite can now run the integration tests in the
tests directory in parallel, via "make -jN check".

Add new test, f_zero_extent_length which tests e2fsck's handling of
the case where all of the extents in the last extent tree block are
uninitialized extents after i_size.

Add a new test, f_jnl_errno, which checks handling of an error
indication set in the journal superblock.

Fix the test f_jnl_64bit so that it properly checks e2fsck's handling
of a 64-bit journal.

Add two tests, f_orphan_indirect_inode and f_orphan_extent_inode which
tests e2fsck's handling of orphan inodes in preen mode, and truncation
of extent inodes on the orphan list.
    
Fixed more OS X portability issues.
