From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs 1.41.12 release
Date: Tue, 18 May 2010 00:42:27 -0400
Message-ID: <E1OEEdP-0000Do-PX@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50062 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0EREma (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 May 2010 00:42:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.41.12; it's available in the usual places:

* e2fsprogs git trees
    http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=tag;h=refs/tags/v1.41.12
* sourceforge
    http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.41.12.tar.gz
* kernel.org
    http://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.41.12.tar.gz

The relevant section of the RELEASE NOTES:

E2fsprogs 1.41.12 (May 17, 2010)
================================

Mke2fs now gives a correct error message if the external journal
device is not found.  (Addresses Red Hat Bug #572935)

Resize2fs -P will now refuse to print a minimum size if the file
system is not clean.  Previously it would go ahead and print a minimum
size anyway, which might not be correct, leading to user confusion.

E2fsck now tests for extents that begin at physical block 0 and
rejects them as invalid.  (Addresses Google Bug: #2573806)
    
Fixed a bug in e2fsck which could cause it to crash when trying to
remove an invalid extent and the block bitmaps hadn't yet been loaded.
(Addresses SourceForge Bug: #2971800)
    
E2fsck now will completely skip time-based checks if the system clock
looks insane or the option broken_system_clock is set in
/etc/e2fsck.conf.

E2fsck would previously report an i_blocks corruption for a 4T file
created using posix_fallocate; this bug has been fixed.

E2fsck will now correctly mark a sparse journal as invalid and will
delete and recreate the journal to address the problem.

E2fsck would previously incorrectly ask the user whether she would
like to abort the file system check after finding a problem --- and
then abort regardless of the user's answer.  This is annoying, and
has been fixed.

E2fsck can now continue even if it fails to recreate the resize
inode; previously it would just abort the file system check
altogether.

E2fsck could potentially remove directory entries for inodes found in
the unused region of the inode table; this would generally happen on
ext4 file systems that do not use journaling.  This bug has been fixed
by not clearing these directory entries once it has been established
that bg_unused_inodes may not be trustworthy; once pass #2 has been
completed, e2fsck will restart the file system check from the
beginning, and then it will be safe to delete any directory entries
pointing to inodes that appear to be deleted.  (Addresses Google Bug:
#2642165)
    
E2fsck will not try to set the block group checksums if the user
cancels the fsck with a control-C.  It's a bad idea to set the
checksums if e2fsck hasn't been completed, and it often results an the
error message, "Inode bitmap not loaded while setting block group
checksum info".  (Addresses Launchpad Bug: #582035)

The mke2fs program now queries the kernel for the physical as well as
the logical sector size, and will not allow a blocksize below the
logical, and will strongly encourage a blocksize at least as big as
the physical blocksize.  This is needed for 4k sector drives that
emulate 512 byte sector sizes.

Mke2fs will now allow a flex_bg size of 1.  This is unusual, and
rarely needed, but it is a legal value.

E2fsck will check for cases where the EOFBLOCKS_FL is set when it is
not needed, and offer to clear it; this is a sign of a kernel bug, but
more importantly, some released kernels may crash when this situation
is encountered on ext4 file systems.  (Addresses Google Bug: #2604224)
    
E2fsck will use the EOFBLOCKS_FL flag exclusively to check whether
i_size is correct.  (Kernels starting with 2.6.34 will set
EOFBLOCKS_FL.)

The com_err library will now only output ^M (a CR character) when the
tty is in raw mode.

Update the Czech, Chinese, Dutch, French, Germany, Indonesian, Polish,
and Vietnamese translations.

Fixed various Debian packaging issues --- see debian/changelog for
details.  (Addresses Debian Bugs: #571247, #563487)


Programmer's Notes
------------------

The regression test suite now uses its own mke2fs.conf file, so that
downstream distributions want change the mke2fs.conf file which is
distributed in the RPM or dpkg file, without worrying about screwing
up the regression test results.

Always build namei.o so that building with configure --disable-debugfs
works correctly.  Long-term, if we care about reduced e2fsprogs
builds, we need a more general solution for deciding what .o files are
needed for a particular build.  Given that install floppies are going
(gone?) the way the dodo bird, we probably don't care, though.
(Addresses Sourceforge Bug: #2911433)

Add configure options --enable-symlink-build and
--enable-symlink-install, which allow e2fsprogs be built using
symlinks instad of hard links, and to be installed using symlinks
instead of hard links, respectively.  It is useful when the file
system where the build is taking place, or the file system where
e2fsprogs is installed, can't handle hard links for some reason.
(Addresses Sourceforge Bug: #1436294)

Fixed compile warning in mke2fs.c.
