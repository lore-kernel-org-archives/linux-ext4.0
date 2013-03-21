From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.9-rc4
Date: Thu, 21 Mar 2013 16:58:13 -0400
Message-ID: <nsxehf8ii6y.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 9b2ff35753c0512bc8c6adae9e9c87cbeee86f82:

  ext4: enable quotas before orphan cleanup (2013-03-02 18:22:38 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linue

for you to fetch changes up to 2b405bfa84063bfa35621d2d6879f52693c614b0:

  ext4: fix data=journal fast mount/umount hang (2013-03-20 09:42:11 -0400)

----------------------------------------------------------------
Fix a number of regression and other bugs in ext4, most of which were
relatively obscure cornercases or races that were found using
regression tests.

----------------------------------------------------------------
Dmitry Monakhov (6):
      ext4: ext4_split_extent should take care of extent zeroout
      ext4: disable merging of uninitialized extents
      ext4: add warning to ext4_convert_unwritten_extents_endio
      ext4: invalidate extent status tree during extent migration
      ext4: add self-testing infrastructure to do a sanity check
      ext4: fix memory leakage in mext_check_coverage

Jan Kara (3):
      ext4: remove unnecessary wait for extent conversion in ext4_fallocate()
      ext4: fix WARN_ON from ext4_releasepage()
      jbd2: fix use after free in jbd2_journal_dirty_metadata()

Lukas Czerner (5):
      ext4: remove unused variable in ext4_free_blocks()
      ext4: do not use yield()
      ext4: update reserved space after the 'correction'
      ext4: reserve metadata block for every delayed write
      ext4: use s_extent_max_zeroout_kb value as number of kb

Theodore Ts'o (3):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix ext4_evict_inode() racing against workqueue processing code
      ext4: fix data=journal fast mount/umount hang

Zheng Liu (4):
      ext4: avoid a potential overflow in ext4_es_can_be_merged()
      ext4: fix wrong m_len value after unwritten extent conversion
      ext4: update extent status tree after an extent is zeroed out
      ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

 fs/ext4/ext4.h           |   8 +++---
 fs/ext4/extents.c        | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 fs/ext4/extents_status.c | 212 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/extents_status.h |   9 +++++++
 fs/ext4/ialloc.c         |   4 +--
 fs/ext4/inode.c          | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/ext4/mballoc.c        |  23 ++++++----------
 fs/ext4/move_extent.c    |  43 +++++++++++++++++++-----------
 fs/ext4/page-io.c        |  12 ++++++++-
 fs/ext4/resize.c         |   4 +--
 fs/ext4/super.c          |   4 +--
 fs/jbd2/transaction.c    |  15 +++++++----
 12 files changed, 540 insertions(+), 81 deletions(-)
