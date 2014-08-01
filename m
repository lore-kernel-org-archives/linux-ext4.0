From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/19] e2fsck: disable checksum verification in a few select
 places
Date: Fri, 01 Aug 2014 11:12:54 -0700
Message-ID: <20140801181254.12496.15751.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaHASM7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:12:59 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Selectively disable checksum verification in a couple more places:

In check_blocks, disable checksum verification when iterating a block
map because the block map iterator function (re)reads the inode, which
could be unchanged since the scan found that the checksum fails.  We
don't want to abort here; we want to keep evaluating the inode, and we
already know if the inode checksum doesn't match.

Further down in check_blocks when we're trying to see if i_size
matches the amount of data stored in the inode, don't allow checksum
errors when we go looking for the size of inline data.  If the
required attribute is at all find-able in the EA block, we'll fix any
other problems with the EA block later.  In the meantime, we don't
want to be truncating files unnecessarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a7792c4..39ebaae 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2452,6 +2452,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else {
+			int flags;
 			/*
 			 * If we've modified the inode, write it out before
 			 * iterate() tries to use it.
@@ -2461,6 +2462,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 						   "check_blocks");
 				dirty_inode = 0;
 			}
+			flags = fs->flags;
 			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
@@ -2479,7 +2481,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			if (pb.inode_modified)
 				e2fsck_read_inode(ctx, ino, inode,
 						  "check_blocks");
-			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 		}
 	} else {
 		/* check inline data */
@@ -2545,10 +2548,17 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
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

