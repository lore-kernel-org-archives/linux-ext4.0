From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v2] Don't report uninit extents past EOF invalid
Date: Wed, 14 Aug 2013 14:30:07 -0400
Message-ID: <20130814183007.GB2602@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49677 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222Ab3HNSaP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Aug 2013 14:30:15 -0400
Received: by mail-ve0-f178.google.com with SMTP id ox1so7931476veb.23
        for <linux-ext4@vger.kernel.org>; Wed, 14 Aug 2013 11:30:14 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit d3f32c2db8 introduced a regression that caused e2fsck failures
in xfstests generic 013, 070, 083, 091, and 263.  Uninitialized
extents created by fallocate() at the end of file with the
FALLOC_FL_KEEP_SIZE flag were identified as invalid.  However,
because the file size is not increased when FALLOC_FL_KEEP_SIZE is
used, uninitialized extents can correctly contain blocks located past
the end of file.

Fix this by filtering out possible invalid extents if they are
uninitialized and extend past the block containing the end of file.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/pass1.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ba6025b..6344d81 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1849,6 +1849,7 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			     struct process_block_struct *pb,
 			     blk64_t start_block, blk64_t end_block,
+			     blk64_t eof_block,
 			     ext2_extent_handle_t ehandle)
 {
 	struct ext2fs_extent	extent;
@@ -1892,7 +1893,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
-		else if (end_block && last_lblk > end_block)
+		else if ((end_block && last_lblk > end_block) &&
+			 (!(extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT &&
+				last_lblk > eof_block)))
 			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;
 		else if (is_leaf && extent.e_len == 0)
 			problem = PR_1_EXTENT_LENGTH_ZERO;
@@ -1968,7 +1971,7 @@ fix_problem_now:
 					ext2fs_extent_fix_parents(ehandle);
 			}
 			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
-					 last_lblk, ehandle);
+					 last_lblk, eof_block, ehandle);
 			if (pctx->errcode)
 				return;
 			pctx->errcode = ext2fs_extent_get(ehandle,
@@ -2071,6 +2074,7 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	ext2_filsys		fs = ctx->fs;
 	ext2_ino_t		ino = pctx->ino;
 	errcode_t		retval;
+	blk64_t                 eof_lblk;
 
 	pctx->errcode = ext2fs_extent_open2(fs, ino, inode, &ehandle);
 	if (pctx->errcode) {
@@ -2088,7 +2092,9 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 		ctx->extent_depth_count[info.max_depth]++;
 	}
 
-	scan_extent_node(ctx, pctx, pb, 0, 0, ehandle);
+	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
+		EXT2_BLOCK_SIZE_BITS(fs->super)) - 1;
+	scan_extent_node(ctx, pctx, pb, 0, 0, eof_lblk, ehandle);
 	if (pctx->errcode &&
 	    fix_problem(ctx, PR_1_EXTENT_ITERATE_FAILURE, pctx)) {
 		pb->num_blocks = 0;
-- 
1.7.10.4

