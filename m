From: Tao Ma <tm@tao.ma>
Subject: [PATCH] mke2fs: Avoid segmentation fault in ext2fs_alloc_generic_bmap.
Date: Mon,  9 May 2011 23:33:27 +0800
Message-ID: <1304955207-4066-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:47635 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751353Ab1EIPdo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 11:33:44 -0400
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1QJSSs-0001aA-CY
	for linux-ext4@vger.kernel.org; Mon, 09 May 2011 09:33:43 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In case of error, ext2fs_alloc_generic_bmap free the memory
in the wrong order. So change it to free description first
and then the bitmap.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 lib/ext2fs/gen_bitmap64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index df095ac..8b9e4c5 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -129,8 +129,8 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 
 	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
 	if (retval) {
-		ext2fs_free_mem(&bitmap);
 		ext2fs_free_mem(&bitmap->description);
+		ext2fs_free_mem(&bitmap);
 		return retval;
 	}
 
-- 
1.6.3.GIT

