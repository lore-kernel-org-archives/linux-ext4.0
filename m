From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 30/35 v3] e2fsck: check incorrect inline data flag
Date: Sun,  1 Jul 2012 21:48:53 +0800
Message-ID: <1341150538-32047-31-git-send-email-wenqing.lz@taobao.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2GANlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 09:41:45 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6319540dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 06:41:45 -0700 (PDT)
In-Reply-To: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

First, we need to check whether or not EXT_ATTR feature is set when
INLINE_DATA feature is set.  Then we will check inode flag to set
EXT4_INLINE_DATA_FL flag.  If the user doesn't set this flag, INLINE_DATA
feature will be clear.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass1.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 48a1af0..fee0dc6 100644
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
@@ -627,6 +627,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
 	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	/*
 	 * Allocate bitmaps structures
@@ -758,6 +759,17 @@ void e2fsck_pass1(e2fsck_t ctx)
 		ext2fs_mark_block_bitmap2(ctx->block_found_map,
 					  fs->super->s_mmp_block);
 
+	/*
+	 * If INLINE_DATA is set and EXT_ATTR doesn't, EXT_ATTR needs to be set
+	 * because INLINE_DATA depends on it.  So the user need to determine
+	 * whether EXT_ATTR is set or not.
+	 */
+	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) &&
+	    inlinedata_fs) {
+		if (fix_problem(ctx, PR_1_INLINE_DATA_AND_EXT_ATTR, &pctx))
+			ext2fs_mark_super_dirty(fs);
+	}
+
 	while (1) {
 		if (ino % (fs->super->s_inodes_per_group * 4) == 1) {
 			if (e2fsck_mmp_update(fs))
@@ -807,6 +819,25 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 
 		/*
+		 * Test for incorrect inline data flags settings.
+		 *
+		 * TODO: check EXT2_ROOT_INO when '/' supports inline data
+		 * feature.
+		 */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && !inlinedata_fs &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			if (ext2fs_inline_data_header_verify(fs, inode) == 0 &&
+			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
+				sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_INLINE_DATA;
+				ext2fs_mark_super_dirty(fs);
+				inlinedata_fs = 1;
+			} else if (fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
+				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+				continue;
+			}
+		}
+
+		/*
 		 * Test for incorrect extent flag settings.
 		 *
 		 * On big-endian machines we must be careful:
-- 
1.7.4.1

