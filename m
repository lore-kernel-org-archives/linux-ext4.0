From: "Theodore Ts'o" <tytso@mit.edu>
Subject: 2.6.24-git12-ext4-1 patchset released
Date: Sat, 02 Feb 2008 13:03:12 -0500
Message-ID: <E1JLMhs-0003Rp-A3@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42778 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbYBBSDQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 13:03:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've just released 2.6.24-git12-ext4-1.  It removes the ext2/ext3 BKL
patches from Andi Kleen, since akpm has apparently already merged those
into -mm and they were causing conflicts with Dave Hansen's read-only
bind mount patches.  

It also adds a patch to replace the use of iget() with iget_unlocked()
(since an iget() removal patch has been queued in -mm), and adds a
number of bug fixes. all, of which I hope to push to Linus shortly.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.24-git12-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.24-git
12-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.24-git12-ext4-1

                                                - Ted

New or modified patches since the last patchset indicated with an
asterisk(*):

Akira Fujita (4):
      ext4: online defrad header file changes
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag -- Move the file data to the new blocks
    * Free space fragmentation functions

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Andi Kleen (3):
      Remove incorrect comment refering to lock_kernel() from jbd/jbd2
      Convert ext4 to use unlocked_ioctl v2
      Remove incorrect BKL comments in ext4

Aneesh Kumar K.V (3):
      ext4: undo the stable boundary patch changes
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (1):
      allow in-inode EAs on ext4 root inode

Jan Kara (1):
    * jbd: Remove useless loop when writing commit record

Josef Bacik (1):
    * jbd: fix assertion failure in journal_next_log_block

Mingming Cao (2):
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Theodore Ts'o (5):
    * ext4: Replace use of iget() with iget_locked()
    * jbd2: Add error check to journal_wait_on_commit_record to avoid oops
      patch test-filesys-flag.patch
      ext4: Stable/Unstable boundary
      ext4: New inode allocation for FLEX_BG meta-data groups.

 fs/buffer.c                     |    3 +-
 fs/ext4/Makefile                |    2 +-
 fs/ext4/balloc.c                |   28 +-
 fs/ext4/defrag.c                | 2214 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                   |    4 +-
 fs/ext4/extents.c               |   65 +-
 fs/ext4/file.c                  |    2 +-
 fs/ext4/ialloc.c                |  110 ++-
 fs/ext4/inode.c                 |  174 +++-
 fs/ext4/ioctl.c                 |   25 +-
 fs/ext4/mballoc.c               |    7 +
 fs/ext4/namei.c                 |   14 +-
 fs/ext4/resize.c                |    6 +-
 fs/ext4/super.c                 |  113 ++-
 fs/jbd/commit.c                 |   21 +-
 fs/jbd/journal.c                |    7 +-
 fs/jbd/recovery.c               |    2 +-
 fs/jbd2/commit.c                |   12 +-
 fs/jbd2/journal.c               |    7 +-
 fs/jbd2/recovery.c              |    2 +-
 fs/mpage.c                      |  406 +++++++
 include/linux/ext4_fs.h         |  107 ++-
 include/linux/ext4_fs_extents.h |   22 +
 include/linux/ext4_fs_sb.h      |    3 +
 include/linux/jbd.h             |    3 +-
 include/linux/jbd2.h            |    3 +-
 include/linux/mpage.h           |    2 +
 27 files changed, 3271 insertions(+), 93 deletions(-)
