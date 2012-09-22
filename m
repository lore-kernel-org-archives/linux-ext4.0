From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 16/21 v5] e2fsck: add problem descriptions and check inline data feature
Date: Sat, 22 Sep 2012 12:01:04 +0800
Message-ID: <1348286469-31690-17-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2IVD5Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:57:24 -0400
Received: by pbbrr4 with SMTP id rr4so3880193pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:57:23 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c           |   33 ++++++++++++++++++++++++++++++++-
 e2fsck/problem.c         |   15 +++++++++++++++
 e2fsck/problem.h         |    9 +++++++++
 lib/ext2fs/ext2fs.h      |    1 +
 lib/ext2fs/inline_data.c |   28 ++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a4bd956..1a12ed3 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -593,7 +593,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	const char	*old_op;
 	unsigned int	save_type;
-	int		imagic_fs, extent_fs;
+	int		imagic_fs, extent_fs, inlinedata_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
 	int		failed_csum = 0;
@@ -627,6 +627,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
 	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (sb->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	/*
 	 * Allocate bitmaps structures
@@ -758,6 +760,20 @@ void e2fsck_pass1(e2fsck_t ctx)
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
 
@@ -809,6 +825,21 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/* Test for incrrect inline_data flags settings. */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && !inlinedata_fs &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			if (ext2fs_inline_data_header_check(fs, ino) &&
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
index 78b05bb..ae99d6c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1000,6 +1000,21 @@ static struct e2fsck_problem problem_table[] = {
 	     "@i %i does not match.  "),
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
index 5caade4..2713f6c 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -586,6 +586,15 @@ struct problem_context {
 /* ea block passes checks, but checksum invalid */
 #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
 
+/* INLINE_DATA feature is set, but EXT_ATTR missing */
+#define PR_1_INLINE_DATA_AND_EXT_ATTR  0x01006D
+
+/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
+#define PR_1_INLINE_DATA_FEATURE       0x01006E
+
+/* INLINE_DATA feature is set in a non-inline-data filesystem */
+#define PR_1_INLINE_DATA_SET	       0x01006F
+
 
 /*
  * Pass 1b errors
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d1f4218..a4a3d06 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1344,6 +1344,7 @@ extern int ext2fs_inline_data_iterate(ext2_filsys fs,
 						  struct ext2_inode_large *inode,
 						  void *priv_data),
 				      void *priv_data);
+extern int ext2fs_inline_data_header_check(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_mkdir(ext2_filsys fs, ext2_ino_t parent,
 					  ext2_ino_t ino, const char *name);
 extern errcode_t ext2fs_convert_inline_data(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 4a98a37..d98b6c7 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -541,6 +541,34 @@ out:
 	return retval;
 }
 
+int ext2fs_inline_data_header_check(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode_large *inode;
+	struct inline_data data;
+	errcode_t retval = 0;
+	int pass = 0;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval);
+		return pass;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto err;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
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
 errcode_t ext2fs_convert_inline_data(ext2_filsys fs,
 				     ext2_ino_t  ino,
 				     void *priv_data)
-- 
1.7.4.1

