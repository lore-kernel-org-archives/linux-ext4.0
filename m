From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/18] e2fsck: don't offer to fix the checksum of fixed
 extents
Date: Fri, 25 Jul 2014 17:35:31 -0700
Message-ID: <20140726003531.28334.40019.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32049 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaGZAfh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:35:37 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an extent fails checksum and the sanity checks, and the user elects
to fix the extents, don't bother asking (the second time) if the user
would like to fix the checksum.  Refactor some redundant code to make
what's going on a little cleaner.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c02f5e9..f5e3f11 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2056,12 +2056,14 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		last_lblk = extent.e_lblk + extent.e_len - 1;
 
 		problem = 0;
+		pctx->blk = extent.e_pblk;
+		pctx->blk2 = extent.e_lblk;
+		pctx->num = extent.e_len;
+		pctx->blkcount = extent.e_lblk + extent.e_len;
+
 		/* Ask to clear a corrupt extent block */
 		if (try_repairs &&
 		    pctx->errcode == EXT2_ET_EXTENT_CSUM_INVALID) {
-			pctx->blk = extent.e_pblk;
-			pctx->blk2 = extent.e_lblk;
-			pctx->num = extent.e_len;
 			problem = PR_1_EXTENT_CSUM_INVALID;
 			if (fix_problem(ctx, problem, pctx))
 				goto fix_problem_now;
@@ -2105,25 +2107,18 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			failed_csum = 0;
 		}
 
-		/* Corrupt but passes checks?  Ask to fix checksum. */
-		if (try_repairs && failed_csum) {
-			pctx->blk = extent.e_pblk;
-			pctx->blk2 = extent.e_lblk;
-			pctx->num = extent.e_len;
-			problem = 0;
-			if (fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID,
-					pctx)) {
-				pb->inode_modified = 1;
-				ext2fs_extent_replace(ehandle, 0, &extent);
-			}
+		/* Failed csum but passes checks?  Ask to fix checksum. */
+		if (try_repairs && failed_csum && problem == 0 &&
+		    fix_problem(ctx, PR_1_EXTENT_ONLY_CSUM_INVALID, pctx)) {
+			pb->inode_modified = 1;
+			pctx->errcode = ext2fs_extent_replace(ehandle,
+							0, &extent);
+			if (pctx->errcode)
+				return;
 		}
 
 		if (try_repairs && problem) {
 report_problem:
-			pctx->blk = extent.e_pblk;
-			pctx->blk2 = extent.e_lblk;
-			pctx->num = extent.e_len;
-			pctx->blkcount = extent.e_lblk + extent.e_len;
 			if (fix_problem(ctx, problem, pctx)) {
 fix_problem_now:
 				if (ctx->invalid_bitmaps) {

