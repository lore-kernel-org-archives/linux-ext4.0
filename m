From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs 1.42 is released!
Date: Tue, 29 Nov 2011 18:54:23 -0500
Message-ID: <E1RVXVH-0008VR-7i@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org, ext3-users@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50510 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102Ab1K2Xy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Nov 2011 18:54:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I'm happy to announce the release of e2fsprogs 1.42.

You can download the tarball from here:

    http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.tar.gz

Or you can download it from the git repository on git.kernel.org.

    git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git.

Or, you can wait for your favorite distribution to package it.  :-)

The release notes are attached below.

Many thanks to all of the contributors to e2fsprogs, whose employers
include Canonical, Ctera Networks, Fujitsu, Google, IBM, Red Hat, SuSE,
Tao Bao, Whamcloud, and of course to all of the users of e2fsprogs.
Many thanks for your support, bug reports, code contributions, and
translations over the years.

Regards,

				- Ted

E2fsprogs 1.42 (November 29, 2011)
==================================

This release of e2fsprogs has support for file systems > 16TB.  Online
resize requires kernel support which will hopefully be in Linux
version 3.2.  Offline support is not yet available for > 16TB file
systems, but will be coming.

This release of e2fsprogs has support for clustered allocation.  This
reduces the number of block (now cluster) bitmaps by allocating and
deallocating space in contiguous power-of-2 collections of blocks,
which are called clustered.  This is a file system level feature,
called 'bigalloc', which must be enabled when the file system is
initially formatted.  It is not backwards compatible with older
kernels.

Added support for the Multi-Mount Protection (MMP) feature.

E2fsck more efficiently uses scratch files for really big file
systems.  (This is a feature that has to be turned on explicitly; see
[scratch_files] in the e2fsck.conf man page.)

Fix a bug in e2fsck where if the free blocks and inodes counts are
incorrect, e2fsck would fix them without printing an error message.
This would cause a "*** FILE SYSTEM WAS MODIFIED ***" message without
any explanation of what was fixed.

E2fsck will no longer attempt to clone an extended attribute block in
pass1b handling if the file system does not support extended
attributes.

