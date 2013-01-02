From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.8
Date: Tue, 01 Jan 2013 19:41:00 -0500
Message-ID: <nsxsj6kl8mb.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41252 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab3ABAlE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 19:41:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit bd9926e80330d43f15b710c2935fa41b792d56fd:

  ext4: zero out inline data using memset() instead of empty_zero_page (2012-12-11 03:31:49 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 0e9a9a1ad619e7e987815d20262d36a2f95717ca:

  ext4: avoid hang when mounting non-journal filesystems with orphan list (2012-12-27 01:42:50 -0500)

----------------------------------------------------------------
Various bug fixes for ext4.  Perhaps the most serious bug fixed is one
which could cause file system corruptions when performing file punch
operations.

----------------------------------------------------------------
Andy Lutomirski (1):
      ext4: fix an incorrect comment about i_mutex

Eric Sandeen (2):
      ext4: remove unaligned AIO warning printk
      ext4: include journal blocks in df overhead calcs

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Jan Kara (4):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()
      ext4: split off ext4_journalled_invalidatepage()
      ext4: fix deadlock in journal_unmap_buffer()

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Theodore Ts'o (2):
      ext4: lock i_mutex when truncating orphan inodes
      ext4: avoid hang when mounting non-journal filesystems with orphan list

 fs/ext4/extents.c           | 22 ++++++++--
 fs/ext4/file.c              |  8 ----
 fs/ext4/fsync.c             |  2 -
 fs/ext4/inode.c             | 99 ++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/namei.c             |  3 +-
 fs/ext4/super.c             | 30 ++++++++------
 fs/jbd2/transaction.c       | 30 +++++++-------
 include/linux/jbd2.h        |  2 +-
 include/trace/events/ext4.h | 14 ++++++-
 9 files changed, 152 insertions(+), 58 deletions(-)
