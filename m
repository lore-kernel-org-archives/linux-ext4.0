From: Theodore Tso <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.26-git6-ext4-2 // and 2.6.26-ext4-4
Date: Sun, 27 Jul 2008 21:21:10 -0400
Message-ID: <20080728012110.GC9378@mit.edu>
References: <E1KMv2C-0007fs-1b@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43230 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbYG1BVP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 21:21:15 -0400
Content-Disposition: inline
In-Reply-To: <E1KMv2C-0007fs-1b@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released a new patchset for post-2.6.26-git4 kernels (when Linus
accepted a set of patches for the 2.6.27-rc1 merge window).  This
removes a problematic patch and adds a documentation patch to remind
people that when installing e2fsprogs 1.41.x, it's important to make
sure to update their /etc/mke2fs.conf file.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-git6-ext4-2
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-git6-ext4-2

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-git6-ext4-2


I've also updated the patch set vs. the 2.6.26-stock kernel, which can
be found here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-4

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

Theodore Ts'o (8):
    * ext4: Allow read/only mounts with corrupted block group checksums
    * jbd2: don't abort if flushing file data failed
    * ext4: Cleanup whitespace and other miscellaneous style issues
    * ext4: unexport jbd2_journal_update_superblock
    * ext4: Update documentation to remind users to update mke2fs.conf
      ext4: Stable/Unstable boundary
      Basic vfs-level fiemap infrastructure, which sets up a new ->fiemap
      Plug ocfs2 into ->fiemap. Some portions of ocfs2_get_clusters() had to be
