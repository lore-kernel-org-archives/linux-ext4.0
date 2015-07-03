From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 0/2] fix ext4 i_blocks corruption in generic/269
Date: Sat,  4 Jul 2015 00:51:49 +0800
Message-ID: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32829 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbGCQyZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jul 2015 12:54:25 -0400
Received: by wiwl6 with SMTP id l6so232022787wiw.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2015 09:54:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I find generic/269 fails on ext4 because of i_blocks corruption like

e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Inode 4802, i_blocks is 280, should be 248.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

ext4.img: ********** WARNING: Filesystem still has errors **********

ext4.img: 32752/32768 files (12.0% non-contiguous), 128483/131072 blocks

and find that it has something to do with the setattr and write
operations in fsstress, with delalloc enabled.

This can be reproduced more reliably by

  # disable all other operations except create/mkdir/write/setattr
  # the "-M 524288" restricts the setflags ioctl to EXT4_EXTENTS_FL
  export FSSTRESS_AVOID="-fallocsp=0 -fattr_remove=0 -fattr_set=0 \
  -fbulkstat=0 -fbulkstat1=0 -fchown=0 -fdread=0 -fdwrite=0 \
  -ffallocate=0 -ffiemap=0 -ffreesp=0 -fgetattr=0 -fgetdents=0 \
  -flink=0 -fmknod=0 -fpunch=0 -fzero=0 -fcollapse=0 -finsert=0 \
  -fread=0 -freadlink=0 -frename=0 -fresvsp=0 -frmdir=0 -fsetxattr=0 \
  -fstat=0 -fsymlink=0 -ftruncate=0 -funlink=0 -funresvsp=0 \
  -fsetattr=5 -M 524288"
  while ./check generic/269; do : ; done

And a simplified reproducer is

  xfs_io -fc "pwrite 4k 4k" -c "fsync" /mnt/ext4/testfile
  chattr -e /mnt/ext4/testfile
  xfs_io -c "pwrite 0 4k" /mnt/ext4/testfile
  umount /mnt/ext4
  e2fsck -nf /dev/<device>

More details please see the commit log in patches.

Eryu Guan (2):
  ext4: be more strict when migrating to non-extent based file
  ext4: reserve hole in the migration to non-extent based file

 fs/ext4/migrate.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

-- 
1.8.3.1

