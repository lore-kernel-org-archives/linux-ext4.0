From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/24] e2fsck: skip clearing bad extents if bitmaps are
 unreadable
Date: Fri, 18 Jul 2014 15:53:04 -0700
Message-ID: <20140718225304.31374.95208.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33052 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762695AbaGRWxK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:10 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the bitmaps are known to be unreadable, don't bother clearing them;
just mark fsck to restart itself after pass 5, by which time the
bitmaps should be fixed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ba60029..5c628a3 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1980,6 +1980,26 @@ report_problem:
 			pctx->blkcount = extent.e_lblk + extent.e_len;
 			if (fix_problem(ctx, problem, pctx)) {
 fix_problem_now:
+				if (ctx->invalid_bitmaps) {
+					/*
+					 * If fsck knows the bitmaps are bad,
+					 * skip to the next extent and
+					 * try to clear this extent again
+					 * after fixing the bitmaps, by
+					 * restarting fsck.
+					 */
+					pctx->errcode = ext2fs_extent_get(
+							  ehandle,
+							  EXT2_EXTENT_NEXT_SIB,
+							  &extent);
+					ctx->flags |= E2F_FLAG_RESTART_LATER;
+					if (pctx->errcode ==
+						    EXT2_ET_NO_CURRENT_NODE) {
+						pctx->errcode = 0;
+						break;
+					}
+					continue;
+				}
 				e2fsck_read_bitmaps(ctx);
 				pctx->errcode =
 					ext2fs_extent_delete(ehandle, 0);

