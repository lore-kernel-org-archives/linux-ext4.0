From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 3/3] e2fsck: Remove unused variable
Date: Mon, 06 Jul 2009 17:16:32 +0900
Message-ID: <4A51B2E0.9080002@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58955 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZGFIUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 04:20:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

check_block_bitmap() calculates the block number of superblock in the current
block group but it's not used.

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 pass5.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e660386..29930cc 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -103,7 +103,7 @@ static void print_bitmap_problem(e2fsck_t ctx, int problem,
 static void check_block_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t	i, super;
+	blk_t	i;
 	int	*free_array;
 	int	group = 0;
 	blk_t	blocks = 0;
@@ -159,7 +159,6 @@ redo_counts:
 	if (csum_flag &&
 	    (fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT))
 		skip_group++;
-	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
 	     i < fs->super->s_blocks_count;
 	     i++) {
@@ -255,7 +254,6 @@ redo_counts:
 			blocks = 0;
 			group_free = 0;
 			skip_group = 0;
-			super += fs->super->s_blocks_per_group;
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 5, group,
 						    fs->group_desc_count*2))
