From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 21/28] e2fsck: add problem descriptions and check inline data feature
Date: Tue,  3 Dec 2013 20:11:48 +0800
Message-ID: <1386072715-9869-22-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49860 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3LCMJy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:54 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so20026459pdj.29
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:54 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c   |   22 +++++++++++++++++++++-
 e2fsck/problem.c |    9 +++++++++
 e2fsck/problem.h |    7 +++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ab23e42..56411f1 100644
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
@@ -808,6 +810,24 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/* Test for incorrect inline_data flags settings. */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && !inlinedata_fs &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			size_t size = 0;
+
+			pctx.errcode = ext2fs_inline_data_size(fs, ino, &size);
+			if (!pctx.errcode && size &&
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
index 897693a..a4f7749 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1018,6 +1018,15 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inode has inline data, but superblock is missing INLINE_DATA feature. */
+	{ PR_1_INLINE_DATA_FEATURE,
+	  N_("@i %i has inline data, but @S is missing INLINE_DATA feature\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* INLINE_DATA feature is set in a non-inline-data filesystem */
+	{ PR_1_INLINE_DATA_SET,
+	  N_("@i %i has INLINE_DATA_FL flag on @f without inline data support.\n"),
+	  PROMPT_CLEAR, 0 },
 
 	/* Pass 1b errors */
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ae1ed26..9d41cea 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -593,6 +593,13 @@ struct problem_context {
 #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
 
 #define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
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
-- 
1.7.9.7

