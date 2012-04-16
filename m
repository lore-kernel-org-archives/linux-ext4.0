From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 15/32] debugfs: make link cmd support inline data
Date: Mon, 16 Apr 2012 19:39:50 +0800
Message-ID: <1334576407-4007-16-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2DPLeU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:20 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:20 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/link.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 2d03b57..e62567c 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -131,8 +131,13 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	ls.blocksize = fs->blocksize;
 	ls.err = 0;
 
-	retval = ext2fs_dir_iterate(fs, dir, DIRENT_FLAG_INCLUDE_EMPTY,
-				    0, link_proc, &ls);
+	if (ext2fs_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_iterate3(fs, dir,
+				DIRENT_FLAG_INCLUDE_EMPTY, 0, ls.name,
+				ls.namelen, link_proc, &ls);
+	else
+		retval = ext2fs_dir_iterate(fs, dir, DIRENT_FLAG_INCLUDE_EMPTY,
+					    0, link_proc, &ls);
 	if (retval)
 		return retval;
 	if (ls.err)
-- 
1.7.4.1

