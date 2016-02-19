From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 4.5
Date: Fri, 19 Feb 2016 15:03:40 -0500
Message-ID: <20160219200340.GA9571@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57616 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbcBSUDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 15:03:43 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 36f90b0a2ddd60823fe193a85e60ff1906c2a9b3:

  Linux 4.5-rc2 (2016-01-31 18:12:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 74dae4278546b897eb81784fdfcce872ddd8b2b8:

  ext4: fix crashes in dioread_nolock mode (2016-02-19 00:33:21 -0500)

----------------------------------------------------------------
Miscellaneous ext4 bug fixes for v4.5

----------------------------------------------------------------
Anton Protopopov (1):
      ext4: ioctl: fix erroneous return value

Eryu Guan (2):
      ext4: don't read blocks from disk after extents being swapped
      ext4: remove unused parameter "newblock" in convert_initialized_extent()

Huaitong Han (1):
      ext4: add a line break for proc mb_groups display

Insu Yun (1):
      ext4: fix potential integer overflow

Jan Kara (3):
      ext4: fix scheduling in atomic on group checksum failure
      ext4: fix bh->b_state corruption
      ext4: fix crashes in dioread_nolock mode

Kirill Tkhai (1):
      ext4: fix memleak in ext4_readdir()

Theodore Ts'o (2):
      ext4 crypto: revalidate dentry after adding or removing the key
      ext4 crypto: move context consistency check to ext4_file_open()

 fs/ext4/balloc.c      |  7 ++++---
 fs/ext4/crypto.c      | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c         | 13 +++++++++++--
 fs/ext4/ext4.h        |  1 +
 fs/ext4/extents.c     |  4 ++--
 fs/ext4/file.c        |  9 +++++++++
 fs/ext4/ialloc.c      |  6 ++++--
 fs/ext4/inode.c       | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 fs/ext4/ioctl.c       |  2 +-
 fs/ext4/mballoc.c     |  2 +-
 fs/ext4/move_extent.c | 15 ++++++++++++---
 fs/ext4/namei.c       | 26 ++++++++++++++++++++++++--
 fs/ext4/resize.c      |  2 +-
 13 files changed, 176 insertions(+), 39 deletions(-)
