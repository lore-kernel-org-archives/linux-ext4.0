From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] e2fsck: Add support for handling orphan file
Date: Fri, 22 May 2015 13:28:56 +0200
Message-ID: <1432294137-26078-4-git-send-email-jack@suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161013AbbEVL3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 07:29:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D099AAD5E
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2015 11:29:00 +0000 (UTC)
In-Reply-To: <1432294137-26078-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/pass1.c   |  27 ++++++
 e2fsck/problem.c |  55 +++++++++++
 e2fsck/problem.h |  36 +++++++
 e2fsck/super.c   | 288 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 e2fsck/unix.c    |  60 ++++++++++++
 5 files changed, 429 insertions(+), 37 deletions(-)

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
index 62fce25d97f9..15813deeeafa 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -464,6 +464,26 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("External @j @S checksum does not match @S.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Orphan file contains holes */
+	{ PR_0_ORPHAN_FILE_HOLE,
+	  N_("Orphan file (@i %i) contains hole.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file block has wrong magic  */
+	{ PR_0_ORPHAN_FILE_BAD_MAGIC,
+	  N_("Orphan file (@i %i) block %B contains wrong magic.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Orphan file block has wrong magic  */
+	{ PR_0_ORPHAN_FILE_BAD_CHECKSUM,
+	  N_("Orphan file (@i %i) block %B contains wrong checksum.\n"),
+	  PROMPT_NONE, 0 },
+
+	/* orphan_present set without orphan_file set */
+	{ PR_0_ORPHAN_PRESENT_WITHOUT_FILE,
+	  N_("@S orphan_present flag set without orphan_file flag.\n"),
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
@@ -1926,6 +1956,31 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error flushing writes to storage device: %m\n"),
 	  PROMPT_NULL, PR_FATAL },
 
+	/* Orphan file without a journal */
+	{ PR_6_ORPHAN_FILE_WITHOUT_JOURNAL,
+	  N_("@S has orphan file without a journal.\n"),
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
+	  N_("Failed to truncate orphan file.\n"),
+	  PROMPT_NONE, 0 },
+
 	{ 0 }
 };
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index bc959c483199..3f9cae9cc261 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -249,6 +249,18 @@ struct problem_context {
 /* Checking group descriptor failed */
 #define PR_0_CHECK_DESC_FAILED			0x000045
 
+/* Orphan file contains holes */
+#define PR_0_ORPHAN_FILE_HOLE			0x000046
+
+/* Orphan file block has wrong magic */
+#define PR_0_ORPHAN_FILE_BAD_MAGIC		0x000047
+
+/* Orphan file block has wrong checksum */
+#define PR_0_ORPHAN_FILE_BAD_CHECKSUM		0x000048
+
+/* orphan_present set without orphan_file set */
+#define PR_0_ORPHAN_PRESENT_WITHOUT_FILE	0x000049
+
 /*
  * metadata_csum supersedes uninit_bg; both feature bits cannot be set
  * simultaneously.
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
@@ -1161,6 +1182,21 @@ struct problem_context {
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
 /*
  * Function declarations
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 9eebd4da4aa6..95841329b5bf 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -224,6 +224,153 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
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
+	int		abort;
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
+	e2_blkcnt_t		i;
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
+
+	/* Orphan file must not have holes */
+	if (!blk) {
+		fix_problem(ctx, PR_0_ORPHAN_FILE_HOLE, &pctx);
+return_abort:
+		pd->abort = 1;
+		return BLOCK_ABORT;
+	}
+	inodes_per_ob = ext2fs_inodes_per_orphan_block(fs);
+	for (i = 0; i < blockcnt; i++) {
+		pctx.blk = blk + i;
+		pd->errcode = io_channel_read_blk64(fs->io, blk + i, 1, pd->buf);
+		if (pd->errcode)
+			goto return_abort;
+		tail = ext2fs_orphan_block_tail(fs, pd->buf);
+		if (ext2fs_le32_to_cpu(tail->ob_magic) !=
+		    EXT4_ORPHAN_BLOCK_MAGIC) {
+			fix_problem(ctx, PR_0_ORPHAN_FILE_BAD_MAGIC, &pctx);
+			goto return_abort;
+		}
+		if (!ext2fs_orphan_file_block_csum_verify(fs, pd->buf)) {
+			fix_problem(ctx, PR_0_ORPHAN_FILE_BAD_CHECKSUM, &pctx);
+			goto return_abort;
+		}
+		bdata = (__u32 *)pd->buf;
+		for (j = 0; j < inodes_per_ob; j++) {
+			if (!bdata[j])
+				continue;
+			ino = ext2fs_le32_to_cpu(bdata[j]);
+			if (release_orphan_inode(ctx, &ino, pd->block_buf))
+				goto return_abort;
+		}
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
+	errcode_t retval;
+
+	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE))
+		return 0;
+
+	orphan_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 4,
+						    "orphan block buffer");
+	pd.buf = orphan_buf + 3 * fs->blocksize;
+	pd.block_buf = block_buf;
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
+	return 0;
+}
+
 /*
  * This function releases all of the orphan inodes.  It returns 1 if
  * it hit some error, and 0 on success.
@@ -231,14 +378,16 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
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
 	/*
 	 * Win or lose, we won't be using the head of the orphan inode
 	 * list again.
@@ -247,15 +396,16 @@ static int release_orphan_inodes(e2fsck_t ctx)
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
+	if (ino && ((ino < EXT2_FIRST_INODE(fs->super)) ||
+	    (ino > fs->super->s_inodes_count))) {
 		clear_problem_context(&pctx);
 		pctx.ino = ino;
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_HEAD_INODE, &pctx);
@@ -266,39 +416,23 @@ static int release_orphan_inodes(e2fsck_t ctx)
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
-			goto return_abort;
-		}
-
-		if (release_inode_blocks(ctx, ino, &inode, block_buf, &pctx))
+		if (release_orphan_inode(ctx, &ino, block_buf))
 			goto return_abort;
+	}
 
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
+	/* Next process orphan file */
+	if (fs->super->s_feature_ro_compat &
+				EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT &&
+	    !(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE)) {
+		fix_problem(ctx, PR_0_ORPHAN_PRESENT_WITHOUT_FILE, &pctx);
+		goto return_abort;
 	}
+	if (process_orphan_file(ctx, block_buf))
+		goto return_abort;
+
+out:
 	ext2fs_free_mem(&block_buf);
 	return 0;
 return_abort:
@@ -306,6 +440,86 @@ return_abort:
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
+	struct ext4_orphan_block_tail *tail;
+	int			inodes_per_ob;
+	__u32			*bdata;
+	e2_blkcnt_t		i;
+
+	pd = priv_data;
+	ctx = pd->ctx;
+
+	/* Orphan file must not have holes */
+	if (!blk) {
+return_abort:
+		pd->abort = 1;
+		return BLOCK_ABORT;
+	}
+	memset(pd->buf, 0, fs->blocksize);
+	tail = ext2fs_orphan_block_tail(fs, pd->buf);
+	tail->ob_magic = ext2fs_cpu_to_le32(EXT4_ORPHAN_BLOCK_MAGIC);
+	ext2fs_orphan_file_block_csum_set(fs, pd->buf);
+	inodes_per_ob = ext2fs_inodes_per_orphan_block(fs);
+	for (i = 0; i < blockcnt; i++) {
+		pd->errcode = io_channel_write_blk64(fs->io, blk + i, 1,
+						     pd->buf);
+		if (pd->errcode)
+			goto return_abort;
+	}
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
+	int ret = 0;
+	errcode_t retval;
+
+	orphan_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 4,
+						    "orphan block buffer");
+	pd.buf = orphan_buf + 3 * fs->blocksize;
+	pd.block_buf = NULL;
+	pd.ctx = ctx;
+	pd.abort = 0;
+	pd.errcode = 0;
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
+out:
+	ext2fs_free_mem(&orphan_buf);
+	return 0;
+}
+
 /*
  * Check the resize inode to make sure it is sane.  We check both for
  * the case where on-line resizing is not enabled (in which case the
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 3db34802c831..7e312d1c6369 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1671,8 +1671,68 @@ print_unsupp_features:
 				_("\n*** journal has been regenerated ***\n"));
 		}
 	}
+
 no_journal:
+	/* Orphan file will be clear - clear the feature unconditionally */
+	if (!(ctx->options & E2F_OPT_READONLY)) {
+		fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT;
+		ext2fs_mark_super_dirty(fs);
+	}
+
+	/* If there isn't journal, no point in creating orphan file... */
+	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_ORPHAN_FILE) {
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
+		if (check_init_orphan_file(ctx) &&
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
+
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
+	}
 
+check_quotas:
 	if (ctx->qctx) {
 		int i, needs_writeout;
 		for (i = 0; i < MAXQUOTAS; i++) {
-- 
2.1.4

