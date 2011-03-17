From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4] Add bitmap configuration interface
Date: Thu, 17 Mar 2011 19:50:20 +0100
Message-ID: <1300387821-21705-4-git-send-email-lczerner@redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1CQSup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2011 14:50:45 -0400
In-Reply-To: <1300387821-21705-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a possibility for user to configure what bitmap backed will be used
for what bitmap. It is also useful for testing and benchmarking
different bitmap backends and its behaviour.

Setting can be done via usual config file with new section [bitmaps]
with subnames defining particular bitmaps. Argument is simply number of
the backend. All backends are defined in ext2fsP.h like this:

enum ext2fs_bmap_backends {
		EXT2FS_BMAP64_BITARRAY = 0,
		EXT2FS_BMAP64_RBTREE,
		EXT2FS_BMAP64_COUNT,
};

Here is an example of bitmap configuration, with the list of all
supported bitmaps.

[bitmaps]
	generic_bitmap = 1
	inode_used_map = 1
	inode_bad_map = 1
	inode_dir_map = 0
	inode_bb_map = 1
	inode_imagic_map = 0
	inode_reg_map = 1
	block_found_map = 0
	block_dup_map = 1
	block_ea_map = 0
	empty_dir_blocks = 1
	empty_dir_map = 0
	block_bitmap = 0
	inode_bitmap = 1
	check_desc_map = 0
	bad_block_map = 1
	touched_map = 0
	block_scramble_map = 1
	block_to_move = 0
	block_reserved = 1
	block_meta_data = 0
	inode_dup_map = 1
	inode_done_map = 0
	inode_loop_map = 1

Note that EXT2FS_BMAP64_BITARRAY is still left as a default bitmap
backend, so nothing is changed for the user, unless bitmap configuration
section is used.

This feature requires interface change of ext2fs_alloc_generic_bmap()
and its definition now is:

errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
				    int type, __u64 start, __u64 end,
				    __u64 real_end,
				    ext2fs_generic_bitmap *ret)

Also note that this does work for 64-bit bitmaps only.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/emptydir.c         |    4 +-
 e2fsck/pass1.c            |   18 ++++----
 e2fsck/pass1b.c           |    2 +-
 e2fsck/pass3.c            |    6 ++-
 e2fsck/pass5.c            |    4 +-
 e2fsck/unix.c             |    7 +++
 lib/ext2fs/Makefile.in    |   17 ++++++-
 lib/ext2fs/bitmaps.c      |   21 +++++----
 lib/ext2fs/check_desc.c   |    2 +-
 lib/ext2fs/ext2fs.h       |   36 +++++++++++++-
 lib/ext2fs/ext2fsP.h      |    8 ++-
 lib/ext2fs/gen_bitmap64.c |  118 ++++++++++++++++++++++++++++++++++++++++++++-
 lib/ext2fs/icount.c       |    5 +-
 lib/ext2fs/initialize.c   |   18 ++-----
 lib/ext2fs/rw_bitmaps.c   |   17 ++-----
 lib/ext2fs/tst_iscan.c    |    6 +-
 misc/e2image.c            |    4 +-
 misc/tune2fs.c            |    2 +-
 resize/resize2fs.c        |    6 +-
 19 files changed, 227 insertions(+), 74 deletions(-)

diff --git a/e2fsck/emptydir.c b/e2fsck/emptydir.c
index cf9b521..10dd3a7 100644
--- a/e2fsck/emptydir.c
+++ b/e2fsck/emptydir.c
@@ -53,12 +53,12 @@ empty_dir_info init_empty_dir(e2fsck_t ctx)
 	if (retval)
 		goto errout;
 
