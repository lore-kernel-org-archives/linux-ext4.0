From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/39] libext2fs/e2fsck: refactor everyone who writes zero
 blocks to disk
Date: Sat, 25 Oct 2014 13:58:57 -0700
Message-ID: <20141025205857.532.33229.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44135 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJYU7W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:59:22 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert all call sites that write zero blocks to disk to use
ext2fs_zero_blocks2() since it can use Linux's zero out feature to do
the writes more quickly.  Reclaim the zero buffer at freefs time and
make the write-zeroes fallback use a larger buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.h        |    2 -
 e2fsck/pass1.c         |   13 +++++---
 e2fsck/pass3.c         |   13 ++------
 e2fsck/util.c          |   53 ----------------------------------
 lib/ext2fs/alloc.c     |   14 ++-------
 lib/ext2fs/expanddir.c |   13 ++------
 lib/ext2fs/ext2fs.h    |    3 ++
 lib/ext2fs/freefs.c    |    1 +
 lib/ext2fs/mkjournal.c |   75 +++++++++++++++++++++++++++++++++++-------------
 misc/mke2fs.c          |    2 -
 resize/resize2fs.c     |   25 ++++++----------
 11 files changed, 84 insertions(+), 130 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index b2654ef..e359515 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -544,8 +544,6 @@ extern void e2fsck_read_bitmaps(e2fsck_t ctx);
 extern void e2fsck_write_bitmaps(e2fsck_t ctx);
 extern void preenhalt(e2fsck_t ctx);
 extern char *string_copy(e2fsck_t ctx, const char *str, int len);
-extern errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
-				    blk_t *ret_blk, int *ret_count);
 extern int fs_proc_check(const char *fs_name);
 extern int check_for_modules(const char *fs_name);
 #ifdef RESOURCE_TRACK
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index d4760ef..a963849 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3576,12 +3576,15 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, dgrp_t group,
 				   old_block + i, 1, buf);
 			if (pctx.errcode)
 				fix_problem(ctx, PR_1_RELOC_READ_ERR, &pctx);
-		} else
-			memset(buf, 0, fs->blocksize);
+			pctx.blk = (*new_block) + i;
+			pctx.errcode = io_channel_write_blk64(fs->io, pctx.blk,
+							      1, buf);
+		} else {
+			pctx.blk = (*new_block) + i;
+			pctx.errcode = ext2fs_zero_blocks2(fs, pctx.blk, 1,
+							   NULL, NULL);
+		}
 
-		pctx.blk = (*new_block) + i;
-		pctx.errcode = io_channel_write_blk64(fs->io, pctx.blk,
-					      1, buf);
 		if (pctx.errcode)
 			fix_problem(ctx, PR_1_RELOC_WRITE_ERR, &pctx);
 	}
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index f03c7ae..2d94ece 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -809,20 +809,13 @@ static int expand_dir_proc(ext2_filsys fs,
 		es->num--;
 		retval = ext2fs_write_dir_block4(fs, new_blk, block, 0,
 						 es->dir);
-	} else {
-		retval = ext2fs_get_mem(fs->blocksize, &block);
-		if (retval) {
-			es->err = retval;
-			return BLOCK_ABORT;
-		}
-		memset(block, 0, fs->blocksize);
-		retval = io_channel_write_blk64(fs->io, new_blk, 1, block);
-	}
+		ext2fs_free_mem(&block);
+	} else
+		retval = ext2fs_zero_blocks2(fs, new_blk, 1, NULL, NULL);
 	if (retval) {
 		es->err = retval;
 		return BLOCK_ABORT;
 	}
-	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, new_blk);
 
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 74f20062..723dafb 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -612,59 +612,6 @@ int ext2_file_type(unsigned int mode)
 	return 0;
 }
 
