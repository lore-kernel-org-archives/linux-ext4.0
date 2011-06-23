From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH v2] ext4: avoid eh_entries overflow before insert extent_idx
Date: Thu, 23 Jun 2011 16:47:17 +0800
Message-ID: <1308818837-5243-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34941 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1FWIr2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 04:47:28 -0400
Received: by iwn6 with SMTP id 6so1389081iwn.19
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 01:47:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If eh_entries is equal to (or greater than) eh_max, the operation of
inserting new extent_idx will make number of entries overflow.
So check eh_entries before inserting the new extent_idx.

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

