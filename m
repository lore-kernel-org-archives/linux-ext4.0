From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.2
Date: Wed, 02 Nov 2011 11:10:28 -0400
Message-ID: <E1RLcSS-0004UQ-C8@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47990 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1KBPKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 11:10:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

The starting commit is the last pull request I sent you (against
v3.1-rc3); this was due to the fact that I had audited the build
infrastructure of v3.1-rc3 after the kernel.org compromise was
discovered, and I didn't want to hold up the ext4 tree waiting for the
post-3.1-rc3 commits in your tree to be reviewed.

There is a signed tag tytso-for-linus-20111102 covering this pull
request.

						- Ted

The following changes since commit 8c0bec2151a47906bf779c6715a10ce04453ab77:

  ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining (2011-08-31 11:50:51 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Aditya Kali (3):
      ext4: Fix bigalloc quota accounting and i_blocks value
      ext4: add some tracepoints in ext4/extents.c
      ext4: attempt to fix race in bigalloc code path

Akira Fujita (1):
      ext4: fix deadlock in ext4_ordered_write_end()

Allison Henderson (5):
      ext4: Add new ext4_discard_partial_page_buffers routines
      ext4: fix xfstests 75, 112, 127 punch hole failure
      ext4: fix 2nd xfstests 127 punch hole failure
      ext4: fix fsx truncate failure
      ext4: fix partial page writes

Andreas Dilger (1):
      ext4: avoid setting directory i_nlink to zero

Curt Wohlgemuth (1):
      ext4: handle NULL p_ext in ext4_ext_next_allocated_block()

Dan Carpenter (2):
      jbd2: use gfp_t instead of int
      ext4: error handling fix in ext4_ext_convert_to_initialized()

Darrick J. Wong (4):
      ext4: ext4_rename should dirty dir_bh with the correct directory
      ext4: ext4_mkdir should dirty dir_block with newly created directory inode
      ext4: Fix comparison endianness problem in MMP initialization
      ext4: prevent stack overrun in ext4_file_open

Dmitry Monakhov (6):
      ext4: Allow quota file use root reservation
      ext4: cleanup ext4_ext_grow_indepth code
      ext4: remove messy logic from ext4_ext_rm_leaf
      ext4: update EOFBLOCKS flag on fallocate properly
      ext4: migrate cleanup
      ext4: fix quota accounting during migration

Eric Gouriou (2):
      ext4: optimize ext4_ext_convert_to_initialized()
      ext4: optimize memmmove lengths in extent/index insertions

Eric Sandeen (2):
      ext4: use ext4_reserve_inode_write in ext4_xattr_set_handle
      ext4: fix race in xattr block allocation path

Eryu Guan (3):
      ext4: remove comments about extent mount option in ext4_new_inode()
      jbd/jbd2: validate sb->s_first in journal_get_superblock()
      jbd2: Unify log messages in jbd2 code

Fabrice Jouhaud (1):
      ext4: fix ext4 so it works without CONFIG_PROC_FS

Greg Harm (1):
      ext4: Don't normalize an falloc request if it can fit in 1 extent.

H Hartley Sweeten (3):
      ext4: functions should not be declared extern
      ext4: add __user decoration to calls of copy_{from,to}_user()
      ext4: quiet sparse noise about plain integer as NULL pointer

Kazuya Mio (1):
      ext4: fix the deadlock in mpage_da_map_and_submit()

Lukas Czerner (1):
      ext4: remove deprecated oldalloc

Nikitas Angelinas (2):
      ext4: MMP: kmmpd should use nodename from init_uts_ns.name, not sysname
      ext4: MMP: fix error message rate-limiting logic in kmmpd

Randy Dunlap (1):
      jbd2: fix build when CONFIG_BUG is not enabled

Robin Dong (5):
      ext4: use stream-alloc when mb_group_prealloc set to zero
      ext4: remove unused variable in ext4_mb_generate_from_pa()
      ext4: remove unused variable in mb_find_extent()
      ext4: fix a wrong comment in __mb_check_buddy()
      ext4: fix a typo in struct ext4_allocation_context

Shaohua Li (1):
      ext4: add block plug for .writepages

Tao Ma (9):
      ext4: Free resources in ext4_mb_init()'s error paths
      ext4: Free resources in some error path in ext4_fill_super
      ext4: fix the comment describing ext4_ext_search_right()
      ext4: remove the obsolete/broken EXT4_IOC_WAIT_FOR_READONLY ioctl
      ext4: use le32_to_cpu for ext4_extent_idx.ei_block in ext4_ext_search_left()
      ext4: avoid stamping on other memories in ext4_ext_insert_index()
      ext4: don't check io->flag when setting EXT4_STATE_DIO_UNWRITTEN inode state
      ext4: Use correct locking for ext4_end_io_nolock()
      ext4: Create helper function for EXT4_IO_END_UNWRITTEN and i_aiodio_unwritten

Theodore Ts'o (32):
      ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes
      ext4: fake direct I/O mode for data=journal
      ext4: call ext4_handle_dirty_metadata with correct inode in ext4_dx_add_entry
      ext4: improve handling of conflicting mount options
      jbd2: add debugging information to jbd2_journal_dirty_metadata()
      ext4: only call ext4_jbd2_file_inode when an inode has been extended
      ext4: add ext4-specific kludge to avoid an oops after the disk disappears
      ext4: read-only support for bigalloc file systems
      ext4: enforce bigalloc restrictions (e.g., no online resizing, etc.)
      ext4: convert instances of EXT4_BLOCKS_PER_GROUP to EXT4_CLUSTERS_PER_GROUP
      ext4: factor out block group accounting into functions
      ext4: split out ext4_free_blocks_after_init()
      ext4: bigalloc changes to block bitmap initialization functions
      ext4: convert block group-relative offsets to use clusters
      ext4: teach mballoc preallocation code about bigalloc clusters
      ext4: teach ext4_free_blocks() about bigalloc and clusters
      ext4: teach ext4_ext_map_blocks() about the bigalloc feature
      ext4: teach ext4_ext_truncate() about the bigalloc feature
      ext4: convert s_{dirty,free}blocks_counter to s_{dirty,free}clusters_counter
      ext4: convert the free_blocks field in s_flex_groups to be free_clusters
      ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
      ext4: tune mballoc's default group prealloc size for bigalloc file systems
      ext4: enable mounting bigalloc as read/write
      ext4: Rename ext4_free_blks_{count,set}() to refer to clusters
      ext4: rename ext4_count_free_blocks() to ext4_count_free_clusters()
      ext4: rename ext4_free_blocks_after_init() to ext4_free_clusters_after_init()
      ext4: rename ext4_claim_free_blocks() to ext4_claim_free_clusters()
      ext4: rename ext4_has_free_blocks() to ext4_has_free_clusters()
      ext4: documentation: remove acl and user_xattr mount options
      fs: optimize out 16 bytes worth of padding in struct inode
      ext4: remove unnecessary call to waitqueue_active()
      ext4: optimize locking for end_io extent conversion

Thomas Gleixner (1):
      jdb/jbd2: factor out common functions from the jbd[2] header files

Yongqiang Yang (9):
      ext4: let ext4_page_mkwrite stop started handle in failure
      ext4: move variables to their scope
      ext4: clean up AGGRESSIVE_TEST code
      ext4: trace punch_hole correctly in ext4_ext_map_blocks
      ext4: move vars to local scope in ext4_discard_partial_page_buffers_no_lock()
      ext4: return ENOMEM if find_or_create_pages fails
      ext4: let ext4_discard_partial_buffers handle unaligned range correctly
      ext4: fix a syntax error in ext4_ext_insert_extent when debugging enabled
      ext4: let ext4_ext_rm_leaf work with EXT_DEBUG defined

 Documentation/filesystems/ext4.txt |   41 +-
 fs/ext4/balloc.c                   |  345 +++++++-----
 fs/ext4/ext4.h                     |  141 ++++--
 fs/ext4/ext4_extents.h             |    2 +
 fs/ext4/ext4_jbd2.c                |    8 +-
 fs/ext4/extents.c                  | 1168 +++++++++++++++++++++++++++---------
 fs/ext4/file.c                     |    4 +-
 fs/ext4/fsync.c                    |   10 +-
 fs/ext4/ialloc.c                   |  204 +------
 fs/ext4/indirect.c                 |   20 +-
 fs/ext4/inode.c                    |  512 ++++++++++++++---
 fs/ext4/ioctl.c                    |   65 +-
 fs/ext4/mballoc.c                  |  331 +++++++----
 fs/ext4/mballoc.h                  |   11 +-
 fs/ext4/migrate.c                  |  109 ++---
 fs/ext4/mmp.c                      |   10 +-
 fs/ext4/move_extent.c              |    1 -
 fs/ext4/namei.c                    |   21 +-
 fs/ext4/page-io.c                  |   66 +--
 fs/ext4/resize.c                   |   10 +-
 fs/ext4/super.c                    |  263 ++++++---
 fs/ext4/xattr.c                    |   12 +-
 fs/jbd/journal.c                   |    8 +
 fs/jbd2/commit.c                   |   26 +-
 fs/jbd2/journal.c                  |   44 +-
 fs/jbd2/recovery.c                 |   28 +-
 fs/jbd2/transaction.c              |   68 ++-
 include/linux/ext2_fs.h            |    4 +-
 include/linux/ext3_fs.h            |    4 +-
 include/linux/fs.h                 |   10 +-
 include/linux/jbd.h                |   64 +--
 include/linux/jbd2.h               |   69 +--
 include/linux/jbd_common.h         |   68 +++
 include/trace/events/ext4.h        |  480 +++++++++++++++-
 34 files changed, 2898 insertions(+), 1329 deletions(-)
 create mode 100644 include/linux/jbd_common.h
