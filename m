From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.12
Date: Sun, 7 May 2017 14:09:10 -0400
Message-ID: <20170507180910.nxy6ho2zrdf3jfxn@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

vThe following changes since commit 39da7c509acff13fc8cb12ec1bb20337c988ed36:

  Linux 4.11-rc6 (2017-04-09 09:49:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 17f423b5160767a8ec43b0602767e5f4d3ecd083:

  jbd2: cleanup write flags handling from jbd2_write_superblock() (2017-05-04 11:01:31 -0400)

----------------------------------------------------------------
Add GETFSMAP support; some performance improvements for very large
file systems and for random write workloads into a preallocated file;
bug fixes and cleanups.

----------------------------------------------------------------
Andrew Perepechko (1):
      ext4: preload block group descriptors

Darrick J. Wong (2):
      vfs: add common GETFSMAP ioctl definitions
      ext4: support GETFSMAP ioctls

Eric Biggers (8):
      ext4: trim return value and 'dir' argument from ext4_insert_dentry()
      ext4: constify static data that is never modified
      ext4: merge ext4_xattr_list() into ext4_listxattr()
      ext4: rename ext4_xattr_check_names() to ext4_xattr_check_entries()
      ext4: remove ext4_xattr_check_entry()
      ext4: evict inline data when writing to memory map
      ext4: make ext4_shutdown() static
      ext4: inherit encryption xattr before other xattrs

Jan Kara (5):
      jbd2: Fix lockdep splat with generic/270 test
      jbd2: fix dbench4 performance regression for 'nobarrier' mounts
      ext4: avoid unnecessary transaction stalls during writeback
      ext4: mark superblock writes synchronous for nobarrier mounts
      jbd2: cleanup write flags handling from jbd2_write_superblock()

Theodore Ts'o (2):
      mm: retry writepages() on ENOMEM when doing an data integrity writeback
      ext4: replace BUG_ON with WARN_ONCE in ext4_end_bio()

 fs/ext4/Makefile            |  10 +-
 fs/ext4/ext4.h              |  13 +-
 fs/ext4/fsmap.c             | 722 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/fsmap.h             |  69 ++++++
 fs/ext4/ialloc.c            |  17 +-
 fs/ext4/inline.c            |   2 +-
 fs/ext4/inode.c             |  40 ++++
 fs/ext4/ioctl.c             |  92 +++++++-
 fs/ext4/mballoc.c           |  51 ++++-
 fs/ext4/mballoc.h           |  17 ++
 fs/ext4/namei.c             |  17 +-
 fs/ext4/page-io.c           |  11 +-
 fs/ext4/super.c             |  14 +-
 fs/ext4/sysfs.c             |   8 +-
 fs/ext4/xattr.c             |  63 ++----
 fs/jbd2/journal.c           |  28 ++-
 include/trace/events/ext4.h |  74 ++++++
 include/uapi/linux/fsmap.h  | 112 +++++++++
 mm/page-writeback.c         |  14 +-
 19 files changed, 1277 insertions(+), 97 deletions(-)
 create mode 100644 fs/ext4/fsmap.c
 create mode 100644 fs/ext4/fsmap.h
 create mode 100644 include/uapi/linux/fsmap.h
