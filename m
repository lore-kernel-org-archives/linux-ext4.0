From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] ext4: teach ext4_ext_in_cache to return type of cached extent
Date: Mon, 14 Nov 2011 11:07:05 +0800
Message-ID: <1321240026-844-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1321240026-844-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KNF3g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 00:29:36 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6824050iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 21:29:35 -0800 (PST)
In-Reply-To: <1321240026-844-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch let ext4_ext_in_cache return the type of cached extent.
Now two kinds of cached extents are supported, they are delayed extent
and initialized extent respectively.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..a99d123 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2059,6 +2059,8 @@ errout:
 	return ret;
 }
 
+#define CACHE_EXTENT_HOLE		1
+#define CACHE_EXTENT_INITIALIZED	2
 /*
  * ext4_ext_in_cache()
  * Checks to see if the given block is in the cache.
@@ -2083,7 +2085,10 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 		ex->ee_block = cpu_to_le32(cex.ec_block);
 		ext4_ext_store_pblock(ex, cex.ec_start);
 		ex->ee_len = cpu_to_le16(cex.ec_len);
-		ret = 1;
+		if (cex.ec_start == 0)
+			ret = CACHE_EXTENT_HOLE;
+		else
+			ret = CACHE_EXTENT_INITIALIZED;
 	}
 
 	return ret;
@@ -3721,9 +3726,10 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
 
 	/* check in cache */
-	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
-		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
-		if (!newex.ee_start_lo && !newex.ee_start_hi) {
+	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)) {
+		ret = ext4_ext_in_cache(inode, map->m_lblk, &newex);
+		switch (ret) {
+		case CACHE_EXTENT_HOLE:
 			if ((sbi->s_cluster_ratio > 1) &&
 			    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
 				map->m_flags |= EXT4_MAP_FROM_CLUSTER;
@@ -3736,7 +3742,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				goto out2;
 			}
 			/* we should allocate requested block */
-		} else {
+			break;
+
+		case CACHE_EXTENT_INITIALIZED:
 			/* block is already allocated */
 			if (sbi->s_cluster_ratio > 1)
 				map->m_flags |= EXT4_MAP_FROM_CLUSTER;
-- 
1.7.5.1

