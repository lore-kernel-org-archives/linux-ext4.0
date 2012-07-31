From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 09/36 v4] debugfs: make icheck cmd support inline data
Date: Tue, 31 Jul 2012 19:48:02 +0800
Message-ID: <1343735309-30579-10-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLkD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:03 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540445pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:03 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When inode has inline_data, we don't need to check i_blocks.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/icheck.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index 48f432a..3caa930 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -132,9 +132,12 @@ void do_icheck(int argc, char **argv)
 		if (inode.i_dtime)
 			goto next;
 
-		retval = ext2fs_block_iterate3(current_fs, ino,
-					       BLOCK_FLAG_READ_ONLY, block_buf,
-					       icheck_proc, &bw);
+		/* we don't need to check i_blocks with inline_data */
+		if (!ext2fs_has_inline_data(current_fs, ino))
+			retval = ext2fs_block_iterate3(current_fs, ino,
+						       BLOCK_FLAG_READ_ONLY,
+						       block_buf,
+						       icheck_proc, &bw);
 		if (retval) {
 			com_err("icheck", retval,
 				"while calling ext2fs_block_iterate");
-- 
1.7.4.1

