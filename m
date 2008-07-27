From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.26-git6-ext4-1 // and 2.6.26-ext4-3
Date: Sat, 26 Jul 2008 21:26:52 -0400
Message-ID: <E1KMv2C-0007fs-1b@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40183 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756018AbYG0B04 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2008 21:26:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've released a new patchset for post-2.6.26-git4 kernels (when Linus
accepted a set of patches for the 2.6.27-rc1 merge window).  A number of
the new patches are cleanups and bug fixes that will be pushed to Linus
shortly; those are marked with an (*).

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-git6-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-git6-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-git6-ext4-1

					----

I've also created a patchset which consists of the new features and bug
fixes pushed to linus, plus the bug fixes and cleanups that are part of
2.6.26-git6-ext4-1 for people who are running the stock 2.6.26 kernel.
This can be found here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-git6-ext4-3

This patchset plus e2fsprogs 1.41.0 should be stable enough for wider
testing.

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
    * ext4: Fix data corruption when writing to prealloc area
    * ext4: Improve error handling in mballoc
    * ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
    * ext4: Don't allow lg prealloc list to be grow large.
    * ext4: Cleanup the block reservation code path
    * ext4: undo the stable boundary patch changes

Eric Sandeen (3):
    * sync up block & inode bitmap reading functions
    * lock block groups when initializing
    * Hook ext4 to the vfs fiemap interface.

Hidehiro Kawai (1):
    * ext4: don't read inode block if the buffer has a write error

Josef Bacik (1):
      Any block based fs (this patch includes ext3) just has to declare its own

Li Zefan (1):
    * ext4: improve ext4_fill_flex_info() a bit

Mingming Cao (1):
    * Ext4: journal credits reservation fixes for DIO, fallocate and delalloc writepages

Theodore Ts'o (9):
    * ext4: Allow read/only mounts with corrupted block group checksums
    * jbd2: don't abort if flushing file data failed
    * ext4: Cleanup whitespace and other miscellaneous style issues
    * ext4: unexport jbd2_journal_update_superblock
      ext4: Stable/Unstable boundary
      This patch should be merged with ext4-online-defrag-alloc-contiguous-blks.patch
      This patch should be merged with ext4-online-defrag-relocate-file-data.patch
      Basic vfs-level fiemap infrastructure, which sets up a new ->fiemap
      Plug ocfs2 into ->fiemap. Some portions of ocfs2_get_clusters() had to be







