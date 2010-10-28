From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.37
Date: Thu, 28 Oct 2010 00:52:07 -0400
Message-ID: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0J1EwP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 00:52:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linu=
s
or
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git upstream=
-merge

the merge is somewhat complex, since there's been a lot of work going o=
n
in parallel with discard and zeroout changes, as well as the change
block_prepare_write/__block_write_begin.  The changes pass the xfstests
regression test suite, using both 1k and 4k block sizes --- both before
the upstream merge (the for_linus branch) and after doing a trial merge
with the head of your tree as of Wednesday evening (the upstream-merge
branch).

The changes this time around have two major features, which are
responsible for most of the new lines of code.  One is lazy inode table
initialization, which allows ext4 file systems to be mkfs'ed very
quickly.  The second is changing the I/O submission path so that it use=
s
the block I/O layer directly.  This makes blktraces much smaller, and
makes ext4 far more scalable.  On the boxacle "large file create"
workload, run with 48 and 192 threads on a 48-core AMD box, ext4 now ha=
s
a 3x increase in write throughput, and CPU usage has been reduced by a
factor of 3-4.  Most of this was achieved by reducing spinlock
contention on the block queue submission locks.

We also added support for run-time discard of unused blocks using the
new FITRIM ioctl (which has been run by the linux-fs mailing list as a
generic file system-independent interface).

And, of course, a lot of bug fixes and clean ups.

     		      	     	       	     - Ted

Brian King (1):
      jbd2: Fix I/O hang in jbd2_journal_release_jbd_inode

Curt Wohlgemuth (1):
      ext4: use dedicated slab caches for group_info structures

Dmitry Monakhov (1):
      ext4: optimize orphan_list handling for ext4_setattr

Eric Sandeen (10):
      ext4: stop looping in ext4_num_dirty_pages when max_pages reached
      ext4: don't bump up LONG_MAX nr_to_write by a factor of 8
      ext4: fix oops in trace_ext4_mb_release_group_pa
      ext4: don't use ext4_allocation_contexts for tracing
      ext4: queue conversion after adding to inode's completed IO list
      ext4: remove unused ext4_sb_info members
      ext4: tidy up a void argument in inode.c
      ext4: implement writeback livelock avoidance using page tagging
      ext4: update writeback_index based on last page scanned
      ext4: move ext4_mb_{get,put}_buddy_cache_lock and make them stati=
c

Kazuya Mio (1):
      ext4: fix compile error in ext4_fallocate()

Lukas Czerner (11):
      ext4: check for negative error code from sb_issue_discard
      ext4: don't hold spinlock while calling ext4_issue_discard()
      Add helper function for blkdev_issue_zeroout (sb_issue_discard)
      ext4: add support for lazy inode table initialization
      ext4: add interface to advertise ext4 features in sysfs
      ext4: use sb_issue_zeroout in setup_new_group_blocks
      ext4: use sb_issue_zeroout in ext4_ext_zeroout
      ext4: Use return value from sb_issue_discard()
      fs: Add FITRIM ioctl
      ext4: Add batched discard support for ext4
      ext4: add batched_discard into ext4 feature list

Maciej =C5=BBenczykowski (1):
      ext4: don't update sb journal_devnum when RO dev

Namhyung Kim (1):
      ext4: Check return value of sb_getblk() and friends

Nicolas Kaiser (1):
      ext4: fix unbalanced mutex unlock in error path of ext4_li_reques=
t_new

Sergey Senozhatsky (1):
      ext4: fix NULL pointer dereference in print_daily_error_info()

Theodore Ts'o (18):
      ext4: fix EOFBLOCKS_FL handling
      jbd2: Add sanity check for attempts to start handle during umount
      ext4: avoid uninitialized memory references in ext3_htree_next_bl=
ock()
      ext4: use search_dirblock() in ext4_dx_find_entry()
      ext4: use KMEM_CACHE instead of kmem_cache_create
      ext4: call mpage_da_submit_io() from mpage_da_map_blocks()
      ext4: simplify ext4_writepage()
      ext4: inline ext4_writepage() into mpage_da_submit_io()
      ext4: inline walk_page_buffers() into mpage_da_submit_io
      ext4: move mpage_put_bnr_to_bhs()'s functionality to mpage_da_sub=
mit_io()
      ext4: use bio layer instead of buffer layer in mpage_da_submit_io
      ext4: fix kernel oops if the journal superblock has a non-zero j_=
errno
      ext4: rename {exit,init}_ext4_*() to ext4_{exit,init}_*()
      ext4: make various ext4 functions be static
      ext4: rename {ext,idx}_pblock and inline small extent functions
      ext4: move flush_completed_IO to fs/ext4/fsync.c and make it stat=
ic
      ext4: rename mark_bitmap_end() to ext4_mark_bitmap_end()
      ext4,jbd2: convert tracepoints to use major/minor numbers

Toshiyuki Okajima (2):
      ext4: improve llseek error handling for overly large seek offsets
      ext4: fix potential infinite loop in ext4_da_writepages()

Wen Congyang (1):
      ext4: avoid null dereference in trace_ext4_mballoc_discard

 Documentation/filesystems/ext4.txt |   14 +
 fs/ext4/Makefile                   |    2 +-
 fs/ext4/balloc.c                   |    5 +-
 fs/ext4/block_validity.c           |    7 +-
 fs/ext4/dir.c                      |    2 +-
 fs/ext4/ext4.h                     |  110 ++++++--
 fs/ext4/ext4_extents.h             |   65 ++++-
 fs/ext4/extents.c                  |  369 ++++++++++-------------
 fs/ext4/file.c                     |   44 +++-
 fs/ext4/fsync.c                    |   83 +++++
 fs/ext4/ialloc.c                   |  136 ++++++++-
 fs/ext4/inode.c                    |  587 +++++++++++++---------------=
--------
 fs/ext4/mballoc.c                  |  554 ++++++++++++++++++++++------=
------
 fs/ext4/migrate.c                  |    2 +-
 fs/ext4/move_extent.c              |   22 +-
 fs/ext4/namei.c                    |   63 ++---
 fs/ext4/page-io.c                  |  430 ++++++++++++++++++++++++++
 fs/ext4/resize.c                   |   53 +---
 fs/ext4/super.c                    |  531 ++++++++++++++++++++++++++++=
+++--
 fs/ext4/xattr.c                    |    4 +-
 fs/ext4/xattr.h                    |    8 +-
 fs/ioctl.c                         |   39 +++
 fs/jbd2/checkpoint.c               |   10 +
 fs/jbd2/commit.c                   |   12 +-
 fs/jbd2/journal.c                  |    4 +-
 fs/jbd2/transaction.c              |    1 +
 include/linux/blkdev.h             |    8 +
 include/linux/fs.h                 |    8 +
 include/linux/jbd2.h               |    2 +-
 include/linux/percpu_counter.h     |   10 +
 include/linux/writeback.h          |    2 +
 include/trace/events/ext4.h        |  378 ++++++++++++++---------
 include/trace/events/jbd2.h        |   78 +++--
 33 files changed, 2513 insertions(+), 1130 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
