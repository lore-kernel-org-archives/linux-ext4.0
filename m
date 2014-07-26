From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/18] e2fsck: during pass1b delete_file,
 only free a cluster once
Date: Fri, 25 Jul 2014 17:34:10 -0700
Message-ID: <20140726003410.28334.82583.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31812 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaGZAeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:15 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're forced to delete a crosslinked file, only call
ext2fs_block_alloc_stats2() on cluster boundaries, since the block
bitmaps are all cluster bitmaps at this point.  It's safe to do this
only once per cluster since we know all the blocks are going away.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1b.c |    3 ++-
 e2fsck/pass2.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index c0bfa07..2d1b448 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -644,7 +644,8 @@ static int delete_file_block(ext2_filsys fs,
 			    _("internal error: can't find dup_blk for %llu\n"),
 				*block_nr);
 	} else {
-		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
+		if ((*block_nr % EXT2FS_CLUSTER_RATIO(ctx->fs)) == 0)
+			ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 		pb->dup_blocks++;
 	}
 	pb->cur_cluster = lc;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index e2bed2f..57d5a16 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1336,7 +1336,8 @@ static int deallocate_inode_block(ext2_filsys fs,
 	if ((*block_nr < fs->super->s_first_data_block) ||
 	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;
-	ext2fs_block_alloc_stats2(fs, *block_nr, -1);
+	if ((*block_nr % EXT2FS_CLUSTER_RATIO(fs)) == 0)
+		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 	p->num++;
 	return 0;
 }

