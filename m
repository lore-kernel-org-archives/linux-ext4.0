From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.12
Date: Wed, 4 Sep 2013 11:46:15 -0400
Message-ID: <20130904154615.GA13156@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit cde2d7a796f7e895e25b43471ed658079345636d:

  ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT (2013-08-12 09:29:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to ad4eec613536dc7e5ea0c6e59849e6edca634d8b:

  ext4: allow specifying external journal by pathname mount option (2013-08-28 19:05:07 -0400)

----------------------------------------------------------------
New features for 3.12:

* Added aggressive extent caching using the extent status tree.  This
  can actually decrease memory usage in read-mostly workloads since
  the information is much more compactly stored in the extent status
  tree than if we had to keep the extent tree metadata blocks in the
  buffer cache.  This also improves Asynchronous I/O since it is it
  makes much less likely that we need to do metadata I/O to lookup the
  extent tree information.
* Improve the recovery after corrupted allocation bitmaps are found
  when running in errors=ignore mode.

Also fixed some writeback vs. truncate races when using a blocksize
less than the page size.

----------------------------------------------------------------
Anatol Pomozov (1):
      ext4: Fix misspellings using 'codespell' tool

Andi Shyti (1):
      ext4: fix use of potentially uninitialized variables in debugging code

Darrick J. Wong (6):
      jbd2: Fix endian mixing problems in the checksumming code
      ext4: error out if verifying the block bitmap fails
      ext4: fix type declaration of ext4_validate_block_bitmap
      ext4: mark block group as corrupt on block bitmap error
      ext4: mark block group as corrupt on inode bitmap error
      ext4: mark group corrupt on group descriptor checksum

Dmitry Monakhov (1):
      ext4: convert write_begin methods to stable_page_writes semantics

Eric Sandeen (1):
      ext4: allow specifying external journal by pathname mount option

Jan Kara (8):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
      jbd2: Fix oops in jbd2_journal_file_inode()
      quota: provide interface for readding allocated space into reserved space
      ext4: fix warning in ext4_da_update_reserve_space()
      ext4: move test whether extent to map can be extended to one place
      ext4: fix ext4_writepages() in presence of truncate
      ext4: simplify truncation code in ext4_setattr()
      ext4: fix lost truncate due to race with writeback

Theodore Ts'o (8):
      ext4: refactor code to read the extent tree block
      ext4: print the block number of invalid extent tree blocks
      ext4: use unsigned int for es_status values
      ext4: cache all of an extent tree's leaf block upon reading
      ext4: add support for extent pre-caching
      ext4: start handle at least possible moment when renaming files
      ext4: allocate delayed allocation blocks before rename
      ext4: avoid reusing recently deleted inodes in no journal mode

Zheng Liu (1):
      ext4: isolate ext4_extents.h file

 Documentation/filesystems/ext4.txt |   7 +--
 fs/ext3/dir.c                      |   2 +-
 fs/ext4/balloc.c                   |  24 ++++++----
 fs/ext4/dir.c                      |   2 +-
 fs/ext4/ext4.h                     |  59 +++++++++++++++++++++---
 fs/ext4/ext4_extents.h             |   6 ---
 fs/ext4/ext4_jbd2.c                |   8 ++--
 fs/ext4/ext4_jbd2.h                |   2 +-
 fs/ext4/extents.c                  | 296 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 fs/ext4/extents_status.c           | 125 +++++++++++++++++++++++++++++++++++---------------
 fs/ext4/extents_status.h           |  51 ++++++++++++---------
 fs/ext4/file.c                     |  21 ++-------
 fs/ext4/ialloc.c                   |  90 ++++++++++++++++++++++++++++++++----
 fs/ext4/indirect.c                 |   1 -
 fs/ext4/inode.c                    | 336 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
 fs/ext4/ioctl.c                    |   4 +-
 fs/ext4/mballoc.c                  |  49 +++++++++++++++++---
 fs/ext4/migrate.c                  |   4 +-
 fs/ext4/move_extent.c              |   2 +-
 fs/ext4/namei.c                    |  35 ++++++++------
 fs/ext4/super.c                    |  47 +++++++++++++++++--
 fs/jbd2/commit.c                   |   6 +--
 fs/jbd2/journal.c                  |   5 +-
 fs/jbd2/recovery.c                 |  24 +++++-----
 fs/quota/dquot.c                   |  46 +++++++++++++++++++
 fs/stat.c                          |  11 ++++-
 include/linux/fs.h                 |   1 +
 include/linux/quotaops.h           |  15 ++++++
 include/trace/events/ext4.h        |  29 ++++++++----
 include/uapi/linux/fiemap.h        |   1 +
 30 files changed, 909 insertions(+), 400 deletions(-)
