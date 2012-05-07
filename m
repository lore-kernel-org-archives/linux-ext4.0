From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5] Clean up I/O buffer allocation in e2fsprogs
Date: Mon,  7 May 2012 14:56:20 -0400
Message-ID: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38758 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas pointed out that original version of the last patch in this
series would break the 16k/64k blocksize regressiont tests on MacOS
10.5.  When I looked into addressing this, I realized that we didn't
need to request 16k or 64k alignment, and in general we often requested
aligned buffers when they were not necessary, and/or requested a larger
alignment factor than necessary.

This patch series cleans up this mess by refactoring the code so that
DIO alignment is calculated in one place, and so we have a common
routine for allocating I/O buffers used by e2fsprogs's I/O layer.

	    	       	   	   	   - Ted


Theodore Ts'o (5):
  libext2fs: move the alignment field from unix_io to the io_manager
  libext2fs: refactor Direct I/O alignment requirement calculations
  libext2fs: make read_bitmaps() more efficient when using direct I/O
  libext2fs: factor out I/O buffer allocation
  Support systems without posix_memalign() and memalign()

 lib/ext2fs/Makefile.in   |    9 +++++++-
 lib/ext2fs/ext2_io.h     |    3 +++
 lib/ext2fs/ext2fs.h      |    1 +
 lib/ext2fs/getsectsize.c |   26 +++++++++++++++++++++
 lib/ext2fs/inline.c      |   56 ++++++++++++++++++++++++++++++++++++++++++++--
 lib/ext2fs/inode.c       |    4 ++--
 lib/ext2fs/io_manager.c  |   17 ++++++++++++++
 lib/ext2fs/mmp.c         |   37 ++++++++----------------------
 lib/ext2fs/openfs.c      |    2 +-
 lib/ext2fs/rw_bitmaps.c  |   24 ++++++++------------
 lib/ext2fs/test_io.c     |    7 +++++-
 lib/ext2fs/unix_io.c     |   42 +++++++++++++++-------------------
 12 files changed, 154 insertions(+), 74 deletions(-)

-- 
1.7.10.rc3

