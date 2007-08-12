From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Remove e2fsck's -s and -S options to byte-swap ancient PPC filesystems
Date: Sun, 12 Aug 2007 12:57:16 -0400
Message-ID: <11869378411811-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46675 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbXHLQ6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:45 -0400
In-Reply-To: <1186937841369-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The need for fixing byte-swapped filesystems is long-gone, and this is
getting in the way of cleaning up e2fsprogs's bitmaps code.  So let's
get rid of it; modern kernels haven't been able to deal with a
byte-swapped filesystem in in about 9 years.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/Makefile.in |   12 +--
 e2fsck/e2fsck.8.in |   13 +---
 e2fsck/e2fsck.h    |    3 -
 e2fsck/swapfs.c    |  272 ----------------------------------------------------
 e2fsck/unix.c      |   47 +---------
 5 files changed, 6 insertions(+), 341 deletions(-)
 delete mode 100644 e2fsck/swapfs.c

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 95c4399..7750759 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -62,7 +62,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 #MCHECK= -DMCHECK
 
 OBJS= dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o pass3.o pass4.o \
-	pass5.o journal.o swapfs.o badblocks.o util.o dirinfo.o dx_dirinfo.o \
+	pass5.o journal.o badblocks.o util.o dirinfo.o dx_dirinfo.o \
 	ehandler.o problem.o message.o recovery.o region.o revoke.o \
 	ea_refcount.o rehash.o profile.o prof_err.o $(MTRACE_OBJ)
 
@@ -71,7 +71,7 @@ PROFILED_OBJS= profiled/dict.o profiled/unix.o profiled/e2fsck.o \
 	profiled/pass2.o profiled/pass3.o profiled/pass4.o profiled/pass5.o \
 	profiled/journal.o profiled/badblocks.o profiled/util.o \
 	profiled/dirinfo.o profiled/dx_dirinfo.o profiled/ehandler.o \
-	profiled/message.o profiled/problem.o profiled/swapfs.o \
+	profiled/message.o profiled/problem.o \
 	profiled/recovery.o profiled/region.o profiled/revoke.o \
 	profiled/ea_refcount.o profiled/rehash.o profiled/profile.o \
 	profiled/prof_err.o
@@ -96,7 +96,6 @@ SRCS= $(srcdir)/e2fsck.c \
 	$(srcdir)/ehandler.c \
 	$(srcdir)/problem.c \
 	$(srcdir)/message.c \
-	$(srcdir)/swapfs.c \
 	$(srcdir)/ea_refcount.c \
 	$(srcdir)/rehash.c \
 	$(srcdir)/region.c \
@@ -382,13 +381,6 @@ message.o: $(srcdir)/message.c $(srcdir)/e2fsck.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/blkid/blkid.h $(top_builddir)/lib/blkid/blkid_types.h \
  $(srcdir)/profile.h prof_err.h $(srcdir)/problem.h
-swapfs.o: $(srcdir)/swapfs.c $(top_srcdir)/lib/et/com_err.h \
- $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
- $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
- $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h $(top_srcdir)/lib/ext2fs/bitops.h \
- $(top_srcdir)/lib/blkid/blkid.h $(top_builddir)/lib/blkid/blkid_types.h \
- $(srcdir)/profile.h prof_err.h
 ea_refcount.o: $(srcdir)/ea_refcount.c $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index c1e40c9..eb560bf 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -8,7 +8,7 @@ e2fsck \- check a Linux ext2/ext3 file system
 .SH SYNOPSIS
 .B e2fsck
 [
-.B \-pacnyrdfkvstDFSV
+.B \-pacnyrdfkvtDFV
 ]
 [
 .B \-b
@@ -256,17 +256,6 @@ options.
 .B \-r
 This option does nothing at all; it is provided only for backwards
 compatibility.
-.TP 
-.B \-s
-This option will byte-swap the filesystem so that it is using the normalized, 
-standard byte-order (which is i386 or little endian).  If the filesystem is
-already in the standard byte-order, 
-.B e2fsck 
-will take no action.
-.TP
-.B \-S
-This option will byte-swap the filesystem, regardless of its current 
-byte-order.
 .TP
 .B \-t
 Print timing statistics for
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 1071847..99c0ae5 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -456,9 +456,6 @@ void e2fsck_rehash_directories(e2fsck_t ctx);
 /* super.c */
 void check_super_block(e2fsck_t ctx);
 
-/* swapfs.c */
-void swap_filesys(e2fsck_t ctx);
-
 /* util.c */
 extern void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
 				    const char *description);
