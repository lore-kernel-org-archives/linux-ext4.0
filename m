From: Theodore Ts'o <tytso@mit.edu>
Subject: ext4 updates for v3.7
Date: Fri, 05 Oct 2012 14:54:53 -0400
Message-ID: <nsxehlc3g1u.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54020 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2JESy4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 14:54:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 89a4e48f8479f8145eca9698f39fe188c982212f:

  ext4: fix kernel BUG on large-scale rm -rf commands (2012-08-17 09:42:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to c278531d39f3158bfee93dc67da0b77e09776de2:

  ext4: fix ext4_flush_completed_IO wait semantics (2012-10-05 11:31:55 -0400)

----------------------------------------------------------------
The big new feature added this time is supporting online resizing
using the meta_bg feature.  This allows us to resize file systems
which are greater than 16TB.  In addition, the speed of online
resizing has been improved in general.

We also fix a number of races, some of which could lead to deadlocks,
in ext4's Asynchronous I/O and online defrag support, thanks to good
work by Dmitry Monakhov.

There are also a large number of more minor bug fixes and cleanups
from a number of other ext4 contributors, quite of few of which have
submitted fixes for the first time.

----------------------------------------------------------------
Anatol Pomozov (3):
      ext4: realign trace events structs to make it smaller
      ext4: add missing space to trace message
      ext4: make orphan functions be no-op in no-journal mode

Andrey Sidorov (1):
      ext4: speed up truncate/unlink by not using bforget() unless needed

Ashish Sangwan (1):
      ext4: no need to add inode to orphan list during hole punch

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Carlos Maiolino (2):
      ext4: fix possible non-initialized variable in htree_dirblock_to_tree()
      ext4: ext4_bread usage audit

Djalal Harouni (1):
      ext4: release donor reference when EXT4_IOC_MOVE_EXT ioctl fails

Dmitry Monakhov (16):
      ext4: fix double unlock buffer mess during fs-resize
      ext4: move_extent code cleanup
      ext4: online defrag is not supported for journaled files
      ext4: clean up online defrag bugs in move_extent_per_page()
      ext4: reimplement uninit extent optimization for move_extent_per_page()
      ext4: ext4_inode_info diet
      ext4: give i_aiodio_unwritten a more appropriate name
      ext4: fix unwritten counter leakage
      ext4: completed_io locking cleanup
      ext4: serialize dio nonlocked reads with defrag workers
      ext4: serialize unlocked dio reads with truncate
      ext4: endless truncate due to nonlocked dio readers
      ext4: serialize truncate with owerwrite DIO workers
      ext4: punch_hole should wait for DIO writers
      ext4: fix ext_remove_space for punch_hole case
      ext4: fix ext4_flush_completed_IO wait semantics

Eric Sandeen (2):
      jbd2: don't write superblock when if its empty
      ext4: don't clear orphan list on ro mount with errors

Herton Ronaldo Krzesinski (1):
      ext4: fix crash when accessing /proc/mounts concurrently

Jan Kara (2):
      ext4: fix fdatasync() for files with only i_size changes
      jbd2: fix assertion failure in commit code due to lacking transaction credits

Lukas Czerner (2):
      ext4: remove unused function ext4_ext_check_cache
      ext4: enable FITRIM ioctl on bigalloc file system

Robin Dong (2):
      ext4: remove unused macro MB_DEFAULT_MAX_GROUPS_TO_SCAN
      ext4: remove unused function argument 'order' in mb_find_extent()

Sachin Kamat (1):
      ext4: replace plain integer with NULL in super.c

Tao Ma (2):
      ext4: remove erroneous ext4_superblock_csum_set() in update_backups()
      ext4: don't call update_backups() multiple times for the same bg

Theodore Ts'o (19):
      ext4: collapse a single extent tree block into the inode if possible
      ext4: don't load the block bitmap for block groups which have no space
      ext4: add max_dir_size_kb mount option
      jbd2: check return value of blkdev_issue_flush()
      ext4: check return value of blkdev_issue_flush()
      ext4: return an error if kset_create_and_add fails in ext4_init_fs()
      ext4: drop lock_super()/unlock_super()
      ext4: grow the s_flex_groups array as needed when resizing
      ext4: grow the s_group_info array as needed
      ext4: set bg_itable_unused when resizing
      ext4: convert file system to meta_bg if needed during resizing
      ext4: log a resize update to the console every 10 seconds
      ext4: advertise the fact that the kernel supports meta_bg resizing
      ext4: do not enable delalloc by default for ext2
      ext4: re-enable -o discard functionality in no-journal mode
      ext4: fix online resizing when the # of block groups is constant
      ext4: fix potential deadlock in ext4_nonda_switch()
      fs: reserve fallocate flag codepoint
      ext4: fix mtime update in nodelalloc mode

Wang Sheng-Hui (2):
      ext4: fix trivial typo in comment
      ext4: remove redundant offset check in mext_check_arguments()

Wei Yongjun (2):
      ext4: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      ext4: convert to use leXX_add_cpu()

Yongqiang Yang (7):
      ext4: ignore last group w/o enough space when resizing instead of BUG'ing
      ext4: report the original old blocks count in a debug message when resizing
      ext4: don't copy non-existent gdt blocks when resizing
      ext4: avoid duplicate writes of the backup bg descriptor blocks
      ext4: add online resizing support for meta_bg and 64-bit file systems
      ext4: check free block counters in ext4_mb_find_by_goal
      ext4: check free inode count before allocating an inode

Zheng Liu (2):
      ext4: make the zero-out chunk size tunable
      ext4: remove duplicated declarations in inode.c

 Documentation/ABI/testing/sysfs-fs-ext4 |  13 +++++
 Documentation/filesystems/ext4.txt      |  10 ++++
 fs/buffer.c                             |  13 +++--
 fs/ext4/ext4.h                          |  49 +++++++++++++---
 fs/ext4/extents.c                       | 258 +++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 fs/ext4/file.c                          |   6 +-
 fs/ext4/fsync.c                         |  92 +++--------------------------
 fs/ext4/ialloc.c                        |   9 +++
 fs/ext4/indirect.c                      |  18 +++++-
 fs/ext4/inode.c                         |  83 +++++++++++++-------------
 fs/ext4/ioctl.c                         |  25 +-------
 fs/ext4/mballoc.c                       | 129 ++++++++++++++++++++--------------------
 fs/ext4/mballoc.h                       |   5 --
 fs/ext4/move_extent.c                   | 520 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------
 fs/ext4/namei.c                         | 105 +++++++++++++++++++++++++++------
 fs/ext4/page-io.c                       | 176 +++++++++++++++++++++++++++++++++++++------------------
 fs/ext4/resize.c                        | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 fs/ext4/super.c                         |  92 +++++++++++++++++++----------
 fs/fs-writeback.c                       |   1 +
 fs/jbd2/commit.c                        |  40 +++++++++----
 fs/jbd2/journal.c                       |   5 ++
 fs/jbd2/recovery.c                      |   7 ++-
 fs/jbd2/transaction.c                   |  65 ++++++++++++++-------
 fs/nilfs2/file.c                        |   1 +
 include/linux/falloc.h                  |   1 +
 include/trace/events/ext4.h             | 242 +++++++++++++++++++++++++++++++++++++--------------------------------------
 26 files changed, 1500 insertions(+), 897 deletions(-)
