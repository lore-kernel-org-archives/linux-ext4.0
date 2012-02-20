From: Ted Ts'o <tytso@mit.edu>
Subject: E2fsprogs 1.42.1 release
Date: Sun, 19 Feb 2012 22:19:38 -0500
Message-ID: <20120220031938.GA5113@thunk.org>
References: <4F3F1439.5000407@ubuntu.com>
 <4F3F1580.9020108@redhat.com>
 <20120218223131.GB8320@thunk.org>
 <B2C249E4-41BE-400F-BC11-B1F7ABDE308E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@ubuntu.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46894 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2BTDTo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Feb 2012 22:19:44 -0500
Content-Disposition: inline
In-Reply-To: <B2C249E4-41BE-400F-BC11-B1F7ABDE308E@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 19, 2012 at 10:11:12PM -0500, Eric Sandeen wrote:
> > Which is in e2fsprogs 1.42.1....
> > 
> Was that the release announcement?  :)

I knew I forgot something.  :-)

Over the weekend I released e2fsprogs 1.42.1.  It can be found in the
usual places: on sourceforge, a signed git tag, and on
ftp.kernel.org:/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.1.

							- Ted

E2fsprogs 1.42.1 (February 17, 2012)
===================================

The mke2fs and e2fsck now use significantly less memory when creating
or checking very large file systems.  This was enabled by adding
extent-based bitmaps which are stored using a red-block tree, since
block and inode allocations tend to be contiguous.

The command mke2fs -S is used as a last ditch recovery command to
write new superblock and block group descriptors, but _not_ to destroy
the inode table in hopes of recovering from a badly corrupted file
system.  So if the uninit_bg feature is enabled, mke2fs -S will now
set the unused inodes count field to zero.  Otherwise, e2fsck -fy
after using mke2fs -S would leave the file system completely empty.

Since mke2fs recognizes mke3fs in argv[0] to mean "mkfs.ext3", also
honor "mke4fs" to work the same as "mke2fs.ext4", since RHEL5 has
installed an mke2fs binary using that name.

The usage and help messages for the -G, -t and -T options in mke2fs
have been fixed.

If e2fsck needs to use the backup group descriptors, the
ext2fs_open2() function clears the UNINIT bits to ensure all of the
inodes in the file systems get scanned.  However, the code which reset
the UNINIT flags did not also recalculate the checksum, which produced
many spurious (and scary) e2fsck messages.  This has been fixed by
resetting cheksums when the UNINIT bits are cleared.

Relax a check in e2fsck which required that the block bitmap to be
initialized when the inode bitmap is in use.  This will allow us to
eventually eliminate code from the kernel which forcibly initialized
the block bitmap when the inode bitmap is first used, requiring an
extra journal credit and disk write.  (Addresses Google Bug: #5944440)
    
Make sure rdebugfs (which may be installed setuid or setgid disk) does
not honor environment variables if euid != uid or egid != gid.

Debugfs's ncheck command has been optimized and now is much more
robust with faced with corrupted file systems.  The ncheck command
also now has a -c option which will verify the file type information
in the directory entry to see if matches the inode's mode bits.  This
is extremely useful when trying to use debugsfs to determine which
parts of the file system metadata can be trusted.

E2image will try to use ftruncate64() to set the i_size for raw
images, instead of writing a single null byte.  This avoid allocating
an extra block to the raw image, for those file systems and/or
operating systems that support this.  (Linux does.)  In addition, fix
a logic bug that caused the file to not be properly extended if the
size of the last hole was exactly an multiple of a megabyte.

Fixed a bug in resize2fs where for 1k and 2k file systems, where
s_first_data_block is non-zero, this wasn't taken into account when
calculate the minimum file system size for use with the -M option.

Fixed the badblocks program to honor the -s flag when in read-only -t
mode.  (Addresses Debian Bug #646629)

Update Czech, Dutch, French, Polish, and Sweedish translation from the
Translation Project.

Fixed various Debian Packaging issues so that dpkg-buildflags is used
if present, which allows e2fsprogs to be built with security hardening
flags.  (Addresses Debian Bugs: #654457)

Programmer's Notes
------------------

Fix a bug in ext2fs_clear_generic_bmap() when used for 32-bit bitmaps.
This was only an issue for programs compiled against e2fsprogs 1.41
that manipulate bitmaps directly.  (Addresses Sourceforge Bugs:
#3451486)

The libext2fs library now uses sysconf() to fetch the page size, instead
of the deprecated getpagesize().

The ext2fs_get_pathname() function will return a partial path if an a
directory in the path is not a directory, displaying it as an inode
number in angle brackets instead of giving up and displaying an error.
This is much more helpful when a user is trying to debug a corrupted
file system.

Codepoints for the RO_COMPAT_REPLICA feature has been reserved.

Added a new library function, ext2fs_file_get_inode_num(), for use by
fuse2fs.

Fixed a bug in ext2fs_file_set_size2() so that when it is truncating a
file, it actually works.

The block iterator now properly honors the BLOCK_ABORT flag for
extent-based flags.  Previously, it didn't, which generally made code
be less efficient, but it could cause bugs in ext2fs_link(), for
example, by causing it to insert multiple directory entries.

Fixed an (harmless other than causing a compiler warning) use of an
uninitialized variable in e2fsck's MMP code.
