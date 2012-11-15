From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/7] libext2fs: return written bytes in ext2fs_try_to_write_inline_data
Date: Thu, 15 Nov 2012 16:13:26 +0800
Message-ID: <1352967209-29616-5-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:39372 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992781Ab2KOIBP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:15 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so561869dak.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:15 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

unwritten variable is assigned to the bytes of written data if writting to
inline data is done.  Otherwise, it will be assigned to 0.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/inline_data.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 7f5ec3e..fd89360 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -890,6 +890,11 @@ errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
 	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
 					 EXT2_INODE_SIZE(fs->super));
 
+	if (!retval)
+		*written = nbytes;
+	else
+		*written = 0;
+
 out:
 	ext2fs_free_mem(&inode);
 	return retval;
-- 
1.7.12.rc2.18.g61b472e

