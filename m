From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update
Date: Wed, 17 Oct 2007 00:26:30 -0400
Message-ID: <E1Ii0UI-0007TW-IM@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42887 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbXJQE0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 00:26:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

It has a number random cleanups and bug fixes, and two new features.
The first is uninitialized block groups, which allows fast mke2fs
operations plus as well as speeding up e2fsck by allowing it to skip
parts of the inode tables that haven't been used yet.  A checksum has
been added to block group descriptors so we can tell detect corruption
in that data structure, since we are depending on it being accurate so
we know what portion of the inode table is really in use.

The second feature is flexible block groups, which allows inode tables
and block/inode bitmaps to be grouped together outside of the block
group that they administer, to allow contiguous regions of data blocks
to span multiple block groups, which helps for large files significantly
bigger than the size of a block group (i.e., 32 gigabytes on a 4k block
filesystem).

All of these patches have been baking in -mm for a while.

Regards,

							- Ted

Andreas Dilger (1):
      Ext4: Uninitialized Block Groups

Aneesh Kumar K.V (8):
      ext4: Fix sparse warnings
      ext4: Convert bg_block_bitmap to bg_block_bitmap_lo
      ext4: Convert bg_inode_bitmap and bg_inode_table
      ext4: Convert s_blocks_count to s_blocks_count_lo
      ext4: Convert s_r_blocks_count and s_free_blocks_count
      ext4: Convert ext4_extent.ee_start to ext4_extent.ee_start_lo
      ext4: Convert ext4_extent_idx.ei_leaf to ext4_extent_idx.ei_leaf_lo
      ext4: sparse fixes

Coly Li (1):
      ext4: Remove (partial, never completed) fragment support

Eric Sandeen (3):
      ext4: remove #ifdef CONFIG_EXT4_INDEX
      ext4: fix setup_new_group_blocks locking
      ext4: lighten up resize transaction requirements

Jan Kara (1):
      jbd2: fix commit code to properly abort journal

Jose R. Santos (2):
      JBD2: debug code cleanup.
      ext4: FLEX_BG Kernel support v2.

Mingming Cao (6):
      JBD: JBD slab allocation cleanups
      JBD2: jbd2 slab allocation cleanups
      JBD: replace jbd_kmalloc with kmalloc directly
      JBD2: replace jbd_kmalloc with kmalloc directly.
      JBD2/Ext4: Convert kmalloc to kzalloc in jbd2/ext4
      jbd2: JBD_XXX to JBD2_XXX naming cleanup

 fs/Kconfig                      |    1 +
 fs/ext4/balloc.c                |  112 ++++++++++++++++++++++++++++-
 fs/ext4/dir.c                   |    7 --
 fs/ext4/extents.c               |   14 ++--
 fs/ext4/fsync.c                 |    2 +-
 fs/ext4/group.h                 |   27 +++++++
 fs/ext4/ialloc.c                |  151 +++++++++++++++++++++++++++++++++++----
 fs/ext4/inode.c                 |   18 ++----
 fs/ext4/namei.c                 |   20 -----
 fs/ext4/resize.c                |   59 +++++++++++-----
 fs/ext4/super.c                 |   97 +++++++++++++++++--------
 fs/ext4/xattr.c                 |    7 +-
 fs/jbd/commit.c                 |    6 +-
 fs/jbd/journal.c                |   99 ++------------------------
 fs/jbd/transaction.c            |   12 ++--
 fs/jbd2/commit.c                |   16 ++--
 fs/jbd2/journal.c               |  128 ++++-----------------------------
 fs/jbd2/recovery.c              |    2 +-
 fs/jbd2/revoke.c                |    4 +-
 fs/jbd2/transaction.c           |   19 +++---
 include/linux/ext4_fs.h         |  103 ++++++++++----------------
 include/linux/ext4_fs_extents.h |    4 +-
 include/linux/ext4_fs_i.h       |    5 --
 include/linux/ext4_fs_sb.h      |    3 -
 include/linux/ext4_jbd2.h       |    6 +-
 include/linux/jbd.h             |   17 +++--
 include/linux/jbd2.h            |   49 +++++++------
 include/linux/poison.h          |    3 +-
 28 files changed, 527 insertions(+), 464 deletions(-)
 create mode 100644 fs/ext4/group.h
