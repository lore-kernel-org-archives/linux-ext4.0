From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 2.6.30
Date: Wed, 01 Apr 2009 12:33:42 -0400
Message-ID: <E1Lp3Nm-0006eh-Pe@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60141 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760018AbZDAQdu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 12:33:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks!

                                                - Ted

 Documentation/ABI/testing/sysfs-fs-ext4 |   81 ++++++
 Documentation/filesystems/ext4.txt      |   30 ++-
 Documentation/filesystems/proc.txt      |   21 --
 fs/ext4/balloc.c                        |   14 +-
 fs/ext4/dir.c                           |   16 +-
 fs/ext4/ext4.h                          |   91 +++----
 fs/ext4/ext4_extents.h                  |    1 +
 fs/ext4/ext4_i.h                        |    6 +-
 fs/ext4/ext4_sb.h                       |   14 +-
 fs/ext4/extents.c                       |  127 ++++++++--
 fs/ext4/file.c                          |    7 +-
 fs/ext4/ialloc.c                        |  273 ++++++++++++++------
 fs/ext4/inode.c                         |  424 +++++++++++++++++++------------
 fs/ext4/ioctl.c                         |   17 +-
 fs/ext4/mballoc.c                       |  158 ++++--------
 fs/ext4/mballoc.h                       |    8 +-
 fs/ext4/namei.c                         |  164 ++++++++----
 fs/ext4/resize.c                        |    8 +-
 fs/ext4/super.c                         |  327 +++++++++++++++++++-----
 fs/jbd2/commit.c                        |    5 +-
 fs/jbd2/revoke.c                        |   24 ++-
 fs/jbd2/transaction.c                   |    2 +
 include/linux/jbd2.h                    |    6 +
 23 files changed, 1224 insertions(+), 600 deletions(-)


Aneesh Kumar K.V (4):
      ext4: Add checks to validate extent entries.
      ext4: Validate extent details only when read from the disk
      ext4: Fix discard of inode prealloc space with delayed allocation.
      ext4: Rename pa_linear to pa_type

Bryan Donlan (1):
      ext4: return -EIO not -ESTALE on directory traversal through deleted inode

Dan Carpenter (1):
      ext4: fix typo which causes a memory leak on error path

Duane Griffin (2):
      ext4: don't inherit inappropriate inode flags from parent
      ext4: tighten restrictions on inode flags

Jan Kara (1):
      jbd2: Update locking coments

Mike Snitzer (1):
      ext4: Remove stale block allocator references from ext4.h

Pekka Enberg (1):
      ext4: allocate ->s_blockgroup_lock separately

Theodore Ts'o (20):
      ext4: remove call to ext4_group_desc() in ext4_group_used_meta_blocks()
      ext4: Use unsigned int for blocksize in dx_make_map() and dx_pack_dirents()
      ext4: New inode/block allocation algorithms for flex_bg filesystems
      ext4: Add fine print for the 32000 subdirectory limit
      ext4: Simplify delalloc implementation by removing mpd.get_block
      ext4: Save stack space by removing fake buffer heads
      ext4: Simplify delalloc code by removing mpage_da_writepages()
      ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
      ext4: Automatically allocate delay allocated blocks on close
      ext4: Automatically allocate delay allocated blocks on rename
      ext4: Track lifetime disk writes
      ext4: Add sysfs support
      ext4: remove /proc tuning knobs
      ext4: Use atomic_t's in struct flex_groups
      ext4: Use struct flex_groups to calculate get_orlov_stats()
      ext4: Add auto_da_alloc mount option
      ext4: Use WRITE_SYNC for commits which are caused by fsync()
      ext4: Check for an valid i_mode when reading the inode from disk
      ext4: fix locking typo in mballoc which could cause soft lockup hangs
      ext4: Regularize mount options

Thiemo Nagel (1):
      ext4: add checks of block references for non-extent inodes

Wei Yongjun (1):
      ext4: New rec_len encoding for very large blocksizes

