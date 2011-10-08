From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 15/47] e2fsck: Verify block bitmap checksum
Date: Sat, 08 Oct 2011 00:34:51 -0700
Message-ID: <20111008073451.17888.70274.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49423 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab1JHHhr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:37:47 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:37:46 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987Ytb3439566
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987YqSY019744
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:34:54 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check block bitmap checksum and write a new checksum if the verification fails.
This is ok because e2fsck has already computed the correct block bitmap.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass5.c   |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 3 files changed, 66 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 104ab84..c04ff37 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -28,6 +28,7 @@ static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
 static void check_inode_bitmap_checksum(e2fsck_t ctx);
+static void check_block_bitmap_checksum(e2fsck_t ctx);
 
 void e2fsck_pass5(e2fsck_t ctx)
 {
@@ -68,6 +69,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 		return;
 
 	check_inode_bitmap_checksum(ctx);
+	check_block_bitmap_checksum(ctx);
 
 	ext2fs_free_inode_bitmap(ctx->inode_used_map);
 	ctx->inode_used_map = 0;
@@ -133,6 +135,62 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
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
+	if (retval)
+		return;
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
+		/* Fixing one checksum will rewrite all of them */
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
index 9134f92..62dcae3 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1699,6 +1699,11 @@ static struct e2fsck_problem problem_table[] = {
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
index d6b36ef..a584369 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1025,6 +1025,9 @@ struct problem_context {
 /* Inode bitmap checksum does not match */
 #define PR_5_INODE_BITMAP_CSUM_INVALID	0x05001A
 
+/* Block bitmap checksum does not match */
+#define PR_5_BLOCK_BITMAP_CSUM_INVALID	0x05001B
+
 /*
  * Post-Pass 5 errors
  */

