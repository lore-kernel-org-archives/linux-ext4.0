From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Thu, 13 Mar 2008 14:11:59 -0400
Message-ID: <20080313181159.GD31653@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41059 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559AbYCMSMK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 14:12:10 -0400
Content-Disposition: inline
In-Reply-To: <20080229154333.GC8968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* js/64bitio (Mon Mar 3 10:41:29 2008 -0600) 3 commits
 + Add {read,write}_blk64 to inode_io.c
 + Add {read,write}_blk64 to unix_io.c
 + Add 64-bit IO manager operations to struct_io_manager.

	Looks good; I've already put it into the next branch.

* tt/mkfs-types (Tue Feb 19 08:32:58 2008 -0500) 1 commit
 - New mke2fs types parsing --- IN PROGRESS

	No change since list time; still needs documentation.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	No change since last time.

* js/flex-bg (Wed Feb 13 20:47:50 2008 -0600) 1 commit
 - e2fsprogs: New bitmap and inode table allocation for FLEX_BG v2

	Jose, have you had a chance to sanity check these compared to
	what is in e2fsprogs-interim?

* ad/nlinks-dir (Sat Feb 2 01:25:03 2008 -0700) 2 commits
 - Add support for the DIR_NLINK feature.
 - libext2fs: Make icount use a 32-bit counter

	This has been reworked per a note to linux-ext4 sent earlier
	today.  If there are no comments, these should be ready to go
	in.

* js/uninit (Sun Oct 21 21:04:24 2007 -0500) 11 commits
 - Add m_uninit test case
 - Add new m_lazy test case
 - Make e2fsck uninit block group aware
 - Make debugfs uninit block group aware
 - Make resize2fs uninit block group aware
 - Make dumpe2fs uninit block group aware
 - Make tune2fs uninit block group aware
 - Add support for creating filesystems using uninit block group
 - Rename feature name from gdt_checksum to uninit_groups
 - Add uninit block group support on libe2fs
 - Add initial checksum support

	The pu merge problem seems to have been solved; thanks to Jose
	for pointing out the missing patch hunk.

	This should be ready to go in soon.  I just need time to do a
	final audit.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

	The test cases are missing an expected file

	Also, we need to chage "mke2fs use undo I/O manager" so it
	only does it if the uninit group patch is enabled.  So this is
	blocked on the uninit topic branch getting merged (or at least
	the mke2fs) changes are so blocked.

	The undoe2fs program is missing a man page.

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
