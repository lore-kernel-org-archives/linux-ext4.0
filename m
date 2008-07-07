From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] handle large extent-based files in pass1
Date: Sun, 06 Jul 2008 23:02:47 -0500
Message-ID: <48719567.1090404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Nick Dokos <nicholas.dokos@hp.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYGGEC4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 00:02:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This:

# /root/truncate bigfile 14680064000000
Truncating bigfile to 14680064000000
# e2fsck /device
Pass 1: Checking inodes, blocks, and sizes
Inode 49154, i_size is 14680064000000, should be 0.  Fix<y>?

is a bit unexpected.  It's because the size is being checked
against the max sizes for bitmap files, not extent-based files.

Nick saw this with his 14TB file.

Patch below applies different size limits to the different
file formats.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--

Index: e2fsprogs/e2fsck/pass1.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass1.c	2008-06-16 11:50:08.877734863 -0500
+++ e2fsprogs/e2fsck/pass1.c	2008-07-06 22:53:52.712291253 -0500
@@ -1756,6 +1756,7 @@ static void check_blocks(e2fsck_t ctx, s
 	struct ext2_inode *inode = pctx->inode;
 	int		bad_size = 0;
 	int		dirty_inode = 0;
+	int		extent_fs;
 	__u64		size;
 	
 	pb.ino = ino;
@@ -1775,6 +1776,9 @@ static void check_blocks(e2fsck_t ctx, s
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
+	extent_fs = (ctx->fs->super->s_feature_incompat &
+                     EXT3_FEATURE_INCOMPAT_EXTENTS);
+
 	if (inode->i_flags & EXT2_COMPRBLK_FL) {
 		if (fs->super->s_feature_incompat &
 		    EXT2_FEATURE_INCOMPAT_COMPRESSION)
@@ -1794,9 +1798,7 @@ static void check_blocks(e2fsck_t ctx, s
 	}
 
 	if (ext2fs_inode_has_valid_blocks(inode)) {
-		if ((ctx->fs->super->s_feature_incompat &
-		     EXT3_FEATURE_INCOMPAT_EXTENTS) &&
-		    (inode->i_flags & EXT4_EXTENTS_FL))
+		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else
 			pctx->errcode = ext2fs_block_iterate2(fs, ino,
@@ -1892,8 +1894,14 @@ static void check_blocks(e2fsck_t ctx, s
 		    (pb.last_block / blkpg * blkpg != pb.last_block ||
 		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
 			bad_size = 3;
-		else if (size > ext2_max_sizes[fs->super->s_log_block_size])
+		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
+			 size > ext2_max_sizes[fs->super->s_log_block_size])
+			/* too big for a direct/indirect-mapped file */
 			bad_size = 4;
+		else if ((extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
+			 size > (1LL << (32 + fs->super->s_log_block_size) - 1))
+			/* too big for an extent-based file - 32bit ee_block */
+			bad_size = 6;
 	}
 	/* i_size for symlinks is checked elsewhere */
 	if (bad_size && !LINUX_S_ISLNK(inode->i_mode)) {

