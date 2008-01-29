From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [GIT PULL] ext4 update
Date: Tue, 29 Jan 2008 00:50:42 -0500
Message-ID: <E1JJjMo-00011j-EU@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65416 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825AbYA2Fu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2008 00:50:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This is the major set of updates meant for 2.6.24 from the ext4 team;
these patches have been baking in -mm for a while.  The two major
features included here is the multi-block allocator that has been in use
by Clusterfs for their luster filesystem, as well as the journal
checksumming features.  There were also a huge number of clean ups and
various bug fixes.

Regards,

						- Ted

Adrian Bunk (1):
      ext4/super.c: fix #ifdef's (CONFIG_EXT4_* -> CONFIG_EXT4DEV_*)

Alex Tomas (2):
      ext4: Add new functions for searching extent tree
      ext4: Add multi block allocator for ext4

Aneesh Kumar K.V (23):
      ext4: Introduce ext4_lblk_t
      ext4: Introduce ext4_update_*_feature
      ext4:  Fix sparse warnings.
      ext4: Rename i_file_acl to i_file_acl_lo
      ext4: Rename i_dir_acl to i_size_high
      ext4: Add support for 48 bit inode i_blocks.
      ext4: Support large files
      ext2: Fix the max file size for ext2 file system.
      ext3: Fix the max file size for ext3 file system.
      ext4: Return after ext4_error in case of failures
      ext4: Change the default behaviour on error
      Add buffer head related helper functions
      ext4: add block bitmap validation
      ext4: Check for the correct error return from
      ext4: Make ext4_get_blocks_wrap take the truncate_mutex early.
      ext4: Convert truncate_mutex to read write semaphore.
      ext4: Take read lock during overwrite case.
      ext4: Add EXT4_IOC_MIGRATE ioctl
      ext4: Fix ext4_show_options to show the correct mount options.
      ext4: Add ext4_find_next_bit()
      ext4: Enable the multiblock allocator by default
      ext4: Check for return value from sb_set_blocksize
      ext4: Use the ext4_ext_actual_len() helper function

Avantika Mathur (2):
      ext4: add ext4_group_t, and change all group variables to this type.
      ext4: fixes block group number being set to a negative value

Chris Snook (1):
      jbd2: Remove printk from J_ASSERT to preserve registers during BUG

Coly Li (1):
      ext4: sync up block group descriptor with e2fsprogs.

Dmitry Monakhov (1):
      ext4: fix uniniatilized extent splitting error

Eric Sandeen (6):
      ext4 extents: remove unneeded casts
      ext4: different maxbytes functions for bitmap & extent	files
      ext4: export iov_shorten from kernel for ext4's use
      ext4: store maxbytes for bitmapped  files and return EFBIG as appropriate
      ext4: fix oops on corrupted ext4 mount
      ext4: fix up EXT4FS_DEBUG builds

Girish Shilamkar (1):
      ext4: Add the journal checksum feature

Jan Kara (2):
      ext4: Avoid rec_len overflow with 64KB block size
      jbd2: Fix assertion failure in fs/jbd2/checkpoint.c

Jean Noel Cordenner (2):
      vfs: Add 64 bit i_version support
      ext4: Add inode version support in ext4

Johann Lombardi (1):
      jbd2: jbd2 stats through procfs

Mariusz Kozlowski (1):
      ext4: remove unused code from ext4_find_entry()

Miklos Szeredi (1):
      ext4: Add stripe= option to /proc/mounts

Mingming Cao (4):
      jbd2: add lockdep support
      jbd2: Mark jbd2 slabs as SLAB_TEMPORARY
      jbd2: Use round-jiffies() function for the "5 second" ext4/jbd2 wakeup
      jbd2: sparse pointer use of zero as null

Takashi Sato (1):
      ext4:  Support large blocksize up to PAGESIZE

 Documentation/filesystems/ext4.txt             |   10 
 b/Documentation/filesystems/ext4.txt           |   10 
 b/Documentation/filesystems/proc.txt           |   39 
 b/fs/Kconfig                                   |    1 
 b/fs/afs/dir.c                                 |    9 
 b/fs/afs/inode.c                               |    3 
 b/fs/buffer.c                                  |   44 
 b/fs/ext2/super.c                              |   32 
 b/fs/ext3/super.c                              |   32 
 b/fs/ext4/Makefile                             |    2 
 b/fs/ext4/balloc.c                             |   67 
 b/fs/ext4/dir.c                                |    2 
 b/fs/ext4/extents.c                            |   24 
 b/fs/ext4/file.c                               |    4 
 b/fs/ext4/group.h                              |    8 
 b/fs/ext4/ialloc.c                             |    2 
 b/fs/ext4/inode.c                              |   15 
 b/fs/ext4/ioctl.c                              |    3 
 b/fs/ext4/mballoc.c                            | 4552 +++++++++++++++++++++++++
 b/fs/ext4/migrate.c                            |  570 +++
 b/fs/ext4/namei.c                              |    4 
 b/fs/ext4/resize.c                             |   16 
 b/fs/ext4/super.c                              |   15 
 b/fs/ext4/xattr.c                              |    4 
 b/fs/inode.c                                   |   17 
 b/fs/jbd2/checkpoint.c                         |   10 
 b/fs/jbd2/commit.c                             |  198 -
 b/fs/jbd2/journal.c                            |    4 
 b/fs/jbd2/recovery.c                           |  151 
 b/fs/jbd2/revoke.c                             |    6 
 b/fs/jbd2/transaction.c                        |   12 
 b/fs/read_write.c                              |    1 
 b/include/asm-arm/bitops.h                     |    2 
 b/include/asm-generic/bitops/ext2-non-atomic.h |    2 
 b/include/asm-generic/bitops/le.h              |    4 
 b/include/asm-m68k/bitops.h                    |    2 
 b/include/asm-m68knommu/bitops.h               |    2 
 b/include/asm-powerpc/bitops.h                 |    4 
 b/include/asm-s390/bitops.h                    |    2 
 b/include/linux/buffer_head.h                  |    2 
 b/include/linux/ext4_fs.h                      |   76 
 b/include/linux/ext4_fs_extents.h              |    4 
 b/include/linux/ext4_fs_i.h                    |    4 
 b/include/linux/ext4_fs_sb.h                   |   52 
 b/include/linux/fs.h                           |   16 
 b/include/linux/jbd2.h                         |    4 
 b/lib/find_next_bit.c                          |   43 
 fs/ext4/Makefile                               |    2 
 fs/ext4/balloc.c                               |  184 -
 fs/ext4/dir.c                                  |   12 
 fs/ext4/extents.c                              |  501 +-
 fs/ext4/file.c                                 |   19 
 fs/ext4/ialloc.c                               |  159 
 fs/ext4/inode.c                                |  381 +-
 fs/ext4/ioctl.c                                |    4 
 fs/ext4/namei.c                                |  131 
 fs/ext4/resize.c                               |   12 
 fs/ext4/super.c                                |  374 +-
 fs/inode.c                                     |   22 
 fs/jbd2/checkpoint.c                           |   12 
 fs/jbd2/commit.c                               |   57 
 fs/jbd2/journal.c                              |  364 +
 fs/jbd2/transaction.c                          |   22 
 include/linux/ext4_fs.h                        |  148 
 include/linux/ext4_fs_extents.h                |   21 
 include/linux/ext4_fs_i.h                      |   21 
 include/linux/ext4_fs_sb.h                     |    3 
 include/linux/fs.h                             |    5 
 include/linux/jbd2.h                           |  131 
 69 files changed, 7773 insertions(+), 898 deletions(-)
