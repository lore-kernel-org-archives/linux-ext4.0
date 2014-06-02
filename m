From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/2] e2fsck: handle symlink properly with inline data
Date: Mon,  2 Jun 2014 19:40:40 +0800
Message-ID: <1401709241-27521-1-git-send-email-wenqing.lz@taobao.com>
Cc: Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51652 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaFBLd0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 07:33:26 -0400
Received: by mail-pd0-f177.google.com with SMTP id g10so3318131pdj.22
        for <linux-ext4@vger.kernel.org>; Mon, 02 Jun 2014 04:33:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After fixing a bug on kernel side for handling symlink properly with
inline data, it will break the assumption in e2fsck because in original
patch set of inline data it doesn't support symlink with inline data
feature.  This commit makes e2fsck handle symlink properly with inline
data.

After applied this patch, the inline data feature has ability to store
the symlink.  We also need to add this ability for symlink commmand in
debugfs.

Cc: Ian Nartowicz <claws@nartowicz.co.uk>
Cc: Tao Ma <tm@tao.ma>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e1012c0..ba60029 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -177,8 +177,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2fs_extent	extent;
 
 	if ((inode->i_size_high || inode->i_size == 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL) ||
-	    (inode->i_flags & EXT4_INLINE_DATA_FL))
+	    (inode->i_flags & EXT2_INDEX_FL))
 		return 0;
 
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
@@ -203,6 +202,17 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		return i;
 	}
 
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		size_t inline_size;
+
+		if (ext2fs_inline_data_size(fs, ino, &inline_size))
+			return 0;
+		if (inode->i_size != inline_size)
+			return 0;
+
+		return 1;
+	}
+
 	blocks = ext2fs_inode_data_blocks2(fs, inode);
 	if (blocks) {
 		if ((inode->i_size >= fs->blocksize) ||
@@ -1189,7 +1199,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 						      block_buf)) {
 			check_immutable(ctx, &pctx);
 			ctx->fs_symlinks_count++;
-			if (ext2fs_inode_data_blocks(fs, inode) == 0) {
+			if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+				continue;
+			} else if (ext2fs_inode_data_blocks(fs, inode) == 0) {
 				ctx->fs_fast_symlinks_count++;
 				check_blocks(ctx, &pctx, block_buf);
 				continue;
-- 
1.7.9.7

