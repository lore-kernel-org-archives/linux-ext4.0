From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 3/5 bigalloc] e2fsprogs: make ext2fs_mkdir to support cluster unit of directory
Date: Fri, 18 Nov 2011 18:55:28 +0800
Message-ID: <1321613730-10600-4-git-send-email-hao.bigrat@gmail.com>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33147 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1KRKzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:49 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3440789iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:48 -0800 (PST)
In-Reply-To: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 lib/ext2fs/block.c |    3 ++-
 lib/ext2fs/mkdir.c |   19 +++++++++++++++++++
 misc/mke2fs.c      |    8 ++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 212989d..468538a 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -469,7 +469,8 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			j = blockcnt - lblk;
 			blk += j;
 			for (blockcnt = lblk, j = 0;
-			     j < (extent.e_len << fs->cluster_ratio_bits);
+			     j < (extent.e_len << fs->cluster_ratio_bits) &&
+			     ((j * (fs->blocksize)) < (inode.i_size));
 			     blk++, blockcnt++, j++) {
 				new_blk = blk;
 				r = (*ctx.func)(fs, &new_blk, blockcnt,
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index b12bf2d..de42107 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -40,7 +40,9 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2_ino_t		ino = inum;
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
+	int			i = 0;
 	char			*block = 0;
+	char			*empty_block = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -69,6 +71,13 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 		goto cleanup;
 
 	/*
+	 * Create a empty dir block
+	 */
+	retval = ext2fs_new_dir_block(fs, 0, 0, &empty_block);
+	if (retval)
+		goto cleanup;
+
+	/*
 	 * Get the parent's inode, if necessary
 	 */
 	if (parent != ino) {
@@ -98,6 +107,14 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	retval = ext2fs_write_dir_block(fs, blk, block);
 	if (retval)
 		goto cleanup;
+	if (fs->cluster_ratio_bits > 0) {
+		for (i = 1; i < (1 << fs->cluster_ratio_bits); i++) {
+			retval = ext2fs_write_dir_block(fs, blk + i,
+					empty_block);
+			if (retval)
+				goto cleanup;
+		}
+	}
 	retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
@@ -149,6 +166,8 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 cleanup:
 	if (block)
 		ext2fs_free_mem(&block);
+	if (empty_block)
+		ext2fs_free_mem(&empty_block);
 	return retval;
 
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..b0d7025 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -392,6 +392,7 @@ static void create_lost_and_found(ext2_filsys fs)
 	unsigned int		lpf_size = 0;
 	errcode_t		retval;
 	ext2_ino_t		ino;
+	struct ext2_inode	inode;
 	const char		*name = "lost+found";
 	int			i;
 
@@ -410,6 +411,13 @@ static void create_lost_and_found(ext2_filsys fs)
 		exit(1);
 	}
 
+	if (fs->cluster_ratio_bits > 0) {
+		retval = ext2fs_read_inode(fs, ino, &inode);
+		inode.i_size = 16*1024;
+		ext2fs_write_inode(fs, ino, &inode);
+		return;
+	}
+
 	for (i=1; i < EXT2_NDIR_BLOCKS; i++) {
 		/* Ensure that lost+found is at least 2 blocks, so we always
 		 * test large empty blocks for big-block filesystems.  */
-- 
1.7.3.2

