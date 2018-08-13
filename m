From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 4.19
Date: Mon, 13 Aug 2018 16:22:31 -0400
Message-ID: <20180813202231.GA15230@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following changes since commit 5012284700775a4e6e3fbe7eac4c543c4874b559:

  ext4: fix check to prevent initializing reserved inodes (2018-07-29 15:34:00 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 863c37fcb14f8b66ea831b45fb35a53ac4a8d69e:

  ext4: remove unneeded variable "err" in ext4_mb_release_inode_pa() (2018-08-04 17:34:07 -0400)

----------------------------------------------------------------
Convert content from the ext4 wiki to Documentation rst files so it is
more likely to be updated as we add new features to ext4.  Add 64-bit
timestamp support to ext4's superblock fields.  And the usual bug
fixes and cleanups, including a Spectre gadget fixup and some
hardening against maliciously corrupted file systems.

----------------------------------------------------------------
Arnd Bergmann (6):
      ext4: sysfs: print ext4_super_block fields as little-endian
      ext4: use 64-bit timestamps for mmp_time
      ext4: use ktime_get_real_seconds for i_dtime
      ext4: use timespec64 for all inode times
      jbd2: replace current_kernel_time64 with ktime equivalent
      ext4: super: extend timestamps to 40 bits

Chengguang Xu (1):
      ext4: check allocation failure when duplicating "data" in ext4_remount()

Darrick J. Wong (15):
      ext4: move ext4.txt into its own directory
      ext4: convert ext4.rst to restructuredtext format
      ext4: import on-disk layout book from wiki page
      ext4: import high level design chapter from wiki page
      ext4: import superblocks chapter from wiki page
      ext4: import group descriptors chapter from wiki page
      ext4: import bitmaps chapter from wiki page
      ext4: import multi-mount protection chapter from wiki page
      ext4: import journal chapter from wiki page
      ext4: import inodes chapter from wiki page
      ext4: import inode data fork chapter from wiki page
      ext4: import directory layout chapter from wiki page
      ext4: import extended attributes chapter from wiki page
      docs: create filesystem internal section
      docs: add new ext4 superblock time extension fields

Eric Sandeen (1):
      ext4: reset error code in ext4_find_entry in fallback

Gustavo A. R. Silva (1):
      ext4: use swap macro in mext_page_double_lock

Jeremy Cline (1):
      ext4: fix spectre gadget in ext4_mb_regular_allocator()

Junichi Uekawa (1):
      ext4: fix warning message in ext4_enable_quotas()

Liu Song (1):
      ext4: improve code readability in ext4_iget()

Ross Zwisler (2):
      dax: dax_layout_busy_page() warn on !exceptional
      ext4: handle layout changes to pinned DAX mappings

Theodore Ts'o (2):
      docs: fix up the obviously obsolete bits in the new ext4 documentation
      ext4: check for NUL characters in extended attribute's name

Wang Shilong (2):
      ext4: fix race when setting the bitmap corrupted flag
      ext4: use ext4_warning() for sb_getblk failure

zhong jiang (1):
      ext4: remove unneeded variable "err" in ext4_mb_release_inode_pa()

 Documentation/conf.py                                    |   2 +-
 Documentation/filesystems/{ext4.txt => ext4/ext4.rst}    | 142 ++++++------
 Documentation/filesystems/ext4/index.rst                 |  17 ++
 Documentation/filesystems/ext4/ondisk/about.rst          |  44 ++++
 Documentation/filesystems/ext4/ondisk/allocators.rst     |  56 +++++
 Documentation/filesystems/ext4/ondisk/attributes.rst     | 191 ++++++++++++++++
 Documentation/filesystems/ext4/ondisk/bigalloc.rst       |  22 ++
 Documentation/filesystems/ext4/ondisk/bitmaps.rst        |  28 +++
 Documentation/filesystems/ext4/ondisk/blockgroup.rst     | 135 +++++++++++
 Documentation/filesystems/ext4/ondisk/blockmap.rst       |  49 ++++
 Documentation/filesystems/ext4/ondisk/blocks.rst         | 142 ++++++++++++
 Documentation/filesystems/ext4/ondisk/checksums.rst      |  73 ++++++
 Documentation/filesystems/ext4/ondisk/directory.rst      | 426 +++++++++++++++++++++++++++++++++++
 Documentation/filesystems/ext4/ondisk/dynamic.rst        |  12 +
 Documentation/filesystems/ext4/ondisk/eainode.rst        |  18 ++
 Documentation/filesystems/ext4/ondisk/globals.rst        |  13 ++
 Documentation/filesystems/ext4/ondisk/group_descr.rst    | 170 ++++++++++++++
 Documentation/filesystems/ext4/ondisk/ifork.rst          | 194 ++++++++++++++++
 Documentation/filesystems/ext4/ondisk/index.rst          |   9 +
 Documentation/filesystems/ext4/ondisk/inlinedata.rst     |  37 ++++
 Documentation/filesystems/ext4/ondisk/inodes.rst         | 575 +++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/filesystems/ext4/ondisk/journal.rst        | 611 ++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/filesystems/ext4/ondisk/mmp.rst            |  77 +++++++
 Documentation/filesystems/ext4/ondisk/overview.rst       |  26 +++
 Documentation/filesystems/ext4/ondisk/special_inodes.rst |  38 ++++
 Documentation/filesystems/ext4/ondisk/super.rst          | 801 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/index.rst                                  |  11 +
 fs/dax.c                                                 |  10 +-
 fs/ext4/balloc.c                                         |   6 +-
 fs/ext4/ext4.h                                           |  32 +--
 fs/ext4/extents.c                                        |  17 ++
 fs/ext4/ialloc.c                                         |   8 +-
 fs/ext4/inode.c                                          |  65 +++++-
 fs/ext4/mballoc.c                                        |   7 +-
 fs/ext4/mmp.c                                            |   6 +-
 fs/ext4/move_extent.c                                    |   4 +-
 fs/ext4/namei.c                                          |   1 +
 fs/ext4/super.c                                          |  70 ++++--
 fs/ext4/sysfs.c                                          |  32 ++-
 fs/ext4/truncate.h                                       |   4 +
 fs/ext4/xattr.c                                          |   2 +
 fs/jbd2/commit.c                                         |   3 +-
 42 files changed, 4036 insertions(+), 150 deletions(-)
 rename Documentation/filesystems/{ext4.txt => ext4/ext4.rst} (86%)
 create mode 100644 Documentation/filesystems/ext4/index.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/about.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/allocators.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/attributes.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/bigalloc.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/bitmaps.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/blockgroup.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/blockmap.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/blocks.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/checksums.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/directory.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/dynamic.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/eainode.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/globals.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/group_descr.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/ifork.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/index.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/inlinedata.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/inodes.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/journal.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/mmp.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/overview.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/special_inodes.rst
 create mode 100644 Documentation/filesystems/ext4/ondisk/super.rst
