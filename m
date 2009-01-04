From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.28-ext4-1
Date: Sun, 04 Jan 2009 00:06:28 -0500
Message-ID: <E1LJLC0-0004k9-Rf@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39322 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZADFGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2009 00:06:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This new patchset is a draft set of patches which I plan to push to
Linus for the 2.6.29 merge window.

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.28-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.28-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.28-ext4-1

                                                        - Ted

(*) Patches that will *NOT* be pushed to Linus

Alexander Beregalov (1):
      ext4: fix printk format warning

Aneesh Kumar K.V (21):
      ext4: Fix the delalloc writepages to allocate blocks at the right offset.
      ext4: avoid ext4_error when mounting a fs with a single bg
      ext4: Don't overwrite allocation_context ac_status
      ext4: sparse fixes
      ext4: Add blocks added during resize to bitmap
      ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize
      ext4: cleanup mballoc header files
      jbd2: Call journal commit callback without holding j_list_lock
      ext4: don't use blocks freed but not yet committed in buddy cache init
      ext4: Fix lockdep recursive locking warning
      ext4: fix BUG when calling ext4_error with locked block group
      ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
      ext4: Use high 16 bits of the block group descriptor's free counts fields
      ext4: code cleanup
      ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()
      ext4: Use new buffer_head flag to check uninit group bitmaps initialization
      ext4: mark the blocks/inode bitmap beyond end of group as used
      ext4: Don't allow new groups to be added during block allocation
      ext4: Init the complete page while building buddy cache
      ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc
  (*) ext4: undo the stable boundary patch changes

David Howells (1):
      CRED: Wrap task credential accesses in the Ext4 filesystem

Frank Mayhar (1):
      ext4: Allow ext4 to run without a journal

Josef Bacik (1):
      jbd2: improve jbd2 fsync batching

Mark Fasheh (1):
      jbd2: Add BH_JBDPrivateStart

Roel Kluin (1):
      ext4: Use simple_strtol() instead of simple_strtoul() in ext4_ui_proc_open

Solofo.Ramangalahy@bull.net (1):
      ext4: When resizing set the EXT4_BG_INODE_ZEROED flag for new block groups

Theodore Ts'o (24):
      ext3: Add support for non-native signed/unsigned htree hash algorithms
      ext4: Add support for non-native signed/unsigned htree hash algorithms
      ext3/4: Fix loop index in do_split() so it is signed
      Update Documentation/filesystems/ext4.txt
      ext4: remove ext4_new_blocks() and call ext4_mb_new_blocks() directly
      ext4: remove ext4_new_meta_block()
      ext4: remove do_blk_alloc()
      ext4: tone down ext4_da_writepages warnings
      jbd2: Add barrier not supported test to journal_wait_on_commit_record
      ext4: remove extraneous newline from the "no extents" warning message
      ext4: display average commit time
      ext4: add fsync batch tuning knobs
      ext4: Remove i_ext_generation from ext4_inode_info structure
      ext4: Make ext4_group_t be an unsigned int
      ext4: Change unsigned long to unsigned int
      jbd2: Remove a large array of bh's from the stack of the checkpoint routine
      add releasepage hooks to block devices which can be used by file systems
      ext4: Remove code to create the journal inode
      ext4: Add markers for better debuggability
      jbd2: Add pid and journal device name to the "kjournald2 starting" message
  (*) ext4: Stable/Unstable boundary
  (*) Add a ioctl which dumps out all of the in-use buffer heads for a block device
  (*) ext4: Add a delayed allocation debugging ioctl
  (*) ext4: akpm's locking hack to fix locking delays

Toshiyuki Okajima (2):
      ext3: provide function to release metadata pages under memory pressure
      ext4: provide function to release metadata pages under memory pressure

Wu Fengguang (1):
      ext4: fix build warning

Yasunori Goto (1):
      ext4: Widen type of ext4_sb_info.s_mb_maxs[]

 Documentation/filesystems/ext4.txt |   56 +++-
 block/compat_ioctl.c               |    1 +
 block/ioctl.c                      |    7 +
 fs/block_dev.c                     |   15 +
 fs/buffer.c                        |   40 +++
 fs/ext3/hash.c                     |   77 ++++-
 fs/ext3/namei.c                    |   11 +-
 fs/ext3/super.c                    |   32 ++
 fs/ext4/balloc.c                   |  295 ++++++------------
 fs/ext4/bitmap.c                   |    5 +-
 fs/ext4/dir.c                      |    8 +-
 fs/ext4/ext4.h                     |  154 +++++++--
 fs/ext4/ext4_extents.h             |    5 -
 fs/ext4/ext4_i.h                   |   16 +-
 fs/ext4/ext4_jbd2.c                |   83 ++++--
 fs/ext4/ext4_jbd2.h                |   83 ++++-
 fs/ext4/ext4_sb.h                  |    6 +-
 fs/ext4/extents.c                  |   56 ++--
 fs/ext4/file.c                     |    3 -
 fs/ext4/hash.c                     |   77 ++++-
 fs/ext4/ialloc.c                   |  326 +++++++++++--------
 fs/ext4/inode.c                    |  309 +++++++++++++-----
 fs/ext4/ioctl.c                    |   53 +++-
 fs/ext4/mballoc.c                  |  625 ++++++++++++++++++++++++++----------
 fs/ext4/mballoc.h                  |   71 +----
 fs/ext4/migrate.c                  |    5 +-
 fs/ext4/namei.c                    |   86 +++---
 fs/ext4/resize.c                   |  106 ++-----
 fs/ext4/super.c                    |  485 +++++++++++++++++++---------
 fs/ext4/xattr.c                    |   25 +-
 fs/jbd2/checkpoint.c               |   24 +-
 fs/jbd2/commit.c                   |   54 +++-
 fs/jbd2/journal.c                  |   84 +-----
 fs/jbd2/transaction.c              |   72 ++++-
 fs/super.c                         |    2 +
 include/linux/buffer_head.h        |    1 +
 include/linux/ext3_fs.h            |   28 ++-
 include/linux/ext3_fs_sb.h         |    1 +
 include/linux/fs.h                 |    4 +
 include/linux/jbd2.h               |   40 +++-
 40 files changed, 2247 insertions(+), 1184 deletions(-)
