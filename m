From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 19/21 v5] e2fsck: check inline_data in pass3
Date: Sat, 22 Sep 2012 12:01:07 +0800
Message-ID: <1348286469-31690-20-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2IVDve (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:34 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873873pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:34 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass3.c  |    8 ++++++++
 e2fsck/rehash.c |    3 ++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index a379e9b..85b3f65 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -787,6 +787,14 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	es.ctx = ctx;
 	es.dir = dir;
 
+	if (ext2fs_inode_has_inline_data(fs, dir)) {
+		retval = ext2fs_convert_inline_data(fs, dir, &es);
+		if (retval)
+			return retval;
+
+		return 0;
+	}
+
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
 
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 347f1b0..a54c6b4 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -940,7 +940,8 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 #if 0
 		fix_problem(ctx, PR_3A_OPTIMIZE_DIR, &pctx);
 #endif
-		pctx.errcode = e2fsck_rehash_dir(ctx, ino);
+		if (!ext2fs_inode_has_inline_data(ctx->fs, ino))
+			pctx.errcode = e2fsck_rehash_dir(ctx, ino);
 		if (pctx.errcode) {
 			end_problem_latch(ctx, PR_LATCH_OPTIMIZE_DIR);
 			fix_problem(ctx, PR_3A_OPTIMIZE_DIR_ERR, &pctx);
-- 
1.7.4.1

