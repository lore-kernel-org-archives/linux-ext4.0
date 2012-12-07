From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: fix some coding styles in extents.c
Date: Fri,  7 Dec 2012 16:36:17 +0800
Message-ID: <1354869377-10399-1-git-send-email-yangyongqiang01@baidu.com>
Cc: tytso@mit.edu, Yongqiang Yang <yangyongqiang01@baidu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61345 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2LGIg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2012 03:36:59 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so123605dak.19
        for <linux-ext4@vger.kernel.org>; Fri, 07 Dec 2012 00:36:59 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix some coding styles by folding 2 lines and aligning.

Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
---
 fs/ext4/extents.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d45ff3f..1b333e7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -906,14 +906,12 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	}
 	if (path[depth].p_ext != EXT_MAX_EXTENT(path[depth].p_hdr)) {
 		border = path[depth].p_ext[1].ee_block;
-		ext_debug("leaf will be split."
-				" next leaf starts at %d\n",
-				  le32_to_cpu(border));
+		ext_debug("leaf will be split. next leaf starts at %d\n",
+			  le32_to_cpu(border));
 	} else {
 		border = newext->ee_block;
-		ext_debug("leaf will be added."
-				" next leaf starts at %d\n",
-				le32_to_cpu(border));
+		ext_debug("leaf will be added. next leaf starts at %d\n",
+			  le32_to_cpu(border));
 	}
 
 	/*
@@ -1317,8 +1315,7 @@ static int ext4_ext_search_left(struct inode *inode,
 	}
 
 	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
-		EXT4_ERROR_INODE(inode,
-				 "logical %d < ee_block %d + ee_len %d!",
+		EXT4_ERROR_INODE(inode, "logical %d < ee_block %d + ee_len %d!",
 				 *logical, le32_to_cpu(ex->ee_block), ee_len);
 		return -EIO;
 	}
@@ -1384,8 +1381,7 @@ static int ext4_ext_search_right(struct inode *inode,
 	}
 
 	if (unlikely(*logical < (le32_to_cpu(ex->ee_block) + ee_len))) {
-		EXT4_ERROR_INODE(inode,
-				 "logical %d < ee_block %d + ee_len %d!",
+		EXT4_ERROR_INODE(inode, "logical %d < ee_block %d + ee_len %d!",
 				 *logical, le32_to_cpu(ex->ee_block), ee_len);
 		return -EIO;
 	}
@@ -1467,15 +1463,14 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
 	while (depth >= 0) {
 		if (depth == path->p_depth) {
 			/* leaf */
-			if (path[depth].p_ext &&
-				path[depth].p_ext !=
-					EXT_LAST_EXTENT(path[depth].p_hdr))
-			  return le32_to_cpu(path[depth].p_ext[1].ee_block);
+			struct ext4_extent *ext = path[depth].p_ext;
+			if (ext && ext != EXT_LAST_EXTENT(path[depth].p_hdr))
+				return le32_to_cpu(ext[1].ee_block);
 		} else {
 			/* index */
-			if (path[depth].p_idx !=
-					EXT_LAST_INDEX(path[depth].p_hdr))
-			  return le32_to_cpu(path[depth].p_idx[1].ei_block);
+			struct ext4_extent_idx *idx = path[depth].p_idx;
+			if (idx != EXT_LAST_INDEX(path[depth].p_hdr))
+				return le32_to_cpu(idx[1].ei_block);
 		}
 		depth--;
 	}
@@ -1502,8 +1497,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct ext4_ext_path *path)
 	depth--;
 
 	while (depth >= 0) {
-		if (path[depth].p_idx !=
-				EXT_LAST_INDEX(path[depth].p_hdr))
+		if (path[depth].p_idx != EXT_LAST_INDEX(path[depth].p_hdr))
 			return (ext4_lblk_t)
 				le32_to_cpu(path[depth].p_idx[1].ei_block);
 		depth--;
@@ -1597,7 +1591,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	ext2_ee_len = ext4_ext_get_actual_len(ex2);
 
 	if (le32_to_cpu(ex1->ee_block) + ext1_ee_len !=
-			le32_to_cpu(ex2->ee_block))
+	    le32_to_cpu(ex2->ee_block))
 		return 0;
 
 	/*
-- 
1.7.9.7

