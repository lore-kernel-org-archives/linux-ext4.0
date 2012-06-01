From: "Theodore Ts'o" <tytso@mit.edu>
Subject: GIT PULL] ext4 updates for 3.5
Date: Fri, 01 Jun 2012 11:07:58 -0400
Message-ID: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Sorry this is so late... it's been a crazily busy May...

	      	 	      	   - Ted


The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

for you to fetch changes up to 5e44f8c374dc4f8eadf61cd18b2c0d46bc87c1b7:

  ext4: hole-punch use truncate_pagecache_range (2012-06-01 00:15:28 -0400)

----------------------------------------------------------------
Ext4 updates for 3.5

The major new feature added in this update is Darrick J. Wong's
metadata checksum feature, which adds crc32 checksums to ext4's
metadata fields.  There is also the usual set of cleanups and bug
fixes.

----------------------------------------------------------------
Akira Fujita (1):
      ext4: remove needs_recovery in ext4_mb_init()

Andreas Dilger (1):
      ext4: disallow hard-linked directory in ext4_lookup

Dan Carpenter (1):
      ext4: fix potential NULL dereference in ext4_free_inodes_counts()

Darrick J. Wong (23):
      ext4: create a new BH_Verified flag to avoid unnecessary metadata validation
      ext4: change on-disk layout to support extended metadata checksumming
      ext4: record the checksum algorithm in use in the superblock
      ext4: load the crc32c driver if necessary
      ext4: calculate and verify superblock checksum
      ext4: calculate and verify inode checksums
      ext4: calculate and verify checksums for inode bitmaps
      ext4: calculate and verify block bitmap checksum
      ext4: verify and calculate checksums for extent tree  blocks
      ext4: Calculate and verify checksums for htree nodes
      ext4: calculate and verify checksums of directory leaf blocks
      ext4: Calculate and verify checksums of extended attribute blocks
      ext4: make block group checksums use metadata_csum algorithm
      ext4: add checksums to the MMP block
      jbd2: change disk layout for metadata checksumming
      jbd2: enable journal clients to enable v2 checksumming
      jbd2: Grab a reference to the crc32c driver if necessary
      jbd2: checksum journal superblock
      jbd2: checksum revocation blocks
      jbd2: checksum descriptor blocks
      jbd2: checksum commit blocks
      jbd2: checksum data blocks that are stored in the journal
      ext4/jbd2: add metadata checksumming to the list of supported features

Eric Sandeen (1):
      ext4: force ro mount if ext4_setup_super() fails

Haogang Chen (1):
      ext4: fix potential integer overflow in alloc_flex_gd()

Hugh Dickins (1):
      ext4: hole-punch use truncate_pagecache_range

Salman Qazi (2):
      ext4: add ext4_mb_unload_buddy in the error path
      ext4: remove mb_groups before tearing down the buddy_cache

Tao Ma (2):
      ext4: protect group inode free counting with group lock
      ext4: let getattr report the right blocks in delalloc+bigalloc

Theodore Ts'o (7):
      ext4: remove unnecessary check in add_dirent_to_buf()
      ext4: enable the 64-bit jbd2 feature based on the 64-bit ext4 feature
      ext4: remove redundundant "(char *) bh->b_data" casts
      ext4: return ENOMEM when mounts fail due to lack of memory
      ext4: add debugging trigger for ext4_error()
      ext4: add missing save_error_info() to ext4_error()
      ext4: don't trash state flags in EXT4_IOC_SETFLAGS

Wanlong Gao (1):
      jbd2: use kmem_cache_zalloc wrapper instead of flag

Zheng Liu (3):
      ext4: cleanup in ext4_discard_allocated_blocks()
      ext4: fix format flag in ext4_ext_binsearch_idx()
      ext4: use consistent ssize_t type in ext4_file_write()

 fs/ext4/Kconfig            |   2 +
 fs/ext4/balloc.c           |  41 ++++-
 fs/ext4/bitmap.c           |  83 +++++++++
 fs/ext4/dir.c              |  12 ++
 fs/ext4/ext4.h             | 130 +++++++++++--
 fs/ext4/ext4_extents.h     |  24 +++
 fs/ext4/ext4_jbd2.c        |   9 +-
 fs/ext4/ext4_jbd2.h        |   7 +-
 fs/ext4/extents.c          |  91 +++++++--
 fs/ext4/file.c             |   2 +-
 fs/ext4/ialloc.c           |  81 +++++++--
 fs/ext4/inode.c            | 119 ++++++++++--
 fs/ext4/ioctl.c            |  19 +-
 fs/ext4/mballoc.c          |  30 +--
 fs/ext4/mmp.c              |  44 ++++-
 fs/ext4/namei.c            | 445 ++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/resize.c           |  71 +++++++-
 fs/ext4/super.c            | 253 +++++++++++++++++++++-----
 fs/ext4/xattr.c            |  92 ++++++++--
 fs/ext4/xattr.h            |   4 +-
 fs/jbd2/Kconfig            |   2 +
 fs/jbd2/commit.c           |  70 ++++++-
 fs/jbd2/journal.c          | 132 +++++++++++++-
 fs/jbd2/recovery.c         | 126 ++++++++++++-
 fs/jbd2/revoke.c           |  27 ++-
 fs/jbd2/transaction.c      |   4 +-
 include/linux/jbd2.h       |  59 +++++-
 include/linux/jbd_common.h |   2 +
 28 files changed, 1784 insertions(+), 197 deletions(-)
