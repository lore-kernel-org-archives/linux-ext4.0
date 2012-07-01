From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 21/35 v3] debugfs: make expand_dir cmd support inline data
Date: Sun,  1 Jul 2012 21:48:44 +0800
Message-ID: <1341150538-32047-22-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2GANl2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:28 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:28 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

expand_dir command allocates two new block for the dir.  It firstly allocates
a new block, and copies all of inline data into this block.  Then it allocates
another block for this dir.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/expanddir.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 22558d6..8ba8a23 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -114,8 +114,12 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	es.newblocks = 0;
 	es.dir = dir;
 
-	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
-				       0, expand_dir_proc, &es);
+	if (ext2fs_has_inline_data(fs, dir))
+		retval = ext2fs_inline_data_expand_dir(fs, dir, BLOCK_CHANGED,
+						       0, expand_dir_proc, &es);
+	else
+		retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
+					       0, expand_dir_proc, &es);
 
 	if (es.err)
 		return es.err;
-- 
1.7.4.1

