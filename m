From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/7] tst_extents: Fix 64-bit bugs in do_goto_block()
Date: Thu, 22 Jul 2010 10:03:12 -0400
Message-ID: <1279807398-13680-2-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34079 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759467Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 030d73a..490dbe8 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1981,8 +1981,8 @@ void do_goto_block(int argc, char **argv)
 	struct ext2fs_extent	extent;
 	errcode_t		retval;
 	int			op = EXT2_EXTENT_NEXT_LEAF;
-	blk_t			blk;
-	int			level = 0;
+	blk64_t			blk;
+	int			level = 0, err;
 
 	if (common_extent_args_process(argc, argv, 2, 3, "goto_block",
 				       "block [level]", 0))
@@ -1991,16 +1991,18 @@ void do_goto_block(int argc, char **argv)
 	if (strtoblk(argv[0], argv[1], &blk))
 		return;
 
-	if (argc == 3)
-		if (strtoblk(argv[0], argv[2], &level))
+	if (argc == 3) {
+		level = parse_ulong(argv[2], argv[0], "level", &err);
+		if (err)
 			return;
+	}
 
 	retval = extent_goto(current_handle, level, (blk64_t) blk);
 
 	if (retval) {
 		com_err(argv[0], retval,
-			"while trying to go to block %u, level %d",
-			blk, level);
+			"while trying to go to block %llu, level %d",
+			(unsigned long long) blk, level);
 		return;
 	}
 
-- 
1.7.0.4

