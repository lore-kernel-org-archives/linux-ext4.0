From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 19/36 v4] debugfs: make rm and kill_file cmd support inline data
Date: Tue, 31 Jul 2012 19:48:12 +0800
Message-ID: <1343735309-30579-20-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2GaLkW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:22 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:22 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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

