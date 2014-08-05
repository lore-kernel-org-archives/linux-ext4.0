From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/21] e2fsck: do a better job of fixing i_size of inline
 directories
Date: Mon, 04 Aug 2014 18:06:42 -0700
Message-ID: <20140805010642.2611.55743.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaHEBGs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:48 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we encounter a directory whose i_size != the inline data size, just
set i_size to the size of the inline data.  The pb.last_block
calculation is wrong since pb.last_block == -1, which results in
i_size being set to zero, which corrupts the directory.

Clear the inline_data inode flag if we actually /are/ setting i_size
to zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b214f72..1a9e0d5 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2832,17 +2832,21 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if (inode->i_flags & EXT4_INLINE_DATA_FL) {
 			int flags;
 			size_t size;
+			errcode_t err;
 
+			size = 0;
 			flags = ctx->fs->flags;
 			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
-			if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
-				bad_size = 5;
+			err = ext2fs_inline_data_size(ctx->fs, pctx->ino,
+						      &size);
 			ctx->fs->flags = (flags &
 					  EXT2_FLAG_IGNORE_CSUM_ERRORS) |
 					 (ctx->fs->flags &
 					  ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
-			if (size != inode->i_size)
-				bad_size = 5;
+			if (err || size != inode->i_size) {
+				bad_size = 7;
+				pctx->num = size;
+			}
 		} else if (inode->i_size & (fs->blocksize - 1))
 			bad_size = 5;
 		else if (nblock > (pb.last_block + 1))
@@ -2875,12 +2879,20 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	}
 	/* i_size for symlinks is checked elsewhere */
 	if (bad_size && !LINUX_S_ISLNK(inode->i_mode)) {
-		pctx->num = (pb.last_block+1) * fs->blocksize;
+		/* Did inline_data set pctx->num earlier? */
+		if (bad_size != 7)
+			pctx->num = (pb.last_block + 1) * fs->blocksize;
 		pctx->group = bad_size;
 		if (fix_problem(ctx, PR_1_BAD_I_SIZE, pctx)) {
 			if (LINUX_S_ISDIR(inode->i_mode))
 				pctx->num &= 0xFFFFFFFFULL;
 			ext2fs_inode_size_set(fs, inode, pctx->num);
+			if (EXT2_I_SIZE(inode) == 0 &&
+			    (inode->i_flags & EXT4_INLINE_DATA_FL)) {
+				memset(inode->i_block, 0,
+				       sizeof(inode->i_block));
+				inode->i_flags &= ~EXT4_INLINE_DATA_FL;
+			}
 			dirty_inode++;
 		}
 		pctx->num = 0;

