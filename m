From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 11/35 v3] debugfs: make ls cmd support inline data
Date: Sun,  1 Jul 2012 21:48:34 +0800
Message-ID: <1341150538-32047-12-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2GANlK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:10 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/ls.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index b4036de..00b497d 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -170,8 +170,12 @@ void do_list_dir(int argc, char *argv[])
 	if (ls.options & DELETED_OPT)
 		flags |= DIRENT_FLAG_INCLUDE_REMOVED;
 
-	retval = ext2fs_dir_iterate2(current_fs, inode, flags,
-				    0, list_dir_proc, &ls);
+	if (ext2fs_has_inline_data(current_fs, inode))
+		retval = ext2fs_inline_data_iterate2(current_fs, inode, flags,
+						     0, list_dir_proc, &ls);
+	else
+		retval = ext2fs_dir_iterate2(current_fs, inode, flags,
+					    0, list_dir_proc, &ls);
 	fprintf(ls.f, "\n");
 	close_pager(ls.f);
 	if (retval)
-- 
1.7.4.1

