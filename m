From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 1 Apr 2008 20:09:56 -0400
Message-ID: <20080402000956.GC302@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41075 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757079AbYDBAJ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 20:09:58 -0400
Content-Disposition: inline
In-Reply-To: <20080229154333.GC8968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* js/flex-bg (Mon Mar 31 22:13:11 2008 -0500) 1 commit
 - mke2fs: New bitmap and inode table allocation for FLEX_BG

	Updated with Jose's latest patch.

* tt/mkfs-types (Tue Feb 19 08:32:58 2008 -0500) 1 commit
 - New mke2fs types parsing --- IN PROGRESS

	I'm taking this back, will work on this soon.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	Unchanged since last iteration.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

	Unchanged since last iteration; previously remarked defects:

        The test cases are missing an expected file

        Also, we need to chage "mke2fs use undo I/O manager" so it
        only does it if the uninit group patch is enabled.  So this is
        blocked on the uninit topic branch getting merged (or at least
        the mke2fs) changes are so blocked.


In addition, the following changes were added to the "next" branch.

At this point, I believe all of the Lustre code changes (not including
the new test cases; that's still on the todo list) have been accounted
for.

Andreas Dilger (8):
      debugfs: Add support for "set_block_group <bg_num> checksum calc"
      ext2fs_set_gdt_csum(): Clean up superblock dirty flag handling
      ext2fs_set_gdt_csum(): Force the last block group to have a valid block bitmap
      ext2fs_set_gdt_csum(): Return an error code on errors instead of void
      libext2fs: Micro-optimization in inode scan code
      Split the m_lazy test case into two cases: m_lazy and m_lazy_resize
      e2fsck: Add check to enforce a valid block bitmap in last block group
      Add new regression test: f_uninit_last_uninit

Eric Sandeen (1):
      e2fsck: Fix extent flag validity tests in pass1 on big endian boxes.

Theodore Ts'o (5):
      Fix trailing whitespace in e2fsck/problem.[ch]
      dumpe2fs: Print the group checksum and the block options in a nicer way
      libext2fs: Make all test programs link only against the static library
      Add dependency rule so that static library when necessary for "make check"
      libext2fs: Fix big-endian bug in tst_csum.c

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
