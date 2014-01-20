From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/12] e2fsprogs mke2fs optimizations and new features
Date: Mon, 20 Jan 2014 00:54:02 -0500
Message-ID: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49966 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaATFy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is the latest version of the patches I've been working on optimize
creating very large file systems, and allowing the file system to be
created with the metadata blocks located at the beginning of the device,
so the data block area can be made maximally contiguous.

An example of the optimizations and new features added in this patch
set:

% cp /dev/null /tmp/foo.img
% mke2fs -F -t ext4 -O sparse_super2 -E num_backup_sb=0,packed_meta_blocks /tmp/foo.img 64T


Theodore Ts'o (12):
  libext2fs: fix off-by-one bug in ext2fs_extent_insert()
  libext2fs: clean up generic handling of
    ext2fs_find_first_{set,zero}_*()
  libext2fs: build tst_bitmaps with rep invariants checking enabled
  libext: optimize find_first_set() for bitarray-based bitmaps
  libext2fs: optimize find_first_{zero,set}() for red-black tree based
    bitmaps
  libext2fs: further clean up and rename check_block_uninit
  libext2fs: add ext2fs_block_alloc_stats_range()
  libext2fs: optimize ext2fs_allocate_group_table()
  libext2: optimize ext2fs_new_block2()
  mke2fs: optimize fix_cluster_bg_counts()
  Add support for new compat feature "sparse_super2"
  mke2fs: allow metadata blocks to be at the beginning of the file
    system

 debugfs/set_fields.c        |   2 +
 lib/e2p/feature.c           |   2 +
 lib/e2p/ls.c                |   8 ++
 lib/ext2fs/Makefile.in      |   7 +-
 lib/ext2fs/alloc.c          |  65 +++++-----------
 lib/ext2fs/alloc_stats.c    |  41 ++++++++++
 lib/ext2fs/alloc_tables.c   |  22 ++----
 lib/ext2fs/blkmap64_ba.c    |  83 ++++++++++++++++++--
 lib/ext2fs/blkmap64_rb.c    | 103 ++++++++++++++++++++++++-
 lib/ext2fs/closefs.c        |  12 ++-
 lib/ext2fs/ext2_fs.h        |   4 +-
 lib/ext2fs/ext2fs.h         |   6 +-
 lib/ext2fs/extent.c         |   4 +-
 lib/ext2fs/gen_bitmap64.c   |  66 ++++++++--------
 lib/ext2fs/initialize.c     |   2 +
 lib/ext2fs/mkjournal.c      |   5 +-
 lib/ext2fs/res_gdt.c        |  13 ++++
 lib/ext2fs/swapfs.c         |   2 +
 lib/ext2fs/tst_super_size.c |   3 +-
 misc/ext4.5.in              |  11 +++
 misc/mke2fs.8.in            |  20 +++++
 misc/mke2fs.c               | 136 ++++++++++++++++++++++++++++-----
 misc/mke2fs.conf.5.in       |   9 +++
 resize/online.c             |   8 ++
 resize/resize2fs.c          | 182 +++++++++++++++++++++++++++++++++++++++++++-
 25 files changed, 688 insertions(+), 128 deletions(-)

-- 
1.8.5.rc3.362.gdf10213

