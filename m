From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 3.1
Date: Mon, 01 Aug 2011 18:39:37 -0400
Message-ID: <E1Qo197-0004oD-JO@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40928 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1HAWjl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 18:39:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Here are my changes for 3.1 can be found here:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

However, there will be a merge conflict because the function
ext4_ind_direct_IO() got moved from inode.c to a new file indirect.c as
part of a cleanup effort.  So a patch hunk that attempted to be applied
to inode.c in upstream caused a merge conflict, and needs to be manually
applied to indirect.c.

My fixup of the merge conflict can be found here:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git upstream-merge

Please pull from either for_linus or upstream-merge, at your
convenience.

Many thanks!!

						- Ted

Allison Henderson (2):
      ext4: punch hole optimizations: skip un-needed extent lookup
      ext4: remove unneeded parameter to ext4_ext_remove_space()

Amir Goldstein (3):
      ext4: split ext4_ind_truncate from ext4_truncate
      ext4: rename ext4_indirect_* funcs to ext4_ind_*
      ext4: move ext4_ind_* functions from inode.c to indirect.c

Bernd Schubert (1):
      ext4: fix compilation with -DDX_DEBUG

Dan Carpenter (1):
      ext4: add missing kfree() on error return path in add_new_gdb()

Dan Ehrenberg (2):
      ext4: make the preallocation size be a multiple of stripe size
      ext4: ignore a stripe width of 1

Eric Sandeen (1):
      ext4: refactor duplicated block placement code

Jan Kara (1):
      ext4: fix data corruption in inodes with journalled data

Jiaying Zhang (1):
      ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails

Lukas Czerner (1):
      ext4: remove unnecessary comments in ext4_orphan_add()

Maxim Patlasov (1):
      ext4: fix i_blocks/quota accounting when extent insertion fails

Robin Dong (9):
      ext4: fix incorrect error msg in ext4_ext_insert_index
      ext4: remove redundant goto in ext4_ext_insert_extent()
      ext4: avoid unneeded ext4_ext_next_leaf_block() while inserting extents
      ext4: avoid wasted extent cache lookup if !PUNCH_OUT_EXT
      ext4: avoid eh_entries overflow before insert extent_idx
      ext4: remove unused argument in ext4_ext_next_leaf_block
      ext4: correct the debug message in ext4_ext_insert_extent
      ext4: correct comment for ext4_ext_check_cache
      ext4: add action of moving index in ext4_ext_rm_idx for Punch Hole

Tao Ma (11):
      jbd2: use WRITE_SYNC in journal checkpoint
      ext4: fix trim length underflow with small trim length
      ext4: speed up group trim with the right free block count
      ext4: Add new ext4 trim tracepoints
      ext4: Speed up FITRIM by recording flags in ext4_group_info
      ext4: Change the wrong param comment for ext4_trim_all_free
      ext4: fix a race which could leak memory in ext4_groupinfo_create_slab()
      ext4: Fix a double free of sbi->s_group_info in ext4_mb_init_backend
      ext4: remove unnecessary ext4_get_group_info in ext4_mb_load_buddy
      ext4: don't increment s_mb_buddies_generated in ext4_mb_release
      ext4: remove ac_repeats from ext4_allocation_context

Theodore Ts'o (10):
      ext4: move __ext4_check_blockref to block_validity.c
      ext4: move common truncate functions to header file
      ext4: remove loop around bio_alloc()
      jbd2: remove jbd2_dev_to_name() from jbd2 tracepoints
      ext4: add tracepoint for ext4_journal_start
      ext4: fix races in ext4_sync_parent()
      ext4: change umode_t in tracepoint headers to be an explicit __u16
      ext4: introduce ext4_kvmalloc(), ext4_kzalloc(), and ext4_kvfree()
      ext4: use ext4_kvzalloc()/ext4_kvmalloc() for s_group_desc and s_group_info
      ext4: use ext4_msg() instead of printk in mballoc

Utako Kusaka (1):
      ext4: Fix overflow caused by missing cast in ext4_fallocate()

Yongqiang Yang (13):
      ext4: quiet 'unused variables' compile warnings
      ext4: prevent parallel resizers by atomic bit ops
      ext4: prevent a fs with errors from being resized
      ext4: rename ext4_add_groupblocks() to ext4_group_add_blocks()
      ext4: let ext4_group_add_blocks() return an error code
      ext4: let ext4_group_add_blocks() handle 0 blocks quickly
      ext4: fix a typo in ext4_group_extend()
      ext4: let setup_new_group_blocks() set multiple bits at a time
      ext4: simplify journal handling in setup_new_group_blocks()
      ext4: remove lock_buffer in bclean() and setup_new_group_blocks()
      ext4: simplify parameters of add_new_gdb()
      ext4: simplify parameters of reserve_backup_gdb()
      ext4: use the correct error exit path in ext4_init_inode_table()

Yu Jian (2):
      ext4: use EXT4_BAD_INO for buddy cache to avoid colliding with valid inode #
      ext4: prevent memory leaks from ext4_mb_init_backend() on error path

 fs/ext4/Makefile            |    2 +-
 fs/ext4/balloc.c            |   48 ++
 fs/ext4/block_validity.c    |   21 +
 fs/ext4/ext4.h              |   55 ++-
 fs/ext4/extents.c           |  129 ++--
 fs/ext4/fsync.c             |   26 +-
 fs/ext4/ialloc.c            |    2 +-
 fs/ext4/indirect.c          | 1484 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c             | 1598 +------------------------------------------
 fs/ext4/ioctl.c             |   12 +-
 fs/ext4/mballoc.c           |  230 ++++---
 fs/ext4/mballoc.h           |    1 -
 fs/ext4/namei.c             |   21 +-
 fs/ext4/page-io.c           |    6 +-
 fs/ext4/resize.c            |  199 +++---
 fs/ext4/super.c             |   88 ++-
 fs/ext4/truncate.h          |   43 ++
 fs/jbd2/checkpoint.c        |    5 +-
 fs/jbd2/journal.c           |   67 --
 include/linux/jbd2.h        |    6 -
 include/trace/events/ext4.h |   87 +++-
 include/trace/events/jbd2.h |   36 +-
 22 files changed, 2192 insertions(+), 1974 deletions(-)
