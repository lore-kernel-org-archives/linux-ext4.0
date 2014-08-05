From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/21] e2fsck: check inline directory data "block" first
Date: Mon, 04 Aug 2014 18:06:15 -0700
Message-ID: <20140805010615.2611.4060.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40355 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaHEBGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:20 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the inline data flag will cause the extent/block map iteration
code to abort fsck early, move the test for the inode flag and the
actual block check call further forward in check_blocks.  This
eliminates an e2fsck abort on an inline data symlink when the file ACL
block is set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f7c1fbb..8bd08ee 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2596,7 +2596,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		pb.num_blocks++;
 	}
 
-	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
+	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
+		check_blocks_inline_data(ctx, pctx, &pb);
+	else if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else {
@@ -2632,10 +2634,6 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
 				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		}
-	} else {
-		/* check inline data */
-		if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL))
-			check_blocks_inline_data(ctx, pctx, &pb);
 	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
 	end_problem_latch(ctx, PR_LATCH_TOOBIG);

