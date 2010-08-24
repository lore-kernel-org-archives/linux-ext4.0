From: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Fix EXT4_FEATURE_RO_COMPAT_HUGE_FILE check
Date: Tue, 24 Aug 2010 01:34:16 +0000
Message-ID: <4c7325f6.02558f0a.5a24.ffffc694@mx.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39997 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0HXBwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2010 21:52:55 -0400
Received: by pvg2 with SMTP id 2so2492263pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 18:52:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Creating a 4TB file on a filesystem with the 64bit flag set results in e2fsck consistently complaining about i_blocks being wrong, with confusing messages like this:

Inode 29818882, i_blocks is 8388608816, should be 8388608816.  Fix? no

That appears to be caused by ext2fs_inode_i_blocks() checking for the EXT4_FEATURE_RO_COMPAT_HUGE_FILE in the wrong place.  Fix it.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 lib/ext2fs/blknum.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index a48b696..560edc7 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -49,7 +49,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
 	return (inode->i_blocks |
-		((fs->super->s_feature_incompat &
+		((fs->super->s_feature_ro_compat &
 		  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
 		 (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
 		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
@@ -62,7 +62,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
 	return (inode->i_blocks |
-		((fs->super->s_feature_incompat & 
+		((fs->super->s_feature_ro_compat & 
 		  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
 		 (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
 }
-- 
1.5.6.5

