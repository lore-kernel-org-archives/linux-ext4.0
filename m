From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix format flag in dx_probe()
Date: Mon, 21 Nov 2011 13:39:56 +0800
Message-ID: <1321853996-17750-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38904 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1KUFiQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 00:38:16 -0500
Received: by iage36 with SMTP id e36so6827602iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Nov 2011 21:38:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Fix ext4_warning format flag in dx_probe().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa4c782..346e4be 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -468,7 +468,7 @@ fail2:
 fail:
 	if (*err == ERR_BAD_DX_DIR)
 		ext4_warning(dir->i_sb,
-			     "Corrupt dir inode %ld, running e2fsck is "
+			     "Corrupt dir inode %lu, running e2fsck is "
 			     "recommended.", dir->i_ino);
 	return NULL;
 }
-- 
1.7.4.1

