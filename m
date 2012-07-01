From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 20/35 v3] debugfs: make pwd cmd support inline data
Date: Sun,  1 Jul 2012 21:48:43 +0800
Message-ID: <1341150538-32047-21-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANl0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:26 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:26 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/get_pathname.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/get_pathname.c b/lib/ext2fs/get_pathname.c
index 52aea62..f92f17d 100644
--- a/lib/ext2fs/get_pathname.c
+++ b/lib/ext2fs/get_pathname.c
@@ -98,7 +98,12 @@ static errcode_t ext2fs_get_pathname_int(ext2_filsys fs, ext2_ino_t dir,
 	gp.name = 0;
 	gp.errcode = 0;
 
-	retval = ext2fs_dir_iterate(fs, dir, 0, buf, get_pathname_proc, &gp);
+	if (ext2fs_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_iterate(fs, dir, 0, buf,
+						    get_pathname_proc, &gp);
+	else
+		retval = ext2fs_dir_iterate(fs, dir, 0, buf,
+					    get_pathname_proc, &gp);
 	if (retval == EXT2_ET_NO_DIRECTORY) {
 		char tmp[32];
 
-- 
1.7.4.1

