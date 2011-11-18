From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/5 bigalloc] debugfs: support cluster unit of ee_block and ee_len
Date: Fri, 18 Nov 2011 18:55:27 +0800
Message-ID: <1321613730-10600-3-git-send-email-hao.bigrat@gmail.com>
References: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53369 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1KRKzq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:55:46 -0500
Received: by ywt32 with SMTP id 32so2287845ywt.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:55:46 -0800 (PST)
In-Reply-To: <1321613730-10600-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 debugfs/debugfs.c   |    8 +++++---
 lib/ext2fs/block.c  |   15 +++++++++------
 lib/ext2fs/bmap.c   |    8 ++++++--
 lib/ext2fs/extent.c |   13 ++++++++-----
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 1fb8f44..e9c0510 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -662,7 +662,8 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 				physical_width,
 				extent.e_pblk,
 				physical_width,
-				extent.e_pblk + (extent.e_len - 1),
+				extent.e_pblk + ((extent.e_len <<
+					current_fs->cluster_ratio_bits) - 1),
 				extent.e_len,
 				extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
 					"Uninit" : "");
@@ -671,7 +672,7 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 
 		if (extent.e_len == 0)
 			continue;
-		else if (extent.e_len == 1)
+		else if (extent.e_len == 1 && current_fs->cluster_ratio_bits == 1)
 			fprintf(f,
 				"%s(%lld%s):%lld",
 				printed ? ", " : "",
@@ -688,7 +689,8 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 				extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT ?
 					"[u]" : "",
 				extent.e_pblk,
-				extent.e_pblk + (extent.e_len - 1));
+				extent.e_pblk + ((extent.e_len <<
+					current_fs->cluster_ratio_bits) - 1));
 		printed = 1;
 	}
 	if (printed)
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 6a5c10d..212989d 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -337,6 +337,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 	struct block_context ctx;
 	int	limit;
 	blk64_t	blk64;
+	blk64_t lblk;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -459,14 +460,16 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 			       extent.e_lblk, extent.e_pblk,
 			       extent.e_len, blockcnt);
 #endif
-			if (extent.e_lblk + extent.e_len <= blockcnt)
+			if (((extent.e_lblk + extent.e_len) <<
+					fs->cluster_ratio_bits) <= blockcnt)
 				continue;
-			if (extent.e_lblk > blockcnt)
-				blockcnt = extent.e_lblk;
-			j = blockcnt - extent.e_lblk;
+			lblk = extent.e_lblk << fs->cluster_ratio_bits;
+			if (lblk > blockcnt)
+				blockcnt = lblk;
+			j = blockcnt - lblk;
 			blk += j;
-			for (blockcnt = extent.e_lblk, j = 0;
-			     j < extent.e_len;
+			for (blockcnt = lblk, j = 0;
+			     j < (extent.e_len << fs->cluster_ratio_bits);
 			     blk++, blockcnt++, j++) {
 				new_blk = blk;
 				r = (*ctx.func)(fs, &new_blk, blockcnt,
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 16d51e0..3e71fdf 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -175,6 +175,8 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
 	unsigned int		offset;
 	errcode_t		retval = 0;
 	blk64_t			blk64 = 0;
+	blk64_t			lblk = 0;
+	blk64_t			len = 0;
 	int			alloc = 0;
 
 	if (bmap_flags & BMAP_SET) {
@@ -192,8 +194,10 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
 	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
 	if (retval)
 		return retval;
-	offset = block - extent.e_lblk;
-	if (block >= extent.e_lblk && (offset <= extent.e_len)) {
+	lblk = extent.e_lblk << fs->cluster_ratio_bits;
+	len = extent.e_len << fs->cluster_ratio_bits;
+	offset = block - lblk;
+	if (block >= lblk && (offset <= len)) {
 		*phys_blk = extent.e_pblk + offset;
 		if (ret_flags && extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
 			*ret_flags |= BMAP_RET_UNINIT;
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index eb096d6..32eb171 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -636,10 +636,13 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 	while (1) {
 		if (handle->max_depth - handle->level == leaf_level) {
 			/* block is in this &extent */
-			if ((blk >= extent.e_lblk) &&
-			    (blk < extent.e_lblk + extent.e_len))
+			if ((blk >= (extent.e_lblk <<
+					handle->fs->cluster_ratio_bits)) &&
+			    (blk < ((extent.e_lblk + extent.e_len) <<
+				    handle->fs->cluster_ratio_bits)))
 				return 0;
-			if (blk < extent.e_lblk) {
+			if (blk < (extent.e_lblk <<
+					handle->fs->cluster_ratio_bits)) {
 				retval = ext2fs_extent_get(handle,
 							   EXT2_EXTENT_PREV_SIB,
 							   &extent);
@@ -665,9 +668,9 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 #ifdef DEBUG_GOTO_EXTENTS
 		dbg_print_extent("next", &extent);
 #endif
-		if (blk == extent.e_lblk)
+		if (blk == (extent.e_lblk << handle->fs->cluster_ratio_bits))
 			goto go_down;
-		if (blk > extent.e_lblk)
+		if (blk > (extent.e_lblk << handle->fs->cluster_ratio_bits))
 			continue;
 
 		retval = ext2fs_extent_get(handle, EXT2_EXTENT_PREV_SIB,
-- 
1.7.3.2

