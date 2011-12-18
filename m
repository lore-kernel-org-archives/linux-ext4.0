From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/10] e2fsck: use different bitmap types as appropriate
Date: Sun, 18 Dec 2011 01:42:36 -0500
Message-ID: <1324190558-7436-9-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50576 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have multiple backend implementations of the bitmap code,
this commit teaches e2fsck to use either the most appropriate backend
for each use case.

Since we don't know for sure if we will get it all right, the default
choices can be overridden via e2fsck.conf.  The various definitions
are shown here, with the current defaults (which may change as we add
more bitmap implementations and as learn what works better).

; EXT2FS_BAMP64_BITARRAY is 1
; EXT2FS_BMAP64_RBTREE is 2
; EXT2FS_BMAP64_AUTODIR is 3
[bitmaps]
	inode_used_map = 2	; pass1
	inode_dir_map = 3	; pass1
	inode_reg_map = 2	; pass1
	block_found_map = 2	; pass1
	inode_bad_map = 2	; pass1
	inode_imagic_map = 2	; pass1
	block_dup_map = 2	; pass1
	block_ea_map = 2	; pass1
	inode_link_info = 2	; pass1
	inode_dup_map = 2	; pass1b
	inode_done_map = 3	; pass3
	inode_loop_detect = 3	; pass3
	fs_bitmaps = 2

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.h     |   20 ++++++++++++++++
 e2fsck/pass1.c      |   62 +++++++++++++++++++++++++++++++-------------------
 e2fsck/pass1b.c     |    6 +++-
 e2fsck/pass2.c      |    7 +++++-
 e2fsck/pass3.c      |    7 +++--
 e2fsck/unix.c       |    4 +++
 e2fsck/util.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h |    1 -
 8 files changed, 137 insertions(+), 31 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d225d89..ed8b0c7 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -540,6 +540,26 @@ extern int write_all(int fd, char *buf, size_t count);
 void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
 errcode_t e2fsck_mmp_update(ext2_filsys fs);
 
