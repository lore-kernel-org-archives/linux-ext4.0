From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.9
Date: Sat, 19 Nov 2016 21:29:38 -0500
Message-ID: <20161120022938.xkpiypxk3hn6yjez@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit bc33b0ca11e3df467777a4fa7639ba488c9d4911:

  Linux 4.9-rc4 (2016-11-05 16:23:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_stable

for you to fetch changes up to 8cdf3372fe8368f56315e66bea9f35053c418093:

  ext4: sanity check the block and cluster size at mount time (2016-11-19 20:58:15 -0500)

----------------------------------------------------------------
A security fix (so a maliciously corrupted file system image won't
panic the kernel) and some fixes for CONFIG_VMAP_STACK.

----------------------------------------------------------------
Eric Biggers (2):
      fscrypto: don't use on-stack buffer for filename encryption
      fscrypto: don't use on-stack buffer for key derivation

Theodore Ts'o (1):
      ext4: sanity check the block and cluster size at mount time

 fs/crypto/fname.c   | 53 +++++++++++++++++++++--------------------------------
 fs/crypto/keyinfo.c | 16 +++++++++++++---
 fs/ext4/ext4.h      |  1 +
 fs/ext4/super.c     | 17 ++++++++++++++++-
 4 files changed, 51 insertions(+), 36 deletions(-)
