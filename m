From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.38
Date: Tue, 11 Jan 2011 16:36:15 -0500
Message-ID: <E1Pclt1-000320-HF@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55001 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1AKVgV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 16:36:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

It's a somewhat larger number of changes this time but it's all
primarily cleanup and minor bug fixes.

						- Ted


 fs/ext2/xattr.c        |   10 +--
 fs/ext3/xattr.c        |    2 +-
 fs/ext4/balloc.c       |    3 +-
 fs/ext4/dir.c          |   58 ++++++----
 fs/ext4/ext4.h         |   93 ++++++++++------
 fs/ext4/ext4_extents.h |    8 +-
 fs/ext4/ext4_jbd2.h    |    2 +-
 fs/ext4/extents.c      |   88 +++++++++------
 fs/ext4/file.c         |   22 ++++
 fs/ext4/fsync.c        |    4 +-
 fs/ext4/ialloc.c       |    2 +-
 fs/ext4/inode.c        |   74 +++++++++----
 fs/ext4/mballoc.c      |   55 ++++-----
 fs/ext4/migrate.c      |    2 +-
 fs/ext4/namei.c        |   69 ++++++++----
 fs/ext4/page-io.c      |    7 +-
 fs/ext4/resize.c       |   64 ++++++++---
 fs/ext4/super.c        |  288 ++++++++++++++++++++++++++----------------------
 fs/ext4/xattr.c        |   28 +++---
 fs/jbd2/journal.c      |   34 +++---
 fs/jbd2/recovery.c     |    2 +-
 fs/jbd2/transaction.c  |    6 +-
 include/linux/jbd2.h   |   20 +++-
 23 files changed, 562 insertions(+), 379 deletions(-)

Andrew Morton (1):
      ext4: fix uninitialized variable in ext4_register_li_request

Dan Carpenter (2):
      ext4: test the correct variable in ext4_init_pageio()
      ext4: use IS_ERR() to check for errors in ext4_error_file

Eric Paris (1):
      ext4: ext4_ext_migrate should use NULL not 0

Eric Sandeen (2):
      ext4: zero out nanosecond timestamps for small inodes
      ext4: don't pass entire map to check_eofblocks_fl

Jan Kara (2):
      ext4: fix trimming of a single group
      ext4: fix trimming starting with block 0 with small blocksize

Jesper Juhl (1):
      ext4: use kmem_cache_zalloc() in ext4_init_io_end()

Jiaying Zhang (1):
      ext4: flush the i_completed_io_list during ext4_truncate

Joe Perches (2):
      ext4: Use vzalloc in ext4_fill_flex_info()
      ext4: Use printf extension %pV

Kazuya Mio (1):
      ext4: fix 32bit overflow in ext4_ext_find_goal()

Lukas Czerner (2):
      ext4: fix possible overflow in ext4_trim_fs()
      ext4: remove warning message from ext4_issue_discard helper

Namhyung Kim (1):
      ext4: add more error checks to ext4_mkdir()

Theodore Ts'o (25):
      ext4: Simplify the usage of clear_opt() and set_opt() macros
      ext4: Move struct ext4_mount_options from ext4.h to super.c
      ext4: Add second mount options field since the s_mount_opt is full up
      ext4: Fix up comments in inode.c
      ext4: Use pr_warning_ratelimited() instead of printk_ratelimit()
      jbd2: Use pr_notice_ratelimited() in journal_alloc_journal_head()
      jbd2: Fix a debug message in do_get_write_access()
      jbd2: use offset_in_page() instead of manual calculation
      jbd2: remove unnecessary goto statement
      jbd2: move debug message into debug #ifdef
      jbd2: simplify return path of journal_init_common
      ext4: optimize ext4_check_dir_entry() with unlikely() annotations
      ext4: Add error checking to kmem_cache_alloc() call in ext4_free_blocks()
      ext4: clean up ext4_xattr_list()'s error code checking and return strategy
      ext4: Use ext4_error_file() to print the pathname to the corrupted inode
      ext4: replace i_delalloc_reserved_flag with EXT4_STATE_DELALLOC_RESERVED
      ext4: use ext4_lblk_t instead of sector_t for logical blocks
      ext4: drop ec_type from the ext4_ext_cache structure
      ext4: reorder ext4_inode_info structure elements to remove unneeded padding
      ext4: drop i_state_flags on architectures with 64-bit longs
      ext4: dynamically allocate the jbd2_inode in ext4_inode_info as necessary
      ext4: add error checking to calls to ext4_handle_dirty_metadata()
      ext4: remove ext4_mb_return_to_preallocation()
      ext4: fix memory leak in ext4_free_branches
      ext4: revert buggy trim overflow patch

Tobias Klauser (1):
      ext4: Remove redundant unlikely()

Wang Sheng-Hui (2):
      ext2,ext3,ext4: clarify comment for extN_xattr_set_handle
      ext2: remove dead code in ext2_xattr_get

