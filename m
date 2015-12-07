From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfixes for 4.4
Date: Sun, 6 Dec 2015 22:40:55 -0500
Message-ID: <20151207034055.GA424@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit be69e1c19f0efb091f29521715c380842fa4cd7e:

  fs/ext4: remove unnecessary new_valid_dev check (2015-10-29 14:18:13 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 087ffd4eae9929afd06f6a709861df3c3508492a:

  jbd2: fix null committed data return in undo_access (2015-12-04 12:29:28 -0500)

----------------------------------------------------------------
Ext4 bug fixes for v4.4, including fixes for post-2038 time encodings,
some endian conversion problems with ext4 encryption, potential memory
leaks after truncate in data=journal mode, and an ocfs2 regression
caused by a jbd2 performance improvement.

----------------------------------------------------------------
Al Viro (2):
      ext4: fix an endianness bug in ext4_encrypted_zeroout()
      ext4: fix an endianness bug in ext4_encrypted_follow_link()

David Turner (1):
      ext4: Fix handling of extended tv_sec

Jan Kara (1):
      jbd2: Fix unreclaimed pages after truncate in data=journal mode

Junxiao Bi (1):
      jbd2: fix null committed data return in undo_access

Xu Cang (1):
      ext4: add "static" to ext4_seq_##name##_fops struct

 fs/ext4/crypto.c      |  2 +-
 fs/ext4/ext4.h        | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/symlink.c     |  2 +-
 fs/ext4/sysfs.c       |  2 +-
 fs/jbd2/transaction.c | 12 +++++++++---
 5 files changed, 56 insertions(+), 13 deletions(-)
