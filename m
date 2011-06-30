From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2] ext4: avoid finding next leaf if newext->ee_block smaller than fex->ee_block
Date: Thu, 30 Jun 2011 16:03:34 +0800
Message-ID: <1309421014-6148-2-git-send-email-sanbai@taobao.com>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab1F3IDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 04:03:48 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so1695995iwn.19
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 01:03:48 -0700 (PDT)
In-Reply-To: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If newext->ee_block is smaller than (or equal to) fex->ee_block, the call of
ext4_ext_next_leaf_block will be useless. We need to call it only after
newext->ee_block is greater than fex->ee_block.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dc5ef91..0ee475a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1765,24 +1765,27 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 
 	/* probably next leaf has space for us? */
 	fex = EXT_LAST_EXTENT(eh);
-	next = ext4_ext_next_leaf_block(inode, path);
-	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
-	    && next != EXT_MAX_BLOCKS) {
-		ext_debug("next leaf block - %d\n", next);
-		BUG_ON(npath != NULL);
-		npath = ext4_ext_find_extent(inode, next, NULL);
-		if (IS_ERR(npath))
-			return PTR_ERR(npath);
-		BUG_ON(npath->p_depth != path->p_depth);
-		eh = npath[depth].p_hdr;
-		if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max)) {
-			ext_debug("next leaf isn't full(%d)\n",
-				  le16_to_cpu(eh->eh_entries));
-			path = npath;
-			goto has_space;
+	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)) {
+		next = ext4_ext_next_leaf_block(inode, path);
+		if (next != EXT_MAX_BLOCKS) {
+			ext_debug("next leaf block - %d\n", next);
+			BUG_ON(npath != NULL);
+			npath = ext4_ext_find_extent(inode, next, NULL);
+			if (IS_ERR(npath))
+				return PTR_ERR(npath);
+			BUG_ON(npath->p_depth != path->p_depth);
+			eh = npath[depth].p_hdr;
+			if (le16_to_cpu(eh->eh_entries) <
+					le16_to_cpu(eh->eh_max)) {
+				ext_debug("next leaf isn't full(%d)\n",
+					  le16_to_cpu(eh->eh_entries));
+				path = npath;
+				goto has_space;
+			}
+			ext_debug("next leaf has no free space(%d,%d)\n",
+				le16_to_cpu(eh->eh_entries),
+				le16_to_cpu(eh->eh_max));
 		}
-		ext_debug("next leaf has no free space(%d,%d)\n",
-			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 	}
 
 	/*
-- 
1.7.1

