From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 11/32] debugfs: make ls cmd support inline data
Date: Mon, 16 Apr 2012 19:39:46 +0800
Message-ID: <1334576407-4007-12-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2DPLeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:14 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:13 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/ls.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index b4036de..14e7022 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -170,8 +170,12 @@ void do_list_dir(int argc, char *argv[])
 	if (ls.options & DELETED_OPT)
 		flags |= DIRENT_FLAG_INCLUDE_REMOVED;
 
-	retval = ext2fs_dir_iterate2(current_fs, inode, flags,
-				    0, list_dir_proc, &ls);
+	if (ext2fs_has_inline_data(current_fs, inode))
+		retval = ext2fs_inline_data_iterate2(current_fs, inode,flags,
+						     0, list_dir_proc, &ls);
+	else
+		retval = ext2fs_dir_iterate2(current_fs, inode, flags,
+					    0, list_dir_proc, &ls);
 	fprintf(ls.f, "\n");
 	close_pager(ls.f);
 	if (retval)
-- 
1.7.4.1