E2fsck will be more careful accidentally asking the user to continue
if the file system is mounted, so that an escape sequence won't cause
a false positive.  (Addresses Debian Bug: #619859)

E2fsck now uses less cpu time in pass 5 when large portions of the
bitmaps are uninitialized.

E2fsck will no longer segault when a corrupted file system has a bad
extent, and removing it leads to a block needing to be deallocated.
(Addresses SourceForge Bug: #2971800)

E2fsck will catch termination signals (segfaults, bus errors, sigfpe)
and print debugging information to make it easier to find potential
problems.

E2fsck will check to see if the bad block inode looks insane, and will
skip trying to use if it certain fields which should be zero look
non-zero.  This is to avoid a corrupted bad block inode causing e2fsck
to get confused and do more harm than good.

If e2fsck modifies certain superblock fields which the kernel doesn't
look at, it will now mark the superblock as dirty without marking the
file system as changed.  This avoids signalling the init scripts that
a reboot is necessary, since the kernel isn't going to look at those
fields, so it won't care if they have been changed.

Fixed a bug in the libext2fs library (in the binary search routine of
the icount abstraction) that could (very, very rarely) cause e2fsck to
die in the middle of pass 1 or pass 2 processing.

E2fsck will not try to do a discard operation if the -n option was
specified on the command line.

E2fsck now supports an extended "discard" option which will cause
e2fsck to attempt discard all unused blocks after a full, successful
file system check.

E2fsck will check for the bad block inode to make sure it looks sane
before trusting it, to avoid causing more harm than good to the file
system.

E2fsck now returns additional status bits in its exit code if it
aborts early in the e2fsck run.

E2fsck now correctly calculates the maximum file size in the case of
the huge_file file system feature enabled without extents.

The mke2fs and e2fsck programs now tries to use the punch hole command
as a "discard" when operating on normal files.

The e2image program now supports the qcow2 format, which is a more
efficient way of capturing file system dumps.

Mke2fs now supports the [devices] stanza in mke2fs.conf which allows
per-device defaults to be specified in the configuration file.

Mke2fs now supports the reserved_ratio relation in the [defaults] and
[fs_types] section in mke2fs.conf.

Mke2fs now creates extent-mapped directories for the root and
lost+found directories.

Mke2fs will skip zero'ing the journal if the extended option
"lazy_journal_init" is specified.  This can save a lot of time, but it
does add a small amount of risk if the system crashes before the
journal is overwritten entirely once.  It is epsecially useful for
testing.

Mke2fs will now create file systems that enable user namespace
extended attributes and with time- and mount count-based file
system checks disabled.

Mke2fs will not set a stride or strip size of one block based on block
device attributes obtained from sysfs.

Mke2fs now displays a progress report during the discard process.

Mke2fs now handles extreme file system parameters correctly which
previously caused the inodes per group to drop below 8, leading to a
segfault.  (The inodes per group must be a multiple of 8, but the code
didn't correctly deal with an inodes per group count less than 8.)

Mke2fs and tune2fs previously would give an error if the user tried
setting the stride and stripe-width parameters to zero; but this is
necessary to disable the stride and stripe-width settings.  So allow
setting these superblock fields to zero.  (Addresses Google Bug:
#4988557)

Mke2fs now gives a warning if the auto-detected block size exceeds the
system's page size.

If the enable_periodic_fsck option is false in /etc/mke2fs.conf (which
is the default), mke2fs will now set the s_max_mnt_count superblock
field to -1, instead of 0.  Kernels older then 3.0 will print a
spurious message on each mount then they see a s_max_mnt_count set to
0, which will annoy users.  (Addresses Debian Bug: #632637)
    
The default mke2fs.conf now has entries for "big" and "huge", which
are needed for very big file systems.

The resize2fs program now has support for a new online resize ioctl
that can support file systems > 16TB, once it arrives in v3.x kernels.

Fixed bug which caused resize2fs to fail when shrinking an empty file
system down to its minimal size.  (Addresses Sourceforge Bug #3404051)

Fixed tune2fs's mount options parsing.  (Addresses Debian Bug: #641667)

Allow tune2fs to remove external journals if the device can not be
found.

Debugfs's icheck will now correctly find inodes which use the
searched-for block as an extended attribute block.

Debugfs now has a new "punch" command which remove blocks from the
middle of an inode.

Debugfs now has a new "e2freefrag" command which analyzes the free
space fragmentation of the file system, using the same code as the
e2freefrag program.

Debugfs now has a "filefrag" command which displays information about
a file's fragmentation.

Add support to build a metadata-only, read-only, stripped-down version
of debugfs called rdebugfs.

Fixed a potential stack overrun bug in debugfs.

The badblocks program now correctly recovers from I/O errors when
direct I/O is being used.  The badblocks command now also supports a
-B option which forces the use of buffered I/O, and the -v option will
provide a more detailed breakdown of read, write, and failed
comparison errors.

Added e4defrag tool which uses the EXT4_IOC_MOVE_EXT ioctl.

Added support for journals larger than 2GB.

Support using both hard links and symlinks when installing e2fsprogs.

Add overflow checking to tune2fs -i's fsck interval, which must fit in
a 32-bit field.

The debugfs command now has a new 'blocks' command which prints out
data blocks of a particular inode in a format which is useful for
scripting.

Filefrag will report 0 extents correctly in verbose mode.  (Addresses
RedHat Bugzilla: #653234)

Filefrag has been fixed so its -v report prints the correct expected
block number (previously there had been an off-by-one error).  In
addition, it will now display the number of contiguous extents when -v
is not specified.  This makes it consistent with the number of extents
printed when the -v option was specified.  In addition, the number of
contiguous extents is far more interesting/useful than the number of
physical extents for very large files.  (Addresses Debian Bug:
#631498, #644792)
    
Logsave's usage message has been fixed.  (Addresses Debian Bug:
#619788)

Avoid an infinite loop in ext2fs_find_block_device() if there are
symlink loops in /dev caused by a buggy udev.

Added a useful "fallocate" program to the contrib directory.

Fixed an ABI compatibility problem in libext2fs which broke the dump
program.  Also added back some macros which dump needed so it could
compile against the latest version of ext2_fs.h (Addresses Debian Bug:
#636418)

Fixed parsing of MNTOPT_ options for tune2fs and debugfs (Addresses
Debian Bug: #641667)

Added internationalization support for libcom_err error table strings.

Fixed various spelling mistakes found in various output strings found
by I18N translators.

Update translations: French, Chinese, Germany, Indonesian, Swedish,
Vietnamese, Polish, Dutch, Czech.  (Addresses Debian Bugs: #520985,
#620659)

Fixed various Debian Packaging issues.  (Addresses Debian Bugs:
#614662, #632169, #641838, #627535, #629355)

Updated/clarified man pages.  (Addresses Debian Bugs: #639411,
#642193, #634883)

Programming notes
-----------------

Initial support for quota as an integrated feature, where the quota
files are hidden system files that are automatically maintained by
e2fsck is present, although disabled by default.  It must be enabled
by using the configure option --enable-quota.

Reserved the on-disk fields for the metadata checksum and snapshot
features, which are currently in development.

The ext2fs library now has the new functions ext2fs_punch(),
ext2fs_get_memzero() and ext2fs_file_get_inode().

The ext2fs library now has support for calculating the crc32c checksum
(via the new functions ext2fs_crc32c_be and ext2fs_crc32c_le).

The I/O manager now supports the discard operation.

Reserved file system code points for new 1st class quota feature.

Shortened the compilation lines by moving the autoconf defines to
a config.h header file.

Fixed a potential free of an unitialized pointer in
ext2fs_update_bb_inode().

Fixed miscellaneous gcc -Wall and coverity warnings.

Fixed portability issues for Mac OS X, Hurd, and FreeBSD.

Fixed a build failure when OMIT_COM_ERR is defined.

Improved error checking and fixed memory leaks caused by error return
paths.

Add ext2fs_flush2() and ext2fs_close2() which takes a flag to allow
the fsync() to be skipped.

Added a test for extent-mapped journals by mke2fs and tune2fs.

Added a test for creating a large (over 4GB) journal using mke2fs.

Added a test to make sure the inode size remains constant.

The regression test script now prints the list of which tests failed.

The regression test system now uses /tmp for its scratch files, which
is often a tmpfs mounted file system and hence much faster.

The i_e2image test was fixed so it works with valgrind.

Tests that rely on debugfs are now skipped if debugfs wasn't built.

Fixed the dependencies for "make check" so all required dependencies
are built before running the gression tests.

A link to com_err.h is installed in $(includedir) during a "make install".

The po/*.gmo files are automatically rebuilt if they are missing or
out of date.  This helps out Debian packaging.

Allow ext2fs_get_memalign() to compile on systems that don't have
posix_memalign().

Fixed a namespace leak in libext2fs (tdb_null).


E2fsprogs 1.41.14 (December 22, 2010)
=====================================

Fix spurious complaint in mke2fs where it would complain if the file
system type "default" is not defined in mke2fs.conf.

The resize2fs program will no longer clear the resize_inode feature
when the number reserved group descriptor blocks reaches zero.  This
allows for subsequent shrinks of the file system to work cleanly for
flex_bg file systems.

The resize2fs program now handles devices which are exactly 16T;
previously it would give an error saying that the file system was too
big.

E2fsck (and the libext2fs library) will not use the extended rec_len
encoding for file systems whose block size is less than 64k, for
consistency with the kernel.

Programming notes
-----------------

E2fsprogs 1.41.13 would not compile on big-endian systems.  This has
been fixed.  (Addresses Sourceforge Bug: #3138115)

The ext2fs_block_iterator2() function passed an incorrect ref_offset
to its callback function in the case of sparse files.  (Addresses
Sourceforge Bug: #3081087)
    
Fix some type-punning warnings generated by newer versions of gcc.


