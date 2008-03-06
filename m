From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Date: Thu,  6 Mar 2008 01:59:08 +0000
Message-ID: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1424 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYCFCF7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2008 21:05:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At present, as discussed in this LKML thread,
http://marc.info/?l=linux-kernel&m=117607695406580, when a dirty ext3
filesystem is mounted read-only it writes to the disk while replaying the
journal log and cleaning up the orphan list. This behaviour may surprise users
and can potentially cause data corruption/loss (e.g. if a system is suspended,
booted into a different OS, then resumed).

This patch series attempts to address this by using a block translation table
instead of replaying the journal on a read-only filesystem.

Patches 1-3 are independent cleanups/bug-fixes for things I came across while
working on this. They could be submitted separately and are not required for
following patches.

Patch 4 is a refactoring change that simplifies the code prior to later
substantive changes.

Patch 5 introduces the translation table and support for a truly read-only
journal into jbd.

Patch 6 uses the facility introduced in patch 5 to add support for true
read-only ext3.

For testing I've been using qemu VMs to create and mount dirtied filesystems. I
have a set of scripts that fully automates creating a dirty filesystem then
checking mounting read-only and read-write produces consistent results. On my
system it can get through around ~30 iteration overnight. If anyone is
interested in the scripts please let me know. Any suggestions for additional
tests or enhancements that could be made to the scripts would be gratefully
received.

TODO:
 * Add R/W remount support
 * Port to ext4

Cheers,
Duane Griffin.

> git diff --stat origin
 fs/ext3/balloc.c        |    2 +-
 fs/ext3/ialloc.c        |    2 +-
 fs/ext3/inode.c         |    8 +-
 fs/ext3/resize.c        |    2 +-
 fs/ext3/super.c         |  123 ++++++++++-----
 fs/ext3/xattr.c         |    8 +-
 fs/jbd/checkpoint.c     |    2 +-
 fs/jbd/commit.c         |    2 +-
 fs/jbd/journal.c        |   68 +++++---
 fs/jbd/recovery.c       |  402 +++++++++++++++++++++++++++++++++--------------
 fs/jbd/revoke.c         |  133 ++++++----------
 fs/ocfs2/journal.c      |    4 +-
 include/linux/ext3_fs.h |    7 +
 include/linux/jbd.h     |   41 +++++-
 14 files changed, 516 insertions(+), 288 deletions(-)

