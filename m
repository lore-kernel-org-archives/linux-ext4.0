From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 19 Feb 2008 00:09:45 -0500
Message-ID: <20080219050945.GU25098@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45185 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbYBSFJq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 00:09:46 -0500
Content-Disposition: inline
In-Reply-To: <20080211045107.GB25089@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The big news here is that extents branch is sufficiently finished that
I've promoted it to the next branch.

     	      				- Ted

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps
* next (Mon Feb 18 23:01:43 2008 -0500) 3 commits 
 + e2fsprogs-tests-f_ea_checks.patch
 + e2fsprogs-tests-f_unsorted_EAs.patch
 + Improve support for in-inode EA's
* tt/extents (Mon Feb 18 20:11:07 2008 -0500) 10 commits
 + Activate basic f_extents test case
 + e2fsck: Add support for extents
 + Add read/only support for extents to ext2fs_bmap()
 + Use BLOCK_FLAG_READ_ONLY flag in debugfs, e2image, and tune2fs
 + Add read-only extents support to ext2fs_block_iterate2()
 + Add support for extents to libext2fs
 + e2fsck: factor out code to clear an inode into
   e2fsck_clear_inode()
 + Don't byte swap extents information in the inode
 + Allow debugfs to be extended for use by test programs
 + debugfs: Fix error handling in strtoblk() and
   common_block_args_process()
* js/flex-bg (Wed Feb 13 20:47:50 2008 -0600) 1 commit
 - e2fsprogs: New bitmap and inode table allocation for FLEX_BG v2
* js/uninit (Sun Oct 21 21:04:24 2007 -0500) 13 commits
 - Add m_uninit test case.
 - Add new mm_lazy test case.
 - Fix test cases.
 - Update uninit block group documetation for some of the utilities.
 - Make e2fsck uninit block group aware.
 - Make debugfs uninit block group aware.
 - Make resize2fs uninit block group aware.
 - Make dumpe2fs uninit block group aware.
 - Make tune2fs uninit block group aware.
 - Add support for creating filesystems using uninit block group.
 - Rename feature name from gdt_checksum to uninit_groups.
 - Add uninit block group support on libe2fs.
 - Add initial checksum support.
* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager
