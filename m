Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36B2C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 16:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8AE52082F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 16:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfC1Qmf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 12:42:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:39722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbfC1Qme (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Mar 2019 12:42:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9307FAC70;
        Thu, 28 Mar 2019 16:42:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4BE5C1E08FF; Thu, 28 Mar 2019 17:42:32 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsck: Check and fix tails of all bitmaps
Date:   Thu, 28 Mar 2019 17:42:18 +0100
Message-Id: <20190328164218.19265-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently, e2fsck effectively checks only tail of the last inode and
block bitmap in the filesystem. Thus if some previous bitmap has unset
bits it goes unnoticed. Mostly these tail bits in the bitmap are ignored
however if blocks_per_group are smaller than 8*blocksize, mballoc code
in the kernel can get confused when the tail bits are unset and return
bogus free extent.

Add support to libext2fs to check these bitmap tails when loading
bitmaps (as that's about the only place which has access to the bitmap
tail bits) and make e2fsck use this functionality to detect buggy bitmap
tails and fix them (by rewriting bitmaps).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/e2fsck.h           |  2 +
 e2fsck/pass5.c            | 96 +++++++----------------------------------------
 e2fsck/problem.c          |  5 ---
 e2fsck/problem.h          |  3 --
 e2fsck/util.c             | 29 ++++++++++++--
 lib/ext2fs/ext2_err.et.in |  6 +++
 lib/ext2fs/ext2fs.h       |  1 +
 lib/ext2fs/rw_bitmaps.c   | 22 +++++++++++
 8 files changed, 69 insertions(+), 95 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 1c7a67cba1ce..b32fbf0e8bdf 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -198,6 +198,8 @@ struct resource_track {
 #define E2F_FLAG_TIME_INSANE	0x2000 /* Time is insane */
 #define E2F_FLAG_PROBLEMS_FIXED	0x4000 /* At least one problem was fixed */
 #define E2F_FLAG_ALLOC_OK	0x8000 /* Can we allocate blocks? */
+#define E2F_FLAG_INODE_BMP_TAIL	0x10000 /* Inode bitmap has incorrect tail */
+#define E2F_FLAG_BLOCK_BMP_TAIL	0x20000 /* Block bitmap has incorrect tail */
 
 #define E2F_RESET_FLAGS (E2F_FLAG_TIME_INSANE | E2F_FLAG_PROBLEMS_FIXED)
 
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 7803e8b80178..c8e2278eb305 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -23,8 +23,7 @@
 
 static void check_block_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
-static void check_inode_end(e2fsck_t ctx);
-static void check_block_end(e2fsck_t ctx);
+static void check_bitmap_tails(e2fsck_t ctx);
 static void check_inode_bitmap_checksum(e2fsck_t ctx);
 static void check_block_bitmap_checksum(e2fsck_t ctx);
 
@@ -57,10 +56,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 	check_inode_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
-	check_inode_end(ctx);
-	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
-		return;
-	check_block_end(ctx);
+	check_bitmap_tails(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
 
@@ -833,93 +829,27 @@ errout:
 	ext2fs_free_mem(&dir_array);
 }
 
-static void check_inode_end(e2fsck_t ctx)
+static void check_bitmap_tails(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	ext2_ino_t	end, save_inodes_count, i;
 	struct problem_context	pctx;
 
 	clear_problem_context(&pctx);
 
-	end = EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count;
-	pctx.errcode = ext2fs_fudge_inode_bitmap_end(fs->inode_map, end,
-						     &save_inodes_count);
-	if (pctx.errcode) {
-		pctx.num = 1;
-		fix_problem(ctx, PR_5_FUDGE_BITMAP_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
-	}
-	if (save_inodes_count == end)
-		return;
-
-	/* protect loop from wrap-around if end is maxed */
-	for (i = save_inodes_count + 1; i <= end && i > save_inodes_count; i++) {
-		if (!ext2fs_test_inode_bitmap(fs->inode_map, i)) {
-			if (fix_problem(ctx, PR_5_INODE_BMAP_PADDING, &pctx)) {
-				for (; i <= end; i++)
-					ext2fs_mark_inode_bitmap(fs->inode_map,
-								 i);
-				ext2fs_mark_ib_dirty(fs);
-			} else
-				ext2fs_unmark_valid(fs);
-			break;
-		}
-	}
-
-	pctx.errcode = ext2fs_fudge_inode_bitmap_end(fs->inode_map,
-						     save_inodes_count, 0);
-	if (pctx.errcode) {
-		pctx.num = 2;
-		fix_problem(ctx, PR_5_FUDGE_BITMAP_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+	if (ctx->flags & E2F_FLAG_INODE_BMP_TAIL) {
+		if (fix_problem(ctx, PR_5_INODE_BMAP_PADDING, &pctx))
+			ext2fs_mark_ib_dirty(fs);
+		else
+			ext2fs_unmark_valid(fs);
 	}
-}
-
-static void check_block_end(e2fsck_t ctx)
-{
-	ext2_filsys fs = ctx->fs;
-	blk64_t	end, save_blocks_count, i;
-	struct problem_context	pctx;
 
 	clear_problem_context(&pctx);
 
-	end = ext2fs_get_block_bitmap_start2(fs->block_map) +
-		EXT2_GROUPS_TO_CLUSTERS(fs->super, fs->group_desc_count) - 1;
-	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map, end,
-						     &save_blocks_count);
-	if (pctx.errcode) {
-		pctx.num = 3;
-		fix_problem(ctx, PR_5_FUDGE_BITMAP_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
-	}
-	if (save_blocks_count == end)
-		return;
-
-	/* Protect loop from wrap-around if end is maxed */
-	for (i = save_blocks_count + 1; i <= end && i > save_blocks_count; i++) {
-		if (!ext2fs_test_block_bitmap2(fs->block_map,
-					       EXT2FS_C2B(fs, i))) {
-			if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx)) {
-				for (; i <= end; i++)
-					ext2fs_mark_block_bitmap2(fs->block_map,
-							EXT2FS_C2B(fs, i));
-				ext2fs_mark_bb_dirty(fs);
-			} else
-				ext2fs_unmark_valid(fs);
-			break;
-		}
-	}
-
-	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map,
-						     save_blocks_count, 0);
-	if (pctx.errcode) {
-		pctx.num = 4;
-		fix_problem(ctx, PR_5_FUDGE_BITMAP_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT; /* fatal */
-		return;
+	if (ctx->flags & E2F_FLAG_BLOCK_BMP_TAIL) {
+		if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx))
+			ext2fs_mark_bb_dirty(fs);
+		else
+			ext2fs_unmark_valid(fs);
 	}
 }
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0e6bacec21ab..c341f560b67f 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1993,11 +1993,6 @@ static struct e2fsck_problem problem_table[] = {
 	  "match calculated @B endpoints (%i, %j)\n"),
 	  PROMPT_NONE, PR_FATAL, 0, 0, 0 },
 
-	/* Internal error: fudging end of bitmap */
-	{ PR_5_FUDGE_BITMAP_ERROR,
-	  N_("Internal error: fudging end of bitmap (%N)\n"),
-	  PROMPT_NONE, PR_FATAL, 0, 0, 0 },
-
 	/* Error copying in replacement inode bitmap */
 	{ PR_5_COPY_IBITMAP_ERROR,
 	  N_("Error copying in replacement @i @B: %m\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 2c79169ef33b..11c89627387a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1200,9 +1200,6 @@ struct problem_context {
 /* Programming error: bitmap endpoints don't match */
 #define PR_5_BMAP_ENDPOINTS		0x050010
 
-/* Internal error: fudging end of bitmap */
-#define PR_5_FUDGE_BITMAP_ERROR		0x050011
-
 /* Error copying in replacement inode bitmap */
 #define PR_5_COPY_IBITMAP_ERROR		0x050012
 
diff --git a/e2fsck/util.c b/e2fsck/util.c
index db6a1cc11a23..3468fccc3327 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -310,7 +310,7 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	errcode_t	retval;
 	const char	*old_op;
 	unsigned int	save_type;
-	int		flags;
+	int		flags, mask;
 
 	if (ctx->invalid_bitmaps) {
 		com_err(ctx->program_name, 0,
@@ -322,11 +322,32 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	old_op = ehandler_operation(_("reading inode and block bitmaps"));
 	e2fsck_set_bitmap_type(fs, EXT2FS_BMAP64_RBTREE, "fs_bitmaps",
 			       &save_type);
+	mask = EXT2_FLAG_IGNORE_CSUM_ERRORS | EXT2_FLAG_VERIFY_BITMAP_TAILS;
 	flags = ctx->fs->flags;
-	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	ctx->fs->flags |= mask;
 	retval = ext2fs_read_bitmaps(fs);
-	ctx->fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
-			 (ctx->fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
+	if (retval == EXT2_ET_BLOCK_BITMAP_TAIL ||
+	    retval == EXT2_ET_INODE_BITMAP_TAIL) {
+		/*
+		 * Read bitmaps one after another to find out which ones have
+		 * wrong tails.
+		 */
+		retval = ext2fs_read_inode_bitmap(fs);
+		if (retval == EXT2_ET_INODE_BITMAP_TAIL)
+			ctx->flags |= E2F_FLAG_INODE_BMP_TAIL;
+		else if (retval)
+			goto restore_flags;
+		retval = ext2fs_read_block_bitmap(fs);
+		if (retval == EXT2_ET_BLOCK_BITMAP_TAIL)
+			ctx->flags |= E2F_FLAG_BLOCK_BMP_TAIL;
+		else if (retval)
+			goto restore_flags;
+		/* Now read the failed ones without checking */
+		ctx->fs->flags &= ~EXT2_FLAG_VERIFY_BITMAP_TAILS;
+		retval = ext2fs_read_bitmaps(fs);
+	}
+restore_flags:
+	ctx->fs->flags = (flags & mask) | (ctx->fs->flags & ~mask);
 	fs->default_bitmap_type = save_type;
 	ehandler_operation(old_op);
 	if (retval) {
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index b2ba71ad2fd5..c2beece13100 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -545,4 +545,10 @@ ec	EXT2_ET_INODE_CORRUPTED,
 ec	EXT2_ET_EA_INODE_CORRUPTED,
 	"Inode containing extended attribute value is corrupted"
 
+ec	EXT2_ET_BLOCK_BITMAP_TAIL,
+	"Block bitmap tail is not completely set"
+
+ec	EXT2_ET_INODE_BITMAP_TAIL,
+	"Inode bitmap tail is not completely set"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9e76ffaaa873..3b223b3322a3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
 #define EXT2_FLAG_SHARE_DUP		0x400000
 #define EXT2_FLAG_IGNORE_SB_ERRORS	0x800000
+#define EXT2_FLAG_VERIFY_BITMAP_TAILS	0x1000000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index e86bacd5321a..1d578283d08f 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -195,6 +195,16 @@ static errcode_t mark_uninit_bg_group_blocks(ext2_filsys fs)
 	return 0;
 }
 
+static int bitmap_tail_verify(unsigned char *bitmap, int first, int last)
+{
+	int i;
+
+	for (i = first; i <= last; i++)
+		if (bitmap[i] != 0xff)
+			return 0;
+	return 1;
+}
+
 static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 {
 	dgrp_t i;
@@ -315,6 +325,12 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					EXT2_ET_BLOCK_BITMAP_CSUM_INVALID;
 					goto cleanup;
 				}
+				if (fs->flags & EXT2_FLAG_VERIFY_BITMAP_TAILS
+				    && !bitmap_tail_verify(block_bitmap,
+						block_nbytes, fs->blocksize - 1)) {
+					retval = EXT2_ET_BLOCK_BITMAP_TAIL;
+					goto cleanup;
+				}
 			} else
 				memset(block_bitmap, 0, block_nbytes);
 			cnt = block_nbytes << 3;
@@ -347,6 +363,12 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					EXT2_ET_INODE_BITMAP_CSUM_INVALID;
 					goto cleanup;
 				}
+				if (fs->flags & EXT2_FLAG_VERIFY_BITMAP_TAILS
+				    && !bitmap_tail_verify(inode_bitmap,
+						inode_nbytes, fs->blocksize - 1)) {
+					retval = EXT2_ET_INODE_BITMAP_TAIL;
+					goto cleanup;
+				}
 			} else
 				memset(inode_bitmap, 0, inode_nbytes);
 			cnt = inode_nbytes << 3;
-- 
2.16.4

