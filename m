From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.28-ext4-2
Date: Tue, 06 Jan 2009 01:35:06 -0500
Message-ID: <E1LK5Ws-00076Z-7D@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56219 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbZAFGfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 01:35:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is an update of the draft set of patches which I hope to be able to
push to Linus shortly, after a tad bit more testing.

These patches fix a few cosmetic issues, add stable@kernel.org markings
for patches that should be attached to the stable tree, and fix a few
bugs in the "allow-ext4-to-run-without-a-journal" patch as well as fix a
potential deadlock in the blkdev-releasepage patches.

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.28-ext4-2
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.28-ext
4-2

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.28-ext4-2

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

Theodore Ts'o (28):
      ext3: Add support for non-native signed/unsigned htree hash algorithms
      ext4: Add support for non-native signed/unsigned htree hash algorithms
      ext3/4: Fix loop index in do_split() so it is signed
      Update Documentation/filesystems/ext4.txt
      ext4: remove ext4_new_blocks() and call ext4_mb_new_blocks() directly
      ext4: remove ext4_new_meta_block()
      ext4: remove do_blk_alloc()
      ext4: tone down ext4_da_writepages warnings
      jbd2: Add barrier not supported test to journal_wait_on_commit_record
      ext4: remove extraneous newlines from calls to ext4_error() and ext4_warning()
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
      jbd2: Submit writes to the journal using WRITE_SYNC
      ext4: Add mount option to set kjournald's I/O priority
      ext4: Add sanity checks for the superblock before mounting the filesystem
      ext4: Make printk's consistently prefixed with "EXT4-fs: "
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

