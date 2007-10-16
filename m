From: "Theodore Ts'o" <tytso@mit.edu>
Subject: What's cooking in e2fsprogs.git (topics)
Date: Tue, 16 Oct 2007 00:48:21 -0400
Message-ID: <E1IheLt-0001TN-65@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47217 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765207AbXJPEsq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2007 00:48:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Here are the topics that are cooking in e2fsprogs.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are in
'next'.  Commits prefixed with '.' are not in either branch for now.

* tt/64bit-bitmaps (Sun Oct 14 22:51:51 2007 -0400) 1 commit
 - Initial design for 64-bit bitmaps

This a sketch for how to do 64-bit bitmaps; it's mostly comments and
function signatures for now.

* js/uninit (Thu Oct 11 14:17:19 2007 -0500) 16 commits
 . Add m_uninit test case.
 . Add new mm_lazy test case.
 . Fix test cases.
 . Update uninit block group documetation for some of the utilities.
 . Make e2fsck uninit block group aware.
 . Make debugfs uninit block group aware.
 . Make resize2fs uninit block group aware.
 . Make dumpe2fs uninit block group aware.
 . Make tune2fs uninit block group aware.
 . Add support for creating filesystems using uninit block group.
 . Rename feature name from gdt_checksum to uninit_groups.
 . Add uninit block group support on libe2fs.
 . Add initial checksum support.

This doesn't compile on my Ubuntu system, due to the use of
linux/types.h.  Jose is reworking this patch seris, so I've left it out
of pu for now.

* cl/remove-masix (Thu Aug 23 15:09:03 2007 +0800) 8 commits
 - mke2fs: remove masix support
 - e2fsck: remove masix support
 - libext2fs: remove masix support
 - document: remove masix from data structure
 - debugfs: remove masix support

I've done a quick review, and this will probably going in soon.

* tt/extents (Mon Aug 20 21:31:11 2007 -0400) 5 commits
 - e2fsck: Add support for extents
 - Add support for extents to libext2fs
 - e2fsck: factor out code to clear an inode into
   e2fsck_clear_inode()
 - Don't byte swap extents information in the inode
 - Allow debugfs to be extended for use by test programs

This will correctly check a valid filesystem, but it may crash or loop
forever on an invalid filesystem.  More work needs to be done on the
e2fsck patch, but the core extent support in libext2fs is mostly there.

* js/flex-bg (Mon Aug 13 23:33:14 2007 -0500) 7 commits
 - New bitmap and inode table allocation for FLEX_BG
 - Relax group descriptor checking.
 - Allow FLEX_BG to be use as a feature option at mke2fs time.
 - Reserve the INCOMPAT feature number for FLEX_BG.

Relatively straight forward, so we should be able to merge this soon.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 9 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

The undo manager is mostly OK, but the large inode migration is
extremely unsatisfactory, given that it halves the number of inodes and
only works if the no more than 50% of the inodes in every single block
group is used.  As a standalone kludge it may be OK, but the right thing
to do is to allocate more blocks for the inode table.

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

These are the extent test cases from Clusterfs.  They will be pulled in
to the extents branch once they don't cause e2fsck to loop forever.

       	       	      	   	      	    	   - Ted
