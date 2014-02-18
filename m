From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 3.14
Date: Tue, 18 Feb 2014 11:54:26 -0500
Message-ID: <20140218165426.GA1482@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59605 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaBRQyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 11:54:33 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 37b0791e6a396e9cda060531d3ffb863d93882f9:

  ext4: address a benign compiler warning (2014-02-17 20:50:59 -0500)

----------------------------------------------------------------
Miscellaneous ext4 bug fixes for v3.14

----------------------------------------------------------------
Azat Khuzhin (1):
      ext4: initialize multi-block allocator before checking block descriptors

Dan Carpenter (2):
      jbd2: fix use after free in jbd2_journal_start_reserved()
      ext4: remove an unneeded check in mext_page_mkuptodate()

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Fabian Frederick (1):
      ext4: Add __init marking to init_inodecache

Patrick Palka (1):
      ext4: address a benign compiler warning

Rashika Kheria (1):
      jbd2: mark file-local functions as static

Theodore Ts'o (5):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized
      ext4: clean up error handling in swap_inode_boot_loader()

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

 fs/ext4/ext4.h        |  2 ++
 fs/ext4/extents.c     |  1 +
 fs/ext4/ioctl.c       | 27 ++++++---------------
 fs/ext4/mballoc.h     |  2 +-
 fs/ext4/move_extent.c |  3 +--
 fs/ext4/resize.c      | 34 ++++++++++++++++----------
 fs/ext4/super.c       | 70 +++++++++++++++++++++++++++++------------------------
 fs/jbd2/journal.c     |  6 ++---
 fs/jbd2/transaction.c |  6 +++--
 9 files changed, 80 insertions(+), 71 deletions(-)
