From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
Date: Sat, 23 Apr 2011 01:44:19 -0700
Message-ID: <1303548259-28311-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, cmm@us.ibm.com,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33766 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1DWIrQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Apr 2011 04:47:16 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so600853pzk.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Apr 2011 01:47:15 -0700 (PDT)
In-Reply-To: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1] Rename ext4_ext_zroout() to ext4_ext_zeroout_dev().

2] Optimize ext4_ext_convert_to_initialized() by using
   ext4_ext_zeroout_mem().

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30663b6..0fc4ca1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2538,7 +2538,7 @@ void ext4_ext_release(struct super_block *sb)
 }
 
 /* FIXME!! we need to try to merge to left or right after zero-out  */
-static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
+static int ext4_ext_zeroout_dev(struct inode *inode, struct ext4_extent *ex)
 {
 	ext4_fsblk_t ee_pblock;
 	unsigned int ee_len;
@@ -2597,7 +2597,7 @@ static int ext4_ext_zeroout_mem(struct inode *inode,
 			ext.ee_block = cpu_to_le32(lblk);
 			ext.ee_len = cpu_to_le16(end - lblk);
 			ext4_ext_store_pblock(&ext, pblk);
-			return ext4_ext_zeroout(inode, &ext);
+			return ext4_ext_zeroout_dev(inode, &ext);
 		}
 
 		/* map buffers, mark dirty */
@@ -2725,7 +2725,7 @@ static int ext4_split_extent_at(handle_t *handle,
 
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err == -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
-		err = ext4_ext_zeroout(inode, &orig_ex);
+		err = ext4_ext_zeroout_dev(inode, &orig_ex);
 		if (err)
 			goto fix_extent_len;
 		/* update the extent length and mark as initialized */
@@ -2860,9 +2860,25 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
 	if (ee_len <= 2*EXT4_EXT_ZERO_LEN &&
 	    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
-		err = ext4_ext_zeroout(inode, ex);
-		if (err)
-			goto out;
+		if (map->m_lblk > ee_block) {
+			zero_ex.ee_block = ex->ee_block;
+			zero_ex.ee_len = cpu_to_le16(map->m_lblk - ee_block);
+			ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
+			err = ext4_ext_zeroout_mem(inode, &zero_ex);
+			if (err)
+				goto out;
+		}
+
+		if (map->m_lblk + map->m_len < ee_block + ee_len) {
+			zero_ex.ee_block = cpu_to_le32(map->m_lblk +
+						       map->m_len);
+			zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
+			ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex) +
+					(map->m_lblk - ee_block) + map->m_len);
+			err = ext4_ext_zeroout_mem(inode, &zero_ex);
+			if (err)
+				goto out;
+		}
 
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
@@ -2892,7 +2908,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
 			ext4_ext_store_pblock(&zero_ex,
 				ext4_ext_pblock(ex) + map->m_lblk - ee_block);
-			err = ext4_ext_zeroout(inode, &zero_ex);
+			err = ext4_ext_zeroout_mem(inode, &zero_ex);
 			if (err)
 				goto out;
 			split_map.m_lblk = map->m_lblk;
@@ -2907,7 +2923,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 							ee_block);
 				ext4_ext_store_pblock(&zero_ex,
 						      ext4_ext_pblock(ex));
-				err = ext4_ext_zeroout(inode, &zero_ex);
+				err = ext4_ext_zeroout_mem(inode, &zero_ex);
 				if (err)
 					goto out;
 			}
-- 
1.7.4.4

