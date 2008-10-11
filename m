From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 2.6.28
Date: Sat, 11 Oct 2008 00:16:25 -0400
Message-ID: <E1KoVtx-0002EB-46@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50414 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbYJKEQ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 00:16:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

In addition to many bug fixes and performance improvements for ext4,
this patch set also contains the FIEMAP ioctl.  The changes to ocfs2 to
support the generic FIEMAP interface were written and approved by Mark
Fasheh from the OCFS2 community.  In addition, the percpu cleanup (which
is in the ext4 tree because a number of follow-on ext4 patches depend on
it) was signed-off or acked by Andrew Morton as well as Peter Zijlstra.

Thanks!!

                                                - Ted



Alexey Dobriyan (1):
      ext4: fix #11321: create /proc/ext4/*/stats more carefully

Andi Kleen (1):
      ext4: Avoid double dirtying of super block in ext4_put_super()

Aneesh Kumar K.V (13):
      ext4: invalidate pages if delalloc block allocation fails.
      ext4: Make sure all the block allocation paths reserve blocks
      ext4: Retry block reservation
      ext4: Add percpu dirty block accounting.
      ext4: Switch to non delalloc mode when we are low on free blocks count.
      ext4: Signed arithmetic fix
      ext4: Fix ext4 nomballoc allocator for ENOSPC
      ext4: Don't add the inode to journal handle until after the block is allocated
      ext4: Retry block allocation if we have free blocks left
      ext4: truncate block allocated on a failed ext4_write_begin
      ext4: Properly update i_disksize.
      ext4: elevate write count for migrate ioctl
      ext4: hook the ext3 migration interface to the EXT4_IOC_SETFLAGS ioctl

Duane Griffin (1):
      jbd2: abort instead of waiting for nonexistent transaction

Eric Sandeen (3):
      ext4: Avoid printk floods in the face of directory corruption
      ext4: use percpu data structures for lg_prealloc_list
      Hook ext4 to the vfs fiemap interface.

Frederic Bohe (2):
      Update flex_bg free blocks and free inodes counters when resizing.
      ext4: fix initialization of UNINIT bitmap blocks

Josef Bacik (1):
      generic block based fiemap implementation

Kalpak Shah (1):
      ext4: fix xattr deadlock

Li Zefan (1):
      ext4: add missing unlock in ext4_check_descriptors() on error path

Mark Fasheh (2):
      vfs: vfs-level fiemap interface
      ocfs2: fiemap support

Mingming Cao (1):
      percpu counter: clean up percpu_counter_sum_and_set()

Theodore Ts'o (16):
      ext4: Add printk priority levels to clean up checkpatch warnings
      ext4: Fix long long checkpatch warnings
      ext4: Fix whitespace checkpatch warnings/errors
      jbd2: clean up how the journal device name is printed
      ext4: Renumber EXT4_IOC_MIGRATE
      ext4/jbd2: Avoid WARN() messages when failing to write to the superblock
      ext4: Don't use 'struct dentry' for internal lookups
      ext4: move /proc setup and teardown out of mballoc.c
      ext4: Combine proc file handling into a single set of functions
      ext4: Improve the documentation for ext4's /proc tunables
      ext4: Use readahead when reading an inode from the inode table
      ext4: Remove old legacy block allocator
      ext4: Add debugging markers that can be used by systemtap
      jbd2: Fix buffer head leak when writing the commit block
      Update ext4 MAINTAINERS file
      ext4: Rename ext4dev to ext4

 Documentation/filesystems/ext4.txt   |   14 +-
 Documentation/filesystems/fiemap.txt |  228 ++++++
 Documentation/filesystems/proc.txt   |   73 +-
 MAINTAINERS                          |    5 +-
 fs/Kconfig                           |   88 ++-
 fs/Makefile                          |    2 +-
 fs/ext2/ext2.h                       |    2 +
 fs/ext2/file.c                       |    1 +
 fs/ext2/inode.c                      |    8 +
 fs/ext3/file.c                       |    1 +
 fs/ext3/inode.c                      |    8 +
 fs/ext4/Makefile                     |   10 +-
 fs/ext4/acl.h                        |   12 +-
 fs/ext4/balloc.c                     | 1457 +++-------------------------------
 fs/ext4/bitmap.c                     |    6 +-
 fs/ext4/dir.c                        |   64 +-
 fs/ext4/ext4.h                       |  131 ++--
 fs/ext4/ext4_extents.h               |   15 +
 fs/ext4/ext4_i.h                     |   39 +-
 fs/ext4/ext4_sb.h                    |   25 +-
 fs/ext4/extents.c                    |  281 ++++++-
 fs/ext4/file.c                       |   10 +-
 fs/ext4/fsync.c                      |    7 +-
 fs/ext4/hash.c                       |    8 +-
 fs/ext4/ialloc.c                     |   71 +-
 fs/ext4/inode.c                      |  620 +++++++++------
 fs/ext4/ioctl.c                      |   84 +--
 fs/ext4/mballoc.c                    |  220 ++----
 fs/ext4/mballoc.h                    |    1 -
 fs/ext4/migrate.c                    |   10 +-
 fs/ext4/namei.c                      |  402 +++++-----
 fs/ext4/resize.c                     |   33 +-
 fs/ext4/super.c                      |  274 +++++--
 fs/ext4/symlink.c                    |    8 +-
 fs/ext4/xattr.c                      |   14 +-
 fs/ext4/xattr.h                      |   12 +-
 fs/ioctl.c                           |  273 +++++++
 fs/jbd2/checkpoint.c                 |   22 +-
 fs/jbd2/commit.c                     |   22 +-
 fs/jbd2/journal.c                    |   75 +-
 fs/ocfs2/alloc.c                     |    9 -
 fs/ocfs2/alloc.h                     |    9 +
 fs/ocfs2/extent_map.c                |  346 +++++++--
 fs/ocfs2/extent_map.h                |    3 +
 fs/ocfs2/file.c                      |    1 +
 include/linux/ext3_fs.h              |    2 +
 include/linux/fiemap.h               |   64 ++
 include/linux/fs.h                   |   21 +
 include/linux/jbd2.h                 |    3 +-
 include/linux/percpu_counter.h       |   12 +-
 lib/percpu_counter.c                 |    8 +-
 51 files changed, 2581 insertions(+), 2533 deletions(-)
