From: Theodore Tso <tytso@MIT.EDU>
Subject: What's cooking in e2fsprogs.git (topics)
Date: Fri, 29 Feb 2008 10:43:33 -0500
Message-ID: <20080229154333.GC8968@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45059 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbYB2PoM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 10:44:12 -0500
Content-Disposition: inline
In-Reply-To: <20080219050945.GU25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The primary changes since last time is more fixups on tt/mkfs-types,
and a refactoring of the patches in js/uninit.

In addition, I've done a lot of analysis and made comments below
regarding what needs to be done before each of these topics are ready
to be merged.  If you are are responsible for any of the patches
below, please do take a look.

Although I've checked to make sure that each of these topic branches
passes "make check" on their own, the combined pu branch is failing
due to what appears to be unfortunate interactions between js/flex-bg
and js/uninit.  This *may* be because I botched the merge, which got
tricky when I merged in js/uninit into the pu branch which already had
js/flex-bg.  If someone could take a look at the misc/mke2fs.c changes
in "git show bffaaf74", I'd much appreciate it.

						- Ted


Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* tt/mkfs-types (Tue Feb 19 08:32:58 2008 -0500) 1 commit
 - New mke2fs types parsing --- IN PROGRESS

	This is missing only documentation updates at this point

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	Untouched since last time
 
* js/flex-bg (Wed Feb 13 20:47:50 2008 -0600) 1 commit
 - e2fsprogs: New bitmap and inode table allocation for FLEX_BG v2

	I've noticed that this patch is slightly different from what
	Jose sent in for the e2fsprogs-interim branch, so I'm a little
	concerned about which is the latest, or whether the
	differences are intentional.  Jose, if you have time, could
	you take a look at commits cb676995 and 8072fe6 and perhaps comment?

* ad/nlinks-dir (Sat Feb 2 01:25:03 2008 -0700) 1 commit
 - e2fsprogs-nlinks.patch

	I'm really not sure about this change in e2fsck/pass4.c:

-			if (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
+			/* i_link_count was previously exceeded, but no longer
+			 * is, fix this but don't consider it an error */
+			if ((LINUX_S_ISDIR(inode->i_mode) && link_counted > 1 &&
+			     (inode->i_flags & EXT2_INDEX_FL) &&
+			     link_count == 1 && !(ctx->options & E2F_OPT_NO)) ||
+			     (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx))) {
 				inode->i_links_count = link_counted;
 				e2fsck_write_inode(ctx, i, inode, "pass4");
 			}

	Why do we require EXT2_INDEX_FL to be set before deciding that
	it's OK if the i_link_count is 1 but we now have less than
	EXT2_LINK_MAX links?
	

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

	I've refactored this patch series, so that the documentation
	changes for mke2fs and tune2fs are with their respective
	patches.  I also moved the test cases fixups into the "make
	e2fsck uninit block group aware".


	As a result of the "make check" failures which I mentioned at
	the beginning of this note, I noticed the following
	unfortunate problem in how errors are getting reported in
	e2fsck pass 5.  As a sample:

Block bitmap differences:  +8195Group 3 block(s) in use but group is marked BLO
CK_UNINIT
Fix? yes

	This mangling is happening because error reporting for
	PR_5_INODE_UNINIT is getting intermingled with the
	PR_5_INODE_USED/PR_5_INODE_UNUSED reporting, which isn't a
	good idea.  The comment around the code says:

		/* 
		 * We should never hit this, because it means that
		 * inodes were marked in use that weren't noticed
		 * in pass1 or pass 2. It is easier to fix the problem
		 * than to kill e2fsck and leave the user stuck.
		 */

	So I'm guessing there's something else wrong going on here....

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

----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
