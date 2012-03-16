From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/9] ext4: Message logging corrections and neatening
Date: Thu, 15 Mar 2012 17:07:28 -0700
Message-ID: <cover.1331856299.git.joe@perches.com>
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53242 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750Ab2CPAHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Mar 2012 20:07:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Joe Perches (9):
  ext4: Add -DDEBUG to Makefile
  ext4: Use pr_fmt and pr_<level>
  ext4: Fix indentation
  ext4: Add no_printk argument validation, fix fallout
  ext4: Avoid output message interleaving in ext4_error_<foo>
  ext4: Remove redundant "EXT4-fs: " from uses of ext4_msg
  ext4: Format neatening for easier grep
  ext4: Neaten ext4_error uses
  ext4: Rename ext4_warning to ext4_warn and ext4_error to ext4_err

 fs/ext4/Makefile         |    2 +
 fs/ext4/balloc.c         |   38 ++--
 fs/ext4/block_validity.c |   11 +-
 fs/ext4/dir.c            |    5 +-
 fs/ext4/ext4.h           |   31 ++--
 fs/ext4/ext4_extents.h   |    4 +-
 fs/ext4/ext4_jbd2.c      |    3 +-
 fs/ext4/extents.c        |  140 +++++++--------
 fs/ext4/file.c           |    3 +-
 fs/ext4/fsync.c          |    2 +-
 fs/ext4/ialloc.c         |   75 ++++----
 fs/ext4/indirect.c       |   12 +-
 fs/ext4/inode.c          |   95 +++++-----
 fs/ext4/mballoc.c        |  163 ++++++++---------
 fs/ext4/mballoc.h        |   18 +-
 fs/ext4/mmp.c            |   39 ++---
 fs/ext4/move_extent.c    |   94 ++++------
 fs/ext4/namei.c          |  140 +++++++-------
 fs/ext4/page-io.c        |   29 ++--
 fs/ext4/resize.c         |  202 ++++++++++-----------
 fs/ext4/super.c          |  465 ++++++++++++++++++++++------------------------
 fs/ext4/xattr.c          |   37 ++--
 22 files changed, 766 insertions(+), 842 deletions(-)

-- 
1.7.8.111.gad25c.dirty

