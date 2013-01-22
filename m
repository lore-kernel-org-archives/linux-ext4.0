From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of E2fsprogs 1.42.6
Date: Mon, 21 Jan 2013 23:30:53 -0500
Message-ID: <nsxmww1u9du.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44731 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3AVEa4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 23:30:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've released e2fsprogs 1.42.7 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, sourceforge, and
code.google.com, and available for ftp at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.7

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.7.tar.gz


This release includes some significant improvements to resize2fs; in
particular it resolves a number of bugs which could lead to file systems
getting corrupted, especially filesystems with the 64-bit or bigalloc
features enabled.

                                                - Ted


E2fsprogs 1.42.7 (January 21, 2013)
===================================

Add warnings to mke2fs, resize2fs, and tune2fs that the bigalloc and
quota features are still under development.  For more information
please see:
    * https://ext4.wiki.kernel.org/index.php/Bigalloc
    * https://ext4.wiki.kernel.org/index.php/Quota

Add some new options to filefrag from Lustre's patches to e2fsprogs:
    * add -k option to print extents in kB-sized units (like df -k)
    * add -b {blocksize} to print extents in blocksize units
    * add -e option to print extent format, even when FIBMAP is used
    * add -X option to print extents in hexadecimal format

Fix resize2fs so that it can handle off-line resizes of file systems
with the flex_bg feature but without a resize_inode (or if we run out
of reserved gdt blocks).  This also fixes a problem where if the user
creates a filesystem with a restricted number of reserved gdt blocks,
an off-line resize which grows the file system could potentially
result in file system corruption.

Fix a resize2fs bug which could cause it to corrupt bigalloc file
systems when doing an off-line resize.

Further optimize resize2fs so it doesn't use quite as much CPU when
resizing very large file systems. 

Fixed 32-bit overflow bugs which could cause resize2fs to fail and
possibly corrupt the file system while resizing 64-bit file systems.

Fix a bug in mke2fs where parsing "-E resize=NNN" will result in a
mke2fs crash due to a divide-by-zero if the 64bit file system feature
is enabled.

Add better error checking to mke2fs to check for invalid parameters
when creating bigalloc file system.

When creating bigalloc filesystems, the -g option to mke2fs will now
specify the number of clusters per block group.

Add to debugfs the functionality to corrupt a specific file system
block via the "zap_block" command.

Add to debugfs the functionality to print out a hex dump of a block in
the file system via the "block_dump" command.

Add to debugfs the functionality to manipulate the extent tree
directly via the "extent_open" command.

Fixed debugfs's mknod command so that it updates the block group
statistics.

Fix e2fsck so it can detect and fix inconsistencies in the interior
nodes of an inode's extent tree.

Fix a potential memory corruption failure in e2fsck's error path if
the call to ext2fs_open2() fails.

Fix e2fsck if its logging function is enabled in e2fsck.conf, and the
resulting file name for the log file is longer than 100 bytes, that it
properly handles this situation instead of crashing.

E2fsck will now report the amount of memory that it attempted to
allocate when a memory allocation request fails, to make it easier to
track down the problem.

Fix mke2fs's handling of the mmp_update_interval option.  (Addresses
Lustre Bug: LU-1888)

E2image can now include all data blocks in the e2image output file
when the user specifies the -a option.

If e2fsprogs is compiled without --enable-quota, make sure that
tune2fs can not turn on the feature for new-style quota support, since
afterwards, none of the e2fsprogs tools will be willing to touch that
file system.

Optimize e2fsck's so that it uses much less CPU for large file
systems.  This can result in significant speedups, especially on
CPU-constrained systems.  This was primarily done by optimizing
libext2fs's bitmap functions.  (Addresses Google Bug: #7534813)

Fix debugfs's htree command so that all its messages are sent through
the pager.

Fixed debugfs's "dump_file" and "cat" functions work correctly
on file systems whose block size is greater than 8k.

Fix e2freefrag so it works on 64-bit file systems, and so it uses much
less memory.  (Addresses Google Bug: 7269948)

Update the spd_readdir.c file in the contrib directory to include some
additions which were made in 2008 that didn't get folded into the
version which we checked into the e2fsprogs source tree.  These
enhancements include thread safety, support for readdir64_r(), and
safe_getenv() support in case spd_readdir.so is used for setuid binaries.

Update Czech, Dutch, French, German, Polish, Sweedish, and Vietnamese
translations

Add a command to debugfs to create symlinks.

Document the bigalloc feature in the mke2fs man page.  (Addresses
Debian Bug: #669730)


Programmer's Notes
------------------

Fix gcc -Wall nits.

Fix a spelling typo in the libext2fs texinfo documentation.

Change the output from "make check" so that tools such as emacs's "M-x
compile" does not mistake the output as containing a compiler error.

Export two new functions from libext2fs: ext2fs_extent_node_split()
and ext2fs_extent_goto2().

The ext2fs_extents_fix_parents() was fixed so it does not modify the
location of the extent handle if its current location is at an
interior node, rather than a leaf node of an inode's extent tree.

Add a regression test to assure that e2fsck can correctly fix an
inconsistent interior node in an inode's extent tree.

The ext2fs_{mark,unmark,test}_block_bitmap_range2() functions now
correctly support bigalloc file systems which use store block usage
information in units of clusters.

Fixed the help text in the configure script for --enable-quota.

The m68k-specific bitops code has been removed since they were
incorrectly treating bit numbers with the high bit set as signed
integers.  Furthermore, modern compilers do a good enough job
optimizing the generic code there is no point in having the m68k
specific asm statements.

Fixed how we link the test programs so they always use the static
libraries, so that we test using the libraries which we have just
built.

Update config.guess and config.sub to the latest versions from the GNU
project.

Fixed the com_err.texinfo file so that it can produce a valid
postscript/pdf printed output.

Add a regression test which checks debugfs's ability to create
symlinks, named FIFO's, and device nodes.

Add a function ext2fs_symlink(), which creates symlinks to the
libext2fs library.

Add debugging code so we can test old kernel interfaces for online
resize to resize2fs.  This backwards compatibility checking is keyed
off of the RESIZE2FS_KERNEL_VERSION, which is designed to allow us to
test the functionality of the kernel's older resize ioctls without
needing to install an old version of resize2fs, and to also test a
modern resize2fs's ability to work with older kernels without having
to install an older version of the kernel.

