From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.42.9
Date: Sun, 29 Dec 2013 16:17:33 -0500
Message-ID: <nsxd2kf4as2.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44389 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3L2VRf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Dec 2013 16:17:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi all,

I've released e2fsprogs 1.42.9 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.9

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.9.tar.gz

The release notes are attached below.

                                                - Ted

E2fsprogs 1.42.9 (December 28, 2013)
====================================

Mke2fs will detect an attempt to create a file system on a loop
mounted file and complain without the -FF option.  Also fixed mke2fs
so it allows the creation of a file system on a mounted device with
two -F options, as documented in the man page, instead of three -F
options.

Fixed a large number of bugs in resize2fs, e2fsck, debugfs, and
libext2fs to correctly handle bigalloc and 64-bit file systems.  There
were many corner cases that had not been noticed in previous uses of
these file systems, since they are not as common.  Some of the bugs
could cause file system corruption or data loss, so users of 64-bit or
bigalloc file systems are strongly urged to upgrade to e2fsprogs
1.42.9.

The tune2fs program will now not allow changing the uuid on a mounted
file system which has the uninit_bg feature enabled.  This avoids a
nasty race where the kernel and tune2fs are both retrying rewrite the
group descriptors at the same time, with different ideas about what
the UUID should be.

When e2fsck is rehashing an extent-mapped directory, it's possible
(although very rare) that an extent block will need to be allocated;
fix e2fsck to make sure that the block gets marked as used.

Mke2fs will now properly set the LARGE_FILE feature when creating a
journal >= 2GB --- which can happen when using 64k block size.

Fixed debugfs so that its freei command will correctly handle a request
to free a range of consecutive inodes.

Fixed 2fsck so it will not erroneously complain that an external journal
is invalid if it is exactly 2**32 blocks.

Fixed e2fsck so it won't try checking for, and adding, a missing
lost+found directory when running in read-only mode.

Fixed e2image to avoid some buffer overruns which would cause it to when
creating a "standard (non-raw, non-qcow2) image file.  Standard
e2image files are actually very rarely used, so we didn't notice when
the changes to enable the qcow2 format broke this e2image mode.

Fixed mke2fs so that the extended option "-E resize=NNN" will not turn
on the resize_inode feature when the meta_bg feature is set, since
these two features can not be set at the same time.

Fixed tune2fs so that when it disables the quota feature, it updates all
of the backup superblocks.

Fixed dumpe2fs that would cause it to abort when run using an image file
when trying to print the journal information (which is not present in
an e2image created image file).

Fixed a potential integer overflow in e2reefrag.
(Addresses-Debian-Bug: #718205)

Enhance debugfs so that when copying a sparse file from a native file
system into the file system image using the "write" command, it will
create a sparse file into the destination file system.

Enhanced debugfs so it can support a command line which is up to 8k
long.

E2image will refuse (unless the -f option is specified to force the
issue) to create a raw or qcow image using a mounted file system,
unless the -f option is specified to force the issue.

E2image has been optimized for using it to efficiently copy a file
system by only copying the allocated blocks, by using the options -ra.
New options (-o and -O) have been added so that a source and
destination offset can be given.  The -p option will print progress
information so the user will know how far along the copy is going.
And finally, the new option -c is useful for updating a file system on
an SSD, by avoiding unnecessary writes.  E2image can also shift a file
system image by doing an in place move.

Fix a regression introduced in 1.42.8 which would cause e2fsck to
erroneously report uninitialized extents past the EOF (as determined by
i_size) to be invalid.

Fixed resize2fs so under a corner case when an inode has a complex
extent tree, it will not corrupt an interior node in the extent tree.

Fixed resize2fs which would sometimes corrupt a file system when
shrinking a file system to a minimum size using resize2fs -M.
(Addresses Debian Bug: #660793)

Fixed resize2fs so that it will relocate inode table blocks if this
becomes necessary when shrinking the file system.

Fixed resize2fs and e2fsck so they will not crash when hit a failure
while operating on a file system with the MMP feature enabled.

Fixed a bug in debugfs which caused it create an invalid inode when
trying to write a zero-length file.

E2fsck will no longer crash if it tries to delete an invalid
extent-mapped symlink.

E2fsck will no longer crash if it comes across an directory which is
larger than 2GB (which is not allowed in valid file systems).

Fixed debugfs's help texts to fully document all options and otherwise
be more helpful.

Updated/fixed various man pages.  (Addresses Debian Bugs: #586218,
#669730, #698076)

Fixed various Debian Packaging Issues (#698879, #721365)


Programmer's Notes
------------------

Fix sparse, gcc -Wall and clang nits.

Update config.{guess,sub} to the latest version

Fixed various memory and file descriptor leaks on various error paths,
as well as some missing error return checks, which were found using
Coverity.

Run sparse against source files when building e2fsprogs with 'make
C=1'.  If instead C=2, it configures basic ext2 types for bitwise
checking with sparse, which can help find the (many many) spots where
conversion errors are (possibly) happening.

Allow the regression test to be run in chrooted environments where
/etc/mtab might be missing.

The ext2fs_punch() function, which was introduced in 1.42, was broken
in many ways, but this was never noticed since it wasn't used for
anything significant.  Some of the bugs include failing when trying to
punch a completely sparse file, failing when punching an extent-mapped
inode when the starting block was at the beginning of the inode, and
not being able to punch a single block (where start_blk == end_block).
It also didn't handle being passed an invalid, too-large ending block
number, and didn't handle properly terminate at the right place when
operating on an indirect-mapped inode.

Fixed some minor typo's in the error catalog for libext2fs.

Fixed ext2fs_file_set_size2() so that if it truncates an inode by
setting the file size, to zero the rest of the block to the end of the
file, so that if an ext4 FUSE driver tries to extended the file, that
we don't avoid stale data from being returned.

Fixed ext2fs_bmap() to disallow clients from trying to map or set
logical blocks which are larger than what an extent-mapped or indirect
block-mapped inode can allow.

If debugfs (or some userspace program using libext2fs) creates a file
which is larger than 2GB, make sure the large_file feature flag gets
set.

Fix a bug in ext2fs_link() where if there is multiple empty slots in the
directory which are large enough, the directory entry could get
inserted more than once in the directory.

If quota support is disabled (which is the default), make sure that
all traces of the quota support is removed from usage messages, man
pages, and tune2fs must not be able to enable the quota file system
feature.  (Addresses Red Hat Bugzilla: #1010709)

The ext2fs_file_write() now updates i_size on a successful write,
instead of only updating i_size wen the file is closed via
ext2fs_file_close().

Added a shell script, populate-extfs.sh which uses debugfs to populate
an ext2/3/4 file system image from a given directory.  It is similar
to the genext2fs program, but it supports ext3 and ext4 file system.

Add changes to the libext2fs library to support block group
descriptors larger than 64 bytes (for future compatibility).

Fixed an off-by-one bug in ext2fs_file_set_size2() so that it will not
leave an extra block in the file when truncating the file down to
size.

The html version info pages are now built using makeinfo --html
instead of the unmaintained and now-obsolete texi2html program.



