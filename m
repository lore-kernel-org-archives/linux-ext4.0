From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 14/36 v4] debugfs: make filefrag cmd support inline data
Date: Tue, 31 Jul 2012 19:48:07 +0800
Message-ID: <1343735309-30579-15-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53943 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2GaLkN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:13 -0400
Received: by pbbrp8 with SMTP id rp8so11540999pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:12 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Inode with inline data haven't any fragmentations.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/filefrag.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index 7f28bc0..c94396c 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -153,16 +153,18 @@ static void filefrag(ext2_ino_t ino, struct ext2_inode *inode,
 		fprintf(fs->f, "\n%s has %llu block(s), i_size is %llu\n",
 			fs->name, num_blocks, EXT2_I_SIZE(inode));
 	}
-	print_header(fs);
-	retval = ext2fs_block_iterate3(current_fs, ino,
-				       BLOCK_FLAG_READ_ONLY, NULL,
-				       filefrag_blocks_proc, fs);
-	if (retval)
-		com_err("ext2fs_block_iterate3", retval, 0);
-
-	report_filefrag(fs);
-	fprintf(fs->f, "%s: %d contiguous extents%s\n", fs->name, fs->ext,
-		LINUX_S_ISDIR(inode->i_mode) ? " (dir)" : "");
+	if (!ext2fs_has_inline_data(current_fs, ino)) {
+		print_header(fs);
+		retval = ext2fs_block_iterate3(current_fs, ino,
+					       BLOCK_FLAG_READ_ONLY, NULL,
+					       filefrag_blocks_proc, fs);
+		if (retval)
+			com_err("ext2fs_block_iterate3", retval, 0);
+
+		report_filefrag(fs);
+		fprintf(fs->f, "%s: %d contiguous extents%s\n", fs->name, fs->ext,
+			LINUX_S_ISDIR(inode->i_mode) ? " (dir)" : "");
+	}
 }
 
 static int filefrag_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
@@ -240,8 +242,12 @@ static void dir_iterate(ext2_ino_t ino, struct filefrag_struct *fs)
 	fs->dir_name = fs->name;
 
 	while (1) {
-		retval = ext2fs_dir_iterate2(current_fs, ino, 0,
-					     0, filefrag_dir_proc, fs);
+		if (ext2fs_has_inline_data(current_fs, ino))
+			retval = ext2fs_inline_data_iterate2(current_fs, ino,
+						0, 0, filefrag_dir_proc, fs);
+		else
+			retval = ext2fs_dir_iterate2(current_fs, ino, 0,
+						     0, filefrag_dir_proc, fs);
 		if (retval)
 			com_err("ext2fs_dir_iterate2", retval, 0);
 		if (p) {
-- 
1.7.4.1

