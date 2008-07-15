From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfixes
Date: Mon, 14 Jul 2008 23:56:28 -0400
Message-ID: <E1KIbeO-0001yQ-N4@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34152 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754086AbYGOD4b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 23:56:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This patch series contains a whole series of cleanups saved up since the
last merge window, plus delayed allocation for ext4.

Thanks!!

						- Ted

Akinobu Mita (1):
      ext4: fix ext4_init_block_bitmap() for metablock block group

Alex Tomas (2):
      vfs: add hooks for ext4's delayed allocation support
      ext4: Add delayed allocation support in data=writeback mode

Alexey Dobriyan (1):
      ext4: switch to seq_files

Aneesh Kumar K.V (12):
      ext4: Fix mb_find_next_bit not to return larger than max
      ext4: start searching for the right extent from the goal group.
      ext4: Update i_disksize properly when allocating from fallocate area.
      ext4: Fix sparse warning
      ext4: Use inode preallocation with -o noextents
      ext4: cleanup block allocator
      ext4: Use page_mkwrite vma_operations to get mmap write notification.
      mm: Add range_cont mode for writeback
      ext4: Add ordered mode support for delalloc
      ext4: Handle page without buffers in ext4_*_writepage()
      ext4: Enable delalloc by default.
      ext4: Don't allow nonextenst mount option for large filesystem

Duane Griffin (3):
      ext4: handle corrupted orphan list at mount
      ext4: handle deleting corrupted indirect blocks
      ext4: validate directory entry data before use

Eric Sandeen (3):
      ext4: call blkdev_issue_flush on fsync
      ext4: use atomic functions to set bh_state
      ext4: do not set extents feature from the kernel

Frederic Bohe (1):
      ext4: fix online resize with mballoc

Jan Kara (8):
      ext4: Set journal pointer to NULL when journal is released
      vfs: Move mark_inode_dirty() from under page lock in generic_write_end()
      ext4: Invert the locking order of page_lock and transaction start
      ext4: Fix lock inversion in ext4_ext_truncate()
      vfs: export filemap_fdatawrite_range()
      jbd2: Implement data=ordered mode handling via inodes
      ext4: Use new framework for data=ordered mode in JBD2
      jbd2: Remove data=ordered mode support using jbd buffer heads

Jose R. Santos (2):
      ext4: New inode allocation for FLEX_BG meta-data groups.
      ext4: Documentation updates.

Julia Lawall (1):
      ext4: Use BUG_ON() instead of BUG()

Li Zefan (3):
      ext4: fix build failure if DX_DEBUG is enabled
      ext4: remove redundant code in ext4_fill_super()
      ext4: cleanup never-used magic numbers from htree code

Mingming Cao (9):
      ext4: Fix ext4_mb_init_cache return error
      jbd2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
      ext4: mballoc avoid use root reserved blocks for non root allocation
      percpu_counter: new function percpu_counter_sum_and_set
      ext4: delayed allocation ENOSPC handling
      ext4: Invert lock ordering of page_lock and transaction start in delalloc
      ext4: fix delalloc i_disksize early update issue
      ext4: delayed allocation i_blocks fix for stat
      ext4: Documention update for new ordered mode and delayed allocation

Shen Feng (11):
      ext4: fix comments to say "ext4"
      ext4: improve some code in rb tree part of dir.c
      ext4: add error processing when calling ext4_mb_init_cache in mballoc
      ext4: miscellaneous error checks and coding cleanups for mballoc
      ext4: remove double definitions of xattr macros
      ext4: error proc entry creation when the fs/ext4 is not correctly created
      ext4: fix error processing in mb_free_blocks
      ext4: remove quota allocation when ext4_mb_new_blocks fails
      ext4: return error when calling ext4_ext_split failed
      ext4: Make ext4_ext_find_extent fills ext_path completely
      ext4: Fix ext4_ext_journal_restart() to reflect errors up to the caller

Stoyan Gaydarov (1):
      ext4: replace __FUNCTION__ occurrences

Theodore Ts'o (3):
      ext4: Rename read_block_bitmap() to ext4_read_block_bitmap()
      ext4: Remove unused variable from ext4_show_options
      jbd2: Add commit time into the commit block

 Documentation/filesystems/ext4.txt |  125 ++--
 fs/buffer.c                        |   19 +-
 fs/ext4/balloc.c                   |  209 ++++--
 fs/ext4/dir.c                      |   17 +-
 fs/ext4/ext4.h                     |   61 ++-
 fs/ext4/ext4_extents.h             |    1 +
 fs/ext4/ext4_i.h                   |   10 +-
 fs/ext4/ext4_jbd2.h                |   21 +-
 fs/ext4/ext4_sb.h                  |    5 +-
 fs/ext4/extents.c                  |  111 ++-
 fs/ext4/file.c                     |   20 +-
 fs/ext4/fsync.c                    |    4 +
 fs/ext4/group.h                    |    2 +-
 fs/ext4/ialloc.c                   |  113 +++-
 fs/ext4/inode.c                    | 1591 ++++++++++++++++++++++++++++++------
 fs/ext4/mballoc.c                  |  451 +++++++---
 fs/ext4/namei.c                    |   45 +-
 fs/ext4/resize.c                   |   52 ++-
 fs/ext4/super.c                    |  142 +++-
 fs/ext4/xattr.c                    |    2 +-
 fs/ext4/xattr_trusted.c            |    4 +-
 fs/ext4/xattr_user.c               |    4 +-
 fs/jbd2/checkpoint.c               |    1 -
 fs/jbd2/commit.c                   |  294 +++-----
 fs/jbd2/journal.c                  |   53 ++-
 fs/jbd2/transaction.c              |  365 ++++-----
 fs/mpage.c                         |   14 +-
 include/linux/fs.h                 |    2 +
 include/linux/jbd2.h               |   73 ++-
 include/linux/mpage.h              |   10 +
 include/linux/percpu_counter.h     |   12 +-
 include/linux/writeback.h          |    1 +
 lib/percpu_counter.c               |    7 +-
 mm/filemap.c                       |    3 +-
 mm/page-writeback.c                |    3 +
 35 files changed, 2805 insertions(+), 1042 deletions(-)
