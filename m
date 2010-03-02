From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/28] Ext4 patch queue for the 2.6.34 merge window.
Date: Tue,  2 Mar 2010 13:18:17 -0500
Message-ID: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0CBSSu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I have queued up to send to Linus for the 2.6.34 merge
window.  It's in the ext4 patch queue and in the ext4 tree (everything
between origin and next).  I'm currently doing final testing and plan to
ship it to Linus in the next day or two.

If you think something is missing or should be dropped for this list, or
see something wrong, please let me know ASAP.  Thanks!!

    	      	     	    	   - Ted

Curt Wohlgemuth (1):
  ext4: Fix BUG_ON at fs/buffer.c:652 in no journal mode

Dmitry Monakhov (7):
  ext4: mount flags manipulation cleanup
  ext4: trivial quota cleanup
  ext4: deprecate obsoleted mount options
  ext4: fix error handling in migrate
  ext4: explicitly remove inode from orphan list after failed direct io
  ext4: Handle non empty on-disk orphan link
  ext4: Fix ext4_quota_write cross block boundary behaviour

Eric Sandeen (3):
  ext4: fix async i/o writes beyond 4GB to a sparse file
  ext4: Fix optional-arg mount options
  ext4: move __func__ into a macro for ext4_warning, ext4_error

Frank Mayhar (1):
  ext4: Convert BUG_ON checks to use ext4_error() instead

Jiaying Zhang (1):
  ext4: Add flag to files with blocks intentionally past EOF

Leonard Michlmayr (1):
  ext4: correctly calculate number of blocks for fiemap

Roel Kluin (1):
  ext4: add missing error checking to ext4_expand_extra_isize_ea()

Tao Ma (1):
  ext4: Fix fencepost error in chosing choosing group vs file
    preallocation.

Theodore Ts'o (9):
  ext4: Add block validity check when truncating indirect block mapped
    inodes
  ext4: Add new tracepoint for jbd2_cleanup_journal_tail
  ext4: Add new tracepoints to debug delayed allocation space functions
  ext4: Use slab allocator for sub-page sized allocations
  ext4: Use bitops to read/modify EXT4_I(inode)->i_state
  ext4: Reserve INCOMPAT_EA_INODE and INCOMPAT_DIRDATA feature
    codepoints
  ext4: mechanical change on dio get_block code in prepare for it to be
    used by buffer write
  ext4: use ext4_get_block_write in buffer write
  ext4: Use direct_IO_no_locking in ext4 dio read.

Toshiyuki Okajima (1):
  ext4: make "offset" consistent in ext4_check_dir_entry()

dingdinghua (2):
  jbd2: delay discarding buffers in journal_unmap_buffer
  jbd2: clean up an assertion in jbd2_journal_commit_transaction()

 fs/ext4/balloc.c            |   29 +--
 fs/ext4/dir.c               |   12 +-
 fs/ext4/ext4.h              |  103 ++++++++---
 fs/ext4/ext4_jbd2.c         |    4 +-
 fs/ext4/ext4_jbd2.h         |   24 +++
 fs/ext4/extents.c           |  250 ++++++++++++++++++++-------
 fs/ext4/file.c              |    4 +-
 fs/ext4/fsync.c             |    2 +-
 fs/ext4/ialloc.c            |   32 ++--
 fs/ext4/inode.c             |  407 +++++++++++++++++++++++++++++--------------
 fs/ext4/ioctl.c             |    9 +
 fs/ext4/mballoc.c           |   34 ++--
 fs/ext4/migrate.c           |   35 ++--
 fs/ext4/move_extent.c       |   12 +-
 fs/ext4/namei.c             |   63 ++++----
 fs/ext4/resize.c            |  102 ++++-------
 fs/ext4/super.c             |  336 ++++++++++++++++++++++-------------
 fs/ext4/xattr.c             |   56 +++---
 fs/jbd2/checkpoint.c        |    1 +
 fs/jbd2/commit.c            |   13 +-
 fs/jbd2/journal.c           |  132 ++++++++++++++
 fs/jbd2/transaction.c       |   43 ++++--
 include/linux/jbd2.h        |   11 +-
 include/trace/events/ext4.h |  101 +++++++++++
 include/trace/events/jbd2.h |   28 +++
 25 files changed, 1253 insertions(+), 590 deletions(-)

