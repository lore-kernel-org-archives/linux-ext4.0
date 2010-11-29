From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 00/15] e2fsprogs cleanups
Date: Mon, 29 Nov 2010 17:55:02 +0900
Message-ID: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0K2IzY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:24 -0500
Received: by gwj20 with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This is a series of small patches that I found during reading the
mke2fs code. Most of them are fix of (potential) memory leaks and
addition of more error checks. Plus a couple of dubious code fix
and trivial cleanups. The man page of mke2fs also be updated.

Any comments/suggestions are welcomed.
Thanks.

---

Namhyung Kim (15):
  libext2fs: fix potential build failure with OMIT_COM_ERR
  libext2fs: fix dubious code in ext2fs_numeric_progress_init()
  mke2fs: simplify inode table block counting
  libext2fs: remove unnecessary casts to ext2fs_generic_bitmap
  libext2fs: fix dubious code in ext2fs_unmark_generic_bitmap()
  libext2fs: invalid EXT4_FEATURE_RO_COMPAT_HUGE_FILE checks
  libext2fs: fix error path in ext2fs_update_bb_inode()
  libext2fs: fix memory leak on error path
  mke2fs: check return value of e2p_os2string()
  mke2fs.8.in: add missing "big" and "huge" usage-type description
  mke2fs: fix determination of size_type
  mke2fs: add some error checks into PRS()
  mke2fs: fix potential memory leak in mke2fs_setup_tdb()
  libext2fs: fix possible memory leak in write_journal_inode()
  mke2fs.8.in: add ENVIRONMENT section

 lib/ext2fs/bb_inode.c     |    6 ++-
 lib/ext2fs/blknum.c       |    4 +-
 lib/ext2fs/gen_bitmap.c   |   14 ++++----
 lib/ext2fs/gen_bitmap64.c |   69 +++++++++++++++++----------------------------
 lib/ext2fs/inode_io.c     |    4 ++-
 lib/ext2fs/mkjournal.c    |    1 +
 lib/ext2fs/progress.c     |    2 +-
 misc/mke2fs.8.in          |   34 +++++++++++++++++++++-
 misc/mke2fs.c             |   52 ++++++++++++++++++++++++----------
 9 files changed, 114 insertions(+), 72 deletions(-)

