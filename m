From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.4
Date: Fri, 6 Nov 2015 11:24:52 -0500
Message-ID: <20151106162452.GA19804@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 1f93e4a96c9109378204c147b3eec0d0e8100fde:

  Linux 4.3-rc2 (2015-09-20 14:32:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to be69e1c19f0efb091f29521715c380842fa4cd7e:

  fs/ext4: remove unnecessary new_valid_dev check (2015-10-29 14:18:13 -0400)

----------------------------------------------------------------
Add support for the CSUM_SEED feature which will allow future
userspace utilities to change the file system's UUID without rewriting
all of the file system metadata.

A number of miscellaneous fixes, the most significant of which are in
the ext4 encryption support.  Anyone wishing to use the encryption
feature should backport all of the ext4 crypto patches up to 4.4 to
get fixes to a memory leak and file system corruption bug.

There are also cleanups in ext4's feature test macros and in ext4's
sysfs support code.

----------------------------------------------------------------
Andy Leiserson (1):
      fix calculation of meta_bg descriptor backups

Daeho Jeong (2):
      ext4: fix xfstest generic/269 double revoked buffer bug with bigalloc
      ext4, jbd2: ensure entering into panic after recording an error in superblock

Darrick J. Wong (7):
      jbd2: gate checksum calculations on crc driver presence, not sb flags
      ext4: promote ext4 over ext2 in the default probe order
      ext4: store checksum seed in superblock
      ext4: call out CRC and corruption errors with specific error codes
      ext4: clean up feature test macros with predicate functions
      jbd2: clean up feature test macros with predicate functions
      ext4: make the bitmap read routines return real error codes

Dmitry Monakhov (2):
      ext4: explicit mount options parsing cleanup
      ext4: do not allow journal_opts for fs w/o journal

Jan Kara (1):
      jbd2: fix checkpoint list cleanup

John Stultz (1):
      ext4: fix abs() usage in ext4_mb_check_group_pa

Lukas Czerner (1):
      ext4: fix potential use after free in __ext4_journal_stop

Theodore Ts'o (10):
      ext4: move sysfs code from super.c to fs/ext4/sysfs.c
      ext4: refactor sysfs support code
      ext4: move procfs registration code to fs/ext4/sysfs.c
      ext4 crypto: fix memory leak in ext4_bio_write_page()
      ext4: optimize ext4_writepage() for attempted 4k delalloc writes
      ext4 crypto: ext4_page_crypto() doesn't need a encryption context
      ext4 crypto: replace some BUG_ON()'s with error checks
      ext4 crypto: fix bugs in ext4_encrypted_zeroout()
      ext4: use private version of page_zero_new_buffers() for data=journal mode
      ext4: reserve code points for the project quota feature

Yaowei Bai (1):
      fs/ext4: remove unnecessary new_valid_dev check

 fs/Makefile              |   7 +-
 fs/ext4/Makefile         |   2 +-
 fs/ext4/balloc.c         |  92 +++++-----
 fs/ext4/block_validity.c |   2 +-
 fs/ext4/crypto.c         |  52 +++---
 fs/ext4/crypto_fname.c   |   2 -
 fs/ext4/crypto_key.c     |  16 +-
 fs/ext4/crypto_policy.c  |   3 +-
 fs/ext4/dir.c            |   7 +-
 fs/ext4/ext4.h           | 177 +++++++++++++++++--
 fs/ext4/ext4_jbd2.c      |   6 +-
 fs/ext4/ext4_jbd2.h      |  10 +-
 fs/ext4/extents.c        |  82 ++++-----
 fs/ext4/extents_status.c |  60 +------
 fs/ext4/extents_status.h |   2 +
 fs/ext4/ialloc.c         | 113 ++++++++----
 fs/ext4/indirect.c       |   5 +-
 fs/ext4/inline.c         |   3 +-
 fs/ext4/inode.c          |  83 ++++++---
 fs/ext4/ioctl.c          |  15 +-
 fs/ext4/mballoc.c        |  91 +++++-----
 fs/ext4/migrate.c        |   9 +-
 fs/ext4/mmp.c            |   8 +-
 fs/ext4/namei.c          |  39 ++---
 fs/ext4/page-io.c        |   5 +-
 fs/ext4/readpage.c       |   2 +-
 fs/ext4/resize.c         |  34 ++--
 fs/ext4/super.c          | 695 ++++++++++++++++----------------------------------------------------------
 fs/ext4/symlink.c        |   2 +-
 fs/ext4/sysfs.c          | 448 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.c          |  32 ++--
 fs/jbd2/checkpoint.c     |   8 +-
 fs/jbd2/commit.c         |  22 +--
 fs/jbd2/journal.c        |  27 +--
 fs/jbd2/recovery.c       |  26 ++-
 fs/jbd2/revoke.c         |   4 +-
 include/linux/jbd2.h     |  84 ++++++++-
 include/uapi/linux/fs.h  |   1 +
 38 files changed, 1279 insertions(+), 997 deletions(-)
 create mode 100644 fs/ext4/sysfs.c
