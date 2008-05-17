From: Theodore Tso <tytso@mit.edu>
Subject: New ext4 patchset 2.6.26-rc2-git5-ext4-1
Date: Sat, 17 May 2008 13:02:23 -0400
Message-ID: <20080517170223.GC8009@mit.edu>
References: <E1JwMp9-0002pJ-9b@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37796 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752049AbYEQRCY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 13:02:24 -0400
Content-Disposition: inline
In-Reply-To: <E1JwMp9-0002pJ-9b@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's a new ext4 patchset available, here:

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-rc2-git5-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-rc2-git5-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-rc2-git5-ext4-1

This patch set removes the stable patches that have been accepted by
Linus, two unstable patches at the end of the series that caused ext4
to instantly lock up, and a few bug fixes since the last commit.  The
DIO race patches have also been removed, since they are still being
reworked and not quite ready for prime time.

New patches since the last patchset have been marked with a '+'
character.

        	    	      	     	    - Ted

Stable series (to be included in linux-next):

Alexey Dobriyan (1):
      ext4: switch to seq_files

Aneesh Kumar K.V (3):
    + ext4: Fix use of uninitialized data with debug enabled.
    + ext4: Use inode preallocation with -o noextents
      ext4: start seraching for the right extent from the goal group.

Julia Lawall (1):
      ext4: Use BUG_ON() instead of BUG()

Shen Feng (1):
    + ext4: fix error ext number comments

Theodore Ts'o (1):
      jbd2: Add commit time into the commit block


Development series (still needs some work):

Akira Fujita (7):
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Aneesh Kumar K.V (4):
      ext4: Use page_mkwrite vma_operations to get mmap write notification.
      ext4:  Update i_diskzie during writepage for delayed allocation.
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (4):
    + ext4: call blkdev_issue_flush on fsync
      vfs: vfs-level fiemap interface
      ext4: reinstate ext4_ext_walk_space()
      ext4: fiemap implementation

Jose R. Santos (1):
      ext4: New inode allocation for FLEX_BG meta-data groups.

Mingming Cao (4):
      ext4: fix  delalloc write_begin failure case
      ext4: Handling preallocated blocks in delayed allocation
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Theodore Ts'o (1):
    + ext4: Add EXT4_DEFM_BARRIER and EXT4_DEFM_I_VERSION default mount options

Valerie Clement (1):
      ext4: Fix filesystem corruption on FS mounted with delalloc
