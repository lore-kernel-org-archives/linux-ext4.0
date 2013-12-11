From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 45/74] e2fsck: print cluster ranges when encountering bitmap
 errors
Date: Tue, 10 Dec 2013 17:23:20 -0800
Message-ID: <20131211012320.30655.87179.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26999 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3LKBX2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:23:28 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If pass5 finds bitmap errors in a range of clusters, don't print each
cluster number individually when we could print only the start and end
cluster number.  e2fsck already does this for the non-bigalloc case.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 6d7b968..04d8843 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -456,8 +456,8 @@ redo_counts:
 			save_problem = problem;
 		} else {
 			if ((problem == save_problem) &&
-			    (pctx.blk2 == i-1))
-				pctx.blk2++;
+			    (pctx.blk2 == i - EXT2FS_CLUSTER_RATIO(fs)))
+				pctx.blk2 += EXT2FS_CLUSTER_RATIO(fs);
 			else {
 				print_bitmap_problem(ctx, save_problem, &pctx);
 				pctx.blk = pctx.blk2 = i;

