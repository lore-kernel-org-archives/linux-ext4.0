From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.1-rc2
Date: Sun, 3 May 2015 21:21:32 -0400
Message-ID: <20150504012132.GA31465@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 6ddb2447846a8ece111e316a2863c2355023682d:

  ext4 crypto: enable encryption feature flag (2015-04-16 01:56:00 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/for_linus_stable

for you to fetch changes up to 2c869b262a10ca99cb866d04087d75311587a30c:

  ext4: fix growing of tiny filesystems (2015-05-02 23:58:32 -0400)

----------------------------------------------------------------
Some miscellaneous bug fixes and some final on-disk and ABI changes
for ext4 encryption which provide better security and performance.

----------------------------------------------------------------
Chanho Park (1):
      ext4 crypto: remove duplicated encryption mode definitions

Davide Italiano (1):
      ext4: move check under lock scope to close a race.

Herbert Xu (1):
      ext4 crypto: do not select from EXT4_FS_ENCRYPTION

Jan Kara (1):
      ext4: fix growing of tiny filesystems

Lukas Czerner (1):
      ext4: fix data corruption caused by unwritten and delayed extents

Theodore Ts'o (2):
      ext4 crypto: simplify and speed up filename encryption
      ext4 crypto: add padding to filenames before encrypting

 fs/ext4/Kconfig          |   9 ++-
 fs/ext4/crypto_fname.c   | 280 +++++++++++++++++++++++++++++++++++++++------------------------------------
 fs/ext4/crypto_key.c     |   1 +
 fs/ext4/crypto_policy.c  |  14 ++--
 fs/ext4/dir.c            |   2 +-
 fs/ext4/ext4.h           |  16 ++---
 fs/ext4/ext4_crypto.h    |  11 ++-
 fs/ext4/extents.c        |  15 ++--
 fs/ext4/extents_status.c |   8 +++
 fs/ext4/inode.c          |   2 +
 fs/ext4/namei.c          |  72 ++------------------
 fs/ext4/resize.c         |   7 +-
 fs/ext4/symlink.c        |   2 +-
 13 files changed, 210 insertions(+), 229 deletions(-)
