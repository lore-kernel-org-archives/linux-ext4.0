From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 08/35 v3] debugfs: make ncheck cmd support inline data
Date: Sun,  1 Jul 2012 21:48:31 +0800
Message-ID: <1341150538-32047-9-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49296 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2GANlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:04 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so6469492pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:04 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When inode has inline data, ext2fs_inline_data_iterate function is called
to traverse dirs.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/ncheck.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 58f3a50..6dda919 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -171,8 +171,12 @@ void do_ncheck(int argc, char **argv)
 		iw.dir = ino;
 		iw.get_pathname_failed = 0;
 
-		retval = ext2fs_dir_iterate(current_fs, ino, 0, 0,
-					    ncheck_proc, &iw);
+		if (ext2fs_has_inline_data(current_fs, ino))
+			retval = ext2fs_inline_data_iterate(current_fs, ino, 0,
+							    0, ncheck_proc, &iw);
+		else
+			retval = ext2fs_dir_iterate(current_fs, ino, 0, 0,
+						    ncheck_proc, &iw);
 		ext2fs_free_mem(&iw.parent);
 		if (retval) {
 			com_err("ncheck", retval,
-- 
1.7.4.1

