From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.1
Date: Wed, 8 Jun 2016 23:20:19 -0400
Message-ID: <20160609032019.GA12419@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59306 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933992AbcFIDUW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2016 23:20:22 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.1 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.1

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.1.tar.gz


The release of e2fsprogs 1.43 happened last month, and it was a bit of
a "soft launch", so it wasn't explicitly announced on this list.  This
was more due to the fact that I did the release while I was
travelling, and so all of the pieces of the release got dribbled out
over a few days, and by then I had noticed a bunch of things I really
wanted to fix before it got a wider exposure.

To see what was added in e2fsprogs 1.43, please see:

	http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.43

The release notes for 1.43.1 can be found below.

        	    	      	     	    	  - Ted

E2fsprogs 1.43.1 (June 8, 2016)
===============================

Fixed e2fsck so that it would correctly update the project quota usage
when deleting a corrupted and inode, and fixed mke2fs so it wouldn't
dereference memory beyond the small inode structure (which was wrong,
but worked mostly by accident unless hardening or some security malloc
was in use).

Fixed a large number of FreeBSD portability problems.  (To build on
FreeBSD, however, we still need to use GNU Make and redirect dd to use
GNU dd.)

The configure script now supports --enable-hardening, which enables
stack protection, fortify, read-only relocation tables, immediate
dynamic symbol binding, and text segment ASLR (if the kernel has
userspace ASLR support enabled) by enabling position independent
executable code.  (Distributions who want to do their own special
thing can set CFLAGS, CFLAGS_SHLIB, CLFAGS_STLIB, LDFLAGS,
LDFLAGS_SHLIB and LDFLAGS_STATIC as appropriate.)

The configure script now supports --disable-tdb since on 64-bit
systems, it's much faster to just enable additional swap space.  The
scratch_files feature in e2fsck.conf is mostly only useful on 32-bit
systems.

Fixed the Direct I/O fallback codepath in the Unix I/O manager so that
read/modify/write worked correctly.  Fortunately in practice (with the
exception of the Undo handler when running on FreeBSD) used this buggy
codepath. so file systems weren't getting corrupted.

Mke2fs will now warn if the user provides a label which is too long.
(Addresses Debian Bug: #791630)

Debugfs's rdump command now works correctly when dumping the root
directory of a file system.  (Addresses Debian Bug: #766125)

Fixed a bug in debugfs so it would correctly calculate a block group's
checksum field field on 64-bit ssystems.

E2fsck now has a much more understandable error message when the
journal superblock is corrupt and the user declines to fix it.
(Addresses Debian Bug: #768162)

Fixed support of extended timestamps on 64-bit systems.

Updated/fixed various man pages.  (Addresses Debian Bugs: #766379,
#761144, #770750, #428361, #766127)

Fixed various Debian Packaging Issues.  (Addresses Debian Bug: #825868)


Programming notes
-----------------

Fixed coverity, sparse, gcc -Wall, and clang warnings/nits.

Fixed Android build makefiles (which was missing a newly added file in
lib/support).

In general, checks on s_creator_os have been removed in favor of
feature flag specific checks; if there is something that can't be
checked via the presence of a feature flag, we will simply check
whether the creator OS is *not* EXT2_OS_HURD which is the one
operating system where there has been extensive abuse of the
s_creator_os flag.

The libmagic libary has been suppressed when running the regression
test suite to avoid false test failures caused by differences between
versions of libmagic (and/or the magic number database).

The tests/test_script progam now accepts the --failed option, which
will run those tests that had previously failed.

Fixed tests build on those systems which require LDFLAGS to be set.

Fixed the regression test suite so it will properly filter out version
numbers with two components (such as 1.43) from log files before
comparing them with the expected golden output.

