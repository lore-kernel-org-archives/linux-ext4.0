From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 changes for 4.5
Date: Fri, 22 Jan 2016 01:06:39 -0500
Message-ID: <20160122060639.GA4746@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37061 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbcAVGGm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2016 01:06:42 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(I thought I had sent this earlier, but apparently the e-mail never
left my machine.  Apologies if this is a duplicate, but I'm pretty
sure it was never sent on my end.)


The following changes since commit f41683a204ea61568f0fd0804d47c19561f2ee39:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2015-12-07 10:25:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 68ce7bfcd995a8a393b1b14fa67dbc16fa3dc784:

  fs: clean up the flags definition in uapi/linux/fs.h (2016-01-08 16:01:25 -0500)

----------------------------------------------------------------
Some locking and page fault bug fixes from Jan Kara, some ext4
encryption fixes from me, and Li Xi's Project Quota commits.

----------------------------------------------------------------
Jan Kara (9):
      ext4: fix races between page faults and hole punching
      ext4: move unlocked dio protection from ext4_alloc_file_blocks()
      ext4: fix races between buffered IO and collapse / insert range
      ext4: fix races of writeback with punch hole and zero range
      ext4: document lock ordering
      ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag
      ext4: provide ext4_issue_zeroout()
      ext4: implement allocation of pre-zeroed blocks
      ext4: use pre-zeroed blocks for DAX page faults

Li Xi (3):
      ext4: adds project ID support
      ext4: add project quota support
      ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support

Theodore Ts'o (3):
      ext4 crypto: add missing locking for keyring_key access
      ext4 crypto: simplify interfaces to directory entry insert functions
      fs: clean up the flags definition in uapi/linux/fs.h

 fs/ext4/crypto.c            |   6 +-
 fs/ext4/crypto_key.c        |   4 +
 fs/ext4/ext4.h              |  99 ++++++++++++++++++++---
 fs/ext4/extents.c           | 153 +++++++++++++++++++----------------
 fs/ext4/file.c              |  82 +++++++++++++------
 fs/ext4/ialloc.c            |   7 ++
 fs/ext4/inline.c            |  10 +--
 fs/ext4/inode.c             | 268 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/ioctl.c             | 376 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 fs/ext4/namei.c             |  34 +++++---
 fs/ext4/super.c             |  97 ++++++++++++++++++++--
 fs/ext4/truncate.h          |   2 +
 include/trace/events/ext4.h |   2 +-
 include/uapi/linux/fs.h     |  31 ++++++-
 14 files changed, 895 insertions(+), 276 deletions(-)
