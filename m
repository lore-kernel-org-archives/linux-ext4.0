From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.2-rc1
Date: Wed, 24 Jun 2015 23:46:26 -0400
Message-ID: <20150625034626.GA21682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit e26081808edadfd257c6c9d81014e3b25e9a6118:

  Linux 4.1-rc4 (2015-05-18 10:13:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to a2fd66d069d86d793e9d39d4079b96f46d13f237:

  ext4: set lazytime on remount if MS_LAZYTIME is set by mount (2015-06-23 11:03:54 -0400)

----------------------------------------------------------------
A very large number of cleanups and bug fixes --- in particular for
the ext4 encryption patches, which is a new feature added in the last
merge window.  Also fix a number of long-standing xfstest failures.
(Quota writes failing due to ENOSPC, a race between truncate and
writepage in data=journalled mode that was causing generic/068 to
fail, and other corner cases.)

Also add support for FALLOC_FL_INSERT_RANGE, and improve jbd2
performance eliminating locking when a buffer is modified more than
once during a transaction (which is very common for allocation
bitmaps, for example), in which case the state of the journalled
buffer head doesn't need to change.

----------------------------------------------------------------
Andreas Dilger (1):
      ext4: improve warning directory handling messages

Chao Yu (1):
      ext4 crypto: release crypto resource on module exit

Darrick J. Wong (1):
      ext4: don't retry file block mapping on bigalloc fs with non-extent file

David Moore (1):
      ext4: BUG_ON assertion repeated for inode1, not done for inode2

Dmitry Monakhov (1):
      jbd2: use GFP_NOFS in jbd2_cleanup_journal_tail()

Eric Whitney (2):
      ext4: minor cleanup of ext4_da_reserve_space()
      ext4: make online defrag error reporting consistent

Fabian Frederick (3):
      ext4 crypto: fix sparse warnings in fs/ext4/ioctl.c
      ext4: use swap() in memswap()
      ext4: use swap() in mext_page_double_lock()

Jan Kara (5):
      jbd2: simplify code flow in do_get_write_access()
      jbd2: simplify error path on allocation failure in do_get_write_access()
      jbd2: more simplifications in do_get_write_access()
      jbd2: speedup jbd2_journal_get_[write|undo]_access()
      jbd2: speedup jbd2_journal_dirty_metadata()

Josef Bacik (1):
      ext4: only call ext4_truncate when size <= isize

Joseph Qi (1):
      jbd2: fix ocfs2 corrupt when updating journal superblock fails

Lukas Czerner (5):
      ext4: verify block bitmap even after fresh initialization
      ext4: try to initialize all groups we can in case of failure on ppc64
      ext4: return error code from ext4_mb_good_group()
      ext4: recalculate journal credits as inode depth changes
      ext4: wait for existing dio workers in ext4_alloc_file_blocks()

Michal Hocko (2):
      jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL
      jbd2: get rid of open coded allocation retry loop

Namjae Jeon (1):
      ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate

Rasmus Villemoes (1):
      ext4: mballoc: avoid 20-argument function call

Theodore Ts'o (26):
      ext4 crypto: optimize filename encryption
      ext4 crypto: don't allocate a page when encrypting/decrypting file names
      ext4 crypto: separate kernel and userspace structure for the key
      ext4 crypto: reorganize how we store keys in the inode
      ext4: clean up superblock encryption mode fields
      ext4 crypto: use slab caches
      ext4 crypto: get rid of ci_mode from struct ext4_crypt_info
      ext4 crypto: shrink size of the ext4_crypto_ctx structure
      ext4 crypto: require CONFIG_CRYPTO_CTR if ext4 encryption is enabled
      ext4 crypto: use per-inode tfm structure
      ext4 crypto: fix memory leaks in ext4_encrypted_zeroout
      ext4 crypto: set up encryption info for new inodes in ext4_inherit_context()
      ext4 crypto: make sure the encryption info is initialized on opendir(2)
      ext4 crypto: encrypt tmpfile located in encryption protected directory
      ext4 crypto: enforce crypto policy restrictions on cross-renames
      ext4 crypto: policies may only be set on directories
      ext4 crypto: clean up error handling in ext4_fname_setup_filename
      ext4 crypto: allocate the right amount of memory for the on-disk symlink
      ext4 crypto: handle unexpected lack of encryption keys
      ext4 crypto: allocate bounce pages using GFP_NOWAIT
      ext4 crypto: fix ext4_get_crypto_ctx()'s calling convention in ext4_decrypt_one
      ext4 crypto: fail the mount if blocksize != pagesize
      ext4: fix race between truncate and __ext4_journalled_writepage()
      ext4: call sync_blockdev() before invalidate_bdev() in put_super()
      ext4: prevent ext4_quota_write() from failing due to ENOSPC
      ext4: set lazytime on remount if MS_LAZYTIME is set by mount

 fs/ext4/Kconfig             |   1 +
 fs/ext4/balloc.c            |   4 +-
 fs/ext4/crypto.c            | 211 +++++++++------------------
 fs/ext4/crypto_fname.c      | 490 ++++++++++++++++-----------------------------------------------
 fs/ext4/crypto_key.c        | 152 ++++++++++++++++----
 fs/ext4/crypto_policy.c     |  87 +++++++-----
 fs/ext4/dir.c               |  29 ++--
 fs/ext4/ext4.h              | 159 ++++++++++++++-------
 fs/ext4/ext4_crypto.h       |  51 +++----
 fs/ext4/extents.c           | 339 +++++++++++++++++++++++++++++++++++++-------
 fs/ext4/file.c              |  19 +--
 fs/ext4/ialloc.c            |  45 +++---
 fs/ext4/indirect.c          |   4 +-
 fs/ext4/inline.c            |  31 ++--
 fs/ext4/inode.c             |  93 ++++++------
 fs/ext4/ioctl.c             |  11 +-
 fs/ext4/mballoc.c           |  43 ++++--
 fs/ext4/move_extent.c       |  19 +--
 fs/ext4/namei.c             | 542 ++++++++++++++++++++++++++++++----------------------------------------
 fs/ext4/page-io.c           |   2 +-
 fs/ext4/readpage.c          |  10 +-
 fs/ext4/super.c             |  60 ++++++--
 fs/ext4/symlink.c           |  16 +--
 fs/jbd2/checkpoint.c        |   7 +-
 fs/jbd2/journal.c           |  57 +++++---
 fs/jbd2/revoke.c            |  15 +-
 fs/jbd2/transaction.c       | 303 ++++++++++++++++++++++++---------------
 include/linux/jbd2.h        |   4 +-
 include/trace/events/ext4.h |  35 ++++-
 29 files changed, 1486 insertions(+), 1353 deletions(-)
