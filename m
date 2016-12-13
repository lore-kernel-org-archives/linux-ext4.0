From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.10
Date: Tue, 13 Dec 2016 15:00:07 -0500
Message-ID: <20161213200007.jczekmqmtknxkfix@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit bc33b0ca11e3df467777a4fa7639ba488c9d4911:

  Linux 4.9-rc4 (2016-11-05 16:23:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to a551d7c8deefb6d9fb45a1de03a617dd064e0419:

  Merge branch 'fscrypt' into dev (2016-12-12 21:50:28 -0500)

----------------------------------------------------------------
This merge request includes the dax-4.0-iomap-pmd branch which is
needed for both ext4 and xfs dax changes to use iomap for DAX.  It
also includes the fscrypt branch which is needed for ubifs encryption
work as well as ext4 encryption and fscrypt cleanups.

Lots of cleanups and bug fixes, especially making sure ext4 is robust
against maliciously corrupted file systems --- especially maliciously
corrupted xattr blocks and a maliciously corrupted superblock.  Also
fix ext4 support for 64k block sizes so it works well on ppcle.  Fixed
mbcache so we don't miss some common xattr blocks that can be merged.

----------------------------------------------------------------
Chandan Rajendra (2):
      ext4: fix mballoc breakage with 64k block size
      ext4: fix stack memory corruption with 64k block size

Daeho Jeong (1):
      ext4: fix inode checksum calculation problem if i_extra_size is small

Dan Carpenter (2):
      ext4: remove another test in ext4_alloc_file_blocks()
      ext4: return -ENOMEM instead of success

Darrick J. Wong (1):
      ext4: reject inodes with negative size

David Gstir (11):
      fscrypt: Add in-place encryption mode
      fscrypt: Allow fscrypt_decrypt_page() to function with non-writeback pages
      fscrypt: Enable partial page encryption
      fscrypt: Constify struct inode pointer
      fscrypt: Let fs select encryption index/tweak
      fscrypt: Use correct index in decrypt path.
      fscrypt: Never allocate fscrypt_ctx on in-place encryption
      fscrypt: Cleanup fscrypt_{decrypt,encrypt}_page()
      fscrypt: Cleanup page locking requirements for fscrypt_{decrypt,encrypt}_page()
      fscrypt: Delay bounce page pool allocation until needed
      fscrypt: Rename FS_WRITE_PATH_FL to FS_CTX_HAS_BOUNCE_BUFFER_FL

Deepa Dinamani (1):
      ext4: use current_time() for inode timestamps

Eric Biggers (16):
      fscrypto: don't use on-stack buffer for filename encryption
      fscrypto: don't use on-stack buffer for key derivation
      ext4: avoid lockdep warning when inheriting encryption context
      ext4: get rid of ext4_sb_has_crypto()
      ext4: disable pwsalt ioctl when encryption disabled by config
      ext4: forbid i_extra_isize not divisible by 4
      ext4: don't read out of bounds when checking for in-inode xattrs
      ext4: correctly detect when an xattr value has an invalid size
      mbcache: correctly handle 'e_referenced' bit
      mbcache: don't BUG() if entry cache cannot be allocated
      mbcache: remove unnecessary module_get/module_put
      mbcache: use consistent type for entry count
      mbcache: document that "find" functions only return reusable entries
      MAINTAINERS: fscrypto: recommend linux-fsdevel for fscrypto patches
      fscrypto: remove unneeded Kconfig dependencies
      fscrypto: move ioctl processing more fully into common code

Eric Sandeen (1):
      ext4: fix mmp use after free during unmount

Eric Whitney (2):
      ext4: allow inode expansion for nojournal file systems
      ext4: remove parameter from ext4_xattr_ibody_set()

Eryu Guan (1):
      ext4: validate s_first_meta_bg at mount time

Fabian Frederick (1):
      Documentation: fix description of ext4's block_validity mount option

Jan Kara (17):
      dax: Introduce IOMAP_FAULT flag
      ext4: factor out checks from ext4_file_write_iter()
      ext4: only set S_DAX if DAX is really supported
      ext4: convert DAX reads to iomap infrastructure
      ext4: use iomap for zeroing blocks in DAX mode
      ext4: DAX iomap write support
      ext4: avoid split extents for DAX writes
      ext4: convert DAX faults to iomap infrastructure
      ext4: rip out DAX handling from direct IO path
      ext2: use iomap_zero_range() for zeroing truncated page in DAX path
      dax: rip out get_block based IO support
      ext4: Add select for CONFIG_FS_IOMAP
      ext4: add EXT4_JOURNAL_DATA_FL and EXT4_EXTENTS_FL to modifiable mask
      ext4: be more strict when verifying flags set via SETFLAGS ioctls
      ext4: warn when page is dirtied without buffers
      ext4: fix checks for data=ordered and journal_async_commit options
      dax: Fix sleep in atomic contex in grab_mapping_entry()

Ross Zwisler (17):
      ext4: tell DAX the size of allocation holes
      dax: remove buffer_size_valid()
      ext2: remove support for DAX PMD faults
      dax: make 'wait_table' global variable static
      dax: remove the last BUG_ON() from fs/dax.c
      dax: consistent variable naming for DAX entries
      dax: coordinate locking for offsets in PMD range
      dax: remove dax_pmd_fault()
      dax: correct dax iomap code namespace
      dax: add dax_iomap_sector() helper function
      dax: dax_iomap_fault() needs to call iomap_end()
      dax: move RADIX_DAX_* defines to dax.h
      dax: move put_(un)locked_mapping_entry() in dax.c
      dax: add struct iomap based DAX PMD support
      xfs: use struct iomap based DAX PMD fault path
      dax: remove "depends on BROKEN" from FS_DAX_PMD
      ext4: remove unused function ext4_aligned_io()

Sergey Karamov (1):
      ext4: do not perform data journaling when data is encrypted

Theodore Ts'o (15):
      Merge branch 'dax-4.10-iomap-pmd' into origin
      Merge branch 'fscrypt' into origin
      ext4: allow ext4_truncate() to return an error
      ext4: allow ext4_ext_truncate() to return an error
      ext4: don't lock buffer in ext4_commit_super if holding spinlock
      ext4: sanity check the block and cluster size at mount time
      ext4: fix in-superblock mount options processing
      ext4: use more strict checks for inodes_per_block on mount
      ext4: add sanity checking to count_overhead()
      ext4: fix reading new encrypted symlinks on no-journal file systems
      fscrypt: rename get_crypt_info() to fscrypt_get_crypt_info()
      fscrypt: unexport fscrypt_initialize()
      fscrypt: move non-public structures and constants to fscrypt_private.h
      fscrypt: move the policy flags and encryption mode definitions to uapi header
      Merge branch 'fscrypt' into dev

 Documentation/filesystems/dax.txt  |   22 +-
 Documentation/filesystems/ext4.txt |   13 +-
 MAINTAINERS                        |    1 +
 fs/Kconfig                         |    1 -
 fs/crypto/Kconfig                  |    2 -
 fs/crypto/crypto.c                 |  123 ++++--
 fs/crypto/fname.c                  |   61 ++-
 fs/crypto/fscrypt_private.h        |   93 +++++
 fs/crypto/keyinfo.c                |   24 +-
 fs/crypto/policy.c                 |   36 +-
 fs/dax.c                           | 1132 ++++++++++++++++++++++--------------------------------
 fs/ext2/file.c                     |   35 +-
 fs/ext2/inode.c                    |   11 +-
 fs/ext4/Kconfig                    |    1 +
 fs/ext4/acl.c                      |    2 +-
 fs/ext4/ext4.h                     |   32 +-
 fs/ext4/ext4_jbd2.h                |   14 +-
 fs/ext4/extents.c                  |   27 +-
 fs/ext4/file.c                     |  184 ++++++---
 fs/ext4/ialloc.c                   |    5 +-
 fs/ext4/inline.c                   |   18 +-
 fs/ext4/inode.c                    |  349 ++++++++++++-----
 fs/ext4/ioctl.c                    |   82 ++--
 fs/ext4/mballoc.c                  |    4 +-
 fs/ext4/namei.c                    |   24 +-
 fs/ext4/page-io.c                  |    3 +-
 fs/ext4/super.c                    |  169 +++++---
 fs/ext4/xattr.c                    |   45 ++-
 fs/f2fs/data.c                     |    4 +-
 fs/f2fs/f2fs.h                     |    4 +-
 fs/f2fs/file.c                     |   19 +-
 fs/iomap.c                         |    5 +-
 fs/mbcache.c                       |   41 +-
 fs/xfs/xfs_aops.c                  |   26 +-
 fs/xfs/xfs_aops.h                  |    3 -
 fs/xfs/xfs_file.c                  |   10 +-
 include/linux/dax.h                |   60 ++-
 include/linux/fscrypto.h           |  134 ++-----
 include/linux/iomap.h              |    1 +
 include/uapi/linux/fs.h            |   14 +
 mm/filemap.c                       |    5 +-
 41 files changed, 1501 insertions(+), 1338 deletions(-)
 create mode 100644 fs/crypto/fscrypt_private.h
