From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] e2fsck: remove last argument from e2fsck_discard_blocks()
Date: Sun, 11 Mar 2012 15:33:11 -0400
Message-ID: <1331494393-21577-1-git-send-email-tytso@mit.edu>
References: <20120311191836.GD1048@thunk.org>
Cc: lczerner@redhat.com, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36475 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2CKTdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:33:15 -0400
In-Reply-To: <20120311191836.GD1048@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Lukas Czerner <lczerner@redhat.com>

Simple code cleanup.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass5.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 9a6a4b0..ca438cb 100644
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
@@ -379,7 +379,7 @@ redo_counts:
 				first_free = i;
 		} else {
 			if (i > first_free)
-				e2fsck_discard_blocks(ctx, manager, first_free,
+				e2fsck_discard_blocks(ctx, first_free,
 						      (i - first_free));
 			first_free = ext2fs_blocks_count(fs->super);
 		}
-- 
1.7.9.107.g97f9a

