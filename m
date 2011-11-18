From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 5/5 bigalloc] e2fsprogs: make ext2fs_extent_set_bmap() to support cluster unit of ee_block and ee_len
Date: Fri, 18 Nov 2011 18:55:30 +0800
Message-ID: <1321613730-10600-6-git-send-email-hao.bigrat@gmail.com>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53369 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1KRKzy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:54 -0500
Received: by mail-yw0-f46.google.com with SMTP id 32so2287845ywt.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:54 -0800 (PST)
In-Reply-To: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 lib/ext2fs/extent.c |   76 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 32eb171..c646604 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -516,7 +516,7 @@ retry:
 			ix++;
 			end_blk = ext2fs_le32_to_cpu(ix->ei_block);
 		} else
-			end_blk = path->end_blk;
+			end_blk = EXT2FS_B2C(handle->fs, path->end_blk);
 
 		extent->e_len = end_blk - extent->e_lblk;
 	}
@@ -854,7 +854,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 
 	/* save the position we were originally splitting... */
 	orig_height = info.max_depth - info.curr_level;
-	orig_lblk = extent.e_lblk;
+	orig_lblk = EXT2FS_C2B(handle->fs, extent.e_lblk);
 
 	/* Is there room in the parent for a new entry? */
 	if (handle->level &&
@@ -1000,7 +1000,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 
 		extent.e_lblk = new_node_start;
 		extent.e_pblk = new_node_pblk;
-		extent.e_len = handle->path[0].end_blk - extent.e_lblk;
+		extent.e_len = EXT2FS_B2C(handle->fs, handle->path[0].end_blk -
+				EXT2FS_C2B(handle->fs, extent.e_lblk));
 		retval = ext2fs_extent_replace(handle, 0, &extent);
 		if (retval)
 			goto done;
@@ -1157,6 +1158,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	struct ext2fs_extent	extent, next_extent, prev_extent;
 	struct ext2fs_extent	newextent;
 	struct ext2_extent_info	info;
+	ext2_filsys		fs = handle->fs;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
@@ -1182,7 +1184,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	if (physical) {
 		newextent.e_len = 1;
 		newextent.e_pblk = physical;
-		newextent.e_lblk = logical;
+		newextent.e_lblk = EXT2FS_B2C(handle->fs, logical);
 		newextent.e_flags = EXT2_EXTENT_FLAGS_LEAF;
 		if (new_uninit)
 			newextent.e_flags |= EXT2_EXTENT_FLAGS_UNINIT;
@@ -1204,7 +1206,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 	if ((retval = ext2fs_extent_get_info(handle, &info)))
 		return retval;
 	orig_height = info.max_depth - info.curr_level;
-	orig_lblk = extent.e_lblk;
+	orig_lblk = EXT2FS_C2B(handle->fs, extent.e_lblk);
 
 	/* go to the logical spot we want to (re/un)map */
 	retval = ext2fs_extent_goto(handle, logical);
@@ -1267,7 +1269,8 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 
 	/* check if already pointing to the requested physical */
 	if (mapped && (new_uninit == extent_uninit) &&
-	    (extent.e_pblk + (logical - extent.e_lblk) == physical)) {
+	    (extent.e_pblk + (logical - EXT2FS_C2B(handle->fs, extent.e_lblk))
+	     == physical)) {
 #ifdef DEBUG
 		printf("physical block (at %llu) unchanged\n", logical);
 #endif
@@ -1278,25 +1281,30 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 #ifdef DEBUG
 		printf("mapping unmapped logical block %llu\n", logical);
 #endif
-		if ((logical == extent.e_lblk + extent.e_len) &&
-		    (physical == extent.e_pblk + extent.e_len) &&
+		if ((logical == EXT2FS_C2B(fs, extent.e_lblk + extent.e_len)) &&
+		    (physical == extent.e_pblk +
+		     EXT2FS_C2B(fs, extent.e_len)) &&
 		    (new_uninit == extent_uninit) &&
-		    ((int) extent.e_len < max_len-1)) {
+		    ((int) EXT2FS_C2B(fs, extent.e_len) < max_len - 1)) {
 			extent.e_len++;
 			retval = ext2fs_extent_replace(handle, 0, &extent);
-		} else if ((logical == extent.e_lblk - 1) &&
-			   (physical == extent.e_pblk - 1) &&
+		} else if ((logical == EXT2FS_C2B(fs, extent.e_lblk - 1)) &&
+			   (physical == extent.e_pblk -
+			    EXT2FS_CLUSTER_RATIO(fs)) &&
 			   (new_uninit == extent_uninit) &&
-			   ((int) extent.e_len < max_len - 1)) {
+			   ((int) EXT2FS_C2B(fs, extent.e_len) < max_len - 1)) {
 			extent.e_len++;
 			extent.e_lblk--;
-			extent.e_pblk--;
+			extent.e_pblk -= EXT2FS_CLUSTER_RATIO(fs);
 			retval = ext2fs_extent_replace(handle, 0, &extent);
 		} else if (has_next &&
-			   (logical == next_extent.e_lblk - 1) &&
-			   (physical == next_extent.e_pblk - 1) &&
+			   (logical == EXT2FS_C2B(fs,
+					next_extent.e_lblk - 1)) &&
+			   (physical == next_extent.e_pblk -
+			    EXT2FS_CLUSTER_RATIO(fs)) &&
 			   (new_uninit == next_uninit) &&
-			   ((int) next_extent.e_len < max_len - 1)) {
+			   ((int) EXT2FS_C2B(fs, next_extent.e_len) <
+			    max_len - 1)) {
 			retval = ext2fs_extent_get(handle,
 						   EXT2_EXTENT_NEXT_LEAF,
 						   &next_extent);
@@ -1304,9 +1312,9 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 				goto done;
 			next_extent.e_len++;
 			next_extent.e_lblk--;
-			next_extent.e_pblk--;
+			next_extent.e_pblk -= EXT2FS_CLUSTER_RATIO(fs);
 			retval = ext2fs_extent_replace(handle, 0, &next_extent);
-		} else if (logical < extent.e_lblk)
+		} else if (logical < EXT2FS_C2B(fs, extent.e_lblk))
 			retval = ext2fs_extent_insert(handle, 0, &newextent);
 		else
 			retval = ext2fs_extent_insert(handle,
@@ -1316,7 +1324,8 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		retval = ext2fs_extent_fix_parents(handle);
 		if (retval)
 			goto done;
-	} else if ((logical == extent.e_lblk) && (extent.e_len == 1))  {
+	} else if ((logical == EXT2FS_C2B(fs, extent.e_lblk)) &&
+			(extent.e_len == 1))  {
 #ifdef DEBUG
 		printf("(re/un)mapping only block in extent\n");
 #endif
@@ -1333,23 +1342,27 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 
 		if (retval)
 			goto done;
-	} else if (logical == extent.e_lblk + extent.e_len - 1)  {
+	} else if (logical == EXT2FS_C2B(fs, extent.e_lblk +
+				extent.e_len - 1))  {
 #ifdef DEBUG
 		printf("(re/un)mapping last block in extent\n");
 #endif
 		if (physical) {
 			if (has_next &&
-			    (logical == (next_extent.e_lblk - 1)) &&
-			    (physical == (next_extent.e_pblk - 1)) &&
+			    (logical == (EXT2FS_C2B(fs,
+					next_extent.e_lblk - 1))) &&
+			    (physical == (next_extent.e_pblk -
+					  EXT2FS_CLUSTER_RATIO(fs))) &&
 			    (new_uninit == next_uninit) &&
-			    ((int) next_extent.e_len < max_len - 1)) {
+			    ((int) EXT2FS_C2B(fs, next_extent.e_len) <
+			     max_len - 1)) {
 				retval = ext2fs_extent_get(handle,
 					EXT2_EXTENT_NEXT_LEAF, &next_extent);
 				if (retval)
 					goto done;
 				next_extent.e_len++;
 				next_extent.e_lblk--;
-				next_extent.e_pblk--;
+				next_extent.e_pblk -= EXT2FS_CLUSTER_RATIO(fs);
 				retval = ext2fs_extent_replace(handle, 0,
 							       &next_extent);
 				if (retval)
@@ -1370,18 +1383,19 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		retval = ext2fs_extent_replace(handle, 0, &extent);
 		if (retval)
 			goto done;
-	} else if (logical == extent.e_lblk) {
+	} else if (logical == EXT2FS_C2B(fs, extent.e_lblk)) {
 #ifdef DEBUG
 		printf("(re/un)mapping first block in extent\n");
 #endif
 		if (physical) {
 			if (has_prev &&
-			    (logical == (prev_extent.e_lblk +
+			    (logical == EXT2FS_C2B(fs, prev_extent.e_lblk +
 					 prev_extent.e_len)) &&
 			    (physical == (prev_extent.e_pblk +
-					  prev_extent.e_len)) &&
+					  EXT2FS_C2B(fs, prev_extent.e_len))) &&
 			    (new_uninit == prev_uninit) &&
-			    ((int) prev_extent.e_len < max_len-1)) {
+			    ((int) EXT2FS_C2B(fs, prev_extent.e_len) <
+			     max_len - 1)) {
 				retval = ext2fs_extent_get(handle, 
 					EXT2_EXTENT_PREV_LEAF, &prev_extent);
 				if (retval)
@@ -1400,7 +1414,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 			if (retval)
 				goto done;
 		}
-		extent.e_pblk++;
+		extent.e_pblk += EXT2FS_CLUSTER_RATIO(fs);
 		extent.e_lblk++;
 		extent.e_len--;
 		retval = ext2fs_extent_replace(handle, 0, &extent);
@@ -1417,7 +1431,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		orig_length = extent.e_len;
 
 		/* shorten pre-split extent */
-		extent.e_len = (logical - extent.e_lblk);
+		extent.e_len = (EXT2FS_B2C(fs, logical) - extent.e_lblk);
 		retval = ext2fs_extent_replace(handle, 0, &extent);
 		if (retval)
 			goto done;
@@ -1430,7 +1444,7 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 				goto done;
 		}
 		/* add post-split extent */
-		extent.e_pblk += extent.e_len + 1;
+		extent.e_pblk += EXT2FS_C2B(fs, extent.e_len + 1);
 		extent.e_lblk += extent.e_len + 1;
 		extent.e_len = orig_length - extent.e_len - 1;
 		retval = ext2fs_extent_insert(handle,
-- 
1.7.3.2

