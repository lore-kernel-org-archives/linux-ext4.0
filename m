From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/49] e2fsck: write dir blocks after new inode when
 reconstructing root/lost+found
Date: Mon, 10 Mar 2014 23:56:37 -0700
Message-ID: <20140311065637.30585.86807.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32762 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbaCKG4m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:56:42 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck has to rebuild the root or lost+found directories, be sure
to write the new directory block after the inode, because the dir
block write has to read the on-disk inode for the generation number.
This solves the problem where e2fsck will cough out complaints about
checksums failing on lost+found and later crash.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass3.c |   85 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 40 deletions(-)


diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 6f7f855..efc0d49 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -188,28 +188,6 @@ static void check_root(e2fsck_t ctx)
 	ext2fs_mark_bb_dirty(fs);
 
 	/*
-	 * Now let's create the actual data block for the inode
-	 */
-	pctx.errcode = ext2fs_new_dir_block(fs, EXT2_ROOT_INO, EXT2_ROOT_INO,
-					    &block);
-	if (pctx.errcode) {
-		pctx.str = "ext2fs_new_dir_block";
-		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-
-	pctx.errcode = ext2fs_write_dir_block4(fs, blk, block, 0,
-					       EXT2_ROOT_INO);
-	if (pctx.errcode) {
-		pctx.str = "ext2fs_write_dir_block4";
-		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-	ext2fs_free_mem(&block);
-
-	/*
 	 * Set up the inode structure
 	 */
 	memset(&inode, 0, sizeof(inode));
@@ -232,6 +210,30 @@ static void check_root(e2fsck_t ctx)
 	}
 
 	/*
+	 * Now let's create the actual data block for the inode.
+	 * Due to metadata_csum, we must write the dir blocks AFTER
+	 * the inode has been written to disk!
+	 */
+	pctx.errcode = ext2fs_new_dir_block(fs, EXT2_ROOT_INO, EXT2_ROOT_INO,
+					    &block);
+	if (pctx.errcode) {
+		pctx.str = "ext2fs_new_dir_block";
+		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
+	pctx.errcode = ext2fs_write_dir_block4(fs, blk, block, 0,
+					       EXT2_ROOT_INO);
+	ext2fs_free_mem(&block);
+	if (pctx.errcode) {
+		pctx.str = "ext2fs_write_dir_block4";
+		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
+	/*
 	 * Miscellaneous bookkeeping...
 	 */
 	e2fsck_add_dir_info(ctx, EXT2_ROOT_INO, EXT2_ROOT_INO);
@@ -449,24 +451,6 @@ unlink:
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
 
 	/*
-	 * Now let's create the actual data block for the inode
-	 */
-	retval = ext2fs_new_dir_block(fs, ino, EXT2_ROOT_INO, &block);
-	if (retval) {
-		pctx.errcode = retval;
-		fix_problem(ctx, PR_3_ERR_LPF_NEW_DIR_BLOCK, &pctx);
-		return 0;
-	}
-
-	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
-	ext2fs_free_mem(&block);
-	if (retval) {
-		pctx.errcode = retval;
-		fix_problem(ctx, PR_3_ERR_LPF_WRITE_BLOCK, &pctx);
-		return 0;
-	}
-
-	/*
 	 * Set up the inode structure
 	 */
 	memset(&inode, 0, sizeof(inode));
@@ -486,6 +470,27 @@ unlink:
 		fix_problem(ctx, PR_3_CREATE_LPF_ERROR, &pctx);
 		return 0;
 	}
+
+	/*
+	 * Now let's create the actual data block for the inode.
+	 * Due to metadata_csum, the directory block MUST be written
+	 * after the inode is written to disk!
+	 */
+	retval = ext2fs_new_dir_block(fs, ino, EXT2_ROOT_INO, &block);
+	if (retval) {
+		pctx.errcode = retval;
+		fix_problem(ctx, PR_3_ERR_LPF_NEW_DIR_BLOCK, &pctx);
+		return 0;
+	}
+
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
+	ext2fs_free_mem(&block);
+	if (retval) {
+		pctx.errcode = retval;
+		fix_problem(ctx, PR_3_ERR_LPF_WRITE_BLOCK, &pctx);
+		return 0;
+	}
+
 	/*
 	 * Finally, create the directory link
 	 */

