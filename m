From: Theodore Ts'o <tytso@mit.edu>
Subject: [GET PULL] ext4 updates for 3.16
Date: Sat, 7 Jun 2014 23:58:25 -0400
Message-ID: <20140608035825.GA23368@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56013 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbaFHD62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jun 2014 23:58:28 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A fairly minor obvious merge fix will be required due to a conflicting
change to a comment made by a commit already in your tree:

 -       * Comments copied from block_write_full_page_endio:
++       * Comments copied from block_write_full_page:

coupled with a move of the code in question in the ext4 tree.

Thanks!!

		       	       	   	   - Ted

The following changes since commit 9ac03675010a69507c0a9d832d6a722e07d35cc6:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-04-20 20:43:47 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to bd9db175dde14b606265e0d37e8319d96fe1a58f:

  ext4: handle symlink properly with inline_data (2014-06-02 10:48:22 -0400)

----------------------------------------------------------------
Clean ups and miscellaneous bug fixes, in particular for the new
collapse_range and zero_range fallocate functions.  In addition,
improve the scalability of adding and remove inodes from the orphan
list.

----------------------------------------------------------------
Andrey Tsyvarev (1):
      ext4: do not destroy ext4_groupinfo_caches if ext4_mb_init() fails

Darrick J. Wong (3):
      ext4: find the group descriptors on a 1k-block bigalloc,meta_bg filesystem
      ext4: fix block bitmap initialization under sparse_super2
      ext4: fix block bitmap validation when bigalloc, ^flex_bg

Dmitry Monakhov (1):
      ext4: remove obsoleted check

Giedrius Rekasius (1):
      ext4: remove unused local variable "stored" from ext4_readdir(...)

Jan Kara (3):
      ext4: use sbi in ext4_orphan_{add|del}()
      ext4: reduce contention on s_orphan_lock
      ext4: fix zeroing of page during writeback

Lukas Czerner (4):
      ext4: get rid of EXT4_MAP_UNINIT flag
      ext4: rename uninitialized extents to unwritten
      ext4: remove unnecessary double parentheses
      ext4: use EXT_MAX_BLOCKS in ext4_es_can_be_merged()

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Namjae Jeon (2):
      ext4: fix data integrity sync in ordered mode
      ext4: fix ZERO_RANGE test failure in data journalling

Stephen Hemminger (1):
      ext4: make local functions static

Theodore Ts'o (5):
      ext4: inline generic_file_aio_write() into ext4_file_write()
      ext4: move ext4_file_dio_write() into ext4_file_write()
      ext4: factor out common code in ext4_file_write()
      ext4: fix locking for O_APPEND writes
      ext4: add a new spinlock i_raw_lock to protect the ext4's raw inode

Zhang Zhen (1):
      ext4: avoid unneeded lookup when xattr name is invalid

Zheng Liu (1):
      ext4: handle symlink properly with inline_data

liang xie (1):
      ext4: add missing BUFFER_TRACE before ext4_journal_get_write_access

 fs/ext4/balloc.c            |  66 ++++++++------
 fs/ext4/dir.c               |   3 +-
 fs/ext4/ext4.h              |  59 ++++--------
 fs/ext4/ext4_extents.h      |  22 ++---
 fs/ext4/ext4_jbd2.c         |   7 +-
 fs/ext4/ext4_jbd2.h         |   4 -
 fs/ext4/extents.c           | 236 ++++++++++++++++++++++++------------------------
 fs/ext4/extents_status.c    |  10 +-
 fs/ext4/file.c              | 153 +++++++++++++++----------------
 fs/ext4/inline.c            |  15 ++-
 fs/ext4/inode.c             |  90 ++++++++++--------
 fs/ext4/mballoc.c           |   8 +-
 fs/ext4/migrate.c           |   2 +-
 fs/ext4/mmp.c               |   4 +-
 fs/ext4/move_extent.c       |  39 ++++----
 fs/ext4/namei.c             | 131 ++++++++++++++++-----------
 fs/ext4/page-io.c           |  32 ++++---
 fs/ext4/resize.c            |  13 +++
 fs/ext4/super.c             |  20 +++-
 fs/ext4/xattr.c             |   9 +-
 include/linux/page-flags.h  |  12 ++-
 include/trace/events/ext4.h |   9 +-
 mm/page-writeback.c         |  11 ++-
 23 files changed, 515 insertions(+), 440 deletions(-)
