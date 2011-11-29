From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 20/50] e2fsck: Verify extent tree blocks and clear the bad ones
Date: Mon, 28 Nov 2011 16:30:06 -0800
Message-ID: <20111129003006.17953.91956.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59521 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1K2AbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:31:00 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:30:59 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0UKhJ302670
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:30:20 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0UC4I005067
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:30:15 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we encounter an extent tree block that passes the header check but fails
the checksum, offer to clear just that extent block instead of failing the
whole tree, which results in the entire inode being wiped out.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |   11 +++++++++--
 e2fsck/problem.c |    6 ++++++
 e2fsck/problem.h |    3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 537538c..f7be09a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1761,7 +1761,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 
 	pctx->errcode = ext2fs_extent_get(ehandle, EXT2_EXTENT_FIRST_SIB,
 					  &extent);
-	while (!pctx->errcode && info.num_entries-- > 0) {
+	while ((pctx->errcode == 0 ||
+		pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) &&
+	       info.num_entries-- > 0) {
 		is_leaf = extent.e_flags & EXT2_EXTENT_FLAGS_LEAF;
 		is_dir = LINUX_S_ISDIR(pctx->inode->i_mode);
 
@@ -1776,6 +1778,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			 (extent.e_pblk + extent.e_len) >
 			 ext2fs_blocks_count(ctx->fs->super))
 			problem = PR_1_EXTENT_ENDS_BEYOND;
+		else if (pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID)
+			problem = PR_1_EXTENT_CSUM_INVALID;
 
 		if (problem) {
 		report_problem:
@@ -1809,7 +1813,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
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
index e74ad79..96b0de5 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -946,6 +946,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* Extent block does not match extent */
+	{ PR_1_EXTENT_CSUM_INVALID,
+	  N_("@i %i extent block checksum does not match extent\n\t(logical @b "
+	     "%c, @n physical @b %b, len %N)\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 1d63598..a1e7ffb 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -553,6 +553,9 @@ struct problem_context {
 /* inode checksum does not match inode */
 #define PR_1_INODE_CSUM_INVALID		0x010066
 
+/* extent block checksum does not match extent block */
+#define PR_1_EXTENT_CSUM_INVALID	0x010067
+
 /*
  * Pass 1b errors
  */