-#define STRIDE_LENGTH 8
-/*
- * Helper function which zeros out _num_ blocks starting at _blk_.  In
- * case of an error, the details of the error is returned via _ret_blk_
- * and _ret_count_ if they are non-NULL pointers.  Returns 0 on
- * success, and an error code on an error.
- *
- * As a special case, if the first argument is NULL, then it will
- * attempt to free the static zeroizing buffer.  (This is to keep
- * programs that check for memory leaks happy.)
- */
-errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
-			     blk_t *ret_blk, int *ret_count)
-{
-	int		j, count;
-	static char	*buf;
-	errcode_t	retval;
-
-	/* If fs is null, clean up the static buffer and return */
-	if (!fs) {
-		if (buf) {
-			free(buf);
-			buf = 0;
-		}
-		return 0;
-	}
-	/* Allocate the zeroizing buffer if necessary */
-	if (!buf) {
-		buf = malloc(fs->blocksize * STRIDE_LENGTH);
-		if (!buf) {
-			com_err("malloc", ENOMEM, "%s",
-				_("while allocating zeroizing buffer"));
-			exit(1);
-		}
-		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
-	}
-	/* OK, do the write loop */
-	for (j = 0; j < num; j += STRIDE_LENGTH, blk += STRIDE_LENGTH) {
-		count = num - j;
-		if (count > STRIDE_LENGTH)
-			count = STRIDE_LENGTH;
-		retval = io_channel_write_blk64(fs->io, blk, count, buf);
-		if (retval) {
-			if (ret_count)
-				*ret_count = count;
-			if (ret_blk)
-				*ret_blk = blk;
-			return retval;
-		}
-	}
-	return 0;
-}
-
 /*
  * Check to see if a filesystem is in /proc/filesystems.
  * Returns 1 if found, 0 if not
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index d1c1a84..82af18e 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -198,15 +198,9 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 {
 	errcode_t	retval;
 	blk64_t		block;
-	char		*buf = 0;
 
-	if (!block_buf) {
-		retval = ext2fs_get_mem(fs->blocksize, &buf);
-		if (retval)
-			return retval;
-		block_buf = buf;
-	}
-	memset(block_buf, 0, fs->blocksize);
+	if (block_buf)
+		memset(block_buf, 0, fs->blocksize);
 
 	if (fs->get_alloc_block) {
 		retval = (fs->get_alloc_block)(fs, goal, &block);
@@ -224,7 +218,7 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 			goto fail;
 	}
 
-	retval = io_channel_write_blk64(fs->io, block, 1, block_buf);
+	retval = ext2fs_zero_blocks3(fs, block, 1, NULL, NULL, block_buf);
 	if (retval)
 		goto fail;
 
@@ -232,8 +226,6 @@ errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
 	*ret = block;
 
 fail:
-	if (buf)
-		ext2fs_free_mem(&buf);
 	return retval;
 }
 
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index d0f7287..ecc13ae 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -67,22 +67,15 @@ static int expand_dir_proc(ext2_filsys	fs,
 		es->done = 1;
 		retval = ext2fs_write_dir_block4(fs, new_blk, block, 0,
 						 es->dir);
-	} else {
-		retval = ext2fs_get_mem(fs->blocksize, &block);
-		if (retval) {
-			es->err = retval;
-			return BLOCK_ABORT;
-		}
-		memset(block, 0, fs->blocksize);
-		retval = io_channel_write_blk64(fs->io, new_blk, 1, block);
-	}
+		ext2fs_free_mem(&block);
+	} else
+		retval = ext2fs_zero_blocks2(fs, new_blk, 1, NULL, NULL);
 	if (blockcnt >= 0)
 		es->goal = new_blk;
 	if (retval) {
 		es->err = retval;
 		return BLOCK_ABORT;
 	}
-	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
 
 	if (es->done)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 689f6a6..5ecaa85 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1504,6 +1504,9 @@ extern errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 				    blk_t *ret_blk, int *ret_count);
 extern errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 				     blk64_t *ret_blk, int *ret_count);
+extern errcode_t ext2fs_zero_blocks3(ext2_filsys fs, blk64_t blk, int num,
+				     blk64_t *ret_blk, int *ret_count,
+				     const void *block_buf);
 extern errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 						  __u32 num_blocks, int flags,
 						  char  **ret_jsb);
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 89a157b..ea9742e 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -61,6 +61,7 @@ void ext2fs_free(ext2_filsys fs)
 
 	fs->magic = 0;
 
+	ext2fs_zero_blocks2(NULL, 0, 0, NULL, NULL);
 	ext2fs_free_mem(&fs);
 }
 
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 5be425c..2cd7ca5 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -148,12 +148,14 @@ errfree:
  * attempt to free the static zeroizing buffer.  (This is to keep
  * programs that check for memory leaks happy.)
  */
-#define STRIDE_LENGTH 8
-errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
-			      blk64_t *ret_blk, int *ret_count)
+#define MAX_STRIDE_LENGTH (4194304 / fs->blocksize)
+errcode_t ext2fs_zero_blocks3(ext2_filsys fs, blk64_t blk, int num,
+			      blk64_t *ret_blk, int *ret_count,
+			      const void *block_buf)
 {
 	int		j, count;
-	static char	*buf;
+	static void	*buf;
+	static unsigned	stride_length;
 	errcode_t	retval;
 
 	/* If fs is null, clean up the static buffer and return */
@@ -165,29 +167,56 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 		return 0;
 	}
 
+	/* Deal with zeroing less than 1 block */
+	if (num <= 0)
+		return 0;
+
 	/* Try a zero out command, if supported */
 	retval = io_channel_zeroout(fs->io, blk, num);
 	if (retval == 0)
 		return 0;
 
+	/* If the user gave us a buffer, write that out */
+	if (block_buf) {
+		retval = io_channel_write_blk64(fs->io, blk, num, block_buf);
+		if (retval) {
+			if (ret_count)
+				*ret_count = num;
+			if (ret_blk)
+				*ret_blk = blk;
+		}
+
+		return retval;
+	}
+
 	/* Allocate the zeroizing buffer if necessary */
