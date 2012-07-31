From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 16/36 v4] debugfs: make unlink cmd support inline data
Date: Tue, 31 Jul 2012 19:48:09 +0800
Message-ID: <1343735309-30579-17-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2GaLkQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:16 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so5911698yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:16 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
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

