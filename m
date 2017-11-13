From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.15
Date: Sun, 12 Nov 2017 22:15:02 -0500
Message-ID: <20171113031502.f6mctmlmgk5psh77@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38168 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdKMDPE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Nov 2017 22:15:04 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 9e66317d3c92ddaab330c125dfe9d06eee268aff:

  Linux 4.14-rc3 (2017-10-01 14:54:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 232530680290ba94ca37852ab10d9556ea28badf:

  ext4: improve smp scalability for inode generation (2017-11-08 22:23:20 -0500)

----------------------------------------------------------------
Add support for online resizing of file systems with bigalloc.  Fix a
two data corruption bugs involving DAX, as well as a corruption bug
after a crash during a racing fallocate and delayed allocation.
Finally, a number of cleanups and optimizations.

----------------------------------------------------------------
Andreas Gruenbacher (3):
      iomap: Switch from blkno to disk offset
      iomap: Add IOMAP_F_DATA_INLINE flag
      ext4: Add iomap support for inline data

Christoph Hellwig (1):
      ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA

Kees Cook (2):
      jbd2: convert timers to use timer_setup()
      ext4: convert timers to use timer_setup()

Pavel Machek (1):
      Documentation: fix little inconsistencies

Ross Zwisler (5):
      ext4: prevent data corruption with inline data + DAX
      ext4: prevent data corruption with journaling + DAX
      ext4: add sanity check for encryption + DAX
      ext4: add ext4_should_use_dax()
      ext4: remove duplicate extended attributes defs

Simon Ruderich (1):
      ext4: mention noload when recovering on read-only device

Theodore Ts'o (3):
      ext4: retry allocations conservatively
      ext4: fix interaction between i_size, fallocate, and delalloc after a crash
      ext4: improve smp scalability for inode generation

harshads (1):
      ext4: add support for online resizing with bigalloc

 Documentation/filesystems/ext4.txt |   8 +--
 fs/buffer.c                        |   4 +-
 fs/dax.c                           |   2 +-
 fs/ext2/inode.c                    |   4 +-
 fs/ext4/Kconfig                    |   1 +
 fs/ext4/balloc.c                   |  15 ++--
 fs/ext4/ext4.h                     |  50 ++-----------
 fs/ext4/extents.c                  |   6 +-
 fs/ext4/file.c                     | 263 ++++-----------------------------------------------------------------
 fs/ext4/ialloc.c                   |   4 +-
 fs/ext4/inline.c                   |  43 +++++++++---
 fs/ext4/inode.c                    | 153 ++++++++++++++++++----------------------
 fs/ext4/ioctl.c                    |  30 ++++----
 fs/ext4/mballoc.c                  |  28 ++++----
 fs/ext4/resize.c                   | 104 +++++++++++++++++----------
 fs/ext4/super.c                    |  27 +++----
 fs/iomap.c                         |  13 ++--
 fs/jbd2/journal.c                  |   9 ++-
 fs/nfsd/blocklayout.c              |   4 +-
 fs/xfs/xfs_iomap.c                 |   6 +-
 include/linux/iomap.h              |  15 ++--
 21 files changed, 278 insertions(+), 511 deletions(-)
