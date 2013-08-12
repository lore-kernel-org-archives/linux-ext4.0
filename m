From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] more ext4 bug fixes (for v3.11-rc6)
Date: Mon, 12 Aug 2013 09:45:14 -0400
Message-ID: <20130812134514.GA13322@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to cde2d7a796f7e895e25b43471ed658079345636d:

  ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT (2013-08-12 09:29:30 -0400)

----------------------------------------------------------------
A number of miscellaneous ext4 bugs fixes for v3.11, including a fix
so that if ext4 is built as a module, to allow it to be unloaded.

----------------------------------------------------------------
Eric Sandeen (1):
      ext4: destroy ext4_es_cachep on module unload

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Theodore Ts'o (4):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: fix retry handling in ext4_ext_truncate()
      ext4: allow the mount options nodelalloc and data=journal
      ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT

Zheng Liu (1):
      ext4: add WARN_ON to check the length of allocated blocks

 fs/ext4/extents.c |  2 +-
 fs/ext4/ialloc.c  | 10 +++++-----
 fs/ext4/inode.c   | 39 ++++++++++++++++++---------------------
 fs/ext4/ioctl.c   |  6 ++++--
 fs/ext4/super.c   | 20 ++++++++++++++++++--
 5 files changed, 46 insertions(+), 31 deletions(-)
