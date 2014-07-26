From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] miscellaneous bug fixes for e2fsprogs
Date: Sat, 26 Jul 2014 09:48:28 -0400
Message-ID: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58033 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbaGZNsh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches fix a number of problems I found while messing
around with resizing large (>16TB) partitions.  Some of these are
serious enough that I will probably end up releasing a 1.42.12
release.

Theodore Ts'o (6):
  tests: use e2fsck -f instead of -p for resize tests
  libext2fs: fix rb_resize_bmap to handle the padding bits
  resize2fs: radically reduce memory utilization by using rbtree bitmaps
  libext2fs: use C99 initializers for the io_manager structure
  Fix 32/64-bit overflow when multiplying by blocks/clusters per group
  libext2fs: fix free block accounting for 64-bit file systems

 e2fsck/pass5.c                |  2 +-
 e2fsck/super.c                |  2 +-
 lib/ext2fs/alloc_stats.c      |  4 ++--
 lib/ext2fs/blkmap64_rb.c      | 14 +++++------
 lib/ext2fs/blknum.c           |  2 +-
 lib/ext2fs/dosio.c            | 17 ++++++-------
 lib/ext2fs/ext2_fs.h          |  5 ++++
 lib/ext2fs/imager.c           | 14 +++++------
 lib/ext2fs/inode_io.c         | 24 +++++++++----------
 lib/ext2fs/nt_io.c            | 18 +++++++-------
 lib/ext2fs/rw_bitmaps.c       |  4 ++--
 lib/ext2fs/test_io.c          | 28 +++++++++++-----------
 lib/ext2fs/undo_io.c          | 26 ++++++++++----------
 lib/ext2fs/unix_io.c          | 28 +++++++++++-----------
 misc/tune2fs.c                |  2 +-
 resize/main.c                 |  1 +
 resize/resize2fs.c            | 11 ++++-----
 tests/m_64bit_flexbg/expect.1 | 55 +++++++++++++++++++++++++++++++++++++++++++
 tests/m_64bit_flexbg/script   |  4 ++++
 tests/scripts/resize_test     | 16 ++++++-------
 util/gcc-wall-cleanup         |  1 -
 21 files changed, 168 insertions(+), 110 deletions(-)
 create mode 100644 tests/m_64bit_flexbg/expect.1
 create mode 100644 tests/m_64bit_flexbg/script

-- 
2.0.0

