From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/51] e2fsck: Verify extent tree blocks and clear the bad ones
Date: Sat, 07 Jan 2012 00:35:10 -0800
Message-ID: <20120107083510.25788.57961.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41500 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab2AGIfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:35:18 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:35:17 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078ZFT7349968
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:35:15 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078ZBsx017687
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:35:14 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we encounter an extent tree block that passes the header check but fails
the checksum, offer to clear just that extent block instead of failing the
whole tree, which results in the entire inode being wiped out.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |   34 ++++++++++++++++++++++++++++++++--
 e2fsck/problem.c |   15 +++++++++++++++
 e2fsck/problem.h |    6 ++++++
 3 files changed, 53 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c382a7b..1ae117d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1805,6 +1805,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	int			is_dir, is_leaf;
 	errcode_t		problem;
 	struct ext2_extent_info	info;
+	int			failed_csum;
 
 	pctx->errcode = ext2fs_extent_get_info(ehandle, &info);
 	if (pctx->errcode)
@@ -1812,11 +1813,25 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 	pctx->errcode = ext2fs_extent_get(ehandle, EXT2_EXTENT_FIRST_SIB,
 					  &extent);
-	while (!pctx->errcode && info.num_entries-- > 0) {
+	while ((pctx->errcode == 0 ||
+		pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) &&
+	       info.num_entries-- > 0) {
+		failed_csum = 0;
 		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
 
 		problem = 0;
+		/* Ask to clear a corrupt extent block */
+		if (pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) {
+			pctx->blk = extent.e_pblk;
+			pctx->blk2 = extent.e_lblk;
+			pctx->num = extent.e_len;
+			problem = PR_1_EXTENT_CSUM_INVALID;
+			if (fix_problem(ctx, problem, pctx))
+				goto fix_problem_now;
+			failed_csum = 1;
+		}
+
 		if (extent.e_pblk == 0 ||
 		    extent.e_pblk < ctx->fs->super->s_first_data_block ||
 		    extent.e_pblk >= ext2fs_blocks_count(ctx->fs->super))
@@ -1828,12 +1843,24 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			 ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
+		/* Corrupt but passes checks?  Ask to fix checksum. */
+		if (failed_csum) {
+			pctx->blk = extent.e_pblk;
+			pctx->blk2 = extent.e_lblk;
+			pctx->num = extent.e_len;
+			problem = 0;
+			if (fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID,
+					pctx))
+				ext2fs_extent_replace(ehandle, 0, &extent);
+		}
+
 		if (problem) {
 		report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
 			if (fix_problem(ctx, problem, pctx)) {
+fix_problem_now:
 				e2fsck_read_bitmaps(ctx);
 				pctx->errcode =
 					ext2fs_extent_delete(ehandle, 0);
@@ -1860,7 +1887,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			if (pctx->errcode) {
 				pctx->str = "EXT2_EXTENT_DOWN";
 				problem = PR_1_EXTENT_HEADER_INVALID;
-				if (pctx->errcode == EXT2_ET_EXTENT_HEADER_BAD)
+				if (pctx->errcode ==
+					EXT2_ET_EXTENT_HEADER_BAD ||
+				    pctx->errcode ==
+					EXT2_ET_EXTENT_CSUM_INVALID)
 					goto report_problem;
 				return;
 			}
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 95813ce..cd404f8 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -951,6 +951,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inode extent block checksum does not match extent */
+	{ PR_1_EXTENT_CSUM_INVALID,
+	  N_("@i %i extent block checksum does not match extent\n\t(logical @b "
+	     "%c, @n physical @b %b, len %N)\n"),
+	  PROMPT_CLEAR, 0 },
+
+	/*
+	 * Inode extent block passes checks, but checksum does not match
+	 * extent
+	 */
+	{ PR_1_EXTENT_ONLY_CSUM_INVALID,
+	  N_("@i %i extent block passes checks, but checksum does not match "
+	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 51a911b..cd9e4ed 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -556,6 +556,12 @@ struct problem_context {
 /* inode passes checks, but checksum does not match inode */
 #define PR_1_INODE_ONLY_CSUM_INVALID	0x010067
 
+/* extent block checksum does not match extent block */
+#define PR_1_EXTENT_CSUM_INVALID	0x010068
+
+/* extent block passes checks, but checksum does not match extent block */
+#define PR_1_EXTENT_ONLY_CSUM_INVALID	0x010069
+
 /*
  * Pass 1b errors
  */

