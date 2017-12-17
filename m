From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.15
Date: Sat, 16 Dec 2017 20:50:00 -0500
Message-ID: <20171217015000.kl4ji4gyjnzkkqo7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit ae64f9bd1d3621b5e60d7363bc20afb46aede215:

  Linux 4.15-rc2 (2017-12-03 11:01:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_stable

for you to fetch changes up to 9d5afec6b8bd46d6ed821aa1579634437f58ef1f:

  ext4: fix crash when a directory's i_size is too small (2017-12-11 15:00:57 -0500)

----------------------------------------------------------------
Fix a regression which caused us to fail to interpret symlinks in very
ancient ext3 file system images.  Also fix two xfstests failures, one
of which could cause a OOPS, plus an additional bug fix caught by fuzz
testing.

----------------------------------------------------------------
Andi Kleen (1):
      ext4: support fast symlinks from ext3 file systems

Chandan Rajendra (1):
      ext4: fix crash when a directory's i_size is too small

Eryu Guan (1):
      ext4: fix fdatasync(2) after fallocate(2) operation

Theodore Ts'o (1):
      ext4: add missing error check in __ext4_new_inode()

 fs/ext4/extents.c | 1 +
 fs/ext4/ialloc.c  | 2 ++
 fs/ext4/inode.c   | 9 +++++++++
 fs/ext4/namei.c   | 4 ++++
 4 files changed, 16 insertions(+)
