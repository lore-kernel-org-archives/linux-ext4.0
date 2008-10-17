From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] additional ext4 updates for 2.6.28
Date: Fri, 17 Oct 2008 16:36:14 -0400
Message-ID: <E1Kqw3S-0004f6-Jm@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60323 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbYJQUgR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 16:36:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This patch set set contains contains bug fixes which could crashes,
performance enhancements especially for large streaming writes (thanks
to Chris Mason for pointing this out), blkdev discard support (for trim
commands for SSD's), and updates to documentation.

Note; the changes to mm/page-writeback have been reviewed by
linux-fsdevel and by Christoph Hellwig specifically.  Christoph believes
(and I agree) that we probably can get rid of the new control flag
(no_nrwrite_index_update) and make the changes in behavior of
write_cached_pages() conditionally, but that would require auditing and
updating all of the other filesystems that use that function.  So for
now we just make the change for ext4, which increases streaming write
speed to large files by a factor of five or more, so that a write to 3GB
file now proceeds at raw disk speeds.

						- Ted

Aneesh Kumar K.V (8):
      ext4: Free ext4_prealloc_space using kmem_cache_free
      ext4: Do mballoc init before doing filesystem recovery
      ext4: Use an rbtree for tracking blocks freed during transaction.
      ext4: Don't reuse released data blocks until transaction commits
      ext4: Use tag dirty lookup during mpage_da_submit_io
      vfs: Remove the range_cont writeback mode.
      vfs: Add no_nrwrite_index_update writeback control flag
      ext4: Fix file fragmentation during large file write.

Diego Calleja (1):
      ext4: Update Documentation/filesystems/ext4.txt

Eric Sesterhenn (1):
      ext4: Add missing newlines to printk messages

Manish Katiyar (2):
      ext4: Fix Kconfig typo for ext4dev
      ext4: Remove compile warnings when building w/o CONFIG_PROC_FS

Martin Michlmayr (1):
      ext4: Remove an old reference to ext4dev in Makefile comment

Theodore Ts'o (4):
      ext4: let the block device know when unused blocks can be discarded
      ext4: Remove unused mount options: nomballoc, mballoc, nocheck
      ext4: Replace hackish ext4_mb_poll_new_transaction with commit callback
      ext4: Remove automatic enabling of the HUGE_FILE feature flag

 Documentation/filesystems/ext4.txt |   32 ++---
 fs/Kconfig                         |    2 +-
 fs/Makefile                        |    2 +-
 fs/ext4/balloc.c                   |   12 ++-
 fs/ext4/ext4.h                     |    1 -
 fs/ext4/ext4_sb.h                  |    3 -
 fs/ext4/inode.c                    |  143 +++++++++++---------
 fs/ext4/mballoc.c                  |  263 ++++++++++++++++++-----------------
 fs/ext4/mballoc.h                  |   31 +++--
 fs/ext4/super.c                    |  132 +++++-------------
 fs/jbd2/commit.c                   |    3 +
 fs/jbd2/transaction.c              |    1 +
 include/linux/jbd2.h               |    9 ++
 include/linux/writeback.h          |   10 ++-
 mm/page-writeback.c                |   12 +-
 15 files changed, 320 insertions(+), 336 deletions(-)
