From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/31] libext2fs: Badblocks should handle 48-bit block numbers
 correctly
Date: Mon, 30 Sep 2013 18:28:37 -0700
Message-ID: <20131001012837.28415.1138.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37932 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB2m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:28:42 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, the badblocks code assumes 32-bit block numbers.  This leads to
unfortunate results, because feeding a badblocks file to mke2fs with 64-bit
block numbers causes libext2fs to rip off the upper 32 bits of the block number
and then assign a truncated block number to the badblocks file.

This is just as well, since the code that writes to the bb inode doesn't know
about extents anyway.  Rather than continuing to open-code block map
manipulation, simply use existing library functions to truncate the old bb
inode, mark all badblocks in use, and then assign them to the badblocks file.
We can even use extents now.

(It's arguable that badblocks is a vestigial organ now, but perhaps someone is
using it?  I use it to stress-test disk block allocation, but I might just be
nutty.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/badblocks.c         |   28 ++---
 lib/ext2fs/bb_inode.c      |  251 +++++++++-----------------------------------
 lib/ext2fs/ext2fs.h        |    7 +
 lib/ext2fs/read_bb.c       |   10 +-
 lib/ext2fs/read_bb_file.c  |   39 ++++++-
 lib/ext2fs/tst_badblocks.c |   42 ++++---
 lib/ext2fs/tst_iscan.c     |    3 -
 lib/ext2fs/write_bb_file.c |    7 +
 misc/dumpe2fs.c            |    4 -
 misc/mke2fs.c              |   37 +++---
 misc/tune2fs.c             |    2 
 resize/resize2fs.c         |    4 -
 12 files changed, 164 insertions(+), 270 deletions(-)


diff --git a/e2fsck/badblocks.c b/e2fsck/badblocks.c
index 71b1c56..9a456d7 100644
--- a/e2fsck/badblocks.c
+++ b/e2fsck/badblocks.c
@@ -14,13 +14,14 @@
 #include <et/com_err.h>
 #include "e2fsck.h"
 
-static int check_bb_inode_blocks(ext2_filsys fs, blk_t *block_nr, int blockcnt,
-				 void *priv_data);
+static int check_bb_inode_blocks(ext2_filsys fs, blk64_t *block_nr,
+				 e2_blkcnt_t blockcnt, blk64_t ref_blk,
+				 int ref_offset, void *priv_data);
 
-
-static void invalid_block(ext2_filsys fs EXT2FS_ATTR((unused)), blk_t blk)
+static void invalid_block(ext2_filsys fs EXT2FS_ATTR((unused)), blk64_t blk,
+			  char *badmsg, void *privdata)
 {
-	printf(_("Bad block %u out of range; ignored.\n"), blk);
+	printf(_("Bad block %llu out of range; ignored.\n"), blk);
 	return;
 }
 
@@ -39,8 +40,8 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 	 * Make sure the bad block inode is sane.  If there are any
 	 * illegal blocks, clear them.
 	 */
-	retval = ext2fs_block_iterate(fs, EXT2_BAD_INO, 0, 0,
-				      check_bb_inode_blocks, 0);
+	retval = ext2fs_block_iterate3(fs, EXT2_BAD_INO, 0, 0,
+				       check_bb_inode_blocks, 0);
 	if (retval) {
 		com_err("ext2fs_block_iterate", retval,
 			_("while sanity checking the bad blocks inode"));
@@ -84,7 +85,7 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 			goto fatal;
 		}
 	}
-	retval = ext2fs_read_bb_FILE(fs, f, &bb_list, invalid_block);
+	retval = ext2fs_read_bb_FILE3(fs, f, &bb_list, NULL, invalid_block);
 	if (bad_blocks_file)
 		fclose(f);
 	else
@@ -115,10 +116,9 @@ fatal:
 
 }
 
