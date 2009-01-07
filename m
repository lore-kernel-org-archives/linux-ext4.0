From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 2.6.29
Date: Wed, 07 Jan 2009 13:42:30 -0500
Message-ID: <E1LKdMM-0001Og-C1@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33552 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650AbZAGSme (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 13:42:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This contains lots of cleanups as well as various bug fixes, some of
which will also need to included in the 2.6.28.x stable tree.  There are
also some performance improvements, such as Josef Bacik fsync batching,
and also of note Frank Mayhar from Google's extensions which allow ext4
to run without a journal.  (This way, if you are using aggressively
replicated filesets, and you want the performance improvements of ext4
--- extents, delayed allocation, et. al --- you can get it without the
overhead of the journal.  This is useful if your recovery mechanism on
an unclean shutdown is to mkfs the filesystem and recover it from one of
the other backup copies of the filesystem.  :-)   Finally, we have some
robustification patches which prevent ext4 from oops when given a
corrupted filesystem image.

Thanks!!

                                                - Ted

Alexander Beregalov (1):
      ext4: fix printk format warning

Aneesh Kumar K.V (20):
      ext4: Fix the delalloc writepages to allocate blocks at the right offset.
      ext4: avoid ext4_error when mounting a fs with a single bg
      ext4: Don't overwrite allocation_context ac_status
      ext4: sparse fixes
      ext4: Add blocks added during resize to bitmap
      ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize
      ext4: cleanup mballoc header files
      jbd2: Call journal commit callback without holding j_list_lock
      ext4: don't use blocks freed but not yet committed in buddy cache init
      ext4: Fix lockdep recursive locking warning
      ext4: fix BUG when calling ext4_error with locked block group
      ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
      ext4: Use high 16 bits of the block group descriptor's free counts fields
      ext4: code cleanup
      ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()
      ext4: Use new buffer_head flag to check uninit group bitmaps initialization
      ext4: mark the blocks/inode bitmap beyond end of group as used
      ext4: Don't allow new groups to be added during block allocation
      ext4: Init the complete page while building buddy cache
      ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc

Frank Mayhar (1):
      ext4: Allow ext4 to run without a journal

Jan Kara (1):
      jbd2: Fix oops in jbd2_journal_init_inode() on corrupted fs

Josef Bacik (1):
      jbd2: improve jbd2 fsync batching

Mark Fasheh (1):
      jbd2: Add BH_JBDPrivateStart

Roel Kluin (1):
      ext4: Use simple_strtol() instead of simple_strtoul() in ext4_ui_proc_open

Solofo.Ramangalahy@bull.net (1):
      ext4: When resizing set the EXT4_BG_INODE_ZEROED flag for new block groups

Theodore Ts'o (26):
      ext3: Add support for non-native signed/unsigned htree hash algorithms
      ext4: Add support for non-native signed/unsigned htree hash algorithms
      ext3/4: Fix loop index in do_split() so it is signed
      Update Documentation/filesystems/ext4.txt
      ext4: remove ext4_new_blocks() and call ext4_mb_new_blocks() directly
      ext4: remove ext4_new_meta_block()
      ext4: remove do_blk_alloc()
      ext4: tone down ext4_da_writepages warnings
      jbd2: Add barrier not supported test to journal_wait_on_commit_record
      ext4: remove extraneous newlines from calls to ext4_error() and ext4_warning()
      ext4: display average commit time
      ext4: add fsync batch tuning knobs
      ext4: Remove i_ext_generation from ext4_inode_info structure
      ext4: Make ext4_group_t be an unsigned int
      ext4: Change unsigned long to unsigned int
      jbd2: Remove a large array of bh's from the stack of the checkpoint routine
      add releasepage hooks to block devices which can be used by file systems
      ext4: Remove code to create the journal inode
      ext4: Add markers for better debuggability
      jbd2: Add pid and journal device name to the "kjournald2 starting" message
      jbd2: Submit writes to the journal using WRITE_SYNC
      ext4: Add mount option to set kjournald's I/O priority
      ext4: Add sanity checks for the superblock before mounting the filesystem
      ext4: Make printk's consistently prefixed with "EXT4-fs: "
      block: Add Kconfig help which notes that ext4 needs CONFIG_LBD
      ext4: Remove "extents" mount option

Toshiyuki Okajima (2):
      ext3: provide function to release metadata pages under memory pressure
      ext4: provide function to release metadata pages under memory pressure

Wu Fengguang (1):
      ext4: fix build warning

Yasunori Goto (1):
      ext4: Widen type of ext4_sb_info.s_mb_maxs[]

 Documentation/filesystems/ext4.txt |   85 ++++-
 block/Kconfig                      |    6 +
 fs/block_dev.c                     |   15 +
 fs/ext3/hash.c                     |   77 ++++-
 fs/ext3/namei.c                    |   11 +-
 fs/ext3/super.c                    |   33 ++
 fs/ext4/balloc.c                   |  293 ++++++------------
 fs/ext4/bitmap.c                   |    5 +-
 fs/ext4/dir.c                      |   10 +-
 fs/ext4/ext4.h                     |  152 +++++++--
 fs/ext4/ext4_extents.h             |    5 -
 fs/ext4/ext4_i.h                   |   16 +-
 fs/ext4/ext4_jbd2.c                |   83 ++++--
 fs/ext4/ext4_jbd2.h                |   87 ++++-
 fs/ext4/ext4_sb.h                  |    6 +-
 fs/ext4/extents.c                  |   60 ++--
 fs/ext4/file.c                     |    3 -
 fs/ext4/hash.c                     |   77 ++++-
 fs/ext4/ialloc.c                   |  324 +++++++++++--------
 fs/ext4/inode.c                    |  309 +++++++++++++-----
 fs/ext4/ioctl.c                    |    2 +-
 fs/ext4/mballoc.c                  |  629 ++++++++++++++++++++++++++----------
 fs/ext4/mballoc.h                  |   71 +----
 fs/ext4/migrate.c                  |   19 +-
 fs/ext4/namei.c                    |   92 +++---
 fs/ext4/resize.c                   |  113 ++-----
 fs/ext4/super.c                    |  622 ++++++++++++++++++++++-------------
 fs/ext4/xattr.c                    |   25 +-
 fs/ioprio.c                        |    3 +-
 fs/jbd2/checkpoint.c               |   24 +-
 fs/jbd2/commit.c                   |   58 +++-
 fs/jbd2/journal.c                  |  124 +++-----
 fs/jbd2/transaction.c              |   60 +++-
 fs/super.c                         |    2 +
 include/linux/ext3_fs.h            |   28 ++-
 include/linux/ext3_fs_sb.h         |    1 +
 include/linux/fs.h                 |    2 +
 include/linux/ioprio.h             |    2 +
 include/linux/jbd2.h               |   39 ++-
 39 files changed, 2272 insertions(+), 1301 deletions(-)
