From: "Theodore Ts'o" <tytso@mit.edu>
Subject: What's cooking in e2fsprogs.git (topics)
Date: Sun, 04 Nov 2007 17:42:27 -0500
Message-ID: <E1IooAl-0006SJ-Ki@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40422 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbXKDWnQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 17:43:16 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* next (Sun Oct 21 21:03:14 2007 -0500) 6 commits 
       (plus those commits pulled in from the topics branches, below)
 + check_ea_in_inode: Cleanup e2fsck_write_inode_full() call
 + blkid.pc, ss.pc: Move private libs from "Libs:" to "Libs.private:"
 + texinfo: Fix directory entries
 + blkid/test_probe.in: Fix temporary files handling
 + Check fgets(3) return value
 + e2image: Fix potential off-by-one fs_device_name buffer overflow
 + Use blk_t type instead of unsigned int or __u32

	I'm using a slightly different system than git, where new
	minor commits are going into the "next" branch, and where
	master is always a strict subset of next.  (With git topic
	branches get pulled into master, and some branches live in
	next for a long time.  In contrast, for now I'm only pulling
	branches into 'next' when I'm reasonably certain that they can
	go into 'master' fairly quickly.)  This is an experiment, but
	if it's too much trouble to keep 'next' close to 'master', I
	might move over to the 'git' scheme.

	In any case, everything in 'next' will proably go into
	'master' fairly quickly.  Pleas test it and let me know if you
	find any problems!

* tt/badblocks-cleanup (Mon Oct 22 10:19:20 2007 -0400) 3 commits
 + badblocks: Factor out calls to strtoul to a helper function
 + badblocks: Change unsigned long to blk_t and unsigned int, as
   appropriate
 + badblocks: Use unsigned int instead of unsigned long for test
   patterns

	This branch has been completely moved into 'next', and is
	ready to graduate to 'master'.
	
* tt/chattr-error-code (Mon Oct 22 08:51:39 2007 -0400) 3 commits
 + chattr: provide an exit code in case of failure and add -f flag
 + libe2p: Change iterate_on_dir so that it counts non-zero returns
 + libe2p: Use lstat() instead of stat() in fsetflags() and
   fgetflags()

	This branch has been completely moved into 'next', and is
	ready to graduate to 'master'.

* js/uninit (Sun Oct 21 21:04:24 2007 -0500) 14 commits
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
 + Reorder some of the $(SRCS) in alphabetical order.

	This still doesn't pass "make check" in lib/ext2fs, but I'll
	take a closer look at this in the near future.

* tt/64bit-bitmaps (Sun Oct 14 22:51:51 2007 -0400) 1 commit
 - Initial design for 64-bit bitmaps

	I haven't done anything with this yet; hopefully, I'll have
	more time in the next two weeks.

* cl/remove-masix (Thu Aug 23 15:09:03 2007 +0800) 5 commits
 + mke2fs: remove masix support
 + e2fsck: remove masix support
 + libext2fs: remove masix support
 + document: remove masix from data structure
 + debugfs: remove masix support

	This branch has been completely moved into 'next', and is
	ready to graduate to 'master'.

* tt/extents (Mon Aug 20 21:31:11 2007 -0400) 5 commits
 - e2fsck: Add support for extents
 - Add support for extents to libext2fs
 - e2fsck: factor out code to clear an inode into
   e2fsck_clear_inode()
 - Don't byte swap extents information in the inode
 - Allow debugfs to be extended for use by test programs

	I haven't done anything with this yet; hopefully, I'll have
	more time in the next two weeks.

* js/flex-bg (Mon Aug 13 23:33:14 2007 -0500) 4 commits
 - New bitmap and inode table allocation for FLEX_BG
 + Enable FLEX_BG feature support
 + Relax group descriptor checking for FLEX_BG
 + Reserve the INCOMPAT feature number for FLEX_BG.

	The basic flex-bg support has been merged into 'master', but
	the allocation changes need some more testing, especially for
	resize2fs.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

	I just need to review these changes more.  It's on my queue...

* ad/extents-testcases (Thu Jul 12 11:20:14 2007 -0400) 19 commits
 . Add extent test: f_extents_shrd_blk
 . Add extent test: f_extents_unsorted
 . Add extent test: f_extents_res_blk
 . Add extent test: f_extents_overlap
 . Add extent test: f_extents_orphan_blks
 . Add extent test: f_extents_inrlevel-incons
 . Add extent test: f_extents_imbalanced_tree
 . Add extent test: f_extents_ei_leaf
 . Add extent test: f_extents_ei_block
 . Add extent test: f_extents_eh_max
 . Add extent test: f_extents_eh_magic
 . Add extent test: f_extents_eh_entries
 . Add extent test: f_extents_eh_depth
 . Add extent test: f_extents_ee_start
 . Add extent test: f_extents_ee_len
 . Add extent test: f_extents_ee_block
 . Add extent test: f_extents_bad_blk
 . Add extent test: f_extents
 . Add extent test: f_bad_disconnected_inode

	These are parked until the extents support is more mature.  As
	the extents code is better suited, these tests will get pulled
	into the extents branch.
