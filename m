From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: check eh_max before really insert index
Date: Wed, 22 Jun 2011 14:51:16 +0800
Message-ID: <1308725476-5393-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36951 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1FVGv0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 02:51:26 -0400
Received: by iwn6 with SMTP id 6so451265iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 23:51:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check eh_entries/eh_max before really insert index.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..a742e6e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -776,6 +776,16 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 				 logical, le32_to_cpu(curp->p_idx->ei_block));
 		return -EIO;
 	}
+
+	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries) + 1
+			     > le16_to_cpu(curp->p_hdr->eh_max))) {
+		EXT4_ERROR_INODE(inode,
+				 "eh_entries %d + 1 > eh_max %d!",
+				 le16_to_cpu(curp->p_hdr->eh_entries),
+				 le16_to_cpu(curp->p_hdr->eh_max));
+		return -EIO;
+	}
+
 	len = EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
 	if (logical > le32_to_cpu(curp->p_idx->ei_block)) {
 		/* insert after */
@@ -805,14 +815,6 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 	ext4_idx_store_pblock(ix, ptr);
 	le16_add_cpu(&curp->p_hdr->eh_entries, 1);
 
-	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
-			     > le16_to_cpu(curp->p_hdr->eh_max))) {
-		EXT4_ERROR_INODE(inode,
-				 "eh_entries %d > eh_max %d!",
-				 le16_to_cpu(curp->p_hdr->eh_entries),
-				 le16_to_cpu(curp->p_hdr->eh_max));
-		return -EIO;
-	}
 	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
 		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
 		return -EIO;
-- 
1.7.1

