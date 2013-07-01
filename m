From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.11
Date: Mon, 01 Jul 2013 09:55:55 -0400
Message-ID: <nsxbo6mxu38.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34262 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3GANz5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jul 2013 09:55:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 6ae06ff51eab5dcbbf959b05ce0f11003a305ba5:

  ext4: optimize starting extent in ext4_ext_rm_leaf() (2013-07-01 08:12:41 -0400)

----------------------------------------------------------------
Lots of bug fixes, cleanups and optimizations.  In the bug fixes
category, of note is a fix for on-line resizing file systems where the
block size is smaller than the page size (i.e., file systems 1k blocks
on x86, or more interestingly file systems with 4k blocks on Power or
ia64 systems.)

In the cleanup category, the ext4's punch hole implementation was
significantly improved by Lukas Czerner, and now supports bigalloc
file systems.  In addition, Jan Kara significantly cleaned up the
write submission code path.  We also improved error checking and added
a few sanity checks.

In the optimizations category, two major optimizations deserve
mention.  The first is that ext4_writepages() is now used for
nodelalloc and ext3 compatibility mode.  This allows writes to be
submitted much more efficiently as a single bio request, instead of
being sent as individual 4k writes into the block layer (which then
relied on the elevator code to coalesce the requests in the block
queue).  Secondly, the extent cache shrink mechanism, which was
introduce in 3.9, no longer has a scalability bottleneck caused by the
i_es_lru spinlock.  Other optimizations include some changes to reduce
CPU usage and to avoid issuing empty commits unnecessarily.

----------------------------------------------------------------
Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Alexey Khoroshilov (1):
      ext4: implement error handling of ext4_mb_new_preallocation()

Ashish Sangwan (2):
      ext4: pass inode pointer instead of file pointer to punch hole
      ext4: optimize starting extent in ext4_ext_rm_leaf()

Darrick J. Wong (1):
      jbd2: fix block tag checksum verification brokenness

Dmitry Monakhov (3):
      jbd2: optimize jbd2_journal_force_commit
      ext4: fix data integrity for ext4_sync_fs
      ext4: Fix fsync error handling after filesystem abort

Jan Kara (30):
      ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
      ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures
      ext4: use io_end for multiple bios
      jbd2: don't create journal_head for temporary journal buffers
      jbd2: remove journal_head from descriptor buffers
      jbd2: refine waiting for shadow buffers
      jbd2: remove outdated comment
      jbd2: cleanup needed free block estimates when starting a transaction
      jbd2: fix race in t_outstanding_credits update in jbd2_journal_extend()
      jbd2: remove unused waitqueues
      jbd2: transaction reservation support
      ext4: provide wrappers for transaction reservation calls
      ext4: stop messing with nr_to_write in ext4_da_writepages()
      ext4: deprecate max_writeback_mb_bump sysfs attribute
      ext4: improve writepage credit estimate for files with indirect blocks
      ext4: better estimate credits needed for ext4_da_writepages()
      ext4: restructure writeback path
      ext4: remove buffer_uninit handling
      ext4: use transaction reservation for extent conversion in ext4_end_io
      ext4: split extent conversion lists to reserved & unreserved parts
      ext4: defer clearing of PageWriteback after extent conversion
      ext4: protect extent conversion after DIO with i_dio_count
      ext4: remove wait for unwritten extent conversion from ext4_truncate()
      ext4: use generic_file_fsync() in ext4_file_fsync() in nojournal mode
      ext4: remove i_mutex from ext4_file_sync()
      ext4: Remove wait for unwritten extents in ext4_ind_direct_IO()
      ext4: don't wait for extent conversion in ext4_punch_hole()
      ext4: remove ext4_ioend_wait()

Jie Liu (1):
      ext4: return FIEMAP_EXTENT_UNKNOWN for delalloc extents

Joe Perches (1):
      ext4: reduce object size when !CONFIG_PRINTK

Jon Ernst (1):
      ext4: delete unused variables

Lukas Czerner (20):
      mm: change invalidatepage prototype to accept length
      jbd2: change jbd2_journal_invalidatepage to accept length
      ext4: use ->invalidatepage() length argument
      jbd: change journal_invalidatepage() to accept length
      xfs: use ->invalidatepage() length argument
      ocfs2: use ->invalidatepage() length argument
      ceph: use ->invalidatepage() length argument
      gfs2: use ->invalidatepage() length argument
      reiserfs: use ->invalidatepage() length argument
      mm: teach truncate_inode_pages_range() to handle non page aligned ranges
      Revert "ext4: remove no longer used functions in inode.c"
      ext4: Call ext4_jbd2_file_inode() after zeroing block
      Revert "ext4: fix fsx truncate failure"
      ext4: truncate_inode_pages() in orphan cleanup path
      ext4: use ext4_zero_partial_blocks in punch_hole
      ext4: remove unused discard_partial_page_buffers
      ext4: remove unused code from ext4_remove_blocks()
      ext4: update ext4_ext_remove_space trace point
      ext4: make punch hole code path work with bigalloc
      ext4: only zero partial blocks in ext4_zero_partial_blocks()

Maarten ter Huurne (1):
      ext4: fix corruption when online resizing a fs with 1K block size

