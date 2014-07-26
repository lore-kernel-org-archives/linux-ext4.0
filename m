From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/18] e2fsck: toggle checksum verification error reporting
 appropriately
Date: Fri, 25 Jul 2014 17:34:53 -0700
Message-ID: <20140726003453.28334.47494.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31885 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaGZAe6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:58 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are a few mistakes in the checksum verification error reporting
logic.  First, when we're doing a re-check of an inode that failed
earlier, we must never ignore checksum errors.  Second, if we're
performing sanity checks after an initial checksum verification
failure, then we /should/ disable checksum error reporting for
block_iterate because that function will re-read the inode from disk.
This fixes the numerous "inode checksum failure" problems that cause
e2fsck to abort.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 646ef8a..d09b4eb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -573,13 +573,18 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 {
 	errcode_t retval;
 	struct ext2_inode_large inode;
+	int flags;
 
 	/*
 	 * Reread inode.  If we don't see checksum error, then this inode
 	 * has been fixed elsewhere.
 	 */
+	flags = fs->flags;
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
 					sizeof(inode));
+	fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+		    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 	if (retval && retval != EXT2_ET_INODE_CSUM_INVALID)
 		return retval;
 	if (!retval)
@@ -588,11 +593,22 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 	/*
 	 * Checksum still doesn't match.  That implies that the inode passes
 	 * all the sanity checks, so maybe the checksum is simply corrupt.
-	 * See if the user will go for fixing that.
+	 * See if the user will go for fixing that.  We have to re-try the
+	 * inode read because the inode struct won't be overwritten if there's
+	 * a checksum verify error.
 	 */
 	if (!fix_problem(ctx, PR_1_INODE_ONLY_CSUM_INVALID, pctx))
 		return 0;
 
+	flags = fs->flags;
+	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	retval = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+					sizeof(inode));
+	fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+		    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
+	if (retval)
+		return retval;
+
 	retval = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
 					 sizeof(inode));
 	if (retval)
@@ -970,6 +986,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 		if (ino == EXT2_BAD_INO) {
 			struct process_block_struct pb;
+			int flags;
 
 			if ((inode->i_mode || inode->i_uid || inode->i_gid ||
 			     inode->i_links_count || inode->i_file_acl) &&
@@ -996,8 +1013,13 @@ void e2fsck_pass1(e2fsck_t ctx)
 			pb.inode = inode;
 			pb.pctx = &pctx;
 			pb.ctx = ctx;
+			flags = fs->flags;
+			if (failed_csum)
+				fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			pctx.errcode = ext2fs_block_iterate3(fs, ino, 0,
 				     block_buf, process_bad_block, &pb);
+			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 			ext2fs_free_block_bitmap(pb.fs_meta_blocks);
 			if (pctx.errcode) {
 				fix_problem(ctx, PR_1_BLOCK_ITERATE, &pctx);
@@ -2453,6 +2475,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else {
+			int flags;
 			/*
 			 * If we've modified the inode, write it out before
 			 * iterate() tries to use it.
@@ -2462,6 +2485,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 						   "check_blocks");
 				dirty_inode = 0;
 			}
+			flags = fs->flags;
 			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
@@ -2480,7 +2504,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			if (pb.inode_modified)
 				e2fsck_read_inode(ctx, ino, inode,
 						  "check_blocks");
-			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		}
 	} else {
 		/* check inline data */
@@ -2546,10 +2571,17 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (pb.is_dir) {
 		int nblock = inode->i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
 		if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+			int flags;
 			size_t size;
 
+			flags = ctx->fs->flags;
+			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
 				bad_size = 5;
+			ctx->fs->flags = (flags &
+					  EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+					 (ctx->fs->flags &
+					  ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 			if (size != inode->i_size)
 				bad_size = 5;
 		} else if (inode->i_size & (fs->blocksize - 1))

