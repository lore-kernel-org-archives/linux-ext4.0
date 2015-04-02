From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/35] e2fsck: abort on read error beyond end of FS
Date: Wed, 01 Apr 2015 19:35:00 -0700
Message-ID: <20150402023500.25243.65825.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35457 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbbDBCfE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:35:04 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Abort if we fail to read a block that's past the end of the FS.
Includes a flag to disable the abort behavior for selected parts of
the fsck run, so that we don't fail on a busted object prior to fixing
it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.h   |    1 +
 e2fsck/ehandler.c |    7 +++++--
 e2fsck/extents.c  |    2 ++
 e2fsck/journal.c  |    3 +++
 e2fsck/message.c  |   12 +++++++++++-
 e2fsck/pass1.c    |   28 ++++++++++++++++------------
 e2fsck/pass1b.c   |    4 ++++
 7 files changed, 42 insertions(+), 15 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 5fda863..453b552 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -193,6 +193,7 @@ struct resource_track {
 #define E2F_FLAG_TIME_INSANE	0x2000 /* Time is insane */
 #define E2F_FLAG_PROBLEMS_FIXED	0x4000 /* At least one problem was fixed */
 #define E2F_FLAG_ALLOC_OK	0x8000 /* Can we allocate blocks? */
+#define E2F_FLAG_IGNORE_READ_ERROR	0x10000 /* Don't rewrite read error blocks */
 
 #define E2F_RESET_FLAGS (E2F_FLAG_TIME_INSANE | E2F_FLAG_PROBLEMS_FIXED)
 
diff --git a/e2fsck/ehandler.c b/e2fsck/ehandler.c
index 71ca301..847f8e5 100644
--- a/e2fsck/ehandler.c
+++ b/e2fsck/ehandler.c
@@ -60,8 +60,11 @@ static errcode_t e2fsck_handle_read_error(io_channel channel,
 	preenhalt(ctx);
 
 	/* Don't rewrite a block past the end of the FS. */
-	if (block >= ext2fs_blocks_count(fs->super))
-		return 0;
+	if (block >= ext2fs_blocks_count(fs->super)) {
+		if (ctx->flags & E2F_FLAG_IGNORE_READ_ERROR)
+			return 0;
+		abort();
+	}
 
 	if (ask(ctx, _("Ignore error"), 1)) {
 		if (ask(ctx, _("Force rewrite"), 1))
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index 8465299..cff265a 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -29,6 +29,7 @@ errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 {
 	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
 				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	    (ctx->flags & (E2F_FLAG_RESTART_LATER | E2F_FLAG_RESTART)) ||
 	    (ctx->options & E2F_OPT_NO) ||
 	    (ino != EXT2_ROOT_INO && ino < ctx->fs->super->s_first_ino))
 		return 0;
@@ -339,6 +340,7 @@ static void rebuild_extents(e2fsck_t ctx, const char *pass_name, int pr_header)
 
 	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
 				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	    (ctx->flags & (E2F_FLAG_RESTART_LATER | E2F_FLAG_RESTART)) ||
 	    !ext2fs_test_valid(ctx->fs) ||
 	    ctx->invalid_bitmaps) {
 		if (ctx->inodes_to_rebuild)
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 9f32095..c195797 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -315,6 +315,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	journal->j_inode = NULL;
 	journal->j_blocksize = ctx->fs->blocksize;
 
+	ctx->flags |= E2F_FLAG_IGNORE_READ_ERROR;
 	if (uuid_is_null(sb->s_journal_uuid)) {
 		if (!sb->s_journal_inum) {
 			retval = EXT2_ET_BAD_INODE_NUM;
@@ -518,9 +519,11 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 
 	*ret_journal = journal;
 	e2fsck_use_inode_shortcuts(ctx, 0);
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 	return 0;
 
 errout:
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 	e2fsck_use_inode_shortcuts(ctx, 0);
 	if (dev_fs)
 		ext2fs_free_mem(&dev_fs);
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 9c1433f..510f291 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -199,14 +199,24 @@ static void print_pathname(FILE *f, ext2_filsys fs, ext2_ino_t dir,
 {
 	errcode_t	retval = 0;
 	char		*path;
+	e2fsck_t	ctx = fs ? (e2fsck_t) fs->priv_data : NULL;
+	int		flags;
 
 	if (!dir && (ino < num_special_inodes)) {
 		fputs(_(special_inode_name[ino]), f);
 		return;
 	}
 
-	if (fs)
+	if (fs) {
+		if (ctx) {
+			flags = ctx->flags;
+			ctx->flags |= E2F_FLAG_IGNORE_READ_ERROR;
+		}
 		retval = ext2fs_get_pathname(fs, dir, ino, &path);
+		if (ctx)
+			ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR |
+					(flags & E2F_FLAG_IGNORE_READ_ERROR);
+	}
 	if (!fs || retval)
 		fputs("???", f);
 	else {
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 308a95a..760fbde 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -510,6 +510,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	int			extent_fs;
 	int			inlinedata_fs;
 
+	ctx->flags |= E2F_FLAG_IGNORE_READ_ERROR;
 	/*
 	 * If the mode looks OK, we believe it.  If the first block in
 	 * the i_block array is 0, this cannot be a directory. If the
@@ -519,7 +520,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode) ||
 	    LINUX_S_ISLNK(inode->i_mode) || inode->i_block[0] == 0)
-		return;
+		goto out;
 
 	/* 
 	 * Check the block numbers in the i_block array for validity:
@@ -552,13 +553,13 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		struct ext2_dir_entry de;
 
 		if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
-			return;
+			goto out;
 		/*
 		 * If the size isn't a multiple of 4, it's probably not a
 		 * directory??
 		 */
 		if (size & 3)
-			return;
+			goto out;
 		/*
 		 * If the first 10 bytes don't look like a directory entry,
 		 * it's probably not a directory.
@@ -578,14 +579,14 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		     de.inode != 0) ||
 		    rec_len > EXT4_MIN_INLINE_DATA_SIZE -
 			      EXT4_INLINE_DATA_DOTDOT_SIZE)
-			return;
+			goto out;
 		/* device files never have a "system.data" entry */
 		goto isdir;
 	} else if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
 		/* extent mapped */
 		if  (ext2fs_bmap2(ctx->fs, pctx->ino, inode, 0, 0, 0, 0,
 				 &blk))
-			return;
+			goto out;
 		/* device files are never extent mapped */
 		not_device++;
 	} else {
@@ -600,7 +601,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 			    blk >= ext2fs_blocks_count(ctx->fs->super) ||
 			    ext2fs_fast_test_block_bitmap2(ctx->block_found_map,
 							   blk))
-				return;	/* Invalid block, can't be dir */
+				goto out;	/* Invalid block, can't be dir */
 		}
 		blk = inode->i_block[0];
 	}
@@ -612,45 +613,48 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	if ((LINUX_S_ISCHR(inode->i_mode) || LINUX_S_ISBLK(inode->i_mode)) &&
 	    (inode->i_links_count == 1) && !not_device)
-		return;
+		goto out;
 
 	/* read the first block */
 	ehandler_operation(_("reading directory block"));
 	retval = ext2fs_read_dir_block4(ctx->fs, blk, buf, 0, pctx->ino);
 	ehandler_operation(0);
 	if (retval)
-		return;
+		goto out;
 
 	dirent = (struct ext2_dir_entry *) buf;
 	retval = ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (retval)
-		return;
+		goto out;
 	if ((ext2fs_dirent_name_len(dirent) != 1) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->inode != pctx->ino) ||
 	    (rec_len < 12) ||
 	    (rec_len % 4) ||
 	    (rec_len >= ctx->fs->blocksize - 12))
-		return;
+		goto out;
 
 	dirent = (struct ext2_dir_entry *) (buf + rec_len);
 	retval = ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (retval)
-		return;
+		goto out;
 	if ((ext2fs_dirent_name_len(dirent) != 2) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->name[1] != '.') ||
 	    (rec_len < 12) ||
 	    (rec_len % 4))
-		return;
+		goto out;
 
 isdir:
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
 		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
 		e2fsck_write_inode_full(ctx, pctx->ino, inode,
 					EXT2_INODE_SIZE(ctx->fs->super),
 					"check_is_really_dir");
 	}
+out:
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 }
 
 void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index cd967f4..10136a6 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -234,7 +234,9 @@ void e2fsck_pass1_dupblocks(e2fsck_t ctx, char *block_buf)
 	dict_set_allocator(&clstr_dict, NULL, cluster_dnode_free, NULL);
 
 	init_resource_track(&rtrack, ctx->fs->io);
+	ctx->flags |= E2F_FLAG_IGNORE_READ_ERROR;
 	pass1b(ctx, block_buf);
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 	print_resource_track(ctx, "Pass 1b", &rtrack, ctx->fs->io);
 
 	init_resource_track(&rtrack, ctx->fs->io);
@@ -242,7 +244,9 @@ void e2fsck_pass1_dupblocks(e2fsck_t ctx, char *block_buf)
 	print_resource_track(ctx, "Pass 1c", &rtrack, ctx->fs->io);
 
 	init_resource_track(&rtrack, ctx->fs->io);
+	ctx->flags |= E2F_FLAG_IGNORE_READ_ERROR;
 	pass1d(ctx, block_buf);
+	ctx->flags &= ~E2F_FLAG_IGNORE_READ_ERROR;
 	print_resource_track(ctx, "Pass 1d", &rtrack, ctx->fs->io);
 
 	/*