-static int check_bb_inode_blocks(ext2_filsys fs,
-				 blk_t *block_nr,
-				 int blockcnt EXT2FS_ATTR((unused)),
-				 void *priv_data EXT2FS_ATTR((unused)))
+static int check_bb_inode_blocks(ext2_filsys fs, blk64_t *block_nr,
+				 e2_blkcnt_t blockcnt, blk64_t ref_blk,
+				 int ref_offset, void *priv_data)
 {
 	if (!*block_nr)
 		return 0;
@@ -128,8 +128,8 @@ static int check_bb_inode_blocks(ext2_filsys fs,
 	 */
 	if (*block_nr >= ext2fs_blocks_count(fs->super) ||
 	    *block_nr < fs->super->s_first_data_block) {
-		printf(_("Warning: illegal block %u found in bad block inode.  "
-			 "Cleared.\n"), *block_nr);
+		printf(_("Warning: illegal block %llu found in bad block "
+			 "inode.  Cleared.\n"), *block_nr);
 		*block_nr = 0;
 		return BLOCK_CHANGED;
 	}
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index 268eecf..1b168c4 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -31,26 +31,6 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-struct set_badblock_record {
-	ext2_badblocks_iterate	bb_iter;
-	int		bad_block_count;
-	blk_t		*ind_blocks;
-	int		max_ind_blocks;
-	int		ind_blocks_size;
-	int		ind_blocks_ptr;
-	char		*block_buf;
-	errcode_t	err;
-};
-
-static int set_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
-			      e2_blkcnt_t blockcnt,
-			      blk_t ref_block, int ref_offset,
-			      void *priv_data);
-static int clear_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
-				e2_blkcnt_t blockcnt,
-				blk_t ref_block, int ref_offset,
-				void *priv_data);
-
 /*
  * Given a bad blocks bitmap, update the bad blocks inode to reflect
  * the map.
@@ -58,210 +38,87 @@ static int clear_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
 errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 {
 	errcode_t			retval;
-	struct set_badblock_record 	rec;
+	ext2_badblocks_iterate		bb_iter;
 	struct ext2_inode		inode;
+	blk64_t				blk, bad_blocks = 0;
+	int				list_sz = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	if (!fs->block_map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
 
-	memset(&rec, 0, sizeof(rec));
-	rec.max_ind_blocks = 10;
-	retval = ext2fs_get_array(rec.max_ind_blocks, sizeof(blk_t),
-				&rec.ind_blocks);
-	if (retval)
-		return retval;
-	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(blk_t));
-	retval = ext2fs_get_mem(fs->blocksize, &rec.block_buf);
-	if (retval)
+	if (bb_list)
+		list_sz = ext2fs_badblocks_count(bb_list);
+
+	if (list_sz > 0 &&
+	    ext2fs_badblocks_get(bb_list, list_sz - 1) > ~0U &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		retval = EXT2_ET_INODE_NOT_EXTENT;
 		goto cleanup;
-	memset(rec.block_buf, 0, fs->blocksize);
-	rec.err = 0;
+	}
 
-	/*
-	 * First clear the old bad blocks (while saving the indirect blocks)
-	 */
-	retval = ext2fs_block_iterate2(fs, EXT2_BAD_INO,
-				       BLOCK_FLAG_DEPTH_TRAVERSE, 0,
-				       clear_bad_block_proc, &rec);
+	retval = ext2fs_read_inode_full(fs, EXT2_BAD_INO, &inode,
+					sizeof(inode));
 	if (retval)
 		goto cleanup;
-	if (rec.err) {
-		retval = rec.err;
+
+	/* Truncate the file */
+	retval = ext2fs_punch(fs, EXT2_BAD_INO, &inode, 0, 0, ~0ULL);
+	if (retval)
 		goto cleanup;
-	}
+	inode.i_size = 0;
+	inode.i_size_high = 0;
 
