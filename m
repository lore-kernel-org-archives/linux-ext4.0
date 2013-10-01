From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/31] libext2fs: Use ext2fs_punch() to truncate quota file
Date: Mon, 30 Sep 2013 18:29:15 -0700
Message-ID: <20131001012915.28415.89982.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22838 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:19 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new ext2fs_punch() call to truncate the quota file.  This also
eliminates the need to fix it to work with bigalloc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/quota/quotaio.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)


diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 8ddb92a..807fabd 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -98,19 +98,6 @@ void update_grace_times(struct dquot *q)
 	}
 }
 
-static int release_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
-			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
-			       blk64_t ref_block EXT2FS_ATTR((unused)),
-			       int ref_offset EXT2FS_ATTR((unused)),
-			       void *private EXT2FS_ATTR((unused)))
-{
-	blk64_t	block;
-
-	block = *blocknr;
-	ext2fs_block_alloc_stats2(fs, block, -1);
-	return 0;
-}
-
 static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 			       e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
 			       blk64_t ref_block EXT2FS_ATTR((unused)),
@@ -135,9 +122,9 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 		inode.i_dtime = fs->now ? fs->now : time(0);
 		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			return 0;
