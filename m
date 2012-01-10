From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.3
Date: Tue, 10 Jan 2012 15:52:04 -0500
Message-ID: <E1Rkift-0006hB-04@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38944 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab2AJUwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 15:52:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

There is a signed tag ext4_for_linus covering these commits.  In
addition, there is merge conflict resolution in the branch
for_linus_merge covering a relatively simple fixup needed in
fs/ext4/ioctl.c.

Thanks!!

                                                - Ted

The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Akinobu Mita (1):
      ext4: use proper little-endian bitops

Ben Hutchings (1):
      ext4: Report max_batch_time option correctly

Curt Wohlgemuth (1):
      ext4: remove unused local variable

Djalal Harouni (2):
      ext4: add missing ext4_resize_end on error paths
      ext4: make local symbol ext4_initxattrs static

Eric Sandeen (1):
      ext4: make more symbols static

Jan Kara (2):
      ext4: fix error handling on inode bitmap corruption
      jbd2: fix hung processes in jbd2_journal_lock_updates()

Robin Dong (1):
      ext4: optimize ext4_find_delalloc_range() in nodelalloc mode

Theodore Ts'o (3):
      ext4: remove unneeded file_remove_suid() from ext4_ioctl()
      ext4: avoid counting the number of free inodes twice in find_group_orlov()
      ext4: reserve new feature flag codepoints

Xi Wang (1):
      ext4: fix undefined behavior in ext4_fill_flex_info()

Yongqiang Yang (16):
      ext4: do not reference pa_inode from group_pa
      ext4: allocate delalloc blocks before changing journal mode
      ext4: flush journal when switching from data=journal mode
      jbd2: clear revoked flag on buffers before a new transaction started
      ext4: add a function which extends a group without checking parameters
      ext4: add a function which adds a new group descriptors to a fs
      ext4: add a structure which will be used by 64bit-resize interface
      ext4: add a function which sets up group blocks of a flex bg
      ext4: add a function which sets up a block group descriptors of a flex bg
      ext4: add a function which updates the super block during online resizing
      ext4: pass verify_reserved_gdb() the number of group decriptors
      ext4: add a new function which allocates bitmaps and inode tables
      ext4: add a new function which adds a flex group to a fs
      ext4: add new online resize interface
      ext4: let ext4_group_extend() use common code
      ext4: let ext4_group_add() use common code

Zheng Liu (3):
      ext4: add missing space to ext4_msg output in ext4_fill_super()
      ext4: add missing spaces to debugging printk's
      ext4: remove no longer used functions in inode.c

 Documentation/filesystems/ext4.txt |    7 +
 fs/ext4/balloc.c                   |    4 +-
 fs/ext4/ext4.h                     |   29 +-
 fs/ext4/extents.c                  |   10 +-
 fs/ext4/ialloc.c                   |   18 +-
 fs/ext4/inode.c                    |  143 +----
 fs/ext4/ioctl.c                    |   87 +++-
 fs/ext4/mballoc.c                  |    2 +-
 fs/ext4/resize.c                   | 1175 +++++++++++++++++++++++++++---------
 fs/ext4/super.c                    |   11 +-
 fs/ext4/xattr_security.c           |    5 +-
 fs/jbd2/commit.c                   |    6 +
 fs/jbd2/revoke.c                   |   34 +
 fs/jbd2/transaction.c              |    5 +-
 include/linux/jbd2.h               |    1 +
 include/trace/events/ext4.h        |    6 +-
 16 files changed, 1080 insertions(+), 463 deletions(-)
