From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 24/30] e2fsck: check inline_data in pass1
Date: Fri,  6 Dec 2013 17:58:11 +0800
Message-ID: <1386323897-2354-25-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62321 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3LFJ4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:21 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so782781pbb.17
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:21 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c          |   62 +++++++++++++++++++++++++++++++++++++++++++----
 lib/ext2fs/dblist_dir.c |   16 ++++++++++--
 2 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 56411f1..d5dca9d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -177,7 +177,8 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2fs_extent	extent;
 
 	if ((inode->i_size_high || inode->i_size == 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL))
+	    (inode->i_flags & EXT2_INDEX_FL) ||
+	    (inode->i_flags & EXT4_INLINE_DATA_FL))
 		return 0;
 
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
@@ -407,6 +408,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	blk64_t			blk;
 	unsigned int		i, rec_len, not_device = 0;
 	int			extent_fs;
+	int			inlinedata_fs;
 
 	/*
 	 * If the mode looks OK, we believe it.  If the first block in
@@ -434,11 +436,23 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	 * For extent mapped files, we don't do any sanity checking:
 	 * just try to get the phys block of logical block 0 and run
 	 * with it.
+	 *
+	 * For inline data files, we just try to get the size of inline
+	 * data.  If it's true, we will treat it as a directory.
 	 */
 
 	extent_fs = (ctx->fs->super->s_feature_incompat &
 		     EXT3_FEATURE_INCOMPAT_EXTENTS);
-	if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
+	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
+			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
+	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL)) {
+		unsigned int size;
+
+		if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
+			return;
+		/* device files never have a "system.data" entry */
+		goto isdir;
+	} else if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
 		/* extent mapped */
 		if  (ext2fs_bmap2(ctx->fs, pctx->ino, inode, 0, 0, 0, 0,
 				 &blk))
@@ -501,6 +515,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	    (rec_len % 4))
 		return;
 
+isdir:
 	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
 		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
 		e2fsck_write_inode_full(ctx, pctx->ino, inode,
@@ -1194,7 +1209,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_sockets_count++;
 		} else
 			mark_inode_bad(ctx, ino);
-		if (!(inode->i_flags & EXT4_EXTENTS_FL)) {
+		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 			if (inode->i_block[EXT2_IND_BLOCK])
 				ctx->fs_ind_count++;
 			if (inode->i_block[EXT2_DIND_BLOCK])
@@ -1203,6 +1219,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				ctx->fs_tind_count++;
 		}
 		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL) &&
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
@@ -2132,6 +2149,26 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 }
 
 /*
+ * In fact we don't need to check blocks for an inode with inline data
+ * because this inode doesn't have any blocks.  In this function all
+ * we need to do is add this inode into dblist when it is a directory.
+ */
+static void check_blocks_inline_data(e2fsck_t ctx, struct problem_context *pctx,
+				     struct process_block_struct *pb)
+{
+	if (!pb->is_dir)
+		return;
+
+	pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist, pb->ino, 0, 0);
+	if (pctx->errcode) {
+		pctx->blk = 0;
+		pctx->num = 0;
+		fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+	}
+}
+
+/*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
  */
@@ -2145,6 +2182,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	int		bad_size = 0;
 	int		dirty_inode = 0;
 	int		extent_fs;
+	int		inlinedata_fs;
 	__u64		size;
 
 	pb.ino = ino;
@@ -2168,6 +2206,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 
 	extent_fs = (ctx->fs->super->s_feature_incompat &
                      EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
+			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	if (inode->i_flags & EXT2_COMPRBLK_FL) {
 		if (fs->super->s_feature_incompat &
@@ -2201,6 +2241,10 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			 */
 			pb.last_init_lblock = pb.last_block;
 		}
+	} else {
+		/* check inline data */
+		if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
+			check_blocks_inline_data(ctx, pctx, &pb);
 	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
 	end_problem_latch(ctx, PR_LATCH_TOOBIG);
@@ -2233,7 +2277,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (!pb.num_blocks && pb.is_dir) {
+	if (!pb.num_blocks && pb.is_dir &&
+	    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
 			e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks");
 			ctx->fs_directory_count--;
@@ -2259,7 +2304,14 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 #endif
 	if (pb.is_dir) {
 		int nblock = inode->i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
-		if (inode->i_size & (fs->blocksize - 1))
+		if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+			size_t size;
+
+			if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
+				bad_size = 5;
+			if (size != inode->i_size)
+				bad_size = 5;
+		} else if (inode->i_size & (fs->blocksize - 1))
 			bad_size = 5;
 		else if (nblock > (pb.last_block + 1))
 			bad_size = 1;
diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index d4d5111..1e36584 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -65,6 +65,7 @@ errcode_t ext2fs_dblist_dir_iterate(ext2_dblist dblist,
 static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 		       void *priv_data)
 {
+	struct ext2_inode	inode;
 	struct dir_context	*ctx;
 	int			ret;
 
@@ -72,8 +73,19 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 	ctx->dir = db_info->ino;
 	ctx->errcode = 0;
 
-	ret = ext2fs_process_dir_block(fs, &db_info->blk,
-				       db_info->blockcnt, 0, 0, priv_data);
+	ctx->errcode = ext2fs_read_inode(fs, ctx->dir, &inode);
+	if (ctx->errcode)
+		return DBLIST_ABORT;
+	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
+		ctx->flags = DIRENT_FLAG_INCLUDE_INLINE_DATA;
+		ext2fs_inline_data_dir_iterate(fs, ctx->dir,
+					       ext2fs_process_dir_block,
+					       ctx);
+	} else {
+		ret = ext2fs_process_dir_block(fs, &db_info->blk,
+					       db_info->blockcnt, 0, 0,
+					       priv_data);
+	}
 	if ((ret & BLOCK_ABORT) && !ctx->errcode)
 		return DBLIST_ABORT;
 	return 0;
-- 
1.7.9.7

