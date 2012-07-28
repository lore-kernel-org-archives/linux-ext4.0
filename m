From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.6
Date: Fri, 27 Jul 2012 23:11:57 -0400
Message-ID: <20120728031157.GA14094@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41752 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab2G1DMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2012 23:12:00 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 03179fe92318e7934c180d96f12eff2cb36ef7b6:

  ext4: undo ext4_calc_metadata_amount if we fail to claim space (2012-07-23 00:00:20 -0400)

----------------------------------------------------------------
The usual collection of bug fixes and optimizations.  Perhaps of
greatest note is a speed up for parallel, non-allocating DIO writes,
since we no longer take the i_mutex lock in that case.  For bug fixes,
we fix an incorrect overhead calculation which caused slightly
incorrect results for df(1) and statfs(2).  We also fixed bugs in the
metadata checksum feature.

----------------------------------------------------------------
Aditya Kali (2):
      ext4: avoid uneeded calls to ext4_mb_load_buddy() while reading mb_groups
      ext4: make quota as first class supported feature

Al Viro (1):
      ext4: fix ext4 mismerge back in January

Artem Bityutskiy (3):
      ext4: remove unnecessary superblock dirtying
      ext4: weed out ext4_write_super
      ext4: remove unnecessary argument from __ext4_handle_dirty_metadata()

Ashish Sangwan (1):
      ext4: fix hole punch failure when depth is greater than 0

Brian Foster (1):
      ext4: don't let i_reserved_meta_blocks go negative

Haibo Liu (1):
      ext4: remove an unused statement in ext4_mb_get_buddy_page_lock()

HaiboLiu (1):
      ext4: fix out-of-date comments in extents.c

Jan Kara (2):
      ext4: remove useless marking of superblock dirty
      ext4: convert last user of ext4_mark_super_dirty() to ext4_handle_dirty_super()

Tao Ma (2):
      ext4: use proper csum calculation in ext4_rename
      ext4: use s_csum_seed instead of i_csum_seed for xattr block

Theodore Ts'o (5):
      ext4: pass a char * to ext4_count_free() instead of a buffer_head ptr
      ext4: fix overhead calculation used by ext4_statfs()
      ext4: remove unused variable in ext4_update_super()
      ext4: remove dynamic array size in ext4_chksum()
      ext4: undo ext4_calc_metadata_amount if we fail to claim space

Zheng Liu (4):
      ext4: honor O_(D)SYNC semantic in ext4_fallocate()
      ext4: split ext4_file_write into buffered IO and direct IO
      ext4: add a new nolock flag in ext4_map_blocks
      ext4: don't take the i_mutex lock when doing DIO overwrites

 fs/ext4/balloc.c    |   3 +-
 fs/ext4/bitmap.c    |  12 +-
 fs/ext4/ext4.h      |  26 ++---
 fs/ext4/ext4_jbd2.c |   8 +-
 fs/ext4/ext4_jbd2.h |  25 ++--
 fs/ext4/extents.c   |  51 +++++----
 fs/ext4/file.c      | 121 ++++++++++++++++----
 fs/ext4/ialloc.c    |   5 +-
 fs/ext4/inode.c     | 126 ++++++++++++++++----
 fs/ext4/ioctl.c     |   1 -
 fs/ext4/mballoc.c   |  26 +++--
 fs/ext4/namei.c     |  15 ++-
 fs/ext4/resize.c    |   7 +-
 fs/ext4/super.c     | 323 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/xattr.c     |  11 +-
 15 files changed, 563 insertions(+), 197 deletions(-)

