From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] e2fsck: don't restart after a critical metadata collision in e2fsck -n mode
Date: Sun, 23 Jul 2017 00:50:32 -0400
Message-ID: <20170723045035.26019-2-tytso@mit.edu>
References: <20170723045035.26019-1-tytso@mit.edu>
Cc: abuchbinder@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51412 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750796AbdGWEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 00:50:45 -0400
In-Reply-To: <20170723045035.26019-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system isn't going to be changed, there's no point
restarting; it will just cause e2fsck to loop forever.

This problem was found using American Fuzzy Lop.

Reported-by: Adam Buchbinder <abuchbinder@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass1.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c358eec0f..8044beed6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2718,7 +2718,8 @@ report_problem:
 				fix_problem(ctx,
 					    PR_1_CRITICAL_METADATA_COLLISION,
 					    pctx);
-				ctx->flags |= E2F_FLAG_RESTART_LATER;
+				if ((ctx->options & E2F_OPT_NO) == 0)
+					ctx->flags |= E2F_FLAG_RESTART_LATER;
 			}
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
@@ -3453,7 +3454,8 @@ static int process_block(ext2_filsys fs,
 	    ext2fs_test_block_bitmap2(ctx->block_metadata_map, blk)) {
 		pctx->blk = blk;
 		fix_problem(ctx, PR_1_CRITICAL_METADATA_COLLISION, pctx);
-		ctx->flags |= E2F_FLAG_RESTART_LATER;
+		if ((ctx->options & E2F_OPT_NO) == 0)
+			ctx->flags |= E2F_FLAG_RESTART_LATER;
 	}
 
 	if (problem) {
-- 
2.11.0.rc0.7.gbe5a750
