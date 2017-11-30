From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 0/3] 64 bit inode counter support
Date: Thu, 30 Nov 2017 18:17:50 +0300
Message-ID: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:40758 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbdK3PR6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 10:17:58 -0500
Received: by mail-lf0-f66.google.com with SMTP id t197so8286149lfe.7
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 07:17:58 -0800 (PST)
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

This is third version of the patch set. Changes since v2:
* added patch "Removes static definition of dx_root struct"
* __le32 used for on-disk data structures
* used __u8 type not char
* macroses __EXT4_DIR_REC_LEN and EXT4_DIR_REC_LEN renamed
* added structures to address dirent fields
* removed BUG_ON() execution
* no need to add s_usr_quota_inum_hi and s_grp_quota_inum_hi
* checksum using high part of inode
* fixed bug in size check code

Andreas Dilger (1):
  ext4: dirdata feature

Artem Blagodarenko (1):
  ext4: Add 64-bit inode number support

Yang Sheng (1):
  ext4: Removes static definition of dx_root struct

 fs/ext4/dir.c    |  21 ++--
 fs/ext4/ext4.h   | 184 +++++++++++++++++++++++++++++++----
 fs/ext4/ialloc.c |  19 ++--
 fs/ext4/inline.c |  18 ++--
 fs/ext4/inode.c  |   5 +
 fs/ext4/namei.c  | 289 ++++++++++++++++++++++++++++++++++++++-----------------
 fs/ext4/resize.c |   8 +-
 fs/ext4/super.c  |  17 +++-
 8 files changed, 423 insertions(+), 138 deletions(-)

-- 
2.13.6 (Apple Git-96)
