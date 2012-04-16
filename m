From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 21/32] debugfs: make expand_dir cmd support inline data
Date: Mon, 16 Apr 2012 19:39:56 +0800
Message-ID: <1334576407-4007-22-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:31 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so6233785pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:31 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/expanddir.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 41c4088..8caa97b 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -111,8 +111,12 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	es.goal = 0;
 	es.newblocks = 0;
 
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

