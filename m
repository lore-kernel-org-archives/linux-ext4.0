From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.16
Date: Sun, 13 Jul 2014 16:10:18 -0400
Message-ID: <20140713201018.GA31590@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 16874b2cb867d3eb63ed838f2847143e11556708:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-06-29 19:20:43 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to bf40c92635d63fcc574c52649f7cda13e0418ac1:

  ext4: fix potential null pointer dereference in ext4_free_inode (2014-07-12 16:11:42 -0400)

----------------------------------------------------------------
More bug fixes for ext4 -- most importantly, a fix for a bug
(introduced in 3.15) that can end up triggering a file system
corruption error after a journal replay.  (It shouldn't lead to any
actual data corruption, but it is scary and can force file systems to
be remounted read-only, etc.)

----------------------------------------------------------------
Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time==0

Namjae Jeon (1):
      ext4: fix potential null pointer dereference in ext4_free_inode

Theodore Ts'o (5):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages
      ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
      ext4: revert commit which was causing fs corruption after journal replays
      ext4: fix a potential deadlock in __ext4_es_shrink()

 fs/ext4/extents_status.c |  4 ++--
 fs/ext4/ialloc.c         | 16 ++++++++--------
 fs/ext4/mballoc.c        |  4 ++--
 fs/ext4/super.c          | 60 ++++++++++++++++++++++++++++--------------------------------
 fs/jbd2/transaction.c    |  5 ++++-
 5 files changed, 44 insertions(+), 45 deletions(-)
