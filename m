From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH RESEND] ext4: format flag in dx_probe()
Date: Mon, 16 Jan 2012 17:01:40 +0800
Message-ID: <1326704500-4368-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58960 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2API6A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 03:58:00 -0500
Received: by iagf6 with SMTP id f6so2257228iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 00:58:00 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix ext4_warning format flag in dx_probe().

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2043f48..349d7b3 100644
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

