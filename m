From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/54] e2fsck: Verify extent tree blocks and clear the bad ones
Date: Tue, 06 Mar 2012 15:59:37 -0800
Message-ID: <20120306235937.11945.84562.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:56647 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031468Ab2CFX7r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 18:59:47 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 16:59:47 -0700
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 1681BC90050
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 18:59:43 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26NxhY73477630
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 18:59:43 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26NxfgK015306
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 20:59:42 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
index 471e3e0..332cc22 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1819,6 +1819,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	int			is_dir, is_leaf;
 	errcode_t		problem;
 	struct ext2_extent_info	info;
+	int			failed_csum;
 
 	pctx->errcode = ext2fs_extent_get_info(ehandle, &info);
 	if (pctx->errcode)
@@ -1826,11 +1827,25 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
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
@@ -1842,12 +1857,24 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
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
@@ -1874,7 +1901,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
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
index 7dc4c39..6ceee11 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -946,6 +946,21 @@ static struct e2fsck_problem problem_table[] = {
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
index 39e6dba..2adb4b9 100644
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

