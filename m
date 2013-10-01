From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/31] e2fsck: Only release clusters when shortening a
 directory during a rehash
Date: Mon, 30 Sep 2013 18:29:21 -0700
Message-ID: <20131001012921.28415.90047.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38202 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB30 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:26 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the rehash process is running on a bigalloc filesystem, it compresses all
the directory entries and hash structures into the beginning of the directory
file and then uses block_iterate3() to free the blocks off the end of the file.
It seems to call ext2fs_block_alloc_stats2() for every block in a cluster,
which is unfortunate because this function allocates and frees entire clusters
(and updates the summary counts accordingly).  In this case e2fsck writes out
incorrect summary counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/rehash.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 6ef3568..29da9a1 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -719,10 +719,18 @@ static int write_dir_block(ext2_filsys fs,
 		/* We don't need this block, so release it */
 		e2fsck_read_bitmaps(wd->ctx);
 		blk = *block_nr;
-		ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map, blk);
-		ext2fs_block_alloc_stats2(fs, blk, -1);
+		/*
+		 * In theory, we only release blocks from the end of the
+		 * directory file, so it's fine to clobber a whole cluster at
+		 * once.
+		 */
+		if (blk % EXT2FS_CLUSTER_RATIO(fs) == 0) {
+			ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map,
+						    blk);
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			wd->cleared++;
+		}
 		*block_nr = 0;
-		wd->cleared++;
 		return BLOCK_CHANGED;
 	}
 

