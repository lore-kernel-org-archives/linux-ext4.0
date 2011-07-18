From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 02/12] ext4: prevent a fs with errors from being resized
Date: Mon, 18 Jul 2011 10:52:25 +0800
Message-ID: <1310957555-15617-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1GRC4s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:56:48 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so2719031iwn.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:56:48 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A filesystem with errors is not allowed to being resized, otherwise, it is
easy to destroy the filesystem.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

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