-	if (!buf) {
-		buf = malloc(fs->blocksize * STRIDE_LENGTH);
-		if (!buf)
-			return ENOMEM;
-		memset(buf, 0, fs->blocksize * STRIDE_LENGTH);
+	if (num > stride_length) {
+		void *p;
+		unsigned new_stride = num;
+
+		if (new_stride > MAX_STRIDE_LENGTH)
+			new_stride = MAX_STRIDE_LENGTH;
+		if (new_stride == stride_length)
+			goto skip_alloc;
+		p = realloc(buf, fs->blocksize * new_stride);
+		if (!p)
+			return EXT2_ET_NO_MEMORY;
+		buf = p;
+		stride_length = new_stride;
+		memset(buf, 0, fs->blocksize * stride_length);
 	}
+skip_alloc:
 	/* OK, do the write loop */
 	j=0;
 	while (j < num) {
-		if (blk % STRIDE_LENGTH) {
-			count = STRIDE_LENGTH - (blk % STRIDE_LENGTH);
+		if (blk % stride_length) {
+			count = stride_length - (blk % stride_length);
 			if (count > (num - j))
 				count = num - j;
 		} else {
 			count = num - j;
-			if (count > STRIDE_LENGTH)
-				count = STRIDE_LENGTH;
+			if (count > stride_length)
+				count = stride_length;
 		}
 		retval = io_channel_write_blk64(fs->io, blk, count, buf);
 		if (retval) {
@@ -202,6 +231,12 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 	return 0;
 }
 
+errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
+			      blk64_t *ret_blk, int *ret_count)
+{
+	return ext2fs_zero_blocks3(fs, blk, num, ret_blk, ret_count, NULL);
+}
+
 errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 			     blk_t *ret_blk, int *ret_count)
 {
@@ -372,20 +407,20 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	retval = ext2fs_block_iterate3(fs, journal_ino, BLOCK_FLAG_APPEND,
 				       0, mkjournal_proc, &es);
 	if (retval)
-		goto errout;
+		goto out2;
 	if (es.err) {
 		retval = es.err;
-		goto errout;
+		goto out2;
 	}
 	if (es.zero_count) {
 		retval = ext2fs_zero_blocks2(fs, es.blk_to_zero,
 					    es.zero_count, 0, 0);
 		if (retval)
-			goto errout;
+			goto out2;
 	}
 
 	if ((retval = ext2fs_read_inode(fs, journal_ino, &inode)))
-		goto errout;
+		goto out2;
 
 	inode_size = (unsigned long long)fs->blocksize * num_blocks;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
@@ -394,10 +429,10 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	inode.i_mode = LINUX_S_IFREG | 0600;
 	retval = ext2fs_inode_size_set(fs, &inode, inode_size);
 	if (retval)
-		goto errout;
+		goto out2;
 
 	if ((retval = ext2fs_write_new_inode(fs, journal_ino, &inode)))
-		goto errout;
+		goto out2;
 	retval = 0;
 
 	memcpy(fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
@@ -406,8 +441,6 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	fs->super->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
 	ext2fs_mark_super_dirty(fs);
 
-errout:
-	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 out2:
 	ext2fs_free_mem(&buf);
 	return retval;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c6a2c2f..149330c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -437,7 +437,6 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 				sync();
 		}
 	}
-	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 	ext2fs_numeric_progress_close(fs, &progress,
 				      _("done                            \n"));
 
@@ -626,7 +625,6 @@ static void create_journal_dev(ext2_filsys fs)
 		count -= c;
 		ext2fs_numeric_progress_update(fs, &progress, blk);
 	}
-	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 
 	ext2fs_numeric_progress_close(fs, &progress, NULL);
 write_superblock:
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index e71acf3..93df070 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -762,11 +762,11 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 		/*
 		 * Write out the new inode table
 		 */
-		retval = io_channel_write_blk64(fs->io,
-						ext2fs_inode_table_loc(fs, i),
-						fs->inode_blocks_per_group,
-						rfs->itable_buf);
-		if (retval) goto errout;
+		retval = ext2fs_zero_blocks2(fs, ext2fs_inode_table_loc(fs, i),
+					     fs->inode_blocks_per_group, NULL,
+					     NULL);
+		if (retval)
+			goto errout;
 
 		io_channel_flush(fs->io);
 		if (rfs->progress) {
@@ -2244,15 +2244,11 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
-	char			*block_buf = NULL;
 
 	if (!(fs->super->s_feature_compat &
 	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
 		return 0;
 
-	retval = ext2fs_get_mem(fs->blocksize, &block_buf);
-	if (retval) goto errout;
-
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
 	if (retval) goto errout;
 
@@ -2272,19 +2268,16 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 		exit(1);
 	}
 
-	memset(block_buf, 0, fs->blocksize);
