From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.11
Date: Sat, 25 Mar 2017 22:23:05 -0400
Message-ID: <20170326022305.exox3zz5b2o7ht4k@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit cab7076a185e1e27f6879325e4da762424c3f1c9:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2017-02-20 18:24:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to d67d64f423147cf4fe8212658255e1160a4ef02c:

  ext4: fix two spelling nits (2017-03-25 17:33:31 -0400)

----------------------------------------------------------------
Fix a memory leak on an error path, and two races when modifying
inodes relating to the inline_data and metadata checksum features.

----------------------------------------------------------------
Eric Biggers (2):
      ext4: mark inode dirty after converting inline directory
      jbd2: don't leak memory if setting up journal fails

Theodore Ts'o (2):
      ext4: lock the xattr block before checksuming it
      ext4: fix two spelling nits

 fs/ext4/inline.c      |  5 ++---
 fs/ext4/inode.c       |  2 +-
 fs/ext4/move_extent.c |  2 +-
 fs/ext4/xattr.c       | 65 +++++++++++++++++++++++++++++++----------------------------------
 fs/jbd2/journal.c     | 22 +++++++++++-----------
 fs/jbd2/revoke.c      |  1 +
 6 files changed, 47 insertions(+), 50 deletions(-)
