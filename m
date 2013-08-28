From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Wed, 28 Aug 2013 13:25:50 +0800
Message-ID: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:63240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3H1Fac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This option is used for adding the files from the root-directory to the
filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
support ext4.

* Questions
  - Is such an option acceptable ?

  - Most of the code have been in debugfs/debugfs.c already, I moved them to
    misc/util.c and modified them to let both mke2fs and debugfs can use them,
    maybe we should put these code in another separate file ?

  - Where can I get the up-to-date development git repo, please? I think that
    there would be conflicts with the dev git repo, I'd like to rebase it if I
    can get the repo, currently, I'm using this one:

    http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git

* The size impact on misc/mke2fs:
   1,677,297 -> 1,728,110 (non stripped, about 50K increases)
   316,968 -> 325,160 (stripped, 8K increases)

Please feel free to give your comments.

// Robert

Robert Yang (10):
  mke2fs.c: add an option: -d root-directory
  misc/util.c: implement populate_fs()
  misc/util.c: create special file
  misc/util.c: create symlink
  misc/util.c: copy regular file
  misc/util.c: create directory
  misc/util.c: set more information for inode
  misc/util.c: handle hardlinks
  mke2fs.8.in: update the manual for the -d option
  debugfs: use the functions in misc/util.c

 debugfs/Makefile.in |   7 +-
 debugfs/debugfs.c   | 251 ++-----------------------
 debugfs/debugfs.h   |   1 +
 misc/mke2fs.8.in    |   7 +
 misc/mke2fs.c       |  39 +++-
 misc/util.c         | 519 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/util.h         |  32 ++++
 7 files changed, 614 insertions(+), 242 deletions(-)

-- 
1.8.1.2

