From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 0/7] 64bit inode e2fsprogs support
Date: Tue, 14 Nov 2017 10:04:33 +0300
Message-ID: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:51853 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbdKNHEq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 02:04:46 -0500
Received: by mail-lf0-f68.google.com with SMTP id f134so12754364lfg.8
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 23:04:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With current hardware clusters faced with the trouble of
creating enough inodes on partitions. Lustre has 0-size
files to store some information about files. Current
MDS disk sizes allow to store large amount of such files, but
EXT4 limits this number to ~4 billions.

Lustre FS has features like DNE to distribute metadata over many targets
(disks), but disks are used not effectively. It would be great to have
ability to store more then ~4 billions inodes on one EXT4 file system.

These patches add 64bit inodes support for e2fsprogs.

Second version of patches set. Changes since v1:
* code style fixes
* allow to store multiple FIDs in the dirent 
* fixed PR_2_CLEAR_DIRDATA problem number
* excluded fix "e2fsck Fix access after free for dx_db structure"
* corrected "ls" output
* super_fields accept a 64-bit value directly 
* feature renamed to EXT4_FEATURE_INCOMPAT_64INODE
* removed 64-bit badblock inodes code. Should send as
  separate feature
* new fields type changed to __le32
* don't change ext2_ino_t type, but add ext2_ino64_t
* use explicit ext2_ino64_t type, not unsigned long
* fixed fields order check
* fixed "inode_ratio" calculation
* quota_sb_inump renamed to quota_sb_inum

Andreas Dilger (2):
  e2fsck: add support for dirdata feature
  tests: add basic tests for dirdata feature

Artem Blagodarenko (4):
  debugfs: 64bit inode support
  ext2fs: add EXT4_FEATURE_INCOMPAT_64INODE support
  quota: swapping s_prj_quota_inum superblock field
  quota: quota 64bit inode number cleanup

Bobi Jam (1):
  tests: e2fsck -D does not change dirdata

 debugfs/debugfs.c                 |   2 +-
 debugfs/htree.c                   |   2 +-
 debugfs/ls.c                      |  46 +++-
 debugfs/set_fields.c              |   3 +-
 debugfs/util.c                    |   5 +-
 e2fsck/extents.c                  |   8 +-
 e2fsck/journal.c                  |   2 +-
 e2fsck/pass1.c                    |  22 +-
 e2fsck/pass1b.c                   |   2 +-
 e2fsck/pass2.c                    | 137 ++++++++--
 e2fsck/pass3.c                    |   8 +
 e2fsck/pass4.c                    |   2 +-
 e2fsck/pass5.c                    |  20 +-
 e2fsck/problem.c                  |   5 +
 e2fsck/problem.h                  |   3 +
 e2fsck/quota.c                    |  10 +-
 e2fsck/rehash.c                   |  78 +++---
 e2fsck/super.c                    |  18 +-
 e2fsck/unix.c                     |  17 +-
 ext2ed/inode_com.c                |   7 +-
 ext2ed/super_com.c                |   6 +-
 lib/e2p/feature.c                 |   2 +
 lib/e2p/ls.c                      |  12 +-
 lib/ext2fs/alloc.c                |   8 +-
 lib/ext2fs/alloc_stats.c          |   6 +-
 lib/ext2fs/bitmaps.c              |   2 +-
 lib/ext2fs/dirblock.c             |  34 +++
 lib/ext2fs/ext2_fs.h              |  27 +-
 lib/ext2fs/ext2fs.h               |  66 ++++-
 lib/ext2fs/extent.c               |   2 +-
 lib/ext2fs/gen_bitmap64.c         |   3 +-
 lib/ext2fs/get_num_dirs.c         |   4 +-
 lib/ext2fs/icount.c               |   7 +-
 lib/ext2fs/initialize.c           |  19 +-
 lib/ext2fs/inline_data.c          |  16 +-
 lib/ext2fs/inode.c                |   8 +-
 lib/ext2fs/lfsck.h                |  42 ++++
 lib/ext2fs/link.c                 |  10 +-
 lib/ext2fs/newdir.c               |   4 +-
 lib/ext2fs/openfs.c               |   4 +-
 lib/ext2fs/rw_bitmaps.c           |   2 +-
 lib/ext2fs/swapfs.c               |   4 +
 lib/ext2fs/tst_bitmaps.c          |   7 +-
 lib/ext2fs/tst_iscan.c            |   2 +-
 lib/ext2fs/tst_super_size.c       |   5 +-
 lib/support/mkquota.c             |  10 +-
 lib/support/quotaio.c             |   2 +-
 lib/support/quotaio.h             |  39 ++-
 misc/findsuper.c                  |   8 +-
 misc/fuse2fs.c                    |   6 +-
 misc/mke2fs.c                     |  30 ++-
 misc/tune2fs.c                    |  16 +-
 resize/main.c                     |   3 +-
 resize/resize2fs.c                |  30 +--
 tests/f_dir_optimize/expect.1     | 511 ++++++++++++++++++++++++++++++++++++++
 tests/f_dir_optimize/expect.2     | 511 ++++++++++++++++++++++++++++++++++++++
 tests/f_dir_optimize/image.gz     | Bin 0 -> 102520 bytes
 tests/f_dir_optimize/name         |   1 +
 tests/f_dir_optimize/script       |  36 +++
 tests/f_dirdata/expect.1          |  15 ++
 tests/f_dirdata/expect.2          |   7 +
 tests/f_dirdata/image.gz          | Bin 0 -> 72169 bytes
 tests/f_dirdata/name              |   1 +
 tests/f_dirdata_optimize/expect.1 |  10 +
 tests/f_dirdata_optimize/expect.2 |   7 +
 tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
 tests/f_dirdata_optimize/name     |   1 +
 tests/f_dirdata_optimize/script   |   3 +
 tests/progs/test_icount.c         |   4 +-
 69 files changed, 1723 insertions(+), 227 deletions(-)
 create mode 100644 lib/ext2fs/lfsck.h
 create mode 100644 tests/f_dir_optimize/expect.1
 create mode 100644 tests/f_dir_optimize/expect.2
 create mode 100644 tests/f_dir_optimize/image.gz
 create mode 100644 tests/f_dir_optimize/name
 create mode 100644 tests/f_dir_optimize/script
 create mode 100644 tests/f_dirdata/expect.1
 create mode 100644 tests/f_dirdata/expect.2
 create mode 100644 tests/f_dirdata/image.gz
 create mode 100644 tests/f_dirdata/name
 create mode 100644 tests/f_dirdata_optimize/expect.1
 create mode 100644 tests/f_dirdata_optimize/expect.2
 create mode 100644 tests/f_dirdata_optimize/image.gz
 create mode 100644 tests/f_dirdata_optimize/name
 create mode 100644 tests/f_dirdata_optimize/script

-- 
2.13.6 (Apple Git-96)
