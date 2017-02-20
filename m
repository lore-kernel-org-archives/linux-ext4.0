From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.11
Date: Mon, 20 Feb 2017 16:34:15 -0500
Message-ID: <20170220213415.rcgc7u3u3j6lyeph@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please merge the fscrypt tree first, or the diff stats that you see
will include some additional fscrypt changes (I had to merge in a
portion of the fscrypt branch for dependency reasons).

Thanks!!

						- Ted


The following changes since commit 56735be05353b085a0862ca4c4943628df3420ca:

  Merge branch 'fscrypt' into d (2017-01-08 20:57:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to e9be2ac7c09cabcbbbb12b0869e49b7a715d6fb5:

  ext4: rename EXT4_IOC_GOINGDOWN to EXT4_IOC_SHUTDOWN (2017-02-20 15:34:59 -0500)

----------------------------------------------------------------
For this cycle we add support for the shutdown ioctl, which is
primarily used for testing, but which can be useful on production
systems when a scratch volume is being destroyed and the data on it
doesn't need to be saved.  This found (and we fixed) a number of bugs
with ext4's recovery to corrupted file system --- the bugs increased
the amount of data that could be potentially lost, and in the case of
the inline data feature, could cause the kernel to BUG.

Also included are a number of other bug fixes, including in ext4's
fscrypt, DAX, inline data support.

----------------------------------------------------------------
Christoph Hellwig (2):
      ext4: fix DAX write locking
      dax: assert that i_rwsem is held exclusive for writes

Eric Biggers (1):
      ext4: fix use-after-iput when fscrypt contexts are inconsistent

Jan Kara (4):
      ext4: trim allocation requests to group size
      ext4: fix data corruption in data=journal mode
      ext4: fix stripe-unaligned allocations
      ext4: do not use stripe_width if it is not set

Jason A. Donenfeld (1):
      ext4: move halfmd4 into hash.c directly

Roman Pen (2):
      ext4: Include forgotten start block on fallocate insert range
      ext4: do not polute the extents cache while shifting extents

Sahitya Tummala (1):
      jbd2: fix use after free in kjournald2()

Theodore Ts'o (15):
      ext4: add debug_want_extra_isize mount option
      ext4: fix deadlock between inline_data and ext4_expand_extra_isize_ea()
      ext4: avoid calling ext4_mark_inode_dirty() under unneeded semaphores
      ext4: propagate error values from ext4_inline_data_truncate()
      ext4: replace BUG_ON with WARN_ON in mb_find_extent()
      ext4: fix inline data error paths
      jbd2: don't leak modified metadata buffers on an aborted journal
      ext4: preserve the needs_recovery flag when the journal is aborted
      ext4: return EROFS if device is r/o and journal replay is needed
      ext4: rename s_resize_flags to s_ext4_flags
      ext4: add shutdown bit and check for it
      ext4: add EXT4_IOC_GOINGDOWN ioctl
      ext4: don't BUG when truncating encrypted inodes on the orphan list
      ext4: fix fencepost in s_first_meta_bg validation
      ext4: rename EXT4_IOC_GOINGDOWN to EXT4_IOC_SHUTDOWN

 fs/dax.c                   |   6 +++-
 fs/ext4/ext4.h             |  28 ++++++++++++++---
 fs/ext4/ext4_jbd2.c        |  11 +++++++
 fs/ext4/extents.c          |  27 +++++++++++------
 fs/ext4/file.c             |  22 ++++++++------
 fs/ext4/fsync.c            |   3 ++
 fs/ext4/hash.c             |  71 ++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/ialloc.c           |   3 ++
 fs/ext4/inline.c           | 123 ++++++++++++++++++++++++++++++++++++++++-----------------------------------
 fs/ext4/inode.c            |  79 +++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/ioctl.c            |  50 +++++++++++++++++++++++++++++++
 fs/ext4/mballoc.c          |  25 ++++++++++++++--
 fs/ext4/namei.c            |  18 +++++++++--
 fs/ext4/page-io.c          |   2 +-
 fs/ext4/resize.c           |   5 ++--
 fs/ext4/super.c            |  47 +++++++++++++++++++++++------
 fs/ext4/xattr.c            |  33 ++++++++++----------
 fs/ext4/xattr.h            |  32 ++++++++++++++++++++
 fs/jbd2/journal.c          |   2 +-
 fs/jbd2/transaction.c      |   4 ++-
 include/linux/cryptohash.h |   2 --
 lib/Makefile               |   2 +-
 lib/halfmd4.c              |  67 -----------------------------------------
 23 files changed, 456 insertions(+), 206 deletions(-)
 delete mode 100644 lib/halfmd4.c
