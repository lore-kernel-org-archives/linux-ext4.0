From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/7] libext2fs: rec_len is set incorrect in ext2fs_process_dir_inline_data
Date: Thu, 15 Nov 2012 16:13:23 +0800
Message-ID: <1352967209-29616-2-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab2KOIBJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so979542pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:08 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

A new dir doesn't be created in the parent dir with inline data due to this
bug because rec_len is set incorrect.  It will cause a wrong offset, and no
free room can be found.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/dir_iterate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 3f94ad4..198c5aa 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -335,7 +335,8 @@ int ext2fs_process_dir_inline_data(ext2_filsys	fs,
 			entry++;
 
 		if (ret & DIRENT_CHANGED) {
-			dirent->rec_len = rec_len;
+			if (ext2fs_get_rec_len(fs, dirent, &rec_len))
+				return BLOCK_ABORT;
 			changed++;
 		}
 		if (ret & DIRENT_ABORT) {
-- 
1.7.12.rc2.18.g61b472e

