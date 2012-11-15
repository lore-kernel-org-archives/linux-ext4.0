From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 5/7] libext2fs: fix a typo
Date: Thu, 15 Nov 2012 16:13:27 +0800
Message-ID: <1352967209-29616-6-git-send-email-wenqing.lz@taobao.com>
References: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992781Ab2KOIBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 03:01:17 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so979542pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 00:01:17 -0800 (PST)
In-Reply-To: <1352967209-29616-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Fix a typo in ext2fs_set_entry_ext_attr().

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 5a8d1ca..9c9ab1c 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -280,7 +280,7 @@ errcode_t ext2fs_set_entry_ext_attr(struct ext2_ext_attr_info *i,
 	}
 	free = min_offs - ((void *)last - s->base) - sizeof(__u32);
 	if (!s->not_found) {
-		if (!s->here->e_value_block & s->here->e_value_size) {
+		if (!s->here->e_value_block && s->here->e_value_size) {
 			size_t size = ext2fs_le32_to_cpu(s->here->e_value_size);
 			free += EXT2_EXT_ATTR_SIZE(size);
 		}
-- 
1.7.12.rc2.18.g61b472e

