From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/6] e2fsck: Discard free data and inode blocks.
Date: Thu, 18 Nov 2010 14:38:38 +0100
Message-ID: <1290087521-9123-4-git-send-email-lczerner@redhat.com>
References: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0KRNiy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:54 -0500
In-Reply-To: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In Pass 5 when we are checking block and inode bitmaps we have great
opportunity to discard free space and unused inodes on the device,
because bitmaps has just been verified as valid. This commit takes
advantage of this opportunity and discards both, all free space and
unused inodes.

I have added new set of options, 'nodiscard' and 'discard'. When the
underlying devices does not support discard, or discard ends with an
error, or when any kind of error occurs on the filesystem, no further
discard attempt will be made and the e2fsck will behave as it would
with nodiscard option provided.

As an addition, when there is any not-yet-zeroed inode table and
discard zeroes data, then inode table is marked as zeroed.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/e2fsck.8.in |   14 +++++++
 e2fsck/e2fsck.h    |    1 +
 e2fsck/pass5.c     |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c      |   10 +++++-
 4 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3fb15e6..4c2dd98 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -189,6 +189,20 @@ be 1 or 2.  The default extended attribute version format is 2.
 .BI fragcheck
 During pass 1, print a detailed report of any discontiguous blocks for
 files in the filesystem.
