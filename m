From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/10] Fix 64-bit type conversion issues in e2fsck
Date: Tue,  3 Dec 2013 00:10:08 -0500
Message-ID: <1386047418-32431-1-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35873 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3LCFKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:31 -0500
In-Reply-To: <20131203002503.GA18601@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This should fix most of the 64-bit type conversion issues in e2fsck.
Thanks to Kit Westneat for pointing out that we might have some problems
in this area.

					- Ted

Eric Whitney (1):
  libext2fs: fix printf conversion spec in tst_iscan.c

Theodore Ts'o (9):
  e2fsck: use problem_t to suppress some -Wconversion warnings
  e2fsck: use errcode_t to suppress some -Wconversion warnings
  e2fsck: use blk_t instead of blk64_t in check_resize_inode()
  dumpe2fs: fix printing of block offsets for 64-bit file systems
  libext2fs: add explicit casts to ext2fs.h
  libext2fs: add explicit casts to bitops.h
  e2fsck: fix j_maxlen if the file system is exactly 1 << 32 blocks
  e2fsck: add support for 64-bit extended attribute block refcounting
  e2fsck: use dgrp_t for block group numbers

 e2fsck/e2fsck.h        | 15 +++++++--------
 e2fsck/ea_refcount.c   | 18 +++++++++---------
 e2fsck/journal.c       | 30 +++++++++++++++---------------
 e2fsck/message.c       |  2 +-
 e2fsck/pass1.c         | 16 +++++++++-------
 e2fsck/pass1b.c        |  8 ++++----
 e2fsck/pass2.c         | 14 +++++++-------
 e2fsck/pass4.c         |  2 +-
 e2fsck/pass5.c         | 24 +++++++++++++-----------
 e2fsck/problem.h       |  2 +-
 e2fsck/rehash.c        |  2 +-
 e2fsck/super.c         |  2 +-
 e2fsck/unix.c          |  2 +-
 e2fsck/util.c          |  8 ++++----
 lib/ext2fs/bitops.h    | 18 +++++++++---------
 lib/ext2fs/ext2fs.h    | 10 +++++-----
 lib/ext2fs/tst_iscan.c |  2 +-
 misc/dumpe2fs.c        |  2 +-
 18 files changed, 90 insertions(+), 87 deletions(-)

-- 
1.8.5.rc3.362.gdf10213

