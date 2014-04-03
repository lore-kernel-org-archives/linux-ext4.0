From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 3.15
Date: Thu, 3 Apr 2014 15:15:58 -0400
Message-ID: <20140403191558.GA8745@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49658 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbaDCTQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2014 15:16:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note: there will be a minor patch conflict since you included an
earlier version of the"atomically set inode->i_flags in
ext4_set_inode_flags()" in 3.14 bbefore you decided that
set_mask_bits() wasn't a good interface to be exposing because people
could too easily misuse it.  The merge conflict is pretty obvious.

Let me know if you want me to send a separate cleanup patch which
removes set_mask_bits(), or whether you just want to drop it from
include/linux/bitops.h while fixing up the merge conflict.

Cheers,

						- Ted

The following changes since commit 92e3b40537707001d17bbad800d150ab04e53bf4:

  jbd2: fix use after free in jbd2_journal_start_reserved() (2014-02-17 20:33:01 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to ad6599ab3ac98a4474544086e048ce86ec15a4d1:

  ext4: fix premature freeing of partial clusters split across leaf blocks (2014-04-01 19:49:30 -0400)

----------------------------------------------------------------
Major changes for 3.14 include support for the newly added ZERO_RANGE
and COLLAPSE_RANGE fallocate operations, and scalability improvements
in the jbd2 layer and in xattr handling when the extended attributes
spill over into an external block.

Other than that, the usual clean ups and minor bug fixes.

----------------------------------------------------------------
Dan Carpenter (1):
      ext4: remove an unneeded check in mext_page_mkuptodate()

Darrick J. Wong (1):
      ext4: merge uninitialized extents

Eric Sandeen (1):
      ext4: remove unused ac_ex_scanned

Eric Whitney (5):
      ext4: fix error return from ext4_ext_handle_uninitialized_extents()
      ext4: silence warnings in extent status tree debugging code
      ext4: delete path dealloc code in ext4_ext_handle_uninitialized_extents
      ext4: fix partial cluster handling for bigalloc file systems
      ext4: fix premature freeing of partial clusters split across leaf blocks

Fabian Frederick (1):
      ext4: Add __init marking to init_inodecache

Jan Kara (1):
      ext4: Speedup WB_SYNC_ALL pass called from sync(2)

Lukas Czerner (5):
      ext4: translate fallocate mode bits to strings
      ext4: Update inode i_size after the preallocation
      ext4: refactor ext4_fallocate code
      ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
      ext4: remove unneeded test of ret variable

Matthew Wilcox (2):
      ext4: make ext4_block_zero_page_range static
      ext4: fix comment typo

Maxim Patlasov (1):
      ext4: avoid exposure of stale data in ext4_punch_hole()

Namjae Jeon (1):
      ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

Patrick Palka (1):
      ext4: address a benign compiler warning

Rashika Kheria (1):
      jbd2: mark file-local functions as static

T Makphaibulchoke (3):
      fs/mbcache.c: change block and index hash chain to hlist_bl_node
      fs/mbcache.c: doucple the locking of local from global data
      ext4: each filesystem creates and uses its own mb_cache

Theodore Ts'o (18):
      ext4: clean up error handling in swap_inode_boot_loader()
      ext4: add ext4_es_store_pblock_status()
      ext4: don't calculate total xattr header size unless needed
      ext4: make sure ex.fe_logical is initialized
      ext4: avoid possible overflow in ext4_map_blocks()
      jbd2: don't unplug after writing revoke records
      jbd2: don't hold j_state_lock while calling wake_up()
      jbd2: calculate statistics without holding j_state_lock and j_list_lock
      jbd2: add transaction to checkpoint list earlier
      jbd2: check jh->b_transaction without taking j_list_lock
      jbd2: minimize region locked by j_list_lock in journal_get_create_access()
      jbd2: minimize region locked by j_list_lock in jbd2_journal_forget()
      jbd2: improve error messages for inconsistent journal heads
      fs: push sync_filesystem() down to the file system's remount_fs()
      ext4: only call sync_filesystm() when remounting read-only
      ext4: kill i_version support for Hurd-castrated file systems
      ext4: optimize Hurd tests when reading/writing inodes
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

 fs/adfs/super.c             |   1 +
 fs/affs/super.c             |   1 +
 fs/befs/linuxvfs.c          |   1 +
 fs/btrfs/super.c            |   1 +
 fs/cifs/cifsfs.c            |   1 +
 fs/coda/inode.c             |   1 +
 fs/cramfs/inode.c           |   1 +
 fs/debugfs/inode.c          |   1 +
 fs/devpts/inode.c           |   1 +
 fs/efs/super.c              |   1 +
 fs/ext2/super.c             |   1 +
 fs/ext3/super.c             |   2 +
 fs/ext4/ext4.h              |  11 +-
 fs/ext4/ext4_jbd2.c         |  10 +
 fs/ext4/extents.c           | 818 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/extents_status.c    |  28 +-
 fs/ext4/extents_status.h    |   9 +
 fs/ext4/inode.c             | 130 ++++++----
 fs/ext4/ioctl.c             |  24 +-
 fs/ext4/mballoc.c           |   7 +-
 fs/ext4/mballoc.h           |   4 +-
 fs/ext4/move_extent.c       |   5 +-
 fs/ext4/super.c             |  40 ++-
 fs/ext4/xattr.c             |  59 +++--
 fs/ext4/xattr.h             |   6 +-
 fs/f2fs/super.c             |   2 +
 fs/fat/inode.c              |   2 +
 fs/freevxfs/vxfs_super.c    |   1 +
 fs/fuse/inode.c             |   1 +
 fs/gfs2/super.c             |   2 +
 fs/hfs/super.c              |   1 +
 fs/hfsplus/super.c          |   1 +
 fs/hpfs/super.c             |   2 +
 fs/inode.c                  |  31 +++
 fs/isofs/inode.c            |   1 +
 fs/jbd2/commit.c            |  77 +++---
 fs/jbd2/journal.c           |  10 +-
 fs/jbd2/transaction.c       |  46 ++--
 fs/jffs2/super.c            |   1 +
 fs/jfs/super.c              |   1 +
 fs/mbcache.c                | 540 +++++++++++++++++++++++++++-----------
 fs/minix/inode.c            |   1 +
 fs/ncpfs/inode.c            |   1 +
 fs/nfs/super.c              |   2 +
 fs/nilfs2/super.c           |   1 +
 fs/ntfs/super.c             |   2 +
 fs/ocfs2/super.c            |   2 +
 fs/openpromfs/inode.c       |   1 +
 fs/proc/root.c              |   2 +
 fs/pstore/inode.c           |   1 +
 fs/qnx4/inode.c             |   1 +
 fs/qnx6/inode.c             |   1 +
 fs/reiserfs/super.c         |   1 +
 fs/romfs/super.c            |   1 +
 fs/squashfs/super.c         |   1 +
 fs/super.c                  |   2 -
 fs/sysv/inode.c             |   1 +
 fs/ubifs/super.c            |   1 +
 fs/udf/super.c              |   1 +
 fs/ufs/super.c              |   1 +
 fs/xfs/xfs_super.c          |   1 +
 include/linux/fs.h          |   3 +
 include/linux/mbcache.h     |  12 +-
 include/trace/events/ext4.h | 102 +++++---
 64 files changed, 1520 insertions(+), 505 deletions(-)
