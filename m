From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: handle symlink properly with inline_data
Date: Mon,  2 Jun 2014 19:39:28 +0800
Message-ID: <1401709168-27403-1-git-send-email-wenqing.lz@taobao.com>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63907 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBLcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 07:32:16 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1814848pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 Jun 2014 04:32:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit tries to fix a bug that we can't read symlink properly with
inline data feature when the length of symlink is greater than 60 bytes
but less than extra space.

The key issue is in ext4_inode_is_fast_symlink() that it doesn't check
whether or not an inode has inline data.  When the user creates a new
symlink, an inode will be allocated with MAY_INLINE_DATA flag.  Then
symlink will be stored in ->i_block and extended attribute space.  In
the mean time, this inode is with inline data flag.  After remounting
it, ext4_inode_is_fast_symlink() function thinks that this inode is a
fast symlink so that the data in ->i_block is copied to the user, and
the data in extra space is trimmed.  In fact this inode should be as a
normal symlink.

The following script can hit this bug.

  #!/bin/bash

  cd ${MNT}
  filename=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
  rm -rf test
  mkdir test
  cd test
  echo "hello" >$filename
  ln -s $filename symlinkfile
  cd
  sudo umount /mnt/sda1
  sudo mount -t ext4 /dev/sda1 /mnt/sda1
  readlink /mnt/sda1/test/symlinkfile

After applying this patch, it will break the assumption in e2fsck
because the original implementation doesn't want to support symlink
with inline data.

Reported-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Reported-by: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Tao Ma <tm@tao.ma>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55f999a..bc5e4c1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -148,6 +148,9 @@ static int ext4_inode_is_fast_symlink(struct inode *inode)
         int ea_blocks = EXT4_I(inode)->i_file_acl ?
 		EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
 
+	if (ext4_has_inline_data(inode))
+		return 0;
+
 	return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
 }
 
-- 
1.7.9.7

