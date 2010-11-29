From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 06/15] libext2fs: invalid EXT4_FEATURE_RO_COMPAT_HUGE_FILE checks
Date: Mon, 29 Nov 2010 17:55:08 +0900
Message-ID: <1291020917-8671-7-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43225 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0K2Izh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:37 -0500
Received: by mail-gx0-f174.google.com with SMTP id 22so1868483gxk.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:37 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It should be checked with fs->super->s_feature_ro_compat instead of
->s_feature_incompat.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/blknum.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index a48b696..b3e6dca 100644
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
1.7.0.4

