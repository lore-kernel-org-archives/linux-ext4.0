From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/74] libext2fs: use ext2fs_punch() to truncate quota file
Date: Tue, 10 Dec 2013 17:18:43 -0800
Message-ID: <20131211011843.30655.22033.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42112 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LKBSx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:18:53 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new ext2fs_punch() call to truncate the quota file.  This also
eliminates the need to fix it to work with bigalloc.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/quota/quotaio.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)


diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 8ddb92a..1bdcba6 100644
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