-	/*
-	 * Now set the bad blocks!
-	 *
-	 * First, mark the bad blocks as used.  This prevents a bad
-	 * block from being used as an indirecto block for the bad
-	 * block inode (!).
-	 */
-	if (bb_list) {
+	if (bb_list && list_sz > 0) {
+		/* Mark all bad blocks in use */
 		retval = ext2fs_badblocks_list_iterate_begin(bb_list,
-							     &rec.bb_iter);
+							     &bb_iter);
 		if (retval)
 			goto cleanup;
-		retval = ext2fs_block_iterate2(fs, EXT2_BAD_INO,
-					       BLOCK_FLAG_APPEND, 0,
-					       set_bad_block_proc, &rec);
-		ext2fs_badblocks_list_iterate_end(rec.bb_iter);
+
+		while (ext2fs_badblocks_list_iterate2(bb_iter, &blk))
+			ext2fs_block_alloc_stats2(fs, blk, +1);
+		ext2fs_badblocks_list_iterate_end(bb_iter);
+
+		/* Flip the extents flag if necessary */
+		memset(&inode.i_blocks, 0, EXT2_N_BLOCKS * sizeof(__u32));
+		if (ext2fs_badblocks_get(bb_list, list_sz - 1) > ~0U)
+			inode.i_flags |= EXT4_EXTENTS_FL;
+		else
+			inode.i_flags &= ~EXT4_EXTENTS_FL;
+
+		/* Set the bad blocks */
+		retval = ext2fs_badblocks_list_iterate_begin(bb_list,
+							     &bb_iter);
 		if (retval)
 			goto cleanup;
-		if (rec.err) {
-			retval = rec.err;
-			goto cleanup;
+
+		while (ext2fs_badblocks_list_iterate2(bb_iter, &blk)) {
+			retval = ext2fs_bmap2(fs, EXT2_BAD_INO, &inode, NULL,
+					      BMAP_SET | BMAP_ALLOC,
+					      bad_blocks++, NULL, &blk);
+			if (retval)
+				break;
 		}
+		ext2fs_badblocks_list_iterate_end(bb_iter);
+		if (retval)
+			goto cleanup;
 	}
 
-	/*
-	 * Update the bad block inode's mod time and block count
-	 * field.
-	 */
-	retval = ext2fs_read_inode(fs, EXT2_BAD_INO, &inode);
-	if (retval)
-		goto cleanup;
-
+	/* Update inode mtime */
 	inode.i_atime = inode.i_mtime = fs->now ? fs->now : time(0);
 	if (!inode.i_ctime)
 		inode.i_ctime = fs->now ? fs->now : time(0);
-	ext2fs_iblk_set(fs, &inode, rec.bad_block_count);
-	inode.i_size = rec.bad_block_count * fs->blocksize;
-
-	retval = ext2fs_write_inode(fs, EXT2_BAD_INO, &inode);
+	bad_blocks *= fs->blocksize;
+	inode.i_size = bad_blocks & 0xFFFFFFFF;
+	inode.i_size_high = bad_blocks >> 32;
+	retval = ext2fs_write_inode_full(fs, EXT2_BAD_INO, &inode,
+					 sizeof(inode));
 	if (retval)
 		goto cleanup;
 
 cleanup:
-	ext2fs_free_mem(&rec.ind_blocks);
-	ext2fs_free_mem(&rec.block_buf);
 	return retval;
 }
