From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 22/32] debugfs: make lsdel cmd support inline data
Date: Mon, 16 Apr 2012 19:39:57 +0800
Message-ID: <1334576407-4007-23-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:33 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:33 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/lsdel.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index bed0ce6..ff283cd 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -141,15 +141,18 @@ void do_lsdel(int argc, char **argv)
 		lsd.free_blocks = 0;
 		lsd.bad_blocks = 0;
 
-		retval = ext2fs_block_iterate3(current_fs, ino,
-					       BLOCK_FLAG_READ_ONLY, block_buf,
-					       lsdel_proc, &lsd);
-		if (retval) {
-			com_err("ls_deleted_inodes", retval,
-				"while calling ext2fs_block_iterate2");
-			goto next;
+		if (!ext2fs_has_inline_data(current_fs, ino)) {
+			retval = ext2fs_block_iterate3(current_fs, ino,
+						       BLOCK_FLAG_READ_ONLY, block_buf,
+						       lsdel_proc, &lsd);
+			if (retval) {
+				com_err("ls_deleted_inodes", retval,
+					"while calling ext2fs_block_iterate2");
+				goto next;
+			}
 		}
-		if (lsd.free_blocks && !lsd.bad_blocks) {
+		if (lsd.free_blocks && !lsd.bad_blocks ||
+		    ext2fs_has_inline_data(current_fs, ino)) {
 			if (num_delarray >= max_delarray) {
 				max_delarray += 50;
 				delarray = realloc(delarray,
-- 
1.7.4.1

