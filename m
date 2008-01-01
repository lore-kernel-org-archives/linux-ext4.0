From: Theodore Tso <tytso@MIT.EDU>
Subject: What's in e2fsprogs.git (stable)
Date: Tue, 1 Jan 2008 13:01:28 -0500
Message-ID: <20080101180128.GB23047@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62285 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639AbYAASBp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2008 13:01:45 -0500
Content-Disposition: inline
In-Reply-To: <20071217171135.GB7070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lots of old (and new) bugs that had been hanging around Sourcefroge
and Debian bug trackers have been fixed.  In addition, yesterday I
released 1.40.4 of e2fsprogs.

* The 'maint' branch has these fixes since the last announcement.

Theodore Ts'o (29):
  uuidd: Use /var/lib/libuuid instead of /var/run/uuidd
  libuuid: When starting uuidd, use waitpid() to reap the zombie
      process
  libuuid: Only try to start the uuidd daemon a limited number of
      times
  debian: Add a dependency on libuuid1 to the uuid-runtime package
  Add #define needed for Hurd ioctl definitions
  libuuid: Fix bug which caused uuidd to fail if sizeof(int) !=
      sizeof(int *)
  uuidd: Avoid race conditions to that only one uuidd is started
  Update Vietnamese translation from the Translation Project
  Convert use of ext2fs_get_mem to ext2fs_get_array for overflow
      detection
  Fix build failure on non-Linux/non-Hurd/non-Masix systems
  Add --disable-tls configure option
  Add --disable-uuidd configure option
  debian: Do not use TLS or uuidd when building the bootfloppy udeb's
  Test for sys/syscall.h in configure to fix dietlibc build problem
  Fix build error in blkid/tst_types.c when using diet libc
  debian: build the e2fsck-static package so it works on 2.4 kernels
  debian: Use useradd and groupadd in favor of adduser
  Update dependencies in lib/uuid/Makefile.in
  debian: Fix the document ID in comerr_dev.doc-base
  Expand discussion of the -D option in e2fsck's man page
  Update release notes, version files for 1.40.4 release
  libss: Remove unnecessary Makefile dependency for test_ss
  debian: Fix all postinst/prerm/postrm scripts to include debhelper
      additions
  uuidd: Add _GNU_SOURCE #define to pick up setres[ug]id() prototypes
  debugfs: Add #include <string.h> to pick up prototype for
      strcasecmp
  e2image: If there is an error while writing a block, call exit(1)
  e2fsck: When optimizing non-htree directories, sort by inode number
  debugfs: allow the undel command reallocate without linking the
      inode
  Fix build failure on non-Linux/non-Hurd/non-Masix systems


* The 'master' branch has these since the last announcement
  in addition to the above.
