From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 4/8] e2fsprogs: add exclude bitmap support in e2fsck
Date: Sun, 23 Oct 2011 15:21:24 +0800
Message-ID: <1319354488-6050-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1JWJLB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:11:01 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:11:01 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is a compat feature needed by exy4 snapshot.  This
patch add exclude bitmap support in e2fsck.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 e2fsck/e2fsck.h         |    1 +
 e2fsck/pass1.c          |   35 +++++++++++++++++++++++++++++++++++
 e2fsck/pass1b.c         |    5 +++++
 e2fsck/pass5.c          |    3 +++
 e2fsck/problem.h        |    6 ++++++
 e2fsck/super.c          |   18 ++++++++++++++++++
 e2fsck/util.c           |    9 ++++++---
 lib/ext2fs/check_desc.c |   14 ++++++++++++++
 8 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 44909c3..bd85683 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -260,6 +260,7 @@ struct e2fsck_struct {
 	 */
 	int *invalid_inode_bitmap_flag;
 	int *invalid_block_bitmap_flag;
+	int *invalid_exclude_bitmap_flag;
 	int *invalid_inode_table_flag;
 	int invalid_bitmaps;	/* There are invalid bitmaps/itable */
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3587dff..90eeff1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2462,6 +2462,15 @@ static int process_bad_block(ext2_filsys fs,
 			}
 			return 0;
 		}
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    blk == ext2fs_exclude_bitmap_loc(fs, i)) {
+			if (fix_problem(ctx, PR_1_BB_BAD_BLOCK, pctx)) {
+				ctx->invalid_exclude_bitmap_flag[i]++;
+				ctx->invalid_bitmaps++;
+			}
+			return 0;
+		}
 		if (blk == ext2fs_inode_bitmap_loc(fs, i)) {
 			if (fix_problem(ctx, PR_1_IB_BAD_BLOCK, pctx)) {
 				ctx->invalid_inode_bitmap_flag[i]++;
@@ -2613,6 +2622,13 @@ static void handle_fs_bad_blocks(e2fsck_t ctx)
 					1, &new_blk);
 			ext2fs_block_bitmap_loc_set(fs, i, new_blk);
 		}
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    ctx->invalid_exclude_bitmap_flag[i]) {
+			new_table_block(ctx, first_block, i,
+					_("exclude bitmap"), 1, &new_blk);
+			ext2fs_exclude_bitmap_loc_set(fs, i, new_blk);
+		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
 			new_blk = ext2fs_inode_bitmap_loc(fs, i);
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
@@ -2691,6 +2707,25 @@ static void mark_table_blocks(e2fsck_t ctx)
 
 		}
 		/*
+		 * Mark block used for the exclude bitmap
+		 */
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    ext2fs_exclude_bitmap_loc(fs, i)) {
+			if (ext2fs_test_block_bitmap2(ctx->block_found_map,
+				     ext2fs_exclude_bitmap_loc(fs, i))) {
+				pctx.blk = ext2fs_exclude_bitmap_loc(fs, i);
+				if (fix_problem(ctx, PR_1_EB_CONFLICT, &pctx)) {
+					ctx->invalid_exclude_bitmap_flag[i]++;
+					ctx->invalid_bitmaps++;
+				}
+			} else {
+			    ext2fs_mark_block_bitmap2(ctx->block_found_map,
+				     ext2fs_exclude_bitmap_loc(fs, i));
+		    }
+
+		}
+		/*
 		 * Mark block used for the inode bitmap
 		 */
 		if (ext2fs_inode_bitmap_loc(fs, i)) {
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 5ff92c2..4994596 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -910,6 +910,11 @@ static int check_if_fs_block(e2fsck_t ctx, blk64_t test_block)
 		    (test_block == ext2fs_inode_bitmap_loc(fs, i)))
 			return 1;
 
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    test_block == ext2fs_exclude_bitmap_loc(fs, i))
+			return 1;
+
 		first_block += fs->super->s_blocks_per_group;
 	}
 	return 0;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 0dda1b3..416e325 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -257,6 +257,9 @@ redo_counts:
 			     LE_CLSTR(i, old_desc_blk + old_desc_blocks-1)) ||
 			    (new_desc_blk && EQ_CLSTR(i, new_desc_blk)) ||
 			    EQ_CLSTR(i, ext2fs_block_bitmap_loc(fs, group)) ||
