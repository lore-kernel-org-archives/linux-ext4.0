From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/31] libext2fs: Be more thorough in searching a range of
 blocks for a cluster
Date: Mon, 30 Sep 2013 18:28:56 -0700
Message-ID: <20131001012856.28415.77322.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB3A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:00 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

implied_cluster_alloc() is written such that if the the user passes in a
logical block that is the zeroth block in a logical cluster (lblk %
cluster_ratio == 0), then it will assume that there is no physical cluster
mapped to any other part of the logical cluster.

This is not true if we happen to be allocating logical blocks in reverse order.
Therefore, search the whole cluster, except for the lblk that we passed in.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index aadd22e..5074587 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -140,7 +140,7 @@ static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
 static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 				       struct ext2_inode *inode,
 				       ext2_extent_handle_t handle,
-				       blk64_t block, blk64_t *phys_blk)
+				       blk64_t lblk, blk64_t *phys_blk)
 {
 	blk64_t	base_block, pblock = 0;
 	int i;
@@ -149,10 +149,19 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 					EXT4_FEATURE_RO_COMPAT_BIGALLOC))
 		return 0;
 
-	base_block = block & ~EXT2FS_CLUSTER_MASK(fs);
+	base_block = lblk & ~EXT2FS_CLUSTER_MASK(fs);
+	/*
+	 * Except for the logical block (lblk) that was passed in, search all
+	 * blocks in this logical cluster for a mapping to a physical cluster.
+	 * If any such map exists, calculate the physical block that maps to
+	 * the logical block and return that.
+	 *
+	 * The old code wouldn't even look if (block % cluster_ratio) == 0;
+	 * this is incorrect if we're allocating blocks in reverse order.
+	 */
 	for (i = 0; i < EXT2FS_CLUSTER_RATIO(fs); i++) {
-		if (block == base_block)
-			return 0;
+		if (base_block + i == lblk)
+			continue;
 		extent_bmap(fs, ino, inode, handle, 0, 0,
 			    base_block + i, 0, 0, &pblock);
 		if (pblock)
@@ -160,7 +169,7 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 	}
 	if (pblock == 0)
 		return 0;
-	*phys_blk = pblock - i + (block - base_block);
+	*phys_blk = pblock - i + (lblk - base_block);
 	return 0;
 }
 

