From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/9] e2fsprogs: fix quota support
Date: Sun, 11 May 2014 00:32:44 -0400
Message-ID: <1399782773-20029-1-git-send-email-tytso@mit.edu>
Cc: adityakali@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60798 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbaEKEdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:33:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got tired of quota being broken, so this patch set fixes all of the
known problems with e2fsck fixing up corrupted quota records.  The quota
library API is still not what I would call ideal, but cleanups can wait
for the 1.43 branch.

Theodore Ts'o (9):
  quota: add debugging code to print the dquot structure
  quota: fix e2fsck so we update the quota file correctly
  quota: fix e2fsck to notice missing quota entries
  quota: fix memory leak in quota_compare_and_update()
  quota: integrate mkquota.h into quotaio.h
  quota: support storing the quota file handles in the quota context
  debugfs: add commands to query the quota information
  tests: add basic e2fsck regression test for fixing the quota inode
  quota: remove warning message that we have fixed the nasty quota bugs

 debian/rules               |   4 -
 debugfs/Makefile.in        | 177 ++++++++++++++++++++++++++++++------------
 debugfs/debug_cmds.ct      |   6 ++
 debugfs/debugfs.c          |   3 +
 debugfs/debugfs.h          |   6 ++
 debugfs/quota.c            | 170 +++++++++++++++++++++++++++++++++++++++++
 debugfs/ro_debug_cmds.ct   |   7 +-
 e2fsck/Makefile.in         | 186 +++++++++++++++++++--------------------------
 e2fsck/e2fsck.h            |   2 +-
 e2fsck/quota.c             |   1 -
 lib/quota/Makefile.in      |  59 ++++----------
 lib/quota/common.h         |   1 +
 lib/quota/mkquota.c        |  71 ++++++++++++++---
 lib/quota/mkquota.h        |  64 ----------------
 lib/quota/quota.pc.in      |  11 ---
 lib/quota/quotaio.c        |  64 +++++++++++++---
 lib/quota/quotaio.h        |  64 +++++++++++++++-
 misc/Makefile.in           |  14 ++--
 misc/ext4.5.in             |   7 --
 misc/mke2fs.c              |   9 +--
 misc/tune2fs.c             |   6 +-
 tests/f_quota/debugfs-cmds |   7 ++
 tests/f_quota/expect.0     |  21 +++++
 tests/f_quota/expect.1     |  13 ++++
 tests/f_quota/expect.2     |   7 ++
 tests/f_quota/image.gz     | Bin 0 -> 1046 bytes
 tests/f_quota/name         |   1 +
 tests/f_quota/script       |   4 +
 tests/m_quota/expect.1     |   4 -
 29 files changed, 650 insertions(+), 339 deletions(-)
 create mode 100644 debugfs/quota.c
 delete mode 100644 lib/quota/mkquota.h
 delete mode 100644 lib/quota/quota.pc.in
 create mode 100644 tests/f_quota/debugfs-cmds
 create mode 100644 tests/f_quota/expect.0
 create mode 100644 tests/f_quota/expect.1
 create mode 100644 tests/f_quota/expect.2
 create mode 100644 tests/f_quota/image.gz
 create mode 100644 tests/f_quota/name
 create mode 100644 tests/f_quota/script

-- 
1.9.0

