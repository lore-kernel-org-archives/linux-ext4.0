From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 21 Apr 2008 12:41:44 -0400
Message-ID: <20080421164144.GG9700@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32917 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbYDUTrG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 15:47:06 -0400
Content-Disposition: inline
In-Reply-To: <20080418184329.GB25797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/uninit_fixup (Mon Apr 21 01:29:01 2008 -0400) 8 commits
 + Transfer responsibility of setting the *_UNINIT flags to libext2fs
 + Remove LAZY_BG feature
 + Add comments documenting ext2fs_[reserve_]super_and_bgd_loc()
 + e2fsck: Fix pass5 handling of meta_bg and uninit_bg combination
 + ext2fs_set_gdt_csum: Remove setting of BLOCK_UNINIT
 + ext2fs_set_gdt_csum: Remove bogus setting of ITABLE_ZEROED

	This is in the 'next' branch already.  It significantly cleans
	up how the BLOCK_UNINIT, INODE_UNINIT, and ITABLE_ZEROED flags
	are handled.  The resulting code is much more robust, so when
	the flex_bg allocation patch is re-introduced, it should be
	much more robust.

* tt/inode_size (Sun Apr 20 16:10:07 2008 -0400) 2 commits
 + libe2p: Print the s_min_extra_isize and s_wanted_extra_isize
   fields
 + libext2fs: Initialize s_min_extra_isize and s_wanted_extra_isize

	This is in the 'next' branch already.  It turns out we weren't
	initializing these fields in the superblock; oops.  

	Still to do is code in e2fsck so we can fix up inodes which
	have less exra inode space allocated than what is requested by
	the superblock.

* js/flex-bg (Mon Mar 31 22:13:11 2008 -0500) 1 commit
 . mke2fs: New bitmap and inode table allocation for FLEX_BG

	This has been temporarily dropped from the 'pu' branch,
	because of patch conflicts introduced by the tt/uninit_fixup
	branch.  This patch needs to be broken up into smaller patches
	(header file and base support in debugfs for the new
	superblock fields, followed by the needed changes to the
	library, and the the mke2fs changes., etc.)

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	No change from last time.

* ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
 - Add test cases for undoe2fs: u_undoe2fs_mke2fs and
   u_undoe2fs_tune2fs
 - Fix the resize inode test case
 - tune2fs: Support for large inode migration.
 - mke2fs: Add support for the undo I/O manager.
 - Add undoe2fs command
 - libext2fs: Add undo I/O manager

	These patches have been *significantly* rototilled.

	* The test cases weren't correctly setting and deleting the
	  test_name.ok and test_name.failed files

	* mke2fs would bomb out with an incomprehensible error message
	  if run twice in a row, or if the user didn't have write access
	  to /var/lib/e2fsprogs (some users run mke2fs as a non-root
	  user!)

	* the undoe2fs program was calling com_err and passing
	  in uninitialized retval values, and was otherwise confused
	  about how to do proper error handling, resulting in garbage
	  getting printed if the file passed in didn't exist

	* there was a terrible performance problem because in the
	  mke2fs case, the undo manager was using a tdb_data_size of
	  512.

	* I added the ability to configure the location of the scratch
          dirctory via mke2fs.conf for mk2efs.  What we should do for
          tune2fs is less clear, and still needs to be addressed.  It
          is also possible to force an undo file to be always created,
          and not just when doing a lazy inode table initialization.
          By using a 4k instead of 512 tdb_data_size, the time to
          speed up an mke2fs was cut in half, while still using an
          undo file.  I suspect if we force the tdb_data_size to be
          even larger, say 32k or 64k the overhead would shrink even
          more.

	Unfortunately, there appears to be some kind of data
	corruption bug if I force a tdb_data_size of 32768, so I'm not
	entirely sure I trust the undo manager to be working
	correctly.  The undo_manager code itself needs a pretty
	serious auditing and checking to make sure it's doing the
	right thing with large tdb_data_sizes.

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
