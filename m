From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 for v2.6.32
Date: Fri, 18 Sep 2009 13:50:26 -0400
Message-ID: <E1MohbG-0006qg-1y@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51607 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbZIRRu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 13:50:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus, 

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following changes for v2.6.32.

Thanks!!

							- Ted

Akira Fujita (9):
      ext4: Fix compile warnings with MB_DEBUG
      ext4: Fix wrong comparisons in mext_check_arguments()
      ext4: Remove unneeded BUG_ON() in ext4_move_extents()
      ext4: Return exchanged blocks count to user space in failure
      ext4: Fix small typo for move_extent_per_page()
      ext4: Replace get_ext_path macro with an inline funciton
      ext4: Replace BUG_ON() with ext4_error() in move_extents.c
      ext4: Add null extent check to ext_get_path
      ext4: Fix different block exchange issue in EXT4_IOC_MOVE_EXT

Andreas Dilger (1):
      jbd2: round commit timer up to avoid uncommitted transaction

Andreas Schlick (1):
      ext4: Always set dx_node's fake_dirent explicitly.

Aneesh Kumar K.V (7):
      ext4: Fix memory leak fix when mounting an ext4 filesystem
      ext4: Add missing unlock_new_inode() call in extent migration code
      ext4: Allow rename to create more than EXT4_LINK_MAX subdirectories
      ext4: Take page lock before looking at attached buffer_heads flags
      ext4: move ext4_mb_init_group() function earlier in the mballoc.c
      ext4: check for need init flag in ext4_mb_load_buddy
      ext4: Clarify the locking details in mballoc

Christoph Hellwig (1):
      ext4: fix cache flush in ext4_sync_file

Curt Wohlgemuth (1):
      ext4: More buffer head reference leaks

Eric Sandeen (8):
      ext4: reject too-large filesystems on 32-bit kernels
      ext4: open-code ext4_mb_update_group_info
      simplify some logic in ext4_mb_normalize_request
      ext4: Add feature set check helper for mount & remount paths
      ext4: use variables not types in sizeofs() for allocations
      ext4: use ext4_grpblk_t more extensively
      ext4: limit block allocations for indirect-block files to < 2^32
      ext4: replace MAX_DEFRAG_SIZE with EXT_MAX_BLOCK

Frank Mayhar (1):
      ext4: Make non-journal fsync work properly

H Hartley Sweeten (1):
      jbd2: bitfields should be unsigned

Jan Kara (4):
      jbd2: Fail to load a journal if it is too short
      jbd2: Annotate transaction start also for jbd2_journal_restart()
      ext4: Fix possible deadlock between ext4_truncate() and ext4_get_blocks()
      ext4: Update documentation about quota mount options

Joe Perches (1):
      ext4: Remove unnecessary semicolons in mballoc.c

Manish Katiyar (1):
      ext4: Fix typo in ext4/Kconfig

Mingming (2):
      ext4: Compile warning fix when EXT_DEBUG enabled
      ext4: Show unwritten extent flag in ext4_ext_show_leaf()

Peng Tao (2):
      ext4: fix build warning when EXT4FS_DEBUG is on
      ext4: fix journal ref count in move_extent_par_page

Roel Kluin (1):
      ext4: remove redundant test on unsigned

Theodore Ts'o (22):
      ext4: Avoid null pointer dereference when decoding EROFS w/o a journal
      ext4: Add configurable run-time mballoc debugging
      ext4: Display the mballoc flags in mb_history in hex instead of decimal
      ext4: Fix bugs in mballoc's stream allocation mode
      ext4: Avoid group preallocation for closed files
      ext4: fix extent sanity checking code with AGGRESSIVE_TEST
      ext4: Limit number of links that can be created by ext4_link()
      ext4: Fix spelling typo in the trace format for trace_ext4_da_writepages()
      ext4: Restore wbc->range_start in ext4_da_writepages()
      ext4: Add new tracepoint: trace_ext4_da_write_pages()
      ext4: fix tracepoint format string warnings
      ext4: Remove journal_checksum mount option and enable it by default
      ext4: print more sysadmin-friendly message in check_block_validity()
      ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
      ext4: Assure that metadata blocks are written during fsync in no journal mode
      ext4: Don't update superblock write time when filesystem is read-only
      ext4: Fix async commit mode to be safe by using a barrier
      ext4: Fix initalization of s_flex_groups
      ext4: Fix include/trace/events/ext4.h to work with Systemtap
      ext4: store EXT4_EXT_MIGRATE in i_state instead of i_flags
      ext4: Add a tracepoint for ext4_alloc_da_blocks()
      ext4: Fix the alloc on close after a truncate hueristic

Tobias Klauser (1):
      ext4: Declare seq_operations and file_operations structures as const

 Documentation/filesystems/ext4.txt |   24 +-
 fs/ext4/Kconfig                    |   11 +-
 fs/ext4/balloc.c                   |    2 +-
 fs/ext4/ext4.h                     |   91 ++++++--
 fs/ext4/ext4_extents.h             |    4 +-
 fs/ext4/ext4_jbd2.c                |    9 +-
 fs/ext4/extents.c                  |  112 ++++++----
 fs/ext4/fsync.c                    |   13 +-
 fs/ext4/ialloc.c                   |    2 +-
 fs/ext4/inode.c                    |  150 +++++++++-----
 fs/ext4/ioctl.c                    |    7 +-
 fs/ext4/mballoc.c                  |  429 +++++++++++++++++++-----------------
 fs/ext4/mballoc.h                  |   22 ++-
 fs/ext4/migrate.c                  |   22 +-
 fs/ext4/move_extent.c              |  334 +++++++++++++++++++---------
 fs/ext4/namei.c                    |   22 ++-
 fs/ext4/resize.c                   |    7 +-
 fs/ext4/super.c                    |  155 ++++++++------
 fs/ext4/xattr.c                    |   15 +-
 fs/jbd2/commit.c                   |   11 +-
 fs/jbd2/journal.c                  |    6 +
 fs/jbd2/transaction.c              |    7 +-
 include/linux/jbd2.h               |    2 +-
 include/trace/events/ext4.h        |  142 +++++++++---
 include/trace/events/jbd2.h        |    2 +-
 25 files changed, 1000 insertions(+), 601 deletions(-)


