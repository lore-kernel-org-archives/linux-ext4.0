From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 03/12] ext4: prevent a fs without journal from being resized
Date: Mon, 18 Jul 2011 10:52:26 +0800
Message-ID: <1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65169 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1GRC4v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:56:51 -0400
Received: by iyb12 with SMTP id 12so2725572iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:56:50 -0700 (PDT)
In-Reply-To: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch prevents a fs without journal from being resized, because
it is easy to detroy the fs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 53d9795..33ab40d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -33,6 +33,16 @@ int ext4_resize_begin(struct super_block *sb)
 		return -EPERM;
 	}
 
+	/*
+	 * We are not allowed to do online-resizing on a filesystem without
+	 * journal, otherwise, it is easy to destroy the filesystem.
+	 */
+	if (!EXT4_SB(sb)->s_journal) {
+		ext4_warning(sb, "There is no journal for the filesystem, "
+			     "so online resizing is not allowed\n");
+		return -EPERM;
+	}
+
 	if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags))
 		ret = -EBUSY;
 
-- 
1.7.5.1

