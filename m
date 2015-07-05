From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.2-rc2
Date: Sun, 5 Jul 2015 17:53:12 -0400
Message-ID: <20150705215312.GE8628@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit a2fd66d069d86d793e9d39d4079b96f46d13f237:

  ext4: set lazytime on remount if MS_LAZYTIME is set by mount (2015-06-23 11:03:54 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 7444a072c387a93ebee7066e8aee776954ab0e41:

  ext4: replace open coded nofail allocation in ext4_free_blocks() (2015-07-05 12:33:44 -0400)

----------------------------------------------------------------
Bug fixes (all for stable kernels) for ext4:
  * address corner cases for indirect blocks->extent migration
  * fix reserved block accounting invalidate_page when
	page_size != block_size (i.e., ppc or 1k block size file systems)
  * fix deadlocks when a memcg is under heavy memory pressure
  * fix fencepost error in lazytime optimization

----------------------------------------------------------------
Eryu Guan (2):
      ext4: be more strict when migrating to non-extent based file
      ext4: correctly migrate a file with a hole at the beginning

Lukas Czerner (1):
      ext4: fix reservation release on invalidatepage for delalloc fs

Michal Hocko (1):
      ext4: replace open coded nofail allocation in ext4_free_blocks()

Nikolay Borisov (2):
      bufferhead: Add _gfp version for sb_getblk()
      ext4: avoid deadlocks in the writeback path by using sb_getblk_gfp

Theodore Ts'o (1):
      ext4: fix fencepost error in lazytime optimization

 fs/ext4/extents.c           |  6 +++---
 fs/ext4/inode.c             | 22 ++++++++++++++++++----
 fs/ext4/mballoc.c           | 16 +++++-----------
 fs/ext4/migrate.c           | 17 ++++++++++++++---
 include/linux/buffer_head.h |  7 +++++++
 5 files changed, 47 insertions(+), 21 deletions(-)
