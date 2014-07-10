From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.11
Date: Thu, 10 Jul 2014 16:30:22 -0400
Message-ID: <nsxoawxufc1.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56703 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaGJUa0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2014 16:30:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've released e2fsprogs 1.42.11 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and code.google.com, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.11

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.11.tar.gz

The release notes are attached below.

                                                - Ted

E2fsprogs 1.42.11 (July 9, 2014)
================================

Add support so that mke2fs can create hugefiles so that they are
aligned relative to the beginning of the disk, instead of relative to
the beginning of the partition, using the mke2fs.conf configuration
parameter "hugefiles_align_disk".

Fix a bug which causes e2fsck to abort a journal replay on a file
system with bigalloc enabled.  (Addresses Debian Bug: #744953)

Add sanity checks so that mke2fs will refuse insanely large flex_bg
counts specified by the -G option.  Insanely large flex_bg sizes can
result in a file system which can't be unmounted, or with extremely
pessimal metadata layouts.

The mke2fs program will provide a better metadata layout for
moderately large (but believable) flex_bg counts, such as 133,072.

The mke2fs progam will also check the kernel version number to
determine whether the lazy_itable_init option is supported, so that
lazy inode table initialization can be used even if the ext4 is
compiled as a module which isn't loaded at the time that mke2fs is
run.

Add description of ext4's mount options to the ext4 section 5 man
page.

Improve the chattr man page and clean up the chattr usage message.

E2fsck will now automatically fix a last mount time or last write time
which is in the future in preen mode, instead of aborting the fsck
check.

Mke2fs will now check the file system revision number requested by the
command line, and reject it if it is too large.  A file system with an
unsupported revision number will not be accepted by any of the other
file system tools, and this command line option is rarely used, so
let's try to help the user not shoot their own foot off.

The debugfs progam can now set the error count and associated
first_error and last_error fields in the superblock using the
set_super_value command.

Resize2fs will not try to calculate the minimum size of a file system
if it contains errors.  Otherwise a very badly corrupted file system
image can cause the minimum size calculation to loop forwever.  Since
resize2fs will not allow a file system marked as containing errors to
be resized.  It's pointless to calculate the minimum size, so just
skip it.

Fixed a typo in one of mke2fs's error message.

If filefrag runs into an error, it will continue processing the rest
of the files specified on thec ommand line, but then exit with an
error code.

Filefrag now prints some additional new flags (such as
FIEMAP_EXTENT_ENCODED), and print unknown flags as hex values.

Fixed support in filefrag for files with > 2**32 blocks on 32-bit
platforms.

Fixed a file descriptor leak in debugfs when copying files.

Fixed a regression introduced in 1.42.10 which caused mke2fs to fail
to create file systems larger than 2GB on 32-bit platforms.
(Addresses Red Hat Bugzilla: #1099892, Debian Bug: #752107)

Add Esparanto and Ukrainian translations, and update Czech, Dutch,
French, German, Italian, Polish, Sweedish, and Vietnamese
translations.

Fixed various compiler warnings.


Programmer's Notes
------------------

The gcc "-checker" option has been long deprecated, so remove support
from e2fsprogs.  It was causing a few people to be confused when they
tried enabling the configure option.

Update to the latest version of the config.status and config.rpath
files, as well as newer versions of the autoconf files in aclocal.m4.
Also, move the e2fsprogs-specific macros to acinclude.m4, which allows
people who want to use autoreconf to do so.

Make the use of strptime() function in debugfs to be more portable to
fix regression test failures for FreeBSD and MacOS.

A few miscellaneous changes designed to make life easier for
translators.

Fix the f_quota test and some Makefile dependencies if quota support
is not enabled.

Fix cross-compilation support, which got broken in 1.42.10.
(Addresses Debian Bug: #753375)

Delete lib/ext2_types.h on a make clean, and build it as necessary.

Add a debug program used for libext2fs unit tests.

Clean up the tests so that it avoids using GNU-specific behaviour in
mktemp.  Make sure the temporary files are cleaned up if the tests are
interrupted.

Add a new ext2fs_close_free() helper function which automatically
takes care of freeing the ext2_filsys structure even if ext2fs_close()
returns an error.
