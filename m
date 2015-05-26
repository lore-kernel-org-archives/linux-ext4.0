From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] e2fsck: Add support for handling orphan file
Date: Tue, 26 May 2015 09:51:07 +0200
Message-ID: <1432626669-6643-4-git-send-email-jack@suse.cz>
References: <1432626669-6643-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbbEZHvS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 03:51:18 -0400
In-Reply-To: <1432626669-6643-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/pass1.c   |  27 +++++
 e2fsck/problem.c |  80 +++++++++++++
 e2fsck/problem.h |  51 +++++++++
 e2fsck/super.c   | 343 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 e2fsck/unix.c    |  68 +++++++++++
 5 files changed, 530 insertions(+), 39 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b007f6522ee3..207778113846 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1466,6 +1466,33 @@ void e2fsck_pass1(e2fsck_t ctx)
 							inode_size, "pass1");
 				failed_csum = 0;
 			}
+		} else if (ino == EXT4_ORPHAN_INO) {
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
+			if (fs->super->s_feature_compat &
+					EXT4_FEATURE_COMPAT_ORPHAN_FILE) {
+				if (!LINUX_S_ISREG(inode->i_mode) &&
+				    fix_problem(ctx, PR_1_ORPHAN_FILE_BAD_MODE,
+						&pctx)) {
+					inode->i_mode = LINUX_S_IFREG;
+					e2fsck_write_inode(ctx, ino, inode,
+							   "pass1");
+					failed_csum = 0;
+				}
+				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
+				continue;
+			}
+			if ((inode->i_links_count ||
+			     inode->i_blocks || inode->i_block[0]) &&
+			    fix_problem(ctx, PR_1_ORPHAN_FILE_NOT_CLEAR,
+					&pctx)) {
+				memset(inode, 0, inode_size);
+				ext2fs_icount_store(ctx->inode_link_info, ino,
+						    0);
+				e2fsck_write_inode_full(ctx, ino, inode,
+							inode_size, "pass1");
+				failed_csum = 0;
+			}
 		} else if (ino < EXT2_FIRST_INODE(fs->super)) {
 			problem_t problem = 0;
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 62fce25d97f9..b09159369106 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -464,6 +464,26 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("External @j @S checksum does not match @S.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Orphan file contains holes */
+	{ PR_0_ORPHAN_FILE_HOLE,
+	  N_("Orphan file (@i %i) contains hole at @b %b. Terminating orphan file recovery.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file block has wrong magic */
+	{ PR_0_ORPHAN_FILE_BAD_MAGIC,
+	  N_("Orphan file (@i %i) @b %b contains wrong magic. Terminating orphan file recovery.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file block has wrong checksum */
+	{ PR_0_ORPHAN_FILE_BAD_CHECKSUM,
+	  N_("Orphan file (@i %i) @b %b contains wrong checksum. Terminating orphan file recovery.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file size isn't multiple of blocks size */
+	{ PR_0_ORPHAN_FILE_WRONG_SIZE,
+	  N_("Orphan file (@i %i) size is not multiple of block size. Terminating orphan file recovery.\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
@@ -1101,6 +1121,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@A memory for encrypted @d list\n"),
 	  PROMPT_NONE, PR_FATAL },
 
+	/* Orphan file has bad mode */
+	{ PR_1_ORPHAN_FILE_BAD_MODE,
+	  N_("Orphan file @i %i is not regular file.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Orphan file inode is not in use, but contains data */
+	{ PR_1_ORPHAN_FILE_NOT_CLEAR,
+	  N_("Orphan file @i %i is not in use, but contains data.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
@@ -1926,6 +1956,56 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error flushing writes to storage device: %m\n"),
 	  PROMPT_NULL, PR_FATAL },
 
+	/* Orphan file without a journal */
+	{ PR_6_ORPHAN_FILE_WITHOUT_JOURNAL,
+	  N_("@S has orphan file without @j.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Orphan file truncation failed */
+	{ PR_6_ORPHAN_FILE_TRUNC_FAILED,
+	  N_("Failed to truncate orphan file.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Failed to initialize orphan file */
+	{ PR_6_ORPHAN_FILE_CORRUPTED,
+	  N_("Failed to initialize orphan file.\n"),
+	  PROMPT_RECREATE, PR_PREEN_OK },
+
+	/* Cannot fix corrupted orphan file with invalid bitmaps */
+	{ PR_6_ORPHAN_FILE_BITMAP_INVALID,
+	  N_("Cannot fix corrupted orphan file with invalid bitmaps.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file creation failed */
+	{ PR_6_ORPHAN_FILE_CREATE_FAILED,
+	  N_("Failed to truncate orphan file (@i %i).\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file block contains data */
+	{ PR_6_ORPHAN_BLOCK_DIRTY,
+	  N_("Orphan file (@i %i) @b %b is not clean.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* orphan_file_used set but orphan file is empty */
+	{ PR_6_ORPHAN_PRESENT_CLEAN_FILE,
+	  N_("Flag orphan_file_used is set but orphan file is clean.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* orphan_file_used set but orphan_file is not */
+	{ PR_6_ORPHAN_PRESENT_NO_FILE,
+	  N_("Flag orphan_file_used is set but flag orphan_file is not.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Orphan file size isn't multiple of blocks size */
+	{ PR_6_ORPHAN_FILE_WRONG_SIZE,
+	  N_("Orphan file (@i %i) size is not multiple of block size.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file contains holes */
+	{ PR_6_ORPHAN_FILE_HOLE,
+	  N_("Orphan file (@i %i) contains hole at @b %b.\n"),
+	  PROMPT_NONE, 0 },
+
 	{ 0 }
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index bc959c483199..8174b86d4037 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -267,6 +267,18 @@ struct problem_context {
 /* External journal has corrupt superblock */
 #define PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID	0x00004A
 
+/* Orphan file contains holes */
+#define PR_0_ORPHAN_FILE_HOLE			0x00004B
+
+/* Orphan file block has wrong magic */
+#define PR_0_ORPHAN_FILE_BAD_MAGIC		0x00004C
+
+/* Orphan file block has wrong checksum */
+#define PR_0_ORPHAN_FILE_BAD_CHECKSUM		0x00004D
+
+/* Orphan file size isn't multiple of blocks size */
+#define PR_0_ORPHAN_FILE_WRONG_SIZE		0x00004E
+
 /*
  * Pass 1 errors
  */
@@ -644,6 +656,15 @@ struct problem_context {
 /* Error allocating memory for encrypted directory list */
 #define PR_1_ALLOCATE_ENCRYPTED_DIRLIST		0x01007E
 
+/* Orphan file inode is not a regular file */
+#define PR_1_ORPHAN_FILE_BAD_MODE		0x01007F
+
+/* Orphan file inode is not in use, but contains data */
+#define PR_1_ORPHAN_FILE_NOT_CLEAR		0x010080
+
+/* Orphan file inode is not clear */
+#define PR_1_ORPHAN_INODE_NOT_CLEAR		0x01007F
+
 /*
  * Pass 1b errors
  */
@@ -1161,6 +1182,36 @@ struct problem_context {
 /* Error flushing writes to storage device */
 #define PR_6_IO_FLUSH			0x060005
 
+/* Orphan file without a journal */
+#define PR_6_ORPHAN_FILE_WITHOUT_JOURNAL	0x060006
+
+/* Orphan file truncation failed */
+#define PR_6_ORPHAN_FILE_TRUNC_FAILED	0x060007
+
+/* Failed to initialize orphan file */
+#define PR_6_ORPHAN_FILE_CORRUPTED	0x060008
+
+/* Cannot fix corrupted orphan file with invalid bitmaps */
+#define PR_6_ORPHAN_FILE_BITMAP_INVALID	0x060009
+
+/* Orphan file creation failed */
+#define PR_6_ORPHAN_FILE_CREATE_FAILED	0x06000A
+
+/* Orphan file block contains data */
+#define PR_6_ORPHAN_BLOCK_DIRTY		0x06000B
+
+/* orphan_file_used set but orphan file is empty */
+#define PR_6_ORPHAN_PRESENT_CLEAN_FILE	0x06000C
+
+/* orphan_file_used set but orphan_file is not */
+#define PR_6_ORPHAN_PRESENT_NO_FILE	0x06000D
+
+/* Orphan file size isn't multiple of blocks size */
+#define PR_6_ORPHAN_FILE_WRONG_SIZE	0x06000E
+
+/* Orphan file contains holes */
+#define PR_6_ORPHAN_FILE_HOLE		0x06000F
+
 /*
  * Function declarations
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 9eebd4da4aa6..6f5bd6e15010 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -224,6 +224,172 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	return 0;
 }
 
+static int release_orphan_inode(e2fsck_t ctx, ext2_ino_t *ino, char *block_buf)
+{
+	ext2_filsys fs = ctx->fs;
+	struct problem_context pctx;
+	struct ext2_inode inode;
+	ext2_ino_t next_ino;
+
+	e2fsck_read_inode(ctx, *ino, &inode, "release_orphan_inode");
+	clear_problem_context(&pctx);
+	pctx.ino = *ino;
+	pctx.inode = &inode;
+	pctx.str = inode.i_links_count ? _("Truncating") : _("Clearing");
+
+	fix_problem(ctx, PR_0_ORPHAN_CLEAR_INODE, &pctx);
+
+	next_ino = inode.i_dtime;
+	if (next_ino &&
+	    ((next_ino < EXT2_FIRST_INODE(fs->super)) ||
+	     (next_ino > fs->super->s_inodes_count))) {
+		pctx.ino = next_ino;
+		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_INODE, &pctx);
+		return 1;
+	}
+	if (release_inode_blocks(ctx, *ino, &inode, block_buf, &pctx))
+		return 1;
+
+	if (!inode.i_links_count) {
+		ext2fs_inode_alloc_stats2(fs, *ino, -1,
+					  LINUX_S_ISDIR(inode.i_mode));
+		ctx->free_inodes++;
+		inode.i_dtime = ctx->now;
+	} else {
+		inode.i_dtime = 0;
+	}
+	e2fsck_write_inode(ctx, *ino, &inode, "delete_file");
+	*ino = next_ino;
+
+	return 0;
+}
+
+struct process_orphan_block_data {
+	e2fsck_t 	ctx;
+	char 		*buf;
+	char		*block_buf;
+	e2_blkcnt_t	blocks;
+	int		abort;
+	int		clear;
+	errcode_t	errcode;
+};
+
+static int process_orphan_block(ext2_filsys fs,
+			       blk64_t	*block_nr,
+			       e2_blkcnt_t blockcnt,
+			       blk64_t	ref_blk EXT2FS_ATTR((unused)),
+			       int	ref_offset EXT2FS_ATTR((unused)),
+			       void *priv_data)
+{
+	struct process_orphan_block_data *pd;
+	e2fsck_t 		ctx;
+	struct problem_context	pctx;
+	blk64_t			blk = *block_nr;
+	struct ext4_orphan_block_tail *tail;
+	int			j;
+	int			inodes_per_ob;
+	__u32			*bdata;
+	ext2_ino_t		ino;
+
+	pd = priv_data;
+	ctx = pd->ctx;
+	clear_problem_context(&pctx);
+	pctx.ino = EXT4_ORPHAN_INO;
+	pctx.blk = blockcnt;
+
+	/* Orphan file must not have holes */
+	if (!blk) {
+		if (blockcnt == pd->blocks)
+			return BLOCK_ABORT;
+		fix_problem(ctx, PR_0_ORPHAN_FILE_HOLE, &pctx);
+return_abort:
+		pd->abort = 1;
+		return BLOCK_ABORT;
+	}
+	inodes_per_ob = ext2fs_inodes_per_orphan_block(fs);
+	pd->errcode = io_channel_read_blk64(fs->io, blk, 1, pd->buf);
+	if (pd->errcode)
+		goto return_abort;
+	tail = ext2fs_orphan_block_tail(fs, pd->buf);
+	if (ext2fs_le32_to_cpu(tail->ob_magic) !=
+	    EXT4_ORPHAN_BLOCK_MAGIC) {
+		fix_problem(ctx, PR_0_ORPHAN_FILE_BAD_MAGIC, &pctx);
+		goto return_abort;
+	}
+	if (!ext2fs_orphan_file_block_csum_verify(fs, pd->buf)) {
+		fix_problem(ctx, PR_0_ORPHAN_FILE_BAD_CHECKSUM, &pctx);
+		goto return_abort;
+	}
+	bdata = (__u32 *)pd->buf;
+	for (j = 0; j < inodes_per_ob; j++) {
+		if (!bdata[j])
+			continue;
+		ino = ext2fs_le32_to_cpu(bdata[j]);
+		if (release_orphan_inode(ctx, &ino, pd->block_buf))
+			goto return_abort;
+	}
+	return 0;
+}
+
+static int process_orphan_file(e2fsck_t ctx, char *block_buf)
+{
+	ext2_filsys fs = ctx->fs;
+	char *orphan_buf;
+	struct process_orphan_block_data pd;
+	int ret = 0;
+	struct ext2_inode orphan_inode;
+	struct problem_context	pctx;
+	errcode_t retval;
+
+	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE))
+		return 0;
+
+	clear_problem_context(&pctx);
+	pctx.ino = EXT4_ORPHAN_INO;
+
+	orphan_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 4,
+						    "orphan block buffer");
+	retval = ext2fs_read_inode(fs, EXT4_ORPHAN_INO, &orphan_inode);
+	if (retval < 0) {
+		com_err("process_orphan_file", retval,
+			_("while reading inode %d"), EXT4_ORPHAN_INO);
+		ret = 1;
+		goto out;
+	}
+	if (EXT2_I_SIZE(&orphan_inode) & (fs->blocksize - 1)) {
+		fix_problem(ctx, PR_0_ORPHAN_FILE_WRONG_SIZE, &pctx);
+		ret = 1;
+		goto out;
+	}
+	pd.buf = orphan_buf + 3 * fs->blocksize;
+	pd.block_buf = block_buf;
+	pd.blocks = EXT2_I_SIZE(&orphan_inode) / fs->blocksize;
+	pd.ctx = ctx;
+	pd.abort = 0;
+	pd.errcode = 0;
+	retval = ext2fs_block_iterate3(fs, EXT4_ORPHAN_INO,
+				       BLOCK_FLAG_DATA_ONLY | BLOCK_FLAG_HOLE,
+				       orphan_buf, process_orphan_block, &pd);
+	if (retval) {
+		com_err("process_orphan_block", retval,
+			_("while calling ext2fs_block_iterate for inode %d"),
+			EXT4_ORPHAN_INO);
+		ret = 1;
+		goto out;
+	}
+	if (pd.abort) {
+		if (pd.errcode) {
+			com_err("process_orphan_block", pd.errcode,
+				_("while reading blocks of inode %d"),
+				EXT4_ORPHAN_INO);
+		}
+		ret = 1;
+	}
+out:
+	ext2fs_free_mem(&orphan_buf);
+	return ret;
+}
+
 /*
  * This function releases all of the orphan inodes.  It returns 1 if
  * it hit some error, and 0 on success.
@@ -231,14 +397,18 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 static int release_orphan_inodes(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	ext2_ino_t	ino, next_ino;
-	struct ext2_inode inode;
+	ext2_ino_t ino;
 	struct problem_context pctx;
 	char *block_buf;
 
-	if ((ino = fs->super->s_last_orphan) == 0)
+	if (fs->super->s_last_orphan == 0 &&
+	    !(fs->super->s_feature_ro_compat &
+					EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT))
 		return 0;
 
+	ino = fs->super->s_last_orphan;
+	clear_problem_context(&pctx);
+	pctx.ino = ino;
 	/*
 	 * Win or lose, we won't be using the head of the orphan inode
 	 * list again.
@@ -247,17 +417,16 @@ static int release_orphan_inodes(e2fsck_t ctx)
 	ext2fs_mark_super_dirty(fs);
 
 	/*
-	 * If the filesystem contains errors, don't run the orphan
-	 * list, since the orphan list can't be trusted; and we're
-	 * going to be running a full e2fsck run anyway...
+	 * If the filesystem contains errors, don't process the orphan list
+	 * or orphan file, since neither can be trusted; and we're going to
+	 * be running a full e2fsck run anyway... We clear orphan file contents
+	 * after filesystem is checked to avoid clearing someone else's data.
 	 */
 	if (fs->super->s_state & EXT2_ERROR_FS)
 		return 0;
 
-	if ((ino < EXT2_FIRST_INODE(fs->super)) ||
-	    (ino > fs->super->s_inodes_count)) {
-		clear_problem_context(&pctx);
-		pctx.ino = ino;
+	if (ino && ((ino < EXT2_FIRST_INODE(fs->super)) ||
+	    (ino > fs->super->s_inodes_count))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_HEAD_INODE, &pctx);
 		return 1;
 	}
@@ -266,39 +435,21 @@ static int release_orphan_inodes(e2fsck_t ctx)
 						    "block iterate buffer");
 	e2fsck_read_bitmaps(ctx);
 
+	/* First process orphan list */
 	while (ino) {
-		e2fsck_read_inode(ctx, ino, &inode, "release_orphan_inodes");
-		clear_problem_context(&pctx);
-		pctx.ino = ino;
-		pctx.inode = &inode;
-		pctx.str = inode.i_links_count ? _("Truncating") :
-			_("Clearing");
-
-		fix_problem(ctx, PR_0_ORPHAN_CLEAR_INODE, &pctx);
-
-		next_ino = inode.i_dtime;
-		if (next_ino &&
-		    ((next_ino < EXT2_FIRST_INODE(fs->super)) ||
-		     (next_ino > fs->super->s_inodes_count))) {
-			pctx.ino = next_ino;
-			fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_INODE, &pctx);
+		if (release_orphan_inode(ctx, &ino, block_buf))
 			goto return_abort;
-		}
+	}
 
-		if (release_inode_blocks(ctx, ino, &inode, block_buf, &pctx))
-			goto return_abort;
+	/* Next process orphan file */
+	if (fs->super->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT &&
+	    !(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE))
+		goto return_abort;
+	if (process_orphan_file(ctx, block_buf))
+		goto return_abort;
 
-		if (!inode.i_links_count) {
-			ext2fs_inode_alloc_stats2(fs, ino, -1,
-						  LINUX_S_ISDIR(inode.i_mode));
-			ctx->free_inodes++;
-			inode.i_dtime = ctx->now;
-		} else {
-			inode.i_dtime = 0;
-		}
-		e2fsck_write_inode(ctx, ino, &inode, "delete_file");
-		ino = next_ino;
-	}
+out:
 	ext2fs_free_mem(&block_buf);
 	return 0;
 return_abort:
@@ -306,6 +457,120 @@ return_abort:
 	return 1;
 }
 
+static int reinit_orphan_block(ext2_filsys fs,
+			       blk64_t	*block_nr,
+			       e2_blkcnt_t blockcnt,
+			       blk64_t	ref_blk EXT2FS_ATTR((unused)),
+			       int	ref_offset EXT2FS_ATTR((unused)),
+			       void *priv_data)
+{
+	struct process_orphan_block_data *pd;
+	e2fsck_t 		ctx;
+	blk64_t			blk = *block_nr;
+	struct problem_context	pctx;
+
+	pd = priv_data;
+	ctx = pd->ctx;
+
+	/* Orphan file must not have holes */
+	if (!blk) {
+		if (blockcnt == pd->blocks)
+			return BLOCK_ABORT;
+
+		clear_problem_context(&pctx);
+		pctx.ino = EXT4_ORPHAN_INO;
+		pctx.blk = blockcnt;
+		fix_problem(ctx, PR_6_ORPHAN_FILE_HOLE, &pctx);
+return_abort:
+		pd->abort = 1;
+		return BLOCK_ABORT;
+	}
+	if (!pd->clear) {
+		pd->errcode = io_channel_read_blk64(fs->io, blk, 1,
+						    pd->block_buf);
+		/* Block is already cleanly initialized? */
+		if (!memcmp(pd->block_buf, pd->buf, fs->blocksize))
+			return 0;
+
+		clear_problem_context(&pctx);
+		pctx.ino = EXT4_ORPHAN_INO;
+		pctx.blk = blockcnt;
+		if (!fix_problem(ctx, PR_6_ORPHAN_BLOCK_DIRTY, &pctx))
+			goto return_abort;
+		pd->clear = 1;
+	}
+	pd->errcode = io_channel_write_blk64(fs->io, blk, 1, pd->buf);
+	if (pd->errcode)
+		goto return_abort;
+	return 0;
+}
+
+/*
+ * Check and clear orphan file. We just return non-zero if we hit some
+ * inconsistency. Caller will truncate & recreate new orphan file.
+ */
+int check_init_orphan_file(e2fsck_t ctx)
+{
+	ext2_filsys fs = ctx->fs;
+	char *orphan_buf;
+	struct process_orphan_block_data pd;
+	struct ext4_orphan_block_tail *tail;
+	struct ext2_inode orphan_inode;
+	int ret = 0;
+	errcode_t retval;
+
+	orphan_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 5,
+						    "orphan block buffer");
+	e2fsck_read_inode(ctx, EXT4_ORPHAN_INO, &orphan_inode, "orphan inode");
+	if (EXT2_I_SIZE(&orphan_inode) & (fs->blocksize - 1)) {
+		struct problem_context	pctx;
+
+		clear_problem_context(&pctx);
+		pctx.ino = EXT4_ORPHAN_INO;
+		fix_problem(ctx, PR_6_ORPHAN_FILE_WRONG_SIZE, &pctx);
+		ret = 1;
+		goto out;
+	}
+	pd.buf = orphan_buf + 3 * fs->blocksize;
+	pd.block_buf = orphan_buf + 4 * fs->blocksize;
+	pd.blocks = EXT2_I_SIZE(&orphan_inode) / fs->blocksize;
+	pd.ctx = ctx;
+	pd.abort = 0;
+	pd.clear = 0;
+	pd.errcode = 0;
+	/* Initialize buffer to write */
+	memset(pd.buf, 0, fs->blocksize);
+	tail = ext2fs_orphan_block_tail(fs, pd.buf);
+	tail->ob_magic = ext2fs_cpu_to_le32(EXT4_ORPHAN_BLOCK_MAGIC);
+	ext2fs_orphan_file_block_csum_set(fs, pd.buf);
+
+	retval = ext2fs_block_iterate3(fs, EXT4_ORPHAN_INO,
+				       BLOCK_FLAG_DATA_ONLY | BLOCK_FLAG_HOLE,
+				       orphan_buf, reinit_orphan_block, &pd);
+	if (retval) {
+		com_err("reinit_orphan_block", retval,
+			_("while calling ext2fs_block_iterate for inode %d"),
+			EXT4_ORPHAN_INO);
+		ret = 1;
+		goto out;
+	}
+	if (pd.abort) {
+		if (pd.errcode) {
+			com_err("process_orphan_block", pd.errcode,
+				_("while reading blocks of inode %d"),
+				EXT4_ORPHAN_INO);
+		}
+		ret = 1;
+	}
+
+	/* We had to clear some blocks. Report it up. */
+	if (ret == 0 && pd.clear)
+		ret = 2;
+out:
+	ext2fs_free_mem(&orphan_buf);
+	return ret;
+}
+
 /*
  * Check the resize inode to make sure it is sane.  We check both for
  * the case where on-line resizing is not enabled (in which case the
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 3db34802c831..bea11bc2cb93 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1671,8 +1671,76 @@ print_unsupp_features:
 				_("\n*** journal has been regenerated ***\n"));
 		}
 	}
+
 no_journal:
+	/* If there isn't journal, no point in creating orphan file... */
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE) {
+		int ret;
+
+		/* No point in orphan file without a journal... */
+		if (!(fs->super->s_feature_compat &
+					EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+		    fix_problem(ctx, PR_6_ORPHAN_FILE_WITHOUT_JOURNAL, &pctx)) {
+			retval = ext2fs_truncate_orphan_file(fs);
+			if (retval) {
+				/* Huh, failed to truncate file */
+				fix_problem(ctx, PR_6_ORPHAN_FILE_TRUNC_FAILED,
+					    &pctx);
+				goto check_quotas;
+			}
+			goto check_quotas;
+		}
+		ret = check_init_orphan_file(ctx);
+		if (ret == 2 ||
+		    (ret == 0 && (fs->super->s_feature_ro_compat &
+				  EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT) &&
+		     fix_problem(ctx, PR_6_ORPHAN_PRESENT_CLEAN_FILE, &pctx))) {
+			fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT;
+			ext2fs_mark_super_dirty(fs);
+		} else if (ret == 1 &&
+		    fix_problem(ctx, PR_6_ORPHAN_FILE_CORRUPTED, &pctx)) {
+			int orphan_file_blocks;
+
+			if (ctx->invalid_bitmaps) {
+				fix_problem(ctx,
+					    PR_6_ORPHAN_FILE_BITMAP_INVALID,
+					    &pctx);
+				goto check_quotas;
+			}
+
+			retval = ext2fs_truncate_orphan_file(fs);
+			if (retval) {
+				/* Huh, failed to truncate file */
+				fix_problem(ctx, PR_6_ORPHAN_FILE_TRUNC_FAILED,
+					    &pctx);
+				goto check_quotas;
+			}
 
+			orphan_file_blocks = ext2fs_default_orphan_file_blocks(
+						ext2fs_blocks_count(fs->super));
+			log_out(ctx, _("Creating orphan file (%d blocks): "),
+				orphan_file_blocks);
+			fflush(stdout);
+			retval = ext2fs_create_orphan_file(fs,
+							   orphan_file_blocks);
+			if (retval) {
+				log_out(ctx, "%s: while trying to create "
+					"orphan file\n", error_message(retval));
+				fix_problem(ctx, PR_6_ORPHAN_FILE_CREATE_FAILED,
+					    &pctx);
+				goto check_quotas;
+			}
+			log_out(ctx, "%s", _(" Done.\n"));
+		}
+	} else if ((fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT) &&
+		   fix_problem(ctx, PR_6_ORPHAN_PRESENT_NO_FILE, &pctx)) {
+			fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT;
+			ext2fs_mark_super_dirty(fs);
+	}
+check_quotas:
 	if (ctx->qctx) {
 		int i, needs_writeout;
 		for (i = 0; i < MAXQUOTAS; i++) {
-- 
2.1.4

