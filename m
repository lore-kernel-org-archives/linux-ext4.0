From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Thu, 21 Oct 2010 16:15:56 +0200
Message-ID: <1287670556-23460-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0JUOQC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 10:16:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In Pass 5 when we are checking block and inode bitmaps we have great
opportunity to discard free space and unused inodes on the device,
because bitmaps has just been verified as valid. This commit takes
advantage of this opportunity and discards both, all free space and
unused inodes.

I have added new option '-K' which when set, disables discard. Also when
the underlying device does not support discard, or BLKDISCARD ioctl
returns any kind of error, or when some errors occurred in bitmaps, the
discard is disabled.

As an addition, when there is any not-yet-zeroed inode table and
discard zeroes data, then inode table is marked as zeroed.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/e2fsck.8.in |    7 +++
 e2fsck/e2fsck.h    |    1 +
 e2fsck/pass5.c     |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c      |   10 ++++-
 4 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3fb15e6..507f7b1 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -19,6 +19,9 @@ e2fsck \- check a Linux ext2/ext3/ext4 file system
 .I blocksize
 ]
 [
+.B \-K
+]
+[
 .BR \-l | \-L
 .I bad_blocks_file
 ]
@@ -204,6 +207,10 @@ time trials.
 @JDEV@Set the pathname where the external-journal for this filesystem can be
 @JDEV@found.
 .TP
+.BI \-K
+Keep, do not attempt to discard free blocks and unused inodes (discarding
+blocks is useful on solid state devices and sparse / thin-provisioned storage).
+.TP
 .BI \-k
 When combined with the 
 .B \-c
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
index cbc12f3..a1db499 100644
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
@@ -64,6 +73,66 @@ void e2fsck_pass5(e2fsck_t ctx)
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
+#ifdef __linux__
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+#ifndef BLKDISCARDZEROES
+#define BLKDISCARDZEROES _IO(0x12,124)
+#endif
+
+static void e2fsck_discard_blocks(e2fsck_t ctx, blk_t start,
+				  blk_t count)
+{
+	int fd;
+	int ret = 0;
+	int blocksize;
+	ext2_filsys fs = ctx->fs;
+	__uint64_t range[2];
+
+	blocksize = EXT2_BLOCK_SIZE(fs->super);
+
+	range[0] = (__uint64_t)(start);
+	range[1] = (__uint64_t)(count);
+	range[0] *= (__uint64_t)(blocksize);
+	range[1] *= (__uint64_t)(blocksize);
+
+	fd = open64(fs->device_name, O_RDWR);
+	if (fd < 0) {
+		com_err("open", errno,
+			_("while opening %s for discarding"),
+			ctx->device_name);
+		fatal_error(ctx, 0);
+	}
+
+	ret = ioctl(fd, BLKDISCARD, &range);
+	if (ret)
+		ctx->options &= ~E2F_OPT_DISCARD;
+
+	close(fd);
+}
+
+static int e2fsck_discard_zeroes_data(ext2_filsys fs)
+{
+	int fd;
+	int ret;
+	int discard_zeroes_data = 0;
+
+	fd = open64(fs->device_name, O_RDWR);
+
+	if (fd > 0) {
+		ioctl(fd, BLKDISCARDZEROES, &discard_zeroes_data);
+		close(fd);
+	}
+	return discard_zeroes_data;
+}
+#else
+#define e2fsck_discard_blocks(fs, start, len)
+#define e2fsck_discard_zeroes_data(fs)		0
+#endif
+
 #define NO_BLK ((blk64_t) -1)
 
 static void print_bitmap_problem(e2fsck_t ctx, int problem,
@@ -108,6 +177,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	int	group = 0;
 	int	blocks = 0;
 	blk64_t	free_blocks = 0;
+	blk64_t first_free = ext2fs_blocks_count(fs->super);
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
@@ -280,11 +350,24 @@ redo_counts:
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
+				e2fsck_discard_blocks(ctx, first_free,
+					(i - first_free));
+			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
 		if ((blocks == fs->super->s_blocks_per_group) ||
@@ -500,6 +583,11 @@ redo_counts:
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
@@ -509,11 +597,42 @@ do_counts:
 			group_free++;
 			free_inodes++;
 		}
+
 		inodes++;
 		if ((inodes == fs->super->s_inodes_per_group) ||
 		    (i == fs->super->s_inodes_count)) {
+			blk64_t used_blks, blk, num;
+
 			free_array[group] = group_free;
 			dir_array[group] = dirs_count;
+
+			/* Discard inode table */
+			if (ctx->options & E2F_OPT_DISCARD) {
+				used_blks = DIV_ROUND_UP(
+					(EXT2_INODES_PER_GROUP(fs->super) -
+					group_free),
+					EXT2_INODES_PER_BLOCK(fs->super));
+
+				blk = ext2fs_inode_table_loc(fs, group) +
+				      used_blks;
+				num = fs->inode_blocks_per_group -
+				      used_blks;
+				e2fsck_discard_blocks(ctx, blk, num);
+			}
+
+			/*
+			 * If discard zeroes data and the group inode table
+			 * was not zeroed yet, set itable as zeroed
+			 */
+			if ((ctx->options & E2F_OPT_DISCARD) &&
+			    (e2fsck_discard_zeroes_data(fs)) &&
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
index 7eb269c..15dd204 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -667,7 +667,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
-	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+
+	/* set defaults */
+	ctx->options |= E2F_OPT_DISCARD;
+
+	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDkK")) != EOF)
 		switch (c) {
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
@@ -790,6 +794,9 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'k':
 			keep_bad_blocks++;
 			break;
+		case 'K':
+			ctx->options &= ~E2F_OPT_DISCARD;
+			break;
 		default:
 			usage(ctx);
 		}
@@ -943,7 +950,6 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 	return retval;
 }
 
