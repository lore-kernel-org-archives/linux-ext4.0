From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 16/51] e2fsck: Verify block bitmap checksum
Date: Sat, 07 Jan 2012 00:34:38 -0800
Message-ID: <20120107083438.25788.38347.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35520 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491Ab2AGIeo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:34:44 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:34:43 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078Yf7Y307212
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:34:41 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078Yejl008125
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 06:34:41 -0200
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check block bitmap checksum and write a new checksum if the verification fails.
This is ok because e2fsck has already computed the correct block bitmap.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass5.c   |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |    5 ++++
 e2fsck/problem.h |    3 ++
 3 files changed, 73 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index fbdde5f..0e86efa 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -28,6 +28,7 @@ static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
 static void check_inode_bitmap_checksum(e2fsck_t ctx);
+static void check_block_bitmap_checksum(e2fsck_t ctx);
 
 void e2fsck_pass5(e2fsck_t ctx)
 {
@@ -66,6 +67,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 		return;
 
 	check_inode_bitmap_checksum(ctx);
+	check_block_bitmap_checksum(ctx);
 
 	ext2fs_free_inode_bitmap(ctx->inode_used_map);
 	ctx->inode_used_map = 0;
@@ -138,6 +140,69 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	ext2fs_free_mem(&buf);
 }
 
+static void check_block_bitmap_checksum(e2fsck_t ctx)
+{
+	struct problem_context	pctx;
+	struct ext4_group_desc	*gdp;
+	char		*buf;
+	dgrp_t		i;
+	int		nbytes;
+	blk64_t		blk_itr;
+	errcode_t	retval;
+	int		csum_flag = 0;
+
+	/* If bitmap is dirty from being fixed, checksum will be corrected */
+	if (ext2fs_test_bb_dirty(ctx->fs))
+		return;
+
+	nbytes = (size_t)(EXT2_BLOCKS_PER_GROUP(ctx->fs->super) / 8);
+	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
+				     &buf);
+	if (retval) {
+		com_err(ctx->program_name, 0,
+		    _("check_block_bitmap_checksum: Memory allocation error"));
+		fatal_error(ctx, 0);
+	}
+
+	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		csum_flag = 1;
+
+	clear_problem_context(&pctx);
+	for (i = 0; i < ctx->fs->group_desc_count; i++) {
+		if (csum_flag && ext2fs_bg_flags_test(ctx->fs, i,
+						      EXT2_BG_BLOCK_UNINIT))
+			continue;
+
+		blk_itr = EXT2FS_B2C(ctx->fs,
+				     ctx->fs->super->s_first_data_block) +
+			  (i * (nbytes << 3));
+		gdp = (struct ext4_group_desc *)ext2fs_group_desc(ctx->fs,
+				ctx->fs->group_desc, i);
+		retval = ext2fs_get_block_bitmap_range2(ctx->fs->block_map,
+							blk_itr, nbytes << 3,
+							buf);
+		if (retval)
+			break;
+
+		if (ext2fs_block_bitmap_csum_verify(ctx->fs, i, buf, nbytes))
+			continue;
+		pctx.group = i;
+		if (!fix_problem(ctx, PR_5_BLOCK_BITMAP_CSUM_INVALID, &pctx))
+			continue;
+
+		/*
+		 * Fixing one checksum will rewrite all of them.  The bitmap
+		 * will be checked against the one we made during pass1 for
+		 * discrepancies, and fixed if need be.
+		 */
+		ext2fs_mark_bb_dirty(ctx->fs);
+		break;
+	}
+
+	ext2fs_free_mem(&buf);
+}
+
 static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
 				  blk64_t start, blk64_t count)
 {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 54894d5..95813ce 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1694,6 +1694,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@g %g @i bitmap does not match checksum\n"),
 	  PROMPT_FIX, PR_LATCH_IBITMAP | PR_PREEN_OK },
 
+	/* Group N block bitmap does not match checksum */
+	{ PR_5_BLOCK_BITMAP_CSUM_INVALID,
+	  N_("@g %g @b bitmap does not match checksum\n"),
+	  PROMPT_FIX, PR_LATCH_BBITMAP | PR_PREEN_OK },
+
 	/* Post-Pass 5 errors */
 
 	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index dbc256e..51a911b 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1022,6 +1022,9 @@ struct problem_context {
 /* Inode bitmap checksum does not match */
 #define PR_5_INODE_BITMAP_CSUM_INVALID	0x05001A
 
+/* Block bitmap checksum does not match */
+#define PR_5_BLOCK_BITMAP_CSUM_INVALID	0x05001B
+
 /*
  * Post-Pass 5 errors
  */

