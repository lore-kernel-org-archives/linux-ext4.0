From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 3.13
Date: Thu, 26 Dec 2013 00:34:38 -0500
Message-ID: <20131226053438.GA20084@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43457 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3LZFek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Dec 2013 00:34:40 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to f5a44db5d2d677dfbf12deee461f85e9ec633961:

  ext4: add explicit casts when masking cluster sizes (2013-12-20 09:29:35 -0500)

----------------------------------------------------------------
A collection of bug fixes destined for stable and some printk cleanups
and a patch so that instead of BUG'ing we use the ext4_error()
framework to mark the file system is corrupted.

----------------------------------------------------------------
Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Dmitry Monakhov (1):
      jbd2: rename obsoleted msg JBD->JBD2

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Jan Kara (3):
      ext4: Do not reserve clusters when fs doesn't support extents
      jbd2: revise KERN_EMERG error messages
      ext4: fix deadlock when writing in ENOSPC conditions

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Theodore Ts'o (3):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      jbd2: don't BUG but return ENOSPC if a handle runs out of space
      ext4: add explicit casts when masking cluster sizes

 fs/ext4/ext4.h        | 10 ++++++++++
 fs/ext4/ext4_jbd2.c   |  9 +++++++++
 fs/ext4/extents.c     | 45 ++++++++++++++++++++++++++++++---------------
 fs/ext4/inode.c       | 12 ------------
 fs/ext4/mballoc.c     | 17 +++++++++++------
 fs/ext4/super.c       | 21 +++++++++++++++------
 fs/jbd2/journal.c     | 18 ++++++++----------
 fs/jbd2/recovery.c    |  2 +-
 fs/jbd2/transaction.c | 16 +++++++++-------
 9 files changed, 93 insertions(+), 57 deletions(-)
