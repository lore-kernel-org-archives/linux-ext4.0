From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset 2.6.26-rc4-ext4-1
Date: Thu, 05 Jun 2008 11:53:52 -0400
Message-ID: <E1K4Hmi-0007lG-Vd@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37047 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628AbYFEPxz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 11:53:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-rc4-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-rc4-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-rc4-ext4-1

Bug fixes patches marked with a (*) will be pushed to Linus shortly.

							- Ted

Akira Fujita (7):
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Alexey Dobriyan (1):
      ext4: switch to seq_files

Aneesh Kumar K.V (9):
    * ext4: Fix use of uninitialized data with debug enabled.
    * ext4: start searching for the right extent from the goal group.
      ext4: undo the stable boundary patch changes
      ext4: Use inode preallocation with -o noextents
      ext4: Use page_mkwrite vma_operations to get mmap write notification.
      ext4: Update i_disksize during writepage for delayed allocation.
      ext4: Fix delalloc sync hang with journal lock inversion
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (5):
    * ext4: enable barriers by default
      ext4: call blkdev_issue_flush on fsync
      vfs: vfs-level fiemap interface
      ext4: reinstate ext4_ext_walk_space()
      ext4: fiemap implementation

Jan Kara (8):
      vfs: Move mark_inode_dirty() from under page lock in generic_write_end()
      ext4: Inverse locking order of page_lock and transaction start.
      ext4: Add checks to writepage()
      ext4: Set journal pointer to NULL when journal is released
      vfs: export filemap_fdatawrite_range()
      jbd2: Implement data=ordered mode handling via inodes
      ext4: Use new framework for data=ordered mode in JBD2
      jbd2: Remove data=ordered mode support using jbd buffer heads

Jose R. Santos (1):
      ext4: Fix uninit block group initialization with FLEX_BG

Josef Bacik (1):
    * ext4: fix online resize bug

Julia Lawall (1):
      ext4: Use BUG_ON() instead of BUG()

Li Zefan (1):
      ext4: remove redundant code in ext4_fill_super()

Mingming Cao (9):
      ext4: Fix ext4_mb_init_cache return error
      JBD2: fix race between jbd2_journal_try_to_free_buffers() and jbd2 commit transaction
      ext4: mballoc avoid use root reserved blocks for non root allocation
      ext4: Need clear buffer_delay in block_write_full_page() after allocation
      ext4: fix delalloc write_begin failure case
      ext4: Handling preallocated blocks in delayed allocation
      ext4: Invert lock ordering of page_lock and transaction start in delalloc
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Mingming cao (6):
      ext4: delalloc -- Adding per inode counters to store reserved blocks
      ext4: delalloc --estimate need metadata blocks to reserve
      ext4: delalloc ENOSPC handling core
      ext4: delalloc block reservation avoid double accounting
      ext4: delalloc block reservation unlink/truncate handling
      percpu counter: update center counter when sum per-cpu counter

Shen Feng (6):
      ext4: fix error ext number comments
      ext4: improve some code in rb tree part of dir.c
      ext4: add error processing when calling ext4_mb_init_cache in mballoc
      ext4: error processing and coding enhancement for mballoc
      ext4: remove double definitions of xattr macros
      ext4: remove quota allocation when ext4_mb_new_blocks fails

Theodore Ts'o (6):
    * jbd2: Fix memory leak when verifying checksums in the journal
    * jbd2: If a journal checksum error is detected, propagate the error to ext4
    * ext4: Display the journal_async_commit mount option in /proc/mounts
    * jbd2: Fix barrier fallback code to re-lock the buffer head
      jbd2: Add commit time into the commit block
      ext4: Stable/Unstable boundary

Valerie Clement (1):
      ext4: Fix filesystem corruption on FS mounted with delalloc

\"Jose R. Santos\ (1):
      ext4: New inode allocation for FLEX_BG meta-data groups.

