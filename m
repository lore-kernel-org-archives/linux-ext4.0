From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 0/2] 64 bit inode counter support
Date: Thu,  2 Nov 2017 00:24:53 +0300
Message-ID: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:51576 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbdKAVZB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2017 17:25:01 -0400
Received: by mail-lf0-f65.google.com with SMTP id r129so4055440lff.8
        for <linux-ext4@vger.kernel.org>; Wed, 01 Nov 2017 14:25:01 -0700 (PDT)
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

This is second version of the patch set. Changes since v1:
* code style fixes
* changed feature name to INCOMPAT_INODE64
* inode counters correct swab
* metadata checksum code gets high inode part
* mount-time check to prevent mounting a
  filesystem with 64-bit inodes on a 32-bit kernel

Andreas Dilger (1):
  ext4: dirdata feature

Artem Blagodarenko (1):
  ext4: Add 64-bit inode number support

 fs/ext2/super.c  |   6 +-
 fs/ext4/dir.c    |  21 ++++---
 fs/ext4/ext4.h   | 167 ++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/ialloc.c |  19 ++++---
 fs/ext4/inline.c |  18 +++---
 fs/ext4/namei.c  | 171 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/resize.c |   8 +--
 fs/ext4/super.c  |  17 ++++--
 8 files changed, 341 insertions(+), 86 deletions(-)

-- 
2.13.5 (Apple Git-94)
