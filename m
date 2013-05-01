From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.10
Date: Wed, 01 May 2013 01:10:52 -0400
Message-ID: <nsxppxbwahv.fsf@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45662 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3EAFKz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 May 2013 01:10:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 8cde7ad17e4f4ff8d12ff60dd09c0a291cb0b61c:

  ext4: fix big-endian bugs which could cause fs corruptions (2013-04-03 12:37:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 0d606e2c9fccdd4e67febf1e2da500e1bfe9e045:

  ext4: fix type-widening bug in inode table readahead code (2013-04-23 08:59:35 -0400)

----------------------------------------------------------------
Mostly performance and bug fixes, plus some cleanups.  The one new
feature this merge window is a new ioctl EXT4_IOC_SWAP_BOOT which
allows installation of a hidden inode designed for boot loaders.

----------------------------------------------------------------
Andrey Sidorov (1):
      ext4: speed-up releasing blocks on commit

Darrick J. Wong (1):
      ext4: mext_insert_extents should update extent block checksum

Dmitri Monakho (1):
      ext4: fix usless declarations

Dmitry Monakhov (7):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
      ext4: fix journal callback list traversal
      ext4: unregister es_shrinker if mount failed
      ext4: fix incorrect lock ordering for ext4_ind_migrate
      ext4: fix big-endian bug in extent migration code
      ext4: fix big-endian bug in metadata checksum calculations
      ext4: defragmentation code cleanup

Dr. Tilmann Bubeck (1):
      ext4: implementation of a new ioctl called EXT4_IOC_SWAP_BOOT

Eric Whitney (1):
      ext4: fix free space estimate in ext4_nonda_switch()

Jan Kara (7):
      ext4: fix deadlock with quota feature
      ext4: improve credit estimate for EXT4_SINGLEDATA_TRANS_BLOCKS
      ext4: make ext4_bio_write_page() use BH_Async_Write flags
      ext4: use io_end for multiple bios
      ext4: clear buffer_uninit flag when submitting IO
      jbd2: reduce journal_head size
      ext4: move quota initialization out of inode allocation transaction

Lukas Czerner (9):
      ext4: make ext4_block_in_group() much more efficient
      ext4: introduce ext4_get_group_number()
      ext4: Transfer initialized block to right neighbor if possible
      ext4: try to prepend extent to the existing one
      ext4: print more info in ext4_print_free_blocks()
      ext4: introduce reserved space
      ext4: move ext4_ind_migrate() into migrate.c
      ext4: do not convert to indirect with bigalloc enabled
      ext4: Use kstrtoul() instead of parse_strtoul()

Tao Ma (2):
      ext4: fix readdir error in the case of inline_data+dir_index
      ext4: fix readdir error in case inline_data+^dir_index.

Theodore Ts'o (18):
      ext4: collapse handling of data=ordered and data=writeback codepaths
      ext4: fold ext4_alloc_blocks() in ext4_alloc_branch()
      ext4: refactor punch hole code
      ext4: refactor truncate code
      ext4: add mutex_is_locked() assertion to ext4_truncate()
      ext4: add might_sleep() annotations
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: support simple conversion of extent-mapped inodes to use i_blocks
      ext4: fix miscellaneous big endian warnings
      ext4: reserve xattr index for Rich ACL support
      ext4: mark all metadata I/O with REQ_META
      buffer: add BH_Prio and BH_Meta flags
      ext4: mark metadata blocks using bh flags
      jbd2: trace when lock_buffer in do_get_write_access takes a long time
      ext4: fix online resizing for ext3-compat file systems
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
      ext4: add check for inodes_count overflow in new resize ioctl
      ext4: fix type-widening bug in inode table readahead code

Zheng Liu (2):
      ext4: fold ext4_generic_write_end() into ext4_write_end()
      jbd2: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

 Documentation/filesystems/ext4.txt |  21 ++++
 fs/buffer.c                        |   5 +
 fs/ext4/Kconfig                    |   3 +-
 fs/ext4/balloc.c                   |  53 ++++++++---
 fs/ext4/dir.c                      |  20 ++--
 fs/ext4/ext4.h                     | 101 ++++++++++++++------
 fs/ext4/ext4_extents.h             |   5 +
 fs/ext4/ext4_jbd2.c                |   8 ++
 fs/ext4/ext4_jbd2.h                |  12 ++-
 fs/ext4/extents.c                  | 522 ++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------
 fs/ext4/fsync.c                    |   3 +-
 fs/ext4/ialloc.c                   |  88 +++++++++--------
 fs/ext4/indirect.c                 | 473 ++++++++++--------------------------------------------------------------------------------
 fs/ext4/inline.c                   | 178 ++++++++++++++++++++++++++++++----
 fs/ext4/inode.c                    | 580 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 fs/ext4/ioctl.c                    | 218 +++++++++++++++++++++++++++++++++++++++---
 fs/ext4/mballoc.c                  | 253 ++++++++++++++++++++++++++++++++++--------------
 fs/ext4/migrate.c                  |  62 +++++++++++-
 fs/ext4/mmp.c                      |   6 +-
 fs/ext4/move_extent.c              |  73 +++++++-------
 fs/ext4/namei.c                    |  48 ++++------
 fs/ext4/page-io.c                  | 280 +++++++++++++++++++++++++++++-------------------------
 fs/ext4/resize.c                   |  16 +++-
 fs/ext4/super.c                    | 131 ++++++++++++++++++++-----
 fs/ext4/xattr.c                    |  13 +--
 fs/ext4/xattr.h                    |   1 +
 fs/jbd2/commit.c                   |  50 +++++-----
 fs/jbd2/journal.c                  |  31 ++++++
 fs/jbd2/transaction.c              |   9 +-
 include/linux/buffer_head.h        |   4 +
 include/linux/jbd2.h               |   4 +-
 include/linux/journal-head.h       |  11 +--
 include/trace/events/ext4.h        |  16 +---
 include/trace/events/jbd2.h        |  21 ++++
 34 files changed, 1900 insertions(+), 1419 deletions(-)
