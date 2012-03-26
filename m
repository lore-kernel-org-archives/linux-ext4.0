From: "Theodore Ts'o" <tytso@mit.edu>
Subject: GIT PULL] ext4 updates for 3.4
Date: Mon, 26 Mar 2012 11:07:19 -0700
Message-ID: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43065 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933Ab2CZSHX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Mar 2012 14:07:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext4_for_linus

for you to fetch changes up to 9d547c35799a4ddd235f1565cec2fff6c9263504:

  vfs: remove unused superblock helpers (2012-03-21 22:34:55 -0400)

----------------------------------------------------------------
Ext4 commits for 3.3 merge window; mostly cleanups and bug fixes

The changes to export dirty_writeback_interval are from Artem's s_dirt
cleanup patch series.  The same is true of the change to remove the
s_dirt helper functions which never got used by anyone in-tree.  I've
run these changes by Al Viro, and am carrying them so that Artem can
more easily fix up the rest of the file systems during the next merge
window.  (Originally we had hopped to remove the use of s_dirt from
ext4 during this merge window, but his patches had some bugs, so I
ultimately ended dropping them from the ext4 tree.)

----------------------------------------------------------------
Allison Henderson (1):
      ext4: correct ext4_punch_hole return codes

Artem Bityutskiy (5):
      ext4: do not mark superblock as dirty unnecessarily
      ext4: write superblock only once on unmount
      ext4: remove useless s_dirt assignment
      mm: export dirty_writeback_interval
      vfs: remove unused superblock helpers

Bobi Jam (1):
      ext4: expand commit callback and

Curt Wohlgemuth (3):
      ext4: mark possibly unused variable in ext4_mb_normalize_request()
      ext4: don't release page refs in ext4_end_bio()
      ext4: add comments to definition of ext4_io_end_t

Dan Carpenter (2):
      ext4: remove an unneeded NULL check in __ext4_check_dir_entry()
      ext4: using PTR_ERR() on the wrong variable in ext4_ext_migrate()

Darrick J. Wong (1):
      ext4: update s_free_{inodes,blocks}_count during online resize

Eric Sandeen (4):
      jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
      ext4: remove the journal=update mount option
      ext4: remove the resize mount option
      ext4: avoid deadlock on sync-mounted FS w/o journal

Heiko Carstens (1):
      ext4: fix balloc.c printk-format-warning

Jan Kara (8):
      jbd2: split updating of journal superblock and marking journal empty
      jbd2: protect all log tail updates with j_checkpoint_mutex
      jbd2: issue cache flush after checkpointing even with internal journal
      jbd2: fix BH_JWrite setting in checkpointing code
      jbd2: declare __jbd2_journal_temp_unlink_buffer() static
      jbd2: remove always true condition in __journal_try_to_free_buffer()
      jbd2: remove bh_state lock from checkpointing code
      jbd2: cleanup journal tail after transaction commit

Jeff Moyer (3):
      ext4: fix race between unwritten extent conversion and truncate
      ext4: clean up the flags passed to __blockdev_direct_IO
      ext4: fix race between sync and completed io work

Joe Perches (3):
      ext4: remove redundant "EXT4-fs: " from uses of ext4_msg
      ext4: add no_printk argument validation, fix fallout
      ext4: avoid output message interleaving in ext4_error_<foo>()

Lukas Czerner (9):
      ext4: ignore EXT4_INODE_JOURNAL_DATA flag with delalloc
      ext4: fix resize when resizing within single group
      ext4: rewrite punch hole to use ext4_ext_remove_space()
      ext4: remove unused code from ext4_ext_map_blocks()
      ext4: give more helpful error message in ext4_ext_rm_leaf()
      ext4: fix start and len arguments handling in ext4_trim_fs()
      ext4: fix trimmed block count accunting
      ext4: always set then trimmed blocks count into len
      ext4: remove restrictive checks for EOFBLOCKS_FL

Santosh Nayak (1):
      ext4: Fix endianness bug when reading the MMP block

Seiji Aguchi (1):
      jbd2: add drop_transaction/update_superblock_end tracepoints

Theodore Ts'o (18):
      ext4: fold ext4_claim_inode into ext4_new_inode
      ext4: fix race when setting bitmap_uptodate flag
      ext4: fix INCOMPAT feature codepoint reservation for INLINEDATA
      ext4: remove EXT4_MB_{BITMAP,BUDDY} macros
      ext4: remove deprecation warnings for minix_df and grpid
      ext4: remove Opt_ignore
      ext4: remove the I_VERSION mount flag and use the super_block flag instead
      ext4: simplify handling of the errors=* mount options
      ext4: unify handling of mount options which have been removed
      ext4: use a table-driven handler for mount options
      ext4: move ext4_show_options() after parse_options()
      ext4: make ext4_show_options() be table-driven
      ext4: add debugging /proc file showing file system options
      ext4: ignore mount options supported by ext2/3 (but have since been removed)
      ext4: try to deprecate noacl and noxattr_user mount options
      ext4: check for zero length extent
      ext4: remove trailing newlines from ext4_msg() and ext4_error() messages
      ext4: change some printk() calls to use ext4_msg() instead

Yongqiang Yang (3):
      jbd2: allocate transaction from separate slab cache
      jbd2: rename functions which initialize slab caches
      jbd2: use KMEM_CACHE instead of kmem_cache_create()

Zheng Liu (2):
      ext4: remove unneeded variable in ext4_xattr_check_block()
      ext4: format flag in dx_probe()

 Documentation/filesystems/ext4.txt |    8 -
 fs/ext4/balloc.c                   |   63 ++-
 fs/ext4/dir.c                      |   13 +-
 fs/ext4/ext4.h                     |   34 +-
 fs/ext4/ext4_extents.h             |    4 +-
 fs/ext4/ext4_jbd2.h                |  128 ++++-
 fs/ext4/extents.c                  |  330 +++++-------
 fs/ext4/fsync.c                    |    2 +
 fs/ext4/ialloc.c                   |  260 ++++-----
 fs/ext4/inode.c                    |   95 ++--
 fs/ext4/mballoc.c                  |  342 +++++-------
 fs/ext4/mballoc.h                  |   20 +-
 fs/ext4/migrate.c                  |    2 +-
 fs/ext4/mmp.c                      |    4 +-
 fs/ext4/namei.c                    |    2 +-
 fs/ext4/page-io.c                  |   18 +-
 fs/ext4/resize.c                   |   37 +-
 fs/ext4/super.c                    | 1075 ++++++++++++++++--------------------
 fs/ext4/xattr.c                    |   25 +-
 fs/jbd2/checkpoint.c               |  140 +----
 fs/jbd2/commit.c                   |   47 ++-
 fs/jbd2/journal.c                  |  361 ++++++++-----
 fs/jbd2/recovery.c                 |    5 +-
 fs/jbd2/revoke.c                   |   12 +-
 fs/jbd2/transaction.c              |   48 ++-
 include/linux/fs.h                 |   13 -
 include/linux/jbd2.h               |   12 +-
 include/linux/journal-head.h       |    2 +
 include/trace/events/jbd2.h        |   29 +-
 mm/page-writeback.c                |    2 +
 30 files changed, 1522 insertions(+), 1611 deletions(-)
