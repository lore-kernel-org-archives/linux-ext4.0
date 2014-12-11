From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 3.19
Date: Thu, 11 Dec 2014 05:59:05 -0500
Message-ID: <20141211105905.GA15768@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 50db71abc529c48b21f4c3034d3cff27cfb25795:

  ext4: ext4_da_convert_inline_data_to_extent drop locked page after error (2014-12-05 21:37:15 -0500)

----------------------------------------------------------------
Lots of bugs fixes, including Zheng and Jan's extent status shrinker
fixes, which should improve CPU utilization and potential soft lockups
under heavy memory pressure, and Eric Whitney's bigalloc fixes.

----------------------------------------------------------------
Al Viro (1):
      ext4: kill ext4_kvfree()

Darrick J. Wong (1):
      ext4: create nojournal_checksum mount option

Dmitry Monakhov (6):
      ext4: move_extent improve bh vanishing success factor
      ext4: cleanup GFP flags inside resize path
      ext4: prevent fsreentrance deadlock for inline_data
      ext4: ext4_inline_data_fiemap should respect callers argument
      ext4: fix suboptimal seek_{data,hole} extents traversial
      ext4: ext4_da_convert_inline_data_to_extent drop locked page after error

Eric Sandeen (1):
      ext4: don't count external journal blocks as overhead

Eric Whitney (4):
      ext4: fix partial cluster initialization
      ext4: fix end of leaf partial cluster handling
      ext4: miscellaneous partial cluster cleanups
      ext4: fix end of region partial cluster handling

Jan Kara (7):
      ext4: fix block reservation for bigalloc filesystems
      ext4: move handling of list of shrinkable inodes into extent status code
      ext4: limit number of scanned extents in status tree shrinker
      ext4: cleanup flag definitions for extent status tree
      ext4: introduce aging to extent status tree
      ext4: remove never taken branch from ext4_ext_shift_path_extents()
      ext4: forbid journal_async_commit in data=ordered mode

Markus Elfring (1):
      ext4: Remove an unnecessary check for NULL before iput()

Namjae Jeon (1):
      ext4: remove unneeded code in ext4_unlink

Theodore Ts'o (1):
      jbd2: remove unnecessary NULL check before iput()

Wang Shilong (1):
      ext4: update comments regarding ext4_delete_inode()

Zheng Liu (2):
      ext4: cache extent hole in extent status tree for ext4_da_map_blocks()
      ext4: change LRU to round-robin in extent status tree shrinker

 fs/ext4/ext4.h              |  41 ++-----
 fs/ext4/extents.c           | 223 +++++++++++++++++++------------------
 fs/ext4/extents_status.c    | 321 ++++++++++++++++++++++++++++--------------------------
 fs/ext4/extents_status.h    |  82 ++++++++------
 fs/ext4/file.c              | 220 ++++++++++++++++++-------------------
 fs/ext4/inline.c            |  35 ++++--
 fs/ext4/inode.c             |  37 ++-----
 fs/ext4/ioctl.c             |   2 -
 fs/ext4/mballoc.c           |  15 ++-
 fs/ext4/migrate.c           |   2 +-
 fs/ext4/move_extent.c       |   8 +-
 fs/ext4/namei.c             |   1 -
 fs/ext4/resize.c            |   6 +-
 fs/ext4/super.c             |  51 +++++----
 fs/jbd2/journal.c           |   3 +-
 include/trace/events/ext4.h |  17 +--
 16 files changed, 533 insertions(+), 531 deletions(-)
