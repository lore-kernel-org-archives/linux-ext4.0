From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 4/4] Initial checkin for new extents API
Date: Sun, 16 Sep 2007 22:57:41 -0400
Message-ID: <11899978623484-git-send-email-tytso@mit.edu>
References: <1189997861181-git-send-email-tytso@mit.edu>
 <11899978613069-git-send-email-tytso@mit.edu>
 <11899978612166-git-send-email-tytso@mit.edu>
 <11899978613124-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33744 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbXIQC5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2007 22:57:48 -0400
In-Reply-To: <11899978613124-git-send-email-tytso@mit.edu>
Message-Id: <ef3b0e3bf2b4bf168b39995aa3ad0e0c51d28caf.1189997130.git.tytso@mit.edu>
In-Reply-To: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
References: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Initial implemenation of extents support for e2fsprogs.  This is enough
so that e2fsck will pass a valid filesystem containing extents.

Eventually this will be split into a patch for the library changes, and
a separate patch for e2fsck, followed by test cases for e2fsprogs.
---
 e2fsck/message.c          |    2 +
 e2fsck/pass1.c            |   86 ++++++-
 e2fsck/problem.c          |    5 +
 e2fsck/problem.h          |    3 +
 lib/ext2fs/Makefile.in    |   68 +++++-
 lib/ext2fs/ext2_err.et.in |   40 +++-
 lib/ext2fs/ext2fs.h       |   62 +++++-
 lib/ext2fs/ext3_extents.h |   20 ++
 lib/ext2fs/extent.c       |  616 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/extent_dbg.ct  |   32 +++
 10 files changed, 926 insertions(+), 8 deletions(-)
 create mode 100644 lib/ext2fs/extent.c
 create mode 100644 lib/ext2fs/extent_dbg.ct

diff --git a/e2fsck/message.c b/e2fsck/message.c
index b2e3e0f..accf3a0 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -80,6 +80,7 @@
  * 	@S	superblock
  * 	@u	unattached
  * 	@v	device
+ *	@x	extent
  * 	@z	zero-length
  */
 
@@ -134,6 +135,7 @@ static const char *abbrevs[] = {
 	N_("Ssuper@b"),
 	N_("uunattached"),
 	N_("vdevice"),
+	N_("xextent"),
 	N_("zzero-length"),
 	"@@",
 	0
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7fba823..f9b7ea3 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -908,10 +908,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_dind_count++;
 		if (inode->i_block[EXT2_TIND_BLOCK])
 			ctx->fs_tind_count++;
-		if (inode->i_block[EXT2_IND_BLOCK] ||
-		    inode->i_block[EXT2_DIND_BLOCK] ||
-		    inode->i_block[EXT2_TIND_BLOCK] ||
-		    inode->i_file_acl) {
+		if (!(inode->i_flags & EXT4_EXTENTS_FL) &&
+		    (inode->i_block[EXT2_IND_BLOCK] ||
+		     inode->i_block[EXT2_DIND_BLOCK] ||
+		     inode->i_block[EXT2_TIND_BLOCK] ||
+		     inode->i_file_acl)) {
 			inodes_to_process[process_inode_count].ino = ino;
 			inodes_to_process[process_inode_count].inode = *inode;
 			process_inode_count++;
@@ -1488,6 +1489,78 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 	e2fsck_write_inode(ctx, ino, inode, source);
 }
 
+static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
+			     ext2_extent_handle_t ehandle)
+{
+	struct ext2fs_extent	extent;
+	blk_t			blk;
+	e2_blkcnt_t		blockcnt;
+	int			i;
+	int			is_dir, is_leaf;
+
+
+	pctx->errcode = ext2fs_extent_get(ehandle, EXT2_EXTENT_FIRST_SIB,
+					  &extent);
+	while (!pctx->errcode) {
+		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
+		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
+
+		if (!is_leaf) {
+			mark_block_used(ctx, extent.e_pblk);
+			pctx->errcode = ext2fs_extent_get(ehandle, 
+						  EXT2_EXTENT_DOWN, &extent);
+			scan_extent_node(ctx, pctx, ehandle);
+			pctx->errcode = ext2fs_extent_get(ehandle, 
+						  EXT2_EXTENT_UP, &extent);
+			goto next;
+		}
+			
+		for (blk = extent.e_pblk, blockcnt = extent.e_lblk, i = 0;
+		     i < extent.e_len;
+		     blk++, blockcnt++, i++) {
+			mark_block_used(ctx, blk);
+
+			if (is_dir) {
+				pctx->errcode = ext2fs_add_dir_block(ctx->fs->dblist, pctx->ino, blk, blockcnt);
+				if (pctx->errcode) {
+					pctx->blk = blk;
+					pctx->num = blockcnt;
+					fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
+					/* Should never get here */
+					ctx->flags |= E2F_FLAG_ABORT;
+					return;
+				}
+			}
+		}
+	next:
+		pctx->errcode = ext2fs_extent_get(ehandle, 
+						  EXT2_EXTENT_NEXT_SIB,
+						  &extent);
+	}
+}
+
+
+static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
+				 char *block_buf)
+{
+	struct ext2_inode	*inode = pctx->inode;
+	ext2_extent_handle_t	ehandle;
+	ext2_filsys		fs = ctx->fs;
+	ext2_ino_t		ino = pctx->ino;
+
+	pctx->errcode = ext2fs_extent_open(fs, ino, &ehandle);
+	if (pctx->errcode &&
+	    fix_problem(ctx, PR_1_READ_EXTENT, pctx)) {
+		e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks_extents");
+		return;
+	}
+
+	scan_extent_node(ctx, pctx, ehandle);
+
+	ext2fs_extent_free(ehandle);
+	
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -1503,6 +1576,11 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	int		dirty_inode = 0;
 	__u64		size;
 	
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		check_blocks_extents(ctx, pctx, block_buf);
+		return;
+	}
+
 	pb.ino = ino;
 	pb.num_blocks = 0;
 	pb.last_block = -1;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0b6fd39..8c8be7e 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -784,6 +784,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i is a %It but it looks like it is really a directory.\n"),
 	  PROMPT_FIX, 0 },
 
