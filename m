From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 25/32] debugfs: make rdump cmd support inline data
Date: Mon, 16 Apr 2012 19:40:00 +0800
Message-ID: <1334576407-4007-26-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:38 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:38 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
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

