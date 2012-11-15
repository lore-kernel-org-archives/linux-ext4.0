From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/7] libext2fs: wrong loop will cause dir entry is not found in dirsearch command
Date: Thu, 15 Nov 2012 16:13:25 +0800
Message-ID: <1352967209-29616-4-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992781Ab2KOIBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:13 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so979542pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:13 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

It needs to iterate dir entry until offset is greater than or equal to size of
inline data.  But currently it is only iterate until offset >= len (length of
name).

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/inline_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index f0473fd..7f5ec3e 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -129,7 +129,7 @@ static int do_search_dir(ext2_filsys fs, void *start, int size,
 	unsigned rec_len;
 	errcode_t errcode;
 
-	while (offset < len) {
+	while (offset < size) {
 		de = (struct ext2_dir_entry *)(start + offset);
 		errcode = ext2fs_get_rec_len(fs, de, &rec_len);
 		if (errcode) {
-- 
1.7.12.rc2.18.g61b472e

