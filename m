From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.39-rc1
Date: Thu, 24 Mar 2011 22:32:31 -0400
Message-ID: <E1Q2wpD-0002It-CE@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33206 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934385Ab1CYCcf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Mar 2011 22:32:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the ext4 updates for the 2.6.39 merge window.

Thanks,

					- Ted

Alexander V. Lukyanov (1):
      ext4: allow inode_readahead_blks=0 (linux-2.6.37)

Amir Goldstein (7):
      ext4: use the nblocks arg to ext4_truncate_restart_trans()
      ext4: skip orphan cleanup if fs has unknown ROCOMPAT features
      jbd2: add the b_cow_tid field to journal_head struct
      jbd2: add COW fields to struct jbd2_journal_handle
      ext4: handle errors in ext4_rename
      ext4: unify the ext4_handle_release_buffer() api
      ext4: handle errors in ext4_clear_blocks()

Coly Li (5):
      ext4: code cleanup in mb_find_buddy()
      ext4: remove unncessary call mb_find_buddy() in debugging code
      mballoc: add comments to ext4_mb_mark_free_simple()
      ext4: clarify description of ac_g_ex in struct ext4_allocation_context
      ext4: mballoc: don't replace the current preallocation group unnecessarily

Curt Wohlgemuth (2):
      ext4: mark multi-page IO complete on mapping failure
      ext4: fix ext4_da_block_invalidatepages() to handle page range properly

Eric Sandeen (2):
      ext4: enable acls and user_xattr by default
      ext4: don't kfree uninitialized s_group_info members

Feng Tang (1):
      ext4: remove redundant set_buffer_mapped() in ext4_da_get_block_prep()

Jiaying Zhang (1):
      ext4: add more tracepoints and use dev_t in the trace buffer

Lukas Czerner (4):
      ext4: update ext4 documentation
      ext4: mark file-local functions and variables as static
      ext4: check if device support discard in FITRIM ioctl
      ext4: Adjust minlen with discard_granularity in the FITRIM ioctl

Manish Katiyar (1):
      ext4: fix missing iput of root inode for some mount error paths

Mingming Cao (1):
      ext4: Use single thread to perform DIO unwritten convertion

Peter Huewe (1):
      ext4: Fix sparse warning: Using plain integer as NULL pointer

Robin Dong (1):
      ext4: add missing space in printk's in __ext4_grp_locked_error()

Sergey Senozhatsky (1):
      ext4: unused variables cleanup in fs/ext4/extents.c

Tao Ma (2):
      ext4: add FITRIM to compat_ioctl.
      ext4: fix a BUG in mb_mark_used during trim.

Theodore Ts'o (12):
      ext4: fix compile warnings with EXT4FS_DEBUG enabled
      ext4: enable mblk_io_submit by default
      ext4: fold __mpage_da_writepage() into write_cache_pages_da()
      ext4: simple cleanups to write_cache_pages_da()
      ext4: clear the dirty bit for a page in writeback at the last minute
      ext4: remove page_skipped hackery in ext4_da_writepages()
      ext4: don't lock the next page in write_cache_pages if not needed
      ext4: move setup of the mpd structure to write_cache_pages_da()
      ext4: don't leave PageWriteback set after memory failure
      ext4: suppress verbose debugging information if malloc-debug is off
      ext4: optimize ext4_bio_write_page() when no extent conversion is needed
      ext4: Initialize fsync transaction ids in ext4_new_inode()

Yongqiang Yang (1):
      ext4: make FIEMAP and delayed allocation play well together


 Documentation/ABI/testing/sysfs-fs-ext4 |   13 +-
 Documentation/filesystems/ext4.txt      |  207 ++++++++-
 fs/ext4/balloc.c                        |    3 +
 fs/ext4/ext4_jbd2.h                     |    7 -
 fs/ext4/extents.c                       |  213 +++++++--
 fs/ext4/fsync.c                         |   14 +-
 fs/ext4/ialloc.c                        |    8 +-
 fs/ext4/inode.c                         |  410 +++++++----------
 fs/ext4/ioctl.c                         |    7 +
 fs/ext4/mballoc.c                       |   34 +-
 fs/ext4/mballoc.h                       |    2 +-
 fs/ext4/migrate.c                       |   10 +-
 fs/ext4/namei.c                         |   13 +-
 fs/ext4/page-io.c                       |   13 +-
 fs/ext4/resize.c                        |   12 +-
 fs/ext4/super.c                         |   48 ++-
 fs/ext4/xattr.c                         |    4 +-
 include/linux/jbd2.h                    |   28 +-
 include/linux/journal-head.h            |    7 +
 include/trace/events/ext4.h             |  775 +++++++++++++++++++++++--------
 include/trace/events/jbd2.h             |   78 ++--
 21 files changed, 1307 insertions(+), 599 deletions(-)
