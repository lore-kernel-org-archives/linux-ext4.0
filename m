From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Fri, 18 Apr 2008 14:43:29 -0400
Message-ID: <20080418184329.GB25797@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65439 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043AbYDRTC6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 15:02:58 -0400
Content-Disposition: inline
In-Reply-To: <20080407171230.GE11997@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/huge_file (Wed Apr 9 11:39:11 2008 -0400) 1 commit
 + Add support for the HUGE_FILE feature
* ak/undo-mgr (Sun Apr 6 18:08:12 2008 -0400) 7 commits
 - Allow user to disable Undo manager through MKE2FS_SCRATCH_DIR
 - e2fsprogs: Add test case for undoe2fs
 - e2fsprogs: Fix the resize inode test case
 - e2fsprogs: Support for large inode migration.
 - e2fsprogs: Make mke2fs use undo I/O manager.
 - e2fsprogs: Add undoe2fs
 - e2fsprogs: Add undo I/O manager
* js/flex-bg (Mon Mar 31 22:13:11 2008 -0500) 1 commit
 - mke2fs: New bitmap and inode table allocation for FLEX_BG
* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

In addition, the folllowing changes were dropped into the 'next' branch:

Eric Sandeen (5):
      print a bit more info for the tst_extents info command
      Fix ext2fs_extent_insert when at last extent in node
      Make extent_goto() deterministic when logical block not found
      e2fsck: Only check PR_1_EXTENT_ENDS_BEYOND for leaf nodes
      blkid: more sanity checks for swap v1

Theodore Ts'o (4):
      Fix tst_extents build when building w/o dynamic libraries
      Rename the feature uninit_groups to uninit_bg
      Change the primary name of the extents feature to be 'extent'
      mke2fs: Disentangle lazy_bg from uninit_bg's lazy inode table initialization

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
