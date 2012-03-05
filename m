From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4] e2fsck: Do not forget to discard last block group
Date: Mon,  5 Mar 2012 08:49:34 +0100
Message-ID: <1330933776-2696-2-git-send-email-lczerner@redhat.com>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2CEHtn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 02:49:43 -0500
In-Reply-To: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously when running e2fsck with '-E discard' argument the end of
the last group has not been discarded. This patch fixes it so we
always discard the end of the last group if needed.

This commit also removes unneeded argument from the
e2fsck_discard_blocks(). Simultaneously the commit causes the block
groups with BLOCK_UNINIT flag not to be discarded, which makes
sense because we do not need to reclaim the space since so far
there has not been written anything.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/pass5.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index ee73dd5..37bbac2 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -74,8 +74,8 @@ void e2fsck_pass5(e2fsck_t ctx)
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
-static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
-				  blk64_t start, blk64_t count)
+static void e2fsck_discard_blocks(e2fsck_t ctx, blk64_t start,
+				  blk64_t count)
 {
 	ext2_filsys fs = ctx->fs;
 
@@ -85,7 +85,7 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
 	 * not enough to fix the problem, hence it is not safe to run discard
 	 * in this case.
 	 */
-	if (ext2fs_test_changed(ctx->fs))
+	if (ext2fs_test_changed(fs))
 		ctx->options &= ~E2F_OPT_DISCARD;
 
 	if (!(ctx->options & E2F_OPT_NO) &&
@@ -137,7 +137,7 @@ static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
 	num = count / EXT2_INODES_PER_BLOCK(fs->super);
 
 	if (num > 0)
-		e2fsck_discard_blocks(ctx, fs->io->manager, blk, num);
+		e2fsck_discard_blocks(ctx, blk, num);
 }
 
 #define NO_BLK ((blk64_t) -1)
@@ -377,16 +377,24 @@ redo_counts:
 			free_blocks++;
 			if (first_free > i)
 				first_free = i;
-		} else {
-			if (i > first_free)
-				e2fsck_discard_blocks(ctx, manager, first_free,
-						      (i - first_free));
+		} else if (i > first_free) {
+			e2fsck_discard_blocks(ctx, first_free,
+					      (i - first_free));
 			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_clusters_per_group) ||
 		    (EXT2FS_B2C(fs, i) ==
 		     EXT2FS_B2C(fs, ext2fs_blocks_count(fs->super)-1))) {
+			/*
+			 * If the last block of this group is free, then we can
+			 * discard it as well.
+			 */
+			if (i >= first_free)
+				e2fsck_discard_blocks(ctx, first_free,
+						      (i - first_free) + 1);
+			first_free = ext2fs_blocks_count(fs->super);
+
 			free_array[group] = group_free;
 			group ++;
 			blocks = 0;
-- 
1.7.4.4

