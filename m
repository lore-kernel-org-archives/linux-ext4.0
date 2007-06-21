From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 9/11][take 2] indirect block type conversion in e2fsprogs
Date: Thu, 21 Jun 2007 17:34:29 +0200
Message-ID: <467A9A85.8000907@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010403050806050103060108"
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37126 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbXFUPzp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------010403050806050103060108
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch converts the indirect block definitions from blkt_t type to 
__u32.

Changes from the previous version:
- Fix errors found in the test suite "make check"

  e2fsck/pass1.c         |    2 -
  e2fsck/super.c         |    4 +-
  lib/ext2fs/bb_inode.c  |   10 +++---
  lib/ext2fs/block.c     |   71 
++++++++++++++++++++++++++++++-------------------
  lib/ext2fs/bmap.c      |   10 +++---
  lib/ext2fs/ext2fs.h    |    4 +-
  lib/ext2fs/ind_block.c |    4 +-
  lib/ext2fs/inode.c     |    4 +-
  misc/e2image.c         |    2 -
  9 files changed, 64 insertions(+), 47 deletions(-)



--------------010403050806050103060108
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="09-indirect-block-type"
Content-Disposition: inline;
 filename="09-indirect-block-type"

Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/block.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/block.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/block.c	2007-06-21 13:16:45.000000000 +0200
@@ -305,7 +305,7 @@ static int block_iterate_ind(blk_t *ind_
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	__u32	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
@@ -330,33 +330,37 @@ static int block_iterate_ind(blk_t *ind_
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->ind_buf;
+	block_nr = (__u32 *) ctx->ind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			blk_t b = *block_nr;
+			flags = (*ctx->func)(ctx->fs, &b, ctx->bcount,
 					     *ind_block, offset, 
 					     ctx->priv_data);
+			*block_nr = b;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	} else {
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
+			blk_t b = *block_nr;
 			if (*block_nr == 0)
 				continue;
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			flags = (*ctx->func)(ctx->fs, &b, ctx->bcount,
 					     *ind_block, offset, 
 					     ctx->priv_data);
+			*block_nr = b;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -379,7 +383,7 @@ static int block_iterate_dind(blk_t *din
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	__u32	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
@@ -404,35 +408,39 @@ static int block_iterate_dind(blk_t *din
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->dind_buf;
+	block_nr = (__u32 *) ctx->dind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, block_nr++) {
-			flags = block_iterate_ind(block_nr,
+			blk_t b = *block_nr;
+			flags = block_iterate_ind(&b,
 						  *dind_block, offset,
 						  ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	} else {
 		for (i = 0; i < limit; i++, block_nr++) {
+			blk_t b = *block_nr;
 			if (*block_nr == 0) {
 				ctx->bcount += limit;
 				continue;
 			}
-			flags = block_iterate_ind(block_nr,
+			flags = block_iterate_ind(&b,
 						  *dind_block, offset,
 						  ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -455,7 +463,7 @@ static int block_iterate_tind(blk_t *tin
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	__u32	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
@@ -480,35 +488,39 @@ static int block_iterate_tind(blk_t *tin
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->tind_buf;
+	block_nr = (__u32 *) ctx->tind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, block_nr++) {
-			flags = block_iterate_dind(block_nr,
+			blk_t b = *block_nr;
+			flags = block_iterate_dind(&b,
 						   *tind_block,
 						   offset, ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	} else {
 		for (i = 0; i < limit; i++, block_nr++) {
+			blk_t b = *block_nr;
 			if (*block_nr == 0) {
 				ctx->bcount += limit*limit;
 				continue;
 			}
-			flags = block_iterate_dind(block_nr,
+			flags = block_iterate_dind(&b,
 						   *tind_block,
 						   offset, ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(__u32);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -541,7 +553,7 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 {
 	int	i;
 	int	ret = 0;
-	blk_t	blocks[EXT2_N_BLOCKS];	/* directory data blocks */
+	__u32	blocks[EXT2_N_BLOCKS];	/* directory data blocks */
 	struct ext2_inode inode;
 	errcode_t	retval;
 	struct block_context ctx;
@@ -613,29 +625,34 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 	 */
 	for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
 		if (blocks[i] || (flags & BLOCK_FLAG_APPEND)) {
-			ret |= (*ctx.func)(fs, &blocks[i],
+			blk_t b = blocks[i];
+			ret |= (*ctx.func)(fs, &b,
 					    ctx.bcount, 0, i, priv_data);
+			blocks[i] = b;
 			if (ret & BLOCK_ABORT)
 				goto abort_exit;
 		}
 	}
 	if (*(blocks + EXT2_IND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_ind(blocks + EXT2_IND_BLOCK,
-					 0, EXT2_IND_BLOCK, &ctx);
+		blk_t b = *(blocks + EXT2_IND_BLOCK);
+		ret |= block_iterate_ind(&b, 0, EXT2_IND_BLOCK, &ctx);
+		*(blocks + EXT2_IND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	} else
 		ctx.bcount += limit;
 	if (*(blocks + EXT2_DIND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_dind(blocks + EXT2_DIND_BLOCK,
-					  0, EXT2_DIND_BLOCK, &ctx);
+		blk_t b = *(blocks + EXT2_DIND_BLOCK);
+		ret |= block_iterate_dind(&b, 0, EXT2_DIND_BLOCK, &ctx);
+		*(blocks + EXT2_DIND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	} else
 		ctx.bcount += limit * limit;
 	if (*(blocks + EXT2_TIND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_tind(blocks + EXT2_TIND_BLOCK,
-					  0, EXT2_TIND_BLOCK, &ctx);
+		blk_t b = *(blocks + EXT2_TIND_BLOCK);
+		ret |= block_iterate_tind(&b, 0, EXT2_TIND_BLOCK, &ctx);
+		*(blocks + EXT2_TIND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	}
@@ -643,7 +660,7 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 abort_exit:
 	if (ret & BLOCK_CHANGED) {
 		for (i=0; i < EXT2_N_BLOCKS; i++)
-			inode.i_block[i] = blocks[i];
+			inode.i_block[i] = (__u32)blocks[i];
 		retval = ext2fs_write_inode(fs, ino, &inode);
 		if (retval)
 			return retval;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ind_block.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ind_block.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ind_block.c	2007-06-21 13:16:45.000000000 +0200
@@ -34,7 +34,7 @@ errcode_t ext2fs_read_ind_block(ext2_fil
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_READ)) {
 		int	limit = fs->blocksize >> 2;
-		blk_t	*block_nr = (blk_t *)buf;
+		__u32	*block_nr = (__u32 *)buf;
 		int	i;
 
 		for (i = 0; i < limit; i++, block_nr++)
@@ -52,7 +52,7 @@ errcode_t ext2fs_write_ind_block(ext2_fi
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_WRITE)) {
 		int	limit = fs->blocksize >> 2;
-		blk_t	*block_nr = (blk_t *)buf;
+		__u32	*block_nr = (__u32 *)buf;
 		int	i;
 
 		for (i = 0; i < limit; i++, block_nr++)
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/ext2fs.h	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/ext2fs.h	2007-06-21 13:16:45.000000000 +0200
@@ -244,7 +244,7 @@ struct struct_ext2_filsys {
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
-	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
+	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, __u32 *blocks);
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
 	errcode_t (*write_bitmaps)(ext2_filsys fs);
 	errcode_t (*read_inode)(ext2_filsys fs, ext2_ino_t ino,
@@ -933,7 +933,7 @@ extern errcode_t ext2fs_write_inode(ext2
 			    struct ext2_inode * inode);
 extern errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 			    struct ext2_inode * inode);
-extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
+extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, __u32 *blocks);
 extern errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino);
 
 /* inode_io.c */
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/inode.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/inode.c	2007-06-21 13:16:45.000000000 +0200
@@ -107,7 +107,7 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 {
 	ext2_inode_scan	scan;
 	errcode_t	retval;
-	errcode_t (*save_get_blocks)(ext2_filsys f, ext2_ino_t ino, blk_t *blocks);
+	errcode_t (*save_get_blocks)(ext2_filsys f, ext2_ino_t ino, __u32 *blocks);
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -759,7 +759,7 @@ errcode_t ext2fs_write_new_inode(ext2_fi
 }
 
  
-errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks)
+errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, __u32 *blocks)
 {
 	struct ext2_inode	inode;
 	int			i;
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/pass1.c	2007-06-21 13:16:42.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/pass1.c	2007-06-21 13:16:45.000000000 +0200
@@ -2433,7 +2433,7 @@ static void mark_table_blocks(e2fsck_t c
  * the inode again.
  */
 static errcode_t pass1_get_blocks(ext2_filsys fs, ext2_ino_t ino,
-				  blk_t *blocks)
+				  __u32 *blocks)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 	int	i;
Index: e2fsprogs-1.39-tyt3-v7/misc/e2image.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/misc/e2image.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/misc/e2image.c	2007-06-21 13:16:45.000000000 +0200
@@ -165,7 +165,7 @@ static struct ext2_inode *stashed_inode;
 
 static errcode_t meta_get_blocks(ext2_filsys fs EXT2FS_ATTR((unused)), 
 				 ext2_ino_t ino,
-				 blk_t *blocks)
+				 __u32 *blocks)
 {
 	int	i;
 	
Index: e2fsprogs-1.39-tyt3-v7/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/e2fsck/super.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/e2fsck/super.c	2007-06-21 13:16:45.000000000 +0200
@@ -114,7 +114,7 @@ static int release_inode_block(ext2_fils
 		 */
 		if (blockcnt < 0) {
 			int	i, limit;
-			blk_t	*bp;
+			__u32	*bp;
 			
 			pb->errcode = io_channel_read_blk(fs->io, blk, 1,
 							pb->buf);
@@ -122,7 +122,7 @@ static int release_inode_block(ext2_fils
 				goto return_abort;
 
 			limit = fs->blocksize >> 2;
-			for (i = 0, bp = (blk_t *) pb->buf;
+			for (i = 0, bp = (__u32 *) pb->buf;
 			     i < limit;	 i++, bp++)
 				if (*bp)
 					return 0;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bb_inode.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bb_inode.c	2007-06-21 13:15:41.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bb_inode.c	2007-06-21 13:16:45.000000000 +0200
@@ -33,7 +33,7 @@
 struct set_badblock_record {
 	ext2_badblocks_iterate	bb_iter;
 	int		bad_block_count;
-	blk_t		*ind_blocks;
+	__u32		*ind_blocks;
 	int		max_ind_blocks;
 	int		ind_blocks_size;
 	int		ind_blocks_ptr;
@@ -68,11 +68,11 @@ errcode_t ext2fs_update_bb_inode(ext2_fi
 	rec.bad_block_count = 0;
 	rec.ind_blocks_size = rec.ind_blocks_ptr = 0;
 	rec.max_ind_blocks = 10;
-	retval = ext2fs_get_mem(rec.max_ind_blocks * sizeof(blk_t),
+	retval = ext2fs_get_mem(rec.max_ind_blocks * sizeof(__u32),
 				&rec.ind_blocks);
 	if (retval)
 		return retval;
-	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(blk_t));
+	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(__u32));
 	retval = ext2fs_get_mem(fs->blocksize, &rec.block_buf);
 	if (retval)
 		goto cleanup;
@@ -174,10 +174,10 @@ static int clear_bad_block_proc(ext2_fil
 
 	if (blockcnt < 0) {
 		if (rec->ind_blocks_size >= rec->max_ind_blocks) {
-			old_size = rec->max_ind_blocks * sizeof(blk_t);
+			old_size = rec->max_ind_blocks * sizeof(__u32);
 			rec->max_ind_blocks += 10;
 			retval = ext2fs_resize_mem(old_size, 
-				   rec->max_ind_blocks * sizeof(blk_t),
+				   rec->max_ind_blocks * sizeof(__u32),
 				   &rec->ind_blocks);
 			if (retval) {
 				rec->max_ind_blocks -= 10;
Index: e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39-tyt3-v7.orig/lib/ext2fs/bmap.c	2007-06-21 13:16:42.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v7/lib/ext2fs/bmap.c	2007-06-21 13:16:45.000000000 +0200
@@ -117,11 +117,11 @@ static _BMAP_INLINE_ errcode_t block_ind
 		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
 			b = ext2fs_swab32(b);
 #endif
-		((blk_t *) block_buf)[nr] = b;
+		((__u32 *) block_buf)[nr] = b;
 		return io_channel_write_blk(fs->io, ind, 1, block_buf);
 	}
 
-	b = ((blk_t *) block_buf)[nr];
+	b = ((__u32 *) block_buf)[nr];
 
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -130,7 +130,7 @@ static _BMAP_INLINE_ errcode_t block_ind
 #endif
 
 	if (!b && (flags & BMAP_ALLOC)) {
-		b = nr ? ((blk_t *) block_buf)[nr-1] : 0;
+		b = nr ? ((__u32 *) block_buf)[nr-1] : 0;
 		retval = ext2fs_alloc_block(fs, b,
 					    block_buf + fs->blocksize, &b);
 		if (retval)
@@ -139,10 +139,10 @@ static _BMAP_INLINE_ errcode_t block_ind
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
 		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-			((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
+			((__u32 *) block_buf)[nr] = ext2fs_swab32(b);
 		else
 #endif
-			((blk_t *) block_buf)[nr] = b;
+			((__u32 *) block_buf)[nr] = b;
 
 		retval = io_channel_write_blk(fs->io, ind, 1, block_buf);
 		if (retval)

--------------010403050806050103060108--
