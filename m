From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH v3] ext4: avoid eh_entries overflow before insert extent_idx
Date: Mon, 27 Jun 2011 14:29:40 +0800
Message-ID: <1309156180-3899-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1F0G3t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 02:29:49 -0400
Received: by iyb12 with SMTP id 12so3829679iyb.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Jun 2011 23:29:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If eh_entries is equal to (or greater than) eh_max, the operation of
inserting new extent_idx will make number of entries overflow.
So check eh_entries before inserting the new extent_idx.

Although there is no bug case according the code (function ext4_ext_insert_index 
is called by ext4_ext_split and ext4_ext_split is called only if the index
block has free space), the right logic should be "lookup the capacity before
insertion".

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..792e77e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -776,6 +776,16 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 				 logical, le32_to_cpu(curp->p_idx->ei_block));
 		return -EIO;
 	}
+
+	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
+			     >= le16_to_cpu(curp->p_hdr->eh_max))) {
+		EXT4_ERROR_INODE(inode,
+				 "eh_entries %d >= eh_max %d!",
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

