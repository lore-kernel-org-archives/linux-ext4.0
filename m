From: "Theodore Ts'o" <tytso@mit.edu>
Subject: The new ext4 git tree re-org
Date: Tue, 10 May 2011 09:56:40 -0400
Message-ID: <E1QJnQW-0002Lg-Ls@tytso-glaptop>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44300 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab1EJN4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 09:56:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've uploaded an updated dev branch to the ext4 tree.  Compared to the
previous version of dev branch, I've removed my modified version of
Allison's "NULL pointer when make_indexed_dir returns -ENOSPC" patch,
and I've added Amir's alloc_semp removal patches.  I'm still in the
process of reviewing those patches; I've included them to make it easier
for I and others to test them.

For those folks who aren't regular attendees of the weekly ext4
conference call[1], and so would have missed the announcement, we've
made a change in how the branchs of the ext4 tree are organized.  The
master branch of the ext4 tree is now non-rewinding, so it should be
considered a stable place to do patch development, or as a starting
point to start git branches.  The dev branch is backed by the ext4 patch
queue, and is subject to being rewound, mainly when a patch gets yanked
because testing or further review has discovered problems.  Please feel
free to test the dev branch, but if you use it as a base for
development, especially using git, please be aware that the dev branch
is subject to being rewound and rebased.

[1] If you want to attent the conference call, please talk to me or
Mingming Cao.

Stephen, could you change the linux-next tree so that it pulls from the
ext4.git's "dev" branch, instead of the "next" branch?   Many thanks!!

Here are some convenient URL's (use the http://.. URL for web browsing,
and the git://... URL for git pull or git clone commands):

* The ext4 tree:
	http://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

* The ext4 patch queue (note: new URL):
	https://github.com/tytso/ext4-patch-queue/commits/master
	git://github.com/tytso/ext4-patch-queue.git

* The e2fsprogs git tree (note in particular the maint, next, and master
  branches):
	http://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

The next patch series that are scheduled to land in dev are Allison's
"punch" patches, which has made several rounds on the ext4 list.  My
intentions are to start reviewing and integrating those patches into the
dev tree on Wednesday.  If other people have any concerns, I'd
appreciate any reviews or comments before then.

						- Ted

% git shortlog master..dev
Amerigo Wang (1):
      ext4: remove redundant #ifdef in super.c

Amir Goldstein (5):
      ext4: move ext4_add_groupblocks() to mballoc.c
      ext4: implement ext4_add_groupblocks() by freeing blocks
      ext4: synchronize ext4_mb_init_group() with buddy page lock
      ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
      ext4: remove alloc_semp

Jan Kara (1):
      jbd2: Fix forever sleeping process in do_get_write_access()

Tao Ma (3):
      ext4: use EXT4FS_DEBUG instead of EXT4_DEBUG in fsync.c
      ext4: use s_inodes_per_block directly in __ext4_get_inode_loc
      ext4: remove redundant check for first_not_zeroed in ext4_register_li_requ

Theodore Ts'o (2):
      jbd2: only print the debugging information for tid wraparound once
      ext4: remove unneeded ext4_journal_get_undo_access

% git shortlog origin..master
Curt Wohlgemuth (1):
      ext4: don't set PageUptodate in ext4_end_bio()

Jan Kara (2):
      ext4: Fix fs corruption when make_indexed_dir() fails
      ext4: fix deadlock in ext4_symlink() in ENOSPC conditions

Shaohua Li (1):
      ext4: remove dead code in ext4_has_free_blocks()

Theodore Ts'o (5):
      ext4: check for ext[23] file system features when mounting as ext[23]
      ext4: ignore errors when issuing discards
      ext4: remove obsolete mount options from ext4's documentation
      jbd2: fix fsync() tid wraparound bug
      ext4: set extents flag when migrating file to use extents

Yang Ruirui (1):
      ext4: release page cache in ext4_mb_load_buddy error path

Yongqiang Yang (3):
      ext4: add a function merging extents right and left
      ext4: add ext4_split_extent_at() and ext4_split_extent()
      ext4: reimplement convert and split_unwritten

