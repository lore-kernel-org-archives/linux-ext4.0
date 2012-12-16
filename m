From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.8
Date: Sat, 15 Dec 2012 22:02:17 -0500
Message-ID: <nsxr4mqya12.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38655 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab2LPDCW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Dec 2012 22:02:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to bd9926e80330d43f15b710c2935fa41b792d56fd:

  ext4: zero out inline data using memset() instead of empty_zero_page (2012-12-11 03:31:49 -0500)

----------------------------------------------------------------
There are two major features for this merge window.  The first is
inline data, which allows small files or directories to be stored in
the in-inode extended attribute area.  (This requires that the file
system use inodes which are at least 256 bytes or larger; 128 byte
inodes do not have any room for in-inode xattrs.)

The second new feature is SEEK_HOLE/SEEK_DATA support.  This is
enabled by the extent status tree patches, and this infrastructure
will be used to further optimize ext4 in the future.

Beyond that, we have the usual collection of code cleanups and bug
fixes.

----------------------------------------------------------------
Alan Cox (1):
      ext4: remove unused assignment

Anatol Pomozov (2):
      ext4: use 'inode' variable that is already dereferenced
      ext4: remove code duplication in ext4_get_block_write_nolock()

Behan Webster (1):
      jbd2: remove VLAIS usage from JBD2 code

Carlos Maiolino (1):
      ext4: ensure Inode flags consistency are checked at build time

Darrick J. Wong (1):
      ext4: don't verify checksums of dx non-leaf nodes during fallback scan

Eric Sandeen (5):
      ext4: fix unjournaled inode bitmap modification
      ext4: fix overhead calculations in ext4_stats, again
      ext4: fix awful goto in ext4_mb_new_blocks()
      ext4: remove ext4_handle_release_buffer()
      ext4: init pagevec in ext4_da_block_invalidatepages

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Guo Chao (3):
      ext4: use sync_inode_metadata() when syncing inode metadata
      ext4: remove redundant code in ext4_alloc_inode()
      ext4: remove redundant initialization in ext4_fill_super()

Lukas Czerner (5):
      ext4: notify when discard is not supported
      ext4: warn when discard request fails other than EOPNOTSUPP
      ext4: fix error handling in ext4_fill_super()
      ext4: prevent race while walking extent tree for fiemap
      ext4: simple cleanup in fiemap codepath

Tao Ma (24):
      ext4: move extra inode read to a new function
      ext4: export inline xattr functions
      ext4: add the basic function for inline data support
      ext4: add read support for inline data
      ext4: add normal write support for inline data
      ext4: add journalled write support for inline data
      ext4: add delalloc support for inline data
      ext4: make ext4_init_dot_dotdot for inline dir usage
      ext4: refactor __ext4_check_dir_entry() to accept start and size
      ext4: create __ext4_insert_dentry for dir entry insertion
      ext4: let add_dir_entry handle inline data properly
      ext4: let ext4_readdir handle inline data
      ext4: create a new function search_dir
      ext4: let ext4_find_entry handle inline data
      ext4: make ext4_delete_entry generic
      ext4: let ext4_delete_entry() handle inline data
      ext4: let empty_dir handle inline dir
      ext4: let ext4_rename handle inline dir
      ext4: let fiemap work with inline data
      ext4: evict inline data out if we need to strore xattr in inode
      ext4: let ext4_truncate handle inline data correctly
      ext4: let fallocate handle inline data correctly
      ext4: enable ext4 inline support
      ext4: Remove CONFIG_EXT4_FS_XATTR

Theodore Ts'o (6):
      ext4: do not use ext4_error() when there is no space in dir leaf for csum
      ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path
      ext4: rationalize ext4_extents.h inclusion
      ext4: restructure ext4_ext_direct_IO()
      ext4: fix possible use after free with metadata csum
      ext4: zero out inline data using memset() instead of empty_zero_page

Vahram Martirosyan (1):
      ext4: fixed potential NULL dereference in ext4_calculate_overhead()

Zhao Hongjiang (1):
      ext4: get rid of redundant code in ext4_fill_super()

Zheng Liu (11):
      ext4: print 'flags' in ext4_ext_handle_uninitialized_extents
      ext4: print map->m_flags in trace_ext4_ext/ind_map_blocks_exit
      ext4: fix missing call to trace_ext4_ext_map_blocks_exit
      ext4: add data structures for the extent status tree
      ext4: add operations on extent status tree
      ext4: initialize extent status tree
      ext4: let ext4 maintain extent status tree
      ext4: add some tracepoints in extent status tree
      ext4: reimplement ext4_find_delay_alloc_range on extent status tree
      ext4: reimplement fiemap using extent status tree
      ext4: introduce lseek SEEK_DATA/SEEK_HOLE support

Zhi Yong Wu (1):
      ext4: remove unused variable from ext4_ext_in_cache()

 Documentation/filesystems/ext4.txt |    9 +-
 fs/Kconfig                         |    4 +-
 fs/ext4/Kconfig                    |   15 -
 fs/ext4/Makefile                   |    4 +-
 fs/ext4/acl.c                      |    6 +-
 fs/ext4/dir.c                      |   41 +-
 fs/ext4/ext4.h                     |  165 +++-
 fs/ext4/ext4_extents.h             |   40 -
 fs/ext4/ext4_jbd2.h                |    7 -
 fs/ext4/extents.c                  |  480 ++++-------
 fs/ext4/extents_status.c           |  500 +++++++++++
 fs/ext4/extents_status.h           |   45 +
 fs/ext4/file.c                     |  336 +++++++-
 fs/ext4/fsync.c                    |    6 +-
 fs/ext4/ialloc.c                   |   25 +-
 fs/ext4/indirect.c                 |    5 +-
 fs/ext4/inline.c                   | 1884 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c                    |  629 ++++++++------
 fs/ext4/mballoc.c                  |   60 +-
 fs/ext4/migrate.c                  |    1 +
 fs/ext4/move_extent.c              |    1 +
 fs/ext4/namei.c                    |  531 ++++++++----
 fs/ext4/page-io.c                  |    3 +-
 fs/ext4/resize.c                   |   17 +-
 fs/ext4/super.c                    |   57 +-
 fs/ext4/symlink.c                  |    4 -
 fs/ext4/xattr.c                    |  110 ++-
 fs/ext4/xattr.h                    |  158 ++--
 fs/jbd2/journal.c                  |    1 -
 fs/jbd2/transaction.c              |   11 -
 include/linux/jbd2.h               |    9 +-
 include/trace/events/ext4.h        |  136 ++-
 32 files changed, 4184 insertions(+), 1116 deletions(-)
 create mode 100644 fs/ext4/extents_status.c
 create mode 100644 fs/ext4/extents_status.h
 create mode 100644 fs/ext4/inline.c