+			    (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+			    (EQ_CLSTR(i, ext2fs_exclude_bitmap_loc(fs, group)))) ||
 			    EQ_CLSTR(i, ext2fs_inode_bitmap_loc(fs, group)) ||
 			    (GE_CLSTR(i, ext2fs_inode_table_loc(fs, group)) &&
 			     LE_CLSTR(i, (ext2fs_inode_table_loc(fs, group) +
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3647f6e..f2b2663 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -243,6 +243,8 @@ struct problem_context {
 /* Superblock has invalid MMP magic. */
 #define PR_0_MMP_INVALID_MAGIC			0x000043
 
+/* Exclude bitmap not in group */
+#define PR_0_EB_NOT_GROUP			0x000104
 
 /*
  * Pass 1 errors
@@ -548,6 +550,10 @@ struct problem_context {
 /* Quota inode is user visible */
 #define PR_1_QUOTA_INODE_NOT_HIDDEN	0x010064
 
+/* Block bitmap conflicts with some other fs block */
+#define PR_1_EB_CONFLICT		0x010101
+
+
 /*
  * Pass 1b errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 36e7309..63fd218 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -604,6 +604,20 @@ void check_super_block(e2fsck_t ctx)
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    ((ext2fs_exclude_bitmap_loc(fs, i) < first_block) ||
+		    (ext2fs_exclude_bitmap_loc(fs, i) > last_block))) {
+			pctx.blk = ext2fs_exclude_bitmap_loc(fs, i);
+			if (fix_problem(ctx, PR_0_EB_NOT_GROUP, &pctx))
+				ext2fs_exclude_bitmap_loc_set(fs, i, 0);
+		}
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    ext2fs_exclude_bitmap_loc(fs, i) == 0) {
+			ctx->invalid_exclude_bitmap_flag[i]++;
+			ctx->invalid_bitmaps++;
+		}
 		if ((ext2fs_inode_bitmap_loc(fs, i) < first_block) ||
 		    (ext2fs_inode_bitmap_loc(fs, i) > last_block)) {
 			pctx.blk = ext2fs_inode_bitmap_loc(fs, i);
@@ -637,6 +651,8 @@ void check_super_block(e2fsck_t ctx)
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i,
+						      EXT2_BG_EXCLUDE_UNINIT);
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
@@ -646,10 +662,12 @@ void check_super_block(e2fsck_t ctx)
 
 		if (!csum_flag &&
 		    (ext2fs_bg_flags_test(fs, i, EXT2_BG_BLOCK_UNINIT) ||
+		     ext2fs_bg_flags_test(fs, i, EXT2_BG_EXCLUDE_UNINIT) ||
 		     ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT) ||
 		     ext2fs_bg_itable_unused(fs, i) != 0)) {
 			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs, i, EXT2_BG_EXCLUDE_UNINIT);
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 06daf12..45fa14c 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -226,7 +226,8 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	old_op = ehandler_operation(_("reading inode and block bitmaps"));
+	old_op = ehandler_operation(_("reading inode, exclude and block "
+				      "bitmaps"));
 	retval = ext2fs_read_bitmaps(fs);
 	ehandler_operation(old_op);
 	if (retval) {
@@ -243,12 +244,14 @@ void e2fsck_write_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	const char	*old_op;
 
-	old_op = ehandler_operation(_("writing block and inode bitmaps"));
+	old_op = ehandler_operation(_("writing block, exclude "
+				      "and inode bitmaps"));
 	retval = ext2fs_write_bitmaps(fs);
 	ehandler_operation(old_op);
 	if (retval) {
 		com_err(ctx->program_name, retval,
-			_("while rewriting block and inode bitmaps for %s"),
+			_("while rewriting block, exclude "
+			  "and inode bitmaps for %s"),
 			ctx->device_name);
 		fatal_error(ctx, 0);
 	}
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index a6fcc45..881959c 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -68,6 +68,20 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		ext2fs_mark_block_bitmap2(bmap, blk);
 
 		/*
+		 * Check to make sure the exclude bitmap for group is sane
+		 */
+		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+					EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP)) {
+			blk = ext2fs_exclude_bitmap_loc(fs, i);
+			if (blk < first_block || blk > last_block ||
+			    ext2fs_test_block_bitmap2(bmap, blk)) {
+				retval = EXT2_ET_GDESC_BAD_BLOCK_MAP;
+				goto errout;
+			}
+			ext2fs_mark_block_bitmap2(bmap, blk);
+		}
+
+		/*
 		 * Check to make sure the inode bitmap for group is sane
 		 */
 		blk = ext2fs_inode_bitmap_loc(fs, i);
-- 
1.7.5.1

