From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes
Date: Mon, 15 Jul 2013 00:42:44 -0400
Message-ID: <nsxhafwv3gb.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 6ae06ff51eab5dcbbf959b05ce0f11003a305ba5:

  ext4: optimize starting extent in ext4_ext_rm_leaf() (2013-07-01 08:12:41 -0400)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1:

  ext4: don't allow ext4_free_blocks() to fail due to ENOMEM (2013-07-13 00:40:35 -0400)

----------------------------------------------------------------
Various regression and bug fixes for ext4.

----------------------------------------------------------------
Anatol Pomozov (1):
      ext4: rate limit printk in buffer_io_error()

Jan Kara (2):
      ext4: silence warning in ext4_writepages()
      ext4: fix warning in ext4_evict_inode()

Theodore Ts'o (4):
      ext4: fix ext4_get_group_number()
      ext4: don't show usrquota/grpquota twice in /proc/mounts
      ext4: fix spelling errors and a comment in extent_status tree
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

 fs/ext4/balloc.c         |  4 ++--
 fs/ext4/extents_status.c | 22 ++++++++++------------
 fs/ext4/inode.c          | 12 ++++++------
 fs/ext4/mballoc.c        | 11 ++++++++---
 fs/ext4/page-io.c        | 35 +++++++++++++++++++++--------------
 fs/ext4/super.c          | 14 ++++----------
 6 files changed, 51 insertions(+), 47 deletions(-)
