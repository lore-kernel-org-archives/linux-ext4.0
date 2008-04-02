From: Theodore Tso <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable)
Date: Tue, 1 Apr 2008 20:06:26 -0400
Message-ID: <20080402000626.GB302@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41038 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756660AbYDBAGc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 20:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20080320202243.GO13719@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Andreas Dilger (1):
  Use -E instead of the deprecated -R option in the mke2fs man page

Michael Spang (1):
  debian: Use UID/GID ranges from adduser.conf, if present

Theodore Ts'o (9):
  debugfs, tune2fs: Handle daylight savings time when parsing a time
      string
  mke2fs: Clarify man page that -T is interpreted using the current
      timezone
  fsck: Fix -C handling so that subsequent progress bars are enabled
  e2fsck: Support a negative argument to -C to suppress progress
      information
  fsck: Make -Cn work correctly where n != 0
  fsck: Treat "ext4" and "ext4dev" as ext* filesystems
  e2fsck: Include the device name in the progress information
  logsave: Pass any SIGTERM or SIGINT signals to child process
  e2fsck: Avoid core dump when using the -N option


* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (2):
  Improve ext4 feature descriptions in mke2fs and tune2fs man pages
  Fix the copyright notice in lib/ext2fs/tst_csum.c to be GPLv2 only

Eric Sandeen (3):
  Fix ext2fs_extent_get for uninit leaf extents
  libext2fs: Fix byte-swap logic for i_block[] in inodes with extents
  Fix parallel builds for lib/ext2fs/extent.o

Jose R. Santos (11):
  Add initial checksum support for the gdt_checksum/uninit_group
      feature
  Add uninit block group support to various libext2fs functions
  Rename feature name from gdt_checksum to uninit_groups
  Add support for creating filesystems using uninit block group
  Make tune2fs uninit block group aware
  Make dumpe2fs uninit block group aware
  Make resize2fs uninit block group aware
  Make debugfs uninit block group aware
  Make e2fsck uninit block group aware
  Add new m_lazy test case
  Add m_uninit test case

Theodore Ts'o (2):
  e2fsck: Don't object to extents flags on deleted fast symlinks
  Add new test case to check e2fsck's response to fast symlinks w/
      EXTENTS_FL

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

