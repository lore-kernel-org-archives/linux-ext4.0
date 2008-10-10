From: "Theodore Ts'o" <tytso@mit.edu>
Subject: New ext4 patchset: 2.6.27-ext4-1
Date: Fri, 10 Oct 2008 00:38:31 -0400
Message-ID: <E1Ko9ln-0004sS-UM@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56362 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbYJJEie (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 00:38:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This new patchset adds better documentation for ext4 mount options and
/proc/fs/ext4 files, and corrects the git commit authorship for a new
patches in preparation for pushing to Linus.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.27-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.27-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.27-ext4-1

                                                        - Ted

Akira Fujita (7):
      ext4: online defrag: Add the EXT4_IOC_DEFRAG ioctl and defrag main function.
      ext4: Fix compile error at defrag.c in the current ext4 patch
      ext4: online defrag: Allocate new contiguous blocks with mballoc.
      ext4: online defrag: Read and write file data with memory page.
      ext4: online defrag: Exchange the blocks between two inodes.
      ext4: online defrag: Add the EXT4_IOC_FIBMAP ioctl.
      ext4: online defrag: Add the EXT4_IOC_GROUP_INFO ioctl.

Alexey Dobriyan (1):
      ext4: fix #11321: create /proc/ext4/*/stats more carefully

Andi Kleen (1):
      ext4: Avoid double dirtying of super block in ext4_put_super()

Aneesh Kumar K.V (14):
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
      ext4: undo the stable boundary patch changes

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

Theodore Ts'o (19):
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
      ext4: Stable/Unstable boundary
      Add a ioctl which dumps out all of the in-use buffer heads for a block device
      ext4: akpm's locking hack to fix locking delays

 Documentation/filesystems/ext4.txt   |    6 +
 Documentation/filesystems/fiemap.txt |  228 ++++++
 Documentation/filesystems/proc.txt   |   73 +-
 MAINTAINERS                          |    5 +-
 block/compat_ioctl.c                 |    1 +
 block/ioctl.c                        |    5 +
 fs/Kconfig                           |   74 +-
 fs/Makefile                          |    2 +-
 fs/buffer.c                          |   40 +
 fs/ext2/ext2.h                       |    2 +
 fs/ext2/file.c                       |    1 +
 fs/ext2/inode.c                      |    8 +
 fs/ext3/file.c                       |    1 +
 fs/ext3/inode.c                      |    8 +
 fs/ext4/Makefile                     |   12 +-
 fs/ext4/acl.h                        |   12 +-
 fs/ext4/balloc.c                     | 1457 ++-------------------------------
 fs/ext4/bitmap.c                     |    6 +-
 fs/ext4/defrag.c                     | 1495 ++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                        |   64 +-
 fs/ext4/ext4.h                       |  155 +++-
 fs/ext4/ext4_extents.h               |   20 +
 fs/ext4/ext4_i.h                     |   39 +-
 fs/ext4/ext4_sb.h                    |   25 +-
 fs/ext4/extents.c                    |  287 ++++++-
 fs/ext4/file.c                       |   10 +-
 fs/ext4/fsync.c                      |    7 +-
 fs/ext4/hash.c                       |    8 +-
 fs/ext4/ialloc.c                     |   71 +-
 fs/ext4/inode.c                      |  622 +++++++++------
 fs/ext4/ioctl.c                      |   89 +--
 fs/ext4/mballoc.c                    |  208 ++----
 fs/ext4/mballoc.h                    |    1 -
 fs/ext4/migrate.c                    |   10 +-
 fs/ext4/namei.c                      |  402 +++++-----
 fs/ext4/resize.c                     |   33 +-
 fs/ext4/super.c                      |  257 ++++--
 fs/ext4/symlink.c                    |    8 +-
 fs/ext4/xattr.c                      |   14 +-
 fs/ext4/xattr.h                      |   12 +-
 fs/ioctl.c                           |  273 +++++++
 fs/jbd2/checkpoint.c                 |   22 +-
 fs/jbd2/commit.c                     |   22 +-
 fs/jbd2/journal.c                    |   75 +-
 fs/jbd2/transaction.c                |   12 +-
 fs/ocfs2/alloc.c                     |    9 -
 fs/ocfs2/alloc.h                     |    9 +
 fs/ocfs2/extent_map.c                |  346 +++++++--
 fs/ocfs2/extent_map.h                |    3 +
 fs/ocfs2/file.c                      |    1 +
 include/linux/buffer_head.h          |    1 +
 include/linux/ext3_fs.h              |    2 +
 include/linux/fiemap.h               |   64 ++
 include/linux/fs.h                   |   22 +
 include/linux/jbd2.h                 |    4 +-
 include/linux/percpu_counter.h       |   12 +-
 lib/percpu_counter.c                 |    8 +-
 57 files changed, 4127 insertions(+), 2536 deletions(-)
