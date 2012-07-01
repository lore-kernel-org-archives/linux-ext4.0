From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 19/35 v3] debugfs: make rm and kill_file cmd support inline data
Date: Sun,  1 Jul 2012 21:48:42 +0800
Message-ID: <1341150538-32047-20-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANlY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:24 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:24 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

rm and kill_file command don't need to release blocks.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 87fc6a9..9069735 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1851,8 +1851,9 @@ static void kill_file_by_inode(ext2_ino_t inode)
 	if (!ext2fs_inode_has_valid_blocks2(current_fs, &inode_buf))
 		return;
 
-	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, NULL,
-			      release_blocks_proc, NULL);
+	if (!ext2fs_has_inline_data(current_fs, inode))
+		ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY,
+				      NULL, release_blocks_proc, NULL);
 	printf("\n");
 	ext2fs_inode_alloc_stats2(current_fs, inode, -1,
 				  LINUX_S_ISDIR(inode_buf.i_mode));
-- 
1.7.4.1

