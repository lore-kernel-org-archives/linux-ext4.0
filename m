From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-41.diff>
Date: Fri, 9 Feb 2007 18:11:37 -0800
Message-ID: <200702100211.l1A2Bbg4007430@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:37127 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXBJCOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 41: Resource Leak

Went through call paths pretty carefully. Looks like it is safe to free
block_buf on an early return. The call paths that I found to use block_buf all
seem to be done with block_buf after they complete. One example is calling
swap_inode_blocks() which gets all the way to ext2fs_block_iterate2(). This
function uses block_buf to set ctx_ind_buf, but is done with it once the
function is complete.

Index: e2fsprogs+chaos/e2fsck/swapfs.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/swapfs.c
+++ e2fsprogs+chaos/e2fsck/swapfs.c
@@ -113,7 +113,7 @@ static void swap_inodes(e2fsck_t ctx)
 	dgrp_t			group;
 	unsigned int		i;
 	ext2_ino_t		ino = 1;
-	char 			*buf, *block_buf;
+	char 			*buf, *block_buf = NULL;
 	errcode_t		retval;
 	struct ext2_inode *	inode;
 
@@ -138,6 +138,8 @@ static void swap_inodes(e2fsck_t ctx)
 				_("while reading inode table (group %d)"),
 				group);
 			ctx->flags |= E2F_FLAG_ABORT;
+			if (block_buf)
+				free(block_buf);
 			return;
 		}
 		inode = (struct ext2_inode *) buf;
@@ -162,11 +164,14 @@ static void swap_inodes(e2fsck_t ctx)
 			     ext2fs_inode_has_valid_blocks(inode)))
 				swap_inode_blocks(ctx, ino, block_buf, inode);
 
-			if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+			if (ctx->flags & E2F_FLAG_SIGNAL_MASK) {
+				if (block_buf)
+					free(block_buf);
 				return;
+			}
 			
 			if (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)
-				ext2fs_swap_inode(fs, inode, inode, 1);
+				ext2fs_swap_inode(fs, inode,inode, 1);
 		}
 		retval = io_channel_write_blk(fs->io,
 		      fs->group_desc[group].bg_inode_table,
@@ -176,6 +181,8 @@ static void swap_inodes(e2fsck_t ctx)
 				_("while writing inode table (group %d)"),
 				group);
 			ctx->flags |= E2F_FLAG_ABORT;
+			if (block_buf)
+				free(block_buf);
 			return;
 		}
 	}
