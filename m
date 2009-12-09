From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for v2.6.33
Date: Wed, 09 Dec 2009 11:10:41 -0500
Message-ID: <E1NIP7h-0002Tv-AP@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820AbZLIQKo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 11:10:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following changes for v2.6.33.

Lots of bug fixes, plus some cleanup work.

Thanks!!

                                                        - Ted

 Documentation/filesystems/ext4.txt |   10 +-
 fs/ext4/Kconfig                    |   10 ++
 fs/ext4/balloc.c                   |   46 +-----
 fs/ext4/block_validity.c           |    3 +-
 fs/ext4/ext4.h                     |   23 ++-
 fs/ext4/ext4_jbd2.c                |   82 ++++++++---
 fs/ext4/ext4_jbd2.h                |   44 ++++---
 fs/ext4/extents.c                  |   40 +++---
 fs/ext4/fsync.c                    |   54 +++-----
 fs/ext4/inode.c                    |  193 +++++++++++--------------
 fs/ext4/ioctl.c                    |   29 +++--
 fs/ext4/mballoc.c                  |  101 ++++++++++---
 fs/ext4/migrate.c                  |   27 +++-
 fs/ext4/move_extent.c              |  282 +++++++++++++++++-------------------
 fs/ext4/namei.c                    |   38 ++---
 fs/ext4/resize.c                   |    2 +-
 fs/ext4/super.c                    |  118 +++++++++++----
 fs/ext4/xattr.c                    |   15 +-
 fs/jbd2/commit.c                   |    4 +
 fs/jbd2/journal.c                  |   11 ++
 include/trace/events/ext4.h        |   54 +++++--
 21 files changed, 674 insertions(+), 512 deletions(-)

Akira Fujita (7):
      ext4: fix the returned block count if EXT4_IOC_MOVE_EXT fails
      ext4: fix lock order problem in ext4_move_extents()
      ext4: fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
      ext4: fix spelling typos in move_extent.c
      ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
      ext4: move_extent_per_page() cleanup
      ext4: Fix insufficient checks in EXT4_IOC_MOVE_EXT

Curt Wohlgemuth (1):
      ext4: remove blocks from inode prealloc list on failure

Dmitry Monakhov (3):
      ext4: ext4_get_reserved_space() must return bytes instead of blocks
      ext4: quota macros cleanup
      ext4: fix incorrect block reservation on quota transfer.

Eric Sandeen (3):
      ext4: journal all modifications in ext4_xattr_set_handle
      ext4: make trim/discard optional (and off by default)
      ext4: make "norecovery" an alias for "noload"

Jan Kara (3):
      ext4: fix error handling in ext4_ind_get_blocks()
      ext4: Avoid data / filesystem corruption when write fails to copy data
      ext4: Wait for proper transaction commit on fsync

Josef Bacik (1):
      ext4: wait for log to commit when umounting

Julia Lawall (1):
      ext4: fix i_flags access in ext4_da_writepages_trans_blocks()

Kazuya Mio (1):
      ext4: initialize moved_len before calling ext4_move_extents()

Roel Kluin (1):
      ext4: Return the PTR_ERR of the correct pointer in setup_new_group_blocks()

Theodore Ts'o (21):
      ext4: fix potential buffer head leak when add_dirent_to_buf() returns ENOSPC
      ext4: avoid divide by zero when trying to mount a corrupted file system
      ext4: plug a buffer_head leak in an error path of ext4_iget()
      jbd2: don't wipe the journal on a failed journal checksum
      ext4: remove failed journal checksum check
      ext4: add tracepoint for ext4_forget()
      ext4: make sure directory and symlink blocks are revoked
      ext4: don't update the superblock in ext4_statfs()
      ext4: fix uninit block bitmap initialization when s_meta_first_bg is non-zero
      ext4: fix block validity checks so they work correctly with meta_bg
      ext4: avoid issuing unnecessary barriers
      ext4: move ext4_forget() to ext4_jbd2.c
      ext4: fold ext4_journal_revoke() into ext4_forget()
      ext4: fold ext4_journal_forget() into ext4_forget()
      ext4: fold ext4_free_blocks() and ext4_mb_free_blocks()
      ext4: call ext4_forget() from ext4_free_blocks()
      ext4: print i_mode in octal in ext4 tracepoints
      ext4: add check for wraparound in ext4_data_block_valid()
      ext4: use ext4_data_block_valid() in ext4_free_blocks()
      jbd2: Add ENOMEM checking in and for jbd2_journal_write_metadata_buffer()
      ext4: Use ext4 file system driver for ext2/ext3 file system mounts

Wu Fengguang (2):
      ext4: remove encountered_congestion trace
      ext4: remove unused parameter wbc from __ext4_journalled_writepage()

