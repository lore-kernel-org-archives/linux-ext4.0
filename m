From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH] fix the extent validity checking in e2fsck
Date: Fri, 14 May 2010 14:42:00 -0700 (PDT)
Message-ID: <20100514214200.8B9DB1BC317@ruihe.smo.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: curtw@google.com, fmayhar@google.com, mrubin@google.com,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab0ENVmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 May 2010 17:42:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch changes e2fsck to use the same checking on the validity of an extent
as the kernel ext4 is using.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3c6f91c..c5dc01a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1690,8 +1690,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
 
 		problem = 0;
-		if (extent.e_pblk < ctx->fs->super->s_first_data_block ||
-		    extent.e_pblk >= ext2fs_blocks_count(ctx->fs->super))
+		if (extent.e_pblk <= ctx->fs->super->s_first_data_block ||
+		    extent.e_pblk > ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_BAD_START_BLK;
 		else if (extent.e_lblk < start_block)
 			problem = PR_1_OUT_OF_ORDER_EXTENTS;
