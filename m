From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 4.17-rc3
Date: Sat, 28 Apr 2018 22:57:48 -0400
Message-ID: <20180429025748.GA9046@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit e40ff213898502d299351cc2fe1e350cd186f0d3:

  ext4: force revalidation of directory pointer after seekdir(2) (2018-04-01 23:21:03 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/for_linus_stable

for you to fetch changes up to 7ef79ad52136712172eb0525bf0b462516bf2f93:

  ext4: add MODULE_SOFTDEP to ensure crc32c is included in the initramfs (2018-04-26 00:44:46 -0400)

----------------------------------------------------------------
Fix misc. bugs and a regression for ext4.

----------------------------------------------------------------
Eric Biggers (1):
      ext4: prevent right-shifting extents beyond EXT_MAX_BLOCKS

Lukas Czerner (1):
      ext4: fix bitmap position validation

Theodore Ts'o (2):
      ext4: set h_journal if there is a failure starting a reserved handle
      ext4: add MODULE_SOFTDEP to ensure crc32c is included in the initramfs

 fs/ext4/balloc.c      |  9 +++++----
 fs/ext4/extents.c     | 16 +++++++++++-----
 fs/ext4/super.c       |  1 +
 fs/jbd2/transaction.c |  1 +
 4 files changed, 18 insertions(+), 9 deletions(-)
