From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 29/32] e2fsck: check incorrect inline data flag
Date: Mon, 16 Apr 2012 19:40:04 +0800
Message-ID: <1334576407-4007-30-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DPLep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:45 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:45 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
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
index c7645d1..023d8ed 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -559,7 +559,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	const char	*old_op;
 	unsigned int	save_type;
-	int		imagic_fs, extent_fs;
+	int		imagic_fs, extent_fs, inlinedata_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
 
@@ -592,6 +592,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
 	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
+	inlinedata_fs = (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 
 	/*
 	 * Allocate bitmaps structures
@@ -722,6 +723,17 @@ void e2fsck_pass1(e2fsck_t ctx)
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
@@ -762,6 +774,25 @@ void e2fsck_pass1(e2fsck_t ctx)
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

