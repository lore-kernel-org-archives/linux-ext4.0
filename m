From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/7] libext2fs: create a new dir with inline data while ino is greater than or equal to the first ino
Date: Thu, 15 Nov 2012 16:13:24 +0800
Message-ID: <1352967209-29616-3-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65348 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab2KOIBL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:11 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so905780pad.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:10 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now when the inode number is greater than or equal to the first inode number, we
will create a new dir with inline data if inline_data feature is enabled and dir
name is not lost+found.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/mkdir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 3bbe808..d48a075 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -56,7 +56,8 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	}
 
 	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA &&
-	    ino > EXT2_FIRST_INO(fs->super) && strcmp("lost+found", name) != 0) {
+	    ino >= EXT2_FIRST_INO(fs->super) &&
+	    strcmp("lost+found", name) != 0) {
 		retval = ext2fs_inline_data_mkdir(fs, parent, ino, name);
 		if (retval)
 			goto cleanup;
-- 
1.7.12.rc2.18.g61b472e

