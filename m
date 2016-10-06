From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.9
Date: Thu, 6 Oct 2016 15:16:21 -0400
Message-ID: <20161006191621.3gsqnmm5jja4kar2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit b8927721ae9d5ac0582d29d7b8c267d465ad5f00:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2016-08-29 12:37:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 18017479cabaeb5c659d789f04ecf7939f8ee28f:

  ext4: remove unused variable (2016-09-30 02:14:56 -0400)

----------------------------------------------------------------
Lots of bug fixes and cleanups.

----------------------------------------------------------------
Chao Yu (1):
      mbcache: fix to detect failure of register_shrinker

Daeho Jeong (1):
      ext4: reinforce check of i_dtime when clearing high fields of uid and gid

Dmitry Monakhov (1):
      ext4: improve ext4lazyinit scalability

Eric Biggers (9):
      ext4: fix memory leak when symlink decryption fails
      fscrypto: improved validation when loading inode encryption metadata
      fscrypto: remove unnecessary includes
      fscrypto: rename completion callbacks to reflect usage
      fscrypto: make filename crypto functions return 0 on success
      blockgroup_lock.h: remove debris from bgl_lock_ptr() conversion
      blockgroup_lock.h: simplify definition of NR_BG_LOCKS
      ext4: do not unnecessarily null-terminate encrypted symlink data
      fscrypto: use standard macros to compute length of fname ciphertext

Eric Engestrom (1):
      ext4: remove unused variable

Eric Whitney (3):
      ext4: enforce online defrag restriction for encrypted files
      ext4: create function to read journal inode
      ext4: use journal inode to determine journal overhead

Fabian Frederick (4):
      ext4: fix memory leak in ext4_insert_range()
      ext4: remove unneeded test in ext4_alloc_file_blocks()
      ext4: create EXT4_MAX_BLOCKS() macro
      ext4: remove unused definition for MAX_32_NUM

Geliang Tang (1):
      jbd2: move more common code into journal_init_common()

Jan Kara (14):
      ext4: fixup free space calculations when expanding inodes
      ext4: Check that external xattr value block is zero
      ext4: remove checks for e_value_block
      ext4: replace bogus assertion in ext4_xattr_shift_entries()
      ext4: factor out xattr moving
      ext4: remove (almost) unused variables from ext4_expand_extra_isize_ea()
      ext4: factor out loop for freeing inode xattr space
      ext4: enable quota enforcement based on mount options
      ext4: cleanup ext4_sync_parent()
      jbd2: fix lockdep annotation in add_transaction_credits()
      ext4: Allow parallel DIO reads
      ext4: allow unlocked direct IO when pages are cached
      ext4: remove plugging from ext4_file_write_iter()
      ext4: unmap metadata when zeroing blocks

Kaho Ng (1):
      ext4: remove old feature helpers

Richard Weinberger (1):
      ext4: require encryption feature for EXT4_IOC_SET_ENCRYPTION_POLICY

Ross Zwisler (1):
      ext4: allow DAX writeback for hole punch

gmail (1):
      ext4: release bh in make_indexed_dir

wangguang (1):
      ext4: bugfix for mmaped pages in mpage_release_unused_pages()

 fs/crypto/crypto.c              |  11 +--
 fs/crypto/fname.c               |  85 ++++++++---------
 fs/crypto/keyinfo.c             |  71 +++++++++-----
 fs/ext4/dir.c                   |   8 +-
 fs/ext4/ext4.h                  |  35 +++----
 fs/ext4/extents.c               |  27 ++----
 fs/ext4/file.c                  |  10 +-
 fs/ext4/fsync.c                 |   9 +-
 fs/ext4/ialloc.c                |   2 +-
 fs/ext4/inode.c                 |  71 +++++++-------
 fs/ext4/ioctl.c                 |  11 +--
 fs/ext4/move_extent.c           |   7 ++
 fs/ext4/namei.c                 |  22 ++---
 fs/ext4/page-io.c               |   4 +-
 fs/ext4/super.c                 | 126 +++++++++++++++++++------
 fs/ext4/symlink.c               |  10 +-
 fs/ext4/xattr.c                 | 340 +++++++++++++++++++++++++++++++++++-------------------------------
 fs/f2fs/dir.c                   |   6 +-
 fs/f2fs/namei.c                 |   6 +-
 fs/jbd2/journal.c               | 131 ++++++++++----------------
 fs/jbd2/transaction.c           |   6 +-
 fs/mbcache.c                    |   6 +-
 include/linux/blockgroup_lock.h |  28 +-----
 include/linux/fscrypto.h        |  24 -----
 24 files changed, 533 insertions(+), 523 deletions(-)
