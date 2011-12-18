From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/5] e2fsck: make it to support inline data in pass1
Date: Sun, 18 Dec 2011 22:44:43 +0800
Message-ID: <1324219484-22443-5-git-send-email-wenqing.lz@taobao.com>
References: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1LROo0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:44:26 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so7092185iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 06:44:26 -0800 (PST)
In-Reply-To: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Let e2fsck to support inline data in pass1.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c           |   46 ++++++++++++++++++++++++++++++++++++++++++----
 e2fsck/problem.c         |   10 ++++++++++
 e2fsck/problem.h         |    6 ++++++
 lib/ext2fs/ext2fs.h      |    2 ++
 lib/ext2fs/inline_data.c |   13 +++++++++++++
 5 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 532e132..05ea7ca 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -278,6 +278,10 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 	int problem = 0;
 
 	inode = (struct ext2_inode_large *) pctx->inode;
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		/* this inode has inline data, so nothing to check. */
+		return;
+	}
 	storage_size = EXT2_INODE_SIZE(ctx->fs->super) - EXT2_GOOD_OLD_INODE_SIZE -
 		inode->i_extra_isize;
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
@@ -557,7 +561,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb = ctx->fs->super;
 	const char	*old_op;
-	int		imagic_fs, extent_fs;
+	int		imagic_fs, extent_fs, inlinedata_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
 
@@ -590,6 +594,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
 	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (sb->s_feature_incompat &
+			 EXT4_FEATURE_INCOMPAT_INLINEDATA);
 
 	/*
 	 * Allocate bitmaps structures
@@ -750,6 +756,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 
 		/*
+		 * Test for incorrect inline data flag settings.
+		 */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && !inlinedata_fs &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			if (ext2fs_inline_data_header_verify(fs, inode) == 0 &&
+			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
+				sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_INLINEDATA;
+				ext2fs_mark_super_dirty(fs);
+				inlinedata_fs = 1;
+			} else if (fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx))
+				goto clear_inode;
+		}
+
+		/*
 		 * Test for incorrect extent flag settings.
 		 *
 		 * On big-endian machines we must be careful:
@@ -1115,7 +1135,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_sockets_count++;
 		} else
 			mark_inode_bad(ctx, ino);
-		if (!(inode->i_flags & EXT4_EXTENTS_FL)) {
+		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 			if (inode->i_block[EXT2_IND_BLOCK])
 				ctx->fs_ind_count++;
 			if (inode->i_block[EXT2_DIND_BLOCK])
@@ -1124,6 +1145,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				ctx->fs_tind_count++;
 		}
 		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    !(inode->i_flags & EXT4_INLINE_DATA_FL) &&
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
@@ -1929,6 +1951,14 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	ext2fs_extent_free(ehandle);
 }
 
+static void check_blocks_inline_data(e2fsck_t ctx, struct problem_context *pctx,
+				     struct process_block_struct *pb)
+{
+	if (pb->is_dir)
+		pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
+						      pb->ino, 0, 0);
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -1943,6 +1973,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	int		bad_size = 0;
 	int		dirty_inode = 0;
 	int		extent_fs;
+	int		inlinedata_fs;
 	__u64		size;
 
 	pb.ino = ino;
@@ -1965,6 +1996,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 
 	extent_fs = (ctx->fs->super->s_feature_incompat &
                      EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
+			 EXT4_FEATURE_INCOMPAT_INLINEDATA);
 
 	if (inode->i_flags & EXT2_COMPRBLK_FL) {
 		if (fs->super->s_feature_incompat &
@@ -1988,6 +2021,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
+		else if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
+			check_blocks_inline_data(ctx, pctx, &pb);
 		else
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
@@ -2024,7 +2059,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (!pb.num_blocks && pb.is_dir) {
+	if (!pb.num_blocks && pb.is_dir &&
+	    !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
 		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
 			e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks");
 			ctx->fs_directory_count--;
@@ -2050,7 +2086,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
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
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index f042b89..88b6295 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -941,6 +941,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* inode has inline data, superblock missing INCOMPAT_INLINEDATA feature */
+	{ PR_1_INLINE_DATA_FEATURE,
+	  N_("@i %i is in inline data format, but @S is missing INLINEDATA feature\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* INLINE_DATA_FL flag set on a non-inline-data filesystem */
+	{ PR_1_INLINE_DATA_SET,
+	  N_("@i %i has INLINE_DATA_FL flag set on @f without inline data support.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9db29d8..bb92f60 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -550,6 +550,12 @@ struct problem_context {
 /* Invalid bad inode */
 #define PR_1_INVALID_BAD_INODE		0x010065
 
+/* INLINE_DATA_FL flag set on a non-inline-data capable filesystem */
+#define PR_1_INLINE_DATA_FEATURE	0x010066
+
+/* inode has inline data, superblock missing INCOMPAT_INLINEDATA feature */
+#define PR_1_INLINE_DATA_SET		0x010067
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c17922e..dc40359 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1224,6 +1224,8 @@ extern errcode_t ext2fs_initialize(const char *name, int flags,
 				   io_manager manager, ext2_filsys *ret_fs);
 
 /* inline_data.c */
+extern errcode_t ext2fs_inline_data_header_verify(ext2_filsys fs,
+						  struct ext2_inode *inode);
 extern errcode_t ext2fs_find_inline_entry(ext2_filsys fs,
 					  struct ext2_inode *inode,
 					  void *priv_data);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index dcf33f9..3a29ee7 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -222,3 +222,16 @@ out:
 	free(inode);
 	return ret;
 }
+
+errcode_t ext2fs_inline_data_header_verify(ext2_filsys fs,
+					   struct ext2_inode *inode)
+{
+	struct inline_data idata;
+	int ret = 0;
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_off == 0)
+		ret = -1;
+
+	return ret;
+}
-- 
1.7.4.1