-	retval = ext2fs_allocate_block_bitmap(ctx->fs, _("empty dirblocks"),
+	retval = ext2fs_allocate_block_bitmap(ctx->fs, EXT2_EMPTY_DIR_BLOCKS,
 					      &edi->empty_dir_blocks);
 	if (retval)
 		goto errout;
 
-	retval = ext2fs_allocate_inode_bitmap(ctx->fs, _("empty dir map"),
+	retval = ext2fs_allocate_inode_bitmap(ctx->fs, EXT2_EMPTY_DIR_MAP,
 					      &edi->dir_map);
 	if (retval)
 		goto errout;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67dd986..7c2792c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -593,7 +593,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	/*
 	 * Allocate bitmaps structures
 	 */
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, _("in-use inode map"),
+	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, EXT2_INODE_USED_MAP,
 					      &ctx->inode_used_map);
 	if (pctx.errcode) {
 		pctx.num = 1;
@@ -602,7 +602,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		return;
 	}
 	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-				_("directory inode map"), &ctx->inode_dir_map);
+				EXT2_INODE_DIR_MAP, &ctx->inode_dir_map);
 	if (pctx.errcode) {
 		pctx.num = 2;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -610,14 +610,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 		return;
 	}
 	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-			_("regular file inode map"), &ctx->inode_reg_map);
