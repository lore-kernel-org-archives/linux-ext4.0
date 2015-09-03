From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.3
Date: Wed, 2 Sep 2015 20:35:53 -0400
Message-ID: <20150903003553.GA19399@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3435590:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to bdfe0cbd746aa9b2509c2f6d6be17193cf7facd7:

  Revert "ext4: remove block_device_ejected" (2015-08-16 10:03:57 -0400)

----------------------------------------------------------------
Pretty much all bug fixes and clean ups for 4.3, after a lot of
features and other churn going into 4.2.

----------------------------------------------------------------
Carlos Maiolino (1):
      ext4: reject journal options for ext2 mounts

Daeho Jeong (1):
      ext4, jbd2: add REQ_FUA flag when recording an error in the superblock

Dan Carpenter (2):
      ext4: simplify some code in read_mmp_block()
      ext4: silence a format string false positive

Eric Sandeen (1):
      ext4: don't manipulate recovery flag when freezing no-journal fs

Eryu Guan (1):
      ext4: update c/mtime on truncate up

Jan Kara (2):
      jbd2: speedup jbd2_journal_dirty_metadata()
      jbd2: avoid infinite loop when destroying aborted journal

Laurent Navet (2):
      ext4 crypto: exit cleanly if ext4_derive_key_aes() fails
      ext4 crypto: fix spelling typo in comment

Lukas Czerner (1):
      jbd2: limit number of reserved credits

Tejun Heo (2):
      ext4: replace ext4_io_submit->io_op with ->io_wbc
      ext4: implement cgroup writeback support

Theodore Ts'o (4):
      ext4 crypto: use a jbd2 transaction when adding a crypto policy
      ext4 crypto: check for too-short encrypted file names
      ext4: ratelimit the file system mounted message
      Revert "ext4: remove block_device_ejected"

zilong.liu (1):
      ext4 crypto: remove duplicate header file

 fs/ext4/crypto_fname.c  |  5 +++-
 fs/ext4/crypto_key.c    |  4 ++-
 fs/ext4/crypto_policy.c | 17 ++++++++++--
 fs/ext4/ext4.h          |  2 +-
 fs/ext4/inode.c         |  8 ++++++
 fs/ext4/mmp.c           | 48 ++++++++++++++++++---------------
 fs/ext4/page-io.c       |  8 ++++--
 fs/ext4/super.c         | 50 +++++++++++++++++++++++++---------
 fs/jbd2/checkpoint.c    | 39 ++++++++++++++++++++++-----
 fs/jbd2/commit.c        |  2 +-
 fs/jbd2/journal.c       | 13 +++++++--
 fs/jbd2/transaction.c   | 74 ++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/jbd2.h    |  3 ++-
 13 files changed, 207 insertions(+), 66 deletions(-)
