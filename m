From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.9
Date: Tue, 26 Feb 2013 15:39:44 -0500
Message-ID: <nsxr4k2kdwv.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 304e220f0879198b1f5309ad6f0be862b4009491:

  ext4: fix free clusters calculation in bigalloc filesystem (2013-02-22 15:27:52 -0500)

----------------------------------------------------------------
The one new feature added in this patch series is the ability to use
the "punch hole" functionality for inodes that are not using extent
maps.

In the bug fix category, we fixed some races in the AIO and fstrim
code, and some potential NULL pointer dereferences and memory leaks in
error handling code paths.

In the optimization category, we fixed a performance regression in the
jbd2 layer introduced by commit d9b0193 (introduced in v3.0) which
shows up in the AIM7 benchmark.  We also further optimized jbd2 by
minimize the amount of time that transaction handles are held active.

This patch series also features some additional enhancement of the
extent status tree, which is now used to cache extent information in a
more efficient/compact form than what we use on-disk.

----------------------------------------------------------------
Akria Fujita (1):
      ext4: fix smatch warning in move_extent.c's mext_replace_branches()

Chen Gang (1):
      ext4: fix memory leak when quota options are specified multiple times

Cong Ding (1):
      ext4: reduce one "if" comparison in ext4_dirhash()

Eric Sandeen (1):
      jbd2: don't wake kjournald unnecessarily

Eryu Guan (2):
      ext4: check bh in ext4_read_block_bitmap()
      ext4: no need to remove extent if len is 0 in ext4_es_remove_extent()

Guo Chao (4):
      ext4: release buffer when checksum failed
      ext4: remove unused variable in add_dirent_to_buf()
      ext4: remove useless assignment in dx_probe()
      ext4: remove unnecessary NULL pointer check

Jan Kara (13):
      ext4: Always use ext4_bio_write_page() for writeout
      ext4: use redirty_page_for_writepage() in ext4_bio_write_page()
      ext4: remove __ext4_journalled_writepage() from mpage_da_submit_io()
      ext4: move work from io_end to inode
      ext4: simplify list handling in ext4_do_flush_completed_IO()
      ext4: dirty page has always buffers attached
      ext4: simplify mpage_add_bh_to_extent()
      ext4: Make ext4_bio_writepage() handle unprepared buffers
      ext4: fix ext4_writepage() to achieve data=ordered guarantees
      ext4: fix possible use-after-free with AIO
      ext4: move several mount options to standard handling loop
      ext4: make mount option parsing loop more logical
      ext4: print error when argument of inode_readahead_blk is invalid

Julia Lawall (1):
      ext4: use WARN in ext4_alloc_blocks

Lukas Czerner (4):
      ext4: remove unused variable flags
      ext4: remove explicit WARN_ON when ext4_map_blocks() fails
      ext4: fix xattr block allocation/release with bigalloc
      ext4: fix free clusters calculation in bigalloc filesystem

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Theodore Ts'o (24):
      ext4: return ENOMEM if sb_getblk() fails
      ext4: trigger the lazy inode table initialization after resize
      ext4: release sysfs kobject when failing to enable quotas on mount
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
      ext4: check incompatible mount options while mounting ext2/3
      ext4: optimize mballoc for large allocations
      jbd2: track request delay statistics
      jbd2: revert "jbd2: add COW fields to struct jbd2_journal_handle"
      jbd2: add tracepoints which provide per-handle statistics
      ext4: move the jbd2 wrapper functions out of super.c
      ext4: pass context information to jbd2__journal_start()
      ext4: grab page before starting transaction handle in write_begin()
      ext4: start handle at the last possible moment in ext4_unlink()
      ext4: start handle at the last possible moment in ext4_rmdir()
      ext4: fix the number of credits needed for ext4_ext_migrate()
      ext4: fix the number of credits needed for ext4_unlink() and ext4_rmdir()
      ext4: fix the number of credits needed for acl ops with inline data
      ext4: start handle at the last possible moment when creating inodes
      ext4: use module parameters instead of debugfs for mballoc_debug
      jbd2: use module parameters instead of debugfs for jbd_debug
      ext4: use KERN_WARNING for warning messages
      ext4: add debugging context for warning in ext4_da_update_reserve_space()
      ext4: refactor code to read directory blocks into ext4_read_dirblock()
      ext4: use ERR_PTR() abstraction for ext4_append()

Wang Shilong (1):
      ext4: use unlikely to improve the efficiency of the kernel

Zheng Liu (11):
      ext4: add tracepoint in punching hole
      ext4: add punching hole support for non-extent-mapped files
      ext4: refine extent status tree
      ext4: add physical block and status member into extent status tree
      ext4: rename and improbe ext4_es_find_extent()
      ext4: let ext4_ext_map_blocks return EXT4_MAP_UNWRITTEN flag
      ext4: track all extent status in extent status tree
      ext4: lookup block mapping in extent status tree
      ext4: remove single extent cache
      ext4: adjust some functions for reclaiming extents from extent status tree
      ext4: reclaim extents from extent status tree

 fs/ext4/acl.c               |   7 +-
 fs/ext4/balloc.c            |  13 +-
 fs/ext4/dir.c               |   1 +
 fs/ext4/ext4.h              | 123 ++++++--
 fs/ext4/ext4_extents.h      |   6 -
 fs/ext4/ext4_jbd2.c         | 102 +++++++
 fs/ext4/ext4_jbd2.h         |  51 +++-
 fs/ext4/extents.c           | 312 ++++++++-------------
 fs/ext4/extents_status.c    | 631 ++++++++++++++++++++++++++++++-----------
 fs/ext4/extents_status.h    |  83 +++++-
 fs/ext4/file.c              |  16 +-
 fs/ext4/hash.c              |   6 +-
 fs/ext4/ialloc.c            |  29 +-
 fs/ext4/indirect.c          | 259 ++++++++++++++++-
 fs/ext4/inline.c            |  12 +-
 fs/ext4/inode.c             | 664 ++++++++++++++++++++------------------------
 fs/ext4/ioctl.c             |  13 +-
 fs/ext4/mballoc.c           |  69 ++---
 fs/ext4/mballoc.h           |   4 +-
 fs/ext4/migrate.c           |  15 +-
 fs/ext4/mmp.c               |   4 +-
 fs/ext4/move_extent.c       |  10 +-
 fs/ext4/namei.c             | 497 +++++++++++++++------------------
 fs/ext4/page-io.c           |  85 ++----
 fs/ext4/resize.c            |  36 +--
 fs/ext4/super.c             | 485 ++++++++++++++------------------
 fs/ext4/xattr.c             |  23 +-
 fs/ext4/xattr.h             |  68 -----
 fs/jbd2/commit.c            |   8 +
 fs/jbd2/journal.c           |  66 ++---
 fs/jbd2/transaction.c       |  29 +-
 include/linux/jbd2.h        |  44 ++-
 include/linux/quota.h       |   1 +
 include/trace/events/ext4.h | 214 +++++++++++---
 include/trace/events/jbd2.h | 106 ++++++-
 35 files changed, 2408 insertions(+), 1684 deletions(-)