-
-/*
- * Helper function for update_bb_inode()
- *
- * Clear the bad blocks in the bad block inode, while saving the
- * indirect blocks.
- */
-#ifdef __TURBOC__
- #pragma argsused
-#endif
-static int clear_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
-				e2_blkcnt_t blockcnt,
-				blk_t ref_block EXT2FS_ATTR((unused)),
-				int ref_offset EXT2FS_ATTR((unused)),
-				void *priv_data)
-{
-	struct set_badblock_record *rec = (struct set_badblock_record *)
-		priv_data;
-	errcode_t	retval;
-	unsigned long 	old_size;
-
-	if (!*block_nr)
-		return 0;
-
-	/*
-	 * If the block number is outrageous, clear it and ignore it.
-	 */
-	if (*block_nr >= ext2fs_blocks_count(fs->super) ||
-	    *block_nr < fs->super->s_first_data_block) {
-		*block_nr = 0;
-		return BLOCK_CHANGED;
-	}
-
-	if (blockcnt < 0) {
-		if (rec->ind_blocks_size >= rec->max_ind_blocks) {
-			old_size = rec->max_ind_blocks * sizeof(blk_t);
-			rec->max_ind_blocks += 10;
-			retval = ext2fs_resize_mem(old_size,
-				   rec->max_ind_blocks * sizeof(blk_t),
-				   &rec->ind_blocks);
-			if (retval) {
-				rec->max_ind_blocks -= 10;
-				rec->err = retval;
-				return BLOCK_ABORT;
-			}
-		}
-		rec->ind_blocks[rec->ind_blocks_size++] = *block_nr;
-	}
-
-	/*
-	 * Mark the block as unused, and update accounting information
-	 */
-	ext2fs_block_alloc_stats2(fs, *block_nr, -1);
-
-	*block_nr = 0;
-	return BLOCK_CHANGED;
-}
-
-
-/*
- * Helper function for update_bb_inode()
- *
- * Set the block list in the bad block inode, using the supplied bitmap.
- */
-#ifdef __TURBOC__
- #pragma argsused
-#endif
-static int set_bad_block_proc(ext2_filsys fs, blk_t *block_nr,
-			      e2_blkcnt_t blockcnt,
-			      blk_t ref_block EXT2FS_ATTR((unused)),
-			      int ref_offset EXT2FS_ATTR((unused)),
-			      void *priv_data)
-{
-	struct set_badblock_record *rec = (struct set_badblock_record *)
-		priv_data;
-	errcode_t	retval;
-	blk_t		blk;
-
-	if (blockcnt >= 0) {
-		/*
-		 * Get the next bad block.
-		 */
-		if (!ext2fs_badblocks_list_iterate(rec->bb_iter, &blk))
-			return BLOCK_ABORT;
-		rec->bad_block_count++;
-	} else {
-		/*
-		 * An indirect block; fetch a block from the
-		 * previously used indirect block list.  The block
-		 * most be not marked as used; if so, get another one.
-		 * If we run out of reserved indirect blocks, allocate
-		 * a new one.
-		 */
-	retry:
-		if (rec->ind_blocks_ptr < rec->ind_blocks_size) {
-			blk = rec->ind_blocks[rec->ind_blocks_ptr++];
-			if (ext2fs_test_block_bitmap2(fs->block_map, blk))
-				goto retry;
-		} else {
-			retval = ext2fs_new_block(fs, 0, 0, &blk);
-			if (retval) {
-				rec->err = retval;
-				return BLOCK_ABORT;
-			}
-		}
-		retval = io_channel_write_blk64(fs->io, blk, 1, rec->block_buf);
-		if (retval) {
-			rec->err = retval;
-			return BLOCK_ABORT;
-		}
-	}
-
-	/*
-	 * Update block counts
-	 */
-	ext2fs_block_alloc_stats2(fs, blk, +1);
-
-	*block_nr = blk;
-	return BLOCK_CHANGED;
-}
-
-
-
-
-
-
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b4ba421..847b33c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1486,6 +1486,13 @@ extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
 
 /* read_bb_file.c */
+extern errcode_t ext2fs_read_bb_FILE3(ext2_filsys fs, FILE *f,
+				      ext2_badblocks_list *bb_list,
+				      void *priv_data,
+				      void (*invalid)(ext2_filsys fs,
+						      blk64_t blk,
+						      char *badstr,
+						      void *priv_data));
 extern errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
 				      ext2_badblocks_list *bb_list,
 				      void *priv_data,
