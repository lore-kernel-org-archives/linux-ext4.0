From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: 2.6.25-rc1-ext4-1 patchset released
Date: Sun, 10 Feb 2008 21:16:02 -0500
Message-ID: <E1JOODC-0007ws-Vb@closure.thunk.org>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63117 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbYBKCRz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 21:17:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a new ext4 patchset which is synchronized with the 2.6.25-rc1
release.  No new patches were added, just patches removed because they
have been accepted upstream.

At this point, I do not anticipate any more patches to ext4 that will
change the on-disk format.  The focus is on the optimization patches
(i.e., delayed allocation support) fine-tuning performance, and fixing
any bugs which turn up as more people use ext4.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.25-rc1-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.25-rc1-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.25-rc1-ext4-1

                                                - Ted

Akira Fujita (4):
      ext4: online defrad header file changes
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag -- Move the file data to the new blocks
      Free space fragmentation functions

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Andi Kleen (2):
      Remove incorrect BKL comments in ext4
      Convert ext4 to use unlocked_ioctl v2

Aneesh Kumar K.V (3):
      ext4: undo the stable boundary patch changes
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Mingming Cao (3):
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support
      ext4: remove read-inode from defrag code,replace with ext4_iget()

Theodore Ts'o (2):
      ext4: Stable/Unstable boundary
      ext4: New inode allocation for FLEX_BG meta-data groups.

 fs/buffer.c                     |    3 +-
 fs/ext4/Makefile                |    2 +-
 fs/ext4/balloc.c                |   28 +-
 fs/ext4/defrag.c                | 2206 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                   |    4 +-
 fs/ext4/extents.c               |   65 +-
 fs/ext4/file.c                  |    2 +-
 fs/ext4/ialloc.c                |   96 ++
 fs/ext4/inode.c                 |  166 +++-
 fs/ext4/ioctl.c                 |   25 +-
 fs/ext4/mballoc.c               |    7 +
 fs/ext4/super.c                 |   78 ++-
 fs/jbd/journal.c                |    7 +-
 fs/jbd2/journal.c               |    7 +-
 fs/mpage.c                      |  406 +++++++
 include/linux/ext4_fs.h         |  100 ++-
 include/linux/ext4_fs_extents.h |   22 +
 include/linux/ext4_fs_sb.h      |    3 +
 include/linux/mpage.h           |    2 +
 19 files changed, 3183 insertions(+), 46 deletions(-)
