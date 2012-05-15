From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.3
Date: Mon, 14 May 2012 22:23:41 -0400
Message-ID: <E1SU7QL-0001z4-Ha@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47050 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965305Ab2EOCXr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 22:23:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.3 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.3

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.3.tar.gz

The release notes are attached below

                                                - Ted

E2fsprogs 1.42.3 (May 14, 2012)
===============================

Fix a bug in the Unix I/O manager which could cause corruption of file
systems with more than 16TB when e2fsprogs is compiled in 32-bit mode
(i.e., when unsigned long is 32-bits).  Also fix a bug which caused
dumpe2fs to incorrectly display block numbers > 32-bits.

Improve the support for integrated quota files (where quota is a first
class supported feature using hidden files in the ext4 file system).
Previously the quota file was getting rewritten even when it was not
necessary, and e2fsck would erroneously try to hide quota files which
were already hidden.

Quiet complaints in e2fsck when the total free blocks or inodes are
incorrect in the superblock after an system crash, since we don't
update nor depend on the superblock summaries at each commit boundary.

Fixed a regression introduced in 1.42.2 which would cause applications
outside of e2fsprogs which did not pass the EXT2_FLAG_64BIT (and so
would were still using the legacy 32-bit bitmaps) to crash.  This was
due to missing 32-bit compat code in side the function
ext2fs_find_first_zero_generic_bmap().  (Addresses Red Hat Bugzilla:
#808421)
    
Fix a bug which would cause mke2fs to fail creating the journal if
/etc/mtab and /proc/mounts are missing.  (Addresses Sourceforge Bug:
#3509398)
    
Updated/fixed various man pages.

Update Czech, Dutch, French, German, Polish, Sweedish, and Vietnamese
translations

Fixed various Debian Packaging issues.


Programmer's Notes
------------------

Change the nonsensically wrong types in the function signature of the
inline function ext2fs_find_first_zero_block_bitmap2().  This was
caused by a cut and paste error; fortunately no code in e2fsprogs used
this inline function, and there are any users of this functions
outside of e2fsprogs.

Add support for systems which have valloc(), but which do have
posix_memalign() nor memalign() (such as MacOS 10.5).

Refactor and clean up the allocation of aligned buffers for Direct I/O
support.  Previously some allocations were requesting a greater
alignment factor that what was strictly necessary.  Also optimize
reading and writing bitmaps using Direct I/O when the size of the
bitmap did not fully cover the file system blocksize.

Reserve the codepoints for the INCOMPAT features LARGEDATA and
INLINEDATA.

Improved the regression test suite by adding some new integration
tests (f_jnl_32bit, f_jnl_64bit) which detect breakage of the on-disk
jbd2 format, as well as f_eofblocks which tests the new handling of
uninitialized and initialized blocks beyond i_size.  Also add a new
unit test which verifies 32-bit bitmaps support and the new
find_first_zero primitives.

Add a few dependencies to fix parallel (make -j) builds.

Removed bash'isms which were breaking the regression test suite on
systems where /bin/sh is not bash.

The config.guess and config.sub have been updated to the 2012-02-10
version.
    
Fix a portability problem caused by assuming the present of mntent.h
means that setmntent() exists.  Instead, explicitly test for this in
the configure script.

If the sys/signal.h header file does not exist, don't try to include
it, since it's not available on all systems.

Add support for systems that do not support getpwuid_r()
    
The configure script now supports a new option,
--enable-relative-symlinks, which will install relative symlinks for
the ELF shared library files.  (Addresses Sourceforge Bug: #3520767).
    
When building BSD shared libraries make sure the LDFLAGS variable is
passed to the linker.  Fixing this allows, for example, e2fsprogs to
be built in 32-bit mode on Mac OS X Lion (Addresses Sourceforge Bug:
#3517272)
    
Fix gcc -Wall nitpicks