+			EXT2_INODE_REG_MAP, &ctx->inode_reg_map);
 	if (pctx.errcode) {
 		pctx.num = 6;
 		fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	pctx.errcode = ext2fs_allocate_block_bitmap(fs, _("in-use block map"),
+	pctx.errcode = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_FOUND_MAP,
 					      &ctx->block_found_map);
 	if (pctx.errcode) {
 		pctx.num = 1;
@@ -1271,7 +1271,7 @@ static void mark_inode_bad(e2fsck_t ctx, ino_t ino)
 		clear_problem_context(&pctx);
 
 		pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-			    _("bad inode map"), &ctx->inode_bad_map);
+			    EXT2_INODE_BAD_MAP, &ctx->inode_bad_map);
 		if (pctx.errcode) {
 			pctx.num = 3;
 			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
@@ -1293,7 +1293,7 @@ static void alloc_bb_map(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 	pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-					      _("inode in bad block map"),
+					      EXT2_INODE_BB_MAP,
 					      &ctx->inode_bb_map);
 	if (pctx.errcode) {
 		pctx.num = 4;
@@ -1313,7 +1313,7 @@ static void alloc_imagic_map(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 	pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-					      _("imagic inode map"),
+					      EXT2_INODE_IMAGIC_MAP,
 					      &ctx->inode_imagic_map);
 	if (pctx.errcode) {
 		pctx.num = 5;
@@ -1340,7 +1340,7 @@ static _INLINE_ void mark_block_used(e2fsck_t ctx, blk64_t block)
 	if (ext2fs_fast_test_block_bitmap2(ctx->block_found_map, block)) {
 		if (!ctx->block_dup_map) {
 			pctx.errcode = ext2fs_allocate_block_bitmap(ctx->fs,
-			      _("multiply claimed block map"),
+			      EXT2_BLOCK_DUP_MAP,
 			      &ctx->block_dup_map);
 			if (pctx.errcode) {
 				pctx.num = 3;
@@ -1440,7 +1440,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	/* If ea bitmap hasn't been allocated, create it */
 	if (!ctx->block_ea_map) {
 		pctx->errcode = ext2fs_allocate_block_bitmap(fs,
-						      _("ext attr block map"),
+						      EXT2_BLOCK_EA_MAP,
 						      &ctx->block_ea_map);
 		if (pctx->errcode) {
 			pctx->num = 2;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 155fcba..95c7bea 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -217,7 +217,7 @@ void e2fsck_pass1_dupblocks(e2fsck_t ctx, char *block_buf)
 	clear_problem_context(&pctx);
 
 	pctx.errcode = ext2fs_allocate_inode_bitmap(fs,
-		      _("multiply claimed inode map"), &inode_dup_map);
+		      EXT2_INODE_DUP_MAP, &inode_dup_map);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1B_ALLOCATE_IBITMAP_ERROR, &pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index c067164..0ac7282 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -73,7 +73,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 	/*
 	 * Allocate some bitmaps to do loop detection.
 	 */
-	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, _("inode done bitmap"),
+	pctx.errcode = ext2fs_allocate_inode_bitmap(fs, EXT2_INODE_DONE_MAP,
 						    &inode_done_map);
 	if (pctx.errcode) {
 		pctx.num = 2;
@@ -317,7 +317,9 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 			if (inode_loop_detect)
 				ext2fs_clear_inode_bitmap(inode_loop_detect);
 			else {
-				pctx->errcode = ext2fs_allocate_inode_bitmap(fs, _("inode loop detection bitmap"), &inode_loop_detect);
+				pctx->errcode = ext2fs_allocate_inode_bitmap(fs,
+					EXT2_INODE_LOOP_MAP,
+					&inode_loop_detect);
 				if (pctx->errcode) {
 					pctx->num = 1;
 					fix_problem(ctx,
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index b423d28..8a9df37 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -272,7 +272,7 @@ redo_counts:
 		else
 			bitmap = ext2fs_fast_test_block_bitmap2(fs->block_map, i);
 
-		if (actual == bitmap)
+		if ((actual && bitmap) || (!actual && !bitmap))
 			goto do_counts;
 
 		if (!actual && bitmap) {
@@ -504,7 +504,7 @@ redo_counts:
 			bitmap = actual;
 		else if (!skip_group)
 			bitmap = ext2fs_fast_test_inode_bitmap2(fs->inode_map, i);
-		if (actual == bitmap)
+		if ((actual && bitmap) || (!actual && !bitmap))
 			goto do_counts;
 
 		if (!actual && bitmap) {
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 73cc2cf..f883a6a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -860,6 +860,13 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	profile_set_syntax_err_cb(syntax_err_report);
 	profile_init(config_fn, &ctx->profile);
 
+	retval = ext2fs_prepare_bmap_definitions(ctx->profile);
+	if (retval) {
+		com_err("ext2fs_prepare_bmap_definitions", retval,
+			_("while setting bitmaps"));
+		fatal_error(ctx, 0);
+	}
+
 	if (flush) {
 		fd = open(ctx->filesystem_name, O_RDONLY, 0);
 		if (fd < 0) {
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 29d1994..cd6c470 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -82,7 +82,8 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	unlink.o \
 	valid_blk.o \
 	version.o \
-	rbtree.o
+	rbtree.o \
+	profile.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -160,6 +161,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/version.c \
 	$(srcdir)/write_bb_file.c \
 	$(srcdir)/rbtree.c \
+	$(top_srcdir)/e2fsck/profile.c
+
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h
@@ -200,6 +203,15 @@ COMPILE_ET=../et/compile_et --build-tree
 
 DISTFILES= Makefile *.c *.h image
 
+profile.o:
+	$(E) "	CC $<"
+	$(Q) $(COMPILE_ET) $(top_srcdir)/e2fsck/prof_err.et
+	$(Q) $(CP) -f $(srcdir)/prof_err.h $(top_srcdir)/e2fsck/
+	$(Q) $(CC) -c $(ALL_CFLAGS) $(top_srcdir)/e2fsck/profile.c -o $@
+@PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/profile.o -c \
+@PROFILE_CMT@	$(top_srcdir)/e2fsck/profile.c
+
+
 ext2_err.et: $(DEP_SUBSTITUTE) $(srcdir)/ext2_err.et.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE) $(srcdir)/ext2_err.et.in ext2_err.et
@@ -387,7 +399,8 @@ clean::
 mostlyclean:: clean
 distclean:: clean
 	$(RM) -f .depend ext2_err.c ext2_err.h Makefile ext2fs.pc \
-		$(srcdir)/TAGS $(srcdir)/Makefile.in.old
+		$(srcdir)/TAGS $(srcdir)/Makefile.in.old \
+		$(srcdir)/prof_err.h
 #
 # Hack to parallel makes recognize dependencies correctly.
 #
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index c53d61e..4063f47 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -48,13 +48,15 @@ void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
 	ext2fs_set_generic_bmap_padding(map);
 }
 
-errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
-				       const char *descr,
+errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs, int type,
 				       ext2fs_inode_bitmap *ret)
 {
 	__u64		start, end, real_end;
+	int backend;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+	if (type >= EXT2_BMAP_COUNT || type < 0)
+		return EINVAL;
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
@@ -66,8 +68,7 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 	if (fs->flags & EXT2_FLAG_64BITS)
 		return (ext2fs_alloc_generic_bmap(fs,
 				  EXT2_ET_MAGIC_INODE_BITMAP64,
-				  EXT2FS_BMAP64_BITARRAY,
-				  start, end, real_end, descr, ret));
+				  type, start, end, real_end, ret));
 
 	/* Otherwise, check to see if the file system is small enough
 	 * to use old-style 32-bit bitmaps */
@@ -76,17 +77,20 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_INODE_BITMAP, fs,
 					 start, end, real_end,
-					 descr, 0,
+					 NULL, 0,
 					 (ext2fs_generic_bitmap *) ret));
 }
 
 errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
-				       const char *descr,
+				       int type,
 				       ext2fs_block_bitmap *ret)
 {
 	__u64		start, end, real_end;
+	int backend;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+	if (type >= EXT2_BMAP_COUNT || type < 0)
+		return EINVAL;
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
@@ -98,15 +102,14 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 	if (fs->flags & EXT2_FLAG_64BITS)
 		return (ext2fs_alloc_generic_bmap(fs,
 				  EXT2_ET_MAGIC_BLOCK_BITMAP64,
-				  EXT2FS_BMAP64_BITARRAY,
-				  start, end, real_end, descr, ret));
+				  type, start, end, real_end, ret));
 
 	if ((end > ~0U) || (real_end > ~0U))
 		return EXT2_ET_CANT_USE_LEGACY_BITMAPS;
 
 	return (ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_BLOCK_BITMAP, fs,
 					   start, end, real_end,
-					   descr, 0,
+					   NULL, 0,
 					   (ext2fs_generic_bitmap *) ret));
 }
 
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 7929cd9..85b6adb 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -41,7 +41,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
-	retval = ext2fs_allocate_block_bitmap(fs, "check_desc map", &bmap);
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_CHECK_DESC_MAP, &bmap);
 	if (retval)
 		return retval;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a204eb7..8621bf6 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -562,6 +562,37 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(0)
 
+
+enum ext2_bitmap_type {
+	EXT2_GENERIC_MAP		=0,
+	EXT2_INODE_USED_MAP,		/* Inodes which are in use */
+	EXT2_INODE_BAD_MAP,		/* Inodes which are bad somehow */
+	EXT2_INODE_DIR_MAP,		/* Inodes which are directories */
+	EXT2_INODE_BB_MAP,		/* Inodes which are in bad blocks */
+	EXT2_INODE_IMAGIC_MAP,		/* AFS inodes */
+	EXT2_INODE_REG_MAP,		/* Inodes which are regular files*/
+	EXT2_INODE_MAP,
+	EXT2_INODE_DUP_MAP,
+	EXT2_INODE_DONE_MAP,
+	EXT2_INODE_LOOP_MAP,
+
+	EXT2_BLOCK_FOUND_MAP,		/* Blocks which are in use */
+	EXT2_BLOCK_DUP_MAP,		/* Blks referenced more than once */
+	EXT2_BLOCK_EA_MAP,		/* Blocks which are used by EA's */
+	EXT2_BLOCK_MAP,
+	EXT2_BLOCK_BAD_MAP,
+	EXT2_BLOCK_SCRAMBLE,
+	EXT2_BLOCK_TO_MOVE,
+	EXT2_BLOCK_RESERVED,
+	EXT2_BLOCK_METADATA,
+
+	EXT2_EMPTY_DIR_BLOCKS,
+	EXT2_EMPTY_DIR_MAP,
+	EXT2_CHECK_DESC_MAP,
+	EXT2_TOUCHED_MAP,
+	EXT2_BMAP_COUNT,		/* Stop mark */
+};
+
 /*
  * function prototypes
  */
@@ -673,10 +704,10 @@ extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
-					      const char *descr,
+					      int type,
 					      ext2fs_block_bitmap *ret);
 extern errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
-					      const char *descr,
+					      int type,
 					      ext2fs_inode_bitmap *ret);
 extern errcode_t ext2fs_fudge_inode_bitmap_end(ext2fs_inode_bitmap bitmap,
 					       ext2_ino_t end, ext2_ino_t *oend);
@@ -1086,7 +1117,6 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap);
 errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 				    int type, __u64 start, __u64 end,
 				    __u64 real_end,
