From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.14
Date: Mon, 4 Sep 2017 10:15:58 -0400
Message-ID: <20170904141558.4vuntrdkuabcb5y6@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 32aaf194201e98db4235b7b71ac62a22e2ac355f:

  ext4: add missing xattr hash update (2017-08-14 08:30:06 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to b5f515735bea4ae71c248aea3e049073f8852889:

  ext4: avoid Y2038 overflow in recently_deleted() (2017-08-31 11:09:45 -0400)

----------------------------------------------------------------
Scalability improvements when allocating inodes, and some
miscellaneous bug fixes and cleanups.

----------------------------------------------------------------
Andreas Dilger (1):
      ext4: avoid Y2038 overflow in recently_deleted()

Christoph Hellwig (1):
      ext4: remove timebomb in ext4_decode_extra_time()

Damien Guibouret (1):
      ext4: remove useless test and assignment in strtohash functions

Darrick J. Wong (1):
      ext4: in ext4_seek_{hole,data}, return -ENXIO for negative offsets

Jan Kara (1):
      ext4: do not unnecessarily allocate buffer in recently_deleted()

Markus Elfring (1):
      ext4: use sizeof(*ptr)

Randy Dodgen (1):
      ext4: fix fault handling when mounted with -o dax,ro

Tahsin Erdogan (1):
      ext4: backward compatibility support for Lustre ea_inode implementation

Wang Shilong (2):
      ext4: cleanup goto next group
      ext4: reduce lock contention in __ext4_new_inode

zhangyi (F) (2):
      ext4: fix incorrect quotaoff if the quota feature is enabled
      ext4: fix quota inconsistency during orphan cleanup for read-only mounts

 fs/ext4/dir.c        |   2 +-
 fs/ext4/ext4.h       |  11 +++----
 fs/ext4/file.c       |  19 ++++++++++--
 fs/ext4/hash.c       |   4 ---
 fs/ext4/ialloc.c     |  93 ++++++++++++++++++++++++++++++++++++--------------------
 fs/ext4/inode.c      |   8 -----
 fs/ext4/mmp.c        |   2 +-
 fs/ext4/super.c      |  38 ++++++++++++++++++-----
 fs/ext4/xattr.c      | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 include/linux/time.h |  15 +++++++++
 10 files changed, 222 insertions(+), 111 deletions(-)
