From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V4 00/11] 2fsprogs/mke2fs: add an option: -d root-directory
Date: Sat, 1 Mar 2014 03:06:04 -0500
Message-ID: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:38812 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaCAIGV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Mar 2014 03:06:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Changes of V4:
  - Rebase to the up to date master branch
  - Fix the skip of socket file (break -> continue)

* Changes of V3:
  - __FUNCTION__ -> __func__
  - Rebase to the up to date master branch

* Changes of V2:
  - Add the "-d" option when the code is ready rather than add it in the
    first commit.
  - Remove "name = name"
  - func_name -> __FUNCTION__
  - The size impact on mke2fs:
    a) Not stripped:
       1,837,440 -> 1,903,522 (64K increased)
    b) Stripped:
       329,464 -> 321,272 (8K increased) 
    No impact on tune2fs

* Changes from the RFC patches:
  - Move the common code of debugfs and mke2fs to misc/create_inode.c to
    avoid bloating the tune2fs binary
  - Fix the error of "make check"
  - Rebase to the up to date master branch

// Robert

Robert Yang (11):
  mke2fs: add the ability to copy files from a given directory
  misc/create_inode.c: copy files recursively
  misc/create_inode.c: create special file
  misc/create_inode.c: create symlink
  misc/create_inode.c: copy regular file
  misc/create_inode.c: create directory
  misc/create_inode.c: set owner/mode/time for the inode
  mke2fs.c: add an option: -d root-directory
  misc/create_inode.c: handle hardlinks
  debugfs: use the functions in misc/create_inode.c
  mke2fs.8.in: update the manual for the -d option

 debugfs/Makefile.in |   17 +-
 debugfs/debugfs.c   |  305 ++-------------------------
 debugfs/debugfs.h   |    1 +
 misc/Makefile.in    |   13 +-
 misc/create_inode.c |  574 +++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/create_inode.h |   35 ++++
 misc/mke2fs.8.in    |    7 +
 misc/mke2fs.c       |   43 +++-
 8 files changed, 690 insertions(+), 305 deletions(-)
 create mode 100644 misc/create_inode.c
 create mode 100644 misc/create_inode.h

-- 
1.7.10.4

