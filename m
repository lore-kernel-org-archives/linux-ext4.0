From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.35
Date: Wed, 26 May 2010 13:59:09 -0400
Message-ID: <E1OHKsn-000139-Nz@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57780 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZR7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 13:59:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the latest bug fixes and improvements for the 2.6.36 merge
window.

There are two minor quota changes that Jan has approved and were carried
in the ext4 tree since there was a bigger ext4 patch which depended on
the quota changes.

I've done a quick trial merge and there was a relatively minor
conflict.  My suggest resolution is appended.

Thanks,

					- Ted


Ben Hutchings (2):
      ext4: Conditionally define compat ioctl numbers
      ext4: Fix compat EXT4_IOC_ADD_GROUP

Christian Borntraeger (1):
      ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode

Curt Wohlgemuth (4):
      ext4: Print mount options in when mounting and add a remount message
      ext4: Remove extraneous newlines in ext4_msg() calls
      ext4: check for a good block group before loading buddy pages
      ext4: Fix for ext4_mb_collect_stats()

Dmitry Monakhov (8):
      ext4: check missed return value in ext4_sync_file()
      ext4: fix quota accounting in case of fallocate
      ext4: symlink must be handled via filesystem specific operation
      ext4: Do not zero out uninitialized extents beyond i_size
      ext4: clean up inode bitmaps manipulation in ext4_free_inode
      ext4: init statistics after journal recovery
      ext4: Use bitops to read/modify i_flags in struct ext4_inode_info
      ext4: restart ext4_ext_remove_space() after transaction restart

Eric Sandeen (7):
      ext4: check s_log_groups_per_flex in online resize code
      ext4: don't return to userspace after freezing the fs with a mutex held
      ext4: stop issuing discards if not supported by device
      ext4: don't scan/accumulate more pages than mballoc will allocate
      quota: use flags interface for dquot alloc/free space
      quota: add the option to not fail with EDQUOT in block
      ext4: don't use quota reservation for speculative metadata

Frank Mayhar (1):
      ext4: Make fsync sync new parent directories in no-journal mode

Jan Kara (1):
      ext4: Show journal_checksum option

Jing Zhang (3):
      ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
      ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
      ext4: rename ext4_mb_release_desc() to ext4_mb_unload_buddy()

Li Zefan (2):
      ext4: Add a missing trace hook
      tracing: Convert more ext4 events to DEFINE_EVENT

Nikanth Karthikesan (1):
      ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate

Steven Liu (1):
      ext4: Fix coding style in fs/ext4/move_extent.c

Theodore Ts'o (9):
      jbd2: Improve scalability by not taking j_state_lock in jbd2_journal_stop()
      ext4: Use our own write_cache_pages()
      ext4: Add new abstraction ext4_map_blocks() underneath ext4_get_blocks()
      ext4: Convert callers of ext4_get_blocks() to use ext4_map_blocks()
      ext4: Convert calls of ext4_error() to EXT4_ERROR_INODE()
      ext4: Avoid crashing on NULL ptr dereference on a filesystem error
      ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
      ext4: Add new tracepoints to track mballoc's buddy bitmap loads
      ext4: Drop whitespace at end of lines

 fs/ext4/balloc.c            |    5 +-
 fs/ext4/block_validity.c    |    4 +-
 fs/ext4/dir.c               |   26 +-
 fs/ext4/ext4.h              |  167 +++++++++--
 fs/ext4/ext4_jbd2.h         |    8 +-
 fs/ext4/extents.c           |  417 ++++++++++++++-----------
 fs/ext4/file.c              |    2 +-
 fs/ext4/fsync.c             |   35 ++-
 fs/ext4/ialloc.c            |   89 +++---
 fs/ext4/inode.c             |  723 ++++++++++++++++++++++---------------------
 fs/ext4/ioctl.c             |   27 ++-
 fs/ext4/mballoc.c           |  120 +++++--
 fs/ext4/migrate.c           |    2 +-
 fs/ext4/move_extent.c       |   13 +-
 fs/ext4/namei.c             |   61 ++--
 fs/ext4/resize.c            |    3 +-
 fs/ext4/super.c             |   80 +++---
 fs/ext4/symlink.c           |    2 +
 fs/ext4/xattr.c             |   39 +--
 fs/jbd2/transaction.c       |    5 +-
 fs/quota/dquot.c            |   11 +-
 include/linux/quotaops.h    |   37 ++-
 include/trace/events/ext4.h |   94 +++---
 23 files changed, 1136 insertions(+), 834 deletions(-)


commit dca730ba7f7dcd29bda2175cd6214305800f1469
Merge: 63a6440 14ece10
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed May 26 13:58:15 2010 -0400

    Merge branch 'for_linus' of /usr/projects/linux/ext4
    
    Conflicts:
    	fs/ext4/fsync.c

diff --cc fs/ext4/fsync.c
index ef3d980,e187f87..b6a74f9
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@@ -100,11 -127,9 +127,11 @@@ int ext4_sync_file(struct file *file, s
  		if (ext4_should_writeback_data(inode) &&
  		    (journal->j_fs_dev != journal->j_dev) &&
  		    (journal->j_flags & JBD2_BARRIER))
 -			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 +			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 +					NULL, BLKDEV_IFL_WAIT);
- 		jbd2_log_wait_commit(journal, commit_tid);
+ 		ret = jbd2_log_wait_commit(journal, commit_tid);
  	} else if (journal->j_flags & JBD2_BARRIER)
 -		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 +		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
 +			BLKDEV_IFL_WAIT);
  	return ret;
  }
