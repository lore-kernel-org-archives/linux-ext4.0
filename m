From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] more ext4 updates
Date: Thu, 18 Jun 2009 12:51:12 -0400
Message-ID: <E1MHKpU-0007FN-RQ@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59492 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZFRQvV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jun 2009 12:51:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the following updates for ext4.

                                                - Ted


Akira Fujita (1):
      ext4: online defrag -- Add EXT4_IOC_MOVE_EXT ioctl

Andreas Dilger (1):
      ext4: teach the inode allocator to use a goal inode number

Hisashi Hifumi (1):
      jbd2: clean up jbd2_journal_try_to_free_buffers()

Linus Torvalds (1):
      ext3: avoid unnecessary spinlock in critical POSIX ACL path

Theodore Ts'o (11):
      jbd2: convert instrumentation from markers to tracepoints
      ext4: convert instrumentation from markers to tracepoints
      ext4: avoid unnecessary spinlock in critical POSIX ACL path
      ext4: change s_mount_opt to be an unsigned int
      ext4: update the s_last_mounted field in the superblock
      ext4: move the abort flag from s_mount_opts to s_mount_flags
      ext4: document the "abort" mount option
      ext4: Use a hash of the topdir directory name for the Orlov parent group
      ext4: Fix 64-bit block type problem on 32-bit platforms
      ext4: Fix up whitespace issues in fs/ext4/inode.c
      ext4: Don't update ctime for non-extent-mapped inodes

 Documentation/ABI/testing/sysfs-fs-ext4 |   10 +
 Documentation/filesystems/ext4.txt      |    4 +
 fs/ext3/acl.c                           |   13 +-
 fs/ext4/Makefile                        |    2 +-
 fs/ext4/acl.c                           |   15 +-
 fs/ext4/ext4.h                          |   39 +-
 fs/ext4/ext4_extents.h                  |    4 +
 fs/ext4/extents.c                       |    4 +-
 fs/ext4/file.c                          |   36 +-
 fs/ext4/fsync.c                         |    8 +-
 fs/ext4/ialloc.c                        |   48 +-
 fs/ext4/inode.c                         |  281 +++----
 fs/ext4/ioctl.c                         |   36 +
 fs/ext4/mballoc.c                       |   85 +--
 fs/ext4/mballoc.h                       |    1 -
 fs/ext4/migrate.c                       |    8 +-
 fs/ext4/move_extent.c                   | 1320 +++++++++++++++++++++++++++++++
 fs/ext4/namei.c                         |   10 +-
 fs/ext4/super.c                         |   20 +-
 fs/jbd2/checkpoint.c                    |    5 +-
 fs/jbd2/commit.c                        |   13 +-
 fs/jbd2/journal.c                       |   69 ++
 fs/jbd2/transaction.c                   |   49 --
 include/linux/jbd2.h                    |    6 +
 include/trace/events/ext4.h             |  719 +++++++++++++++++
 include/trace/events/jbd2.h             |  168 ++++
 26 files changed, 2638 insertions(+), 335 deletions(-)
