From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.9
Date: Sun, 23 Oct 2016 08:39:48 -0400
Message-ID: <20161023123948.blgxlmb6vgtswfnf@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit b67be92feb486f800d80d72c67fd87b47b79b18e:

  Merge tag 'pwm/for-4.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm (2016-10-12 11:11:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to d74f3d25289aa9722cf777a7482eeee2eacdf46e:

  ext4: add missing KERN_CONT to a few more debugging uses (2016-10-15 09:57:31 -0400)

----------------------------------------------------------------
A few bug fixes and add some missing KERN_CONT annotations

----------------------------------------------------------------
Eric Biggers (4):
      ext4: do not advertise encryption support when disabled
      fscrypto: make XTS tweak initialization endian-independent
      ext4: correct endianness conversion in __xattr_check_inode()
      fscrypto: lock inode while setting encryption policy

Joe Perches (2):
      ext4: super.c: Update logging style using KERN_CONT
      ext4: add missing KERN_CONT to a few more debugging uses

Taesoo Kim (1):
      jbd2: fix incorrect unlock on j_list_lock

 fs/crypto/crypto.c       | 15 ++++++++-------
 fs/crypto/policy.c       |  4 ++++
 fs/ext4/block_validity.c |  4 ++--
 fs/ext4/mballoc.h        | 17 ++++++++---------
 fs/ext4/namei.c          | 18 ++++++++++--------
 fs/ext4/super.c          | 21 +++++++++++----------
 fs/ext4/sysfs.c          |  4 ++++
 fs/ext4/xattr.c          | 20 +++++++-------------
 fs/jbd2/transaction.c    |  3 ++-
 9 files changed, 56 insertions(+), 50 deletions(-)