+extern void e2fsck_set_bitmap_type(ext2_filsys fs,
+				   unsigned int default_type,
+				   const char *profile_name,
+				   unsigned int *old_type);
+extern errcode_t e2fsck_allocate_inode_bitmap(ext2_filsys fs,
+					      const char *descr,
+					      int default_type,
+					      const char *profile_name,
+					      ext2fs_inode_bitmap *ret);
+extern errcode_t e2fsck_allocate_block_bitmap(ext2_filsys fs,
+					      const char *descr,
+					      int default_type,
+					      const char *profile_name,
+					      ext2fs_block_bitmap *ret);
+extern errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs,
+						   const char *descr,
+						   int default_type,
+						   const char *profile_name,
+						   ext2fs_block_bitmap *ret);
+
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
 extern int e2fsck_simple_progress(e2fsck_t ctx, const char *label,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index d225026..5faa093 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -557,6 +557,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb = ctx->fs->super;
 	const char	*old_op;
+	unsigned int	save_type;
 	int		imagic_fs, extent_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
@@ -594,33 +595,38 @@ void e2fsck_pass1(e2fsck_t ctx)
 	/*
 	 * Allocate bitmaps structures
 	 */
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, _("in-use inode map"),
-					      &ctx->inode_used_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(fs, _("in-use inode map"),
+						    EXT2FS_BMAP64_RBTREE,
+						    "inode_used_map",
+						    &ctx->inode_used_map);
 	if (pctx.errcode) {
 		pctx.num = 1;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-				_("directory inode map"), &ctx->inode_dir_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(fs,
+			_("directory inode map"),
+			EXT2FS_BMAP64_AUTODIR,
+			"inode_dir_map", &ctx->inode_dir_map);
 	if (pctx.errcode) {
 		pctx.num = 2;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-			_("regular file inode map"), &ctx->inode_reg_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(fs,
+			_("regular file inode map"), EXT2FS_BMAP64_RBTREE,
+			"inode_reg_map", &ctx->inode_reg_map);
 	if (pctx.errcode) {
 		pctx.num = 6;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	pctx.errcode = ext2fs_allocate_subcluster_bitmap(fs,
-						_("in-use block map"),
-						&ctx->block_found_map);
+	pctx.errcode = e2fsck_allocate_subcluster_bitmap(fs,
+			_("in-use block map"), EXT2FS_BMAP64_RBTREE,
+			"block_found_map", &ctx->block_found_map);
 	if (pctx.errcode) {
 		pctx.num = 1;
 		fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, &pctx);
@@ -628,9 +634,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 		return;
 	}
 	e2fsck_setup_tdb_icount(ctx, 0, &ctx->inode_link_info);
-	if (!ctx->inode_link_info)
+	if (!ctx->inode_link_info) {
+		e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE,
+				       "inode_link_info", &save_type);
 		pctx.errcode = ext2fs_create_icount2(fs, 0, 0, 0,
 						     &ctx->inode_link_info);
+		fs->default_bitmap_type = save_type;
+	}
+
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_ALLOCATE_ICOUNT, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
@@ -1331,8 +1342,9 @@ static void mark_inode_bad(e2fsck_t ctx, ino_t ino)
 	if (!ctx->inode_bad_map) {
 		clear_problem_context(&pctx);
 
-		pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-			    _("bad inode map"), &ctx->inode_bad_map);
+		pctx.errcode = e2fsck_allocate_inode_bitmap(ctx->fs,
+				_("bad inode map"), EXT2FS_BMAP64_RBTREE,
+				"inode_bad_map", &ctx->inode_bad_map);
 		if (pctx.errcode) {
 			pctx.num = 3;
 			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -1353,9 +1365,9 @@ static void alloc_bb_map(e2fsck_t ctx)
 	struct		problem_context pctx;
 
 	clear_problem_context(&pctx);
-	pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-					      _("inode in bad block map"),
-					      &ctx->inode_bb_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(ctx->fs,
+			_("inode in bad block map"), EXT2FS_BMAP64_RBTREE,
+			"inode_bb_map", &ctx->inode_bb_map);
 	if (pctx.errcode) {
 		pctx.num = 4;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -1373,9 +1385,9 @@ static void alloc_imagic_map(e2fsck_t ctx)
 	struct		problem_context pctx;
 
 	clear_problem_context(&pctx);
-	pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-					      _("imagic inode map"),
-					      &ctx->inode_imagic_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(ctx->fs,
+			_("imagic inode map"), EXT2FS_BMAP64_RBTREE,
+			"inode_imagic_map", &ctx->inode_imagic_map);
 	if (pctx.errcode) {
 		pctx.num = 5;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -1400,9 +1412,10 @@ static _INLINE_ void mark_block_used(e2fsck_t ctx, blk64_t block)
 
 	if (ext2fs_fast_test_block_bitmap2(ctx->block_found_map, block)) {
 		if (!ctx->block_dup_map) {
-			pctx.errcode = ext2fs_allocate_block_bitmap(ctx->fs,
-			      _("multiply claimed block map"),
-			      &ctx->block_dup_map);
+			pctx.errcode = e2fsck_allocate_block_bitmap(ctx->fs,
+					_("multiply claimed block map"),
+					EXT2FS_BMAP64_RBTREE, "block_dup_map",
+					&ctx->block_dup_map);
 			if (pctx.errcode) {
 				pctx.num = 3;
 				fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR,
@@ -1500,9 +1513,10 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 
 	/* If ea bitmap hasn't been allocated, create it */
 	if (!ctx->block_ea_map) {
-		pctx->errcode = ext2fs_allocate_block_bitmap(fs,
-						      _("ext attr block map"),
-						      &ctx->block_ea_map);
+		pctx->errcode = e2fsck_allocate_block_bitmap(fs,
+					_("ext attr block map"),
+					EXT2FS_BMAP64_RBTREE, "block_ea_map",
+					&ctx->block_ea_map);
 		if (pctx->errcode) {
 			pctx->num = 2;
 			fix_problem(ctx, PR_1_ALLOCATE_BBITMAP_ERROR, pctx);
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index a9eecd2..93fb630 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -218,8 +218,10 @@ void e2fsck_pass1_dupblocks(e2fsck_t ctx, char *block_buf)
 
 	clear_problem_context(&pctx);
 
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-		      _("multiply claimed inode map"), &inode_dup_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(fs,
+			_("multiply claimed inode map"),
+			EXT2FS_BMAP64_RBTREE, "inode_dup_map",
+			&inode_dup_map);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1B_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 103b155..882950d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -91,6 +91,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	struct check_dir_struct cd;
 	struct dx_dir_info	*dx_dir;
 	struct dx_dirblock_info	*dx_db, *dx_parent;
+	unsigned int		save_type;
 	int			b;
 	int			i, depth;
 	problem_t		code;
@@ -110,11 +111,15 @@ void e2fsck_pass2(e2fsck_t ctx)
 				&ctx->inode_count);
 	if (ctx->inode_count)
 		cd.pctx.errcode = 0;
-	else
+	else {
+		e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE,
+				       "inode_count", &save_type);
 		cd.pctx.errcode = ext2fs_create_icount2(fs,
 						EXT2_ICOUNT_OPT_INCREMENT,
 						0, ctx->inode_link_info,
 						&ctx->inode_count);
+		fs->default_bitmap_type = save_type;
+	}
 	if (cd.pctx.errcode) {
 		fix_problem(ctx, PR_2_ALLOCATE_ICOUNT, &cd.pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 7164aa9..565b8e3 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -74,8 +74,9 @@ void e2fsck_pass3(e2fsck_t ctx)
 	/*
 	 * Allocate some bitmaps to do loop detection.
 	 */
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, _("inode done bitmap"),
-						    &inode_done_map);
+	pctx.errcode = e2fsck_allocate_inode_bitmap(fs, _("inode done bitmap"),
+					EXT2FS_BMAP64_AUTODIR,
+					"inode_done_map", &inode_done_map);
 	if (pctx.errcode) {
 		pctx.num = 2;
 		fix_problem(ctx, PR_3_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -318,7 +319,7 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 			if (inode_loop_detect)
 				ext2fs_clear_inode_bitmap(inode_loop_detect);
 			else {
-				pctx->errcode = ext2fs_allocate_inode_bitmap(fs, _("inode loop detection bitmap"), &inode_loop_detect);
+				pctx->errcode = e2fsck_allocate_inode_bitmap(fs, _("inode loop detection bitmap"), EXT2FS_BMAP64_AUTODIR, "inode_loop_detect", &inode_loop_detect);
 				if (pctx->errcode) {
 					pctx->num = 1;
 					fix_problem(ctx,
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d2a8c80..c38b67a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1002,6 +1002,10 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 	} else
 		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options,
 				      flags, 0, 0, io_ptr, ret_fs);
+
+	if (ret_fs)
+		e2fsck_set_bitmap_type(*ret_fs, EXT2FS_BMAP64_RBTREE,
+				       "default", NULL);
 	return retval;
 }
 
diff --git a/e2fsck/util.c b/e2fsck/util.c
index f00734e..6e3a1dc 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -237,6 +237,7 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	errcode_t	retval;
 	const char	*old_op;
+	unsigned int	save_type;
 
 	if (ctx->invalid_bitmaps) {
 		com_err(ctx->program_name, 0,
@@ -246,7 +247,10 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	}
 
 	old_op = ehandler_operation(_("reading inode and block bitmaps"));
+	e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE, "fs_bitmaps",
+			       &save_type);
 	retval = ext2fs_read_bitmaps(fs);
+	fs->default_bitmap_type = save_type;
 	ehandler_operation(old_op);
 	if (retval) {
 		com_err(ctx->program_name, retval,
@@ -757,3 +761,60 @@ errcode_t e2fsck_mmp_update(ext2_filsys fs)
 
 	return retval;
 }
+
+void e2fsck_set_bitmap_type(ext2_filsys fs, unsigned int default_type,
+			    const char *profile_name, unsigned int *old_type)
+{
+	unsigned type;
+	errcode_t	retval;
+
+	if (old_type)
+		*old_type = fs->default_bitmap_type;
+	profile_get_uint(e2fsck_global_ctx->profile, "bitmaps",
+			 profile_name, 0, default_type, &type);
+	profile_get_uint(e2fsck_global_ctx->profile, "bitmaps",
+			 "all", 0, type, &type);
+	fs->default_bitmap_type = type ? type : default_type;
+}
+
+errcode_t e2fsck_allocate_inode_bitmap(ext2_filsys fs, const char *descr,
+				       int deftype,
+				       const char *name,
+				       ext2fs_inode_bitmap *ret)
+{
+	errcode_t	retval;
+	unsigned int	save_type;
+
+	e2fsck_set_bitmap_type(fs, deftype, name, &save_type);
+	retval = ext2fs_allocate_inode_bitmap(fs, descr, ret);
+	fs->default_bitmap_type = save_type;
+	return retval;
+}
+
+errcode_t e2fsck_allocate_block_bitmap(ext2_filsys fs, const char *descr,
+				       int deftype,
+				       const char *name,
+				       ext2fs_block_bitmap *ret)
+{
+	errcode_t	retval;
+	unsigned int	save_type;
+
+	e2fsck_set_bitmap_type(fs, deftype, name, &save_type);
+	retval = ext2fs_allocate_block_bitmap(fs, descr, ret);
+	fs->default_bitmap_type = save_type;
+	return retval;
+}
+
+errcode_t e2fsck_allocate_subcluster_bitmap(ext2_filsys fs, const char *descr,
+					    int deftype,
+					    const char *name,
+					    ext2fs_block_bitmap *ret)
+{
+	errcode_t	retval;
+	unsigned int	save_type;
+
+	e2fsck_set_bitmap_type(fs, deftype, name, &save_type);
+	retval = ext2fs_allocate_subcluster_bitmap(fs, descr, ret);
+	fs->default_bitmap_type = save_type;
+	return retval;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f2df66e..3f8333f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -291,7 +291,6 @@ struct struct_ext2_filsys {
 /*
  * 64-bit bitmap backend types
  */
