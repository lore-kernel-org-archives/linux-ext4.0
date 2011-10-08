From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 12/47] e2fsck: Verify inode bitmap checksum
Date: Sat, 08 Oct 2011 00:34:32 -0700
Message-ID: <20111008073432.17888.53030.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e38.co.us.ibm.com ([32.97.110.159]:51440 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1JHHgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:36:39 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987SK6s002387
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:28:20 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987YYoT199184
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:34:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987YXtx011782
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:34:34 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rewrite the block bitmap when the checksum doesn't match.  This is ok since
e2fsck will have already computed the correct inode bitmap.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass5.c   |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 3 files changed, 67 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index a60e84a..104ab84 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -27,6 +27,7 @@ static void check_block_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
+static void check_inode_bitmap_checksum(e2fsck_t ctx);
 
 void e2fsck_pass5(e2fsck_t ctx)
 {
@@ -49,7 +50,9 @@ void e2fsck_pass5(e2fsck_t ctx)
 		if ((ctx->progress)(ctx, 5, 0, ctx->fs->group_desc_count*2))
 			return;
 
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	e2fsck_read_bitmaps(ctx);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 
 	check_block_bitmaps(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -64,6 +67,8 @@ void e2fsck_pass5(e2fsck_t ctx)
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
 
+	check_inode_bitmap_checksum(ctx);
+
 	ext2fs_free_inode_bitmap(ctx->inode_used_map);
 	ctx->inode_used_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_dir_map);
@@ -74,6 +79,60 @@ void e2fsck_pass5(e2fsck_t ctx)
 	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
+static void check_inode_bitmap_checksum(e2fsck_t ctx)
+{
+	struct problem_context	pctx;
+	struct ext4_group_desc	*gdp;
+	char		*buf;
+	dgrp_t		i;
+	int		nbytes;
+	ext2_ino_t	ino_itr;
+	errcode_t	retval;
+	int		csum_flag = 0;
+
+	/* If bitmap is dirty from being fixed, checksum will be corrected */
+	if (ext2fs_test_ib_dirty(ctx->fs))
+		return;
+
+	nbytes = (size_t)(EXT2_INODES_PER_GROUP(ctx->fs->super) / 8);
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
+						      EXT2_BG_INODE_UNINIT))
+			continue;
+
+		ino_itr = 1 + (i * (nbytes << 3));
+		gdp = (struct ext4_group_desc *)ext2fs_group_desc(ctx->fs,
+				ctx->fs->group_desc, i);
+		retval = ext2fs_get_inode_bitmap_range2(ctx->fs->inode_map,
+							ino_itr, nbytes << 3,
+							buf);
+		if (retval)
+			break;
+
+		if (ext2fs_inode_bitmap_csum_verify(ctx->fs, i, buf, nbytes))
+			continue;
+		pctx.group = i;
+		if (!fix_problem(ctx, PR_5_INODE_BITMAP_CSUM_INVALID, &pctx))
+			continue;
+
+		/* Fixing one checksum will rewrite all of them */
+		ext2fs_mark_ib_dirty(ctx->fs);
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
index 86cd954..9134f92 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1694,6 +1694,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@g %g @i(s) in use but @g is marked INODE_UNINIT\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Group N inode bitmap does not match checksum */
+	{ PR_5_INODE_BITMAP_CSUM_INVALID,
+	  N_("@g %g @i bitmap does not match checksum\n"),
+	  PROMPT_FIX, PR_LATCH_IBITMAP | PR_PREEN_OK },
+
 	/* Post-Pass 5 errors */
 
 	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index e1c7f26..d6b36ef 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1022,6 +1022,9 @@ struct problem_context {
 /* Inode in use but group is marked INODE_UNINIT */
 #define PR_5_INODE_UNINIT		0x050019
 
+/* Inode bitmap checksum does not match */
+#define PR_5_INODE_BITMAP_CSUM_INVALID	0x05001A
+
 /*
  * Post-Pass 5 errors
  */

