From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.27-rc3-ext4-1 and 2.6.26-ext4-7
Date: Wed, 20 Aug 2008 01:31:56 -0400
Message-ID: <E1KVgIW-0002ZM-Tm@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39309 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750766AbYHTFb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 01:31:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've released a new ext4 patchset against the 2.6.27-rc3 kernel.  This
has more bug fixes that have been reported by benchmarkers and early
users of ext4.

As before I've also released updated the patch set vs. the 2.6.26 stock
kernel, for those people who don't want to play with development kernels
but who still want to test out ext4.  The 2.6.26-ext4-7 patchset
contains only the stable patches of ext4.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.27-rc3-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.27-rc3-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-rc3-ext4-1

The patch vs. 2.6.26:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-7

                                                - Ted

Patches marked with '*' are in the stable queue and will be pushed to
Linus shortly.

Akira Fujita (7):
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Aneesh Kumar K.V (7):
    * ext4: Handle unwritten extent properly with delayed allocation
    * ext4: Rework the ext4_da_writepages() function
    * ext4: make sure ext4_has_free_blocks returns 0 for ENOSPC
    * ext4: Initialize writeback_index to 0 when allocating a new inode
    * ext4: Fix small file fragmentation
      ext4: undo the stable boundary patch changes
      ext4: invalidate pages if delalloc block allocation fails.

Eric Sandeen (3):
    * ext4: Fix bug where we return ENOSPC even though we have plenty of inodes
      ext4: use percpu data structures for lg_prealloc_list
      Hook ext4 to the vfs fiemap interface.

Josef Bacik (2):
    * ext4: don't try to resize if there are no reserved gdt blocks left
      Any block based fs (this patch includes ext3) just has to declare its own

Mingming Cao (5):
    * ext4: Fix delalloc release block reservation for truncate
    * ext4: journal credits calulation cleanup and fix for non-extent writepage
    * ext4: journal credits reservation fixes for extent file writepage
    * ext4: journal credits reservation fixes for DIO, fallocate
    * ext4: journal credit fix for the delayed allocation's writepages() function

Theodore Ts'o (9):
    * ext4: Fix potential truncate BUG due to i_prealloc_list being non-empty
    * ext4: Fix ext4_dx_readdir hash collision handling
    * ext4: Use ext4_discard_reservations instead of mballoc-specific call
    * ext4: Update documentation to remind users to update mke2fs.conf
      ext4: Stable/Unstable boundary
      This patch should be merged with ext4-online-defrag-alloc-contiguous-blks.patch
      Basic vfs-level fiemap infrastructure, which sets up a new ->fiemap
      Plug ocfs2 into ->fiemap. Some portions of ocfs2_get_clusters() had to be
      patch ext4_fix_printk_checkpatch_issues

