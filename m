From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] Ext4 changes for 3.14
Date: Tue, 28 Jan 2014 11:27:54 -0500
Message-ID: <20140128162754.GA17770@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit d0abafac8c9162f39c4f6b2f8141b772a09b3770:

  ext4: fix bigalloc regression (2014-01-06 14:00:23 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to d7092ae2973f20a39fee786c47e5edf18ced088f:

  ext4: delete "set but not used" variables (2014-01-11 13:26:56 -0500)

----------------------------------------------------------------
Bug fixes and cleanups for ext4.  We also enable the punch hole
functionality for bigalloc file systems.

----------------------------------------------------------------
David Howells (1):
      ext4: use %pd printk specificer

Jan Kara (2):
      ext4: retry allocation when inline->extent conversion failed
      ext4: standardize error handling in ext4_da_write_inline_data_begin()

Theodore Ts'o (2):
      ext4: avoid clearing beyond i_blocks when truncating an inline data file
      ext4: don't pass freed handle to ext4_walk_page_buffers

Yongqiang Yang (2):
      ext4: fix a typo in extents.c
      ext4: ext4_inode_is_fast_symlink should use EXT4_CLUSTER_SIZE

Zheng Liu (1):
      ext4: enable punch hole for bigalloc

jon ernst (1):
      ext4: delete "set but not used" variables

 fs/ext4/extents.c |  2 +-
 fs/ext4/inline.c  | 26 +++++++++++++++-----------
 fs/ext4/inode.c   | 11 +++--------
 fs/ext4/ioctl.c   |  6 +-----
 fs/ext4/namei.c   |  5 ++---
 5 files changed, 22 insertions(+), 28 deletions(-)
