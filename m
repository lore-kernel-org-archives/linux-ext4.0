From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/49] e2fsck: zero errcode when checking inline data blocks
Date: Mon, 10 Mar 2014 23:55:08 -0700
Message-ID: <20140311065508.30585.30041.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCKGzM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:12 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When checking inline data blocks, always zero pctx->errcode because
otherwise a previous error condition could leak through and "cause" a
fatal block iteration failure.  I found this by corrupting an xattr
block on an inline_data inode and fsck aborted when I tried to repair
it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 11b3dde..641b3fb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2158,8 +2158,10 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 static void check_blocks_inline_data(e2fsck_t ctx, struct problem_context *pctx,
 				     struct process_block_struct *pb)
 {
-	if (!pb->is_dir)
+	if (!pb->is_dir) {
+		pctx->errcode = 0;
 		return;
+	}
 
 	pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist, pb->ino, 0, 0);
 	if (pctx->errcode) {