diff --git a/e2fsck/swapfs.c b/e2fsck/swapfs.c
deleted file mode 100644
index 81f3ca2..0000000
--- a/e2fsck/swapfs.c
+++ /dev/null
@@ -1,272 +0,0 @@
-/*
- * swapfs.c --- byte-swap an ext2 filesystem
- *
- * Copyright 1996, 1997 by Theodore Ts'o
- * 
- * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Public
- * License.
- * %End-Header%
- * 
- */
-
-#ifdef HAVE_ERRNO_H
-#include <errno.h>
-#endif
-#include <et/com_err.h>
-#include "e2fsck.h"
-
-#ifdef ENABLE_SWAPFS
-
-struct swap_block_struct {
-	ext2_ino_t	ino;
-	int		isdir;
-	errcode_t	errcode;
-	char		*dir_buf;
-	struct ext2_inode *inode;
-};
-
-/*
- * This is a helper function for block_iterate.  We mark all of the
- * indirect and direct blocks as changed, so that block_iterate will
- * write them out.
- */
-static int swap_block(ext2_filsys fs, blk_t *block_nr, int blockcnt,
-		      void *priv_data)
-{
-	errcode_t	retval;
-	
-	struct swap_block_struct *sb = (struct swap_block_struct *) priv_data;
-
-	if (sb->isdir && (blockcnt >= 0) && *block_nr) {
-		retval = ext2fs_read_dir_block(fs, *block_nr, sb->dir_buf);
-		if (retval) {
-			sb->errcode = retval;
-			return BLOCK_ABORT;
-		}
-		retval = ext2fs_write_dir_block(fs, *block_nr, sb->dir_buf);
-		if (retval) {
-			sb->errcode = retval;
-			return BLOCK_ABORT;
-		}
-	}
-	if (blockcnt >= 0) {
-		if (blockcnt < EXT2_NDIR_BLOCKS)
-			return 0;
-		return BLOCK_CHANGED;
-	}
-	if (blockcnt == BLOCK_COUNT_IND) {
-		if (*block_nr == sb->inode->i_block[EXT2_IND_BLOCK])
-			return 0;
-		return BLOCK_CHANGED;
-	}
-	if (blockcnt == BLOCK_COUNT_DIND) {
-		if (*block_nr == sb->inode->i_block[EXT2_DIND_BLOCK])
-			return 0;
-		return BLOCK_CHANGED;
-	}
-	if (blockcnt == BLOCK_COUNT_TIND) {
-		if (*block_nr == sb->inode->i_block[EXT2_TIND_BLOCK])
-			return 0;
-		return BLOCK_CHANGED;
-	}
-	return BLOCK_CHANGED;
-}
-
-/*
- * This function is responsible for byte-swapping all of the indirect,
- * block pointers.  It is also responsible for byte-swapping directories.
- */
-static void swap_inode_blocks(e2fsck_t ctx, ext2_ino_t ino, char *block_buf,
-			      struct ext2_inode *inode)
-{
-	errcode_t			retval;
-	struct swap_block_struct	sb;
-
-	sb.ino = ino;
-	sb.inode = inode;
-	sb.dir_buf = block_buf + ctx->fs->blocksize*3;
-	sb.errcode = 0;
-	sb.isdir = 0;
-	if (LINUX_S_ISDIR(inode->i_mode))
-		sb.isdir = 1;
-
-	retval = ext2fs_block_iterate(ctx->fs, ino, 0, block_buf,
-				      swap_block, &sb);
-	if (retval) {
-		com_err("swap_inode_blocks", retval,
-			_("while calling ext2fs_block_iterate"));
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-	if (sb.errcode) {
-		com_err("swap_inode_blocks", sb.errcode,
-			_("while calling iterator function"));
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-}
-
-static void swap_inodes(e2fsck_t ctx)
-{
-	ext2_filsys fs = ctx->fs;
-	dgrp_t			group;
-	unsigned int		i;
-	ext2_ino_t		ino = 1;
-	char 			*buf = NULL, *block_buf = NULL;
-	errcode_t		retval;
-	struct ext2_inode *	inode;
-
-	e2fsck_use_inode_shortcuts(ctx, 1);
-	
-	retval = ext2fs_get_mem(fs->blocksize * fs->inode_blocks_per_group,
-				&buf);
-	if (retval) {
-		com_err("swap_inodes", retval,
-			_("while allocating inode buffer"));
-		ctx->flags |= E2F_FLAG_ABORT;
-		goto errout;
-	}
-	block_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 4,
-						    "block interate buffer");
-	for (group = 0; group < fs->group_desc_count; group++) {
-		retval = io_channel_read_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
-		      fs->inode_blocks_per_group, buf);
-		if (retval) {
-			com_err("swap_inodes", retval,
-				_("while reading inode table (group %d)"),
-				group);
-			ctx->flags |= E2F_FLAG_ABORT;
-			goto errout;
-		}
-		inode = (struct ext2_inode *) buf;
-		for (i=0; i < fs->super->s_inodes_per_group;
-		     i++, ino++, inode++) {
-			ctx->stashed_ino = ino;
-			ctx->stashed_inode = inode;
-			
-			if (fs->flags & EXT2_FLAG_SWAP_BYTES_READ)
-				ext2fs_swap_inode(fs, inode, inode, 0);
-			
-			/*
-			 * Skip deleted files.
-			 */
-			if (inode->i_links_count == 0)
-				continue;
-			
-			if (LINUX_S_ISDIR(inode->i_mode) ||
-			    ((inode->i_block[EXT2_IND_BLOCK] ||
-			      inode->i_block[EXT2_DIND_BLOCK] ||
-			      inode->i_block[EXT2_TIND_BLOCK]) &&
-			     ext2fs_inode_has_valid_blocks(inode)))
-				swap_inode_blocks(ctx, ino, block_buf, inode);
-
-			if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-				goto errout;
-			
-			if (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)
-				ext2fs_swap_inode(fs, inode, inode, 1);
-		}
-		retval = io_channel_write_blk(fs->io,
-		      fs->group_desc[group].bg_inode_table,
-		      fs->inode_blocks_per_group, buf);
-		if (retval) {
-			com_err("swap_inodes", retval,
-				_("while writing inode table (group %d)"),
-				group);
-			ctx->flags |= E2F_FLAG_ABORT;
-			goto errout;
-		}
-	}
-errout:
-	if (buf)
-		ext2fs_free_mem(&buf);
-	if (block_buf)
-		ext2fs_free_mem(&block_buf);
-	e2fsck_use_inode_shortcuts(ctx, 0);
-	ext2fs_flush_icache(fs);
-}
-
-#if defined(__powerpc__) && defined(EXT2FS_ENABLE_SWAPFS)
-/*
- * On the PowerPC, the big-endian variant of the ext2 filesystem
- * has its bitmaps stored as 32-bit words with bit 0 as the LSB
- * of each word.  Thus a bitmap with only bit 0 set would be, as
- * a string of bytes, 00 00 00 01 00 ...
- * To cope with this, we byte-reverse each word of a bitmap if
- * we have a big-endian filesystem, that is, if we are *not*
- * byte-swapping other word-sized numbers.
- */
-#define EXT2_BIG_ENDIAN_BITMAPS
-#endif
-
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-static void ext2fs_swap_bitmap(ext2fs_generic_bitmap bmap)
-{
-	__u32 *p = (__u32 *) bmap->bitmap;
-	int n, nbytes = (bmap->end - bmap->start + 7) / 8;
-		
-	for (n = nbytes / sizeof(__u32); n > 0; --n, ++p)
-		*p = ext2fs_swab32(*p);
-}
-#endif
-
-
-void swap_filesys(e2fsck_t ctx)
-{
-	ext2_filsys fs = ctx->fs;
-#ifdef RESOURCE_TRACK
-	struct resource_track	rtrack;
-
-	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
-	if (!(ctx->options & E2F_OPT_PREEN))
-		printf(_("Pass 0: Doing byte-swap of filesystem\n"));
-	
-#ifdef MTRACE
-	mtrace_print("Byte swap");
-#endif
-
-	if (fs->super->s_mnt_count) {
-		fprintf(stderr, _("%s: the filesystem must be freshly "
-			"checked using fsck\n"
-			"and not mounted before trying to "
-			"byte-swap it.\n"), ctx->device_name);
-		ctx->flags |= E2F_FLAG_ABORT;
-		return;
-	}
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		fs->flags &= ~(EXT2_FLAG_SWAP_BYTES|
-			       EXT2_FLAG_SWAP_BYTES_WRITE);
-		fs->flags |= EXT2_FLAG_SWAP_BYTES_READ;
-	} else {
-		fs->flags &= ~EXT2_FLAG_SWAP_BYTES_READ;
-		fs->flags |= EXT2_FLAG_SWAP_BYTES_WRITE;
-	}
-	swap_inodes(ctx);
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-		return;
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)
-		fs->flags |= EXT2_FLAG_SWAP_BYTES;
-	fs->flags &= ~(EXT2_FLAG_SWAP_BYTES_READ|
-		       EXT2_FLAG_SWAP_BYTES_WRITE);
-
-#ifdef EXT2_BIG_ENDIAN_BITMAPS
-	e2fsck_read_bitmaps(ctx);
-	ext2fs_swap_bitmap(fs->inode_map);
-	ext2fs_swap_bitmap(fs->block_map);
-	fs->flags |= EXT2_FLAG_BB_DIRTY | EXT2_FLAG_IB_DIRTY;
-#endif
-	fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
-	ext2fs_flush(fs);
-	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
-	
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2)
-		print_resource_track(_("Byte swap"), &rtrack, fs->io);
-#endif
-}
-
-#endif
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index ad68c4b..3d91049 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -52,8 +52,6 @@ extern int optind;
 #include "../version.h"
 
 /* Command line options */
