From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Thu, 20 Mar 2008 16:32:50 -0400
Message-ID: <20080320203250.GP13719@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080313181159.GD31653@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32773 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594AbYCTUcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 16:32:55 -0400
Content-Disposition: inline
In-Reply-To: <20080313181159.GD31653@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/mkfs-types (Tue Feb 19 08:32:58 2008 -0500) 1 commit
 - New mke2fs types parsing --- IN PROGRESS

	Eric is working on the documentation and reworking the way we
	handle the command parsing.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	Not touched.

* js/flex-bg (Wed Feb 13 20:47:50 2008 -0600) 1 commit
 - e2fsprogs: New bitmap and inode table allocation for FLEX_BG v2

	Next on my list to audit.

* js/uninit (Sun Oct 21 21:04:24 2007 -0500) 11 commits
 + Add m_uninit test case
 + Add new m_lazy test case
 + Make e2fsck uninit block group aware
 + Make debugfs uninit block group aware
 + Make resize2fs uninit block group aware
 + Make dumpe2fs uninit block group aware
 + Make tune2fs uninit block group aware
 + Add support for creating filesystems using uninit block group
 + Rename feature name from gdt_checksum to uninit_groups
 + Add uninit block group support to various libext2fs functions
 + Add initial checksum support for the gdt_checksum/uninit_group
   feature

	Merged into next.  At this point e2fsck on the 'next' branch
	should be able to deal with any valid ext4 filesystem; if it
	doesn't, that's a bug.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

	Unchanged from last time.

        The test cases are missing an expected file.

        Also, we need to chage "mke2fs use undo I/O manager" so it
        only does it if the uninit group patch is enabled.  

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
