From: Theodore Tso <tytso@MIT.EDU>
Subject: What's in e2fsprogs.git (stable)
Date: Fri, 29 Feb 2008 09:28:30 -0500
Message-ID: <20080229142830.GB8968@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42151 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884AbYB2O3Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 09:29:25 -0500
Content-Disposition: inline
In-Reply-To: <20080219050347.GT25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There have been enough fixups that I've released e2fsprogs 1.40.7.

      	   	       	      	   	- Ted

* The 'maint' branch has these fixes since the last announcement.

Andreas Mohr (1):
  Add manpage references to debugfs/tune2fs commands

Eric Sandeen (3):
  blkid: detect LVM2 physical volumes
  resize2fs: Fix movement of large (greater than 128 byte) inodes
  Add regression test for resize2fs moving inodes with inline xattrs

Mike Frysinger (1):
  Fix makefile dependency issues for various install targets

Theodore Ts'o (27):
  Fix memory leak in ext2fs_alloc_block()
  libe2p: Change Raid to RAID in display option
  debian: Pass 100 to UID_MIN and GID_MIN, not 1
  e2fsck: Document that the -D option finds duplicate file names
  libe2p: New e2p_edit_feature2 which provides better error handling
  Teach tune2fs to use e2p_edit_feature2() to provide better error
      handling
  tune2fs: Cleanup feature handling to avoid merge conflicts
  tune2fs: Add support to clear the resize_inode feature
  Eliminate really obsolete references to Linux 2.0/2.1/2.2 in
      tune2fs man page
  Fix dumpe2fs parsing of explicit superblock/blocksize parameters
  libext2fs: Add EXT2_FLAG_NONFREE_ON_ERROR to ext2fs_open2()
  Enhance e2fsck's reporting for reporting unsupported filesystem
      features
  libblkid: Add error checking to devicemapper code to avoid
      segfaults
  e2fsck: Don't clear the LARGE_FILES feature flag
  Fix gcc -Wall warnings for lib/blkid/probe.c
  debugfs: Fix find_free_block to avoid reporting the block more than
      once
  fsck: Don't complain about an old-style fstab if the fstab is empty
  Add support for manipulating large_file feature in mke2fs and
      tune2fs
  e2fsck: Print an explicit message when the bad block inode is
      updated
  Improve descriptions for the r_move_itable and r_resize_inode tests
  Update mke2fs usage message
  tune2fs: Remove support for clearing the SPARSE_SUPER feature
  Update e2fsprogs translation template and po/gmo files
  Fix up debian copyright files to avoid Lintian errors
  debian: Add required ${shlibs:Depends} to libss2's depend header
  debian: Avoid adding an empty directory in the uuid-dev package
  Update release notes, version files for 1.40.7 release


* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (3):
  Improve support for in-inode EA's
  e2fsprogs-tests-f_unsorted_EAs.patch
  e2fsprogs-tests-f_ea_checks.patch

Theodore Ts'o (16):
  debugfs: Fix error handling in strtoblk() and
      common_block_args_process()
  Allow debugfs to be extended for use by test programs
  Don't byte swap extents information in the inode
  e2fsck: factor out code to clear an inode into e2fsck_clear_inode()
  Add support for extents to libext2fs
  Add read-only extents support to ext2fs_block_iterate2()
  Use BLOCK_FLAG_READ_ONLY flag in debugfs, e2image, and tune2fs
  Add read/only support for extents to ext2fs_bmap()
  e2fsck: Add support for extents
  Activate basic f_extents test case
  Allow mke2fs to create filesystems with the EXTENTS feature
  Add ability to set (but not clear) the extents feature to tune2fs
  mke2fs: Remove requirement for -f option for filesystems > 2**31
      blocks
  mke2fs: Remove 2.4 kernel warning for blocksizes > 4096 bytes
  mke2fs: Remove warning for inode_size > 128 bytes
  e2fsck: Account for index nodes in the extent tree for i_blocks

Valerie Clement (2):
  Add missing free in ext2fs_extent_free()
  Add missing shift for ei_leaf_hi

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