Paul Gortmaker (6):
      jbd2: relocate assert after state lock in journal_commit_transaction()
      jbd2: drop checkpoint mutex when waiting in __jbd2_log_wait_for_space()
      jbd2: fix duplicate debug label for phase 2
      jbd/jbd2: relocate bit_spinlock header to jbd_common
      jbd2: use a single printk for jbd_debug()
      jbd2: remove debug dependency on debug_fs and update Kconfig help text

Paul Taysom (1):
      ext4: suppress ext4 orphan messages on mount

Theodore Ts'o (13):
      ext4: add check to io_submit_init_bio
      ext4: verify group number in verify_group_input() before using it
      ext4: add sanity check to ext4_get_group_info()
      ext4: optimize test_root()
      ext4: use ext4_da_writepages() for all modes
      ext4: add cond_resched() to ext4_free_blocks() & ext4_mb_regular_allocator()
      ext4: don't use EXT4_FREE_BLOCKS_FORGET unnecessarily
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      ext4: check error return from ext4_write_inline_data_end()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: fix up error handling for mpage_map_and_submit_extent()
      ext4: translate flag bits to strings in tracepoints
      jbd2: invalidate handle if jbd2_journal_restart() fails

Zheng Liu (2):
      jbd2: use kmem_cache_zalloc for allocating journal head
      ext4: improve extent cache shrink mechanism to avoid to burn CPU time

boxi liu (1):
      ext4: improve free space calculation for inline_data

jon ernst (1):
      ext4: delete unnecessary C statements

 Documentation/filesystems/Locking |    6 +-
 Documentation/filesystems/vfs.txt |   20 +-
 fs/9p/vfs_addr.c                  |    5 +-
 fs/afs/file.c                     |   10 +-
 fs/btrfs/disk-io.c                |    3 +-
 fs/btrfs/extent_io.c              |    2 +-
 fs/btrfs/inode.c                  |    3 +-
 fs/buffer.c                       |   21 +-
 fs/ceph/addr.c                    |   15 +-
 fs/cifs/file.c                    |    5 +-
 fs/exofs/inode.c                  |    6 +-
 fs/ext3/inode.c                   |    9 +-
 fs/ext3/namei.c                   |    7 +-
 fs/ext4/balloc.c                  |   14 +-
 fs/ext4/ext4.h                    |  187 ++++---
 fs/ext4/ext4_jbd2.c               |   58 ++-
 fs/ext4/ext4_jbd2.h               |   29 +-
 fs/ext4/extents.c                 |  193 +++++---
 fs/ext4/extents_status.c          |   75 ++-
 fs/ext4/extents_status.h          |    5 +-
 fs/ext4/file.c                    |   14 +-
 fs/ext4/fsync.c                   |   52 +-
 fs/ext4/ialloc.c                  |    3 +-
 fs/ext4/indirect.c                |   40 +-
 fs/ext4/inline.c                  |    4 +-
 fs/ext4/inode.c                   | 1775 ++++++++++++++++++++++++++++++------------------------------------
 fs/ext4/mballoc.c                 |   21 +-
 fs/ext4/move_extent.c             |    3 -
 fs/ext4/namei.c                   |    7 +-
 fs/ext4/page-io.c                 |  325 ++++++------
 fs/ext4/resize.c                  |   24 +-
 fs/ext4/super.c                   |  155 ++++--
 fs/f2fs/data.c                    |    3 +-
 fs/f2fs/node.c                    |    3 +-
 fs/gfs2/aops.c                    |   17 +-
 fs/jbd/transaction.c              |   19 +-
 fs/jbd2/Kconfig                   |    6 +-
 fs/jbd2/checkpoint.c              |   22 +-
 fs/jbd2/commit.c                  |  184 +++----
 fs/jbd2/journal.c                 |  166 ++++---
 fs/jbd2/recovery.c                |   11 +-
 fs/jbd2/revoke.c                  |   49 +-
 fs/jbd2/transaction.c             |  526 ++++++++++++--------
 fs/jfs/jfs_metapage.c             |    5 +-
 fs/logfs/file.c                   |    3 +-
 fs/logfs/segment.c                |    3 +-
 fs/nfs/file.c                     |    8 +-
 fs/ntfs/aops.c                    |    2 +-
 fs/ocfs2/aops.c                   |    5 +-
 fs/reiserfs/inode.c               |   12 +-
 fs/ubifs/file.c                   |    5 +-
 fs/xfs/xfs_aops.c                 |   14 +-
 fs/xfs/xfs_trace.h                |   15 +-
 include/linux/buffer_head.h       |    3 +-
 include/linux/fs.h                |    2 +-
 include/linux/jbd.h               |   28 +-
 include/linux/jbd2.h              |  175 ++++---
 include/linux/jbd_common.h        |   26 +-
 include/linux/mm.h                |    3 +-
 include/trace/events/ext3.h       |   12 +-
 include/trace/events/ext4.h       |  304 ++++++++----
 mm/readahead.c                    |    2 +-
 mm/truncate.c                     |  117 +++--
 63 files changed, 2664 insertions(+), 2182 deletions(-)
