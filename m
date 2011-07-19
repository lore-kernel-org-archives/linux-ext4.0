From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 02/11] ext4: prevent a fs with errors from being resized
Date: Tue, 19 Jul 2011 12:02:08 +0800
Message-ID: <1311048137-16400-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1GSEG2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:28 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so3703318iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:28 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A filesystem with errors is not allowed to being resized, otherwise, it is
easy to destroy the filesystem.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

 v1->v2:
    nothing changed.
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 0213f63..53d9795 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -23,6 +23,16 @@ int ext4_resize_begin(struct super_block *sb)
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	/*
+	 * We are not allowed to do online-resizing on a filesystem mounted
+	 * with error, because it can destroy the filesystem easily.
+	 */
+	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
+		ext4_warning(sb, "There are errors in the filesystem, "
+			     "so online resizing is not allowed\n");
+		return -EPERM;
+	}
+
 	if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags))
 		ret = -EBUSY;
 
-- 
1.7.5.1