diff --git a/lib/ext2fs/read_bb.c b/lib/ext2fs/read_bb.c
index b5a0d7b..348d5a3 100644
--- a/lib/ext2fs/read_bb.c
+++ b/lib/ext2fs/read_bb.c
@@ -38,9 +38,9 @@ struct read_bb_record {
 #ifdef __TURBOC__
  #pragma argsused
 #endif
-static int mark_bad_block(ext2_filsys fs, blk_t *block_nr,
+static int mark_bad_block(ext2_filsys fs, blk64_t *block_nr,
 			  e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
-			  blk_t ref_block EXT2FS_ATTR((unused)),
+			  blk64_t ref_block EXT2FS_ATTR((unused)),
 			  int ref_offset EXT2FS_ATTR((unused)),
 			  void *priv_data)
 {
@@ -53,7 +53,7 @@ static int mark_bad_block(ext2_filsys fs, blk_t *block_nr,
 	    (*block_nr >= ext2fs_blocks_count(fs->super)))
 		return 0;	/* Ignore illegal blocks */
 
-	rb->err = ext2fs_badblocks_list_add(rb->bb_list, *block_nr);
+	rb->err = ext2fs_badblocks_list_add2(rb->bb_list, *block_nr);
 	if (rb->err)
 		return BLOCK_ABORT;
 	return 0;
@@ -67,7 +67,7 @@ errcode_t ext2fs_read_bb_inode(ext2_filsys fs, ext2_badblocks_list *bb_list)
 	errcode_t	retval;
 	struct read_bb_record rb;
 	struct ext2_inode inode;
-	blk_t	numblocks;
+	blk64_t	numblocks;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -92,7 +92,7 @@ errcode_t ext2fs_read_bb_inode(ext2_filsys fs, ext2_badblocks_list *bb_list)
 
 	rb.bb_list = *bb_list;
 	rb.err = 0;
-	retval = ext2fs_block_iterate2(fs, EXT2_BAD_INO, BLOCK_FLAG_READ_ONLY,
+	retval = ext2fs_block_iterate3(fs, EXT2_BAD_INO, BLOCK_FLAG_READ_ONLY,
 				       0, mark_bad_block, &rb);
 	if (retval)
 		return retval;
diff --git a/lib/ext2fs/read_bb_file.c b/lib/ext2fs/read_bb_file.c
index 7d7bb7a..44f1cde 100644
--- a/lib/ext2fs/read_bb_file.c
+++ b/lib/ext2fs/read_bb_file.c
@@ -30,16 +30,16 @@
 /*
  * Reads a list of bad blocks from  a FILE *
  */
-errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
+errcode_t ext2fs_read_bb_FILE3(ext2_filsys fs, FILE *f,
 			       ext2_badblocks_list *bb_list,
 			       void *priv_data,
 			       void (*invalid)(ext2_filsys fs,
-					       blk_t blk,
+					       blk64_t blk,
 					       char *badstr,
 					       void *priv_data))
 {
 	errcode_t	retval;
-	blk_t		blockno;
+	blk64_t		blockno;
 	int		count;
 	char		buf[128];
 
@@ -55,7 +55,7 @@ errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
 	while (!feof (f)) {
 		if (fgets(buf, sizeof(buf), f) == NULL)
 			break;
-		count = sscanf(buf, "%u", &blockno);
+		count = sscanf(buf, "%llu", &blockno);
 		if (count <= 0)
 			continue;
 		if (fs &&
@@ -65,13 +65,42 @@ errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
 				(invalid)(fs, blockno, buf, priv_data);
 			continue;
 		}
-		retval = ext2fs_badblocks_list_add(*bb_list, blockno);
+		retval = ext2fs_badblocks_list_add2(*bb_list, blockno);
 		if (retval)
 			return retval;
 	}
 	return 0;
 }
 
+struct read_helper2_data {
+	void (*invalid)(ext2_filsys fs, blk_t blk, char *badstr,
+			void *priv_data);
+	void *priv_data;
+};
+
+static void read_helper2(ext2_filsys fs, blk64_t blk, char *badstr,
+			 void *priv_data)
+{
+	struct read_helper2_data *d = priv_data;
+	if (d->invalid)
+		d->invalid(fs, blk, badstr, d->priv_data);
+}
+
+errcode_t ext2fs_read_bb_FILE2(ext2_filsys fs, FILE *f,
+			       ext2_badblocks_list *bb_list,
+			       void *priv_data,
+			       void (*invalid)(ext2_filsys fs,
+					       blk_t blk,
+					       char *badstr,
+					       void *priv_data))
+{
+	struct read_helper2_data d;
+
+	d.invalid = invalid;
+	d.priv_data = priv_data;
+	return ext2fs_read_bb_FILE3(fs, f, bb_list, &d, read_helper2);
+}
+
 struct compat_struct {
 	void (*invalid)(ext2_filsys, blk_t);
 };
diff --git a/lib/ext2fs/tst_badblocks.c b/lib/ext2fs/tst_badblocks.c
index 3b39ef1..40168b9 100644
--- a/lib/ext2fs/tst_badblocks.c
+++ b/lib/ext2fs/tst_badblocks.c
@@ -29,11 +29,11 @@
 #define ADD_BLK	0x0001
 #define DEL_BLK	0x0002
 
-blk_t test1[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0 };
-blk_t test2[] = { 11, 10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 1 };
-blk_t test3[] = { 3, 1, 4, 5, 9, 2, 7, 10, 5, 6, 10, 8, 0 };
-blk_t test4[] = { 20, 50, 12, 17, 13, 2, 66, 23, 56, 0 };
-blk_t test4a[] = {
+blk64_t test1[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0 };
+blk64_t test2[] = { 11, 10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 1 };
+blk64_t test3[] = { 3, 1, 4, 5, 9, 2, 7, 10, 5, 6, 10, 8, 0 };
+blk64_t test4[] = { 20, 50, 12, 17, 13, 2, 66, 23, 56, 0 };
+blk64_t test4a[] = {
  	20, 1,
 	50, 1,
 	3, 0,
@@ -48,8 +48,8 @@ blk_t test4a[] = {
 	45, 0,
 	66, 1,
 	0 };
-blk_t test5[] = { 31, 20, 17, 51, 23, 1, 56, 57, 0 };
-blk_t test5a[] = {
+blk64_t test5[] = { 31, 20, 17, 51, 23, 1, 56, 57, 0 };
+blk64_t test5a[] = {
 	50, ADD_BLK,
 	51, DEL_BLK,
 	57, DEL_BLK,
@@ -66,7 +66,7 @@ blk_t test5a[] = {
 static int test_fail = 0;
 static int test_expected_fail = 0;
 
-static errcode_t create_test_list(blk_t *vec, badblocks_list *ret)
+static errcode_t create_test_list(blk64_t *vec, badblocks_list *ret)
 {
 	errcode_t	retval;
 	badblocks_list	bb;
@@ -78,7 +78,7 @@ static errcode_t create_test_list(blk_t *vec, badblocks_list *ret)
 		return retval;
 	}
 	for (i=0; vec[i]; i++) {
-		retval = ext2fs_badblocks_list_add(bb, vec[i]);
+		retval = ext2fs_badblocks_list_add2(bb, vec[i]);
 		if (retval) {
 			com_err("create_test_list", retval,
 				"while adding test vector %d", i);
@@ -94,7 +94,7 @@ static void print_list(badblocks_list bb, int verify)
 {
 	errcode_t	retval;
 	badblocks_iterate	iter;
-	blk_t			blk;
+	blk64_t			blk;
 	int			i, ok;
 
 	retval = ext2fs_badblocks_list_iterate_begin(bb, &iter);
@@ -103,7 +103,7 @@ static void print_list(badblocks_list bb, int verify)
 		return;
 	}
 	ok = i = 1;
-	while (ext2fs_badblocks_list_iterate(iter, &blk)) {
+	while (ext2fs_badblocks_list_iterate2(iter, &blk)) {
 		printf("%u ", blk);
 		if (i++ != blk)
 			ok = 0;
@@ -119,12 +119,12 @@ static void print_list(badblocks_list bb, int verify)
 	}
 }
 
-static void validate_test_seq(badblocks_list bb, blk_t *vec)
+static void validate_test_seq(badblocks_list bb, blk64_t *vec)
 {
 	int	i, match, ok;
 
 	for (i = 0; vec[i]; i += 2) {
-		match = ext2fs_badblocks_list_test(bb, vec[i]);
+		match = ext2fs_badblocks_list_test2(bb, vec[i]);
 		if (match == vec[i+1])
 			ok = 1;
 		else {
@@ -137,15 +137,15 @@ static void validate_test_seq(badblocks_list bb, blk_t *vec)
 	}
 }
 
-static void do_test_seq(badblocks_list bb, blk_t *vec)
+static void do_test_seq(badblocks_list bb, blk64_t *vec)
 {
 	int	i, match;
 
 	for (i = 0; vec[i]; i += 2) {
 		switch (vec[i+1]) {
 		case ADD_BLK:
-			ext2fs_badblocks_list_add(bb, vec[i]);
-			match = ext2fs_badblocks_list_test(bb, vec[i]);
+			ext2fs_badblocks_list_add2(bb, vec[i]);
+			match = ext2fs_badblocks_list_test2(bb, vec[i]);
 			printf("Adding block %u --- now %s\n", vec[i],
 			       match ? "present" : "absent");
 			if (!match) {
@@ -154,10 +154,10 @@ static void do_test_seq(badblocks_list bb, blk_t *vec)
 			}
 			break;
 		case DEL_BLK:
-			ext2fs_badblocks_list_del(bb, vec[i]);
-			match = ext2fs_badblocks_list_test(bb, vec[i]);
+			ext2fs_badblocks_list_del2(bb, vec[i]);
+			match = ext2fs_badblocks_list_test2(bb, vec[i]);
 			printf("Removing block %u --- now %s\n", vec[i],
-			       ext2fs_badblocks_list_test(bb, vec[i]) ?
+			       ext2fs_badblocks_list_test2(bb, vec[i]) ?
 			       "present" : "absent");
 			if (match) {
 				printf("FAILURE!\n");
@@ -188,7 +188,7 @@ int file_test(badblocks_list bb)
 	}
 
 	rewind(f);
-	retval = ext2fs_read_bb_FILE2(0, f, &new_bb, 0, 0);
+	retval = ext2fs_read_bb_FILE3(0, f, &new_bb, 0, 0);
 	if (retval) {
 		com_err("file_test", retval, "while reading bad blocks");
 		return 1;
@@ -204,7 +204,7 @@ int file_test(badblocks_list bb)
 	return 0;
 }
 
-static void invalid_proc(ext2_filsys fs, blk_t blk)
+static void invalid_proc(ext2_filsys fs, blk64_t blk)
 {
 	if (blk == 34500) {
 		printf("Expected invalid block\n");
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index a95296c..3013d41 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -124,7 +124,8 @@ static void setup(void)
 		exit(1);
 	}
 	for (i=0; test_vec[i]; i++) {
-		retval = ext2fs_badblocks_list_add(test_badblocks, test_vec[i]);
+		retval = ext2fs_badblocks_list_add2(test_badblocks,
+						    test_vec[i]);
 		if (retval) {
 			com_err("setup", retval,
 				"while adding test vector %d", i);
diff --git a/lib/ext2fs/write_bb_file.c b/lib/ext2fs/write_bb_file.c
index 5834340..aeeee82 100644
--- a/lib/ext2fs/write_bb_file.c
+++ b/lib/ext2fs/write_bb_file.c
@@ -20,16 +20,15 @@ errcode_t ext2fs_write_bb_FILE(ext2_badblocks_list bb_list,
 			       FILE *f)
 {
 	badblocks_iterate	bb_iter;
-	blk_t			blk;
+	blk64_t			blk;
 	errcode_t		retval;
 
 	retval = ext2fs_badblocks_list_iterate_begin(bb_list, &bb_iter);
 	if (retval)
 		return retval;
 
-	while (ext2fs_badblocks_list_iterate(bb_iter, &blk)) {
-		fprintf(f, "%u\n", blk);
-	}
+	while (ext2fs_badblocks_list_iterate2(bb_iter, &blk))
+		fprintf(f, "%llu\n", blk);
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 	return 0;
 }
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b139977..3035b62 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -293,7 +293,7 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 {
 	badblocks_list		bb_list = 0;
 	badblocks_iterate	bb_iter;
-	blk_t			blk;
+	blk64_t			blk;
 	errcode_t		retval;
 	const char		*header, *fmt;
 
@@ -314,7 +314,7 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 		header =  _("Bad blocks: %u");
 		fmt = ", %u";
 	}
-	while (ext2fs_badblocks_list_iterate(bb_iter, &blk)) {
+	while (ext2fs_badblocks_list_iterate2(bb_iter, &blk)) {
 		printf(header ? header : fmt, blk);
 		header = 0;
 	}
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d96f156..d8bd5ed 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -175,9 +175,10 @@ static int parse_version_number(const char *s)
 /*
  * Helper function for read_bb_file and test_disk
  */
-static void invalid_block(ext2_filsys fs EXT2FS_ATTR((unused)), blk_t blk)
+static void invalid_block(ext2_filsys fs EXT2FS_ATTR((unused)), blk64_t blk,
+			  char *badstr, void *private_data)
 {
-	fprintf(stderr, _("Bad block %u out of range; ignored.\n"), blk);
+	fprintf(stderr, _("Bad block %llu out of range; ignored.\n"), blk);
 	return;
 }
 
@@ -196,7 +197,7 @@ static void read_bb_file(ext2_filsys fs, badblocks_list *bb_list,
 			_("while trying to open %s"), bad_blocks_file);
 		exit(1);
 	}
-	retval = ext2fs_read_bb_FILE(fs, f, bb_list, invalid_block);
+	retval = ext2fs_read_bb_FILE3(fs, f, bb_list, NULL, invalid_block);
 	fclose (f);
 	if (retval) {
 		com_err("ext2fs_read_bb_FILE", retval,
@@ -225,7 +226,7 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
 			_("while trying to run '%s'"), buf);
 		exit(1);
 	}
-	retval = ext2fs_read_bb_FILE(fs, f, bb_list, invalid_block);
+	retval = ext2fs_read_bb_FILE3(fs, f, bb_list, NULL, invalid_block);
 	pclose(f);
 	if (retval) {
 		com_err("ext2fs_read_bb_FILE", retval,
@@ -237,13 +238,13 @@ static void test_disk(ext2_filsys fs, badblocks_list *bb_list)
 static void handle_bad_blocks(ext2_filsys fs, badblocks_list bb_list)
 {
 	dgrp_t			i;
-	blk_t			j;
-	unsigned 		must_be_good;
-	blk_t			blk;
+	blk64_t			j;
+	blk64_t			must_be_good;
+	blk64_t			blk;
 	badblocks_iterate	bb_iter;
 	errcode_t		retval;
-	blk_t			group_block;
-	int			group;
+	blk64_t			group_block;
+	dgrp_t			group;
 	int			group_bad;
 
 	if (!bb_list)
@@ -254,12 +255,12 @@ static void handle_bad_blocks(ext2_filsys fs, badblocks_list bb_list)
 	 * good; if not, abort.
 	 */
 	must_be_good = fs->super->s_first_data_block + 1 + fs->desc_blocks;
-	for (i = fs->super->s_first_data_block; i <= must_be_good; i++) {
-		if (ext2fs_badblocks_list_test(bb_list, i)) {
-			fprintf(stderr, _("Block %d in primary "
-				"superblock/group descriptor area bad.\n"), i);
-			fprintf(stderr, _("Blocks %u through %u must be good "
-				"in order to build a filesystem.\n"),
+	for (j = fs->super->s_first_data_block; j <= must_be_good; j++) {
+		if (ext2fs_badblocks_list_test2(bb_list, j)) {
+			fprintf(stderr, _("Block %llu in primary "
+				"superblock/group descriptor area bad.\n"), j);
+			fprintf(stderr, _("Blocks %u through %llu must be "
+				"good in order to build a filesystem.\n"),
 				fs->super->s_first_data_block, must_be_good);
 			fputs(_("Aborting....\n"), stderr);
 			exit(1);
@@ -277,11 +278,11 @@ static void handle_bad_blocks(ext2_filsys fs, badblocks_list bb_list)
 	for (i = 1; i < fs->group_desc_count; i++) {
 		group_bad = 0;
 		for (j=0; j < fs->desc_blocks+1; j++) {
-			if (ext2fs_badblocks_list_test(bb_list,
+			if (ext2fs_badblocks_list_test2(bb_list,
 						       group_block + j)) {
 				if (!group_bad)
 					fprintf(stderr,
-_("Warning: the backup superblock/group descriptors at block %u contain\n"
+_("Warning: the backup superblock/group descriptors at block %llu contain\n"
 "	bad blocks.\n\n"),
 						group_block);
 				group_bad++;
@@ -303,7 +304,7 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 			_("while marking bad blocks as used"));
 		exit(1);
 	}
-	while (ext2fs_badblocks_list_iterate(bb_iter, &blk))
+	while (ext2fs_badblocks_list_iterate2(bb_iter, &blk))
 		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, blk));
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 }
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 60d1378..835f364 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1812,7 +1812,7 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 				/*
 				 * IF the block is a bad block we fail
 				 */
-				if (ext2fs_badblocks_list_test(bb_list, j)) {
+				if (ext2fs_badblocks_list_test2(bb_list, j)) {
 					ext2fs_badblocks_list_free(bb_list);
 					return ENOSPC;
 				}
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 76d7aa6..e9c207b 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1240,8 +1240,8 @@ static errcode_t block_mover(ext2_resize_t rfs)
 			continue;
 		if (!ext2fs_test_block_bitmap2(rfs->move_blocks, blk))
 			continue;
-		if (ext2fs_badblocks_list_test(badblock_list, blk)) {
-			ext2fs_badblocks_list_del(badblock_list, blk);
+		if (ext2fs_badblocks_list_test2(badblock_list, blk)) {
+			ext2fs_badblocks_list_del2(badblock_list, blk);
 			bb_modified++;
 			continue;
 		}

