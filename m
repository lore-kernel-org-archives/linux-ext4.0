From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.8
Date: Mon, 25 Jul 2016 02:45:32 -0400
Message-ID: <20160725064532.GA29191@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 1a695a905c18548062509178b98bc91e67510864:

  Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 7bc9491645118c9461bd21099c31755ff6783593:

  ext4: verify extent header depth (2016-07-15 00:22:07 -0400)

----------------------------------------------------------------
The major change this cycle is deleting ext4's copy of the file system
encryption code and switching things over to using the copies in
fs/crypto.  I've updated the MAINTAINERS file to add an entry for
fs/crypto listing Jaeguk Kim and myself as the maintainers.

There are also a number of bug fixes, most notably for some problems
found by American Fuzzy Lop (AFL) courtesy of Vegard Nossum.  Also
fixed is a writeback deadlock detected by generic/130, and some
potential races in the metadata checksum code.

----------------------------------------------------------------
Arnd Bergmann (1):
      jbd2: make journal y2038 safe

Carlos Maiolino (1):
      ext2: fix filesystem deadlock while reading corrupted xattr block

Daeho Jeong (2):
      ext4: avoid modifying checksum fields directly during checksum verification
      ext4: correct error value of function verifying dx checksum

Jaegeuk Kim (1):
      ext4 crypto: migrate into vfs's crypto engine

Jan Kara (4):
      jbd2: move lockdep instrumentation for jbd2 handles
      jbd2: move lockdep tracking to journal_s
      jbd2: track more dependencies on transaction commit
      ext4: fix deadlock during page writeback

Pranay Kr. Srivastava (1):
      ext4: Fix WARN_ON_ONCE in ext4_commit_super()

Theodore Ts'o (4):
      ext4: optimize ext4_should_retry_alloc() to improve ENOSPC performance
      ext4: respect the nobarrier mount option in nojournal mode
      ext4: validate s_reserved_gdt_blocks on mount
      MAINTAINRES: fs-crypto maintainers update

Vegard Nossum (5):
      ext4: check for extents that wrap around
      ext4: don't call ext4_should_journal_data() on the journal inode
      ext4: fix reference counting bug on block allocation error
      ext4: short-cut orphan cleanup on error
      ext4: verify extent header depth

Wang Shilong (1):
      ext4: fix project quota accounting without quota limits enabled

yalin wang (1):
      ext4: remove unused page_idx

 MAINTAINERS             |   7 +
 fs/ext2/balloc.c        |  21 +++
 fs/ext2/ext2.h          |   3 +
 fs/ext2/inode.c         |  10 ++
 fs/ext2/xattr.c         |   9 ++
 fs/ext4/Kconfig         |  12 +-
 fs/ext4/Makefile        |   2 -
 fs/ext4/balloc.c        |   7 +-
 fs/ext4/crypto.c        | 536 ---------------------------------------------------------------------------
 fs/ext4/crypto_fname.c  | 468 -----------------------------------------------------------------
 fs/ext4/crypto_key.c    | 274 --------------------------------------
 fs/ext4/crypto_policy.c | 229 --------------------------------
 fs/ext4/dir.c           |  26 ++--
 fs/ext4/ext4.h          | 209 +++++++++++------------------
 fs/ext4/ext4_crypto.h   | 159 ----------------------
 fs/ext4/ext4_jbd2.h     |  10 +-
 fs/ext4/extents.c       |  12 +-
 fs/ext4/file.c          |  10 +-
 fs/ext4/fsync.c         |   5 +-
 fs/ext4/ialloc.c        |   7 +-
 fs/ext4/inline.c        |  14 +-
 fs/ext4/inode.c         |  81 ++++++++----
 fs/ext4/ioctl.c         |  38 +++---
 fs/ext4/mballoc.c       |  29 ++---
 fs/ext4/namei.c         | 144 ++++++++++----------
 fs/ext4/page-io.c       |  13 +-
 fs/ext4/readpage.c      |  48 +------
 fs/ext4/super.c         | 162 ++++++++++++++++++-----
 fs/ext4/symlink.c       |  35 +++--
 fs/ext4/xattr.c         |  13 +-
 fs/jbd2/commit.c        |   2 +-
 fs/jbd2/journal.c       |   5 +
 fs/jbd2/transaction.c   |  17 ++-
 include/linux/jbd2.h    |  23 +++-
 34 files changed, 538 insertions(+), 2102 deletions(-)
 delete mode 100644 fs/ext4/crypto.c
 delete mode 100644 fs/ext4/crypto_fname.c
 delete mode 100644 fs/ext4/crypto_key.c
 delete mode 100644 fs/ext4/crypto_policy.c
 delete mode 100644 fs/ext4/ext4_crypto.h
