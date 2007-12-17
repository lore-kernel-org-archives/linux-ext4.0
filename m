From: Theodore Ts'o <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable)
Date: Mon, 17 Dec 2007 12:11:35 -0500
Message-ID: <20071217171135.GB7070@thunk.org>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55187 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbXLQRLh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 12:11:37 -0500
Content-Disposition: inline
In-Reply-To: <E1IooC9-0006TJ-Q6@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Andreas Dilger (1):
  fix check_mntent_file() to pass mode for open(O_CREAT)

Arun Thomas (1):
  e2image in raw-mode appends an extra byte to image-file

Eric Sandeen (1):
  e2fsprogs: fix blkid whole-disk scanning heuristics

Samuel Thibault (1):
  Fix Debian rules files to support building non-Linux archs

Theodore Ts'o (20):
  Fix errors in test_ss.c so it can be an example application and
      test case
  libext2fs: Fix a corner case bug in ext2fs_unlink
  libss: Fix parallel build failure
  Update Spanish translation and e2fsprogs.pot file for 1.40.3
      release
  gen-tarball: Ignore the Meta directory when creating the release
      tarballs
  Update Debian policy compliance to version 3.7.3.0
  Add Ubuntu-specific e2fsck.conf file to work around Ubuntu issues
  libext2fs: Add checks to prevent integer overflows passed to
      malloc()
  Update release notes, version files, etc., for 1.40.3 release.
  ext2fs_flushfs: Remove the NEEDS_RECOVERY from the backup
      superblocks
  Fix cross-compilation support in Debian's build rules
  Fix uuid_unparse man page to give a correct example UUID output
      string
  libss: Fix "make check" test case to work portably
  blkid: Avoid division by zero error when probing an invalid FAT
      filesystem
  libcom_err: Fix sign-extension problem on 64-bit systems in
      error_message()
  Update Dutch and Polish translations from the Translation Project
  Remove Rwandan translation
  blkid: Output non-printing characters using ^ and M- notation
  fsck: '#' is only a comment character at the beginning of an fstab
      line
  

* The 'master' branch has these since the last announcement, including 
	patches merged in from previous topics branch:
		js/flex-bg (partial)
		cl/remove-masix
		tt/badblocks-cleanup
		tt/chattr-error-code

Coly Li (5):
  debugfs: remove masix support
  document: remove masix from data structure
  libext2fs: remove masix support
  e2fsck: remove masix support
  mke2fs: remove masix support

Dmitry V. Levin (6):
  e2image: Fix potential off-by-one fs_device_name buffer overflow
  Check fgets(3) return value
  blkid/test_probe.in: Fix temporary files handling
  texinfo: Fix directory entries
  blkid.pc, ss.pc: Move private libs from "Libs:" to "Libs.private:"
  check_ea_in_inode: Cleanup e2fsck_write_inode_full() call

Jose R. Santos (4):
  Reserve the INCOMPAT feature number for FLEX_BG.
  lib/ext2fs/Makefile.in: Reorder some of the $(SRCS) in alphabetical
      order.
  Relax group descriptor checking for FLEX_BG
  Enable FLEX_BG feature support

Theodore Ts'o (9):
  libe2p: Use lstat() instead of stat() in fsetflags() and
      fgetflags()
  libe2p: Change iterate_on_dir so that it counts non-zero returns
  chattr: provide an exit code in case of failure and add -f flag
  badblocks: Use unsigned int instead of unsigned long for test
      patterns
  badblocks: Change unsigned long to blk_t and unsigned int, as
      appropriate
  badblocks: Factor out calls to strtoul to a helper function
  badblocks: Use unsigned int instead of unsigned long for test
      patterns
  badblocks: Change unsigned long to blk_t and unsigned int, as
      appropriate
  badblocks: Factor out calls to strtoul to a helper function
