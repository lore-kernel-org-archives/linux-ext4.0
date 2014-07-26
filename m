From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/18] e2fsck: fix merge error in "clear uninit flag on
 directory extents"
Date: Fri, 25 Jul 2014 17:33:51 -0700
Message-ID: <20140726003351.28334.1044.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31735 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGZAd4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:33:56 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the original patch (against -next), the hunk to fix uninit dirs was
just prior to the hunk labelled "Corrupt but passes checks?".  The
hunks are ordered this way so that if e2fsck obtains permission to fix
a failed-csum extent (which in turn fixes the checksum), it will not
subsequently ask to (re)fix the checksum.

Due to a merge error the hunk moved to the wrong place, so put it
back.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c116e1c..a6552e5 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2009,19 +2009,6 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			  (1 << (21 - ctx->fs->super->s_log_block_size))))
 			problem = PR_1_TOOBIG_DIR;
 
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
-		}
