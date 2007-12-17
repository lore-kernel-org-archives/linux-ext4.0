From: Theodore Tso <tytso@mit.edu>
Subject: What's cooking in e2fsprogs.git (topics)
Date: Mon, 17 Dec 2007 12:11:00 -0500
Message-ID: <20071217171100.GA7070@thunk.org>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55181 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXLQRLI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 12:11:08 -0500
Content-Disposition: inline
In-Reply-To: <E1IooAl-0006SJ-Ki@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

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

	The uninit patch set is the next major set on my "to-merge"
	list.  I've fixed this patch set so that "make check" works.

* tt/64bit-bitmaps (Sun Oct 14 22:51:51 2007 -0400) 1 commit
 - Initial design for 64-bit bitmaps

	No change; still needs work, obviously.

* tt/extents (Mon Aug 20 21:31:11 2007 -0400) 5 commits
 - e2fsck: Add support for extents
 - Add support for extents to libext2fs
 - e2fsck: factor out code to clear an inode into
   e2fsck_clear_inode()
 - Don't byte swap extents information in the inode
 - Allow debugfs to be extended for use by test programs

	I've started adding some additional checking into e2fsck, but
	it still needs work.

* js/flex-bg (Mon Aug 13 23:33:14 2007 -0500) 1 commit
 - New bitmap and inode table allocation for FLEX_BG
* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager
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

	These tests haven't been merged in yet, pending improvement of
	the extents patches.
