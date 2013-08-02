From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 16/22] e2fsck: add problem descriptions and check inline data feature
Date: Fri,  2 Aug 2013 17:49:43 +0800
Message-ID: <1375436989-18948-17-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44973 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab3HBJvR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:51:17 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so500094pbb.13
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:51:17 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c           |   33 ++++++++++++++++++++++++++++++++-
 e2fsck/problem.c         |   15 +++++++++++++++
 e2fsck/problem.h         |    9 +++++++++
 lib/ext2fs/ext2fs.h      |    1 +
 lib/ext2fs/inline_data.c |   28 ++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1b410be..e6ea460 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -592,7 +592,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	const char	*old_op;
 	unsigned int	save_type;
-	int		imagic_fs, extent_fs;
+	int		imagic_fs, extent_fs, inlinedata_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
 	int		failed_csum = 0;
@@ -626,6 +626,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
 	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (sb->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	/*
 	 * Allocate bitmaps structures
@@ -757,6 +759,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ext2fs_mark_block_bitmap2(ctx->block_found_map,
 					  fs->super->s_mmp_block);
 
+	/*
+	 * If INLINE_DATA feature is set and EXT_ATTR feature missing,
+	 * EXT_ATTR needs to be set because INLINE_DATA depends on it and
+	 * this feature is enabled on default.
+	 */
+	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) &&
+	    inlinedata_fs) {
+		if (fix_problem(ctx, PR_1_INLINE_DATA_AND_EXT_ATTR, &pctx)) {
+			fs->super->s_feature_compat |=
+				EXT2_FEATURE_COMPAT_EXT_ATTR;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 	/* Set up ctx->lost_and_found if possible */
 	(void) e2fsck_get_lost_and_found(ctx, 0);
 
@@ -808,6 +824,21 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/* Test for incorrect inline_data flags settings. */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && !inlinedata_fs &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			if (ext2fs_inline_data_check(fs, ino) &&
+			    !fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
+				sb->s_feature_incompat |=
+					EXT4_FEATURE_INCOMPAT_INLINE_DATA;
+				ext2fs_mark_super_dirty(fs);
+				inlinedata_fs = 1;
+			} else if (!fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
+				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+				continue;
+			}
+		}
+
 		/*
 		 * Test for incorrect extent flag settings.
 		 *
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 76bc1d5..d79115a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1008,6 +1008,21 @@ static struct e2fsck_problem problem_table[] = {
 	     "Logical start %b does not match logical start %c at next level.  "),
 	  PROMPT_FIX, 0 },
 
+	/* INLINE_DATA feature is set, but EXT_ATTR missing */
+	{ PR_1_INLINE_DATA_AND_EXT_ATTR,
+	  N_("INLINE_DATA feature is set in @S, but EXT_ATTR feature missing\n"),
+	  PROMPT_FIX, 0 },
+
+	/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
+	{ PR_1_INLINE_DATA_FEATURE,
+	  N_("@i %i has inline data, but @S is missing INLINE_DATA feature\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* INLINE_DATA feature is set in a non-inline-data filesystem */
+	{ PR_1_INLINE_DATA_SET,
+	  N_("@i %i has INLINE_DATA_FL flag on @f without inline data support.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index d2b6df4..83257ae 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -589,6 +589,15 @@ struct problem_context {
 /* Index start doesn't match start of next extent down */
 #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
 
+/* INLINE_DATA feature is set, but EXT_ATTR missing */
+#define PR_1_INLINE_DATA_AND_EXT_ATTR  0x01006E
+
+/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
+#define PR_1_INLINE_DATA_FEATURE       0x01006F
+
+/* INLINE_DATA feature is set in a non-inline-data filesystem */
+#define PR_1_INLINE_DATA_SET	       0x010070
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ab4c70e..fc40ef2 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1357,6 +1357,7 @@ extern errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
 						  struct ext2_inode_large *inode,
 						  void *priv_data),
 				      void *priv_data);
+extern int ext2fs_inline_data_check(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_create(ext2_filsys fs,
 					   struct ext2_inode_large *inode,
 					   unsigned int len);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 52ac133..1c954a3 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -383,6 +383,34 @@ err:
 	return retval;
 }
 
+int ext2fs_inline_data_check(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	int pass = 0;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return pass;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto err;
+
+	retval = ext2fs_inline_data_find(fs, inode, &data);
+	if (retval)
+		goto err;
+
+	if (data.inline_off != 0)
+		pass = 1;
+
+err:
+	ext2fs_free_mem(&inode);
+	return pass;
+}
+
 errcode_t ext2fs_inline_data_convert(ext2_filsys fs,
 				     ext2_ino_t  ino,
 				     void *priv_data)
-- 
1.7.9.7

