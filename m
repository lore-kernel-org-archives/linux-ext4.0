From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 31/35 v3] e2fsck: make pass1 support inline data
Date: Sun,  1 Jul 2012 21:48:54 +0800
Message-ID: <1341150538-32047-32-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2GANlr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:47 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:47 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c          |   76 ++++++++++++++++++++++++++++++++++++++++++-----
 e2fsck/pass1b.c         |    5 ++-
 lib/ext2fs/dblist_dir.c |    8 ++++-
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index fee0dc6..f1bf828 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -221,12 +221,37 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		if (len == fs->blocksize)
 			return 0;
 	} else {
-		if (inode->i_size >= sizeof(inode->i_block))
-			return 0;
+		if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+			struct ext2_inode_large *large_inode;
+			struct inline_data idata;
+			void *inline_start;
+			int inline_data_size;
+			errcode_t retval;
+
+			inline_data_size = ext2fs_inline_data_size(fs, ino);
+			if (inode->i_size != inline_data_size)
+				return 0;
 
-		len = strnlen((char *)inode->i_block, sizeof(inode->i_block));
-		if (len == sizeof(inode->i_block))
-			return 0;
+			large_inode = (struct ext2_inode_large *)inode;
+
+			ext2fs_iget_extra_inode(fs, large_inode, &idata);
+			if (idata.inline_off == EXT4_MIN_INLINE_DATA_SIZE)
+				return 0;
+			inline_start = ext2fs_get_inline_xattr_pos(large_inode,
+								   &idata);
+			len = strnlen((char *)inline_start,
+				      idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+			if (len != idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE)
+				return 0;
+			len += EXT4_MIN_INLINE_DATA_SIZE;
+		} else {
+			if (inode->i_size >= sizeof(inode->i_block))
+				return 0;
+
+			len = strnlen((char *)inode->i_block, sizeof(inode->i_block));
+			if (len == sizeof(inode->i_block))
+				return 0;
+		}
 	}
 	if (len != inode->i_size)
 		return 0;
@@ -304,6 +329,14 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 			goto fix;
 		}
 
+		/*
+		 * not do the following checks for inline_data because
+		 * other checks ensure that the content of inline data
+		 * is correct.
+		 */
+		if (strncmp(EXT2_EXT_ATTR_NAME(entry), "data", 4) == 0)
+			goto next;
+
 		/* attribute len eats this space */
 		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
 
@@ -331,6 +364,7 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 			goto fix;
 		}
 
+next:
 		remain -= entry->e_value_size;
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
@@ -1203,7 +1237,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_sockets_count++;
 		} else
 			mark_inode_bad(ctx, ino);
-		if (!(inode->i_flags & EXT4_EXTENTS_FL)) {
+		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 			if (inode->i_block[EXT2_IND_BLOCK])
 				ctx->fs_ind_count++;
 			if (inode->i_block[EXT2_DIND_BLOCK])
@@ -1212,6 +1247,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				ctx->fs_tind_count++;
 		}
 		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL) &&
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
@@ -2089,6 +2125,22 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	ext2fs_extent_free(ehandle);
 }
 
+static void check_blocks_inline_data(e2fsck_t ctx, struct problem_context *pctx,
+				     struct process_block_struct *pb)
+{
+	if (pb->is_dir) {
+		pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
+						      pb->ino, 0, 0);
+		if (pctx->errcode) {
+			pctx->blk = 0;
+			pctx->num = 0;
+			fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
+			/* Should never get here */
+			ctx->flags |= E2F_FLAG_ABORT;
+		}
+	}
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -2103,6 +2155,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	int		bad_size = 0;
 	int		dirty_inode = 0;
 	int		extent_fs;
+	int		inlinedata_fs;
 	__u64		size;
 
 	pb.ino = ino;
@@ -2126,6 +2179,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 
 	extent_fs = (ctx->fs->super->s_feature_incompat &
                      EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
+		     EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	if (inode->i_flags & EXT2_COMPRBLK_FL) {
 		if (fs->super->s_feature_incompat &
@@ -2149,6 +2204,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
+		else if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
+			check_blocks_inline_data(ctx, pctx, &pb);
 		else {
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
@@ -2191,7 +2248,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (!pb.num_blocks && pb.is_dir) {
+	if (!pb.num_blocks && pb.is_dir &&
+	    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
 			e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks");
 			ctx->fs_directory_count--;
@@ -2217,7 +2275,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 #endif
 	if (pb.is_dir) {
 		int nblock = inode->i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (inode->i_size & (fs->blocksize - 1))
+		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			;
+		else if (inode->i_size & (fs->blocksize - 1))
 			bad_size = 5;
 		else if (nblock > (pb.last_block + 1))
 			bad_size = 1;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 05cbd10..6918fcc 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -315,8 +315,9 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		pb.inode = &inode;
 		pb.cur_cluster = ~0;
 
-		if (ext2fs_inode_has_valid_blocks2(fs, &inode) ||
-		    (ino == EXT2_BAD_INO))
+		if ((ext2fs_inode_has_valid_blocks2(fs, &inode) ||
+		     (ino == EXT2_BAD_INO)) &&
+		    !(inode.i_flags & EXT4_INLINE_DATA_FL))
 			pctx.errcode = ext2fs_block_iterate3(fs, ino,
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index d4d5111..cc54d7a 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -72,8 +72,12 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 	ctx->dir = db_info->ino;
 	ctx->errcode = 0;
 
-	ret = ext2fs_process_dir_block(fs, &db_info->blk,
-				       db_info->blockcnt, 0, 0, priv_data);
+	if (ext2fs_has_inline_data(fs, ctx->dir))
+		ret = ext2fs_inline_data_iterate2(fs, ctx->dir, 0, NULL,
+						  ctx->func, ctx->priv_data);
+	else
+		ret = ext2fs_process_dir_block(fs, &db_info->blk,
+					       db_info->blockcnt, 0, 0, priv_data);
 	if ((ret & BLOCK_ABORT) && !ctx->errcode)
 		return DBLIST_ABORT;
 	return 0;
-- 
1.7.4.1