+.TP
+.BI discard
+Attempt to discard free blocks and unused inode blocks after the full
+filesystem check (discarding blocks is useful on solid state devices and sparse
+/ thin-provisioned storage). Note that discard is done in pass 5 AFTER the
+filesystem has been fully checked and only if it does not contain recognizable
+errors. However there might be cases where
+.B e2fsck
+does not fully recognise a problem and hence in this case this
+option may prevent you from further manual data recovery.
+.TP
+.BI nodiscard
+Do not attempt to discard free blocks and unused inode blocks. This option is
+exacly the opposite of discard option. This is set as default.
 .RE
 .TP
 .B \-f
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d4df5f3..a377246 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -155,6 +155,7 @@ struct resource_track {
 #define E2F_OPT_WRITECHECK	0x0200
 #define E2F_OPT_COMPRESS_DIRS	0x0400
 #define E2F_OPT_FRAGCHECK	0x0800
+#define E2F_OPT_DISCARD		0x1000
 
 /*
  * E2fsck flags
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index cbc12f3..8f31816 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -10,9 +10,18 @@
  *
  */
 
+#include <stdint.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <errno.h>
+
 #include "e2fsck.h"
 #include "problem.h"
 
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
 static void check_block_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
@@ -64,6 +73,35 @@ void e2fsck_pass5(e2fsck_t ctx)
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
+static int e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
+				  blk64_t start, blk64_t count)
+{
+	ext2_filsys fs = ctx->fs;
+	int ret = 0;
+
+	/*
+	 * If the filesystem has changed it means that there was an corruption
+	 * which should be repaired, but in some cases just one e2fsck run is
+	 * not enough to fix the problem, hence it is not safe to run discard
+	 * in this case.
+	 */
+	if (ext2fs_test_changed(ctx->fs))
+		ctx->options &= ~E2F_OPT_DISCARD;
+
+	if (ctx->options & E2F_OPT_DISCARD)
+		ret = manager->discard(fs->io, start, count, fs->blocksize);
+
+	if (ret) {
+		printf("Discard failed while trimming blocks %llu -> %llu "
+		       "with blocksize %lu\n", start, start + count,
+		       fs->blocksize);
+		ctx->flags |= E2F_FLAG_ABORT;
+		ctx->options &= ~E2F_OPT_DISCARD;
+	}
+
+	return ret;
+}
+
 #define NO_BLK ((blk64_t) -1)
 
 static void print_bitmap_problem(e2fsck_t ctx, int problem,
@@ -108,6 +146,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	group = 0;
 	int	blocks = 0;
 	blk64_t	free_blocks = 0;
+	blk64_t first_free = ext2fs_blocks_count(fs->super);
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
@@ -120,6 +159,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	cmp_block = 0;
 	int	redo_flag = 0;
 	blk64_t	super_blk, old_desc_blk, new_desc_blk;
+	io_manager	manager = ctx->fs->io->manager;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -281,10 +321,26 @@ redo_counts:
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
 
+		/*
+		 * If there a problem we should turn off the discard so we
+		 * do not compromise the filesystem.
+		 */
+		ctx->options &= ~E2F_OPT_DISCARD;
+
 	do_counts:
 		if (!bitmap && (!skip_group || csum_flag)) {
 			group_free++;
 			free_blocks++;
+			if (first_free > i)
+				first_free = i;
+		} else {
+			if ((i > first_free) &&
+			   (ctx->options & E2F_OPT_DISCARD)) {
+				if (e2fsck_discard_blocks(ctx, manager,
+					first_free, (i - first_free)))
+					goto errout;
+			}
+			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
@@ -381,6 +437,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	int		csum_flag;
 	int		skip_group = 0;
 	int		redo_flag = 0;
+	io_manager	manager = ctx->fs->io->manager;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -500,6 +557,11 @@ redo_counts:
 		}
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
+		/*
+		 * If there a problem we should turn off the discard so we
+		 * do not compromise the filesystem.
+		 */
+		ctx->options &= ~E2F_OPT_DISCARD;
 
 do_counts:
 		if (bitmap) {
@@ -509,11 +571,45 @@ do_counts:
 			group_free++;
 			free_inodes++;
 		}
+
 		inodes++;
 		if ((inodes == fs->super->s_inodes_per_group) ||
 		    (i == fs->super->s_inodes_count)) {
+
 			free_array[group] = group_free;
 			dir_array[group] = dirs_count;
+
+			/* Discard inode table */
+			if (ctx->options & E2F_OPT_DISCARD) {
+				blk64_t used_blks, blk, num;
+
+				used_blks = DIV_ROUND_UP(
+					(EXT2_INODES_PER_GROUP(fs->super) -
+					group_free),
+					EXT2_INODES_PER_BLOCK(fs->super));
+
+				blk = ext2fs_inode_table_loc(fs, group) +
+				      used_blks;
+				num = fs->inode_blocks_per_group -
+				      used_blks;
+				if (e2fsck_discard_blocks(ctx, manager,
+							       blk, num))
+					goto errout;
+			}
+
+			/*
+			 * If discard zeroes data and the group inode table
+			 * was not zeroed yet, set itable as zeroed
+			 */
+			if ((ctx->options & E2F_OPT_DISCARD) &&
+			    (ext2fs_discard_zeroes_data(fs->io)) &&
+			    !(ext2fs_bg_flags_test(fs, group,
+						  EXT2_BG_INODE_ZEROED))) {
+				ext2fs_bg_flags_set(fs, group,
+						    EXT2_BG_INODE_ZEROED);
+				ext2fs_group_desc_csum_set(fs, group);
+			}
+
 			group ++;
 			inodes = 0;
 			skip_group = 0;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7eb269c..4cf55a9 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -594,6 +594,12 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "fragcheck") == 0) {
 			ctx->options |= E2F_OPT_FRAGCHECK;
 			continue;
+		} else if (strcmp(token, "discard") == 0) {
+			ctx->options |= E2F_OPT_DISCARD;
+			continue;
+		} else if (strcmp(token, "nodiscard") == 0) {
+			ctx->options &= ~E2F_OPT_DISCARD;
+			continue;
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -609,6 +615,8 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		       "Valid extended options are:\n"), stderr);
 		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
 		fputs(("\tfragcheck\n"), stderr);
+		fputs(("\tdiscard\n"), stderr);
+		fputs(("\tnodiscard\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -667,6 +675,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
+
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
@@ -943,7 +952,6 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 	return retval;
 }
 
