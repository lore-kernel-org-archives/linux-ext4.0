From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sun, 10 Feb 2008 23:51:07 -0500
Message-ID: <20080211045107.GB25089@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34140 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbYBKEvK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 23:51:10 -0500
Content-Disposition: inline
In-Reply-To: <20071217171100.GA7070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'ts been a while since I've pushed one of these out.  This updates pu
against the latest "next" branch, so we can make sure all of the
changes that had been folded into "maint" is included on the pu
branch.  It also includes more work on the tt/extents patches.
Tune2fs and e2image are now functional with extents, and e2fsck has
more extents checking added.  Still a bit more work to be done there,
and I also have to add code to deal with symlinks that have the
EXTENTS_FL flag set.

I've dropped the js/flex-bg branch since it had conflicts with the
on-disk bg flags, and it had conflicts with the exsting patches that
caused me concern.  Jose, once you regenerate the patch and deal with
comments, I'll add it back in.

My TODO list:

   finish e2fsck extents support
   more flexible mke2fs.conf handling
   EXT4 -- allow mke2fs 8TB without -f
   reserve a few extra resize blocks for small filesystems
   disable metabg/resize combination
   adjust big, medium, small, thresholds
         256 inode size
   flexbg patch from Jose

					- Ted

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
* tt/64bit-bitmaps (Sun Oct 14 22:51:51 2007 -0400) 2 commits
 - Initial design for 64-bit bitmaps
* tt/extents (Mon Aug 20 21:31:11 2007 -0400) 8 commits
 - e2fsck: Add support for extents
 - Use BLOCK_FLAG_READ_ONLY flag in debugfs, e2image, and tune2fs
 - Add read-only extents support to ext2fs_block_iterate2()
 - Add support for extents to libext2fs
 - e2fsck: factor out code to clear an inode into
   e2fsck_clear_inode()
 - Don't byte swap extents information in the inode
 - Allow debugfs to be extended for use by test programs
* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 7 commits
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager
