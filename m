From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 00/22] Add XIP support to ext4
Date: Sun, 22 Dec 2013 16:49:27 -0500
Message-ID: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

... or, as it should probably be called now "Complete rewrite of everything
XIP related".  It's only compile-tested; before I get too much further down
this path, I wanted to get some opinions on the approach.

Matthew Wilcox (21):
  Fix XIP fault vs truncate race
  Simplify COW of XIP mappings
  axonram: Fix bug in direct_access
  Change direct_access calling convention
  Introduce IS_XIP(inode)
  Treat XIP like O_DIRECT
  Rewrite XIP page fault handling
  Change xip_truncate_page to take a get_block parameter
  Remove mm/filemap_xip.c
  Remove get_xip_mem
  Replace ext2_clear_xip_target with xip_clear_blocks
  ext2: Remove ext2_xip_verify_sb()
  ext2: Remove ext2_use_xip
  ext2: Remove xip.c and xip.h
  Remove CONFIG_EXT2_FS_XIP
  ext2: Remove ext2_aops_xip
  xip: Add xip_zero_page_range
  ext4: Make ext4_block_zero_page_range static
  ext4: Fix typos
  Add support for pmd_faults
  xip: Add reporting of major faults

Ross Zwisler (1):
  ext4: Add XIP functionality

 Documentation/filesystems/Locking  |   3 -
 Documentation/filesystems/ext4.txt |   2 +
 Documentation/filesystems/xip.txt  | 119 ++++-----
 arch/powerpc/sysdev/axonram.c      |   8 +-
 drivers/block/brd.c                |   8 +-
 drivers/s390/block/dcssblk.c       |  19 +-
 fs/Kconfig                         |  21 +-
 fs/Makefile                        |   1 +
 fs/exofs/inode.c                   |   1 -
 fs/ext2/Kconfig                    |  11 -
 fs/ext2/Makefile                   |   1 -
 fs/ext2/ext2.h                     |   1 -
 fs/ext2/file.c                     |  44 +++-
 fs/ext2/inode.c                    |  35 +--
 fs/ext2/namei.c                    |   9 +-
 fs/ext2/super.c                    |  38 ++-
 fs/ext2/xip.c                      |  91 -------
 fs/ext2/xip.h                      |  26 --
 fs/ext4/ext4.h                     |   4 +-
 fs/ext4/file.c                     |  54 ++++-
 fs/ext4/indirect.c                 |  19 +-
 fs/ext4/inode.c                    | 106 +++++---
 fs/ext4/namei.c                    |  10 +-
 fs/ext4/super.c                    |  39 ++-
 fs/open.c                          |   5 +-
 fs/xip.c                           | 432 +++++++++++++++++++++++++++++++++
 include/linux/blkdev.h             |   4 +-
 include/linux/fs.h                 |  48 +++-
 include/linux/mm.h                 |   6 +
 mm/Makefile                        |   1 -
 mm/fadvise.c                       |   6 +-
 mm/filemap.c                       |   6 +-
 mm/filemap_xip.c                   | 483 -------------------------------------
 mm/madvise.c                       |   2 +-
 mm/memory.c                        |  69 +++++-
 35 files changed, 901 insertions(+), 831 deletions(-)
 delete mode 100644 fs/ext2/xip.c
 delete mode 100644 fs/ext2/xip.h
 create mode 100644 fs/xip.c
 delete mode 100644 mm/filemap_xip.c

-- 
1.8.4.rc3