-				    const char *descr,
 				    ext2fs_generic_bitmap *ret);
 errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 				   ext2fs_generic_bitmap *dest);
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index aa45c43..0a620d4 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -107,13 +107,15 @@ extern void ext2fs_numeric_progress_close(ext2_filsys fs,
  * 64-bit bitmap support
  */
 
-#define EXT2FS_BMAP64_BITARRAY	1
-#define EXT2FS_BMAP64_RBTREE	2
+enum ext2fs_bmap_backends {
+	EXT2FS_BMAP64_BITARRAY = 0,
+	EXT2FS_BMAP64_RBTREE,
+	EXT2FS_BMAP64_COUNT,
+};
 
 extern errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 					   int type, __u64 start, __u64 end,
 					   __u64 real_end,
-					   const char * description,
 					   ext2fs_generic_bitmap *bmap);
 
 extern void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap);
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 84065ea..4c69244 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -28,6 +28,7 @@
 #include "ext2_fs.h"
 #include "ext2fsP.h"
 #include "bmap64.h"
+#include "profile.h"
 
 /*
  * Design of 64-bit bitmaps
@@ -77,17 +78,128 @@ static void warn_bitmap(ext2fs_generic_bitmap bitmap,
 }
 
 
+#define EXT2_DEFAULT_BITMAP_BACKEND EXT2FS_BMAP64_BITARRAY
+
+static char *ext2_bmap_profile_value[EXT2_BMAP_COUNT] = {
+	[EXT2_GENERIC_MAP] = "generic_bitmap",
+	[EXT2_INODE_USED_MAP] = "inode_used_map",
+	[EXT2_INODE_BAD_MAP] = "inode_bad_map",
+	[EXT2_INODE_DIR_MAP] = "inode_dir_map",
+	[EXT2_INODE_BB_MAP] = "inode_bb_map",
+	[EXT2_INODE_IMAGIC_MAP] = "inode_imagic_map",
+	[EXT2_INODE_REG_MAP] = "inode_reg_map",
+	[EXT2_INODE_MAP] = "inode_bitmap",
+	[EXT2_INODE_DUP_MAP] = "inode_dup_map",
+	[EXT2_INODE_DONE_MAP] = "inode_done_map",
+	[EXT2_INODE_LOOP_MAP] = "inode_loop_map",
+
+	[EXT2_BLOCK_FOUND_MAP] = "block_found_map",
+	[EXT2_BLOCK_DUP_MAP] = "block_dup_map",
+	[EXT2_BLOCK_EA_MAP] = "block_ea_map",
+	[EXT2_BLOCK_MAP] = "block_bitmap",
+	[EXT2_BLOCK_BAD_MAP] = "bad_block_map",
+	[EXT2_BLOCK_SCRAMBLE] = "block_scramble_map",
+	[EXT2_BLOCK_TO_MOVE] = "block_to_move",
+	[EXT2_BLOCK_RESERVED] = "block_reserved",
+	[EXT2_BLOCK_METADATA] = "block_meta_data",
+
+	[EXT2_EMPTY_DIR_BLOCKS] = "empty_dir_blocks",
+	[EXT2_EMPTY_DIR_MAP] = "empty_dir_map",
+	[EXT2_CHECK_DESC_MAP] = "check_desc_map",
+	[EXT2_TOUCHED_MAP] = "touched_map",
+};
+
+struct ext2_bmap_definition {
+	int backend;
+	char *descr;
+};
+
+const
+static struct ext2_bmap_definition ext2_bmap_default[EXT2_BMAP_COUNT] = {
+	[EXT2_GENERIC_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "generic bitmap"},
+	[EXT2_INODE_USED_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "in-use inode map"},
+	[EXT2_INODE_BAD_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "bad inode map"},
+	[EXT2_INODE_DIR_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "directory inode map"},
+	[EXT2_INODE_BB_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "inode in bad block map"},
+	[EXT2_INODE_IMAGIC_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "imagic inode map"},
+	[EXT2_INODE_REG_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "regular file inode map"},
+	[EXT2_INODE_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "inode bitmap"},
+	[EXT2_INODE_DUP_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "multiply claimed inode map"},
+	[EXT2_INODE_DONE_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "inode done bitmap"},
+	[EXT2_INODE_LOOP_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "inode loop detection bitmap"},
+
+	[EXT2_BLOCK_FOUND_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "in-use block map"},
+	[EXT2_BLOCK_DUP_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND,"multiply claimed block map"},
+	[EXT2_BLOCK_EA_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "ext attr block map"},
+	[EXT2_BLOCK_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "block bitmap"},
+	[EXT2_BLOCK_BAD_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "bad block map"},
+	[EXT2_BLOCK_SCRAMBLE] = {EXT2_DEFAULT_BITMAP_BACKEND, "scrambled block map"},
+	[EXT2_BLOCK_TO_MOVE] = {EXT2_DEFAULT_BITMAP_BACKEND, "blocks to be moved"},
+	[EXT2_BLOCK_RESERVED] = {EXT2_DEFAULT_BITMAP_BACKEND, "reserved blocks"},
+	[EXT2_BLOCK_METADATA] = {EXT2_DEFAULT_BITMAP_BACKEND, "meta-data blocks"},
+
+	[EXT2_EMPTY_DIR_BLOCKS] = {EXT2_DEFAULT_BITMAP_BACKEND, "empty dir blocks"},
+	[EXT2_EMPTY_DIR_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "empty dir map"},
+	[EXT2_CHECK_DESC_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "check desc map"},
+	[EXT2_TOUCHED_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "touched map"},
+};
+
+static struct ext2_bmap_definition *bmap_defs = NULL;
+
+errcode_t ext2fs_prepare_bmap_definitions(profile_t profile)
+{
+	char	*cp;
+	errcode_t retval = 0;
+	int i, backend;
+
+	if (!bmap_defs)
+		retval = ext2fs_get_mem(EXT2_BMAP_COUNT *
+					sizeof(struct ext2_bmap_definition),
+					&bmap_defs);
+	if (retval)
+		return retval;
+
+	for (i = 0; i < EXT2_BMAP_COUNT; i++) {
+		retval = profile_get_integer(profile, "bitmaps",
+					     ext2_bmap_profile_value[i],
+					     NULL, ext2_bmap_default[i].backend,
+					     &backend);
+		if (retval)
+			goto out;
+
+		if (backend >= EXT2FS_BMAP64_COUNT ||
+		    backend < 0)
+			backend = ext2_bmap_default[i].backend;
+
+		bmap_defs[i].backend = backend;
+		bmap_defs[i].descr = ext2_bmap_default[i].descr;
+	}
+
+	if (retval)
+		ext2fs_free_mem(bmap_defs);
+
+out:
+	return retval;
+}
+
 errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 				    int type, __u64 start, __u64 end,
 				    __u64 real_end,
-				    const char *descr,
 				    ext2fs_generic_bitmap *ret)
 {
 	ext2fs_generic_bitmap	bitmap;
 	struct ext2_bitmap_ops	*ops;
 	errcode_t retval;
+	char *descr = NULL;
+	int backend;
+
+	if (!bmap_defs)
+		ext2fs_prepare_bmap_definitions(NULL);
+
+	descr = bmap_defs[type].descr;
+	backend = bmap_defs[type].backend;
 
-	switch (type) {
+	switch (backend) {
 	case EXT2FS_BMAP64_BITARRAY:
 		ops = &ext2fs_blkmap64_bitarray;
 		break;
@@ -102,6 +214,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 				&bitmap);
 	if (retval)
 		return retval;
+	memset(bitmap, 0, sizeof(struct ext2fs_struct_generic_bitmap));
 
 	/* XXX factor out, repeated in copy_bmap */
 	bitmap->magic = magic;