+	/* Error while reading extent tree */
+	{ PR_1_READ_EXTENT,
+	  N_("Error while reading over @x tree in @i %i: %m\n"),
+	  PROMPT_CLEAR_INODE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f5f7212..538dee2 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -455,6 +455,9 @@ struct problem_context {
 /* inode appears to be a directory */
 #define PR_1_TREAT_AS_DIRECTORY		0x010055
 
+/* Error while reading extent tree */
+#define PR_1_READ_EXTENT		0x010056
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 03ce131..f3edbf7 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -10,6 +10,8 @@ INSTALL = @INSTALL@
 @DEBUGFS_CMT@DEBUGFS_LIB_OBJS = bb_compat.o fileio.o \
 @DEBUGFS_CMT@	inode_io.o namei.o write_bb_file.o 
 
+MK_CMDS=	_SS_DIR_OVERRIDE=../ss ../ss/mk_cmds
+
 @RESIZER_CMT@RESIZE_LIB_OBJS = dupfs.o test_io.o 
 
 @IMAGER_CMT@E2IMAGE_LIB_OBJS = imager.o
@@ -35,6 +37,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	dir_iterate.o \
 	expanddir.o \
 	ext_attr.o \
+	extent.o \
 	finddev.o \
 	flushb.o \
 	freefs.o \
@@ -90,6 +93,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/dupfs.c \
 	$(srcdir)/expanddir.c \
 	$(srcdir)/ext_attr.c \
+	$(srcdir)/extent.c \
 	$(srcdir)/fileio.c \
 	$(srcdir)/finddev.c \
 	$(srcdir)/flushb.c \
@@ -239,6 +243,68 @@ ext2_tdbtool: tdbtool.o
 	@echo "	LD $@"
 	@$(CC) -o ext2_tdbtool tdbtool.o tdb.o
 
+extent_dbg.c: $(srcdir)/extent_dbg.ct
+	@echo "	MK_CMDS $<"
+	@$(MK_CMDS) $(srcdir)/extent_dbg.ct
+
+debug_cmds.c debug_cmds.h: $(top_srcdir)/debugfs/debug_cmds.ct
+	@echo "	MK_CMDS $<@"
+	@$(MK_CMDS) $(top_srcdir)/debugfs/debug_cmds.ct
+
+DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
+	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o
+
+debugfs.o: $(top_srcdir)/debugfs/debugfs.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+util.o: $(top_srcdir)/debugfs/util.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+ncheck.o: $(top_srcdir)/debugfs/ncheck.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+icheck.o: $(top_srcdir)/debugfs/icheck.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+ls.o: $(top_srcdir)/debugfs/ls.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+lsdel.o: $(top_srcdir)/debugfs/lsdel.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+dump.o: $(top_srcdir)/debugfs/dump.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+set_fields.o: $(top_srcdir)/debugfs/set_fields.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+logdump.o: $(top_srcdir)/debugfs/logdump.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+htree.o: $(top_srcdir)/debugfs/htree.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+unused.o: $(top_srcdir)/debugfs/unused.c
+	@echo "	CC $<"
+	@$(CC) $(ALL_CFLAGS) -c $< -o $@
+
+tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) $(DEPLIBUUID) $(DEPLIBBLKID)
+	@echo "	LD $@"
+	@$(CC) -o tst_extents $(srcdir)/extent.c extent_dbg.c \
+		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
+		$(LIBUUID) $(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBCOM_ERR) \
+		-I $(top_srcdir)/debugfs
+
 mkjournal: mkjournal.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
@@ -282,7 +348,7 @@ clean::
 		tst_badblocks tst_iscan ext2_err.et ext2_err.c ext2_err.h \
 		tst_byteswap tst_ismounted tst_getsize tst_sectgetsize \
 		tst_bitops tst_types tst_icount tst_super_size \
-		ext2_tdbtool mkjournal \
+		ext2_tdbtool mkjournal debug_cmds.c \
 		../libext2fs.a ../libext2fs_p.a ../libext2fs_chk.a
 
 mostlyclean:: clean
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index eda4bb4..5d62548 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -62,8 +62,8 @@ ec	EXT2_ET_MAGIC_E2IMAGE,
 ec	EXT2_ET_MAGIC_INODE_IO_CHANNEL,
 	"Wrong magic number for inode io_channel structure"
 
-ec	EXT2_ET_MAGIC_RESERVED_9,
-	"Wrong magic number --- RESERVED_9"
+ec	EXT2_ET_MAGIC_EXTENT_HANDLE,
+	"Wrong magic number for ext4 extent handle"
 
 ec	EXT2_ET_BAD_MAGIC,
 	"Bad magic number in super-block"
@@ -326,5 +326,41 @@ ec	EXT2_ET_TDB_ERR_NOEXIST,
 ec	EXT2_ET_TDB_ERR_RDONLY,
 	"TDB: Write not permitted"
 
+ec	EXT2_ET_EXTENT_HEADER_BAD,
+	"Corrupt extent header"
+
+ec	EXT2_ET_EXTENT_INDEX_BAD,
+	"Corrupt extent index"
+
+ec	EXT2_ET_EXTENT_LEAF_BAD,
+	"Corrupt extent"
+
+ec	EXT2_ET_EXTENT_NO_SPACE,
+	"No free space in extent map"
+
+ec	EXT2_ET_INODE_NOT_EXTENT,
+	"Inode does not use extents"
+
+ec	EXT2_ET_EXTENT_NO_NEXT,
+	"No 'next' extent"
+
+ec	EXT2_ET_EXTENT_NO_PREV,
+	"No 'previous' extent"
+
+ec	EXT2_ET_EXTENT_NO_UP,
+	"No 'up' extent"
+
+ec	EXT2_ET_EXTENT_NO_DOWN,
+	"No 'down' extent"
+
+ec	EXT2_ET_NO_CURRENT_NODE,
+	"No current node"
+
+ec	EXT2_ET_OP_NOT_SUPPORTED,
+	"Ext2fs operation not supported"
+
+ec	EXT2_ET_CANT_INSERT_EXTENT,
+	"No room to insert extent in node"
+
 	end
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 83a9091..022d7f4 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -65,6 +65,7 @@ extern "C" {
 
 typedef __u32		ext2_ino_t;
 typedef __u32		blk_t;
+typedef __u64		blk64_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
 typedef __s64		e2_blkcnt_t;
@@ -285,6 +286,51 @@ struct struct_ext2_filsys {
 #endif
 
 /*
+ * Generic (non-filesystem layout specific) extents structure
+ */
+
+#define EXT2_EXTENT_FLAGS_LEAF		0x0001
+#define EXT2_EXTENT_FLAGS_UNINIT	0x0002
+
+struct ext2fs_extent {
+	blk64_t	e_pblk;		/* first physical block */
+	blk64_t	e_lblk;		/* first logical block extent covers */
+	__u32	e_len;		/* number of blocks covered by extent */
+	__u32	e_flags;	/* extent flags */
+};
+
+typedef struct ext2_extent_handle *ext2_extent_handle_t;
+
+/*
+ * Flags used by ext2fs_extent_get()
+ */
+#define EXT2_EXTENT_CURRENT	0x0000
+#define EXT2_EXTENT_MOVE_MASK	0x000F
+#define EXT2_EXTENT_ROOT	0x0001
+#define EXT2_EXTENT_FIRST_SIB	0x0002
+#define EXT2_EXTENT_NEXT_SIB	0x0003
+#define EXT2_EXTENT_PREV_SIB	0x0004
+#define EXT2_EXTENT_UP		0x0005
+#define EXT2_EXTENT_DOWN	0x0006
+#define EXT2_EXTENT_NEXT_LEAF	0x0007
+#define EXT2_EXTENT_PREV_LEAF	0x0008
+
+/*
+ * Data structure returned by ext2fs_extent_get_info()
+ */
+struct ext2_extent_info {
+	int		curr_entry;
+	int		curr_level;
+	int		num_entries;
+	int		max_entries;
+	int		bytes_avail;
+	blk64_t		max_lblk;
+	blk64_t		max_pblk;
+	__u32		max_len;
+	__u32		max_uninit_len;
+};
+	
+/*
  * Flags for directory block reading and writing functions
  */
 #define EXT2_DIRBLOCK_V2_STRUCT	0x0001
@@ -437,7 +483,8 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT3_FEATURE_INCOMPAT_EXTENTS)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
@@ -715,6 +762,19 @@ extern errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
 
+/* extent.c */
+extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
+				    ext2_extent_handle_t *handle);
+extern errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
+				   int flags, struct ext2fs_extent *extent);
+extern errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle, int flags,
+				       struct ext2fs_extent *extent);
+extern errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
+				      struct ext2fs_extent *extent);
+extern errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags);
+extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
+					struct ext2_extent_info *info);
+
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
 				   struct ext2_inode *inode,
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index c4178c9..ba980e4 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -126,6 +126,26 @@ struct ext3_ext_path {
 #define EXT_MAX_BLOCK	0xffffffff
 #define EXT_CACHE_MARK	0xffff
 
+/*
+ * EXT_INIT_MAX_LEN is the maximum number of blocks we can have in an
+ * initialized extent. This is 2^15 and not (2^16 - 1), since we use the
+ * MSB of ee_len field in the extent datastructure to signify if this
+ * particular extent is an initialized extent or an uninitialized (i.e.
+ * preallocated).
+ * EXT_UNINIT_MAX_LEN is the maximum number of blocks we can have in an
+ * uninitialized extent.
+ * If ee_len is <= 0x8000, it is an initialized extent. Otherwise, it is an
+ * uninitialized one. In other words, if MSB of ee_len is set, it is an
+ * uninitialized extent with only one special scenario when ee_len = 0x8000.
+ * In this case we can not have an uninitialized extent of zero length and
+ * thus we make it as a special case of initialized extent with 0x8000 length.
+ * This way we get better extent-to-group alignment for initialized extents.
+ * Hence, the maximum number of blocks we can have in an *initialized*
+ * extent is 2^15 (32768) and in an *uninitialized* extent is 2^15-1 (32767).
+ */
+#define EXT_INIT_MAX_LEN	(1UL << 15)
+#define EXT_UNINIT_MAX_LEN	(EXT_INIT_MAX_LEN - 1)
+
 
 #define EXT_FIRST_EXTENT(__hdr__) \
 	((struct ext3_extent *) (((char *) (__hdr__)) +		\
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
new file mode 100644
index 0000000..a6f4f65
--- /dev/null
+++ b/lib/ext2fs/extent.c
@@ -0,0 +1,616 @@
+/*
+ * extent.c --- routines to implement extents support
+ * 
+ * Copyright (C) 2007 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#if HAVE_ERRNO_H
+#include <errno.h>
+#endif
+#if HAVE_SYS_STAT_H
+#include <sys/stat.h>
+#endif
+#if HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
+#include "ext2_fs.h"
+#include "ext2fsP.h"
+#include "e2image.h"
+#include "ss/ss.h"
+
+/*
+ * Definitions to be dropped in lib/ext2fs/ext2fs.h
+ */
+
+/*
+ * Private definitions
+ */
+
+struct extent_path {
+	char		*buf;
+	int		entries;
+	int		max_entries;
+	int		left;
+	blk64_t		end_blk;
+	void		*curr;
+};
+	
+
+struct ext2_extent_handle {
+	errcode_t		magic;
+	ext2_filsys		fs;
+	ext2_ino_t 		ino;
+	struct ext2_inode	*inode;
+	int			type;
+	int			level;
+	int			max_depth;
+	struct extent_path	*path;
+};
+
+/*
+ *  Useful Debugging stuff
+ */
+
+#ifdef DEBUG
+#define EXT_DEBUG
+#endif
+
+#ifdef EXT_DEBUG
+static void ext_show_header(struct ext3_extent_header *eh)
+{
+	printf("header: magic=%x entries=%u max=%u depth=%u generation=%u\n",
+	       eh->eh_magic, eh->eh_entries, eh->eh_max, eh->eh_depth,
+	       eh->eh_generation);
+}
+
+static void ext_show_index(struct ext3_extent_idx *ix)
+{
+	printf("index: block=%u leaf=%u leaf_hi=%u unused=%u\n",
+	       ix->ei_block, ix->ei_leaf, ix->ei_leaf_hi, ix->ei_unused);
+}
+
+static void ext_show_extent(struct ext3_extent *ex)
+{
+	printf("extent: block=%u-%u len=%u start=%u start_hi=%u\n",
+	       ex->ee_block, ex->ee_block + ex->ee_len - 1,
+	       ex->ee_len, ex->ee_start, ex->ee_start_hi);
+}
+
+#define ext_printf(fmt, args...) printf(fmt, ## args)
+#else
+#define ext_show_header(eh) do { } while (0)
+#define ext_show_index(ix) do { } while (0)
+#define ext_show_extent(ex) do { } while (0)
+#define ext_printf(fmt, args...) do { } while (0)
+#endif
+
+/*
+ * Begin functions to handle an inode's extent information
+ */
+
+extern void ext2fs_extent_free(ext2_extent_handle_t handle)
+{
+	int			i;
+
+	if (!handle)
+		return;
+
+	if (handle->inode)
+		ext2fs_free_mem(&handle->inode);
+	if (handle->path) {
+		for (i=1; i < handle->max_depth; i++) {
+			if (handle->path[i].buf)
+				ext2fs_free_mem(&handle->path[i].buf);
+		}
+	}
+	ext2fs_free_mem(&handle);
+}
+
+extern errcode_t ext2fs_extent_open(ext2_filsys fs, ext2_ino_t ino,
+				    ext2_extent_handle_t *ret_handle)
+{
+	struct ext2_extent_handle	*handle;
+	errcode_t			retval;
+	int				isize = EXT2_INODE_SIZE(fs->super);
+	struct ext3_extent_header	*eh;
+	struct ext3_extent_idx		*ix;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	if ((ino == 0) || (ino > fs->super->s_inodes_count))
+		return EXT2_ET_BAD_INODE_NUM;
+
+	retval = ext2fs_get_mem(sizeof(struct ext2_extent_handle), &handle);
+	if (retval)
+		return retval;
+	memset(handle, 0, sizeof(struct ext2_extent_handle));
+
+	retval = ext2fs_get_mem(isize, &handle->inode);
+	if (retval)
+		goto errout;
+
+	handle->ino = ino;
+	handle->fs = fs;
+
+	retval = ext2fs_read_inode_full(fs, ino, handle->inode, isize);
+	if (retval)
+		goto errout;
+
+	if (!(handle->inode->i_flags & EXT4_EXTENTS_FL))
+		return EXT2_ET_INODE_NOT_EXTENT;
+
+	eh = (struct ext3_extent_header *) &handle->inode->i_block;
+
+	if (ext2fs_le16_to_cpu(eh->eh_magic) != EXT3_EXT_MAGIC)
+		return EXT2_ET_EXTENT_HEADER_BAD;
+
+	ext_show_header(eh);
+
+	handle->max_depth = ext2fs_le16_to_cpu(eh->eh_depth);
+	handle->type = ext2fs_le16_to_cpu(eh->eh_magic);
+
+	retval = ext2fs_get_mem(((handle->max_depth+1) * 
+				 sizeof(struct extent_path)),
+				&handle->path);
+	memset(handle->path, 0, 
+	       (handle->max_depth+1) * sizeof(struct extent_path));
+	handle->path[0].buf = (char *) handle->inode->i_block;
+
+	handle->path[0].left = handle->path[0].entries = 
+		ext2fs_le16_to_cpu(eh->eh_entries);
+	handle->path[0].max_entries = ext2fs_le16_to_cpu(eh->eh_max);
+	handle->path[0].curr = 0;
+	handle->path[0].end_blk = 
+		((((__u64) handle->inode->i_size_high << 32) +
+		  handle->inode->i_size + (fs->blocksize - 1))
+		 >> EXT2_BLOCK_SIZE_BITS(fs->super));
+	handle->level = 0;
+	handle->magic = EXT2_ET_MAGIC_EXTENT_HANDLE;
+
+	*ret_handle = handle;
+	return 0;
+
+errout:
+	ext2fs_extent_free(handle);
+	return retval;
+}
+
+/*
+ * This function is responsible for (optionally) moving through the
+ * extent tree and then returning the current extent
+ */
+errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
+			    int flags, struct ext2fs_extent *extent)
+{
+	struct extent_path	*path, *newpath;
+	struct ext3_extent_header	*eh;
+	struct ext3_extent_idx		*ix = 0;
+	struct ext3_extent		*ex;
+	errcode_t			retval;
+	blk_t				blk;
+	blk64_t				end_blk;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+	switch (flags & EXT2_EXTENT_MOVE_MASK) {
+	case EXT2_EXTENT_CURRENT:
+		ix = path->curr;
+		break;
+	case EXT2_EXTENT_ROOT:
+		handle->level = 0;
+	case EXT2_EXTENT_FIRST_SIB:
+		path->left = path->entries;
+		path->curr = 0;
+	case EXT2_EXTENT_NEXT_SIB:
+		if (path->curr) {
+			if (path->left <= 0)
+				return EXT2_ET_EXTENT_NO_NEXT;
+			ix = path->curr;
+			ix++;
+		} else {
+			if (path->entries == 0)
+				return EXT2_ET_EXTENT_NO_NEXT;
+			eh = (struct ext3_extent_header *) path->buf;
+			ix = EXT_FIRST_INDEX(eh);
+		}
+		path->left--;
+		path->curr = ix;
+		break;
+	case EXT2_EXTENT_PREV_SIB:
+		if (!path->curr ||
+		    path->left+1 >= path->entries)
+			return EXT2_ET_EXTENT_NO_PREV;
+		ix = path->curr;
+		ix--;
+		path->curr = ix;
+		path->left++;
+		break;
+	case EXT2_EXTENT_UP:
+		if (handle->level <= 0)
+			return EXT2_ET_EXTENT_NO_UP;
+		handle->level--;
+		path--;
+		ix = path->curr;
+		break;
+	case EXT2_EXTENT_DOWN:
+		if (!path->curr ||(handle->level >= handle->max_depth))
+			return EXT2_ET_EXTENT_NO_DOWN;
+
+		ix = path->curr;
+		newpath = path + 1;
+		if (!newpath->buf) {
+			retval = ext2fs_get_mem(handle->fs->blocksize, 
+						&newpath->buf);
+			if (retval)
+				return retval;
+		}
+		blk = ext2fs_le32_to_cpu(ix->ei_leaf) + 
+			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi));
+		if ((handle->fs->flags & EXT2_FLAG_IMAGE_FILE) &&
+		    (handle->fs->io != handle->fs->image_io))
+			memset(newpath->buf, 0, handle->fs->blocksize);
+		else {
+			retval = io_channel_read_blk(handle->fs->io, 
+						     blk, 1, newpath->buf);
+			if (retval)
+				return retval;
+		}
+		handle->level++;
+
+		eh = (struct ext3_extent_header *) newpath->buf;
+
+		ext_show_header(eh);
+		newpath->left = newpath->entries = 
+			ext2fs_le16_to_cpu(eh->eh_entries);
+		newpath->max_entries = ext2fs_le16_to_cpu(eh->eh_max);
+
+		if (path->left > 0) {
+			ix++;
+			newpath->end_blk = ext2fs_le32_to_cpu(ix->ei_block);
+		} else
+			newpath->end_blk = path->end_blk;
+
+		ix = EXT_FIRST_INDEX((struct ext3_extent_header *) eh);
+		newpath->curr = ix;
+		newpath->left = newpath->entries - 1;
+		path = newpath;
+
+		ext_printf("Down to level %d/%d, end_blk=%llu\n",
+			   handle->level, handle->max_depth,
+			   path->end_blk);
+
+		break;
+	default:
+		return EXT2_ET_OP_NOT_SUPPORTED;
+	}
+
+	if (!ix)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	ext_printf("Left is now: %d\n", path->left);
+
+	extent->e_flags = 0;
+
+	if (handle->level == handle->max_depth) {
+		ex = (struct ext3_extent *) ix;
+
+		extent->e_pblk = ext2fs_le32_to_cpu(ex->ee_start) + 
+			((__u64) ext2fs_le16_to_cpu(ex->ee_start_hi) << 32);
+		extent->e_lblk = ext2fs_le32_to_cpu(ex->ee_block);
+		extent->e_len = ext2fs_le16_to_cpu(ex->ee_len);
+		extent->e_flags = EXT2_EXTENT_FLAGS_LEAF;
+		if (extent->e_len > EXT_INIT_MAX_LEN) {
+			extent->e_len -= EXT_INIT_MAX_LEN;
+			extent->e_flags = EXT2_EXTENT_FLAGS_UNINIT;
+		}
+	} else {
+		extent->e_pblk = ext2fs_le32_to_cpu(ix->ei_leaf) + 
+			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
+		extent->e_lblk = ext2fs_le32_to_cpu(ix->ei_block);
+		if (path->left > 0) {
+			ix++;
+			end_blk = ext2fs_le32_to_cpu(ix->ei_block);
+		} else 
+			end_blk = path->end_blk;
+		
+		extent->e_len = end_blk - extent->e_lblk;
+	}
+
+	return 0;
+}
+
+static errcode_t update_path(ext2_extent_handle_t handle)
+{
+	struct extent_path		*path;
+	blk64_t				blk;
+	errcode_t			retval;
+	struct ext3_extent_idx		*ix;
+
+	if (handle->level == 0) {
+		retval = ext2fs_write_inode_full(handle->fs, handle->ino, 
+			   handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+	} else {
+		ix = handle->path[handle->level - 1].curr;
+		blk = ext2fs_le32_to_cpu(ix->ei_leaf) + 
+			((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);
+		
+		retval = io_channel_write_blk(handle->fs->io, 
+				      blk, 1, handle->path[handle->level].buf);
+	}
+	return retval;
+}
+
+errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle, int flags,
+				struct ext2fs_extent *extent)
+{
+	struct extent_path		*path;
+	struct ext3_extent_idx		*ix;
+	struct ext3_extent		*ex;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	if (handle->level == handle->max_depth) {
+		ex = path->curr;
+
+		ex->ee_block = ext2fs_cpu_to_le32(extent->e_lblk);
+		ex->ee_start = ext2fs_cpu_to_le32(extent->e_pblk & 0xFFFFFFFF);
+		ex->ee_start_hi = ext2fs_cpu_to_le16(extent->e_pblk >> 32);
+		ex->ee_len = ext2fs_cpu_to_le16(extent->e_len);
+	} else {
+		ix = path->curr;
+
+		ix->ei_leaf = ext2fs_cpu_to_le32(extent->e_pblk & 0xFFFFFFFF);
+		ix->ei_leaf_hi = ext2fs_cpu_to_le16(extent->e_pblk >> 32);
+		ix->ei_block = ext2fs_cpu_to_le32(extent->e_lblk);
+		ix->ei_unused = 0;
+	}
+	update_path(handle);
+	return 0;
+}
+
+errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
+				      struct ext2fs_extent *extent)
+{
+	struct extent_path		*path;
+	struct ext3_extent_idx		*ix;
+	struct ext3_extent_header	*eh;
+	errcode_t			retval;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+
+	eh = (struct ext3_extent_header *) path->buf;
+	if (path->curr) {
+		ix = path->curr;
+		ix++;
+	} else
+		path->curr = ix = EXT_FIRST_INDEX(eh);
+		
+	if (path->left)
+		memmove(ix, ix + 1, 
+			path->left * sizeof(struct ext3_extent_idx));
+	path->left++;
+	path->entries++;
+
+
+	retval = ext2fs_extent_replace(handle, 0, extent);
+	if (retval) 
+		goto errout;
+
+	retval = update_path(handle);
+	if (retval)
+		goto errout;
+
+	return 0;
+
+errout:
+	ext2fs_extent_delete(handle, 0);
+	return retval;
+}
+
+errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
+{
+	struct extent_path		*path;
+	char 				*cp;
+	struct ext3_extent_header	*eh;
+	errcode_t			retval;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	if (!handle->path)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	path = handle->path + handle->level;
+	if (!path->curr)
+		return EXT2_ET_NO_CURRENT_NODE;
+
+	cp = path->curr;
+
+	if (path->left) {
+		memmove(cp, cp + sizeof(struct ext3_extent_idx),
+			path->left * sizeof(struct ext3_extent_idx));
+		path->left--;
+	}
+	path->entries--;
+	if (path->entries == 0)
+		path->curr = 0;
+
+	eh = (struct ext3_extent_header *) path->buf;
+	eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
+
+	retval = update_path(handle);
+
+	return retval;
+}
+
+errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
+				 struct ext2_extent_info *info)
+{
+	struct extent_path		*path;
+	struct ext3_extent_idx		*ix;
+	struct ext3_extent		*ex;
+
+	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
+
+	memset(info, 0, sizeof(struct ext2_extent_info));
+
+	path = handle->path + handle->level;
+	if (path) {
+		if (path->curr)
+			info->curr_entry = ((char *) path->curr - path->buf) / 
+				sizeof(struct ext3_extent_idx);
+		else
+			info->curr_entry = 0;
+		info->num_entries = path->entries;
+		info->max_entries = path->max_entries;
+		info->bytes_avail = path->max_entries - path->entries;
+	}
+
+	info->max_lblk = ((__u64) 1 << 32) - 1;
+	info->max_pblk = ((__u64) 1 << 48) - 1;
+	info->max_len = (1UL << 15);
+	info->max_uninit_len = (1UL << 15) - 1;
+
+	return 0;
+}
+
+
+
+#ifdef DEBUG
+
+#include "debugfs.h"
+
+/*
+ * Hook in new commands into debugfs
+ */
+char *debug_prog_name = "tst_extents";
+extern ss_request_table extent_cmds;
+ss_request_table *extra_cmds = &extent_cmds;
+
+ext2_ino_t	current_ino = 0;
+ext2_extent_handle_t current_handle;
+
+void do_inode(int argc, char *argv[])
+{
+	ext2_ino_t	inode;
+	int		i;
+	struct ext3_extent_header *eh;
+	errcode_t retval;
+
+	if (check_fs_open(argv[0]))
+		return;
+
+	if (argc == 1) {
+		if (current_ino)
+			printf("Current inode is %d\n", current_ino);
+		else
+			printf("No current inode\n");
+		return;
+	}
+
+	if (common_inode_args_process(argc, argv, &inode, 0)) {
+		return;
+	}
+
+	current_ino = 0;
+
+	retval = ext2fs_extent_open(current_fs, inode, &current_handle);
+	if (retval) {
+		com_err(argv[1], retval, "while opening extent handle");
+		return;
+	}
+
+	current_ino = inode;
+
+	printf("Loaded inode %d\n", current_ino);
+
+	return;
+}
+
+void generic_goto_node(char *cmd_name, int op)
+{
+	struct ext2fs_extent	extent;
+	errcode_t		retval;
+	
+	if (check_fs_open(cmd_name))
+		return;
+
+	retval = ext2fs_extent_get(current_handle, op, &extent);
+	if (retval) {
+		com_err(cmd_name, retval, 0);
+		return;
+	}
+	printf("Extent: lblk %llu, len %lu, pblk %llu, flags: ",
+	       extent.e_lblk, extent.e_len, extent.e_pblk);
+	if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)
+		fputs("LEAF ", stdout);
+	if (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT)
+		fputs("UNINIT ", stdout);
+	if (!extent.e_flags)
+		fputs("(none)", stdout);
+	fputc('\n', stdout);
+}
+
+
+void do_current_node(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_CURRENT);
+}
+
+void do_root_node(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_ROOT);
+}
+
+void do_first_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_FIRST_SIB);
+}
+
+void do_next_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_NEXT_SIB);
+}
+
+void do_prev_sib(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_PREV_SIB);
+}
+
+void do_up(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_UP);
+}
+
+void do_down(int argc, char *argv[])
+{
+	generic_goto_node(argv[0], EXT2_EXTENT_DOWN);
+}
+
+#endif
diff --git a/lib/ext2fs/extent_dbg.ct b/lib/ext2fs/extent_dbg.ct
new file mode 100644
index 0000000..21ece39
--- /dev/null
+++ b/lib/ext2fs/extent_dbg.ct
@@ -0,0 +1,32 @@
+#
+# Copyright (C) 1993 Theodore Ts'o.  This file may be redistributed
+# under the terms of the GNU Public License.
+#
+command_table extent_cmds;
+
+request do_inode, "Open an inode",
+	inode;
+
+request do_current_node, "Current extent node",
+	current_node, current;
+
+request do_root_node, "Goto root extent",
+	root_node, root;
+
+request do_first_sib, "First sibling",
+	first_sibling, first_sib;
+
+request do_next_sib, "Next sibling",
+	next_sibling, next_sib, next;
+
+request do_prev_sib, "Previous sibling",
+	prev_sibling, prev_sib, prev;
+
+request do_up, "Up node",
+	up_node, up;
+
+request do_down, "Down node",
+	down_node, down;
+
+end;
+
-- 
1.5.3.1.19.gb5ef6
