From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/7] e2fsck: Discard free data and inode blocks.
Date: Tue, 26 Oct 2010 19:54:15 +0200
Message-ID: <1288115658-7004-5-git-send-email-lczerner@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZRyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 13:54:37 -0400
In-Reply-To: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
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

This is off by default.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/e2fsck.8.in |   14 +++++++++
 e2fsck/e2fsck.h    |    1 +
 e2fsck/pass5.c     |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c      |   10 ++++++-
 4 files changed, 105 insertions(+), 1 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3fb15e6..2da253a 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -189,6 +189,20 @@ be 1 or 2.  The default extended attribute version format is 2.
 .BI fragcheck
 During pass 1, print a detailed report of any discontiguous blocks for
 files in the filesystem.
+.TP
+.BI discard
+Discard, attempt to discard free blocks and unused inode blocks after the full
+filesystem check (discardding blocks is useful on solid state devices and sparse
+/ thin-provisioned storage). Note that discard is done in pass 5 AFTER the
+filesystem has been fully checked and does not contains recognizable errors.
+However there might be cases where
+.B e2fsck
+does not fully recognise the problem and hence in this case this
+option may prevent you from further manual data recovery.
+.TP
+.BI nodiscard
+Do not attempt to discard free blocks and unused inode blocks. This option is
+exacly the oposite of discard option. This is set as default.
 .RE
 .TP
 .B \-f
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index a6563cc..65601ab 100644
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
index cbc12f3..3819901 100644
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
@@ -39,6 +48,12 @@ void e2fsck_pass5(e2fsck_t ctx)
 		if ((ctx->progress)(ctx, 5, 0, ctx->fs->group_desc_count*2))
 			return;
 
+	if ((ctx->options & E2F_OPT_DISCARD) &&
+	    (ctx->problem_history)) {
+		fix_problem(ctx, PR_5_DONT_DISCARD, &pctx);
+		ctx->options &= ~E2F_OPT_DISCARD;
+	}
+
 	e2fsck_read_bitmaps(ctx);
 
 	check_block_bitmaps(ctx);
@@ -64,6 +79,19 @@ void e2fsck_pass5(e2fsck_t ctx)
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
+static void e2fsck_should_discard(e2fsck_t ctx, io_manager manager,
+				  blk64_t start, blk64_t count)
+{
+	ext2_filsys fs = ctx->fs;
+	int ret = 0;
+
+	if (ctx->options & E2F_OPT_DISCARD)
+		ret = manager->discard(fs->io, start, count, fs);
+
+	if (ret)
+		ctx->options &= ~E2F_OPT_DISCARD;
+}
+
 #define NO_BLK ((blk64_t) -1)
 
 static void print_bitmap_problem(e2fsck_t ctx, int problem,
@@ -108,6 +136,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	group = 0;
 	int	blocks = 0;
 	blk64_t	free_blocks = 0;
+	blk64_t first_free = ext2fs_blocks_count(fs->super);
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
@@ -120,6 +149,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	cmp_block = 0;
 	int	redo_flag = 0;
 	blk64_t	super_blk, old_desc_blk, new_desc_blk;
+	io_manager	manager = ctx->fs->io->manager;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -280,11 +310,24 @@ redo_counts:
 		}
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
+		/*
+		 * If there a problem we should turn off the discard so we
+		 * do not compromise the filesystem.
+		 */
+		ctx->options &= ~E2F_OPT_DISCARD;
 
 	do_counts:
 		if (!bitmap && (!skip_group || csum_flag)) {
 			group_free++;
 			free_blocks++;
+			if (first_free > i)
+				first_free = i;
+		} else {
+			if ((i > first_free) &&
+			   (ctx->options & E2F_OPT_DISCARD))
+				e2fsck_should_discard(ctx, manager, first_free,
+						      (i - first_free));
+			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
@@ -381,6 +424,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	int		csum_flag;
 	int		skip_group = 0;
 	int		redo_flag = 0;
+	io_manager	manager = ctx->fs->io->manager;
 
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -500,6 +544,11 @@ redo_counts:
 		}
 		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
 		had_problem++;
+		/*
+		 * If there is a problem we should turn off the discard so we
+		 * do not compromise the filesystem.
+		 */
+		ctx->options &= ~E2F_OPT_DISCARD;
 
 do_counts:
 		if (bitmap) {
@@ -509,11 +558,43 @@ do_counts:
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
+				e2fsck_should_discard(ctx, manager, blk, num);
+			}
+
+			/*
+			 * If discard zeroes data and the group inode table
+			 * was not zeroed yet, set itable as zeroed
+			 */
+			if ((ctx->options & E2F_OPT_DISCARD) &&
+			    (manager->discard_zeroes_data) &&
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
 
