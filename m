Return-Path: <SRS0=sDDi=PO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr680118.outbound.protection.outlook.com ([40.107.68.118]:39782
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbfAFNjv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Jan 2019 08:39:51 -0500
Date: Sun, 6 Jan 2019 08:39:43 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ext4 bug fixes for 4.21
Message-ID: <20190106133943.GA10099@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 18f2c4fcebf2582f96cbd5f2238f4f354a0e4847:

  ext4: check for shutdown and r/o file system in ext4_write_inode() (2018-12-19 14:36:58 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 191ce17876c9367819c4b0a25b503c0f6d9054d8:

  ext4: fix special inode number checks in __ext4_iget() (2018-12-31 22:34:31 -0500)

----------------------------------------------------------------
Fix a number of ext4 bugs.

----------------------------------------------------------------
Theodore Ts'o (6):
      ext4: make sure enough credits are reserved for dioread_nolock writes
      ext4: fix a potential fiemap/page fault deadlock w/ inline_data
      ext4: avoid kernel warning when writing the superblock to a dead device
      ext4: use ext4_write_inode() when fsyncing w/o a journal
      ext4: track writeback errors using the generic tracking infrastructure
      ext4: fix special inode number checks in __ext4_iget()

 fs/ext4/fsync.c  | 16 ++++++++++++----
 fs/ext4/inline.c |  6 +++---
 fs/ext4/inode.c  |  5 +++--
 fs/ext4/super.c  |  2 +-
 4 files changed, 19 insertions(+), 10 deletions(-)
