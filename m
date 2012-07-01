From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 16/35 v3] debugfs: make unlink cmd support inline data
Date: Sun,  1 Jul 2012 21:48:39 +0800
Message-ID: <1341150538-32047-17-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:19 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:19 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/unlink.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/unlink.c b/lib/ext2fs/unlink.c
index d2d31cc..6852d4a 100644
--- a/lib/ext2fs/unlink.c
+++ b/lib/ext2fs/unlink.c
@@ -90,8 +90,13 @@ errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir,
 	ls.done = 0;
 	ls.prev = 0;
 
-	retval = ext2fs_dir_iterate(fs, dir, DIRENT_FLAG_INCLUDE_EMPTY,
-				    0, unlink_proc, &ls);
+	if (ext2fs_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_iterate(fs, dir,
+					DIRENT_FLAG_INCLUDE_EMPTY, 0,
+					unlink_proc, &ls);
+	else
+		retval = ext2fs_dir_iterate(fs, dir, DIRENT_FLAG_INCLUDE_EMPTY,
+					    0, unlink_proc, &ls);
 	if (retval)
 		return retval;
 
-- 
1.7.4.1