@@ -185,6 +298,7 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 				&new_bmap);
 	if (retval)
 		return retval;
+	memset(new_bmap, 0, sizeof(struct ext2fs_struct_generic_bitmap));
 
 	/* Copy all the high-level parts over */
 	new_bmap->magic = src->magic;
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 43cc53e..f6b1646 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -103,12 +103,13 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 		return retval;
 	memset(icount, 0, sizeof(struct ext2_icount));
 
-	retval = ext2fs_allocate_inode_bitmap(fs, 0, &icount->single);
+	retval = ext2fs_allocate_inode_bitmap(fs, EXT2_GENERIC_MAP,
+					      &icount->single);
 	if (retval)
 		goto errout;
 
 	if (flags & EXT2_ICOUNT_OPT_INCREMENT) {
-		retval = ext2fs_allocate_inode_bitmap(fs, 0,
+		retval = ext2fs_allocate_inode_bitmap(fs, EXT2_GENERIC_MAP,
 						      &icount->multiple);
 		if (retval)
 			goto errout;
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 4cf0863..dd1df1d 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -96,7 +96,6 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	int		rsv_gdt;
 	int		csum_flag;
 	int		io_flags;
-	char		*buf = 0;
 	char		c;
 
 	if (!param || !ext2fs_blocks_count(param))
@@ -359,24 +358,16 @@ ipg_retry:
 	 * count.
 	 */
 
-	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_MAP,
+					      &fs->block_map);
 	if (retval)
 		goto cleanup;
 
-	strcpy(buf, "block bitmap for ");
-	strcat(buf, fs->device_name);
-	retval = ext2fs_allocate_block_bitmap(fs, buf, &fs->block_map);
+	retval = ext2fs_allocate_inode_bitmap(fs, EXT2_INODE_MAP,
+					      &fs->inode_map);
 	if (retval)
 		goto cleanup;
 
-	strcpy(buf, "inode bitmap for ");
-	strcat(buf, fs->device_name);
-	retval = ext2fs_allocate_inode_bitmap(fs, buf, &fs->inode_map);
-	if (retval)
-		goto cleanup;
-
-	ext2fs_free_mem(&buf);
-
 	retval = ext2fs_get_array(fs->desc_blocks, fs->blocksize,
 				&fs->group_desc);
 	if (retval)
@@ -442,7 +433,6 @@ ipg_retry:
 	*ret_fs = fs;
 	return 0;
 cleanup:
-	free(buf);
 	ext2fs_free(fs);
 	return retval;
 }
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 3031b7d..83feb87 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -139,7 +139,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 {
 	dgrp_t i;
 	char *block_bitmap = 0, *inode_bitmap = 0;
-	char *buf;
 	errcode_t retval;
 	int block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
@@ -160,15 +159,11 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
 
-	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
-	if (retval)
-		return retval;
 	if (do_block) {
 		if (fs->block_map)
 			ext2fs_free_block_bitmap(fs->block_map);
-		strcpy(buf, "block bitmap for ");
-		strcat(buf, fs->device_name);
-		retval = ext2fs_allocate_block_bitmap(fs, buf, &fs->block_map);
+		retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_MAP,
+						      &fs->block_map);
 		if (retval)
 			goto cleanup;
 		if (do_image)
@@ -185,9 +180,8 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (do_inode) {
 		if (fs->inode_map)
 			ext2fs_free_inode_bitmap(fs->inode_map);
-		strcpy(buf, "inode bitmap for ");
-		strcat(buf, fs->device_name);
-		retval = ext2fs_allocate_inode_bitmap(fs, buf, &fs->inode_map);
+		retval = ext2fs_allocate_inode_bitmap(fs, EXT2_INODE_MAP,
+						      &fs->inode_map);
 		if (retval)
 			goto cleanup;
 		retval = ext2fs_get_mem(do_image ? fs->blocksize :
@@ -196,7 +190,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			goto cleanup;
 	} else
 		inode_nbytes = 0;
-	ext2fs_free_mem(&buf);
 
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE) {
 		blk = (fs->image_header->offset_inodemap / fs->blocksize);
@@ -306,8 +299,6 @@ cleanup:
 		ext2fs_free_mem(&inode_bitmap);
 	if (block_bitmap)
 		ext2fs_free_mem(&block_bitmap);
-	if (buf)
-		ext2fs_free_mem(&buf);
 	return retval;
 }
 
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 64246d3..7795497 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -95,21 +95,21 @@ static void setup(void)
 			"While allocating tables for test filesystem");
 		exit(1);
 	}
