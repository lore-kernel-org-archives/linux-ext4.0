From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v4 0/4] 64 bit inode counter support
Date: Fri,  2 Feb 2018 12:41:32 +0300
Message-ID: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36604 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbeBBJll (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Feb 2018 04:41:41 -0500
Received: by mail-lf0-f66.google.com with SMTP id t79so30540306lfe.3
        for <linux-ext4@vger.kernel.org>; Fri, 02 Feb 2018 01:41:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With current hardware clusters faced with the trouble of
creating enough inodes on partitions. Lustre has 0-size
files to store some information about files. Current
MDS disk sizes allow to store large amount of such files, but
EXT4 limits this number to ~4 billions.

Lustre FS has features like DNE to distribute metadata over many targets
(disks), but disks are used not effectively. It would be great to have
ability to store more then ~4 billions inodes on one EXT4 file system.

This patches add 1) dirdata feature, that allow to store additional
data in direntry 2)  code that uses dirdata to store high bits of 
64bit inode number.

This is 4th version of the patch set. Changes since v3:

* ext4_warning_inode() is used to print messages
* DIRENT_INODE_LEN size is 4 bytes
* using structures to access dirdata fields
* some code pieces moved to appropriate patches
* added high part for s_last_orphan, s_first_error_ino, and s_last_error_ino
  fields
* ext4_dirent_inohi changed to ext4_dirent_inode64
* s_inode_goal become 64 bit
* __u64 goal in ext4_ext_migrate()
* added functions set_inode() and get_inode() 
  (in separate patch 3/4)
* 64 bit support in htree_inlinedir_to_tree(), ext4_try_create_inline_dir() and
  ext4_add_dirent_to_inline()
* skip the NUL separator after the name 
* high part of inode number is accessed only if EXT4_DIRENT_INODE64 enabled
* 64bit support for ext4_rename_dir_prepare(), ext4_rename_dir_finish(),
  ext4_rename_delete(), ext4_cross_rename(), ext4_empty_dir(), ext4_rmdir(),
  ext4_rename(), ext4_unlink(), and ext4_setent() 
* heleper functions for access to high part of superblock fields
  based on macroses
* high part of inode number is copied to prevent align problems
* style fixes

Andreas Dilger (1):
  ext4: dirdata feature

Artem Blagodarenko (2):
  ext4: Add helper functions to access inode numbers
  ext4: Add 64-bit inode number support

Yang Sheng (1):
  ext4: Removes static definition of dx_root struct

 fs/ext4/dir.c     |  20 ++-
 fs/ext4/ext4.h    | 182 +++++++++++++++++++++----
 fs/ext4/ialloc.c  |  19 ++-
 fs/ext4/inline.c  |  47 ++++---
 fs/ext4/inode.c   |   5 +
 fs/ext4/migrate.c |   2 +-
 fs/ext4/namei.c   | 390 ++++++++++++++++++++++++++++++++++++++----------------
 fs/ext4/resize.c  |   8 +-
 fs/ext4/super.c   |  54 ++++----
 9 files changed, 528 insertions(+), 199 deletions(-)

-- 
2.14.3 (Apple Git-98)
