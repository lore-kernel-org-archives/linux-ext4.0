From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] more ext4 bug fixes
Date: Fri, 19 Jul 2013 20:29:24 -0400
Message-ID: <nsxy592axaz.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following changes since commit e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1:

  ext4: don't allow ext4_free_blocks() to fail due to ENOMEM (2013-07-13 00:40:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 63b999685cb372e24eb73f255cd73547026370fd:

  ext4: call ext4_es_lru_add() after handling cache miss (2013-07-16 10:28:47 -0400)

----------------------------------------------------------------
Fixes for 3.11-rc2, sent at 5pm, in the professoinal style.  :-)

----------------------------------------------------------------
Theodore Ts'o (5):
      ext4: fix error handling in ext4_ext_truncate()
      ext4: simplify calculation of blocks to free on error
      ext4: make the extent_status code more robust against ENOMEM failures
      ext4: yield during large unlinks
      ext4: call ext4_es_lru_add() after handling cache miss

 fs/ext4/extents.c        | 23 +++++++++++++++++++----
 fs/ext4/extents_status.c | 51 +++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/inode.c          |  7 ++-----
 3 files changed, 60 insertions(+), 21 deletions(-)
