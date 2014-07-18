From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/24] e2fsck: report correct inode number in pass1b
Date: Fri, 18 Jul 2014 15:52:49 -0700
Message-ID: <20140718225249.31374.59654.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762724AbaGRWwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:54 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there's a problem with the inode scan during pass 1b, report the
inode that we were trying to examine when the error happened, not the
inode that just went through the checker.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1b.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index d7c5e55..b4041d1 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -301,6 +301,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
 		if (pctx.errcode) {
+			pctx.ino = ino;
 			fix_problem(ctx, PR_1B_ISCAN_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;

