From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 23/35 v3] debugfs: make undelete cmd support inline data
Date: Sun,  1 Jul 2012 21:48:46 +0800
Message-ID: <1341150538-32047-24-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab2GANlb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:31 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:31 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Inode with inline data doesn't need to mark blocks.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 9069735..cf32068 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1445,8 +1445,9 @@ void do_undel(int argc, char *argv[])
 	if (debugfs_write_inode(ino, &inode, argv[0]))
 		return;
 
-	ext2fs_block_iterate3(current_fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
-			      mark_blocks_proc, NULL);
+	if (!ext2fs_has_inline_data(current_fs, ino))
+		ext2fs_block_iterate3(current_fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
+				      mark_blocks_proc, NULL);
 
 	ext2fs_inode_alloc_stats2(current_fs, ino, +1, 0);
 
-- 
1.7.4.1

