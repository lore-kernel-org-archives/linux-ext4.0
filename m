From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v3.1 13/54] e2fsck: Verify inode bitmap checksum
Date: Mon, 12 Mar 2012 17:32:33 -0700
Message-ID: <20120313003233.GR15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com> <20120310054657.GA1048@thunk.org> <20120311021150.GB1048@thunk.org> <20120312212537.GL15164@tux1.beaverton.ibm.com> <20120312223010.GO15164@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:43078 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab2CMAdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 20:33:22 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 18:33:20 -0600
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id BEDB8C90063
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:32:36 -0400 (EDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2D0Wajo313898
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:32:36 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2D0WXva004142
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:32:35 -0600
Content-Disposition: inline
In-Reply-To: <20120312223010.GO15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rewrite the block bitmap when the checksum doesn't match.  This is
ok since e2fsck will have already computed the correct inode bitmap.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 e2fsck/pass5.c   |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |    5 ++++
 e2fsck/problem.h |    3 +++
 3 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 1e836e3..bfcf384 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -27,6 +27,7 @@ static void check_block_bitmaps(e2fsck_t ctx);
 static void check_inode_bitmaps(e2fsck_t ctx);
 static void check_inode_end(e2fsck_t ctx);
 static void check_block_end(e2fsck_t ctx);
+static void check_inode_bitmap_checksum(e2fsck_t ctx);
 
 void e2fsck_pass5(e2fsck_t ctx)
 {
@@ -64,6 +65,8 @@ void e2fsck_pass5(e2fsck_t ctx)
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
 
+	check_inode_bitmap_checksum(ctx);
+
 	ext2fs_free_inode_bitmap(ctx->inode_used_map);
 	ctx->inode_used_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_dir_map);
@@ -74,6 +77,65 @@ void e2fsck_pass5(e2fsck_t ctx)
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
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	/* If bitmap is dirty from being fixed, checksum will be corrected */
+	if (ext2fs_test_ib_dirty(ctx->fs))
+		return;
+
+	nbytes = (size_t)(EXT2_INODES_PER_GROUP(ctx->fs->super) / 8);
+	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
+				     &buf);
+	if (retval) {
+		com_err(ctx->program_name, 0,
+		    _("check_inode_bitmap_checksum: Memory allocation error"));
+		fatal_error(ctx, 0);
+	}
+
+	clear_problem_context(&pctx);
+	for (i = 0; i < ctx->fs->group_desc_count; i++) {
+		if (ext2fs_bg_flags_test(ctx->fs, i, EXT2_BG_INODE_UNINIT))
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
+		/*
+		 * Fixing one checksum will rewrite all of them.  The bitmap
+		 * will be checked against the one we made during pass1 for
+		 * discrepancies, and fixed if need be.
+		 */
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
index a2a1a44..79ad34d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1684,6 +1684,11 @@ static struct e2fsck_problem problem_table[] = {
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
index 5797fe2..0adc7ea 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1019,6 +1019,9 @@ struct problem_context {
 /* Inode in use but group is marked INODE_UNINIT */
 #define PR_5_INODE_UNINIT		0x050019
 
+/* Inode bitmap checksum does not match */
+#define PR_5_INODE_BITMAP_CSUM_INVALID	0x05001A
+
 /*
  * Post-Pass 5 errors
  */

