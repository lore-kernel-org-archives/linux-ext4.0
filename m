From: Jan Kara <jack@suse.com>
Subject: [PATCH 16/21] ext2fs: Remove old block mapping function
Date: Wed, 26 Aug 2015 18:22:31 +0200
Message-ID: <1440606156-5754-17-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbbHZQW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:58 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an old unused block mapping function in libext2fs. Just remove
it since the new one provides superior functionality.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/bmove.c  | 167 ----------------------------------------------------
 lib/ext2fs/ext2fs.h |  16 -----
 2 files changed, 183 deletions(-)
 delete mode 100644 lib/ext2fs/bmove.c

diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
deleted file mode 100644
index e2ea405a5910..000000000000
--- a/lib/ext2fs/bmove.c
+++ /dev/null
@@ -1,167 +0,0 @@
-/*
- * bmove.c --- Move blocks around to make way for a particular
- * 	filesystem structure.
- *
- * Copyright (C) 1997 Theodore Ts'o.
- *
- * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Library
- * General Public License, version 2.
- * %End-Header%
- */
-
-#include "config.h"
-#include <stdio.h>
-#include <string.h>
-#if HAVE_UNISTD_H
-#include <unistd.h>
-#endif
-#if HAVE_SYS_TYPES_H
-#include <sys/types.h>
-#endif
-#if HAVE_SYS_TIME_H
-#include <sys/time.h>
-#endif
-
-#include "ext2_fs.h"
-#include "ext2fsP.h"
-
-struct process_block_struct {
-	ext2_ino_t		ino;
-	struct ext2_inode *	inode;
-	ext2fs_block_bitmap	reserve;
-	ext2fs_block_bitmap	alloc_map;
-	errcode_t		error;
-	char			*buf;
-	int			add_dir;
-	int			flags;
-};
-
-static int process_block(ext2_filsys fs, blk64_t *block_nr,
-			 e2_blkcnt_t blockcnt, blk64_t ref_block,
-			 int ref_offset, void *priv_data)
-{
-	struct process_block_struct *pb;
-	errcode_t	retval;
-	int		ret;
-	blk64_t		block, orig;
-
-	pb = (struct process_block_struct *) priv_data;
-	block = orig = *block_nr;
-	ret = 0;
-
-	/*
-	 * Let's see if this is one which we need to relocate
-	 */
-	if (ext2fs_test_block_bitmap2(pb->reserve, block)) {
-		do {
-			if (++block >= ext2fs_blocks_count(fs->super))
-				block = fs->super->s_first_data_block;
-			if (block == orig) {
-				pb->error = EXT2_ET_BLOCK_ALLOC_FAIL;
-				return BLOCK_ABORT;
-			}
-		} while (ext2fs_test_block_bitmap2(pb->reserve, block) ||
-			 ext2fs_test_block_bitmap2(pb->alloc_map, block));
-
-		retval = io_channel_read_blk64(fs->io, orig, 1, pb->buf);
-		if (retval) {
-			pb->error = retval;
-			return BLOCK_ABORT;
-		}
-		retval = io_channel_write_blk64(fs->io, block, 1, pb->buf);
-		if (retval) {
-			pb->error = retval;
-			return BLOCK_ABORT;
-		}
-		*block_nr = block;
-		ext2fs_mark_block_bitmap2(pb->alloc_map, block);
-		ret = BLOCK_CHANGED;
-		if (pb->flags & EXT2_BMOVE_DEBUG)
-			printf("ino=%u, blockcnt=%lld, %llu->%llu\n",
-			       (unsigned) pb->ino, blockcnt, 
-			       (unsigned long long) orig,
-			       (unsigned long long) block);
-	}
-	if (pb->add_dir) {
-		retval = ext2fs_add_dir_block2(fs->dblist, pb->ino,
-					       block, blockcnt);
-		if (retval) {
-			pb->error = retval;
-			ret |= BLOCK_ABORT;
-		}
-	}
-	return ret;
-}
-
-errcode_t ext2fs_move_blocks(ext2_filsys fs,
-			     ext2fs_block_bitmap reserve,
-			     ext2fs_block_bitmap alloc_map,
-			     int flags)
-{
-	ext2_ino_t	ino;
-	struct ext2_inode inode;
-	errcode_t	retval;
-	struct process_block_struct pb;
-	ext2_inode_scan	scan;
-	char		*block_buf;
-
-	retval = ext2fs_open_inode_scan(fs, 0, &scan);
-	if (retval)
-		return retval;
-
-	pb.reserve = reserve;
-	pb.error = 0;
-	pb.alloc_map = alloc_map ? alloc_map : fs->block_map;
-	pb.flags = flags;
-
-	retval = ext2fs_get_array(4, fs->blocksize, &block_buf);
-	if (retval)
-		return retval;
-	pb.buf = block_buf + fs->blocksize * 3;
-
-	/*
-	 * If GET_DBLIST is set in the flags field, then we should
-	 * gather directory block information while we're doing the
-	 * block move.
-	 */
-	if (flags & EXT2_BMOVE_GET_DBLIST) {
-		if (fs->dblist) {
-			ext2fs_free_dblist(fs->dblist);
-			fs->dblist = NULL;
-		}
-		retval = ext2fs_init_dblist(fs, 0);
-		if (retval)
-			return retval;
-	}
-
-	retval = ext2fs_get_next_inode(scan, &ino, &inode);
-	if (retval)
-		return retval;
-
-	while (ino) {
-		if ((inode.i_links_count == 0) ||
-		    !ext2fs_inode_has_valid_blocks2(fs, &inode))
-			goto next;
-
-		pb.ino = ino;
-		pb.inode = &inode;
-
-		pb.add_dir = (LINUX_S_ISDIR(inode.i_mode) &&
-			      flags & EXT2_BMOVE_GET_DBLIST);
-
-		retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
-					       process_block, &pb);
-		if (retval)
-			return retval;
-		if (pb.error)
-			return pb.error;
-
-	next:
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
-		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
-			goto next;
-	}
-	return 0;
-}
-
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e76ceaa699e6..de4b8c2f7013 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -344,14 +344,6 @@ struct struct_ext2_filsys {
 #define BLOCK_COUNT_TIND	(-3)
 #define BLOCK_COUNT_TRANSLATOR	(-4)
 
-#if 0
-/*
- * Flags for ext2fs_move_blocks
- */
-#define EXT2_BMOVE_GET_DBLIST	0x0001
-#define EXT2_BMOVE_DEBUG	0x0002
-#endif
-
 /*
  * Generic (non-filesystem layout specific) extents structure
  */
@@ -948,14 +940,6 @@ errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
 				   struct ext2_inode *inode, blk64_t lblk,
 				   blk64_t *pblk);
 
-#if 0
-/* bmove.c */
-extern errcode_t ext2fs_move_blocks(ext2_filsys fs,
-				    ext2fs_block_bitmap reserve,
-				    ext2fs_block_bitmap alloc_map,
-				    int flags);
-#endif