-static int swapfs;
-static int normalize_swapfs;
 static int cflag;		/* check disk */
 static int show_version_only;
 static int verbose;
@@ -71,7 +69,7 @@ int journal_enable_debug = -1;
 static void usage(e2fsck_t ctx)
 {
 	fprintf(stderr,
-		_("Usage: %s [-panyrcdfvstDFSV] [-b superblock] [-B blocksize]\n"
+		_("Usage: %s [-panyrcdfvtDFV] [-b superblock] [-B blocksize]\n"
 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
 		"\t\t[-E extended-options] device\n"),
@@ -267,8 +265,7 @@ static void check_if_skip(e2fsck_t ctx)
 	if (!defer_check_on_battery)
 		batt = 0;
 
-	if ((ctx->options & E2F_OPT_FORCE) || bad_blocks_file ||
-	    cflag || swapfs)
+	if ((ctx->options & E2F_OPT_FORCE) || bad_blocks_file || cflag)
 		return;
 	
 	if ((fs->super->s_state & EXT2_ERROR_FS) ||
@@ -717,20 +714,6 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'N':
 			ctx->device_name = optarg;
 			break;
-#ifdef ENABLE_SWAPFS
-		case 's':
-			normalize_swapfs = 1;
-		case 'S':
-			swapfs = 1;
-			break;
-#else
-		case 's':
-		case 'S':
-			fprintf(stderr, _("Byte-swapping filesystems "
-					  "not compiled in this version "
-					  "of e2fsck\n"));
-			exit(1);
-#endif
 		case 'k':
 			keep_bad_blocks++;
 			break;
@@ -742,7 +725,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if (optind != argc - 1)
 		usage(ctx);
 	if ((ctx->options & E2F_OPT_NO) && !bad_blocks_file &&
-	    !cflag && !swapfs && !(ctx->options & E2F_OPT_COMPRESS_DIRS))
+	    !cflag && !(ctx->options & E2F_OPT_COMPRESS_DIRS))
 		ctx->options |= E2F_OPT_READONLY;
 	ctx->io_options = strchr(argv[optind], '?');
 	if (ctx->io_options) 
@@ -777,15 +760,6 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		}
 		close(fd);
 	}
-#ifdef ENABLE_SWAPFS
-	if (swapfs) {
-		if (cflag || bad_blocks_file) {
-			fprintf(stderr, _("Incompatible options not "
-					  "allowed when byte-swapping.\n"));
-			exit(FSCK_USAGE);
-		}
-	}
-#endif
 	if (cflag && bad_blocks_file) {
 		fprintf(stderr, _("The -c and the -l/-L options may "
 				  "not be both used at the same time.\n"));
@@ -1169,21 +1143,6 @@ restart:
 		read_bad_blocks_file(ctx, 0, !keep_bad_blocks); /* Test disk */
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		fatal_error(ctx, 0);
-#ifdef ENABLE_SWAPFS
-	if (normalize_swapfs) {
-		if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ==
-		    ext2fs_native_flag()) {
-			fprintf(stderr, _("%s: Filesystem byte order "
-				"already normalized.\n"), ctx->device_name);
-			fatal_error(ctx, 0);
-		}
-	}
-	if (swapfs) {
-		swap_filesys(ctx);
-		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-			fatal_error(ctx, 0);
-	}
-#endif
 
 	/*
 	 * Mark the system as valid, 'til proven otherwise
-- 
1.5.3.rc4.67.gf9286
