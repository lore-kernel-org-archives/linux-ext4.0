From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.6
Date: Wed, 16 Mar 2016 17:37:59 -0400
Message-ID: <20160316213759.GA21699@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53444 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcCPViC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2016 17:38:02 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 74dae4278546b897eb81784fdfcce872ddd8b2b8:

  ext4: fix crashes in dioread_nolock mode (2016-02-19 00:33:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 0304688676bdfc8159e165313d71da19c118ba27:

  ext4: clean up error handling in the MMP support (2016-03-13 17:56:52 -0400)

----------------------------------------------------------------
Performance improvements in SEEK_DATA and xattr scalability
improvements, plus a lot of clean ups and bug fixes.

----------------------------------------------------------------
Adam Buchbinder (1):
      ext4: fix misspellings in comments.

Aihua Zhang (1):
      ext4: fix compile error while opening the macro DOUBLE_CHECK

Ales Novak (1):
      ext4: print ext4 mount option data_err=abort correctly

Andreas Gruenbacher (3):
      ext4: kill ext4_mballoc_ready
      mbcache: get rid of _e_hash_list_head
      mbcache: add reusable flag to cache entries

Daeho Jeong (1):
      ext4: make sure to revoke all the freeable blocks in ext4_free_blocks

Eric Whitney (1):
      ext4: trim unused parameter from convert_initialized_extent()

Eryu Guan (2):
      ext4: iterate over buffer heads correctly in move_extent_per_page()
      ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()

Geliang Tang (1):
      ext4: drop unneeded BUFFER_TRACE in ext4_delete_inline_entry()

Jan Kara (23):
      mbcache2: reimplement mbcache
      ext4: convert to mbcache2
      ext2: convert to mbcache2
      mbcache: remove mbcache
      mbcache2: limit cache size
      mbcache2: Use referenced bit instead of LRU
      mbcache2: rename to mbcache
      ext4: shortcut setting of xattr to the same value
      jbd2: remove unnecessary arguments of jbd2_journal_write_revoke_records
      jbd2: factor out common descriptor block initialization
      jbd2: unify revoke and tag block checksum handling
      jbd2: save some atomic ops in __JI_COMMIT_RUNNING handling
      ext4: pack ioend structure better
      ext4: use i_mutex to serialize unaligned AIO DIO
      ext4: rename and split get blocks functions
      ext4: move trans handling and completion deferal out of _ext4_get_block
      ext4: simplify io_end handling for AIO DIO
      ext4: remove i_ioend_count
      ext4: fix setting of referenced bit in ext4_es_lookup_extent()
      ext4: factor out determining of hole size
      ext4: return hole from ext4_map_blocks()
      ext4: cleanup handling of bh->b_state in DAX mmap
      ext4: more efficient SEEK_DATA implementation

Konstantin Khlebnikov (1):
      ext4: use __GFP_NOFAIL in ext4_free_blocks()

Michal Hocko (1):
      jbd2: do not fail journal because of frozen_buffer allocation failure

OGAWA Hirofumi (1):
      jbd2: fix FS corruption possibility in jbd2_journal_destroy() on umount path

vikram.jadhav07 (1):
      ext4: clean up error handling in the MMP support

 fs/ext2/ext2.h           |    3 +
 fs/ext2/super.c          |   25 +-
 fs/ext2/xattr.c          |  139 +++++------
 fs/ext2/xattr.h          |   21 +-
 fs/ext4/ext4.h           |   45 ++--
 fs/ext4/ext4_extents.h   |    2 +-
 fs/ext4/extents.c        |  128 +++++-----
 fs/ext4/extents_status.c |    4 +-
 fs/ext4/file.c           |  129 ++++------
 fs/ext4/ialloc.c         |    2 +-
 fs/ext4/indirect.c       |   29 ++-
 fs/ext4/inline.c         |    8 +-
 fs/ext4/inode.c          |  388 +++++++++++++++++++----------
 fs/ext4/mballoc.c        |   81 +++---
 fs/ext4/mballoc.h        |   12 -
 fs/ext4/migrate.c        |    2 +-
 fs/ext4/mmp.c            |   34 +--
 fs/ext4/move_extent.c    |    1 +
 fs/ext4/page-io.c        |    4 -
 fs/ext4/super.c          |   35 ++-
 fs/ext4/xattr.c          |  166 +++++++-----
 fs/ext4/xattr.h          |    3 +-
 fs/jbd2/commit.c         |   49 +---
 fs/jbd2/journal.c        |   43 +++-
 fs/jbd2/recovery.c       |   31 +--
 fs/jbd2/revoke.c         |   60 ++---
 fs/jbd2/transaction.c    |   22 +-
 fs/mbcache.c             | 1093 +++++++++++++++++++++++++-------------------------------------------------------
 include/linux/jbd2.h     |   16 +-
 include/linux/mbcache.h  |   93 ++++---
 30 files changed, 1150 insertions(+), 1518 deletions(-)
