From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 18/35 v3] debugfs: make rmdir cmd support inline data
Date: Sun,  1 Jul 2012 21:48:41 +0800
Message-ID: <1341150538-32047-19-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANlW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:22 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:22 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index db3d3b9..87fc6a9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1958,8 +1958,12 @@ void do_rmdir(int argc, char *argv[])
 	rds.parent = 0;
 	rds.empty = 1;
 
-	retval = ext2fs_dir_iterate2(current_fs, inode_num, 0,
-				    0, rmdir_proc, &rds);
+	if (ext2fs_has_inline_data(current_fs, inode_num))
+		retval = ext2fs_inline_data_iterate2(current_fs, inode_num, 0,
+						     0, rmdir_proc, &rds);
+	else
+		retval = ext2fs_dir_iterate2(current_fs, inode_num, 0,
+					    0, rmdir_proc, &rds);
 	if (retval) {
 		com_err(argv[0], retval, "while iterating over directory");
 		return;
-- 
1.7.4.1

