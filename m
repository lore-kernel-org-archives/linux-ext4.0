From: Theodore Tso <tytso@MIT.EDU>
Subject: What's in e2fsprogs.git (stable)
Date: Sun, 10 Feb 2008 23:41:08 -0500
Message-ID: <20080211044108.GA25089@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64822 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbYBKElL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 23:41:11 -0500
Content-Disposition: inline
In-Reply-To: <20080101180128.GB23047@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most of the maint branch went into the e2fsprogs 1.40.6 release that
happened this weekend.

						- Ted

* The 'maint' branch has these fixes since the last announcement.

Eric Sandeen (2):
  Fix the pathname of /var/lib/uuidd/uuidd.pid in uuidd man page.
  Fix up e2fsprogs.spec file to include a new uuidd package

Pixel (1):
  blkid: have ntfs's UUID compatible with vol_id

Theodore Ts'o (41):
  Add the Meta directory to the .gitignore file
  debian: use '$(MAKE)' instead of 'make' in debian/rules
  Fix profile, checker, and shared-library building on non-Linux
      platforms
  Fix Makefile race so that "make -j3 distclean" works correctly
  Use pkg-config to determine where to find the devmapper library
  debugfs: Change lsdel to use ext2fs_block_iterate2 it can find
      large files
  Add sample python bindings for the uuid library
  If --sbindir, et. al are specified to configure set $root_sbindir,
      et al.
  debian: Add "set -e" to postinst scripts
  debian: Add passwd dependency to libuuid1 and uuid-runtime
  Define helper functions ext2fs_set_i_{u,g}id_high() for MacOS
      compatibility
  resize2fs: Add sanity check for off_t overflow before truncating
  Explicitly check for ftruncate64() in configure.in
  Update Swedish translation file from the Translation Project
  Add support for the test_fs flag
  Teach the blkid library about ext4/ext4dev
  Ignore "safe" flag differences when e2fsck compares superblocks
  Fix minor typo in resize2fs man page
  blkid: Make sure the blocksize in reiserfs is sane
  blkid: Add support for HFS+ detection
  libuuid: Make sure execl() variadic function is properly terminated
  Use lseek() instead of llseek() of sizeof(long) == sizeof(long
      long)
  e2image: Fix potential overflow if the device name is too long
  debian: Don't use dietlibc on platforms that don't support it
  Don't build e2fsck statically by default anymore
  Create new filesystems with 256-byte inodes by default
  Create filesystems with the ext_attr feature by default
  Update release notes, version files for 1.40.5 release
  debian: Fix packaging problem caused by dpkg 1.14.16
  Fix bug in e2fsck which caused it to core dump if
      --enable-jbd-debug is used
  blkid: Automatically chose between ext4 and ext4dev as appropriate
  Allow tune2fs to set and clear the test_fs flag on ext4 filesystems
  blkid: Flush cached filesystem information on any error other than
      EPERM
  Don't try to create $DESTDIR/etc/init.d as part of make install
  blkid: Add support for returning labels for UDF filesystems
  Update e2fsprogs translation template and Vietnamese and Czech
      translations
  Document the BLKID_FILE environment variable in the libblkid man
      page
  libcom_err: Use thread local storage to fix reentrancy problems
  Update release notes, version files for 1.40.6 release
  Fix incorrect distribution name in Debian's Changelog
  Set the C locale in the tests/test_script driver


* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (1):
  mke2fs: Make lost+found always have at least 2 blocks

Theodore Ts'o (1):
  debugfs: Add -p option to ls subcommand.
