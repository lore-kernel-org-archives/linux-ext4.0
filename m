From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: fix incorrect error msg in ext4_ext_insert_index
Date: Wed, 15 Jun 2011 10:25:26 +0800
Message-ID: <1308104726-5112-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40174 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1FOCZq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 22:25:46 -0400
Received: by pvg12 with SMTP id 12so2934456pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 19:25:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In function ext4_ext_insert_index when eh_entries of curp is
bigger than eh_max, error messages will be printed out, but the content
is about logical and ei_block, that's incorret.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..25be6e0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -808,8 +808,9 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
 			     > le16_to_cpu(curp->p_hdr->eh_max))) {
 		EXT4_ERROR_INODE(inode,
-				 "logical %d == ei_block %d!",
-				 logical, le32_to_cpu(curp->p_idx->ei_block));
+				 "eh_entries %d > eh_max %d!",
+				 le16_to_cpu(curp->p_hdr->eh_entries),
+				 le16_to_cpu(curp->p_hdr->eh_max));
 		return -EIO;
 	}
 	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
-- 
1.7.1

