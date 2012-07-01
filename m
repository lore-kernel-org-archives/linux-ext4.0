From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 25/35 v3] debugfs: make rdump cmd support inline data
Date: Sun,  1 Jul 2012 21:48:48 +0800
Message-ID: <1341150538-32047-26-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2GANlg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:35 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/dump.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index 10ebe7a..84de606 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -308,8 +308,12 @@ static void rdump_inode(ext2_ino_t ino, struct ext2_inode *inode,
 			goto errout;
 		}
 
-		retval = ext2fs_dir_iterate(current_fs, ino, 0, 0,
-					    rdump_dirent, (void *) fullname);
+		if (ext2fs_has_inline_data(current_fs, ino))
+			retval = ext2fs_inline_data_iterate(current_fs, ino, 0, 0,
+							    rdump_dirent, (void *) fullname);
+		else
+			retval = ext2fs_dir_iterate(current_fs, ino, 0, 0,
+						    rdump_dirent, (void *) fullname);
 		if (retval)
 			com_err("rdump", retval, "while dumping %s", fullname);
 
-- 
1.7.4.1

