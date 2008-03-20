From: Theodore Tso <tytso@MIT.EDU>
Subject: What's in e2fsprogs.git (stable)
Date: Thu, 20 Mar 2008 16:22:43 -0400
Message-ID: <20080320202243.GO13719@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61841 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758205AbYCTUWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 16:22:47 -0400
Content-Disposition: inline
In-Reply-To: <20080313180503.GC31653@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Eric Sandeen (1):
  Fix ext2fs_swap_inode_full() for in-inode xattrs on big-endian
      machines

Matthias Koenig (1):
  uuidd: Fix issues identified by SuSE's security team

Philipp Thomas (2):
  po: update de.po (from translationproject.org)
  po: update de.po (from translationproject.org)

Theodore Ts'o (7):
  Don't fail the "make install" if the info files have not been built
  Update release notes, version files for 1.40.8 release
  debian: Remove preinstall script which is no longer necessary
  Update release notes and debian changelog for 1.40.8-2 release
  ext2_fs.h: Rename EXT4_ORPHAN_FS to be EXT3_ORPHAN_FS
  Change valgrind options in test_script to conform with valgrind
      3.2.3
  debugfs: Don't use a pager if stdout is not a tty


* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (1):
  Add support for the DIR_NLINK feature.

Jose R. Santos (3):
  Add 64-bit IO manager operations to struct_io_manager.
  Add {read,write}_blk64 to unix_io.c
  Add {read,write}_blk64 to inode_io.c

Josef Bacik (1):
  resize2fs: Add options to print (and resizing to) the minimum
      filesystem size

Theodore Ts'o (6):
  e2fsck: Support long symlinks which use extents
  e2fsck: Check for fast symlinks that have EXTENTS_FL set
  libext2fs: Fix ext2fs_extent_delete() to always point at a valid
      entry
  libext2fs: Fix fencepost error in ext2fs_extent_insert()
  libext2fs: Make icount use a 32-bit counter
  Fix miscellaneous gcc -Wall warnings

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

