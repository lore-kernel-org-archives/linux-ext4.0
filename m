From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 10/35 v3] debugfs: make chroot and cd cmd support inline data
Date: Sun,  1 Jul 2012 21:48:33 +0800
Message-ID: <1341150538-32047-11-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2GANlI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:08 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:08 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Both chroot and cd command call ext2fs_lookup.  So we can let it supoort
inline data simultaneously.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/lookup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/lookup.c b/lib/ext2fs/lookup.c
index 0e66e71..9835082 100644
--- a/lib/ext2fs/lookup.c
+++ b/lib/ext2fs/lookup.c
@@ -60,7 +60,11 @@ errcode_t ext2fs_lookup(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	ls.inode = inode;
 	ls.found = 0;
 
-	retval = ext2fs_dir_iterate(fs, dir, 0, buf, lookup_proc, &ls);
+	if (ext2fs_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_iterate(fs, dir, 0, buf,
+						    lookup_proc, &ls);
+	else
+		retval = ext2fs_dir_iterate(fs, dir, 0, buf, lookup_proc, &ls);
 	if (retval)
 		return retval;
 
-- 
1.7.4.1

