From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.5
Date: Mon, 30 Jul 2012 18:30:50 -0400
Message-ID: <20120730223050.GA16862@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42157 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab2G3Wax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 18:30:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.5 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.5

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.5.tar.gz

(Note that the tar.gz files will not be identical between
sourceforge.net and kernel.org, due to how kernel.org handles the
uploads and how it handles tarball signing.  Kernel.org signs the
uncompressed .tar file, while on Sourceforge the PGP signature is over
the .tar.gz file.)

The release notes are attached below.

                                                - Ted

E2fsprogs 1.42.5 (July 29, 2012)
================================

Fixed a bug with mke2fs where if there is only 8 inodes per block
group, the calculation of the number of uninitialized inodes in the
first block group would go negative.  This resulted in "mke2fs -N 256
-t ext4 /tmp/foo.img 256m" trying to write so many blocks that /tmp
would run out of space.  (Addresses Sourceforge Bug: #3528892)

Fixed a bug in how e2fsck would uniquify directory entry names.
(Addresses Sourceforge Bug: #3540545)

Previously, e2fsck would only allow a mounted file system to be
checked if it was the root file system and it was mounted read-only.
Now it will allow any file system mounted read-only to be checked if
the -f option is specified.  This makes it easier to test how e2fsck
handles checking file systems which are mounted without having to test
on the root file system.

Fixed a problem if e2fsck where if the root file system is mounted
read-only, e2fsck would not clear an error indication in the journal
superblock.  Combined with a kernel bug, this would cause the e2fsck
to check the file system after every single boot.

The e4defrag program can now handle device symlinks, such as
/dev/mapper/testvg-testlv, instead of insisting on a less
human-friendly name such as /dev/dm-2.  (Addresses Red Hat Bugzilla:
#707209)

Fixed filefrag so it will not crash with a segfault on files from a
virtual file system such as /proc.  (e.g., "filefrag
/proc/partitions")

Fixed filefrag so that it correctly reports the number of extents.
(Addresses Red Hat Bugzilla: #840848)

Fixed a file descriptor leak in logsave which could cause it to hang.
(Addresses Debian Bug: #682592)

Fixed e2fsck so that the file system is marked as containing an error
if the user chooses not to fix the quota usage information.

Fixed tune2fs so that it correctly removes the quota feature when the
last quota inode is removed.

Fix tune2fs so that after removing a quota inode, the block bitmap is
updated; otherwise, e2fsck would complain after running 'tune2fs -O
^quota <dev>'.

Fix tune2fs so that when converting a file system from using legacy
quota files to the new quota file system feature with hidden quota
files, the accounting for these files is handled correctly so that
e2fsck doesn't complain.

Improved e2fsck's verbose reporting statistics, and allow the more
verbose reporting to be enabled via /etc/e2fsck.conf.

Fixed various Debian Packaging Issues (Addresses Debian Bug #678395)

Updated/fixed various man pages.  (Addresses Debian Bugs: #680114)


Programmer's Notes
------------------

Fixed portability problems on other operating systems (e.g., Hurd and
FreeBsd) caused by the attempted inclusion of <sys/quota.h>.

Make sure that shared libraries link with the shared libraries built
in the build tree, instead of the system provided libraries.
Previously, libraries and executables were linked with the system
libraries if present, and possibly using static archives instead of
shared libraries.  This was also problematic since if libext2fs.so is
linked with a static libcom_err.a from system, the build system would
attempt to link without -lpthread.  (Addresses Sourceforge Bug:
#3542572)
