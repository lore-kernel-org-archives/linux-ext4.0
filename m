From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset 2.6.26-ext4-1
Date: Sun, 13 Jul 2008 21:52:32 -0400
Message-ID: <E1KIDEu-0004am-Bo@closure.thunk.org>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47727 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753008AbYGNBwe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 21:52:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-1

Patches marked with a (*) will shortly be pushed to Linus during
just-opened merge window.

					- Ted

Akinobu Mita (1):
    * ext4: fix ext4_init_block_bitmap() for metablock block group

Akira Fujita (7):
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Alex Tomas (2):
    * vfs: add hooks for ext4's delayed allocation support
    * ext4: Add delayed allocation support in data=writeback mode

Alexey Dobriyan (1):
    * ext4: switch to seq_files

Aneesh Kumar K.V (13):
    * ext4: Fix mb_find_next_bit not to return larger than max
    * ext4: start searching for the right extent from the goal group.
    * ext4: Update i_disksize properly when allocating from fallocate area.
    * ext4: Fix sparse warning
    * ext4: Use inode preallocation with -o noextents
    * ext4: cleanup block allocator
    * ext4: Use page_mkwrite vma_operations to get mmap write notification.
    * mm: Add range_cont mode for writeback
    * ext4: Add ordered mode support for delalloc
    * ext4: Handle page without buffers in ext4_*_writepage()
    * ext4: Enable delalloc by default.
    * ext4: Don't allow nonextenst mount option for large filesystem
      ext4: undo the stable boundary patch changes

Duane Griffin (3):
    * ext4: handle corrupted orphan list at mount
    * ext4: handle deleting corrupted indirect blocks
    * ext4: validate directory entry data before use

Eric Sandeen (6):
    * ext4: call blkdev_issue_flush on fsync
    * ext4: use atomic functions to set bh_state
    * ext4: do not set extents feature from the kernel
      vfs: vfs-level fiemap interface
      ext4: reinstate ext4_ext_walk_space()
      ext4: fiemap implementation

Frederic Bohe (1):
    * ext4: fix online resize with mballoc

Jan Kara (8):
    * ext4: Set journal pointer to NULL when journal is released
    * vfs: Move mark_inode_dirty() from under page lock in generic_write_end()
    * ext4: Invert the locking order of page_lock and transaction start
    * ext4: Fix lock inversion in ext4_ext_truncate()
    * vfs: export filemap_fdatawrite_range()
    * jbd2: Implement data=ordered mode handling via inodes
    * ext4: Use new framework for data=ordered mode in JBD2
    * jbd2: Remove data=ordered mode support using jbd buffer heads

Jose R. Santos (2):
    * ext4: New inode allocation for FLEX_BG meta-data groups.
    * ext4: Documentation updates.

Julia Lawall (1):
    * ext4: Use BUG_ON() instead of BUG()

Li Zefan (3):
    * ext4: fix build failure if DX_DEBUG is enabled
    * ext4: remove redundant code in ext4_fill_super()
    * ext4: cleanup never-used magic numbers from htree code

Mingming Cao (9):
    * ext4: Fix ext4_mb_init_cache return error
    * jbd2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
    * ext4: mballoc avoid use root reserved blocks for non root allocation
    * percpu_counter: new function percpu_counter_sum_and_set
    * ext4: delayed allocation ENOSPC handling
    * ext4: Invert lock ordering of page_lock and transaction start in delalloc
    * ext4: fix delalloc i_disksize early update issue
    * ext4: delayed allocation i_blocks fix for stat
    * ext4: Documention update for new ordered mode and delayed allocation

Shen Feng (11):
    * ext4: fix comments to say "ext4"
    * ext4: improve some code in rb tree part of dir.c
    * ext4: add error processing when calling ext4_mb_init_cache in mballoc
    * ext4: miscellaneous error checks and coding cleanups for mballoc
    * ext4: remove double definitions of xattr macros
    * ext4: error proc entry creation when the fs/ext4 is not correctly created
    * ext4: fix error processing in mb_free_blocks
    * ext4: remove quota allocation when ext4_mb_new_blocks fails
    * ext4: return error when calling ext4_ext_split failed
    * ext4: Make ext4_ext_find_extent fills ext_path completely
    * ext4: Fix ext4_ext_journal_restart() to reflect errors up to the caller

Stoyan Gaydarov (1):
    * ext4: replace __FUNCTION__ occurrences

Theodore Ts'o (4):
    * ext4: Rename read_block_bitmap() to ext4_read_block_bitmap()
    * ext4: Remove unused variable from ext4_show_options
    * jbd2: Add commit time into the commit block
      ext4: Stable/Unstable boundary

