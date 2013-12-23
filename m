From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Mon, 23 Dec 2013 07:09:50 -0500
Message-ID: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:52627 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3LWMKG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I'm very sorry for the late response, I've fixed the problems which you 
pointed out in the RFC patches, and now the "make check" works well.

* Changes from the RFC patches:
  - Move the common code of debugfs and mke2fs to misc/create_inode.c to
    avoid bloating the tune2fs binary
  - Fix the error of "make check"
  - Rebase to the up to date master branch

Merry Christmas and Happy New Year!

// Robert

Robert Yang (10):
  mke2fs.c: add an option: -d root-directory
  misc/create_inode.c: copy files recursively
  misc/create_inode.c: create special file
  misc/create_inode.c: create symlink
  misc/create_inode.c: copy regular file
  misc/create_inode.c: create directory
  misc/create_inode.c: set owner/mode/time for the inode
  misc/create_inode.c: handle hardlinks
  debugfs: use the functions in misc/create_inode.c
  mke2fs.8.in: update the manual for the -d option

 debugfs/Makefile.in |   17 +-
 debugfs/debugfs.c   |  305 ++-------------------------
 debugfs/debugfs.h   |    1 +
 misc/Makefile.in    |   13 +-
 misc/create_inode.c |  575 +++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/create_inode.h |   35 ++++
 misc/mke2fs.8.in    |    7 +
 misc/mke2fs.c       |   43 +++-
 8 files changed, 691 insertions(+), 305 deletions(-)
 create mode 100644 misc/create_inode.c
 create mode 100644 misc/create_inode.h

-- 
1.7.10.4

