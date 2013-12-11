From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 46/74] e2fsck: try implied cluster allocation when expanding a
 dir
Date: Tue, 10 Dec 2013 17:23:27 -0800
Message-ID: <20131211012327.30655.58116.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43368 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3LKBXf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:23:35 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're expanding a directory, check to see if we're doing an
implied cluster allocation; if so, we don't need to allocate a new
block, and we certainly don't need to update the summary counts.

Reported-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index dc9d7c1..c57aab8 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -718,12 +718,23 @@ static int expand_dir_proc(ext2_filsys fs,
 		last_blk = *blocknr;
 		return 0;
 	}
-	retval = ext2fs_new_block2(fs, last_blk, ctx->block_found_map,
-				  &new_blk);
-	if (retval) {
-		es->err = retval;
-		return BLOCK_ABORT;
+
+	if (blockcnt &&
+	    (EXT2FS_B2C(fs, last_blk) == EXT2FS_B2C(fs, last_blk + 1)))
+		new_blk = last_blk + 1;
+	else {
+		last_blk &= ~EXT2FS_CLUSTER_MASK(fs);
+		retval = ext2fs_new_block2(fs, last_blk, ctx->block_found_map,
+					  &new_blk);
+		if (retval) {
+			es->err = retval;
+			return BLOCK_ABORT;
+		}
+		es->newblocks++;
+		ext2fs_block_alloc_stats2(fs, new_blk, +1);
 	}
+	last_blk = new_blk;
+
 	if (blockcnt > 0) {
 		retval = ext2fs_new_dir_block(fs, 0, 0, &block);
 		if (retval) {
@@ -749,8 +760,6 @@ static int expand_dir_proc(ext2_filsys fs,
 	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, new_blk);
-	ext2fs_block_alloc_stats2(fs, new_blk, +1);
-	es->newblocks++;
 
 	if (es->num == 0)
 		return (BLOCK_CHANGED | BLOCK_ABORT);

