From: ck ya <ykwan0201@gmail.com>
Subject: fsck get error with the file which is > 2TB in 4k block file system
Date: Thu, 21 Oct 2010 11:51:52 +0800
Message-ID: <AANLkTik6mjHAZG2ePmDyBmb6CRhV8=dD_tTTdhCzykca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59527 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab0JUDvx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Oct 2010 23:51:53 -0400
Received: by yxm8 with SMTP id 8so2085806yxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Oct 2010 20:51:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I compiled the latest e2fsprogs, and do fsck with -nvf on my ext4 file system.
It showed
Inode 18, i_blocks is 17179870744, should be 17179870744. Fix? no
The i_blocks is the same.

I found ext2fs_inode_i_blocks() has problem.  The function check
EXT4_FEATURE_RO_COMPAT_HUGE_FILE with "s_feature_compat".  It should
be "s_feature_ro_compat".

Thanks.

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index a48b696..d67c6ec 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -49,7 +49,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
                                        struct ext2_inode *inode)
 {
        return (inode->i_blocks |
-               ((fs->super->s_feature_incompat &
+               ((fs->super->s_feature_ro_incompat &
                  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
                 (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
                (inode->i_file_acl ? fs->blocksize >> 9 : 0);
@@ -62,7 +62,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
                                        struct ext2_inode *inode)
 {
        return (inode->i_blocks |
-               ((fs->super->s_feature_incompat &
+               ((fs->super->s_feature_ro_incompat &
                  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
                 (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
 }
