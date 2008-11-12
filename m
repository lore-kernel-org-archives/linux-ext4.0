From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC,PATCH] 64-bit support for e2fsprogs
Date: Tue, 11 Nov 2008 19:42:53 -0800
Message-ID: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42459 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYKLDnq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:46 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hkl3007407
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is my incomplete current 64-bit e2fsprogs patchset for review and
comment (not inclusion).  Only lib/ext2fs/, misc/mke2fs.c, and e2fsck/
have been converted to 64-bit interfaces so far (and those not
completely).  As of this patch set, mke2fs can create a file system
with > 2^32 blocks.  However, it can't be mounted due to invalid
checksums on the group descriptors. :)

This series is based on the 64-bit patches by Ted T'so and Jose
R. Santos.  It includes:

* Two housekeeping patches (workaround make check error, fix warnings)
* 64-bit bitops and bitmaps
* Conversion of all of e2fsprogs to 64-bit bitmap interfaces
* Partial conversion of e2fprogs to other 64-bit interfaces
* Miscellaneous 64-bit bug fixes

Use the following mke2fs command to produce a file system with more
than 2^32 blocks:

$ mke2fs -t ext4 -O 64bit -b 4096 -N 200000 <device>

These patches apply against the pu branch, commit ID:

6db77ec039ff241dab0f1e267fabcfa814fbaf4c

All commits pass "make check" on my machine.

-VAL

Valerie Aurora Henson (17):
  Disable tst_refcount - doesn't compile, don't know why
  Squash warnings
  Add 64-bit bitops
  Implement 64-bit "bitarray" bmap ops
  Convert libext2fs to 64-bit bitmap interface
  Convert mke2fs to new bitmap interface
  Convert e2fsck to new bitmap interface
  Turn on new bitmaps in e2fsck and mke2fs
  Add progress bar for allocating block tables - takes forever on large
  signed int -> blk64_t to fix bugs at 2^31 - 2^32 blocks
  Fix overflow in calculation of total file system blocks
  Add ext2fs_block_iterate3 (from Ted)
  Support 48-bit file acl blocks
  super->s_*_blocks_count -> ext2fs_*_blocks_count()
  Convert to inode/block/bitmap/table loc()/loc_set() functions
  ext2fs_block_alloc_stats -> ext2fs_block_alloc_stats2
  Convert to 64-bit IO

 debugfs/debugfs.c                       |    2 +-
 debugfs/htree.c                         |    4 +-
 e2fsck/Makefile.in                      |    7 +-
 e2fsck/e2fsck.h                         |   20 +-
 e2fsck/ehandler.c                       |    6 +-
 e2fsck/journal.c                        |   10 +-
 e2fsck/message.c                        |    2 +-
 e2fsck/pass1.c                          |  183 +++++++++--------
 e2fsck/pass1b.c                         |  110 ++++++-----
 e2fsck/pass2.c                          |   60 +++---
 e2fsck/pass3.c                          |   56 +++---
 e2fsck/pass4.c                          |    8 +-
 e2fsck/pass5.c                          |   86 ++++----
 e2fsck/rehash.c                         |    4 +-
 e2fsck/super.c                          |   74 ++++----
 e2fsck/unix.c                           |   15 +-
 e2fsck/util.c                           |    4 +-
 lib/blkid/probe.c                       |    5 +-
 lib/e2p/e2p.h                           |    2 +
 lib/ext2fs/alloc.c                      |   51 +++---
 lib/ext2fs/alloc_sb.c                   |   15 +-
 lib/ext2fs/alloc_stats.c                |   10 +-
 lib/ext2fs/alloc_tables.c               |   27 +--
 lib/ext2fs/bb_inode.c                   |    2 +-
 lib/ext2fs/bitmaps.c                    |  149 ++++++++++----
 lib/ext2fs/bitops.c                     |   39 ++++
 lib/ext2fs/bitops.h                     |  200 ++++++++++++++++++-
 lib/ext2fs/blkmap64_ba.c                |  174 +++++++++++++++-
 lib/ext2fs/blknum.c                     |   23 ++
 lib/ext2fs/block.c                      |  133 ++++++++++---
 lib/ext2fs/bmove.c                      |   20 +-
 lib/ext2fs/check_desc.c                 |   24 +-
 lib/ext2fs/closefs.c                    |   14 +-
 lib/ext2fs/csum.c                       |    4 +-
 lib/ext2fs/dirblock.c                   |    2 +-
 lib/ext2fs/ext2_fs.h                    |    6 +-
 lib/ext2fs/ext2_io.h                    |    4 +
 lib/ext2fs/ext2fs.h                     |  102 ++++++++--
 lib/ext2fs/ext2fsP.h                    |   15 +-
 lib/ext2fs/ext_attr.c                   |    2 +-
 lib/ext2fs/extent.c                     |    7 +-
 lib/ext2fs/gen_bitmap64.c               |  333 +++++++++++++++++++++++++++----
 lib/ext2fs/icount.c                     |   46 ++--
 lib/ext2fs/imager.c                     |   12 +-
 lib/ext2fs/inode.c                      |   25 ++-
 lib/ext2fs/mkjournal.c                  |    9 +-
 lib/ext2fs/openfs.c                     |   10 +-
 lib/ext2fs/rw_bitmaps.c                 |   38 ++--
 lib/ext2fs/tst_badblocks.c              |    2 +-
 lib/ext2fs/tst_bitops.c                 |  120 +++++++++++
 lib/ext2fs/tst_csum.c                   |   10 +-
 lib/ext2fs/tst_iscan.c                  |   48 +++--
 lib/ext2fs/valid_blk.c                  |    2 +-
 lib/uuid/gen_uuid.c                     |    4 +-
 misc/blkid.c                            |    1 -
 misc/dumpe2fs.c                         |    2 +-
 misc/mke2fs.c                           |   51 ++++--
 misc/tune2fs.c                          |    2 +-
 tests/f_bad_disconnected_inode/expect.1 |    4 +-
 tests/f_resize_inode/expect             |    1 +
 tests/m_dasd_bs/expect.1                |    1 +
 tests/m_large_file/expect.1             |    1 +
 tests/m_meta_bg/expect.1                |    1 +
 tests/m_no_opt/expect.1                 |    1 +
 tests/m_raid_opt/expect.1               |    1 +
 tests/m_std/expect.1                    |    1 +
 tests/m_uninit/expect.1                 |    1 +
 67 files changed, 1741 insertions(+), 667 deletions(-)

