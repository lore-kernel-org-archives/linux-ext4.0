From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.1-rc4
Date: Sat, 16 May 2015 18:15:34 -0400
Message-ID: <20150516221534.GA22778@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 5ebe6afaf0057ac3eaeb98defd5456894b446d22:

  Linux 4.1-rc2 (2015-05-03 19:22:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/for_linus_stable

for you to fetch changes up to b9576fc3624eb9fc88bec0d0ae883fd78be86239:

  ext4: fix an ext3 collapse range regression in xfstests (2015-05-15 00:24:10 -0400)

----------------------------------------------------------------
Fix a number of ext4 bugs; the most serious of which is a bug in the
lazytime mount optimization code where we could end up updating the
timestamps to the wrong inode.

----------------------------------------------------------------
Darrick J. Wong (1):
      jbd2: fix r_count overflows leading to buffer overflow in journal recovery

Eryu Guan (1):
      ext4: check for zero length extent explicitly

Lukas Czerner (1):
      ext4: fix NULL pointer dereference when journal restart fails

Theodore Ts'o (4):
      ext4: fix lazytime optimization
      ext4: don't save the error information if the block device is read-only
      ext4: remove unused function prototype from ext4.h
      ext4: fix an ext3 collapse range regression in xfstests

 fs/ext4/ext4.h        |  1 -
 fs/ext4/ext4_jbd2.c   |  6 ++++++
 fs/ext4/extents.c     | 10 +++++++++-
 fs/ext4/inode.c       |  2 +-
 fs/ext4/super.c       |  2 ++
 fs/jbd2/recovery.c    | 10 +++++++++-
 fs/jbd2/revoke.c      | 18 ++++++++++--------
 fs/jbd2/transaction.c | 25 ++++++++++++++++---------
 8 files changed, 53 insertions(+), 21 deletions(-)
