From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfixes for 4.8
Date: Mon, 29 Aug 2016 14:57:46 -0400
Message-ID: <20160829185746.gbdh6pbfigcvbtyx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 7bc9491645118c9461bd21099c31755ff6783593:

  ext4: verify extent header depth (2016-07-15 00:22:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 2e81a4eeedcaa66e35f58b81e0755b87057ce392:

  ext4: avoid deadlock when expanding inode size (2016-08-11 12:38:55 -0400)

----------------------------------------------------------------
Fix bugs that could cause kernel deadlocks or file system corruption
while moving xattrs to expand the extended inode.  Also add some
sanity checks to the block group descriptors to make sure we don't end
up overwriting the superblock.

----------------------------------------------------------------
Jan Kara (4):
      ext4: fix xattr shifting when expanding inodes
      ext4: fix xattr shifting when expanding inodes part 2
      ext4: properly align shifted xattrs when expanding inodes
      ext4: avoid deadlock when expanding inode size

Theodore Ts'o (2):
      ext4: reserve xattr index for the Hurd
      ext4: validate that metadata blocks do not overlap superblock

 fs/ext4/inode.c |  2 --
 fs/ext4/super.c | 18 +++++++++++++++++-
 fs/ext4/xattr.c | 53 +++++++++++++++++++++++++++++++----------------------
 fs/ext4/xattr.h |  1 +
 4 files changed, 49 insertions(+), 25 deletions(-)
