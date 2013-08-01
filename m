From: Theodore Ts'o <tytso@MIT.EDU>
Subject: [GIT PULL] more ext4 bug fixes
Date: Thu, 01 Aug 2013 01:28:46 -0400
Message-ID: <nsx7gg6569d.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
From: Theodore Ts'o <tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 44fb851dfb2f8e3462617e19a7b3b9025db9d919:

  ext4: add WARN_ON to check the length of allocated blocks (2013-07-29 12:51:42 -0400)

----------------------------------------------------------------
ext4 bugfixes for v3.11-rc4

----------------------------------------------------------------
Eric Sandeen (1):
      ext4: destroy ext4_es_cachep on module unload

Theodore Ts'o (2):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: fix retry handling in ext4_ext_truncate()

Zheng Liu (1):
      ext4: add WARN_ON to check the length of allocated blocks

 fs/ext4/extents.c |  2 +-
 fs/ext4/ialloc.c  | 10 +++++-----
 fs/ext4/inode.c   | 39 ++++++++++++++++++---------------------
 fs/ext4/super.c   |  1 +
 4 files changed, 25 insertions(+), 27 deletions(-)
