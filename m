From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.1
Date: Sat, 18 Apr 2015 20:49:46 -0400
Message-ID: <20150419004946.GA26678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 1efff914afac8a965ad63817ecf8861a927c2ace:

  fs: add dirtytime_expire_seconds sysctl (2015-03-17 12:23:32 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 6ddb2447846a8ece111e316a2863c2355023682d:

  ext4 crypto: enable encryption feature flag (2015-04-16 01:56:00 -0400)

----------------------------------------------------------------
A few bug fixes and add support for file-system level encryption in ext4.

----------------------------------------------------------------
Christoph Hellwig (1):
      ext4: remove block_device_ejected

Eric Whitney (2):
      ext4: fix loss of delalloc extent info in ext4_zero_range()
      ext4: don't release reserved space for previously allocated cluster

Konstantin Khlebnikov (1):
      ext4: fix bh leak on error paths in ext4_rename() and ext4_cross_rename()

Lukas Czerner (2):
      ext4: allocate entire range in zero range
      ext4: make fsync to sync parent dir in no-journal for real this time

Maurizio Lombardi (1):
      ext4: remove unnecessary lock/unlock of i_block_reservation_lock

Michael Halcrow (13):
      ext4 crypto: export ext4_empty_dir()
      ext4 crypto: add encryption xattr support
      ext4 crypto: add encryption policy and password salt support
      ext4 crypto: add ext4 encryption facilities
      ext4 crypto: add encryption key management facilities
      ext4 crypto: inherit encryption policies on inode and directory create
      ext4 crypto: implement the ext4 encryption write path
      ext4 crypto: implement the ext4 decryption read path
      ext4 crypto: filename encryption facilities
      ext4 crypto: insert encrypted filenames into a leaf directory block
      ext4 crypto: partial update to namei.c for fname crypto
      ext4 crypto: filename encryption modifications
      ext4 crypto: enable filename encryption

Rasmus Villemoes (1):
      ext4: fix transposition typo in format string

Sheng Yong (1):
      ext4: remove unused header files

Theodore Ts'o (7):
      ext4 crypto: add ext4_mpage_readpages()
      ext4 crypto: reserve codepoints used by the ext4 encryption feature
      ext4 crypto: add ext4 encryption Kconfig
      ext4 crypto: enforce context consistency
      ext4 crypto: teach ext4_htree_store_dirent() to store decrypted filenames
      ext4 crypto: add symlink encryption
      ext4 crypto: enable encryption feature flag

Wei Yuan (1):
      ext4: remove useless condition in if statement.

Xiaoguang Wang (1):
      ext4: fix comments in ext4_can_extents_be_merged()

 fs/ext4/Kconfig          |  17 +++
 fs/ext4/Makefile         |   4 +-
 fs/ext4/acl.c            |   5 -
 fs/ext4/balloc.c         |   3 -
 fs/ext4/bitmap.c         |   1 -
 fs/ext4/block_validity.c |   1 -
 fs/ext4/crypto.c         | 558 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_fname.c   | 709 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_key.c     | 165 +++++++++++++++++++++++
 fs/ext4/crypto_policy.c  | 194 +++++++++++++++++++++++++++
 fs/ext4/dir.c            |  81 ++++++++----
 fs/ext4/ext4.h           | 169 ++++++++++++++++++++++--
 fs/ext4/ext4_crypto.h    | 147 +++++++++++++++++++++
 fs/ext4/extents.c        |  81 ++++++------
 fs/ext4/extents_status.c |   2 -
 fs/ext4/file.c           |  19 ++-
 fs/ext4/fsync.c          |   1 -
 fs/ext4/hash.c           |   1 -
 fs/ext4/ialloc.c         |  28 +++-
 fs/ext4/inline.c         |  16 ++-
 fs/ext4/inode.c          | 130 +++++++++++++++++-
 fs/ext4/ioctl.c          |  86 +++++++++++-
 fs/ext4/namei.c          | 637 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 fs/ext4/page-io.c        |  47 ++++++-
 fs/ext4/readpage.c       | 328 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c          |  56 +++++---
 fs/ext4/symlink.c        |  97 +++++++++++++-
 fs/ext4/xattr.c          |   4 +-
 fs/ext4/xattr.h          |   3 +
 29 files changed, 3344 insertions(+), 246 deletions(-)
 create mode 100644 fs/ext4/crypto.c
 create mode 100644 fs/ext4/crypto_fname.c
 create mode 100644 fs/ext4/crypto_key.c
 create mode 100644 fs/ext4/crypto_policy.c
 create mode 100644 fs/ext4/ext4_crypto.h
 create mode 100644 fs/ext4/readpage.c
