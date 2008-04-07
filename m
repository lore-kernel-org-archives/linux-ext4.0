From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 7 Apr 2008 13:12:30 -0400
Message-ID: <20080407171230.GE11997@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46616 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbYDGRMf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 13:12:35 -0400
Content-Disposition: inline
In-Reply-To: <20080402000956.GC302@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* ak/undo-mgr (Sun Apr 6 18:08:12 2008 -0400) 7 commits
 - Allow user to disable Undo manager through MKE2FS_SCRATCH_DIR
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager

	Still needs a lot of polish.  I'll be working on this myself.
	Patches to clean this up are welcome...

* js/flex-bg (Mon Mar 31 22:13:11 2008 -0500) 1 commit
 - mke2fs: New bitmap and inode table allocation for FLEX_BG

	This patch has problems with combinations with meta_bg; some
	of it may be bugs or a misdesign in the meta_bg or
	uninit_groups support code.  In particular I suspect I'll need
	to redesign a new interface for ext2fs_super_and_bgd_loc2()
	that makes this all cleaner.

	We also need to make uninit_groups truly *be* uninit_groups,
	and do the lazy intable initialziation (which we don't do
	now).

* es/warnings-fix (Sat Mar 29 23:01:52 2008 -0500) 1 commit
 + Fix a couple of implicit function declarations

	Merged into next and master; will be dropped as a branch.

* tt/mkfs-types (Tue Feb 19 08:32:58 2008 -0500) 1 commit
 + New mke2fs filesystem and usage types support

	Merged into next and master; will be dropped as a branch.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	No change

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
