From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs 1.41.10 has been released
Date: Wed, 10 Feb 2010 18:26:27 -0500
Message-ID: <E1NfLwx-00062Q-AX@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39808 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab0BJX0d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2010 18:26:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since Sourceforge has changed its File Release System, and no longer has
a way of making announcements when a new release has gone out (and I
don't know how many people were using it), I'll just make a quick
announcement here.

E2fsprogs 1.41.10 has been released.  It can be found in the usual
places (ftp.kernel.org, sourceforge), and of course in the e2fsprogs git
repositories.

						- Ted

E2fsprogs 1.41.10 (February 7, 2010)
====================================

Fix resize2fs bug which causes it to access invalid memory.

Add libss support for libreadline.so.6.
    
Fix e2fsck's check for extent-mapped directory with an incorrect file
type.

Add new e2fsck.conf configuration option, default/broken_system_clock
to support systems with broken CMOS hardware clocks.  Also, since too
many distributions seem to have broken virtualization scripts now,
e2fsck will by default accept dates which are off by up to 24 hours by
default.  (Addresses Debian Bugs: #559776, #557636)

Fix a bug where mke2fs may not use the best placement of the inode
table when there is only room for a single block group in the last
flex_bg.

E2fsck is now smarter when it needs to allocate blocks in the course
of fixing file system problems.  This reduces the number of spurious
differences found in pass #5.

E2fsck will no longer rehash directories which fit in a single
directory block.

E2fsck now correctly handles holes in extent-mapped directories (i.e.,
sparse directories which use extents).

Fix big-endian problems with ext2fs_bmap() and ext2fs_bmap2().

Fix a bug in filefrag where on platforms which can allow file systems
with 8k blocks, that it doesn't core dump when it sees a file system
with 8k block sizes.  (Thanks to Mikulas Patocka for pointing this
out.)

E2fsck will correctly fix directories that are have an inaccurate
i_size as well as other problems in a single pass, instead of
requiring two e2fsck runs before the file system is fully fixed.

Fix e2fsck so it will correctly find and detect duplicate directory
entries for non-indexed directories.  ( Addresses Sourceforge Bug:
#2862551)
    
Mke2fs will use BLKDISCARD to pre-discard all blocks on an SSD or
thinly-provisioned storage device.  This can be disabled using the -K
option.

Enhance libext2fs so it works around bug in Linux version 2.6.19
and earlier where the /proc/swaps file was missing the header on
the first line.

Fix bug in Linux version 2.6.19 and earlier where the /proc/swaps file
was missing the header on the first line.

Fix some big-endian bugs in e2fsck and libext2fs.

Fix resize2fs so it works correctly on file systems with external
journals instead of failing early with the error "Illegal inode
number".

Fix libss so that it does not seg fault when using a readline library
which does not supply a readline_shutdown() function.

Updated dumpe2fs's usage message so it correctly gives the right
arguments summary for "-o superblock=<num>" and "-o blocksize=<num>".
(Addresses Launchpad Bug: #448099)
   
Teach libext2fs to ignore the high 32 bits of the i_blocks field
when huge_file file system feature is set, but the inode does not
have the HUGE_FILE_FL flag set.

Fix e2fsck's handling of 64-bit i_blocks fields.

E2fsck will now print "Illegal indirect block", "Illegal
double-indirect block", etc., instead of "Illegal block #-1" or
"Illegal block #-2", etc.  This makes it easier for users to
understand what has gone wrong.  (Addresses SourceForge Bug: #2871782)

Mke2fs now will obtain get device topology information from blkid and
use it to populate the superblock stride and stripe sizes.  It will
also warn if the block device is misaligned

Fix file descriptor leaks in fsck and debugfs.  (Addresses Novell Bug:
##524526)

Fix the libext2fs library code to round up the bitmap size to a 4-byte
boundary, to prevent spurious seg faults caused by the x86
architecture.  This doesn't affect Linux systems, but was a major
problem on a number of *BSD systems.  (Addresses Sourceforge Bug:
#2328708)

Fix resize2fs's minimum size required for a file system so it doesn't
fail when "resize2fs -M" is run.  (Addresses RedHat Bugzilla: #519131)
    
Dumpe2fs now prints summary information about the contents of the
journal.
    
Avoid printing scary error messages when e2fsck starts running
problems on low-memory systems, as it tends to panic and mislead the
user.  (Addresses Debian Bug: #509529)

Fix blkid's modules.dep parser so it handles compressed (.ko.gz)
modules files.  (Address Red Hat Bug: #518572)
    
Fix tune2fs so it can add a journal when an extent-enabled file system
is mounted.  (Addresses Launchpad bug: #416648)

Update Czech, Indonesian, Polish and Vietnamese translations (from the
Translation Project).
    
Update/clarify man pages.  (Addresses Sourceforge Bug: #2822186)

Fixed various Debian packaging issues --- see debian/changelog for
details.  (Addresses Debian Bugs: #540111)

Programmer's Notes
------------------

The configure script supports the --with-cc, --with-ccopts, and
--with-ldopts options.  Instead, the more standard use of CC=,
CCFLAGS=, and LDFLAGS= in the configure command line is used instead.
Also, --with-ld, which never worked, was also removed.
(Addresses Sourceforge Bug: #2843248)

The in-tree header files are only used if the in-tree uuid or blkid
libraries are used.  Otherwise, use the system-provided uuid or blkid
header files if using the system-provided libraries.

Fix some build failures caused by --disable-* configure options.

Work around a bug in autoconf 2.64.