-	retval = ext2fs_allocate_block_bitmap(test_fs, "bad block map",
+	retval = ext2fs_allocate_block_bitmap(test_fs, EXT2_BLOCK_BAD_MAP,
 					      &bad_block_map);
 	if (retval) {
 		com_err("setup", retval,
 			"While allocating bad_block bitmap");
 		exit(1);
 	}
-	retval = ext2fs_allocate_block_bitmap(test_fs, "touched map",
+	retval = ext2fs_allocate_block_bitmap(test_fs, EXT2_TOUCHED_MAP,
 					      &touched_map);
 	if (retval) {
 		com_err("setup", retval,
 			"While allocating touched block bitmap");
 		exit(1);
 	}
-	retval = ext2fs_allocate_inode_bitmap(test_fs, "bad inode map",
+	retval = ext2fs_allocate_inode_bitmap(test_fs, EXT2_INODE_BAD_MAP,
 					      &bad_inode_map);
 	if (retval) {
 		com_err("setup", retval,
diff --git a/misc/e2image.c b/misc/e2image.c
index 003ac5a..0e4b2a5 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -465,7 +465,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 	errcode_t			retval;
 	char *				block_buf;
 
-	retval = ext2fs_allocate_block_bitmap(fs, "in-use block map",
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_FOUND_MAP,
 					      &meta_block_map);
 	if (retval) {
 		com_err(program_name, retval, "while allocating block bitmap");
@@ -473,7 +473,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 	}
 
 	if (scramble_flag) {
-		retval = ext2fs_allocate_block_bitmap(fs, "scramble block map",
+		retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_SCRAMBLE,
 						      &scramble_block_map);
 		if (retval) {
 			com_err(program_name, retval,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..a2a980a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1472,7 +1472,7 @@ static int resize_inode(ext2_filsys fs, unsigned long new_size)
 	 */
 	fs->super->s_state &= ~EXT2_VALID_FS;
 
-	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_TO_MOVE,
 						&bmap);
 	if (retval) {
 		fputs(_("Failed to allocate block bitmap when "
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 216a626..26ebb30 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -580,7 +580,7 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	ext2fs_mark_bb_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
 
-	retval = ext2fs_allocate_block_bitmap(fs, _("reserved blocks"),
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_RESERVED,
 					      &rfs->reserve_blocks);
 	if (retval)
 		return retval;
@@ -788,12 +788,12 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	if (ext2fs_blocks_count(old_fs->super) > ext2fs_blocks_count(fs->super))
 		fs = rfs->old_fs;
 
-	retval = ext2fs_allocate_block_bitmap(fs, _("blocks to be moved"),
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_TO_MOVE,
 					      &rfs->move_blocks);
 	if (retval)
 		return retval;
 
-	retval = ext2fs_allocate_block_bitmap(fs, _("meta-data blocks"),
+	retval = ext2fs_allocate_block_bitmap(fs, EXT2_BLOCK_METADATA,
 					      &meta_bmap);
 	if (retval)
 		return retval;
-- 
1.7.4

