From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.27-rc1-ext4-1 and 2.6.26-ext4-5
Date: Sat, 02 Aug 2008 21:42:15 -0400
Message-ID: <E1KPSbv-0001ou-CM@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54453 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbYHCBmR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 21:42:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've released a new ext4 patchset against the 2.6.27-rc1 kernel.  This
includes a number of bug fixes reported by benchmarkers plus some
cleanups.

As before I've also released updated the patch set vs. 2.6.26 stock
kernel, for those people who don't want to play with development kernels
but who still want to test out ext4.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.27-rc1-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.27-rc1-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-rc1-ext4-1

The patch vs. 2.6.26:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-5

						- Ted

Akira Fujita (7):
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Aneesh Kumar K.V (6):
      ext4: Fix data corruption when writing to prealloc area
      ext4: Improve error handling in mballoc
      ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
      ext4: Don't allow lg prealloc list to be grow large.
      ext4: Cleanup the block reservation code path
      ext4: undo the stable boundary patch changes

Eric Sandeen (5):
      ext4: sync up block and inode bitmap reading functions
      ext4: lock block groups when initializing
      ext4: fix ext4_da_write_begin error path
      ext4: remove write-only variables from ext4_ordered_write_end
      Hook ext4 to the vfs fiemap interface.

Hidehiro Kawai (2):
      ext4: don't read inode block if the buffer has a write error
      jbd2: don't abort if flushing file data failed

Josef Bacik (1):
      Any block based fs (this patch includes ext3) just has to declare its own

Li Zefan (1):
      ext4: improve ext4_fill_flex_info() a bit

Mingming Cao (1):
      Ext4: journal credits reservation fixes

Theodore Ts'o (12):
      ext4: Allow read/only mounts with corrupted block group checksums
      ext4: Fix ext4_ext_journal_restart()
      ext4: Fix lack of credits BUG() when deleting a badly fragmented inode
      ext4: don't assume extents can't cross block groups when truncating
      ext4: Cleanup whitespace and other miscellaneous style issues
      ext4: unexport jbd2_journal_update_superblock
      ext4: Stable/Unstable boundary
      This patch should be merged with ext4-online-defrag-alloc-contiguous-blks.patch
      This patch should be merged with ext4-online-defrag-relocate-file-data.patch
      Basic vfs-level fiemap infrastructure, which sets up a new ->fiemap
      Plug ocfs2 into ->fiemap. Some portions of ocfs2_get_clusters() had to be
      patch ext4_fix_printk_checkpatch_issues



