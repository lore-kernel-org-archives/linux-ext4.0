From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 18/36 v4] debugfs: make rmdir cmd support inline data
Date: Tue, 31 Jul 2012 19:48:11 +0800
Message-ID: <1343735309-30579-19-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53681 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2GaLkV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:21 -0400
Received: by yhmm54 with SMTP id m54so5916848yhm.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:20 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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

