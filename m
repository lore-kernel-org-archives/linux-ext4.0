From: "Theodore Ts'o" <tytso@mit.edu>
Subject: ext4.git's dev branch has what I hope to push to Linus
Date: Tue, 24 May 2011 19:11:19 -0400
Message-ID: <E1QP0kx-0007rD-IR@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60367 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1EXXLV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 19:11:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, I've just pushed out a new dev branch to the ext4.git branch, with a
commit id: 8ac22b5d4144653e45bd0c18b0aff436b1d299ed.

I'm going to be running this through a full set of tests, and hopefully
I'll be able to push this to Linus in 24 hours or so.

If you think I'm missing something critical, please shout; but it's
going to have to be something really important.  We still have an option
to push bug fixes and obvious clean ups before -rc2 closes, of course.

As you can see, we have a fair amount that we're pushing to Linus this
time around...

   	    	      	      	    	       	    - Ted

Aditya Kali (1):
      ext4: reserve inodes and feature code for 'quota' feature

Allison Henderson (7):
      ext4: don't dereference null pointer when make_indexed_dir() fails
      ext4: ext4_ext_convert_to_initialized bug found in extended FSX testing
      ext4: add flag to ext4_has_free_blocks
      ext4: add new function ext4_block_zero_page_range()
      ext4: punch out extents
      ext4: add "punch hole" flag to ext4_map_blocks()
      ext4: enable "punch hole" functionality

Amerigo Wang (1):
      ext4: remove redundant #ifdef in super.c

Amir Goldstein (6):
      ext4: move ext4_add_groupblocks() to mballoc.c
      ext4: implement ext4_add_groupblocks() by freeing blocks
      ext4: synchronize ext4_mb_init_group() with buddy page lock
      ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
      ext4: remove alloc_semp
      ext4: fix oops in ext4_quota_off()

Curt Wohlgemuth (1):
      ext4: don't set PageUptodate in ext4_end_bio()

Darrick J. Wong (2):
      ext4: clean up some wait_on_page_writeback calls
      ext4: wait for writeback to complete while making pages writable

Eric Gouriou (1):
      ext4: fix unbalanced up_write() in ext4_ext_truncate() error path

Eryu Guan (1):
      jbd2: Fix comment to match the code in jbd2__journal_start()

Jan Kara (6):
      ext4: Fix fs corruption when make_indexed_dir() fails
      ext4: fix deadlock in ext4_symlink() in ENOSPC conditions
      jbd2: Fix forever sleeping process in do_get_write_access()
      jbd2: fix sending of data flush on journal commit
      jbd2: Add function jbd2_trans_will_send_data_barrier()
      ext4: fix waiting and sending of a barrier in ext4_sync_file()

Johann Lombardi (1):
      ext4: add support for multiple mount protection

Kazuya Mio (1):
      ext4: ensure f_bfree returned by ext4_statfs() is non-negative

Lukas Czerner (6):
      ext4: Use schedule_timeout_interruptible() for waiting in lazyinit thread
      ext4: Remove unnecessary wait_event ext4_run_lazyinit_thread()
      ext4: fix the mount option "init_itable=n" to work as expected for n=0
      ext4: fix possible use-after-free in ext4_remove_li_request()
      ext4: only load buddy bitmap in ext4_trim_fs() when it is needed
      ext4: protect bb_first_free in ext4_trim_all_free() with group lock

Shaohua Li (1):
      ext4: remove dead code in ext4_has_free_blocks()

Tao Ma (5):
      ext4: use EXT4FS_DEBUG instead of EXT4_DEBUG in fsync.c
      ext4: use s_inodes_per_block directly in __ext4_get_inode_loc
      ext4: remove redundant check for first_not_zeroed in ext4_register_li_request
      ext4: don't warn about mnt_count if it has been disabled
      jbd2: Fix the wrong calculation of t_max_wait in update_t_max_wait

Theodore Ts'o (9):
      ext4: check for ext[23] file system features when mounting as ext[23]
      ext4: ignore errors when issuing discards
      ext4: remove obsolete mount options from ext4's documentation
      jbd2: fix fsync() tid wraparound bug
      ext4: set extents flag when migrating file to use extents
      jbd2: only print the debugging information for tid wraparound once
      ext4: remove unneeded ext4_journal_get_undo_access
      ext4: don't show mount options in /proc/mounts if there is no journal
      ext4: use truncate_setsize() unconditionally

Vivek Haldar (2):
      ext4: do not normalize block requests from fallocate()
      ext4: count hits/misses of extent cache and expose in sysfs

Yang Ruirui (1):
      ext4: release page cache in ext4_mb_load_buddy error path

Yongqiang Yang (5):
      ext4: add a function merging extents right and left
      ext4: add ext4_split_extent_at() and ext4_split_extent()
      ext4: reimplement convert and split_unwritten
      ext4: make ext4_split_extent() handle error correctly
      ext4: fix ext4_ext_fiemap_cb() to handle blocks before request range correctly

 Documentation/filesystems/ext4.txt |    4 -
 fs/ext4/Makefile                   |    3 +-
 fs/ext4/balloc.c                   |  146 +----
 fs/ext4/ext4.h                     |  127 +++-
 fs/ext4/ext4_jbd2.c                |   14 -
 fs/ext4/ext4_jbd2.h                |    5 -
 fs/ext4/extents.c                  | 1326 ++++++++++++++++++++++--------------
 fs/ext4/fsync.c                    |   25 +-
 fs/ext4/inode.c                    |  110 +++-
 fs/ext4/mballoc.c                  |  459 +++++++------
 fs/ext4/mballoc.h                  |    6 -
 fs/ext4/migrate.c                  |    2 +-
 fs/ext4/mmp.c                      |  351 ++++++++++
 fs/ext4/move_extent.c              |    3 +-
 fs/ext4/namei.c                    |   82 ++-
 fs/ext4/page-io.c                  |   39 +-
 fs/ext4/super.c                    |  204 ++++--
 fs/ext4/xattr.c                    |    4 +-
 fs/jbd2/commit.c                   |   22 +-
 fs/jbd2/journal.c                  |   58 ++-
 fs/jbd2/transaction.c              |   20 +-
 include/linux/jbd2.h               |    8 +-
 22 files changed, 1961 insertions(+), 1057 deletions(-)
