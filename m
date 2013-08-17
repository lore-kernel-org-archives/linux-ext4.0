From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] jbd2 bug fixes for v3.11-rc6
Date: Sat, 17 Aug 2013 09:05:42 -0400
Message-ID: <20130817130542.GA32430@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit cde2d7a796f7e895e25b43471ed658079345636d:

  ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT (2013-08-12 09:29:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to a361293f5fedea0016a10599f409631a15d47ee7:

  jbd2: Fix oops in jbd2_journal_file_inode() (2013-08-16 21:19:41 -0400)

----------------------------------------------------------------
Two jbd2 bug fixes, one of which is a regression fix.

----------------------------------------------------------------
Jan Kara (2):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
      jbd2: Fix oops in jbd2_journal_file_inode()

 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.c |  8 ++++----
 fs/ext4/file.c      | 21 ++++-----------------
 fs/ext4/inode.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 21 deletions(-)
