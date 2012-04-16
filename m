From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 09/32] debugfs: make ncheck cmd support inline data
Date: Mon, 16 Apr 2012 19:39:44 +0800
Message-ID: <1334576407-4007-10-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2DPLeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:10 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

when inode has inline data, ext2fs_inline_data_iterate function is called
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

