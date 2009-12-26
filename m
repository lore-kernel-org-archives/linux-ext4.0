From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for v2.6.33
Date: Sat, 26 Dec 2009 15:37:37 -0500
Message-ID: <E1NOdOL-0001s1-4J@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33208 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZLZUhl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Dec 2009 15:37:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following bug fixes for v2.6.33.

Thanks!!

							- Ted

 Documentation/filesystems/ext4.txt |    2 +-
 fs/ext4/Kconfig                    |    1 +
 fs/ext4/block_validity.c           |    1 -
 fs/ext4/extents.c                  |   31 ++++++++++++++++++++++++++++---
 fs/ext4/fsync.c                    |   16 ++++++++++++++--
 fs/ext4/inode.c                    |   14 ++++++++++----
 fs/ext4/mballoc.h                  |    1 -
 fs/ext4/super.c                    |    6 ++++--
 fs/ext4/xattr.c                    |    2 ++
 fs/fs-writeback.c                  |   17 +++++++++++++++++
 fs/jbd2/checkpoint.c               |   15 +++++++++++++++
 fs/jbd2/commit.c                   |   19 +++++++++++--------
 fs/jbd2/journal.c                  |    5 +++--
 include/linux/jbd2.h               |    1 +
 include/linux/writeback.h          |    1 +
 15 files changed, 108 insertions(+), 24 deletions(-)

Andrew Morton (2):
      ext4: fix unsigned long long printk warning in super.c
      jbd2: don't use __GFP_NOFAIL in journal_init_common()

Curt Wohlgemuth (1):
      ext4: Ensure zeroout blocks have no dirty metadata

David Howells (1):
      ext4: Don't ask about supporting ext2/3 in ext4 if ext4 is not configured

Eric Sandeen (2):
      fs-writeback: Add helper function to start writeback if idle
      ext4: flush delalloc blocks when space is low

Fang Wenqi (1):
      ext4: Update documentation to correct the inode_readahead_blks option name

Huang Weiyi (1):
      ext4: remove unused #include <linux/version.h>

Julia Lawall (1):
      ext4: Eliminate potential double free on error path

Richard Kennedy (1):
      ext4: return correct wbc.nr_to_write in ext4_da_writepages

Surbhi Palande (1):
      ext4: replace BUG() with return -EIO in ext4_ext_get_blocks

Theodore Ts'o (2):
      ext4: add module aliases for ext2 and ext3
      ext4, jbd2: Add barriers for file systems with exernal journals

Yin, Kangkai (1):
      jbd2: /sys/kernel/debug/jbd2/jbd2-debug should be writable.

