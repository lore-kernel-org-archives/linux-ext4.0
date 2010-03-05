From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Thu, 04 Mar 2010 23:44:51 -0500
Message-ID: <E1NnPP9-0001Y1-52@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the latest bug fixes and improvements for the 2.6.34 merge
window.

Thanks,

                                                - Ted

Akinobu Mita (3):
      ext4: cleanup to use ext4_group_first_block_no()
      ext4: cleanup to use ext4_grp_offs_to_block()
      ext4: consolidate in_range() definitions

Akira Fujita (3):
      ext4: Fix insertion point of extent in mext_insert_across_blocks()
      ext4: Fix the NULL reference in double_down_write_data_sem()
      ext4: Code cleanup for EXT4_IOC_MOVE_EXT ioctl

Curt Wohlgemuth (1):
      ext4: Fix BUG_ON at fs/buffer.c:652 in no journal mode

Dmitry Monakhov (7):
      ext4: mount flags manipulation cleanup
      ext4: trivial quota cleanup
      ext4: deprecate obsoleted mount options
      ext4: fix error handling in migrate
      ext4: explicitly remove inode from orphan list after failed direct io
      ext4: Handle non empty on-disk orphan link
      ext4: Fix ext4_quota_write cross block boundary behaviour

Eric Sandeen (3):
      ext4: fix async i/o writes beyond 4GB to a sparse file
      ext4: Fix optional-arg mount options
      ext4: move __func__ into a macro for ext4_warning, ext4_error

Frank Mayhar (1):
      ext4: Convert BUG_ON checks to use ext4_error() instead

Jan Kara (1):
      ext4: Release page references acquired in ext4_da_block_invalidatepages

Jiaying Zhang (4):
      ext4: Add flag to files with blocks intentionally past EOF
      ext4: mechanical rename some of the direct I/O get_block's identifiers
      ext4: use ext4_get_block_write in buffer write
      ext4: Use direct_IO_no_locking in ext4 dio read

Leonard Michlmayr (1):
      ext4: correctly calculate number of blocks for fiemap

Roel Kluin (1):
      ext4: add missing error checking to ext4_expand_extra_isize_ea()

Tao Ma (1):
      ext4: Fix fencepost error in chosing choosing group vs file preallocation.

Theodore Ts'o (6):
      ext4: Add block validity check when truncating indirect block mapped inodes
      ext4: Add new tracepoint for jbd2_cleanup_journal_tail
      ext4: Add new tracepoints to debug delayed allocation space functions
      ext4: Use slab allocator for sub-page sized allocations
      ext4: Use bitops to read/modify EXT4_I(inode)->i_state
      ext4: Reserve INCOMPAT_EA_INODE and INCOMPAT_DIRDATA feature codepoints

Toshiyuki Okajima (1):
      ext4: make "offset" consistent in ext4_check_dir_entry()

Venkatesh Pallipadi (1):
      ext4: fix up rb_root initializations to use RB_ROOT

dingdinghua (2):
      jbd2: delay discarding buffers in journal_unmap_buffer
      jbd2: clean up an assertion in jbd2_journal_commit_transaction()

 fs/ext4/balloc.c            |   35 +---
 fs/ext4/block_validity.c    |    4 +-
 fs/ext4/dir.c               |   14 +-
 fs/ext4/ext4.h              |  106 +++++++---
 fs/ext4/ext4_jbd2.c         |    4 +-
 fs/ext4/ext4_jbd2.h         |   24 +++
 fs/ext4/extents.c           |  260 ++++++++++++++++++------
 fs/ext4/file.c              |    4 +-
 fs/ext4/fsync.c             |    2 +-
 fs/ext4/ialloc.c            |   32 ++--
 fs/ext4/inode.c             |  459 +++++++++++++++++++++++++++++-------------
 fs/ext4/ioctl.c             |   12 +-
 fs/ext4/mballoc.c           |   73 +++----
 fs/ext4/mballoc.h           |    9 +-
 fs/ext4/migrate.c           |   35 ++--
 fs/ext4/move_extent.c       |   36 ++--
 fs/ext4/namei.c             |   63 +++---
 fs/ext4/resize.c            |  102 ++++------
 fs/ext4/super.c             |  342 ++++++++++++++++++++------------
 fs/ext4/xattr.c             |   56 +++---
 fs/jbd2/checkpoint.c        |    1 +
 fs/jbd2/commit.c            |   13 +-
 fs/jbd2/journal.c           |  132 +++++++++++++
 fs/jbd2/transaction.c       |   43 +++--
 include/linux/jbd2.h        |   11 +-
 include/trace/events/ext4.h |  101 ++++++++++
 include/trace/events/jbd2.h |   28 +++
 27 files changed, 1344 insertions(+), 657 deletions(-)
